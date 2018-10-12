package com.valent.pricewell
import grails.converters.JSON

import com.valent.pricewell.templater.*

import hr.ngs.templater.Configuration
import hr.ngs.templater.ITemplateDocument

import java.text.SimpleDateFormat

import javax.management.RuntimeErrorException

import org.apache.shiro.SecurityUtils
import org.xhtmlrenderer.pdf.ITextRenderer
import org.springframework.web.multipart.MultipartFile
import org.codehaus.groovy.grails.web.context.ServletContextHolder
import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONObject
//import org.json.simple.parser.JSONParser
import org.codehaus.groovy.grails.web.json.parser.JSONParser

import com.google.gson.Gson
import com.valent.pricewell.Staging.StagingObjectType

import org.apache.commons.lang.StringEscapeUtils

class QuotationController {
	def generalStagingService
	private static int ROUNDING_MODE = BigDecimal.ROUND_HALF_EVEN;
	private static int DECIMALS = 2;
	def myPDFService
	def quotationService
	def serviceCatalogService
	def reviewService
	def sendMailService
	def fileUploadService, cwimportService, salesCatalogService, bootstrapProcessService
	static allowedMethods = [save: "POST", update: "POST", delete: "POST", savesowtag: "POST"]

	def index = {
		redirect(action: "list", params: params)
	}

	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}
	
	public boolean isClass(String className)
	{
		boolean exist = false;
		
		for (grailsClass in grailsApplication.allClasses)
		{
			if(grailsClass.name == className)
			{
				exist = true;
				println grailsClass.name
			}
		}
		
		return exist;
	}

	def hasProjectParameters = {
		def quotationInstance = Quotation.get(params.id)
		
		if(quotationInstance?.projectParameters?.size() > 0)
		{
			render "true"
		}
		else
			render "false"
	}
	
	def list = {
		params.max = Math.min(params.max ? params.int('max') : 10, 100)
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def quotationList = quotationService.findUserQuote(user)

		//def serviceQuote = reviewService.findServiceQuoteList()
		//println serviceQuote
		//,serviceQuoteList: serviceQuote


		[quotationInstanceList: quotationList, quotationInstanceTotal: quotationList.size()]
	}

	def goToOpportunity = {
		Quotation quotationInstance = Quotation.get(params.id)
		redirect(controller: "opportunity", action: "show", id: quotationInstance?.opportunity?.id, params: [quoteId: quotationInstance?.id, filePath: params.filePath])
	}
	
	def quotationWorkflowSettingSave = {
		
		String selectedWorkflow = params.get("workflowValue")
		
		//def val = Setting.()
		def workflowMode = Setting.findByName("quotationWorkflowMode");
		
		if(workflowMode == null)
		{
			Setting wrkFlw = new Setting ()
			
			wrkFlw.name = "quotationWorkflowMode"
			wrkFlw.value = selectedWorkflow
			wrkFlw.save()
		}
		else
		{
			workflowMode.value = selectedWorkflow
			workflowMode.save()
		}
				
		render "success"
		//redirect (controller: "setup" , action : "firstsetup")
	}
	
	def listPendingJSON = {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def quotationList = quotationService.findPendingUserQuotes(user)

		def results = []

		for(Quotation q in quotationList){
			def days = new Date() - (q.statusChangeDate?:q.createdDate)
			results.add([
						cell: [
							q.id,
							q.status.toString(),
							days,
							q.account?.accountName,
							q.customerType,
							q.createdDate,
							q.geo.name,
							q.totalQuotedPrice
						],
						id: q.id
					]);
		}

		def jsonData = [rows: results]

		render jsonData as JSON
	}

	def create = {
		def quotationInstance = new Quotation()
		quotationInstance.properties = params

		def validityDays = 0
		if(params.opportunityId){

			def opp = Opportunity.get(params.opportunityId);
			
			def closeDate = opp.closeDate;
			closeDate.clearTime()
			
			//converting Timestamp to Date object
			def closeDateWithoutTime = new Date(closeDate.getTime())
			
			def currentDateWitoutTime = new Date();
			currentDateWitoutTime.clearTime()
			
			//println "date diff "+closeDateWithoutTime.compareTo(currentDateWitoutTime)+" ===="
			
			//validityDays = opp.closeDate - new Date() - 1
			if(closeDateWithoutTime.compareTo(currentDateWitoutTime) <= 0 ){
				validityDays = 1; //if date comparison is negative or equal - just allow for today
			}
			else{
				//TODO need to discuss this with Snehal Mistry and Rich before finalizing it
				validityDays = closeDateWithoutTime - currentDateWitoutTime //Removed -1 from here
			}
			
			quotationInstance.opportunity = opp;
			quotationInstance.account = opp.account
			quotationInstance.geo = opp.geo
			quotationInstance.customerType = opp.account.type
			quotationInstance.projectParameters = new ArrayList()
		}

		render (template: "create", model: [quotationInstance: quotationInstance, validityDays: validityDays])
	}

	def getServiceTicketConfiguration = {
		def quotationInstance = Quotation.get(params.id.toLong())
		
		def configurationMap = cwimportService.getTicketConfiguration()
		render (view: "serviceTicketConfiguration", model: [quotationInstance: quotationInstance, serviceBoard: configurationMap['serviceBoard'], serviceStatus: configurationMap['serviceStatus'], serviceType: configurationMap['serviceType'], serviceSource: configurationMap['serviceSource'], priority: configurationMap['priority']])
	}
	
	def getRelatedConfiguration = {
		def board = params.board
		def configurationMap = cwimportService.getBoardRelatedConfiguration(board)
		
		def statusNameContent = g.render(template:"boardRelatedConfiguration", model:[configType: 'serviceStatus', serviceStatus: configurationMap['serviceStatus']])
		def serviceTypeContent = g.render(template:"boardRelatedConfiguration", model:[configType: 'serviceType', serviceType: configurationMap['serviceType']])
		
		Map dataMap = [:]
		dataMap['statusNameContent'] = statusNameContent

		dataMap['serviceTypeContent'] = serviceTypeContent
		render dataMap as JSON
	}
	
	def createServiceTicket = {
		Quotation quotationInstance = Quotation.get(params.quotationId.toLong())
		def dataMap = [:]
		dataMap["board"] = params.board
		dataMap["source"] = params.source
		dataMap["statusName"] = params.statusName
		dataMap["priority"] = params.priority
		dataMap["serviceType"] = params.serviceType
		def count = cwimportService.createServiceTicketForQuotation(quotationInstance, dataMap)
		def msg = "No service ticket have been created."
		if(count > 1)
		{
			msg = "Total "+count+" service ticket have been created."
		}
		else if(count == 1)
		{
			msg = "One service ticket has been created."
		}
		quotationInstance.convertToTicket = "yes"
		quotationInstance.modifiedDate = new Date()
		quotationInstance.save()
		Map data = [:]
		data["result"] = "success"
		data["msg"] = msg
		render data as JSON
	}
	
	def addSOWIntroductionAndMilestones = {
		def quotationInstance = Quotation.get(params.id.toLong())
		render(template: "addSOWIntroductionAndMilestones", model:[quotationInstance: quotationInstance])
	}
	
	def saveSOWIntroductionAndMilestones = {
		def quotationInstance = Quotation.get(params.id.toLong())
		def value = params.sowIntroduction
		
		//deleteExistingIntroductionAndMilestone(quotationInstance)
		deleteExistingSOWIntroduction(quotationInstance)
		deleteExistingSOWMilestone(quotationInstance)
		
		quotationInstance.sowIntroductionSetting = new Setting(name: 'introductionFor'+quotationInstance?.id, value: value).save(flush: true)
		
		def quotationMilestoneInstance = createMilestone(params.milestone1, params.amount, params.priceIn, quotationInstance)
		quotationInstance.addToMilestones(quotationMilestoneInstance)
		
		if(params.milestone2 != null && params.milestone2 != "")
		{
			def quotationMilestoneInstance2 = createMilestone(params.milestone2, params.amount2, params.priceIn, quotationInstance)
			quotationInstance.addToMilestones(quotationMilestoneInstance2)
		}
		if(params.milestone3 != null && params.milestone3 != "")
		{
			def quotationMilestoneInstance3 = createMilestone(params.milestone3, params.amount3, params.priceIn, quotationInstance)
			quotationInstance.addToMilestones(quotationMilestoneInstance3)
		}
		if(params.milestone4 != null && params.milestone4 != "")
		{
			def quotationMilestoneInstance4 = createMilestone(params.milestone4, params.amount4, params.priceIn, quotationInstance)
			quotationInstance.addToMilestones(quotationMilestoneInstance4)
		}
		if(params.milestone5 != null && params.milestone5 != "")
		{
			def quotationMilestoneInstance5 = createMilestone(params.milestone5, params.amount5, params.priceIn, quotationInstance)
			quotationInstance.addToMilestones(quotationMilestoneInstance5)
		}
		if(params.milestone6 != null && params.milestone6 != "")
		{
			def quotationMilestoneInstance6 = createMilestone(params.milestone6, params.amount6, params.priceIn, quotationInstance)
			quotationInstance.addToMilestones(quotationMilestoneInstance6)
		}
		if(quotationInstance.save())
		{
			render "success"
		}else {
			render "fail"
		}
		
		
	}
	
	public void deleteExistingSOWIntroduction(Quotation quotationInstance)
	{
		if(quotationInstance?.sowIntroductionSetting != null && quotationInstance?.sowIntroductionSetting != "")
		{
			Setting introductionSetting = Setting.get(quotationInstance?.sowIntroductionSetting?.id)
			introductionSetting.delete()
		}
		
		
		quotationInstance?.sowIntroductionSetting = null
		quotationInstance.save()
	}
	
	public void deleteExistingSOWMilestone(Quotation quotationInstance)
	{
		for(QuotationMilestone qMilestone : quotationInstance?.milestones)
		{
			println "Quotation milestone is going to delete now : " + qMilestone?.id
			qMilestone.delete()
		}
		
		quotationInstance.milestones = new ArrayList()
		quotationInstance.save()
	}
	
	public void deleteExistingIntroductionAndMilestone(Quotation quotationInstance)
	{
		if(quotationInstance?.sowIntroductionSetting != null && quotationInstance?.sowIntroductionSetting != "")
		{
			Setting introductionSetting = Setting.get(quotationInstance?.sowIntroductionSetting?.id)
			introductionSetting.delete()
		}
		
		for(QuotationMilestone qMilestone : quotationInstance.milestones)
		{
			qMilestone.delete()
		}
		quotationInstance?.sowIntroductionSetting = null
		quotationInstance.milestones = new ArrayList()
		quotationInstance.save()
	}
	
	public QuotationMilestone createMilestone(String milestone, def price, def priceIn, Quotation quotation)
	{
		def quotationMilestoneInstance = new QuotationMilestone()
		quotationMilestoneInstance.milestone = milestone
		addMilestoneToDefaultList(milestone)
		def amountOrPercentage = (price == "" || price == null) ? 0 : price.toInteger()
		Map amountPercentageMap = (priceIn=="percentage") ? calculateAmountFromPercentage(quotation?.finalPrice, amountOrPercentage) : calculatePercentageFromAmount(quotation?.finalPrice, amountOrPercentage)
		quotationMilestoneInstance.amount = amountPercentageMap['amount']//new BigDecimal(price)
		quotationMilestoneInstance.percentage = amountPercentageMap['percentage']//new BigDecimal(price)
		quotationMilestoneInstance.quotation = quotation
		quotationMilestoneInstance.save()
		return quotationMilestoneInstance
	}
	
	public void addMilestoneToDefaultList(String milestoneName)
	{
		ObjectType defaultMilestone = ObjectType.findByNameAndType(milestoneName, ObjectType.Type.SOW_MILESTONE)
		
		if(defaultMilestone == null)
		{
			bootstrapProcessService.createNewObjectType(milestoneName, ObjectType.Type.SOW_MILESTONE)
		}
	}
	
	public Map calculateAmountFromPercentage(BigDecimal finalPrice, def percentage)
	{
		BigDecimal tenthOfActualPrice = new BigDecimal(finalPrice * 0.10)
		int decimalPoint = 0, roundingMode = BigDecimal.ROUND_HALF_EVEN
		
		if(isStringContainCharacherString(tenthOfActualPrice.toString(), '.'))
		{
			String[] result = tenthOfActualPrice.toString().split("\\.");
			decimalPoint = result[1].length()
		}
		
		BigDecimal amount = new BigDecimal(tenthOfActualPrice * percentage.toBigDecimal() / 10).setScale(decimalPoint, roundingMode)
		
		return [percentage: percentage.toBigDecimal(), amount: amount]
		
	}
	
	public boolean isStringContainCharacherString(String string1, String compStr)
	{
		if(string1.contains(compStr))	
			return true
		return false
	}
	
	public Map calculatePercentageFromAmount(BigDecimal finalPrice, def amount)
	{
		BigDecimal percentage = new BigDecimal(amount.toBigDecimal() * 100 / finalPrice)
		return [percentage: percentage.toBigDecimal(), amount: amount.toBigDecimal()]
	}
	
	public String getWorkflowMode()
	{
		Setting wrkFlw = Setting.findByName("quotationWorkflowMode");
		
		if(wrkFlw == null || wrkFlw?.value == null)
		{
			println "full"
			return "full"
		}
		//println wrkFlw?.value
		return wrkFlw?.value
			
	}
	
	def save = {
		def quotationInstance = new Quotation()
		quotationInstance.properties = params
		quotationInstance.createdDate = new Date()
		quotationInstance.modifiedDate = new Date()
		quotationInstance.contractStatus = Staging.initialStage(StagingObjectType.QUOTATION, false)
		quotationInstance.statusChangeDate = new Date()
		
		def selectedWorkflow = getWorkflowMode()
		if(selectedWorkflow == "full")
		{
			quotationInstance.isLight = false//new Boolean(params.isLight)//setting value of light version false if its full version
		}
		else
		{
			quotationInstance.isLight = true//new Boolean(params.isLight)//setting value of light version true if light version
		}
		
		if(quotationInstance?.isLight == false)
		{
			quotationInstance.status = Staging.initialStage(StagingObjectType.QUOTATION, false)
		}
		else
		{
			quotationInstance.status = Staging.finalAcceptStage(StagingObjectType.QUOTATION, false)
		}
		
		quotationInstance.createdBy = User.get(new Long(SecurityUtils.subject.principal))
		if(quotationInstance.geo){
			quotationInstance.taxPercent = quotationInstance.geo.taxPercent;
		}

		def map = [:]
		if (quotationInstance.save(flush: true)) {
			//println "Quotation saved"
			flash.message = "${message(code: 'default.created.message.quotation', args: [message(code: 'quotation.label', default: 'Quotation'), quotationInstance.createdBy,quotationInstance.account])}"
			//render message(code: 'default.created.message', args: [message(code: 'quotation.label', default: 'Quotation'), quotationInstance.createdBy,quotationInstance.account])
			//render(template: "opportunity-quotes", model: [opportunityInstance: quotationInstance.opportunity]  )
			//redirect (action: "show", id: quotationInstance.id, params: [source: "fromOpportunity"] )
			map['res'] = "success"
			map['id'] = quotationInstance.id
			map['msg'] = "${message(code: 'quotation.create.message.success.dialog', args: [quotationInstance.id])}"
			render map as JSON
		}
		else {
			map['res'] = "fail"
			map['msg'] = "${message(code: 'quotation.create.message.failure.dialog')}"
			render map as JSON
			//render(view: "create", model: [quotationInstance: quotationInstance])
		}
		
	}

	def listPart = {
		def opp = Opportunity.get(params.opportunityId);
		//boolean isForConnectwise = salesCatalogService.isClass("com.connectwise.integration.ConnectwiseExporterService", grailsApplication)
		render(template: "listPart", model: [opportunityInstance: opp])//, isForConnectwise: isForConnectwise]  )
	}

	def changeServiceQuotationStatus = {
		def quotationInstance = Quotation.get(params.id.toLong())
		session["quotationId"] = quotationInstance?.id
		if (!quotationInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'quotation.label', default: 'Quotation'), params.id])}"
			//redirect(action: "list")
			render "fail"
		}
		else {
			def sqIds = []
			for(ServiceQuotation sq : quotationInstance.serviceQuotations)
			{
				if(sq.stagingStatus.name == "new")
				{
					sq.stagingStatus = Staging.findByName("active")
					sq.oldStage = ""
					sq.save()
				}
				else if(sq.stagingStatus.name == "edit")
				{
					sq.oldUnits = 0
					sq.stagingStatus = Staging.findByName("active")
					sq.oldStage = ""
					sq.save()
				}
				else if(sq.stagingStatus.name == "delete")
				{
					sqIds.add(sq.id)
				}
				
			}
			for(def Id : sqIds)
			{
				def serviceQuotationInstance = ServiceQuotation.get(Id.toLong())
				quotationInstance.removeFromServiceQuotations(serviceQuotationInstance)
				quotationInstance.save()
				int sequenceOrder = serviceQuotationInstance.sequenceOrder 
				serviceQuotationInstance.delete()
				
				correctSequenceOrder(quotationInstance, sequenceOrder)
			}
			quotationService.processAndSaveChanges(quotationInstance)
			render "success"
		}
	}
	
	def correctSequenceOrder(Quotation quotation, int sequenceOrder)
	{
		for(ServiceQuotation serviceQuotation : quotation?.serviceQuotations)
		{
			if(serviceQuotation?.sequenceOrder > sequenceOrder)
			{
				serviceQuotation.sequenceOrder--
				serviceQuotation.save()
			}
		}
	}
	
	def cancelServiceQuotationStatus = {
		def quotationInstance = Quotation.get(params.id.toLong())
		session["quotationId"] = quotationInstance?.id
		if (!quotationInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'quotation.label', default: 'Quotation'), params.id])}"
			render "fail"
		}
		else {
			def sqIds = []
			for(ServiceQuotation sq : quotationInstance.serviceQuotations)
			{
				if(sq.stagingStatus.name == "new")
				{
					sqIds.add(sq.id)
					
				}
				else if(sq.stagingStatus.name == "edit" || sq.stagingStatus.name == "delete")
				{
					if(sq.oldStage != "new")
					{
						Map priceMap = new HashMap()
						if(sq?.isCorrected == "yes" && sq?.correctionsInRoleTime?.size() > 0)
						{
							Map roleHrsCorrections = quotationService.createRoleHoursMap(sq)
							priceMap = quotationService.calculteServiceProfilePrice(sq.profile, sq.geo, sq.oldUnits, roleHrsCorrections)
							
						}
						else
						{
							priceMap = quotationService.calculteServiceProfilePrice(sq.profile, sq.geo, sq.oldUnits)
						}
						
						
						//Map priceMap = quotationService.calculteServiceProfilePrice(sq.profile, sq.geo, sq.oldUnits)
						sq.price = priceMap["totalPrice"]
						sq.totalUnits = sq.oldUnits
						sq.oldUnits = 0
						sq.stagingStatus = Staging.findByName("active")
						sq.oldStage = ""
						sq.save()
					}
					else
					{
						sqIds.add(sq.id)
					}
					
				}
				
			}
			
			for(def Id : sqIds)
			{
				def serviceQuotationInstance = ServiceQuotation.get(Id.toLong())
				quotationInstance.removeFromServiceQuotations(serviceQuotationInstance)
				quotationInstance.save()
				int sequenceOrder = serviceQuotationInstance.sequenceOrder
				serviceQuotationInstance.delete()
				
				correctSequenceOrder(quotationInstance, sequenceOrder)
			}
			//quotationInstance.save()
			quotationService.processAndSaveChanges(quotationInstance)
			render "success"
		}
	}
	
	def show = {
		def quotationInstance = Quotation.get(params.id)

		session["quotationId"] = quotationInstance?.id
		if (!quotationInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'quotation.label', default: 'Quotation'), params.id])}"
			redirect(action: "list")
		}
		else {
			
			quotationService.processAndSaveChanges(quotationInstance)
			
			def serquo = quotationService.getActiveServiceOfQuotation(quotationInstance)
			//def serquo = ServiceQuotation.findAll("from ServiceQuotation sq WHERE sq.quotation.id = ${params.id} AND sq.stagingStatus.name != 'delete' ORDER BY sq.sequenceOrder")
			HashSet set = new HashSet()
			set.addAll(serquo.service.portfolio)
			def notificationList = Notification.findAll("FROM Notification nf WHERE nf.objectId=${quotationInstance.id} AND nf.objectType='Quotation' order by dateCreated desc")
			boolean requestDone = false
			boolean canModifyServices = false;

			if(quotationInstance.requestLevel1==false && quotationInstance.requestLevel2==false && quotationInstance.requestLevel3==false) {
				requestDone=true
			}


			if(quotationInstance.status.sequenceOrder <= 2) {
				def user = User.get(new Long(SecurityUtils.subject.principal))
				canModifyServices = canUserModifyService(quotationInstance)
				/*if(quotationInstance?.opportunity?.createdBy == user || quotationInstance?.opportunity?.assignTo == user || SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR")) {
					canModifyServices = true;
				}*/
			}
			
			if(quotationInstance?.isLight)
			{
				if(quotationInstance.contractStatus.sequenceOrder <= 2)
				{
					canModifyServices = canUserModifyService(quotationInstance)
				}
			}
			
			/*for(ServiceQuotation sq : serquo)
			{
				println sq?.service?.serviceName
			}*/
			//println serquo


			if(params.notificationId) {
				def note = Notification.get(params.notificationId)
				note.active = false
				note.save(flush:true)
			}
			if(params.source == "fromOpportunity") {
				Boolean moreDiscountAllowed = checkUserForDiscount(quotationInstance)
				Boolean discountReject = checkForDiscountReject(quotationInstance)
				render(template: "show", model: [readOnly: false, "discountReject": discountReject, "serviceQuotations": serquo, "moreDiscountAllowed": moreDiscountAllowed, "quotationInstance": quotationInstance, "notificationList": notificationList, "portfolioList": set.toList(), "canModifyServices": canModifyServices, "requestDone": requestDone]);
			}
			else {
				model: [readOnly: false, "quotationInstance": quotationInstance, "serviceQuotations": serquo, "notificationList": notificationList, "portfolioList": set.toList(), "canModifyServices": canModifyServices, "requestDone": requestDone]
			}
		}
	}
	
	public boolean canUserModifyService(Quotation quotationInstance)
	{
		boolean canModify =  false
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def quoteGeo = quotationInstance?.geo
		
		if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("SALES PRESIDENT"))
		{
			canModify = true
		}
		else if(SecurityUtils.subject.hasRole("GENERAL MANAGER"))
		{
			for(Geo territory : user?.geoGroup?.geos)
			{
				if(territory.id == quoteGeo.id)
				{
					canModify = true
				}
			}
		}
		else if(SecurityUtils.subject.hasRole("SALES MANAGER"))
		{
			for(Geo territory : user?.territories)
			{
				if(territory.id == quoteGeo.id)
				{
					canModify = true
				}
			}
		}
		else if(SecurityUtils.subject.hasRole("SALES PERSON"))
		{
			if(quotationInstance?.opportunity?.createdBy.id == user.id || quotationInstance?.opportunity?.assignTo.id == user.id)
			{
				canModify = true
			}
		}
		return canModify
	}

	/**
	 * Params: id & confidence
	 */
	def saveConfidence = {
		Quotation quotationInstance = Quotation.get(params.id)
		if(quotationInstance){
			quotationInstance = quotationService.saveConfidence(quotationInstance, new BigDecimal(params.confidence));
			render quotationInstance.forecastValue
		}
	}

	/**
	 * params: id
	 */
	def getForcastValue = {
		def quotationInstance = Quotation.get(params.id)
		if(quotationInstance){
			render quotationInstance.forecastValue
		}
	}
	
	def refreshStages = {
		def quotationInstance = Quotation.get(params.id)
		if(quotationInstance){
			render(template: "showInfo", model: [quotationInstance: quotationInstance, readOnly: false])
		}
	}

	/**
	 * Params: id , type & changeToId
	 * id: Quotation id
	 * type: type of staging, quotation or contract, if params not set to contract then default is quotation
	 * changeToId: StageId to change to
	 */
	def changeStage = {
		if(params.id && params.changeToId && params.type){

			def quotationInstance = Quotation.get(params.id.toLong())
			Staging nextStage =  Staging.get(params.changeToId.toLong())
			performStageChange(quotationInstance,nextStage, params.type)

			def actionTo = ""
			if(params.changeStage == "change")
			{
				actionTo = "show"
			}
			else
			{
				actionTo = "showInfo"
			}
			redirect (action: actionTo, id: quotationInstance.id, params: [source: "fromOpportunity", readOnly: false] )
			//showInfo
		}
	}

	void performStageChange(Quotation quotationInstance, Staging nextStage, String stageType ){
		Staging currentStage;

		if(quotationInstance && nextStage){
			def user = User.get(new Long(SecurityUtils.subject.principal))
			def type
			if(stageType == "contract"){
				type = GeneralStagingLog.StagingLogObjectType.CONTRACT;
				currentStage = Staging.get(quotationInstance.contractStatus.id);
				quotationInstance.contractStatus = nextStage
				if(nextStage.name == "Accepted") {
					quotationInstance = quotationService.saveConfidence(quotationInstance, new BigDecimal(100));
				}
			}
			else{
				type = GeneralStagingLog.StagingLogObjectType.QUOTATION;
				currentStage = Staging.get(quotationInstance.status.id);
				/*if(currentStage.name == "development")
				{
					quotationInstance.contractStatus = Staging.initialStage(StagingObjectType.QUOTATION, false)
				}*/
				quotationInstance.status = nextStage
				if(nextStage.name == "rejected" && quotationInstance.contractStatus != null) {
					quotationInstance.contractStatus = nextStage
				}
				/*else if(nextStage.name == "developement")
				{
					quotationInstance.contractStatus = null
				}*/
			}

			GeneralStagingLog generalStagingLogInstance = generalStagingService.logStagingModification(quotationInstance, nextStage, currentStage, "Created by ${user}", type);

			if(nextStage.name == 'rejected'){
				quotationInstance = quotationService.saveConfidence(quotationInstance, new BigDecimal(0));
			}
			quotationInstance.modifiedDate = new Date()
			quotationInstance.save()
		}
	}

	def showInfo = {
		def quotationInstance = Quotation.get(params.id)
		render(template: "showInfo", model: ['quotationInstance': quotationInstance, readOnly: false] )
	}

	def showPart = {
		def quotationInstance = Quotation.get(params.id)
		session["quotationId"] = quotationInstance?.id
		if (!quotationInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'quotation.label', default: 'Quotation'), params.id])}"
			redirect(action: "list")
		}else{

			def serquo = quotationService.getActiveServiceOfQuotation(quotationInstance)//quotationInstance.serviceQuotations
			HashSet set = new HashSet()
			set.addAll(serquo.service.portfolio)

			boolean canModifyServices = false;
			if(quotationInstance.status.sequenceOrder <= 2) {
				def user = User.get(new Long(SecurityUtils.subject.principal))

				if(quotationInstance.createdBy == user) {
					canModifyServices = true;
				}
			}

			render(template: "showPart", model: [readOnly: false, quotationInstance: quotationInstance, portfolioList: set.toList(), canModifyServices: canModifyServices])
		}
	}

	def checkUserForDiscount(Quotation quotationInstance) {
		boolean moreDiscountAllowed = false;
		if(SecurityUtils.subject.hasRole("SALES PERSON")) {
			if(quotationInstance.requestLevel1==false) {
				moreDiscountAllowed = true
			}
		}
		else if(SecurityUtils.subject.hasRole("SALES MANAGER")) {
			if(quotationInstance.requestLevel2==false) {
				moreDiscountAllowed = true
			}
		}
		else if(SecurityUtils.subject.hasRole("GENERAL MANAGER")) {
			if(quotationInstance.requestLevel3==false) {
				moreDiscountAllowed = true
			}
		}
		return moreDiscountAllowed
	}

	def checkForDiscountReject(Quotation quotationInstance) {
		boolean discountReject = false;
		if(SecurityUtils.subject.hasRole("SALES MANAGER")) {
			if(quotationInstance.requestLevel1==true) {
				discountReject = true
			}
		}
		else if(SecurityUtils.subject.hasRole("GENERAL MANAGER")) {
			if(quotationInstance.requestLevel2==true) {
				discountReject = true
			}
		}
		else if(SecurityUtils.subject.hasRole("SALES PRESIDENT")) {
			if(quotationInstance.requestLevel3==true) {
				discountReject = true
			}
		}
		return discountReject
	}

	def export = {
		def quotationInstance = Quotation.get(params.id)
		def serquo = quotationService.getActiveServiceOfQuotation(quotationInstance)//q.serviceQuotations
		render(view: "/quotation/export", model: [quotationInstance: quotationInstance, serviceQuotations: serquo])
	}

	def previewQuotation = {

		Quotation q =  Quotation.get(params.id)
		def serquo = quotationService.getActiveServiceOfQuotation(q)//q.serviceQuotations
		HashSet set = new HashSet()
		set.addAll(serquo.service.portfolio)
		println set.toList()
		def content = g.render(template:"/quotation/export", model:[quotationInstance: Quotation.get(params.id), portfolioList: set.toList(), serviceQuotations: serquo])

		render (template: "previewQuotation", model: ['content': content, qpId: q.id])
	}

	def exportPDF = {

		byte[] b
		//println params.qpId
		Quotation q =  Quotation.get(params.qpId)
		//println q
		def serquo = quotationService.getActiveServiceOfQuotation(q)//q.serviceQuotations
		HashSet set = new HashSet()
		set.addAll(serquo.service.portfolio)

		def content = g.render(template:"/quotation/export", model:[quotationInstance: q, portfolioList: set.toList(), pdfDisplay: true, serviceQuotations: serquo])
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		ITextRenderer renderer = new ITextRenderer();
		try {
			String text = content.toString()
			//println text
			def baseUri = request.scheme + "://" + request.serverName + ":" + request.serverPort +
					grailsAttributes.getApplicationUri(request)
			CompanyInformation companyInfo = CompanyInformation.list().iterator().next();
			if(companyInfo && companyInfo?.logo?.image){
				renderer.getSharedContext().setReplacedElementFactory(new ProfileImageReplacedElementFactory(renderer.getSharedContext().getReplacedElementFactory(), companyInfo?.logo?.image));
			}


			renderer.setDocumentFromString(text, baseUri);
			renderer.layout();
			renderer.createPDF(baos);
			b  = baos.toByteArray();
		}
		catch (Throwable e) {
			log.error(e)
			//throw new RuntimeErrorException(e.message, e )
			//sddsd
		}

		//Change stage to generated
		def nextStage = Staging.findByNameAndEntity('generated', Staging.StagingObjectType.QUOTATION)
		performStageChange(q, nextStage, "quotation")

		response.setContentType("application/pdf")
		response.setHeader("Content-disposition", "attachment; filename=quoteFor${q?.account?.accountName}.pdf")
		String fileName = "${q?.account?.accountName}-${q?.opportunity?.name}-Quote-${q?.id}.pdf"//"quoteFor${q?.account?.accountName}.pdf"
		response.setHeader("Content-disposition", "attachment; filename=\""+fileName+"\"")
		response.setContentLength(b.length)
		response.getOutputStream().write(b)

		if(!b){
			throw new RuntimeErrorException("No Bytes" )
		}

	}

	//def germanCharsReplace = ["&auml;":"&#228;", "&euro;": "&#8364;", "&szlig;": "&#223;", "&eacute;": "&#233;", "&ouml;": "&#246;"]
	def germanCharsReplace = ["&Auml;":"&#196;","&auml;":"&#228;","&Eacute;":"&#201;","&eacute;":"&#233;","&Ouml;":"&#214;","&ouml;":"&#246;","&Uuml;":"&#220;","&uuml;":"&#252;","&szlig;":"&#223;","&euro;" :"&#128;","&pound;":"&#163;"]

	def exportSOWInPDF = {

		def q = Quotation.get(params.sowId.toLong());
		String sowLabel =  getSOWLabel(q);

		def content = generateSOWForQuotation(q)
		//renderPdf(template: "/quotation/sow", model: [content: content], filename: "samplePDF.pdf")

		def text = g.render(template:"/quotation/sow", model:[content: content, sowLabel: sowLabel, pdfDisplay: true])

		text = text.replace("<br>", "<br/>");
		text = text.replace("& ", "&amp; ");
		//Change stage to generated
		//render text: text, contentType:"text/html", encoding:"UTF-8"


		byte[] b

		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		ITextRenderer renderer = new ITextRenderer();
		try {

			def baseUri = request.scheme + "://" + request.serverName + ":" + request.serverPort + grailsAttributes.getApplicationUri(request)

			CompanyInformation companyInfo = CompanyInformation.list().iterator().next();
			if(companyInfo && companyInfo?.logo?.image){
				renderer.getSharedContext().setReplacedElementFactory(new ProfileImageReplacedElementFactory(renderer.getSharedContext().getReplacedElementFactory(), companyInfo?.logo?.image));
			}
			renderer.setDocumentFromString(text.toString(), baseUri)
			renderer.layout();
			renderer.createPDF(baos);
			b  = baos.toByteArray();

		}
		catch (org.xhtmlrenderer.util.XRRuntimeException e) {
			e.printStackTrace();
			log.error(e)
			throw e
			//sddsd
		}

		//Change stage to generated
		def nextStage = Staging.findByNameAndEntity('generated', Staging.StagingObjectType.QUOTATION)
		performStageChange(Quotation.get(new Long(params.sowId)) ,nextStage, "contract")

		response.setContentType("application/pdf")
		String fileName = "SOWFor${q?.account?.accountName}.pdf"
		response.setHeader("Content-disposition", "attachment; filename=\""+fileName+"\"")
		response.setContentLength(b?.length)
		response.getOutputStream().write(b)

		if(!b){
			throw new RuntimeException("No Bytes" )
		}

	}


	def editsowtag = {
		def q = Quotation.get(params.qid);
		String tagName = params.tag;
		String tagTitle = params.title;

		def sowTag = null;
		if(params.createFlg == "true"){
			sowTag = new SowTag();
			sowTag.quotation = q;
			sowTag.tagName = tagName;
		} else{
			sowTag = SowTag.findByTagNameAndQuotation(tagName, q)
		}

		render(template: "editsowtag", model: ["sowTag": sowTag, "createFlg": params.createFlg, tagTitle: tagTitle]);
	}

	def savesowtag = {
		def q = null;

		if(params.createFlg == "true"){
			println "Create Flg trye"
			def sowTag = new SowTag();
			sowTag.properties = params;
			sowTag.save(flush: true)

			q = sowTag.quotation
		} else{
			println "Create Flg False"
			def sowTag = SowTag.get(params.id)
			sowTag.properties = params;
			sowTag.save(flush: true)
			q = sowTag.quotation
		}

		def sowPreview = generateSOWForQuotation(q)
		String sowLabel =  getSOWLabel(q);
		render (template: "sowPreview", model: ['sowContent': sowPreview, 'sowId': q.id, sowLabel: sowLabel, quotation: q])
	}

	def cancelsavesowtag = {
		def q = Quotation.get(params.id);
		def sowPreview = generateSOWForQuotation(q)
		String sowLabel =  getSOWLabel(q);
		render (template: "sowPreview", model: ['sowContent': sowPreview, 'sowId': q.id, sowLabel: sowLabel, quotation: q])
	}


	def previewSOW = {
		Quotation q =  Quotation.get(new Long(params.id));
		String sowLabel =  getSOWLabel(q);
		def sowPreview = generateSOWForQuotation(q)
		if(isSOWEditable(q)){
			render (template: "sowPreview", model: ['sowContent': sowPreview, 'sowId': params.id, sowLabel: sowLabel, quotation: q])
		} else {
			render (template: "sowPreview", model: ['sowContent': sowPreview, 'sowId': params.id, sowLabel: sowLabel, quotation: q, sowFinalPreview: 'true'])
		}
		
	}

	def finalPreviewSOW = {
		Quotation q =  Quotation.get(new Long(params.id));
		String sowLabel =  getSOWLabel(q);
		def sowPreview = generateSOWForQuotation(q)
		render (template: "sowPreview", model: ['sowContent': sowPreview, 'sowId': params.id, sowLabel: sowLabel, quotation: q, sowFinalPreview: 'true'])
	}

	private String getSOWLabel(Quotation q){
		if(q.geo.sowLabel){
			return q.geo.sowLabel;
		} else{
			return Setting.findByName("sowLabel").value;
		}
	}
	
	def gm = {
		System.out.println("sow test comming here")
		try
		{
			Quotation quotationInstance =  Quotation.get(new Long(params.id))
			println "Quotation id" + quotationInstance?.id
			if(quotationInstance)
			{
				render(view: "generateSOW", model: [quotationInstance: quotationInstance, currentStep: 1]);
			}
		}
		catch(java.lang.reflect.InvocationTargetException ex )
		{
			println "cause is :"+ ex.getCause()
		}
		
		
	}

	def checkSowTemplateAvailable = {
		Quotation quotationInstance =  Quotation.get(new Long(params.id));
		boolean isSOWTemplateThere = false
		Map resultMap = new HashMap()
		resultMap["result"] = "file_not_available"
		
		/*if(quotationInstance?.geo?.sowFile?.filePath != null && quotationInstance?.geo?.sowFile?.filePath != "")
		{
			def filePath = quotationInstance?.geo?.sowFile?.filePath + "\\" + quotationInstance?.geo?.sowFile?.name
			filePath = filePath.replaceAll('\\\\', '/')
			isSOWTemplateThere = fileUploadService.isFileExist(filePath)
			
		}*/
		if(quotationInstance?.geo?.sowDocumentTemplates?.size() > 0)
		{
			isSOWTemplateThere = true
		}
		
		if(isSOWTemplateThere)
		{
			resultMap["result"] = "file_available"
		}
		render resultMap as JSON
	}
	
	def generatesow = {
		try
		{
			Quotation quotationInstance =  Quotation.get(new Long(params.id))
			if(quotationInstance)
			{
				boolean isSampleSowOfTemplaterType = true//isSampleSowOfTemplaterType(quotationInstance)
				render(view: "generateSOW", model: [quotationInstance: quotationInstance, currentStep: 1, isSampleSowOfTemplaterType: isSampleSowOfTemplaterType]);
			}
		}
		catch(java.lang.reflect.InvocationTargetException ex )
		{
			println "cause is :"+ ex.getCause()
		}
		
	}
	
	private boolean isSampleSowOfTemplaterType(Quotation quotationInstance)
	{
		Map resultMap = new HashMap()
		def generateSOW = new TestWord()
		String fileName = quotationService.getSOWFilenameToGenerateWordDocument(quotationInstance)
		def storagePath =  fileUploadService.getStoragePath("generatedCustomerSOW")
		def outputFilePath = storagePath+"/"+fileName+".docx"
		
		TestWord tempFinder = new TestWord()
		String templatePath = tempFinder.getFilePath(quotationInstance.geo)
		
		JSONObject sowJsonObject = new JSONObject()
		if(TestWord.findTexts(templatePath, '\\[\\[[\\w,\\.]+\\]\\]').size() > 0)
		{
			return true
		}
		return false
	}
	
	def showGenerateSOWStages = {
		String source = params.source
		
		def user = User.get(new Long(SecurityUtils.subject.principal))

		//println source
		Quotation quotationInstance = Quotation.get(params.id)
		int stepNumber = (params.step_number && params.step_number.toInteger() > 0?params.step_number.toInteger(): 1);
		//println stepNumber
		String stepName = ServiceStageFlow.findSOWGenerateStepName(source, stepNumber);
		//println stepName
		
		if(stepName == "introduction")
		{
			DocumentTemplate defaultTemplate = quotationService.getTerritoryDefaultDocumentTemplate(quotationInstance)
			
			def sowIntroductionInstance = new SowIntroduction();
			def sowIntroductionInstanceList = sowIntroductionInstance.findAll("FROM SowIntroduction s WHERE s.geo.id = :gid ", [gid:quotationInstance.geo.id]);
			
			def dateFormat = (quotationInstance?.geo?.dateFormat != "" && quotationInstance?.geo?.dateFormat != null) ? quotationInstance?.geo?.dateFormat : "mm/dd/yy"
			def sowStartDate = quotationService.convertDateToString(dateFormat, quotationInstance?.sowStartDate)
			def sowEndDate = quotationService.convertDateToString(dateFormat, quotationInstance?.sowEndDate)
			
			render(template: "generateSOW/addIntroduction", model: [quotationInstance: quotationInstance, sowIntroList: sowIntroductionInstanceList, dateFormat: dateFormat, sowStartDate: sowStartDate, sowEndDate: sowEndDate, defaultTemplate: defaultTemplate]);
			return;
		}
		else if(stepName == "milestone"){
			session.removeAttribute("sowSupportParameterList");//remove the attribute added in projectParameters step
			render(template: "generateSOW/addMilestone", model: [quotationInstance: quotationInstance]);
			return;
		}
		else if(stepName == "projectParameters"){
			def projectParameterInstance = null
			if(quotationInstance?.projectParameters?.size() > 0)
			{
				 projectParameterInstance = ProjectParameter.get(quotationInstance?.projectParameters.toList().get(0).id)
			}
			else
			{
				projectParameterInstance = new ProjectParameter(params)
			}
			
			def sowSupportParameterList = SowSupportParameter.findAll("FROM SowSupportParameter ssp WHERE ssp.geo.id = :gid  AND ssp.type = :type",[gid:quotationInstance.geo.id, type:'PROJECTPARAMS']);
			session.setAttribute("sowSupportParameterList", sowSupportParameterList);
			render(template: "generateSOW/addProjectParameters", model: [quotationInstance: quotationInstance, projectParameterInstance: projectParameterInstance, sowSupportParameterList: sowSupportParameterList, isReadOnly: false]);
			return;
		}
		else if(stepName == "serviceview"){
			render(template: "generateSOW/selectServiceView", model: [quotationInstance: quotationInstance, isReadOnly: true]);
			return;
		}
		else if(stepName == "reviewSowPhaseContent"){
			
			redirect(action: "buildJsonObjectForQuotationProperties", params: [id: quotationInstance?.id])
			return;
		}
		else if(stepName == "showReview")
		{
			def serviceQuotationList = ServiceQuotation.findAll("from ServiceQuotation sq WHERE sq.quotation.id = ${quotationInstance?.id} AND sq.stagingStatus.name != 'delete'")
			HashSet portfolioSet = new HashSet()
			portfolioSet.addAll(serviceQuotationList.service.portfolio)
			
			render(template: "generateSOW/showReview", model: [readOnly: true, serviceQuotations: serviceQuotationList, quotationInstance: quotationInstance, portfolioList: portfolioSet.toList()]);
			return;
		}
	}
	
	def saveSOWMilestone = {
		Quotation quotationInstance = Quotation.get(params.id)
		render createQuotationMilestones(quotationInstance, params)
	}
	
	def saveGenerateSOWStages = {
		String source = params.source
		
		//println source
		Quotation quotationInstance = Quotation.get(params.id)
		int stepNumber = (params.step_number && params.step_number.toInteger() > 0?params.step_number.toInteger(): 1);
		//println stepNumber
		String stepName = ServiceStageFlow.findSOWGenerateStepName(source, stepNumber);
		//println stepName
		
		if(stepName == "introduction"){
			
			def value = params.sowIntroduction
			if(quotationInstance?.sowIntroductionSetting != null && quotationInstance?.sowIntroductionSetting != "")
			{
				Setting introductionSetting = Setting.get(quotationInstance?.sowIntroductionSetting?.id)
				introductionSetting.value = value
				introductionSetting.save()
			}
			else{
				quotationInstance.sowIntroductionSetting = new Setting(name: 'introductionFor'+quotationInstance?.id, value: value).save(flush: true)
			}
			
			quotationInstance.sowDocumentTemplate = DocumentTemplate.get(params.sowDocumentTemplateId)
			quotationInstance.sowStartDate = quotationService.convertDateStringToDate(quotationInstance?.geo?.dateFormat, params.sowStartDate)
			quotationInstance.sowEndDate = quotationService.convertDateStringToDate(quotationInstance?.geo?.dateFormat, params.sowEndDate)
			quotationInstance.save()
			
			render "success"
		}
		else if(stepName == "milestone"){
			
			render createQuotationMilestones(quotationInstance, params)
		}
		else if(stepName == "projectParameters")
		{
			def result = "fail"
			if(quotationInstance?.projectParameters?.size() > 0)
			{
				def projectParameterInstance = ProjectParameter.get(quotationInstance?.projectParameters.toList().get(0).id)
				if (projectParameterInstance) {
					if (params.version) {
						def version = params.version.toLong()
						if (projectParameterInstance.version > version) {
							
							projectParameterInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'projectParameter.label', default: 'ProjectParameter')] as Object[], "Another user has updated this ProjectParameter while you were editing")
						}
					}
					projectParameterInstance.properties = params
					if (!projectParameterInstance.hasErrors() && projectParameterInstance.save(flush: true)) {
						result = "success"
					}
				}
			}
			else
			{
				def projectParameterInstance = new ProjectParameter(params)
				projectParameterInstance.sequenceOrder = quotationInstance?.projectParameters?.size() + 1
				projectParameterInstance.quotation = quotationInstance
				if (projectParameterInstance.save(flush: true)) 
				{
					result = "success"
				}
			}
			render result
		}
		else if(stepName == "addprerequisite"){
			//render(template: "generateSOW/addPrerequisite", model: [quotationInstance: quotationInstance]);
			return;
		}
		else if(stepName == "serviceview"){
			render "success"
		}
	}
	
	public String createQuotationMilestones(Quotation quotationInstance, Map params)
	{
		List quotationMilestones = quotationInstance?.milestones?.toList()
		quotationInstance.milestones = new ArrayList()
		quotationInstance.save()
		
		
		//deleteExistingSOWMilestone(quotationInstance)
		
		for(QuotationMilestone qMilestone : quotationMilestones)
		{
			qMilestone.delete()
		}
		
		def quotationMilestoneInstance = createMilestone(params.milestone1, params.amount, params.priceIn, quotationInstance)
		quotationInstance.addToMilestones(quotationMilestoneInstance)
		
		if(params.milestone2 != null && params.milestone2 != "")
		{
			def quotationMilestoneInstance2 = createMilestone(params.milestone2, params.amount2, params.priceIn, quotationInstance)
			quotationInstance.addToMilestones(quotationMilestoneInstance2)
		}
		if(params.milestone3 != null && params.milestone3 != "")
		{
			def quotationMilestoneInstance3 = createMilestone(params.milestone3, params.amount3, params.priceIn, quotationInstance)
			quotationInstance.addToMilestones(quotationMilestoneInstance3)
		}
		if(params.milestone4 != null && params.milestone4 != "")
		{
			def quotationMilestoneInstance4 = createMilestone(params.milestone4, params.amount4, params.priceIn, quotationInstance)
			quotationInstance.addToMilestones(quotationMilestoneInstance4)
		}
		if(params.milestone5 != null && params.milestone5 != "")
		{
			def quotationMilestoneInstance5 = createMilestone(params.milestone5, params.amount5, params.priceIn, quotationInstance)
			quotationInstance.addToMilestones(quotationMilestoneInstance5)
		}
		if(params.milestone6 != null && params.milestone6 != "")
		{
			def quotationMilestoneInstance6 = createMilestone(params.milestone6, params.amount6, params.priceIn, quotationInstance)
			quotationInstance.addToMilestones(quotationMilestoneInstance6)
		}
		
		for(QuotationMilestone qMilestone : quotationInstance?.milestones)
		{
			println qMilestone?.milestone
		}
		
		if(quotationInstance.save())
		{
			return "success"
		}else {
			return "fail"
		}
	}
	
	private String evalForEscapeCharacters(String str)
	{
		if(str.contains("\\"))
		{
			while(str.contains("\\"))
			{
				int ind = str.indexOf('\\')
			
				if(str.charAt(ind+1) == 'n' || str.charAt(ind+1) == 't' || str.charAt(ind+1) == 'r')
				{
					String one = "", two = "";
			  
					if(ind != 0)
						one = str.substring(0, ind-1)
			  
					if(ind != str.length())
						two = str.substring(ind+2, str.length())
			  
					str = one + " " +two
				}
			}
		}
		return str
	}
	
	def buildJsonObjectForQuotationProperties = 
	{
		Quotation quotationInstance =  Quotation.get(new Long(params.id));
		/*boolean isSampleSOWThere = false
		
		if(quotationInstance?.geo?.sowFile?.filePath != null && quotationInstance?.geo?.sowFile?.filePath != "")
		{
			def filePath = quotationInstance?.geo?.sowFile?.filePath + "\\" + quotationInstance?.geo?.sowFile?.name
			filePath = filePath.replaceAll('\\\\', '/')
			isSampleSOWThere = fileUploadService.isFileExist(filePath)
			
		}
		if(isSampleSOWThere)
		{*/
			Map resultMap = new HashMap()
			def generateSOW = new TestWord()
			String fileName = quotationService.getSOWFilenameToGenerateWordDocument(quotationInstance)
			def storagePath =  fileUploadService.getStoragePath("generatedCustomerSOW")
			def outputFilePath = storagePath+"/"+fileName+".docx"
			
			TestWord tempFinder = new TestWord()
			String templatePath = tempFinder.getQuotationSowFilePath(quotationInstance)//getFilePath(quotationInstance.geo)
			
			JSONObject sowJsonObject = new JSONObject()
			if(TestWord.findTexts(templatePath, '\\[\\[[\\w,\\.]+\\]\\]').size() > 0)
			{
				sowJsonObject = SowJsonConverterUtil.convertSOWToJson(quotationInstance)
				//new DeliverablesGroupingByPhasePlugin().convertDeliverablesPhaseGroupDataToJson(quotationInstance)
				
				session.setAttribute("sowJsonObject", sowJsonObject)
				println sowJsonObject.toString();
				
				JSONArray phasesJsonArray = sowJsonObject.getJSONArray("phases")
				//JSONArray rolesByPhaseJsonArray = sowJsonObject.getJSONArray("rolesByPhase")
				
				sowJsonObject = new JSONObject().put("phases", phasesJsonArray)
				def sowJsonString = evalForEscapeCharacters(sowJsonObject.toString().replaceAll("'", ""))
				
				/*JSONObject rolesByPhaseJsonObject = new JSONObject().put("rolesByPhase", rolesByPhaseJsonArray)
				def rolesByPhaseJsonString = evalForEscapeCharacters(rolesByPhaseJsonObject.toString().replaceAll("'", ""))
				*/
				render(template: "generateSOW/reviewSOWContent", model: [sowJsonObject: sowJsonObject, sowJsonString: sowJsonString, quotationInstance: quotationInstance])//, rolesByPhaseJsonString: rolesByPhaseJsonString]);
			}
			else {
				outputFilePath = generateSOW.main(quotationInstance, outputFilePath ) // g -> grails tags library directly inherit from grails
				
				def nextStage = Staging.findByNameAndEntity('generated', Staging.StagingObjectType.QUOTATION)
				performStageChange(quotationInstance ,nextStage, "contract")
				
				outputFilePath = URLEncoder.encode(outputFilePath, "UTF-8")//outputFilePath.replaceAll("&", "%26")
				
				resultMap["filePath"] = outputFilePath
				resultMap["isJson"] = false
				
				render resultMap as JSON
			}
			
		/*}
		else
		{
			render "noFile"
		}*/
	}
	
	def storeSOWJsonAndGenerateSOW = {
		Quotation quotationInstance =  Quotation.get(new Long(params.id));
		JSONObject sowJsonObject = null, sowPhaseJsonObject = null, rolesByPhaseJsonObject= null
		
		String fileName = quotationService.getSOWFilenameToGenerateWordDocument(quotationInstance)
		def storagePath =  fileUploadService.getStoragePath("generatedCustomerSOW")
		def outputFilePath = storagePath+"/"+fileName+".docx"
		
		sowJsonObject = session.getAttribute("sowJsonObject")//SowJsonConverterUtil.convertSOWToJson(quotationInstance)//, g)
		session.removeAttribute("sowJsonObject")
		//println "sowJsonData : " + sowJsonObject.toString() 
		
		sowPhaseJsonObject  = new JSONObject(params.sowJsonObject.toString()); // json
		JSONArray phases = new JSONArray(sowPhaseJsonObject.get("phases").toString())
		
		sowJsonObject.put("phases", phases) //override existing phases inside json object with modified value
		sowJsonObject.put("phases2", phases)
		
		//generateSOWTempFinder - used to generate sow 
		TestWord generateSOWTempFinder = new TestWord()
		String templatePath = generateSOWTempFinder.getQuotationSowFilePath(quotationInstance)//getFilePath(quotationInstance.geo)
		
		//replace tags like [[tag_name]]
		generateWordDocUsingTemplater(quotationInstance, templatePath, outputFilePath, sowJsonObject)
	
		//replace tags like ${tag_name}
		outputFilePath = generateSOWTempFinder.implementAfterTemplater(quotationInstance, outputFilePath ) // g -> grails tags library directly inherit from grails
		
		def nextStage = Staging.findByNameAndEntity('generated', Staging.StagingObjectType.QUOTATION)
		performStageChange(quotationInstance ,nextStage, "contract")
		
		render URLEncoder.encode(outputFilePath, "UTF-8")//outputFilePath.replaceAll("&", "%26")
			//downloadSOWFile(outputFilePath)
		
	}
	
	def generateDucumentOfSOW = 
	{
		Quotation quotationInstance =  Quotation.get(new Long(params.id));
		/*boolean isSampleSOWThere = false
		
		if(quotationInstance?.geo?.sowFile?.filePath != null && quotationInstance?.geo?.sowFile?.filePath != "")
		{
			def filePath = quotationInstance?.geo?.sowFile?.filePath + "\\" + quotationInstance?.geo?.sowFile?.name
			filePath = filePath.replaceAll('\\\\', '/')
			isSampleSOWThere = fileUploadService.isFileExist(filePath)
			
		}
		if(isSampleSOWThere)
		{*/
			TestWord generateSOWTempFinder = new TestWord()
			String fileName = quotationService.getSOWFilenameToGenerateWordDocument(quotationInstance)
			def storagePath =  fileUploadService.getStoragePath("generatedCustomerSOW")
			def outputFilePath = storagePath+"/"+fileName+".docx"
			
			println outputFilePath
			
			String templatePath = generateSOWTempFinder.getFilePath(quotationInstance.geo)
			
			if(TestWord.findTexts(templatePath, '\\[\\[[\\w,\\.]+\\]\\]').size() > 0) {
                generateWordDocUsingTemplater(quotationInstance, templatePath, outputFilePath, null)
            } else {
                outputFilePath = generateSOWTempFinder.main(quotationInstance, outputFilePath ) // g -> grails tags library directly inherit from grails
            }

			def nextStage = Staging.findByNameAndEntity('generated', Staging.StagingObjectType.QUOTATION)
			performStageChange(quotationInstance ,nextStage, "contract")
			
			render URLEncoder.encode(outputFilePath, "UTF-8")//outputFilePath.replaceAll("&", "%26")
			//downloadSOWFile(outputFilePath)
		/*}
		else
		{
			render "noFile"
		}*/
		
		
	}
	
	//TODO: This is sample place holder, move it to separate controller
	private boolean generateWordDocUsingTemplater(Quotation quotation, String templatePath, String outputPath, JSONObject jsonObject){

		if(jsonObject == null)
		{
			jsonObject = SowJsonConverterUtil.convertSOWToJson(quotation, g)
			//TODO: This is temporary, once we get confidence we will remove it.
			println jsonObject.toString()
		}
        
        File file = new File(templatePath)
        //org.apache.commons.lang.
        if(!file.exists()){
            println "Error: file: " + templatePath + " does not exist"
            return false
        }
        if(jsonObject == null){
            println "Error: Invalid json values"
            return false
        }
        InputStream inputTemplateStream = new FileInputStream(templatePath);
        ByteArrayOutputStream bAOS = new ByteArrayOutputStream();
        ITemplateDocument tpl =
                Configuration.factory().open(inputTemplateStream, "docx", bAOS);
        tpl.process(jsonObject);
        tpl.flush();
        byte[] result = bAOS.toByteArray();
		InputStream is = new ByteArrayInputStream(result);
		TestWord.removeText(is, "Unlicensed version", outputPath)
		//Temporary disabled this code, enable this code once we have licensed version
		/*
        FileOutputStream fOS;
        fOS = new FileOutputStream(outputPath);
        fOS.write(result);*/
		println "SOW is generated successfully"
        return  true
    }
	
	String generateSOWForQuotation(Quotation q)
	{
		byte[] b
		String text = ""
		
		def serquo = quotationService.getActiveServiceOfQuotation(q)//q.serviceQuotations
		SortedMap<String, SortedSet<String[]>> servicesMap = new TreeMap<String, SortedSet<String[]>>();

		Properties serviceProps = new Properties();
		File sowServicesPropsFile = grailsAttributes.getApplicationContext().getResource("/props/sow-services.properties").getFile();
		serviceProps.load(new FileReader(sowServicesPropsFile));

		for(ServiceQuotation sq in serquo)
		{
			String portfolioName = sq.service.portfolio.portfolioName;
			if(!servicesMap.containsKey(portfolioName))
			{
				servicesMap.put(portfolioName, new TreeSet<String[]>(new Comparator<String[]>()
						{
							public int compare(String[] objA, String[] objB)
							{
								return objA[0].compareToIgnoreCase(objB[0]);
							}
						}));
			}
			String[] serviceValues = new String[2];
			List deliverables = sq.profile.listCustomerDeliverables();
			def dels = ""
			if(deliverables != null && deliverables.size() > 0){
				dels = g.render(template:"/quotation/serviceDeliverables", model:[deliverables: deliverables])
				
			}

			def map = [service: sq.service, units: sq.totalUnits, deliverables: dels];
			String definition = sq.profile?.definition;

			definition = evaluateValues(serviceProps, definition, map);

			serviceValues[0] = sq.service.toString();
			serviceValues[1] = definition;

			servicesMap.get(sq.service.portfolio.portfolioName).add(serviceValues);
		}

		def content = g.render(template:"/quotation/servicesContents", model:[portfolioServicesMap: servicesMap])

		text = q.geo.sowTemplate;

		if(!text || text.length()  == 0)
		{
			if(Setting.findByName("sow"))
				text = Setting.findByName("sow").value
		}

		Properties props = new Properties();
		File sowPropsFile = grailsAttributes.getApplicationContext().getResource("/props/sow.properties").getFile();
		props.load(new FileReader(sowPropsFile));
		def ciList = CompanyInformation.list()
		def ci = null;
		if(ciList != null && ciList.size() > 0){
			ci = ciList.get(0)
		}


		def map = [ci: ci, q: q,
					general_billing_terms: Setting.findByName("billing_terms")?.value,
					general_terms: Setting.findByName("terms")?.value,
					general_signature_block: Setting.findByName("signature_block")?.value,
					content: content]

		//Adding user input tags into map.
		if(q.sowTags != null){
			for(SowTag sowTag: q.sowTags){
				map.put(sowTag.tagName, sowTag.tagValue)
			}
		}

		//Adding labels
		map.put("sow_introduction_input_label", "SOW Introduction");

		text = evaluateValues(props, text, map);

		return text;
	}
	
	boolean isSOWEditable(Quotation q){
		String text = q.geo?.sowTemplate;
		if(text){
			if(text.contains("sow_introduction_input")){
				return true;
			}
		}
		return false;
	}

	String generateSOW(Long id){
		Quotation q =  Quotation.get(id)
		return generateSOWForQuotation(q);

	}

	private String evaluateValues(Properties props, String text, Map map){
		for(String key: props.keySet())
		{
			try{
				String tag = "[@@" + key + "@@]"
				if(text.contains(tag))
				{
					String evaluation = props.get(key);
					String value = Eval.me("map", map, evaluation).toString();
					text = text.replace(tag, value);
				}
			}catch(Exception e){

			}

		}

		return text;
	}


	def edit = {
		def quotationInstance = Quotation.get(params.id)
		String text = quotationInstance.templateText;

		if(!text || text.length == 0){
			quotationInstance.templateText = Setting.findByName("sow").value
		}

		if (!quotationInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'quotation.label', default: 'Quotation'), params.id])}"
			redirect(action: "list")
		}
		else {
			return [quotationInstance: quotationInstance, accountsList : Account.list(sort: "accountName")]
		}
	}

	def quotationServiceBegin = {
		redirect(controller: "service", action:"search", params: ["mode": "sales"])
	}

	def getRange(Object quotationInstance)
	{

		if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("SALES PRESIDENT"))
		{
			quotationInstance.discountFrom = -50
			quotationInstance.discountTo = 50
		}
		else if(SecurityUtils.subject.hasRole("GENERAL MANAGER"))
		{
			quotationInstance.discountFrom = -40
			quotationInstance.discountTo = 40
		}
		else if(SecurityUtils.subject.hasRole("SALES MANAGER"))
		{
			quotationInstance.discountFrom = -30
			quotationInstance.discountTo = 30
		}
		else if(SecurityUtils.subject.hasRole("SALES PERSON"))
		{
			quotationInstance.discountFrom = -20
			quotationInstance.discountTo = 20
		}
		quotationInstance.save();

	}

	def discount = {
		Quotation quotationInstance = null;

		if(params.quotationId)//(session["quotationId"])
		{
			quotationInstance = Quotation.get(params.quotationId)//session["quotationId"])
			if(!quotationInstance.discountPercent){
				quotationInstance.discountPercent = 0;
			}
			if(!quotationInstance.flatDiscount){
				quotationInstance.flatDiscount = false;
			}
		}

		if (!quotationInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'quotation.label', default: 'Quotation'), params.id])}"
			redirect(action: "list")
		}
		else
		{
			Boolean moreDiscountAllowed = checkUserForDiscount(quotationInstance)

			getRange(quotationInstance)
			def allowedDiscountRange = [
				quotationInstance.discountFrom,
				quotationInstance.discountTo
			];
			if(!quotationInstance.flatDiscount)
			{
				def discountPercent = quotationInstance.discountPercent;
				if(discountPercent > allowedDiscountRange[1])
				{

					allowedDiscountRange[1] = discountPercent;

				}
				if(discountPercent < allowedDiscountRange[0])
				{

					allowedDiscountRange[0] = discountPercent;

				}
			}
			
			List<SowDiscount> discountsList = new ArrayList<SowDiscount>()
				
			render(template: "discount", model: [quotationInstance: quotationInstance ,moreDiscountAllowed: moreDiscountAllowed, allowedDiscountRange: allowedDiscountRange])
			/*if(quotationInstance?.sowDiscounts?.size() > 0)
			{
				redirect(action: "list", controller: "sowDiscount", params: [quotationId: quotationInstance?.id])
			}
			else
			{
				redirect(action: "create", controller: "sowDiscount", params: [quotationId: quotationInstance?.id])
			}*/
		}
	}

	def addSowDiscount()
	{
		Map resultMap = new HashMap()
		resultMap.put("key", "fail")
		
		Quotation  quotationInstance = Quotation.get(params.quotationId)
		SowDiscount sowDiscountInstance = SowDiscount.get(params.discountId)
		
		if(quotationInstance && sowDiscountInstance)
		{
			quotationInstance.addToSowDiscounts(sowDiscountInstance)
			
			quotationInstance.discountAmount += sowDiscountInstance?.amount
			quotationInstance.save()
			
			resultMap.put("key", "success")
		}
		redirect(action: "discount", params: [quotationId: quotationInstance.id])
		//render resultMap as JSON
	}
	
	def removeSowDiscount()
	{
		Quotation  quotationInstance = Quotation.get(params.quotationId)
		SowDiscount sowDiscountInstance = SowDiscount.get(params.discountId)
		
		if(quotationInstance && sowDiscountInstance)
		{
			quotationInstance.removeFromSowDiscounts(sowDiscountInstance)
			
			quotationInstance.discountAmount -= sowDiscountInstance?.amount
			quotationInstance.save()
			
		}
		
		redirect(action: "discount", params: [quotationId: quotationInstance.id])
	}
	
	def discountRequest =
	{
		Quotation quotationInstance = null;

		if(session["quotationId"])
		{
			quotationInstance = Quotation.get(session["quotationId"])
		}

		if (!quotationInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'quotation.label', default: 'Quotation'), params.id])}"
			redirect(action: "list")
		}
		else
		{
			render(template: "discountRequest", model: [quotationInstance: quotationInstance])
		}
	}

	def addExpense = {
		Quotation quotationInstance = null;

		if(session["quotationId"])
		{
			quotationInstance = Quotation.get(session["quotationId"])
		}

		if (!quotationInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'quotation.label', default: 'Quotation'), params.id])}"
			redirect(action: "list")
		}
		else
		{
			render(template: "addExpense", model: [quotationInstance: quotationInstance])
		}
	}

	def saveExpense =
	{
		Quotation quotationInstance = null;

		if(session["quotationId"])
		{
			quotationInstance = Quotation.get(session["quotationId"])
		}

		if (quotationInstance)
		{
			if (params.version) {
				def version = params.version.toLong()
				if (quotationInstance.version > version) {

					quotationInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [
						message(code: 'quotation.label', default: 'Quotation')]
					as Object[], "Another user has updated this Quotation while you were editing")
					render(view: "edit", model: [quotationInstance: quotationInstance])
					return
				}
			}


			quotationInstance.properties = params
			quotationInstance.modifiedDate = new Date()

			if (!quotationInstance.hasErrors() && quotationService.processAndSaveChanges(quotationInstance) ) {
				flash.message = "${message(code: 'quotation.addExpence.message.success.flash')}"
				//render message(code: 'default.updated.message', args: [message(code: 'quotation.label', default: 'Quotation'), quotationInstance.createdBy,quotationInstance.customerName])
				redirect(action: "show", params: params)
			}
			else {
				render(view: "edit", model: [quotationInstance: quotationInstance])
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'quotation.label', default: 'Quotation'), params.id])}"
			redirect(action: "list")
		}
	}

	def showExpense =
	{
		Quotation quotationInstance = null;

		if(session["quotationId"])
		{
			quotationInstance = Quotation.get(session["quotationId"])
		}

		if (!quotationInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'quotation.label', default: 'Quotation'), params.id])}"
			redirect(action: "list")
		}
		else
		{
			render(template: "showExpense", model: [quotationInstance: quotationInstance])
		}
	}

	def deleteExpense =
	{
		Quotation quotationInstance = null;

		if(session["quotationId"])
		{
			quotationInstance = Quotation.get(session["quotationId"])
		}

		if (quotationInstance)
		{
			if (params.version) {
				def version = params.version.toLong()
				if (quotationInstance.version > version) {

					quotationInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [
						message(code: 'quotation.label', default: 'Quotation')]
					as Object[], "Another user has updated this Quotation while you were editing")
					render(view: "edit", model: [quotationInstance: quotationInstance])
					return
				}
			}


			quotationInstance.expenseAmount = 0
			quotationInstance.description = ""
			quotationInstance.modifiedDate = new Date()

			if (!quotationInstance.hasErrors() && quotationService.processAndSaveChanges(quotationInstance) ) {
				flash.message = "${message(code: 'quotation.removeExpence.message.success.flash')}"
				//render message(code: 'default.updated.message', args: [message(code: 'quotation.label', default: 'Quotation'), quotationInstance.createdBy,quotationInstance.customerName])
				redirect(action: "show", params: params)
			}
			else {
				render(view: "edit", model: [quotationInstance: quotationInstance])
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'quotation.label', default: 'Quotation'), params.id])}"
			redirect(action: "list")
		}
	}

	def sendDiscountNotification =
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))
		Quotation quotationInstance = Quotation.get(params.id)

		def note = new Notification()
		note.objectType = "Quotation"
		note.objectId = quotationInstance.id
		note.dateCreated = new Date()
		note.createdBy = user
		note.active = true
		//println getReceiverUser(quotationInstance)
		note.receiverUsers = getReceiverUserUp(quotationInstance)//[user.supervisor]
		note.receiverGroups = new ArrayList()
		note.message = "Notification for more discount in quotation by ${user}."
		note.comment = params.comment
		if(note.save(flush:true))
		{
			if(SecurityUtils.subject.hasRole("SALES PERSON"))
			{
				quotationInstance.requestLevel1 = true
			}
			else if(SecurityUtils.subject.hasRole("SALES MANAGER"))
			{
				quotationInstance.requestLevel2 = true
			}
			else if(SecurityUtils.subject.hasRole("GENERAL MANAGER"))
			{
				quotationInstance.requestLevel3 = true
			}
			quotationInstance.modifiedDate = new Date()
			quotationInstance.save()
		}

		//flash.message = "Notification sent to ${user.supervisor} for more discount."

		//redirect(action: "showPart", id: quotationInstance.id)
		redirect(action: "show", id: quotationInstance.id, params: [source: "fromOpportunity", readOnly: false])
	}

	public List getReceiverUserUp(Quotation quotationInstance)//call when sending request for more discount
	{
		def receiverUsers = []
		def territory = quotationInstance?.geo
		def user = User.get(new Long(SecurityUtils.subject.principal))
		if(SecurityUtils.subject.hasRole("SALES PERSON"))
		{
			receiverUsers.add(territory?.salesManager)
		}
		else if(SecurityUtils.subject.hasRole("SALES MANAGER"))
		{
			for(User us : territory?.geoGroup?.generalManagers)
			{
				receiverUsers.add(us)
			}
		}
		else if(SecurityUtils.subject.hasRole("GENERAL MANAGER"))
		{
			receiverUsers = serviceCatalogService.findUsersByRole("SALES PRESIDENT")
			
		}
		
		return receiverUsers
	}
	
	public List getReceiverUserDown(Quotation quotationInstance)//call when approve or reject discount request
	{
		def receiverUsers = []
		def territory = quotationInstance?.geo
		def user = User.get(new Long(SecurityUtils.subject.principal))
		
		receiverUsers.add(quotationInstance.createdBy)
		if(SecurityUtils.subject.hasRole("SALES PRESIDENT"))
		{
			receiverUsers.add(territory?.salesManager)
			for(User us : territory?.geoGroup?.generalManagers)
			{
				receiverUsers.add(us)
			}
		}
		else if(SecurityUtils.subject.hasRole("GENERAL MANAGER"))
		{
			receiverUsers.add(territory?.salesManager)
		}
		
		quotationInstance.requestLevel1 = false
		quotationInstance.requestLevel2 = false
		quotationInstance.requestLevel3 = false
		return receiverUsers
	}

	def saveDiscount = {

		Quotation quotationInstance = null;
		def map = [:]
		
		if(params.qid)
		{
			quotationInstance = Quotation.get(params.qid)
		}
		else if(session["quotationId"])
		{
			quotationInstance = Quotation.get(session["quotationId"])
		}
		println quotationInstance.id
		if (quotationInstance)
		{
			if (params.version) {
				def version = params.version.toLong()
				if (quotationInstance.version > version) {

					quotationInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [
						message(code: 'quotation.label', default: 'Quotation')]
					as Object[], "Another user has updated this Quotation while you were editing")
					render(view: "edit", model: [quotationInstance: quotationInstance])
					return
				}
			}
			def user = User.get(new Long(SecurityUtils.subject.principal))
			def receiversList = new ArrayList()
			if(quotationInstance.createdBy != user)
			{
				receiversList = getReceiverUserDown(quotationInstance)

				NotificationGenerator gen = new NotificationGenerator(g)
				map = gen.acceptDiscountNotification(quotationInstance, receiversList)

				/*if(map["message"]!=null && map["subject"]!=null && map["receiverList"].size()>0)
				{
					sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/quotation/show/"+quotationInstance.id)
				}*/

			}

			BigDecimal oldLocalDiscount = (quotationInstance?.localDiscount > 0) ? quotationInstance?.localDiscount : 0
		
			/*if(quotationInstance?.localDiscount != new BigDecimal(params.localDiscount.toInteger()))
			{
				quotationInstance.discountAmount -= (quotationInstance?.localDiscount > 0) ? quotationInstance?.localDiscount : 0
				quotationInstance?.localDiscount = params.localDiscount
				quotationInstance.discountAmount += quotationInstance?.localDiscount
			}*/
			
			quotationInstance.properties = params
			//quotationInstance.discountAmount += quotationInstance?.localDiscount - oldLocalDiscount
			quotationInstance.modifiedDate = new Date()

			if (!quotationInstance.hasErrors() && quotationService.processAndSaveChanges(quotationInstance) ) {
				flash.message = "${message(code: 'quotation.addDiscount.message.success.flash')}"
				//render message(code: 'default.updated.message', args: [message(code: 'quotation.label', default: 'Quotation'), quotationInstance.createdBy,quotationInstance.customerName])
				//redirect(action: "showPart", id: quotationInstance.id)
				redirect(action: "show", id: quotationInstance.id, params: [source: "fromOpportunity", readOnly: false])
			}
			else {
				render(view: "edit", model: [quotationInstance: quotationInstance])
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'quotation.label', default: 'Quotation'), params.id])}"
			redirect(action: "list")
		}
	}

	def rejectDiscount =
	{
		Quotation quotationInstance = null;
		def map = [:]
		def res = "fail"
		
		if(params.qid)
		{
			quotationInstance = Quotation.get(params.qid)
		}
		else if(session["quotationId"])
		{
			quotationInstance = Quotation.get(session["quotationId"])
		}
		
		if (quotationInstance)
		{
			def user = User.get(new Long(SecurityUtils.subject.principal))
			def receiversList = new ArrayList()
			if(quotationInstance.createdBy != user)
			{
				receiversList = getReceiverUserDown(quotationInstance)
				
				NotificationGenerator gen = new NotificationGenerator(g)
				map = gen.rejectDiscountNotification(quotationInstance, receiversList)

				/*if(map["message"]!=null && map["subject"]!=null && map["receiverList"].size()>0)
				{
					sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/quotation/show/"+quotationInstance.id)
				}*/

				if (!quotationInstance.hasErrors() && quotationService.processAndSaveChanges(quotationInstance) ) {
					flash.message = "${message(code: 'quotation.rejectDiscountRequest.message.success.flash')}"
					//render message(code: 'default.updated.message', args: [message(code: 'quotation.label', default: 'Quotation'), quotationInstance.createdBy,quotationInstance.customerName])
					//redirect(action: "show", id: quotationInstance.id, source: "fromOpportunity")
					res = "success"
					render res
				}

			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'quotation.label', default: 'Quotation'), params.id])}"
			redirect(action: "list")
		}
	}
	def update = {
		def quotationInstance = Quotation.get(params.id)
		if (quotationInstance) {
			if (params.version) {
				def version = params.version.toLong()
				if (quotationInstance.version > version) {

					quotationInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [
						message(code: 'quotation.label', default: 'Quotation')]
					as Object[], "Another user has updated this Quotation while you were editing")
					render(view: "edit", model: [quotationInstance: quotationInstance])
					return
				}
			}
			Object old_status = quotationInstance.status
			Date old_date = quotationInstance.statusChangeDate
			quotationInstance.properties = params
			if (!old_status.equals(quotationInstance.status))
			{
				quotationInstance.statusChangeDate = new Date()
			}

			quotationInstance.modifiedDate = new Date()

			if (!quotationInstance.hasErrors() && quotationInstance.save(flush: true)) {
				flash.message = "${message(code: 'default.updated.message.quotation', args: [message(code: 'quotation.label', default: 'Quotation'), quotationInstance.createdBy,quotationInstance.account])}"
				//render message(code: 'default.updated.message', args: [message(code: 'quotation.label', default: 'Quotation'), quotationInstance.createdBy,quotationInstance.customerName])
				redirect(action: "show", id: quotationInstance.id)
			}
			else {
				render(view: "edit", model: [quotationInstance: quotationInstance])
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'quotation.label', default: 'Quotation'), params.id])}"
			redirect(action: "list")
		}
	}

	def delete = {
		def quotationInstance = Quotation.get(params.id.toInteger())
		
		if (quotationInstance)
		{
			try 
			{
				
				quotationInstance.delete()
				
				render "success"
				
				/*flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'quotation.label', default: 'Quotation'), params.id])}"
				render message(code:'default.deleted.message', args: [
					message(code: 'quotation.label', default: 'Quotation'),
					params.id
				])
				redirect(action: "list")*/
			}
			catch (org.springframework.dao.DataIntegrityViolationException e) {
				/*flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'quotation.label', default: 'Quotation'), params.id])}"
				redirect(action: "show", id: params.id)*/
				render "fail"
			}
		}
		else {
			/*flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'quotation.label', default: 'Quotation'), params.id])}"
			redirect(action: "list")*/
			render "fail"
		}
	}

	def VSOEDiscount = {
		Date endDate = null
		Map totaldiscount = [:]
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date startDate = dateFormat.parse(params.start);
		
		if(params.end == null || params.end == "null")
		{
			totaldiscount = reviewService.countVSOEDiscounting(startDate, endDate)
		}
		else
		{
			endDate = dateFormat.parse(params.end);
			totaldiscount = reviewService.countVSOEDiscounting(startDate, endDate)
		}
		
		render (view: "/reports/VSOEDiscounting", model: [totaldiscount: totaldiscount])
	}

	def dealStatusChart =
	{
		Date endDate = null
		Map quoteTypesMap = [:]
		def user = User.get(new Long(SecurityUtils.subject.principal))
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date startDate = dateFormat.parse(params.start);
		if(params.end == null || params.end == "null")
		{
			quoteTypesMap = reviewService.buildSalesQuotesChartData(user, startDate, null)
		}
		else
		{
			endDate = dateFormat.parse(params.end);
			quoteTypesMap = reviewService.buildSalesQuotesChartData(user, startDate, endDate)
		}
		
		render (template: "../reports/dealStatus", model: [quoteTypesMap: quoteTypesMap])
	}
}
