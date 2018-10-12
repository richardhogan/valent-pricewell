package com.valent.pricewell

import org.apache.shiro.SecurityUtils

class ReviewCommentController {
	
	def serviceStagingService
	def sendMailService
    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}
	
    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [reviewCommentInstanceList: ReviewComment.list(params), reviewCommentInstanceTotal: ReviewComment.count()]
    }

	def listComments= {
		if(params.id)
		{
			def reviewRequest = ReviewRequest.get(params.id)
			User user = User.get(new Long(SecurityUtils.subject.principal))
			if(reviewRequest.serviceProfile!= null)
			{
				ServiceProfileSecurityProvider profileSecurity =
											new ServiceProfileSecurityProvider(reviewRequest.serviceProfile, user)
											
				render(template: "listComments", model:[reviewRequestInstance: reviewRequest, commentAllowed: profileSecurity.isCommentAllowed(reviewRequest), statusChangeAllowed: profileSecurity.isStatusChangedAllowed(reviewRequest)])
			}
		}
	}
	
	
	def create = {
	        def reviewCommentInstance = new ReviewComment()
	        reviewCommentInstance.properties = params
	        return [reviewCommentInstance: reviewCommentInstance]
	    }

	def addComment = 
	{
		if(!params.id)
		{
			flash.message = "Invalid Request";
			//TODO: Redirect appropriately
		}
		
		def reviewCommentInstance = new ReviewComment()
		reviewCommentInstance.properties = params
		def reviewRequest = ReviewRequest.get(params.id)
		User user = User.get(new Long(SecurityUtils.subject.principal))
		if(reviewRequest.serviceProfile!= null)
		{
			ServiceProfileSecurityProvider profileSecurity =
											new ServiceProfileSecurityProvider(reviewRequest.serviceProfile, user)
			
			render(template:"createComment",
						 model:[reviewCommentInstance: reviewCommentInstance,reviewRequestId:params.id, commentAllowed: profileSecurity.isCommentAllowed(reviewRequest), statusChangeAllowed: profileSecurity.isStatusChangedAllowed(reviewRequest) ])
		}
	}
	
	def editComment = {
		def reviewCommentInstance = ReviewComment.get(params.id)
		if (!reviewCommentInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'reviewComment.label', default: 'ReviewComment'), params.id])}"
			
		}
		else {
			return render (template: editComment,model:[reviewCommentInstance: reviewCommentInstance])
		}
	}

	def save = {
		def res = "fail"
		flash.message = "";
		def map = [:]
		def reviewCommentInstance = new ReviewComment()
		def user = User.get(new Long(SecurityUtils.subject.principal))
		reviewCommentInstance.submitter = user
		reviewCommentInstance.dateModified = new Date()
		reviewCommentInstance.dateCreated = new Date()
		reviewCommentInstance.comment = params.comment
		def reviewRequest= ReviewRequest.get(params.reviewRequestId)
		boolean statusChanged = false;
		if(params.status)
		{
			reviewCommentInstance.statusChanged = "Stage changed from ${reviewRequest.status} to ${params.status}."
			
			reviewRequest.properties = params
			reviewRequest.dateModified = new Date()
			if(reviewRequest.status == ReviewRequest.Status.APPROVED)
			{
				reviewRequest.open = false;
				if(reviewRequest.serviceProfile!=null)
				{
					if(!serviceStagingService.changeStaging(reviewRequest.serviceProfile, reviewRequest.toStage, "Approved by ${user}"))
					{
						//TODO: Something wrong handle it properly
					}
					
					flash.message = "${message(code: 'reviewRequest.approved.message.success.flash', args: [reviewRequest.toStage.name])}"
				}
			}
			else if(reviewRequest.status == ReviewRequest.Status.REJECTED)
			{
				reviewRequest.open = false;
				if(reviewRequest.serviceProfile!=null)
				{
					Staging prevStage = Staging.getPreviousStage("NEW_STAGE", reviewRequest.fromStage)
					if(!serviceStagingService.changeStaging(reviewRequest.serviceProfile, prevStage, "Rejected by ${user}"))
					{
						//TODO: Something wrong handle it properly
					}
					
					flash.message = "${message(code: 'reviewRequest.rejected.message.success.flash', args: [prevStage.name])}"
				}
			}
			
			statusChanged = true
		}
		reviewCommentInstance.reviewRequest = reviewRequest
		
		if(!reviewRequest)
		{
			flash.message = "Review Request is not valid"
		}
		
		reviewRequest.addToReviewComments(reviewCommentInstance)
		
		if(reviewRequest.save(flush:true) && reviewRequest.serviceProfile!=null)
		{
			NotificationGenerator gen = new NotificationGenerator(g)
			map = gen.notifyReviewCommentsToUsers(reviewRequest, statusChanged, User.get(new Long(SecurityUtils.subject.principal)))
			sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/service/show?serviceProfileId="+reviewRequest.serviceProfile.id)
			
			res = "success"
			render res
			/*if(params.source && params.source == "serviceProfile"){
				redirect(controller: "service", action:"show", params: ["serviceProfileId": reviewRequest.serviceProfile?.id])	
			}
			
			if(flash.message && flash.message.size() == 0)
				flash.message = "Comment updated successfully"
			redirect(controller: "service", action:show, params: ["serviceProfileId": reviewRequest.serviceProfile?.id])
			*/
			//render(template: "listComments", model: [reviewRequestInstance: reviewRequest])
			
		}
		else
		{
			render res
		}
	}
	
	def saveComment = {
		def res = "fail"
		flash.message = "";
		def map = [:]
		def reviewCommentInstance = new ReviewComment()
		def user = User.get(new Long(SecurityUtils.subject.principal))
		reviewCommentInstance.submitter = user
		reviewCommentInstance.dateModified = new Date()
		reviewCommentInstance.dateCreated = new Date()
		reviewCommentInstance.properties['comment'] = params
		def reviewRequestId = params.reviewRequestId
		def reviewRequest= ReviewRequest.get(reviewRequestId)
		boolean statusChanged = false;
		
		reviewCommentInstance.reviewRequest = reviewRequest
		
		if(!reviewRequest)
		{
			flash.message = "Review Request is not valid"
		}
		
		reviewRequest.addToReviewComments(reviewCommentInstance)
		
		if(reviewRequest.save(flush:true))
		{
		
			NotificationGenerator gen = new NotificationGenerator(g)
			map = gen.notifyReviewCommentsToUsers(reviewRequest, statusChanged, User.get(new Long(SecurityUtils.subject.principal)))
			sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"])
			
			
			if(params.source && params.source == "serviceProfile"){
				redirect(controller: "service", action:show, params: ["serviceProfileId": reviewRequest.serviceProfile?.id])
			}
			
			if(params.source && params.source == "reviewRequest"){
				redirect( action:listComments, params: ["id": reviewRequest.id])
			}
			
			res = "success"
			render res
			/*
			if(flash.message && flash.message.length == 0)
				flash.message = "Comment updated successfully"
			redirect( action: "listComments", params: ["id": reviewRequest.id])*/
		}
		
	}
	
	
    def show = {
        def reviewCommentInstance = ReviewComment.get(params.id)
        if (!reviewCommentInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'reviewComment.label', default: 'ReviewComment'), params.id])}"
            redirect(action: "list")
        }
        else {
            [reviewCommentInstance: reviewCommentInstance]
        }
    }

    def edit = {
        def reviewCommentInstance = ReviewComment.get(params.id)
        if (!reviewCommentInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'reviewComment.label', default: 'ReviewComment'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [reviewCommentInstance: reviewCommentInstance]
        }
    }

    def update = {
        def reviewCommentInstance = ReviewComment.get(params.id)
        if (reviewCommentInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (reviewCommentInstance.version > version) {
                    
                    reviewCommentInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'reviewComment.label', default: 'ReviewComment')] as Object[], "Another user has updated this ReviewComment while you were editing")
                    render(view: "edit", model: [reviewCommentInstance: reviewCommentInstance])
                    return
                }
            }
            reviewCommentInstance.properties = params
            if (!reviewCommentInstance.hasErrors() && reviewCommentInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'reviewComment.label', default: 'ReviewComment'), reviewCommentInstance.id])}"
                redirect(action: "show", id: reviewCommentInstance.id)
            }
            else {
                render(view: "edit", model: [reviewCommentInstance: reviewCommentInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'reviewComment.label', default: 'ReviewComment'), params.id])}"
            redirect(action: "list")
        }
    }
	def updateComment = {
		
		def reviewCommentInstance = ReviewComment.get(params.id)
		if (reviewCommentInstance) {
			if (params.version) {
				def version = params.version.toLong()
				if (reviewCommentInstance.version > version) {
					
					reviewCommentInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'reviewComment.label', default: 'ReviewComment')] as Object[], "Another user has updated this ReviewComment while you were editing")
					render(view: "edit", model: [reviewCommentInstance: reviewCommentInstance])
					return
				}
			}
			reviewCommentInstance.properties = params
			if (!reviewCommentInstance.hasErrors() && reviewCommentInstance.save(flush: true)) {
				flash.message = "${message(code: 'default.updated.message', args: [message(code: 'reviewComment.label', default: 'ReviewComment'), reviewCommentInstance.id])}"
				redirect(action: "listComments", id: reviewCommentInstance?.reviewRequestInstance?.id)
			}
			else {
				render(view: "edit", model: [reviewCommentInstance: reviewCommentInstance])
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'reviewComment.label', default: 'ReviewComment'), params.id])}"
			//redirect(action: "list")
		}
	}

    def delete = {
        def reviewCommentInstance = ReviewComment.get(params.id)
        if (reviewCommentInstance) {
            try {
                reviewCommentInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'reviewComment.label', default: 'ReviewComment'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'reviewComment.label', default: 'ReviewComment'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'reviewComment.label', default: 'ReviewComment'), params.id])}"
            redirect(action: "list")
        }
    }
}
