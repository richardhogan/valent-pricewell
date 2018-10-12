package com.valent.pricewell

import java.util.Collection;

import grails.converters.JSON
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.text.DateFormat;
import java.util.Date;

import org.apache.shiro.SecurityUtils
import org.codehaus.groovy.grails.commons.ConfigurationHolder;


class OpportunityController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

	def generalStagingService
	def opportunityService
	def reviewService
	def salesCatalogService, fieldMappingService
	def quotationService
	def sendMailService, cwimportService, connectwiseCatalogService
	
	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}
		
    def index = {
        redirect(action: "list", params: params)
    }
	
	def createServiceTicket = {
		Opportunity opportunityInstance = Opportunity.get(params.id)
		cwimportService.showReportingApiFields(opportunityInstance)
		render "success"
	}
	
	def tmp = {
		//def data = Opportunity.findAll("FROM Opportunity op  WHERE op.geo.id = 4 AND op.dateCreated BETWEEN 'Tue Jun 26 00:00:00 IST 2012' AND 'Wed Jun 26 00:00:00 IST 2013' ORDER BY dateModified DESC")
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DAY_OF_MONTH, -365)
		Date from = cal.getTime();
		Date toDate = new Date();
		
		println from
		println toDate	
		
		def data = Opportunity.executeQuery("FROM Opportunity op  WHERE op.geo.id = ? AND op.dateCreated BETWEEN ? AND ?  ORDER BY dateModified DESC", [4L, from ,toDate])
		render(view: "list", model:[opportunityInstanceList: data, opportunityInstanceTotal: data.count()])
	}

    /*def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [opportunityInstanceList: Opportunity.list(params), opportunityInstanceTotal: Opportunity.count()]
    }*/
	
	def getAccountContacts = 
	{
		def account = Account.get(params.id)
		
		render(template: "/opportunity/accountContactList",  model: [contactList: account?.contacts])
	}
	
	public boolean isClass(String className)
	{
		boolean exist = false;
		
		for (Class grailsClass in grailsApplication.allClasses)
		{
			if(grailsClass.name == className)
			{
				exist = true;
				println grailsClass.name
			}
		}
		
		return exist;
	}
	
	def list = {
		/*def opportunityList = [];
		opportunityList = retrieveOpportunityList("pending",[:]);
		def user = User.get(new Long(SecurityUtils.subject.principal))
		
		List accountList = reviewService.findUserAccounts()
		
		if(session["opportunitylist-filter"]){
			[listType: 'pending', accountList: accountList, opportunityInstanceList: opportunityList, opportunityInstanceTotal: opportunityList?.size(), searchFields: session["opportunitylist-filter"], title: "My Pending Opportunities"]
		}
		else{
			[listType: 'pending', accountList: accountList, opportunityInstanceList: opportunityList, opportunityInstanceTotal: opportunityList?.size(), title: "My Pending Opportunities"]
		}*/
		
		if(params?.listType != "" && params?.listType != null)
		{
			def action = (params?.listType == "pending") ? "pendingOpportunity" : ((params?.listType == "won") ? "closedWonOpportunity" : "closedLostOpportunity")
			redirect(action: action, params: params)
		}
		else
		{
			redirect(action: "pendingOpportunity", params: params)
		}
		
	}
	
	def closedWonOpportunity = {
		def opportunityList = [];
		
		opportunityList = retrieveOpportunityList("closedWon", [:]);
		List accountList = reviewService.findUserAccounts()
		
		if(session["opportunitylist-filter"]){
			render(view: "list", model: [listType: 'won', accountList: accountList, opportunityInstanceList: opportunityList, opportunityInstanceTotal: opportunityList?.size(), searchFields: session["opportunitylist-filter"], title: "Won Opportunities"])
		}
		else{
			render(view: "list", model: [listType: 'won', accountList: accountList, opportunityInstanceList: opportunityList, opportunityInstanceTotal: opportunityList?.size(), title: "Won Opportunities"])
		}
	}
	def closedLostOpportunity = {
		def opportunityList = [];
		
		opportunityList = retrieveOpportunityList("closedLost", [:]);
		List accountList = reviewService.findUserAccounts()
		
		if(session["opportunitylist-filter"]){
			render(view: "list", model: [listType: 'lost', accountList: accountList, opportunityInstanceList: opportunityList, opportunityInstanceTotal: opportunityList?.size(), searchFields: session["opportunitylist-filter"], title: "Lost Opportunities"])
		}
		else{
			render(view: "list", model: [listType: 'lost', accountList: accountList, opportunityInstanceList: opportunityList, opportunityInstanceTotal: opportunityList?.size(), title: "Lost Opportunities"])
		}
	}
	def pendingOpportunity = {
		def opportunityList = [];
		
		opportunityList = retrieveOpportunityList("pending", [:]);
		List accountList = reviewService.findUserAccounts()
		
		if(session["opportunitylist-filter"]){
			render(view: "list", model: [listType: 'pending', accountList: accountList, opportunityInstanceList: opportunityList, opportunityInstanceTotal: opportunityList?.size(), searchFields: session["opportunitylist-filter"], title: "Pending Opportunities"])
		}
		else{
			render(view: "list", model: [listType: 'pending', accountList: accountList, opportunityInstanceList: opportunityList, opportunityInstanceTotal: opportunityList?.size(), title: "Pending Opportunities"])
		}
	}

	Collection retrieveOpportunityList(def type, Map dateMap)
	{
		def opportunityList = opportunityService.retrieveOpportunityList(type, dateMap)
		session["opportunitylist-original"] = opportunityList;
		session["opportunitylist-refresh"] = true;
	
		/*if(params.searchFields && params.searchFields.toString().length() > 0 ){
			Map map = Eval.me(params.searchFields);
			session["opportunitylist-filter"] =  map
		}*/
		
		/*if(searchFields && searchFields.size() > 0)
		{
			session["opportunitylist-filter"] = searchFields
		}*/
	
		if(session["opportunitylist-filter"]){
			opportunityList = applyFilter(opportunityList, session["opportunitylist-filter"]);
			
		}
	
		if(params.sort){
			def sortData = [sort: params.sort, order: params.order]
			session["opportunitylist-sortparams"] = sortData;
		}
	
		if(session["opportunitylist-sortparams"]){
			String propName = session["opportunitylist-sortparams"].sort;
			if(session["opportunitylist-sortparams"].order == 'desc'){
				opportunityList = opportunityList.sort{a1, a2 -> a2.getProperty(propName).toString().compareToIgnoreCase(a1.getProperty(propName).toString());}
			}
			else
			{
				opportunityList = opportunityList.sort{a1, a2 -> a1.getProperty(propName).toString().compareToIgnoreCase(a2.getProperty(propName).toString());}
			}
			
		}
		
		return opportunityList
	}

	Collection<Opportunity> applyFilter(Collection<Opportunity> listopportunity, Object searchFields){
		
		def filteredData = []
				
		for(Opportunity op: listopportunity){
			
			boolean flag = true;
			
			if(searchFields?.name  && searchFields?.accountId)
			{
				flag = flag && op.name?.toLowerCase().contains(searchFields?.name?.toLowerCase()) && (op?.account?.id == Long.parseLong(searchFields?.accountId))
			}
			else if(searchFields?.name)
			{
				flag = flag && op.name?.toLowerCase().contains(searchFields?.name?.toLowerCase())
			}
			else if(searchFields?.accountId)
			{
				flag = flag && (op?.account?.id == Long.parseLong(searchFields?.accountId))
			}
			
			if(flag){
				filteredData.add(op);
			}
		}
		
		return filteredData;
	}
	
	def search = {
		Map searchFields = buildOpportunitySearchMap(params.searchFields)
		
		if(searchFields && searchFields.size() > 0 && searchFields["name"].toString().length() > 0)
		{
			session["opportunitylist-filter"] = searchFields
		}
		else
		{
			//session["opportunitylist-filter"] = null
			session.removeAttribute("opportunitylist-filter");
		}
		
		redirect(action: "list", params: params)//, params: [searchQuery: searchQuery])//[searchFields: params.searchFields])
		
	}
	
	private Map buildOpportunitySearchMap(Object searchFields)
	{
		Map searchFieldsMap = new HashMap()
		
		if(searchFields?.name)
		{
			searchFieldsMap.put("name", searchFields?.name)
		}
		
		if(searchFields?.accountId)
		{
			searchFieldsMap.put("accountId", searchFields?.accountId)
		}
		return searchFieldsMap
	}

    def create = {
        def user = User.get(new Long(SecurityUtils.subject.principal))
		def territoryList = new ArrayList()
		territoryList = salesCatalogService.findUserTerritories(user)
		
		if(user?.primaryTerritory != null && user?.primaryTerritory != "null" && user?.primaryTerritory != "NULL" )
		{
			boolean checkPrimaryTerritory = salesCatalogService.checkListContainsPrimaryTerritory(territoryList, user?.primaryTerritory)
			if(checkPrimaryTerritory)
			{
				def opportunityInstance = new Opportunity()
		        opportunityInstance.properties = params
				//def salesUsers = []
				Set salesUsers = new HashSet()
				salesUsers = salesCatalogService.findSalesUsers()//reviewService.findSalesUsers()
				//println salesCatalogService.findSalesUsers()
				def accountList = []
				accountList = reviewService.findUserAccounts()
				
				
		        return [opportunityInstance: opportunityInstance, accountList: accountList, salesUsers: salesUsers.toList(), territoryList: territoryList]
			}
			else
			{
				render(view: "/userSetup/addTerritory", model: ["controller": "opportunity", territoryList: territoryList ])
			}
		}
		else
		{
			render(view: "/userSetup/addTerritory", model: ["controller": "opportunity", territoryList: territoryList])
		}
    }

	def addOpportunityFromAccount = {
		def opportunityInstance = new Opportunity()
		def user = User.get(new Long(SecurityUtils.subject.principal))
		opportunityInstance.properties = params
		def account = Account.get(params.accountId)
		//account?.contacts
		//def salesUsers = []
		Set salesUsers = new HashSet()
		salesUsers = salesCatalogService.findSalesUsers()
		
		def territoryList = salesCatalogService.findUserTerritories(user)
		if(!territoryList.contains(user.primaryTerritory))
		{
			territoryList.add(user.primaryTerritory)
		}
		render(template: "/opportunity/addOpportunity",  model: [salesUsers: salesUsers.toList(), opportunityInstance: opportunityInstance, contactList: account?.contacts, accountId: params.accountId, createdFrom: 'account', territoryList: territoryList])
	}
	
    def save = {
		
        def opportunityInstance = new Opportunity(params)
		def accountInstance = null
		def leadInstance = null
		def geoInstance = Geo.get(params.territoryId)
		String dateString = params.closeDate
		
		
		def dateFormat = geoInstance.dateFormat
		Date closeDate
		if(dateFormat != "" && dateFormat != null)
		{
			
			def newformat = dateFormat.replace("yy", "yyyy").replace("mm", "MM")
			
			try {
				
				DateFormat df = new SimpleDateFormat(newformat);
				closeDate =  df.parse(dateString);
				
			} catch (ParseException pe) {
				pe.printStackTrace();
			}
			
		}
		else
		{
			try {
				
				DateFormat df = new SimpleDateFormat("MM/dd/yyyy");
				closeDate =  df.parse(dateString);
				
			} catch (ParseException pe) {
				pe.printStackTrace();
			}
		}
		
		
		opportunityInstance.properties['name','amount','discount','probability'] = params
		opportunityInstance.geo = geoInstance
		opportunityInstance.closeDate = closeDate
		def user = User.get(new Long(SecurityUtils.subject.principal))
		opportunityInstance.createdBy = user
		opportunityInstance.assignTo = User.get(params.assignToId)
		if(params.accountIdFromLead != null)
		{
			accountInstance = Account.get(params.accountIdFromLead)
		}
		else
		{
			accountInstance = Account.get(params.accountId)
			opportunityInstance.primaryContact = Contact.get(params.contactId)
		}
		
		accountInstance.dateModified = new Date()
		accountInstance.save(flush:true)
		opportunityInstance.account = accountInstance
		
		opportunityInstance.stagingStatus = Staging.findByName('prospecting')
		if(params.probability == null)
		{
			opportunityInstance.probability = 10
		}
		
		opportunityInstance.dateCreated = new Date()
		opportunityInstance.dateModified = new Date()
		
		if(params.createdFrom == "lead")
		{
			leadInstance = Lead.get(params.leadId)
			opportunityInstance.primaryContact = leadInstance.contact
		}
		
		def map = [:]
        if (opportunityInstance.save(flush: true)) 
		{
			if(opportunityInstance.createdBy.id != opportunityInstance.assignTo.id)
			{
				map = new NotificationGenerator(g).sendAssignedToNotification(opportunityInstance, "Opportunity")
				sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/opportunity/show/"+opportunityInstance.id)
			}
			
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'opportunity.label', default: 'Opportunity'), opportunityInstance.name])}"
			session["opportunitylist-refresh"] = false;
			
			if(params.createdFrom == "account")
			{
				redirect(action: "show", controller: "account", id: params.accountId)
			}
			else if(params.createdFrom == "lead")
			{
				generalStagingService.changeStaging(leadInstance, Staging.findByName('converted'), "Created by ${user}", GeneralStagingLog.StagingLogObjectType.LEAD)
				flash.message = "Stage changed successfully."
				redirect(action: "show", controller: "lead", id: leadInstance.id)
			}
			else
			{
				redirect(action: "list")
			}
			//redirect(action: "show", id: opportunityInstance.id)
        }
        else {
			def salesUsers = []
			salesUsers = reviewService.findSalesUsers()
            render(view: "create", model: [opportunityInstance: opportunityInstance, salesUsers: salesUsers])
        }
    }
	
	def showStage = {
		
		String source = params.source
		
		def user = User.get(new Long(SecurityUtils.subject.principal))
		
		def opportunityInstance = Opportunity.get(params.id)
		
		int stepNumber = (params.step_number && params.step_number.toInteger() > 0?params.step_number.toInteger(): 1);
		
		String stepName = ServiceStageFlow.findOpportunityStepName(source, stepNumber);
		 
		List stagingInstanceList = Staging.listOpportunityStages ("NEW_STAGE")
		if(stepName == "show")
		{
			Staging nextStage = null
			nextStage = Staging.findBySequenceOrder(opportunityInstance.stagingStatus.sequenceOrder.toInteger() + 1)
			
			 
			render(template: "stage/show", model: [opportunityInstance: opportunityInstance, stagingInstanceList: stagingInstanceList, nextStage: nextStage]);
			return;
		}
		
	}
	
	def changeStage =
	{
		def probability = 0
		Staging nextStage = null
		Staging newStage = null
		Opportunity opportunityInstance = Opportunity.get(params.id)
		if(params.source == "previousStage")
		{
			
			int i = 1;
			newStage = Staging.findBySequenceOrder(opportunityInstance.stagingStatus.sequenceOrder.toInteger() - 1)
			while(newStage != null && newStage.isActive != true)
			{
				i++;
				newStage = Staging.findBySequenceOrder(opportunityInstance.stagingStatus.sequenceOrder.toInteger() - i)
				
			}
		}
		else if(params.source == "closedWon")
		{
			newStage = Staging.findByName("closedWon")
		}
		else if(params.source == "closedLost")
		{
			newStage = Staging.findByName("closedLost")
			for(Quotation qu in opportunityInstance.quotations)
			{
				if(qu.status.sequenceOrder != -1 && qu.status.sequenceOrder != 5)
				{
					qu.status = Staging.findByName("rejected")
				}
				if(qu.contractStatus.sequenceOrder != -1 && qu.contractStatus.sequenceOrder != 5)
				{
					qu.contractStatus = Staging.findByName("rejected")
				}
				qu.save()
			}
		}
		else
		{
			int i = 1;
			newStage = Staging.findBySequenceOrder(opportunityInstance.stagingStatus.sequenceOrder.toInteger() + 1)
			while(newStage != null && newStage.isActive != true)
			{
				i++;
				newStage = Staging.findBySequenceOrder(opportunityInstance.stagingStatus.sequenceOrder.toInteger() + i)
			}
		}
		
		def user = User.get(new Long(SecurityUtils.subject.principal))
		if (!opportunityInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'opportunity.label', default: 'Opportunity'), params.id])}"
			redirect(action: "list")
		}
		else
		{ 
			boolean check = false
			if(newStage.name == "closedWon")
			{
				for(Quotation qu : opportunityInstance?.quotations)
				{
					if(qu?.status?.name == "Accepted" && qu?.contractStatus?.name == "Accepted")
					{
						check = true
					}
				}
			}
			else
			{
				check = true
			}
			if(check == true)
			{
				if(newStage.name == "qualification")
				{
					probability = 10
				}
				else if(newStage.name == "needAnalysis")
				{
					probability = 20
				}
				else if(newStage.name == "valueProposition")
				{
					probability = 50
				}
				else if(newStage.name == "decisionMakers")
				{
					probability = 60
				}
				else if(newStage.name == "preceptionAnalysis")
				{
					probability = 70
				}
				else if(newStage.name == "proposalPriceQuote")
				{
					probability = 75
				}
				else if(newStage.name == "negotiationReview")
				{
					probability = 90
				}
				else if(newStage.name == "closedWon")
				{
					probability = 100
				}
				
				if(newStage.name == "closedLost")
				{
					opportunityInstance.probability = 0
				}
				else if(opportunityInstance.probability < probability)
				{
					opportunityInstance.probability = probability
				}
				generalStagingService.changeStaging(opportunityInstance, Staging.findByName(newStage.name), "Created by ${user}", GeneralStagingLog.StagingLogObjectType.OPPORTUNITY)
				flash.message = "${message(code: 'stageChange.message.flash', args: ['Opportunity', newStage.displayName])}"
				
			}
			else
			{
				flash.message = "${message(code: 'opportunity.stageChangeToWon.message.flash')}"
			}
			redirect(action: "show", id: opportunityInstance.id)
		}
	}
	
    def show = {
        def opportunityInstance = Opportunity.get(params.id)
		def loginUserId =  User.get(new Long(SecurityUtils.subject.principal))
		
		boolean showOpportunity = false
		
		if(params.notificationId)
		{
			def note = Notification.get(params.notificationId)
			note.active = false
			note.save(flush:true)
		}
        if (!opportunityInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'opportunities.label', default: 'Opportunity'), params.id])}"
            redirect(action: "list")
        }
        else {
			if(opportunityInstance?.geo?.id == null && opportunityInstance?.externalSource != "salesforceImport")
			{
				if(opportunityInstance?.externalId != null && opportunityInstance?.externalId != "")
				{
					def connectwiseTerritory = cwimportService.getTerritoryOfImportedOpportunity(opportunityInstance)
					
					if(fieldMappingService.isMappingAvailable(connectwiseTerritory, FieldMapping.MappingType.TERRITORY))
					{
						String territory =  fieldMappingService.getFieldMappingValue(connectwiseTerritory, FieldMapping.MappingType.TERRITORY)
						
						opportunityInstance.geo = Geo.findByName(territory)
						opportunityInstance.save()
						showOpportunity = true
						//redirect(action: "show", id: opportunityInstance.id)
					}
					else redirect(action: "mapTerritory", id: opportunityInstance.id)
				}
				else redirect(action: "addTerritory", id: opportunityInstance.id)
			}
			else if((opportunityInstance?.geo?.id == null || opportunityInstance?.primaryContact?.id == null) && opportunityInstance?.externalSource == "salesforceImport")
			{
				redirect(action: "addSalesforceTerritoryAndContact", id: opportunityInstance.id)
			}
			else
			{
				showOpportunity = true
			}
			
			if(showOpportunity)
			{
				
				List stagingInstanceList = Staging.listOpportunityStages ("NEW_STAGE")
				
				Staging nextStage = null
				nextStage = Staging.findBySequenceOrder(opportunityInstance.stagingStatus.sequenceOrder.toInteger() + 1)
				
				Quotation quotationInstance = null
				String quoteAvailable = 'false'
				String filePath = ""
				if(params.quoteId != "" && params.quoteId != null)
				{
					quotationInstance = Quotation.get(params.quoteId)
					filePath = params.filePath
					quoteAvailable = 'true'
				}
				
				render(view: "main", model: [filePath: filePath, quoteAvailable: quoteAvailable, quotationInstance: quotationInstance, opportunityInstance: opportunityInstance, stagingInstanceList: stagingInstanceList, nextStage: nextStage, loginUserId: loginUserId]);
			}            
        }
    }

	def addSalesforceTerritoryAndContact = 
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def opportunityInstance = Opportunity.get(params.id)
		def territoryList = new ArrayList()
		territoryList = salesCatalogService.findUserTerritories(user)
		
		render(view: "addSalesforceTerritoryAndContact", model: [opportunityInstance: opportunityInstance, territoryList: territoryList]);
	}
	
	def mapTerritory = {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def opportunityInstance = Opportunity.get(params.id)
		def territoryList = new ArrayList()
		territoryList = salesCatalogService.findUserTerritories(user)
		
		def connectwiseTerritory = cwimportService.getTerritoryOfImportedOpportunity(opportunityInstance)
		
		/*if(fieldMappingService.isMappingAvailable(connectwiseTerritory, FieldMapping.MappingType.TERRITORY))
		{
			String territory =  fieldMappingService.getFieldMappingValue(connectwiseTerritory, FieldMapping.MappingType.TERRITORY)
			
			if(opportunityInstance?.geo?.id == null)
			{
				opportunityInstance.geo = Geo.findByName(territory)
				opportunityInstance.save()
				redirect(action: "show", id: opportunityInstance.id)
			}
			redirect(action: "show", id: opportunityInstance.id)
		}*/
		render(view: "mapTerritory", model: [opportunityInstance: opportunityInstance, territoryList: territoryList, connectwiseTerritory: connectwiseTerritory]);
	}
	
	def saveTerritoryMapping = {
		Opportunity opportunityInstance =	 Opportunity.get(params.id)
		def result = "fail"
		if(opportunityInstance)
		{
			Geo territory = null
			if(params.mapValue == "doMapping")
			{
				territory = Geo.get(params.territoryId.toLong())
				
				if(params.connectwiseTerritory != "No Territory Specified")
				{
					fieldMappingService.addFieldMapping(params.connectwiseTerritory, territory?.name, FieldMapping.MappingType.TERRITORY)
				}
			}
			else
			{
				territory = connectwiseCatalogService.getTerritory(params.connectwiseTerritory)
			}
			
			if(territory != null)
			{
				opportunityInstance.geo = territory
				
				User assignedUser = salesCatalogService.getSalesUserOfGeo(opportunityInstance.geo)
				log.info "[Log Time: ${new Date()}] - Found sales user of territory ${opportunityInstance.geo?.getName()} is ${assignedUser}"
				opportunityInstance.assignTo = assignedUser
				
				opportunityInstance.save()
				result = "success"
			}
			
		}
		
		render result
	}
	
	def createNote = {
		
	   def opportunityInstance = Opportunity.get(params.opportunityId)
	   def comment  = params.comment
	   
	   if(comment != null && comment.trim() != "")
	   {
	   opportunityService.createNotes(params.opportunityId, comment)
	   Map data = [:]
	   data["result"] = "success"
	   data["msg"] = "added"
	   render data as JSON
	   }
	   else
	   {
		   Map data = [:]
		   data["result"] = "fail"
		   data["msg"] = "enter data"
		   render data as JSON
	   }
		
	}
	
	def refreshNotes = {
		def opp = Opportunity.get(params.opportunityId);
		
		def loginUserId =  User.get(new Long(SecurityUtils.subject.principal))

		render(template: "notesList", model: [opportunityInstance: opp , loginUserId : loginUserId])
	}
	
	
	def deleteNote = {
		
		def res = opportunityService.deleteNote(params.noteId)
		
		if(res)
		{
		
		Map data = [:]
		data["result"] = "success"
		data["msg"] = "deleted"
		render data as JSON
		}
		else
		{
			Map data = [:]
			data["result"] = "fail"
			render data as JSON
		}
	}
	
	def editNote = {
		
		def res = opportunityService.editNote(params.noteId, params.comment)
		
		if(res)
		{
		
		Map data = [:]
		data["result"] = "success"
		data["msg"] = "edited"
		render data as JSON
		}
		else
		{
			Map data = [:]
			data["result"] = "fail"
			render data as JSON
		}
	}
	
	def addTerritory = {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def opportunityInstance = Opportunity.get(params.id)
		def territoryList = new ArrayList()
		territoryList = salesCatalogService.findUserTerritories(user)
		
		render(view: "addTerritory", model: [opportunityInstance: opportunityInstance, territoryList: territoryList]);
	}
	
	def saveTerritory = {
		def opportunityInstance = Opportunity.get(params.id)
		def territory = Geo.get(params.territoryId)
		
		opportunityInstance.geo = territory
		
		if(params.sourceFrom == "salesforceImport")
		{
			Contact primaryContact = Contact.get(params.primaryContactId)
			if(primaryContact)
			{
				opportunityInstance.primaryContact = primaryContact
			}
		}
		opportunityInstance.save()
		redirect(action: "show", id: opportunityInstance.id)
	}
	
	def getFormatedDate = 
	{
		def opportunityInstance = Opportunity.get(params.id)
		
		def dateFormat = opportunityInstance?.geo?.dateFormat
		def closeDate = ""
		if(dateFormat != "" && dateFormat != null)
		{
			
			def newformat = dateFormat.replace("yy", "yyyy").replace("mm", "MM")
			
			try {
				
				DateFormat df = new SimpleDateFormat(newformat);
				println opportunityInstance.closeDate
				closeDate = df.format(opportunityInstance.closeDate)
				
			} catch (ParseException pe) {
				pe.printStackTrace();
			}
			
		}
		else
		{
			try {
				
				DateFormat df = new SimpleDateFormat("MM/dd/yyyy");
				closeDate = df.format(opportunityInstance.closeDate)
				
				
			} catch (ParseException pe) {
				pe.printStackTrace();
			}
		}
		render closeDate
	}
	
    def edit = {
        def opportunityInstance = Opportunity.get(params.id)
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def territoryList = salesCatalogService.findUserTerritories(opportunityInstance?.assignTo)
		
		def dateFormat = opportunityInstance?.geo?.dateFormat
		def closeDate = ""
		if(dateFormat != "" && dateFormat != null)
		{
			
			def newformat = dateFormat.replace("yy", "yyyy").replace("mm", "MM")
			
			try {
				
				DateFormat df = new SimpleDateFormat(newformat);
				println opportunityInstance.closeDate
				closeDate = df.format(opportunityInstance.closeDate)
				
			} catch (ParseException pe) {
				pe.printStackTrace();
			}
			
		}
		else
		{
			try {
				
				DateFormat df = new SimpleDateFormat("MM/dd/yyyy");
				println opportunityInstance.closeDate
				closeDate = df.format(opportunityInstance.closeDate)
				
				
			} catch (ParseException pe) {
				pe.printStackTrace();
			}
		}
		
        if (!opportunityInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'opportunities.label', default: 'Opportunity'), params.id])}"
            redirect(action: "list")
        }
        else {
			//def salesUsers = []
			Set salesUsers = new HashSet()
			salesUsers = salesCatalogService.findSalesUsers()
			render(template: "/opportunity/edit",  model: [opportunityInstance: opportunityInstance, closeDate: closeDate, salesUsers: salesUsers.toList(), territoryList: territoryList])
			//[opportunityInstance: opportunityInstance, closeDate: closeDate, salesUsers: salesUsers.toList(), territoryList: territoryList]
        }
    }

    def update = {
        def opportunityInstance = Opportunity.get(params.id)
		def salesUsers = []
		salesUsers = reviewService.findSalesUsers()
        if (opportunityInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (opportunityInstance.version > version) {
                    
                    opportunityInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'opportunities.label', default: 'Opportunity')] as Object[], "Another user has updated this Opportunities while you were editing")
                    render(view: "edit", model: [opportunityInstance: opportunityInstance, salesUsers: salesUsers])
                    return
                }
            }
			def previousAssignToId = opportunityInstance.assignTo.id
	        opportunityInstance.properties['name','probability','amount','discount'] = params
			def user = User.get(new Long(SecurityUtils.subject.principal))
			opportunityInstance.assignTo = User.get(params.assignToId)
			
			def geoInstance = Geo.get(params.territoryId)
			String dateString = params.closeDate
			
			
			def dateFormat = geoInstance.dateFormat
			Date closeDate
			if(dateFormat != "" && dateFormat != null)
			{
				
				def newformat = dateFormat.replace("yy", "yyyy").replace("mm", "MM")
				
				try {
					
					DateFormat df = new SimpleDateFormat(newformat);
					closeDate =  df.parse(dateString);
					
				} catch (ParseException pe) {
					pe.printStackTrace();
				}
				
			}
			else
			{
				try {
					
					DateFormat df = new SimpleDateFormat("MM/dd/yyyy");
					closeDate =  df.parse(dateString);
					
				} catch (ParseException pe) {
					pe.printStackTrace();
				}
			}
			
			
			opportunityInstance.modifiedBy = user
			opportunityInstance.dateModified = new Date()
			opportunityInstance.geo = geoInstance
			opportunityInstance.closeDate = closeDate
			
			for(Quotation quote : opportunityInstance?.quotations)
			{
				quote?.geo = geoInstance
				quote.save()
			}
				
			def map = [:]
            if (!opportunityInstance.hasErrors() && opportunityInstance.save(flush: true)) 
			{
				if(previousAssignToId != opportunityInstance.assignTo.id && opportunityInstance.createdBy.id != opportunityInstance.assignTo.id)
				{
					map = new NotificationGenerator(g).sendAssignedToNotification(opportunityInstance, "Opportunity")
					sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/opportunity/show/"+opportunityInstance.id)
					
					map = [:]
					map = new NotificationGenerator(g).changeAssignedToNotification(opportunityInstance, User.get(previousAssignToId), "Opportunity")
					sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/opportunity/show/"+opportunityInstance.id)
				}
				
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'opportunities.label', default: 'Opportunity'), opportunityInstance.name])}"
                redirect(action: "show", id: opportunityInstance.id)
            }
            else {
                render(view: "edit", model: [opportunityInstance: opportunityInstance, salesUsers: salesUsers])
            }
        }
        else {
			session["opportunitylist-refresh"] = false;
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'opportunities.label', default: 'Opportunity'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
		def opportunityInstance = Opportunity.get(params.id)
		def name = opportunityInstance.name
        if (opportunityInstance) {
            try {
                opportunityInstance.delete(flush: true)
				session["opportunitylist-refresh"] = false;
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'opportunities.label', default: 'Opportunity'), name])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'opportunities.label', default: 'Opportunity'), name])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'opportunities.label', default: 'Opportunity'), name])}"
            redirect(action: "list")
        }
    }
}
