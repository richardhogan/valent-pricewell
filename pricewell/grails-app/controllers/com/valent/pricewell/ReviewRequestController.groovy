package com.valent.pricewell
import grails.plugins.nimble.core.*

import org.apache.shiro.SecurityUtils

class ReviewRequestController {

	static allowedMethods = [save: "POST", update: "POST", delete: "POST"]
	def sendMailService, userService

	def index = {

		redirect(action: "inbox", params: params)
	}

	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}
	
	def inbox = {

		def user = User.get(new Long(SecurityUtils.subject.principal))

		def notificationList = Notification.listUserNotifications(user,null)
		//println notificationList

		def notificationPending = Notification.listUserNotifications(user, "active")


		def requestsList = ReviewRequest.findAll("FROM ReviewRequest rq WHERE rq.serviceProfile != null ORDER BY dateModified DESC")

		def reviewRequestList = []
		for(ReviewRequest rq in requestsList)
		{
			if(user in rq.assignees)
			{
				if(rq.status == ReviewRequest.Status.REVIEW)
					reviewRequestList.add(rq)
			}
		}


		//reviewRequestList = requestsList//.sort{x,y -> y.dateModified <=> x.dateModified}
		render(view: "inbox", model: [notificationPending: notificationPending, notificationInstanceList: notificationList, notificationInstanceTotal: notificationList.size(), reviewRequestInstanceList: reviewRequestList, reviewRequestInstanceTotal: reviewRequestList.size(), title: "My Assigned Review Requests", category: "myAssigned", type: "Pending"])
	}

	static navigation = [
		[group:'review', action:'myAssigned', order: 0],
		[action:'mySubmitted', order: 5],
		[action:'all', order: 10],
	]

	def list = {
		if(params.category != null || params.category != "")
		{
			redirect(action: params.category, params: params)
		}
		else
		{
			render(template: "list", model: [reviewRequestInstanceList: ReviewRequest.list(params), reviewRequestInstanceTotal: ReviewRequest.count(), title: "All Review Requests", , category: "all"])
		}
	}

	def myAssigned = {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def requestsList = ReviewRequest.findAll("FROM ReviewRequest rq WHERE rq.serviceProfile != null ORDER BY dateModified DESC")
		def reviewRequestList = []
		for(ReviewRequest rq in requestsList)
		{
			if(user in rq.assignees)
			{
				if(params.type == "Pending" && rq.status == ReviewRequest.Status.REVIEW)
					reviewRequestList.add(rq)
				else if(params.type == "Archive" && rq.status != ReviewRequest.Status.REVIEW)
					reviewRequestList.add(rq)
			}
		}
		render(template: "list", model: [reviewRequestInstanceList: reviewRequestList, reviewRequestInstanceTotal: reviewRequestList.size(), title: "My Assigned Review Requests", category: "myAssigned", type: params.type])
	}

	def mySubmitted = {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def requestsList = ReviewRequest.findAll("FROM ReviewRequest rq WHERE rq.serviceProfile != null ORDER BY dateModified DESC")
		def reviewRequestList = []
		for(ReviewRequest rq in requestsList)
		{
			if(user.id == rq.submitter.id)
			{
				if(params.type == "Pending" && rq.status == ReviewRequest.Status.REVIEW)
					reviewRequestList.add(rq)
				else if(params.type == "Archive" && rq.status != ReviewRequest.Status.REVIEW)
					reviewRequestList.add(rq)
			}
		}

		render(template: "list", model: [reviewRequestInstanceList: reviewRequestList, reviewRequestInstanceTotal: reviewRequestList.size(), title: "My Submitted Review Requests", category: "mySubmitted", type: params.type])
	}

	def all = {

		def reviewRequestList = []
		for(ReviewRequest rq in ReviewRequest.list())
		{
			if(rq?.serviceProfile != null)
			{
				if(params.type == "Pending" && rq.status == ReviewRequest.Status.REVIEW)
					reviewRequestList.add(rq)
				else if(params.type == "Archive" && rq.status != ReviewRequest.Status.REVIEW)
					reviewRequestList.add(rq)
			}
		}
		render(template: "list", model:[reviewRequestInstanceList: reviewRequestList, reviewRequestInstanceTotal: reviewRequestList.size(), title: "All Review Requests", category: "all", type: params.type])
	}

	def showFromStaging = {
		def reviewRequestInstance = ReviewRequest.get(params.requestId)
		if (!reviewRequestInstance) {
			flash.message = "Error while creating review request"
			redirect(action: "list")
		}
		else {
			boolean submitterLoggedIn = (reviewRequestInstance?.submitter.id == new Long(SecurityUtils.subject.principal))
			[reviewRequestInstance: reviewRequestInstance,submitterLoggedIn: submitterLoggedIn ]
		}
	}

	def create = {
		def serviceProfileId = params.serviceProfileId
		def userId = params.userId
		def reviewRequestInstance = new ReviewRequest()
		reviewRequestInstance.properties = params
		//println params.category +" "+ params.type
		List userList = userService.filterUserList(User.list())
		return [reviewRequestInstance: reviewRequestInstance,serviceProfileId: serviceProfileId,userId: userId,category: params.category, type: params.type, userList: userList]

	}

	def save = {
		def res = "fail"
		println params
		def serviceProfileId = params.serviceProfileId
		def serviceProfile = ServiceProfile.get(serviceProfileId)
		println serviceProfile
		def reviewRequestInstance = new ReviewRequest()
		def user = User.get(new Long(SecurityUtils.subject.principal))
		bindData(reviewRequestInstance, params, ['fromStage'])
		//reviewRequestInstance.properties['assignees']  = params;
		reviewRequestInstance.dateModified = new Date()
		reviewRequestInstance.dateCreated = new Date()
		reviewRequestInstance.submitter = user
		reviewRequestInstance.subject = params.subject
		reviewRequestInstance.description = params.description


		serviceProfile.addToReviewRequests(reviewRequestInstance)
		serviceProfile.currentReviewRequest = reviewRequestInstance
		serviceProfile.save(flush:true)
		def map=[:]
		if (reviewRequestInstance.save(flush: true))
		{
			println reviewRequestInstance
			NotificationGenerator gen = new NotificationGenerator(g)
			map = gen.notifyReviewRequestUpdate(reviewRequestInstance, NotificationGenerator.ReviewRequestUpdates.NEW,
					User.get(new Long(SecurityUtils.subject.principal)))
			sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/service/show?serviceProfileId="+serviceProfile.id)
			println map
			if(params.source == "inbox")
			{
				res = "success"
				render res
				return
			}
			flash.message = "${message(code: 'default.created.message', args: [message(code: 'reviewRequest.label', default: 'ReviewRequest'), reviewRequestInstance.id])}"
			redirect(action: "show", id: reviewRequestInstance.id)
		}
		else {
			if(params.source == "inbox")
			{

				render res
				return
			}
			render(view: "create", model: [reviewRequestInstance: reviewRequestInstance])
		}
	}


	def show = {
		def reviewRequestInstance = ReviewRequest.get(params.id)
		if (!reviewRequestInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'reviewRequest.label', default: 'ReviewRequest'), params.id])}"
			redirect(action: "list")
		}
		else {
			boolean submitterLoggedIn = (reviewRequestInstance?.submitter.id == new Long(SecurityUtils.subject.principal))
			User user = User.get(new Long(SecurityUtils.subject.principal))
			ServiceProfileSecurityProvider profileSecurity =null
			def listBtn ="yes"
			if(reviewRequestInstance.serviceProfile!= null)
			{
				if(params.notificationId)
				{
					def note = Notification.get(params.notificationId)
					note.active = false
					listBtn = "no"
					note.save(flush:true)
				}

				ServiceProfile serviceProfileInstance = ServiceProfile.get(reviewRequestInstance.serviceProfile.id)
				profileSecurity = new ServiceProfileSecurityProvider(reviewRequestInstance.serviceProfile, user)

				if(params.source){

					session["reviewShowSource"] = params.source
				}

				if(params.sourceFrom == "serviceProfile" )
				{
					session["reviewShowSource"] = params.sourceFrom
					render(template: "showFromWizard", model: [serviceProfileInstance: serviceProfileInstance, reviewRequestInstance: reviewRequestInstance,submitterLoggedIn: submitterLoggedIn, commentAllowed: profileSecurity.isCommentAllowed(reviewRequestInstance), statusChangeAllowed: profileSecurity.isStatusChangedAllowed(reviewRequestInstance), source: session["reviewShowSource"] ])
				}
				else if(params.source == "serviceProfile" )
				{
					render(view: "showFromService", model: [reviewRequestInstance: reviewRequestInstance,submitterLoggedIn: submitterLoggedIn, commentAllowed: profileSecurity.isCommentAllowed(reviewRequestInstance), statusChangeAllowed: profileSecurity.isStatusChangedAllowed(reviewRequestInstance), source: session["reviewShowSource"] ])
				}
				else
				{
					session["reviewShowSource"] = "inbox"
					[listBtn: listBtn, reviewRequestInstance: reviewRequestInstance, category: params.category, type: params.type, submitterLoggedIn: submitterLoggedIn, commentAllowed: profileSecurity.isCommentAllowed(reviewRequestInstance), statusChangeAllowed: profileSecurity.isStatusChangedAllowed(reviewRequestInstance), source: session["reviewShowSource"] ]
				}

			}
		}
	}

	def showFromWizard = {
		def reviewRequestInstance = ReviewRequest.get(params.id)
		def serviceProfileInstance = ServiceProfile.get(params.serviceProfileId)
		if (!reviewRequestInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'reviewRequest.label', default: 'ReviewRequest'), params.id])}"
			redirect(action: "list")
		}
		else {
			boolean submitterLoggedIn = (reviewRequestInstance?.submitter.id == new Long(SecurityUtils.subject.principal))
			User user = User.get(new Long(SecurityUtils.subject.principal))
			ServiceProfileSecurityProvider profileSecurity =
					new ServiceProfileSecurityProvider(reviewRequestInstance.serviceProfile, user)

			if(params.source){
				session["reviewShowSource"] = params.source
			}
			//profileSecurity.isStatusChangedAllowed(reviewRequestInstance)
			render(view: "showFromWizard", model: [serviceProfileInstance: serviceProfileInstance, reviewRequestInstance: reviewRequestInstance,submitterLoggedIn: submitterLoggedIn, commentAllowed: profileSecurity.isCommentAllowed(reviewRequestInstance), statusChangeAllowed: profileSecurity.isStatusChangedAllowed(reviewRequestInstance) ]);
		}
	}

	def showdialog = {
		def reviewRequestInstance = ReviewRequest.get(params.id)
		if (!reviewRequestInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'reviewRequest.label', default: 'ReviewRequest'), params.id])}"
			redirect(action: "list")
		}
		else {
			boolean submitterLoggedIn = (reviewRequestInstance?.submitter.id == new Long(SecurityUtils.subject.principal))
			User user = User.get(new Long(SecurityUtils.subject.principal))
			ServiceProfileSecurityProvider profileSecurity =
					new ServiceProfileSecurityProvider(reviewRequestInstance.serviceProfile, user)
			[reviewRequestInstance: reviewRequestInstance,submitterLoggedIn: submitterLoggedIn, commentAllowed: profileSecurity.isCommentAllowed(reviewRequestInstance), statusChangeAllowed: profileSecurity.isStatusChangedAllowed(reviewRequestInstance) ]
		}
	}



	def edit = {
		println params.category +" "+ params.type +" "+ params.id
		boolean hideUpperNav = false
		def reviewRequestInstance = ReviewRequest.get(params.id)
		if (!reviewRequestInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'reviewRequest.label', default: 'ReviewRequest'), params.id])}"
			redirect(action: "list",  params: [category: params.category, type: params.type])
		}
		else {
			ServiceProfileSecurityProvider profileSecurity = new ServiceProfileSecurityProvider(reviewRequestInstance.serviceProfile)
			Set tmpSet = new HashSet()
			tmpSet = profileSecurity.listAuthorizedUsers()
			List usersList = new ArrayList()
			for(UserBase user : tmpSet.toList())
			{
				if(user.username != "superadmin")
				{
					usersList.add(user)
				}
			}
			
			if(params.sourceFrom == "serviceProfile")
			{
				hideUpperNav = true
			}
			return [reviewRequestInstance: reviewRequestInstance, usersList: usersList, category: params.category, type: params.type, hideUpperNav: hideUpperNav, sourceFrom: params.sourceFrom]
		}
	}

	def update = {
		def reviewRequestInstance = ReviewRequest.get(params.id)
		if (reviewRequestInstance) {
			if (params.version) {
				def version = params.version.toLong()
				if (reviewRequestInstance.version > version) {

					reviewRequestInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [
						message(code: 'reviewRequest.label', default: 'ReviewRequest')]
					as Object[], "Another user has updated this ReviewRequest while you were editing")
					render(view: "edit", model: [reviewRequestInstance: reviewRequestInstance, category: params.category, type: params.type])
					return
				}
			}
			reviewRequestInstance.properties = params
			if (!reviewRequestInstance.hasErrors() && reviewRequestInstance.save(flush: true)) {
				flash.message = "${message(code: 'default.updated.message', args: [message(code: 'reviewRequest.label', default: 'ReviewRequest'), reviewRequestInstance.id])}"
				redirect(action: "show", id: reviewRequestInstance.id, params: [category: params.category, type: params.type, source: params.source, sourceFrom: params.sourceFrom])
			}
			else {
				render(view: "edit", model: [reviewRequestInstance: reviewRequestInstance, category: params.category, type: params.type])
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'reviewRequest.label', default: 'ReviewRequest'), params.id])}"
			redirect(action: "list", params: [category: params.category, type: params.type])
		}
	}

	def delete = {
		def reviewRequestInstance = ReviewRequest.get(params.id)
		if (reviewRequestInstance) {
			try {
				reviewRequestInstance.delete(flush: true)
				flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'reviewRequest.label', default: 'ReviewRequest'), params.id])}"
				redirect(action: "list", params: [category: params.category, type: params.type])
			}
			catch (org.springframework.dao.DataIntegrityViolationException e) {
				flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'reviewRequest.label', default: 'ReviewRequest'), params.id])}"
				redirect(action: "show", id: params.id, params: [category: params.category, type: params.type])
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'reviewRequest.label', default: 'ReviewRequest'), params.id])}"
			redirect(action: "list", params: [category: params.category, type: params.type])
		}
	}
}
