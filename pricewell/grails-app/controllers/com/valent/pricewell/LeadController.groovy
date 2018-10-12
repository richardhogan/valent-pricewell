package com.valent.pricewell
import java.util.Map;

import grails.converters.JSON

import org.apache.shiro.SecurityUtils
import org.joda.time.*;
import org.joda.*;

class LeadController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

	def generalStagingService
	def phoneNumberService
	def salesCatalogService
	def leadService
	def reviewService
	def sendMailService
    def index = {
        redirect(action: "list", params: params)
    }

	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}
	
    def list = {
		//Method used to cache, refresh cache and search on cache collection and sort filtered data..
		//1) Flag to tell whether refresh cache or not. session["leadlist-refresh"]
		//2) If refresh flag is set then retrieve from database all data for login user and save in cache, session["leadlist-original"]
		//3) If filter is applied then cache filter data into session data, session["leadlist-filter"] 
		//4) If sort data is applied then save into session cache session["leadlist-sortparams"]
		def leadList = [];
		//2)
		/*if(session["leadlist-refresh"]){
			leadList = session["leadlist-original"]
		} 
		else{*/
			leadList = retrieveLeadList();
			def tmpList = []
			def unAssignedList = [], assignedList = []
			//def tmpList2 = []
			//def tmpList3 = []
			tmpList = leadList; leadList = []
			def user = User.get(new Long(SecurityUtils.subject.principal))
			if(SecurityUtils.subject.hasRole("SALES PERSON"))
			{
				for(Lead l in tmpList)
				{
					if(l?.stagingStatus?.name != 'converted')
					{
						if(l?.assignTo?.id == user?.id)
						{
							assignedList.add(l)
						}
						else{
							unAssignedList.add(l)
						}
					}
				}
				leadList = assignedList
			}
			else
			{
				for(Lead l in tmpList)
				{
					if(l?.stagingStatus?.name != 'converted')
					{
						leadList.add(l)
					}
				}
			
			}
			
			
			session["leadlist-original"] = leadList;
			session["leadlist-refresh"] = true;
		//}
		
		/*println leadList
		println unAssignedList
		//3
		if(params.searchFields && params.searchFields.toString().length() > 0 ){
			Map map = Eval.me(params.searchFields);
			session["leadlist-filter"] =  map
		}*/
		
		
		if(session["leadlist-filter"]){
			leadList = applyFilter(leadList, session["leadlist-filter"]);
			
		}
		
		
		//4)
		if(params.sort){
			def sortData = [sort: params.sort, order: params.order]
			session["leadlist-sortparams"] = sortData;
		}
		
		if(session["leadlist-sortparams"]){
			//println leadList[0].getProperty(session["leadlist-sortparams"].sort)
			String propName = session["leadlist-sortparams"].sort;
			if(session["leadlist-sortparams"].order == 'desc'){
				leadList = leadList.sort{a1, a2 -> a2.getProperty(propName).toString().compareToIgnoreCase(a1.getProperty(propName).toString());}
			}
			else
			{
				leadList = leadList.sort{a1, a2 -> a1.getProperty(propName).toString().compareToIgnoreCase(a2.getProperty(propName).toString());}
			}
			
		}
		
		def leadInstanceTotal
		
		if(leadList != null)
		{
			leadInstanceTotal = leadList?.size()
		}
		else
		{
			leadInstanceTotal = 0
		}
		
		if(session["leadlist-filter"]){
			[leadInstanceList: leadList, leadInstanceTotal: leadInstanceTotal, unAssignedList: unAssignedList, searchFields: session["leadlist-filter"], title: "Pending Leads"]
		}
		else{
			[leadInstanceList: leadList, leadInstanceTotal: leadInstanceTotal, unAssignedList: unAssignedList, title: "Pending Leads"]
		}
        
    }
	
	def pending = {
		redirect(action: "list")
	}
	
	def converted = {
		def leadList = []
		leadList = Lead.findAll("FROM Lead l WHERE l.stagingStatus.name = 'converted'")
		
		render(view: "list", model: [leadInstanceList: leadList, leadInstanceTotal: leadList?.size(), title: "Converted Leads"])
	}
	Collection retrieveLeadList(){
		def accountList = Account.findAll("FROM Account ac")
		def leadList = []
		def user = User.get(new Long(SecurityUtils.subject.principal))
		
		FilterCriteria filterCriteria = new FilterCriteria()
		
		leadList = leadService.getUserLeads(user, filterCriteria)
		
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
				def leadInstance = new Lead()
				leadInstance.properties = params
				Set salesUsers = new HashSet()
				//def salesUsers = []
				salesUsers = salesCatalogService.findSalesUsers()//reviewService.findSalesUsers()
				//println salesUsers
				List stagingInstanceList = Staging.listLeadStages ("NEW_STAGE")
				return [leadInstance: leadInstance, stagingInstanceList: stagingInstanceList, salesUsers: salesUsers.toList()]
			}
			else
			{
				render(view: "/userSetup/addTerritory", model: ["controller": "lead", territoryList: territoryList ])
			}
		}
        else
		{
			
			render(view: "/userSetup/addTerritory", model: ["controller": "lead", territoryList: territoryList ])
		}
    }
	
	Collection<Lead> applyFilter(Collection<Lead> listlead, Object searchFields){
		
		def filteredData = []
				
		for(Lead l: listlead){	
			
			boolean flag = true;
			
			if(searchFields?.firstname  )
			{
				flag = flag && l.firstname?.toLowerCase().contains(searchFields?.firstname?.toLowerCase());
			}
			
			if(flag && searchFields?.lastname)
			{
				flag = flag && l.lastname?.toLowerCase().contains(searchFields?.lastname?.toLowerCase());
			}
			
			if(flag && searchFields?.email)
			{
				flag = flag && l.email?.toLowerCase().contains(searchFields?.email?.toLowerCase());
			}
	
			if(flag && searchFields?.phone)
			{
				flag = flag && l.phone?.toLowerCase().contains(searchFields?.phone?.toLowerCase());
			}
			
			if(flag && searchFields?.daysPending &&  searchFields?.daysPending != "0"){
				int val = Integer.parseInt(searchFields?.daysPending);				
				int days = Days.daysBetween(new DateTime(new Date()), new DateTime(l.dateCreated)).getDays();
				println days
				if(val > 0){
					flag = flag && (days > val)
				}
				else{
					val = val * -1;
					flag = flag && (days <= val)
				}
			}
			
			if(flag){
				filteredData.add(l);
			}
		}
		
		return filteredData;
	}
	
	String buildLeadSearchQuery(Object searchFields)
	{
		String queryString = "from Lead ld "
		
		boolean isFirst = true
		
		List tags = null
		if(searchFields?.firstname)
		{
			for(String searchword: searchFields.firstname.split(" "))
			{
				if(isFirst)
				{
					queryString += " WHERE "
					isFirst = false
				}
				else
				{
					queryString += " OR "
				}
				
				queryString += " (ld.firstname LIKE '${searchword}%' OR ld.firstname LIKE '%${searchword}' OR ld.firstname LIKE '%${searchword}%' OR ld.firstname = '${searchword}') "
				
			}
		}
		
		if(searchFields?.lastname)
		{
			for(String searchword: searchFields.lastname.split(" "))
			{
				if(isFirst)
				{
					queryString += " WHERE "
					isFirst = false
				}
				else
				{
					queryString += " OR "
				}
				
				queryString += " (ld.lastname LIKE '${searchword}%' OR ld.lastname LIKE '%${searchword}' OR ld.lastname LIKE '%${searchword}%' OR ld.lastname = '${searchword}') "
				
			}
		}
		
		if(searchFields?.email)
		{
			if(isFirst)
			{
				queryString += " WHERE ld.email = ${searchFields.email}"
				isFirst = false
			}
			else
			{
				queryString += " AND ld.email = ${searchFields.email}"
			}
		}

		if(searchFields?.phone)
		{
			if(isFirst)
			{
				queryString += " WHERE ld.phone = ${searchFields.phone}"
				isFirst = false
			}
			else
			{
				queryString += " AND ld.phone = ${searchFields.phone}"
			}
		}
		return queryString
	}
	
	def search = {
		//String queryString =  buildLeadSearchQuery(params.searchFields)
		//def leadList = Lead.findAll(queryString)
		
		//render(view:"list",
			//model: [leadInstanceList: leadList, leadInstanceTotal: leadList.size(), searchFields: params.searchFields])
		//println params.searchFields
		
		
		Map searchFields = buildLeadSearchMap(params.searchFields)
		
		if(searchFields["hasSearchValueDefined"])
		{
			session["leadlist-filter"] = searchFields
		}
		else
		{
			session.removeAttribute("leadlist-filter");
		}
		
		redirect(action: "list")//, params: [searchFields: params.searchFields])
		
	}
	
	private Map buildLeadSearchMap(Object searchFields)
	{
		Map searchFieldsMap = new HashMap()
		boolean hasSearchValueDefined = false
		
		if(searchFields?.firstname != "" )
		{
			searchFieldsMap.put("firstname", searchFields?.firstname)
			hasSearchValueDefined = true
		}
		
		if(searchFields?.lastname != "")
		{
			searchFieldsMap.put("lastname", searchFields?.lastname)
			hasSearchValueDefined = true
		}
		
		if(searchFields?.email != "")
		{
			searchFieldsMap.put("email", searchFields?.email)
			hasSearchValueDefined = true
		}

		if(searchFields?.phone != "")
		{
			searchFieldsMap.put("phone", searchFields?.phone)
			hasSearchValueDefined = true
		}
		
		if(searchFields?.daysPending &&  searchFields?.daysPending != "0")
		{
			searchFieldsMap.put("daysPending", searchFields?.daysPending)
			hasSearchValueDefined = true
		}
		
		searchFieldsMap.put("hasSearchValueDefined", hasSearchValueDefined)
		
		return searchFieldsMap
	}

    def save = {
				def res = "fail"
				boolean i = false
				def mobile = null
				def phone = phoneNumberService.getValidatedPhonenumber(params.phone, params.billCountry)
				if(phone == "Invalid")
				{
					res = "invalidPhone"
					render res
				}
				else
				{
					params.phone = phone
					
					if(params.mobile != "")
					{
						mobile = phoneNumberService.getValidatedPhonenumber(params.mobile, params.billCountry)
						if(mobile == "Invalid")
						{
							res = "invalidMobile"
							render res
							return
						}
						else
						{
							params.mobile = mobile
							i = createContact(params)
						}
					}
					else
					{
						i = createContact(params)
					}
					
					if(i == true)
					{
						res = "success"
						render res
					}
					else
					{
						render res
					}
				 }

            }

	public boolean createContact(Object params)
	{
		
		def leadInstance = new Lead()
		leadInstance.properties['firstname', 'lastname', 'title', 'company', 'status', 'email', 'phone', 'mobile','altEmail', 'address', 'iso', 'format'] = params
		def user = User.get(new Long(SecurityUtils.subject.principal))
		leadInstance.createdBy = user
		leadInstance.modifiedBy = user
		leadInstance.assignTo = User.get(params.assignToId)
		leadInstance.dateCreated = new Date()
		leadInstance.dateModified = new Date()
		//leadInstance.assignTo = params.assignTo
		def billingAddress = new BillingAddress()
		billingAddress.properties["billAddressLine1", "billAddressLine2", "billCity", "billState", "billPostalcode", "billCountry"] =params
		
		leadInstance.billingAddress = billingAddress
		leadInstance.stagingStatus = Staging.findByName('uncontacted')
		
		def map = [:]
		if (billingAddress.save() && leadInstance.save(flush: true)) 
		{
			if(leadInstance.createdBy.id != leadInstance.assignTo.id)
			{
				map = new NotificationGenerator(g).sendAssignedToNotification(leadInstance, "Lead")
				sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/lead/show/"+leadInstance.id)
			}
			
			session["leadlist-refresh"] = false;
			flash.message = "${message(code: 'default.created.message', args: [message(code: 'lead.label', default: 'Lead'), leadInstance.id])}"
			//redirect(action: "list", id: leadInstance.id)
			return true
		}
		else {
			//def salesUsers = []
			//salesUsers = reviewService.findSalesUsers()
			//render(view: "create", model: [leadInstance: leadInstance, salesUsers: salesUsers])
			return false
		}

	}
	
	def showStage = {
		
		String source = params.source
		
		def user = User.get(new Long(SecurityUtils.subject.principal))
		
		def leadInstance = Lead.get(params.id)
		
		int stepNumber = (params.step_number && params.step_number.toInteger() > 0?params.step_number.toInteger(): 1);
		
		String stepName = ServiceStageFlow.findLeadStepName(source, stepNumber);
		
		List stagingInstanceList = Staging.listLeadStages ("NEW_STAGE")
		if(stepName == "show")
		{
			
			render(template: "stage/show", model: [leadInstance: leadInstance, stagingInstanceList: stagingInstanceList]);
			return;
		}
		switch(source)
		{
			case "converttoopportunity":
						
				//params.currentStep = params.step_number.toInteger();
				def accountList = [], salesUsers = []
				accountList = reviewService.findUserAccounts()
				salesUsers = reviewService.findSalesUsers()
				
				if(stepName.equals("addaccount"))
				{
					if(leadInstance?.contact != null)
					{
						render(template:"/contact/show", model:[contactInstance: leadInstance?.contact])
					}
					else
					{
						def accountInstance = new Account()
						render(template: "stage/converted-addAccount", model: [leadInstance: leadInstance, accountInstance: accountInstance, accountList: accountList, salesUsers: salesUsers])
					}
					
				}
				
				if(stepName.equals("createopportunity"))
				{
					def territoryList = salesCatalogService.findUserTerritories(user)
					if(user?.primaryTerritory != null && user?.primaryTerritory != "null" && user?.primaryTerritory != "NULL")
					{
						if(!territoryList.contains(user?.primaryTerritory))
						{
							territoryList.add(user?.primaryTerritory)
						}
					}
					render(template: "/opportunity/addOpportunity", model: [leadInstance: leadInstance,  territoryList: territoryList, createdFrom: 'lead', accountList: accountList, salesUsers: salesUsers])
				}
				break;
		}
	}
	
	def changeStage = 
	{
		def leadInstance = Lead.get(params.id)
		Staging newStage = null
		def user = User.get(new Long(SecurityUtils.subject.principal))
		if (!leadInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'lead.label', default: 'Lead'), params.id])}"
			redirect(action: "list")
		}
		else 
		{
			if(params.source == "nextStage")
			{
				newStage = Staging.findBySequenceOrder(leadInstance.stagingStatus.sequenceOrder.toInteger() + 1)
			}
			else if(params.source == "dead")
			{
				generalStagingService.changeStaging(leadInstance, Staging.findByName('dead'), "Created by ${user}", GeneralStagingLog.StagingLogObjectType.LEAD)
			}
			
			if(newStage != null)
			{
				if(newStage.name == "contactinprogress")
				{
					generalStagingService.changeStaging(leadInstance, Staging.findByName('contactinprogress'), "Created by ${user}", GeneralStagingLog.StagingLogObjectType.LEAD)
				}
				else if(newStage.name == "converttoopportunity")
				{
					generalStagingService.changeStaging(leadInstance, Staging.findByName('converttoopportunity'), "Created by ${user}", GeneralStagingLog.StagingLogObjectType.LEAD)
				}
			}
			flash.message = "${message(code: 'stageChange.message.flash', args: ['Lead', newStage.displayName])}"
			redirect(action: "show", id: leadInstance.id)
		}
	}
	
    def show = {
        def leadInstance = Lead.get(params.id)
		if(params.notificationId)
		{
			def note = Notification.get(params.notificationId)
			note.active = false
			note.save(flush:true)
		}
        if (!leadInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'lead.label', default: 'Lead'), params.id])}"
            redirect(action: "list")
        }
        else {
			List stagingInstanceList = Staging.listLeadStages ("NEW_STAGE")
			
            render(view: "main", model: [leadInstance: leadInstance, stagingInstanceList: stagingInstanceList, accountId: params.accountId, updatePermission: isUpdated(leadInstance)]);
        }
    }

    def edit = {
        def leadInstance = Lead.get(params.id)
        if (!leadInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'lead.label', default: 'Lead'), params.id])}"
            redirect(action: "list")
        }
        else {
			//println params
			Set salesUsers = new HashSet()
			//def salesUsers = []
			salesUsers = salesCatalogService.findSalesUsers()
            render(template: "/lead/edit",  model: [leadInstance: leadInstance, salesUsers: salesUsers.toList(), updatePermission: isUpdated(leadInstance)])
        }
    }

    def update = {
		
				def res = "fail"
				boolean i = false
				def mobile = null
				def phone = phoneNumberService.getValidatedPhonenumber(params.phone, params.billCountry)
				if(phone == "Invalid")
				{
					res = "invalidPhone"
					render res
				}
				else
				{
					params.phone = phone
					
					if(params.mobile != "")
					{
						mobile = phoneNumberService.getValidatedPhonenumber(params.mobile, params.billCountry)
						if(mobile == "Invalid")
						{
							res = "invalidMobile"
							render res
							return
						}
						else
						{
							params.mobile = mobile
							i = updateLead(params)
						}
					}
					else
					{
						i = updateLead(params)
					}
					
					if(i == true)
					{
						res = "success"
						render res
					}
					else
					{
						render res
					}
				 }
    }

	
	public boolean updateLead(Object params)
	{
		
		def leadInstance = Lead.get(params.id)
		def salesUsers = []
		salesUsers = reviewService.findSalesUsers()
		
		if (leadInstance) {
			if (params.version) {
				def version = params.version.toLong()
				if (leadInstance.version > version) {
					
					leadInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'lead.label', default: 'Lead')] as Object[], "Another user has updated this Lead while you were editing")
					//render(view: "edit", model: [leadInstance: leadInstance, salesUsers: salesUsers])
					return false
				}
			}
			def previousAssignToId = leadInstance.assignTo.id
			leadInstance.properties = params
			leadInstance.phone = params.phone
			leadInstance.mobile = params.mobile
			def user = User.get(new Long(SecurityUtils.subject.principal))
			leadInstance.dateModified = new Date()
			leadInstance.modifiedBy = user;
			leadInstance.assignTo = User.get(params.assignToId)
			
			leadInstance.billingAddress = BillingAddress.get(params.billingAddressId)
			leadInstance.billingAddress.properties["billAddressLine1", "billAddressLine2", "billCity", "billState", "billPostalcode", "billCountry"] =params
			def map = [:]
			if (!leadInstance.hasErrors() && leadInstance.save(flush: true))
			{
				if(previousAssignToId != leadInstance.assignTo.id && leadInstance.createdBy.id != leadInstance.assignTo.id)
				{
					map = new NotificationGenerator(g).sendAssignedToNotification(leadInstance, "Lead")
					sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/lead/show/"+leadInstance.id)
					
					map = [:]
					map = new NotificationGenerator(g).changeAssignedToNotification(leadInstance, User.get(previousAssignToId), "Lead")
					sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/lead/show/"+leadInstance.id)
					
				}
				session["leadlist-refresh"] = false;
				def leadname = leadInstance.firstname + " "+ leadInstance.lastname
				flash.message = "${message(code: 'default.updated.message', args: [message(code: 'lead.label', default: 'Lead'), leadname])}"
				//redirect(action: "show", id: leadInstance.id)
				return true
			}
			else {
				//render(view: "edit", model: [leadInstance: leadInstance, salesUsers: salesUsers])
				return false
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'lead.label', default: 'Lead'), params.id])}"
			//redirect(action: "list")
			return false
		}
		
	}
	
    def delete = {
        def leadInstance = Lead.get(params.id)
        if (leadInstance) {
            try {
				def name = leadInstance.firstname +" "+leadInstance.lastname
                leadInstance.delete(flush: true)
				session["leadlist-refresh"] = false;
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'lead.label', default: 'Lead'), name])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'lead.label', default: 'Lead'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'lead.label', default: 'Lead'), params.id])}"
            redirect(action: "list")
        }
    }
	
	def leadConverter = {
		def leadInstance = Lead.get(params.id)
		render(template: "leadConverter", model: [leadInstance: leadInstance])
	}
	
	def leadReject = 
	{
		def res = "fail"
		def leadInstance = Lead.get(params.id)
		if(leadInstance)
		{
			def user = User.get(new Long(SecurityUtils.subject.principal))
			leadInstance.status = "Rejected"
			leadInstance.modifiedBy = user
			leadInstance.dateModified = new Date()
			
			if (leadInstance.save(flush: true))
			{
				flash.message = "${message(code: 'lead.reject.message.success.flash', args: [leadInstance.firstname, leadInstance.lastname])}"
				//redirect(action: "list", id: leadInstance.id)
			}
			else {
				flash.message = "${message(code: 'lead.reject.message.failure.flash', args: [leadInstance.firstname, leadInstance.lastname])}"
				//redirect(action: "list", id: leadInstance.id)
			}
		}
		
		redirect(action: "list")
	}
	
	public boolean isUpdated(Lead leadInstance)
	{
		 boolean check = false
	 
		 if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("SALES PRESIDENT"))
		 {
			 check = true
		 }
		 else
		 {
			 def user = User.get(new Long(SecurityUtils.subject.principal))
			 if(SecurityUtils.subject.hasRole("SALES PERSON"))
			 {
				 if(leadInstance?.assignTo?.id == user?.id)
				 {
					 check = true
				 }
			 }
			 else
			 {
				 check = true
			 }
			
		 }
	 
		 return check
	}
	
	def convertToContact = 
	{
		def res = "fail"
		def leadInstance = Lead.get(params.id)
		if(leadInstance)
		{
			def contactInstance = new Contact()
			def user = User.get(new Long(SecurityUtils.subject.principal))
			
			//get Account to convert lead to contact..............................
			def accountInstance = Account.get(params.accountId)
			//accountInstance.dateModified = new Date()
			//accountInstance.save(flush:true)
			
			//referencing address of lead to contact..............................
			def billingAddressInstance = new BillingAddress()
			billingAddressInstance?.billCountry = leadInstance?.billingAddress?.billCountry
			billingAddressInstance?.billAddressLine1 = leadInstance?.billingAddress?.billAddressLine1
			billingAddressInstance?.billAddressLine2 = leadInstance?.billingAddress?.billAddressLine2
			billingAddressInstance?.billState = leadInstance?.billingAddress?.billState
			billingAddressInstance?.billCity = leadInstance?.billingAddress?.billCity
			billingAddressInstance?.billPostalcode = leadInstance?.billingAddress?.billPostalcode
			billingAddressInstance.save(flush: true)

			
			contactInstance.firstname = leadInstance.firstname
			contactInstance.lastname = leadInstance.lastname
			contactInstance.phone = leadInstance.phone
			contactInstance.email = leadInstance.email
			contactInstance.title = leadInstance.title
			contactInstance.altEmail = leadInstance.altEmail
			contactInstance.mobile = leadInstance.mobile
			contactInstance.assignTo = User.get(params.assignToId)
			contactInstance.dateCreated = new Date()
			contactInstance.dateModified = new Date()
			contactInstance.createdBy = user
			contactInstance.modifiedBy = user
			contactInstance.account = accountInstance
			contactInstance.billingAddress = billingAddressInstance
			
			leadInstance.status = "Converted"
			leadInstance.modifiedBy = user
			leadInstance.contact = contactInstance
			leadInstance.dateModified = new Date()
						
			String source = params.source
			def map = [:]
			/*if(source == "converttoopportunity")
			{
				String stepName = ServiceStageFlow.findLeadStepName(source, params.step_number.toInteger());
				if(stepName.equals("addaccount"))
				{
					params.currentStep = params.step_number.toInteger() + 1;
					
					leadInstance.currentStep  = params.currentStep
					*/if (leadInstance.save(flush: true) && contactInstance.save(flush: true))
					{
						if(contactInstance.createdBy.id != contactInstance.assignTo.id)
						{
							map = new NotificationGenerator(g).sendAssignedToNotification(contactInstance, "Contact")
							sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/contact/show/"+contactInstance.id)
						}
						
						render(template:"/contact/show", model:[contactInstance: contactInstance])
						
					}
					else 
					{
						flash.message = "Lead is not converted into contact, some error has occured."
						render "fail"
						
						
						//redirect(action: "list", id: leadInstance.id)
					}
				//}
			//}
			
		}
		
	}
}
