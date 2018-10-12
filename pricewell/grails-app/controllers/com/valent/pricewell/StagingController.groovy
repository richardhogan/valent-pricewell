package com.valent.pricewell

import org.apache.shiro.SecurityUtils

class StagingController {

	static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

	def serviceStagingService
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
		def stagingInstanceList = []
		stagingInstanceList = Staging.findAll("FROM Staging st WHERE st.entity = 'SERVICE' ")
		session["stagingType"] = "service"
		[stagingInstanceList: stagingInstanceList, title: "Service Staging List"]
	}
	
	def workflowsetting = {
		
		redirect (controller : "service", action : "selectionOfWorkflow")
	}
	
	def workflowsettingSave = {
		
		String selectedWorkflow = params.get("workflowValue")
		
		//def val = Setting.()
		def val = Setting.findByName("workflowmode");
		
		if(val == null)
		{
			Setting wrkFlw = new Setting ()
			
			wrkFlw.name = "workflowmode"
			wrkFlw.value = selectedWorkflow
			wrkFlw.save()
		}
		else
		{
			val.value = selectedWorkflow
			val.save()
		}
				
		render "success"	
		//redirect (controller: "setup" , action : "firstsetup")
	}
	

	def listsetup = {
		
				
		def stagingInstanceList = []
		stagingInstanceList = Staging.findAll("FROM Staging st WHERE st.entity = 'SERVICE' ")
		session["stagingType"] = "service"
		render(template: "listsetup", model: [stagingInstanceList: stagingInstanceList, title: "Service Staging List"])
	}
	
	//For Admin Workflow setup
	def stageList = {
		
		
		def stagesList = SubStages.findAll("FROM SubStages st WHERE st.staging.entity = 'SERVICE'")
		/*
		println "In stageList"
		
		println stagesList
		*/
		//render(template:"serviceStages", model:[stagesList:stagesList])
		render(template:"listStages", model:[stagesList:stagesList])
		
	}
	
	def updateStageName = {
		
		SubStages subStage = SubStages.get(params.id)
		
		if(subStage != null)
		{
			def updatedName = params.displayName
			
			if(updatedName != null && updatedName.trim() != "")
			{
				subStage.displayName = updatedName
				subStage.save()
			}
			
	       render "success"
		}
		else
		{
			render "Fail"
		}
		
	}
	
	def editStageName = {
		
		SubStages subStage = SubStages.get(params.id?.toLong())
		
		render(template:"editStageName", model:[subStage: subStage])
		
	}
	
	

	def stagingList = {
		redirect(action: "updateList", params: [type: session["stagingType"]])
	}

	def updateList = {
		def stagingInstanceList = []
		def query = "FROM Staging st "
		def title = ""

		if(params.type == "service") {
			query = query + "WHERE st.entity = 'SERVICE'"
			title = "Service Staging List"
			session["stagingType"] = "service"
		}
		else if(params.type == "lead") {
			query = query + "WHERE st.entity = 'LEAD'"
			title = "Lead Staging List"
			session["stagingType"] = "lead"
		}
		else if(params.type == "opportunity") {
			query = query + "WHERE st.entity = 'OPPORTUNITY'"
			title = "Opportunity Staging List"
			session["stagingType"] = "opportunity"
		}
		else if(params.type == "quotation") {
			query = query + "WHERE st.entity = 'QUOTATION'"
			title = "Quotation Staging List"
			session["stagingType"] = "quotation"
		}
		else if(params.type == "serviceWorkflowMode")
		{
			
			def serviceWorkflow = Setting.findByName("workflowmode");
			Boolean isDetailedChecked = true
			Boolean isCustomizedChecked = false
			def workflowValue = "detailed"
			if(serviceWorkflow != null && serviceWorkflow?.value != null && serviceWorkflow?.value == "customized")
			{
				isCustomizedChecked =  true
				isDetailedChecked = false
				workflowValue = "customized"
			}
			title = "Service Workflow Mode"
			session["stagingType"] = "serviceWorkflowMode"
			
			render(template: "../service/selectWorkflow", model: [isCustomizedChecked : isCustomizedChecked, isDetailedChecked:isDetailedChecked, title: title, workflowValue: workflowValue]);
		}
		else if(params.type == "quotationWorkflowMode")
		{
			
			def quotationWorkflow = Setting.findByName("quotationWorkflowMode");
			Boolean isFullChecked = true
			Boolean isLightChecked = false
			def workflowValue = "full"
			if(quotationWorkflow != null && quotationWorkflow?.value != null && quotationWorkflow?.value == "light")
			{
				isLightChecked = true
				isFullChecked = false
				workflowValue = "light"
			}
			title = "Quotation Workflow Mode"
			session["stagingType"] = "quotationWorkflowMode"
			
			render(template: "../quotation/selectWorkflowMode", model: [isFullChecked: isFullChecked, isLightChecked: isLightChecked, title: title, workflowValue: workflowValue]);
		}
		else if(params.type == "serviceSubstages")
		{
			def subStagesList = SubStages.findAll("FROM SubStages st WHERE st.staging.entity = 'SERVICE'")
			title = "Service Substage List"
			session["stagingType"] = "serviceSubstages"
			render(template:"listStages", model:[subStagesList: subStagesList, title: title])
		}

		if(params.type == "service" || params.type == "lead" || params.type == "opportunity" || params.type == "quotation")
		{
			stagingInstanceList = Staging.findAll(query)
			if(params.source == "setup") {
				render(template: "/staging/listsetup", model: [stagingInstanceList: stagingInstanceList, title: title]);
			}else {
				render(template: "/staging/list", model: [stagingInstanceList: stagingInstanceList, title: title]);
			}
		}
	}

	def listServiceStages = {
		def currentStage;
		if(params.stageId) {
			currentStage = Staging.get(params.stageId)
		}
		[stagingInstanceList: Staging.listServiceStages ("NEW_STAGE"), currentStage: currentStage]
	}

	def changeStaging = {
		def currentStage;
		def nextStage;
		def stagingLogInstance = new StagingLog()

		if(params.stageId) {
			currentStage = Staging.get(params.stageId)
			nextStage = Staging.getNextServiceStage("NEW_STAGE", currentStage)
		}

		ServiceProfileSecurityProvider profileSecurity =
				new ServiceProfileSecurityProvider(ServiceProfile.get(params.serviceProfileId))

		boolean isNextReview = profileSecurity.isStageBeingReviewed(nextStage)

		Set assigneesList = null;

		if(isNextReview) {
			assigneesList = profileSecurity.listAuthorizedUsers(nextStage)
			assigneesList.addAll(profileSecurity.listReviewerUsers(nextStage))
		}


		//render(view: "changeStaging", model:
		[stagingInstanceList: (params.nextStageDisabled? [nextStage]: Staging.listServiceStages ("NEW_STAGE")),
			currentStage: currentStage,
			nextStage: nextStage,
			staginLogInstance: stagingLogInstance,
			serviceProfileId: params.serviceProfileId,
			nextStageDisabled: params.nextStageDisabled,
			nextReviewStage: isNextReview,
			assigneesList: assigneesList]//)

	}


	def reviewRequestFromStaging={

		def map = [:]
		def res = "fail"
		if(!params.serviceProfileId || !params.nextStageId){
			flash.message = "Service Profile is not provided properly or some parameters are not valid"
			//TODO: Redirect properly
		}

		def stage = Staging.get(params.nextStageId)


		if(!stage) {
			flash.message = "Next stage is not valid"
			//TODO: Redirect properly
		}

		def profileId = params.serviceProfileId

		def serviceProfile = ServiceProfile.get(params.serviceProfileId)
		if(!serviceProfile) {
			flash.message = "Service profile is not valid"
			//TODO: Redirect properly
		}

		if(stage == serviceProfile.stagingStatus) {
			flash.message = "Stages can not be the same"
			//TODO: redirect properly
		}

		println "Stage Id" + params.nextStageId

		//def action = Staging.getStageChangeActionString(serviceProfile.stagingStatus, nextStage);

		if(!serviceStagingService.changeStaging(serviceProfile, stage, params.comment))
		{
			//TODO: Something wrong redirect accordingly
		}


		/*if(!stage.types.contains(Staging.StagingType.REVIEW_REQUEST))
		 {*/

		String subject = "${stage} for ${serviceProfile?.service?.serviceName}"
		String description =  params.comment

		def nextStage = Staging.getNextServiceStage("NEW_STAGE", stage)

		ReviewRequest request1 = createNewReviewRequest(serviceProfile, subject, description, stage, nextStage, params)
		
		if(request1)
		{
			NotificationGenerator gen = new NotificationGenerator(g)
			map = gen.notifyReviewRequestUpdate(request1, NotificationGenerator.ReviewRequestUpdates.NEW,
					User.get(new Long(SecurityUtils.subject.principal)))
			
			sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/service/show?serviceProfileId="+serviceProfile.id)

			println "changed successfuly"
			//flash.message = "Request sent successfully and Stage changed to review request"
			//redirect(action: "show", controller: "service", params: [serviceProfileId: profileId])
			res = "success"
			render res
		}
	}


	private ReviewRequest createNewReviewRequest(ServiceProfile serviceProfile, String subject, String description, Staging fromStage, Staging toStage, Object params)
	{
		def reviewRequestInstance = new ReviewRequest()
		def user = User.get(new Long(SecurityUtils.subject.principal))
		bindData(reviewRequestInstance, params, ['fromStage'])
		//reviewRequestInstance.properties['assignees']  = params;
		reviewRequestInstance.dateModified = new Date()
		reviewRequestInstance.dateCreated = new Date()
		reviewRequestInstance.submitter = user
		reviewRequestInstance.subject = subject
		reviewRequestInstance.description = description
		reviewRequestInstance.fromStage = fromStage
		reviewRequestInstance.toStage = toStage


		serviceProfile.addToReviewRequests(reviewRequestInstance)
		serviceProfile.currentReviewRequest = reviewRequestInstance
		serviceProfile.save(flush:true)

		if (reviewRequestInstance.save(flush: true)) {
			return reviewRequestInstance
		}
		else {
			reviewRequestInstance.errors.each { println 'error in saving review request' + it }
			return null
		}
	}


	/*
	 def saveStagingChange= {
	 if(!params.serviceProfileId || !params.nextStageId){
	 flash.message = "Service Profile is not provided properly or some parameters are not valid"
	 //TODO: Redirect properly
	 }
	 def nextStage = Staging.get(params.nextStageId)
	 if(!nextStage)
	 {
	 flash.message = "Next stage is not valid"
	 //TODO: Redirect properly
	 }
	 def profileId = params.serviceProfileId
	 def serviceProfile = ServiceProfile.get(params.serviceProfileId)
	 if(!serviceProfile)
	 {
	 flash.message = "Service profile is not valid"
	 //TODO: Redirect properly
	 }
	 if(nextStage == serviceProfile.stagingStatus)
	 {
	 flash.message = "Stages can not be the same"
	 //TODO: redirect properly
	 }
	 def action = Staging.getStageChangeActionString(serviceProfile.stagingStatus, nextStage);
	 def stagingLogInstance = new StagingLog()
	 stagingLogInstance.properties['fromStage','comment'] = params
	 stagingLogInstance.toStage = nextStage
	 stagingLogInstance.action = action
	 stagingLogInstance.dateModified = new Date()
	 stagingLogInstance.modifiedBy = session.user?.toString()
	 println stagingLogInstance.modifiedBy
	 serviceProfile.addToStagingLogs(stagingLogInstance)
	 serviceProfile.stagingStatus = nextStage
	 if (serviceProfile.save(flush:true)) {
	 flash.message = "Stage changed successfully"
	 redirect(action: "show", controller: "service", params: [serviceProfileId: serviceProfile.id])
	 }
	 else {
	 println "Can't save"
	 //TODO: Redirect proeprly
	 }
	 } */

	def create = {
		def stagingInstance = new Staging()
		stagingInstance.properties = params
		return [stagingInstance: stagingInstance]
	}

	def createsetup = {
		def stagingInstance = new Staging()
		stagingInstance.properties = params
		render(template: "createsetup", model: [stagingInstance: stagingInstance])
	}

	def save = {
		def res = "fail"
		def stagingInstance = new Staging()
		println params
		stagingInstance.properties = params
		if (stagingInstance.save(flush: true))
		{
			// flash.message = "${message(code: 'default.created.message', args: [message(code: 'staging.label', default: 'Staging'), stagingInstance.id])}"
			// redirect(action: "show", id: stagingInstance.id)
			res = "success"
		}
		else {
			//render(view: "create", model: [stagingInstance: stagingInstance])
		}
		render res
	}

	def show = {
		def stagingInstance = Staging.get(params.id)
		if (!stagingInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'staging.label', default: 'Staging'), params.id])}"
			redirect(action: "list")
		}
		else {

			render(template: "/staging/show", model: [stagingInstance: stagingInstance]);
		}
	}

	def showsetup = {
		def stagingInstance = Staging.get(params.id)
		if (!stagingInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'staging.label', default: 'Staging'), params.id])}"
			redirect(action: "list")
		}
		else {
			render(template: "showsetup", model: [stagingInstance: stagingInstance])

		}
	}

	def edit = {
		def stagingInstance = Staging.get(params.id)
		if (!stagingInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'staging.label', default: 'Staging'), params.id])}"
			redirect(action: "list")
		}
		else {
			return [stagingInstance: stagingInstance]
		}
	}

	def editsetup = {
		def stagingInstance = Staging.get(params.id)
		if (!stagingInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'staging.label', default: 'Staging'), params.id])}"
			redirect(action: "list")
		}
		else {
			render(template: "editsetup", model: [stagingInstance: stagingInstance]);
		}
	}


	def update = {
		def res = "fail"
		def stagingInstance = Staging.get(params.id)
		if (stagingInstance) {
			if (params.version) {
				def version = params.version.toLong()
				if (stagingInstance.version > version) {

					stagingInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [
						message(code: 'staging.label', default: 'Staging')]
					as Object[], "Another user has updated this Staging while you were editing")
					//render(view: "edit", model: [stagingInstance: stagingInstance])
					//render res
					//return
				}
			}
			stagingInstance.properties = params
			if (!stagingInstance.hasErrors() && stagingInstance.save(flush: true)) {
				//flash.message = "${message(code: 'default.updated.message', args: [message(code: 'staging.label', default: 'Staging'), stagingInstance.id])}"
				//redirect(action: "show", id: stagingInstance.id)
				res = "success"
			}
			else {
				//render(view: "edit", model: [stagingInstance: stagingInstance])
			}
		}
		else {
			//flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'staging.label', default: 'Staging'), params.id])}"
			//redirect(action: "list")
		}
		render res
	}

	def deletesetup = {
		def stagingInstance = Staging.get(params.id)
		if (stagingInstance) {
			try {
				stagingInstance.delete(flush: true)
				render "success"
			}
			catch (org.springframework.dao.DataIntegrityViolationException e) {
				flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'staging.label', default: 'Staging'), params.id])}"
				redirect(action: "show", id: params.id)
			}
		}
		else {
			//flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'geo.label', default: 'Geo'), params.id])}"
			redirect(action: "stagingList")
		}
	}

	def delete = {
		def stagingInstance = Staging.get(params.id)
		if (stagingInstance) {
			try {
				stagingInstance.delete(flush: true)
				flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'staging.label', default: 'Staging'), params.id])}"
				redirect(action: "stagingList")
			}
			catch (org.springframework.dao.DataIntegrityViolationException e) {
				//flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'staging.label', default: 'Staging'), params.id])}"
				//redirect(action: "show", id: params.id)
			}
		}
		else {
			//flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'staging.label', default: 'Staging'), params.id])}"
			redirect(action: "stagingList")
		}
	}
}
