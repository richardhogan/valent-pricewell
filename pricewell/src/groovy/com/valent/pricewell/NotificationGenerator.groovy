package com.valent.pricewell
import java.util.List;

import grails.plugins.nimble.core.Role;
import grails.plugins.nimble.core.UserBase
import org.apache.shiro.SecurityUtils;

class NotificationGenerator 
{
	ServiceCatalogService serviceCatalogService
	SendMailService sendMailService
	
	void generateNotifications()
	{
		
	}
	def g;
	
	public NotificationGenerator(Object g){
		this.g = g;	
	}
	
	public enum ReviewRequestUpdates {NEW, COMMENT, APPROVE, REJECT, PUBLISH}
	
	def notifyReviewCommentsToUsers(ReviewRequest request, boolean statusChanged, User loginUser)
	{
		NotificationGenerator.ReviewRequestUpdates updateStatus = NotificationGenerator.ReviewRequestUpdates.COMMENT
		def map = [:]
		if(statusChanged)
		{
			switch(request.status)
			{
				case ReviewRequest.Status.REJECTED:
				case ReviewRequest.Status.CANCELLED:
					updateStatus = NotificationGenerator.ReviewRequestUpdates.REJECT
					break;
				case ReviewRequest.Status.APPROVED:
					if(request.serviceProfile!=null)
					{
						if(request.serviceProfile.type == ServiceProfile.ServiceProfileType.PUBLISHED)
						{
							updateStatus = NotificationGenerator.ReviewRequestUpdates.PUBLISH
						}
						else
						{
							updateStatus = NotificationGenerator.ReviewRequestUpdates.APPROVE
						}
					}
					else  //This is for quotation's review request.....
					{
						updateStatus = NotificationGenerator.ReviewRequestUpdates.APPROVE
					}
					break;
			}
		}
		
		map = notifyReviewRequestUpdate(request, updateStatus, loginUser)
		
		return map
	}
	
	def notifyReviewRequestUpdate(ReviewRequest request, ReviewRequestUpdates update, User loginUser)
	{
		
		ReviewRequest reviewRequest = null
		def reviewComment="", objectType="", objectId="", notiMsg="", emailMsg="", notiSubject=""
		def receiverUsers = [], receiverGroups = []
		reviewRequest = request
		
		if(request.reviewComments)
		{
			def commentsList = ReviewComment.findAll("FROM ReviewComment rc WHERE rc.reviewRequest.id=:rid ORDER BY rc.dateModified DESC", [rid: request.id])
			if(commentsList.size() > 0)
			{
				def comment = commentsList[0].comment
				reviewComment = comment
				
			}
		}
		if(request.serviceProfile!=null)
		{
			objectType = "ServiceProfile"
			
			objectId = request?.serviceProfile.id
		}
		else
		{
			objectType = "Quotation"
			objectId = request?.quotation.id
		}
		
		String subject = "Service Notification"
		String emailMessage = "";
		
		switch(update)
		{
			case ReviewRequestUpdates.NEW:
				receiverUsers.addAll(request?.assignees)
				if(request.fromStage != null)
				{
					notiMsg = g.message(code: "notification.review.create", args: ["${request?.fromStage?.displayName}", "${request?.serviceProfile}"]);
					emailMessage = g.message(code: "notification.review.create.email.message", args: ["${request?.fromStage?.displayName}", "${request?.serviceProfile}"]);
					subject = g.message(code: "notification.review.create.email.subject", args: ["${request?.fromStage?.displayName} for ${request?.serviceProfile}"]);
				}
				else
				{
					notiMsg = g.message(code: "notification.review.create.withoutstage", args: [ "${request?.serviceProfile}"]);
					emailMessage = g.message(code: "notification.review.create.email.message.withoutstage", args: [ "${request?.serviceProfile}"]);
					subject = g.message(code: "notification.review.create.email.subject", args: ["for ${request?.serviceProfile}"]);

				}
				break;
				
			case ReviewRequestUpdates.COMMENT:
				receiverUsers.add(request.submitter)
				notiMsg = g.message(code: "notification.review.comment", args: ["${request?.fromStage?.displayName}", "${request?.serviceProfile}", "${loginUser}"]);
				emailMessage = g.message(code: "notification.review.comment.email.message", args: ["${request?.fromStage?.displayName}", "${request?.serviceProfile}", "${loginUser}"]);
				subject = g.message(code: "notification.review.comment.email.subject", args: ["${request?.fromStage?.displayName} for ${request?.serviceProfile}"]);
				break;
				
			case ReviewRequestUpdates.APPROVE:
				receiverUsers.add(request.submitter)
				notiMsg = g.message(code: "notification.review.approve", args: ["${request?.fromStage?.displayName}", "${request?.serviceProfile}", "${loginUser}"]);
				emailMessage = g.message(code: "notification.review.approve.email.message", args: ["${request?.fromStage?.displayName}", "${request?.serviceProfile}", "${loginUser}"]);
				subject = g.message(code: "notification.review.approve.email.subject", args: ["${request?.fromStage?.displayName} for ${request?.serviceProfile}"]);
				break;
				
			case ReviewRequestUpdates.REJECT:
				receiverUsers.add(request.submitter)
				notiMsg = g.message(code: "notification.review.reject", args: ["${request?.fromStage?.displayName}", "${request?.serviceProfile}", "${loginUser}"]);
				emailMessage = g.message(code: "notification.review.reject.email.message", args: ["${request?.fromStage?.displayName}", "${request?.serviceProfile}", "${loginUser}"]);
				subject = g.message(code: "notification.review.reject.email.subject", args: ["${request?.fromStage?.displayName} for ${request?.serviceProfile}"]);
				break;
				
			case ReviewRequestUpdates.PUBLISH:
				receiverGroups.add(RoleId.SALES_PERSON)
				receiverUsers.add(request.submitter)
				notiMsg = g.message(code: "notification.review.publish", args: ["${request?.serviceProfile}", "${loginUser}"]);
				emailMessage = g.message(code: "notification.review.publish.email.message", args: ["${request?.serviceProfile}", "${loginUser}"]);
				subject = g.message(code: "notification.review.publish.email.subject", args: ["${request?.serviceProfile}"]);
				
				break;
		}
		
		
		if(receiverGroups.size() > 0)
		{
			List receivers = findUsersByRole("SALES PERSON")
			for(User us in receivers)
			{
				receiverUsers.add(us)
			}
			
			//return ["message": emailMessage, "subject": subject, "receiverList": receiverUsers]
			//sendEmailNotification(note.message, subject, note.receiverGroups)
		}
		if(receiverUsers.size() > 0)
		{
			for(User receiver : receiverUsers)
			{
				def note = new Notification()
				note.reviewRequest = reviewRequest
				note.comment = reviewComment
				note.objectType = objectType
				note.objectId = objectId
				note.dateCreated = new Date()
				note.active = true
				note.message = notiMsg
				note.receiverUsers = [receiver]
				note.receiverGroups = new ArrayList()
				note.save(flush:true)
			}
			return ["message": emailMessage, "subject": subject, "receiverList": receiverUsers]
			//sendEmailNotification(note.message, subject, note.receiverUsers)
		}
		
	}
	
	public List findUsersByRole(String roleName)
	{
		List tmpList = new ArrayList()
		for(UserBase user in Role.findByCode(roleName)?.users)//User user in Role.findByCode(roleName)?.users)
		{
			tmpList.add(User.get(user.id))
		}
		
		return tmpList
	}
	
	def sendAssignedToConceptuzlizeNotification(ServiceProfile serviceProfile)
	{
		println "service name is : "+serviceProfile.service.serviceName
		def note = new Notification()
		note.objectType = "ServiceProfile"
		note.objectId = serviceProfile.id
		note.dateCreated = new Date()
		note.active = true
		
		println "service product manager : " + serviceProfile?.service?.productManager?.id 
		if(serviceProfile?.service?.productManager?.id != null)
			note.receiverUsers = [serviceProfile.service.productManager]
		else note.receiverUsers = new ArrayList()
		note.receiverGroups = new ArrayList()
		//note.message = "You have been assigned as  for  ${serviceProfile}, so define service deliverables."; 
		note.message = g.message(code: "notification.productManagerAssigned", args: ["Product Manager", "${serviceProfile}"]);
		String subject = g.message(code: "notification.productManagerAssigned.email.subject", args: ["Product Manager"]);
		String emailMessage = g.message(code: "notification.productManagerAssigned.email.message", args: ["Product Manager", "${serviceProfile}"]);
		
		
		note.save()//flush:true)	
		if(note.receiverUsers.size() > 0)
		{
			return ["message": emailMessage, "subject": subject, "receiverList": note.receiverUsers]
			//sendEmailNotification(note.message, subject, note.receiverUsers)
		}
		return [:]
	}
	
	def sendServiceImportSuccessNotification(ServiceProfile serviceProfile, User user)
	{
		def note = new Notification()
		note.objectType = "ServiceProfile"
		note.objectId = serviceProfile.id
		note.dateCreated = new Date()
		note.active = true
		note.receiverUsers = [user]
		note.receiverGroups = new ArrayList()
		//note.message = "You have been assigned as  for  ${serviceProfile}, so define service deliverables.";
		note.message = g.message(code: "notification.serviceImportSuccess", args: ["${serviceProfile}"]);
		String subject = g.message(code: "notification.serviceImportSuccess.email.subject");
		String emailMessage = g.message(code: "notification.serviceImportSuccess.email.message", args: ["${serviceProfile}"]);
		
		
		note.save(flush:true)
		if(note.receiverUsers.size() > 0)
		{
			return ["message": emailMessage, "subject": subject, "receiverList": note.receiverUsers]
			//sendEmailNotification(note.message, subject, note.receiverUsers)
		}
		return [:]
	}
	
	def sendCWToPricewellOpportunityImportNotification(Opportunity opportunity, User user)
	{
		def note = new Notification()
		note.objectType = "Opportunity"
		note.objectId = opportunity.id
		note.dateCreated = new Date()
		note.active = true
		note.receiverUsers = [user]
		note.receiverGroups = new ArrayList()
		//note.message = "You have been assigned as  for  ${serviceProfile}, so define service deliverables.";
		note.message = g.message(code: "notification.opportunityImportFromCWSuccess", args: ["${opportunity.name}"]);
		String subject = g.message(code: "notification.opportunityImportFromCWSuccess.email.subject");
		String emailMessage = g.message(code: "notification.opportunityImportFromCWSuccess.email.message", args: ["${opportunity.name}"]);
		
		
		note.save(flush:true)
		if(note.receiverUsers.size() > 0)
		{
			return ["message": emailMessage, "subject": subject, "receiverList": note.receiverUsers]
			//sendEmailNotification(note.message, subject, note.receiverUsers)
		}
		return [:]
	}
	
	def sendSalesforceToPricewellOpportunityImportNotification(Opportunity opportunity, User user)
	{
		def note = new Notification()
		note.objectType = "Opportunity"
		note.objectId = opportunity.id
		note.dateCreated = new Date()
		note.active = true
		note.receiverUsers = [user]
		note.receiverGroups = new ArrayList()
		//note.message = "You have been assigned as  for  ${serviceProfile}, so define service deliverables.";
		note.message = g.message(code: "notification.opportunityImportFromSalesforceSuccess", args: ["${opportunity.name}"]);
		String subject = g.message(code: "notification.opportunityImportFromSalesforceSuccess.email.subject");
		String emailMessage = g.message(code: "notification.opportunityImportFromSalesforceSuccess.email.message", args: ["${opportunity.name}"]);
		
		
		note.save(flush:true)
		if(note.receiverUsers.size() > 0)
		{
			return ["message": emailMessage, "subject": subject, "receiverList": note.receiverUsers]
			//sendEmailNotification(note.message, subject, note.receiverUsers)
		}
		return [:]
	}
	
	def sendAssignedToDesignNotification(ServiceProfile serviceProfile)
	{
		def note = new Notification()
		note.objectType = "ServiceProfile"
		note.objectId = serviceProfile.id
		note.dateCreated = new Date()
		note.active = true
		note.receiverUsers = [serviceProfile.serviceDesignerLead]
		note.receiverGroups = new ArrayList()
		//note.message = "You have been assigned as Service Designer for  ${serviceProfile}, so define service activity and roles.";
		note.message = g.message(code: "notification.serviceDesignerAssigned", args: ["Service Designer", "${serviceProfile}"]);
		String subject = g.message(code: "notification.serviceDesignerAssigned.email.subject", args: ["Service Designer"]);
		String emailMessage = g.message(code: "notification.serviceDesignerAssigned.email.message", args: ["Service Designer", "${serviceProfile}"]);
		
		note.save(flush:true)
		if(note.receiverUsers.size() > 0)
		{
			return ["message": emailMessage, "subject": subject, "receiverList": note.receiverUsers]
			//sendEmailNotification(note.message, subject, note.receiverUsers)
		}
		return [:]
	}
	
	def sendQuotaAssignedToSalesUserNotification(Quota quotaInstance)
	{
		def note = new Notification()
		note.objectType = "Quota"
		note.objectId = quotaInstance.id
		note.dateCreated = new Date()
		note.active = true
		note.receiverUsers = [quotaInstance.person]
		note.receiverGroups = new ArrayList()
		//note.message = "You have been assigned as Service Designer for  ${serviceProfile}, so define service activity and roles.";
		note.message = g.message(code: "notification.quotaAssigned", args: ["Sales Manager ${quotaInstance.createdBy.profile.fullName}", "Quota"]);
		String subject = g.message(code: "notification.quotaAssigned.email.subject", args: ["Quota"]);
		String emailMessage = g.message(code: "notification.quotaAssigned.email.message", args: ["Sales Manager ${quotaInstance.createdBy.profile.fullName}", "Quota"]);
		
		note.save(flush:true)
		if(note.receiverUsers.size() > 0)
		{
			return ["message": emailMessage, "subject": subject, "receiverList": note.receiverUsers]
			//sendEmailNotification(note.message, subject, note.receiverUsers)
		}
		return [:]
	}
	
	def sendQuotaModifiedToSalesUserNotification(Quota quotaInstance)
	{
		def note = new Notification()
		note.objectType = "Quota"
		note.objectId = quotaInstance.id
		note.dateCreated = new Date()
		note.active = true
		note.receiverUsers = [quotaInstance.person]
		note.receiverGroups = new ArrayList()
		//note.message = "You have been assigned as Service Designer for  ${serviceProfile}, so define service activity and roles.";
		note.message = g.message(code: "notification.quotaModified", args: ["Sales Manager ${quotaInstance.createdBy.profile.fullName}", "Quota"]);
		String subject = g.message(code: "notification.quotaModified.email.subject", args: ["Quota"]);
		String emailMessage = g.message(code: "notification.quotaModified.email.message", args: ["Sales Manager ${quotaInstance.createdBy.profile.fullName}", "Quota"]);
		
		note.save(flush:true)
		if(note.receiverUsers.size() > 0)
		{
			return ["message": emailMessage, "subject": subject, "receiverList": note.receiverUsers]
			//sendEmailNotification(note.message, subject, note.receiverUsers)
		}
		return [:]
	}
	
	def acceptDiscountNotification(Quotation quotationInstance, List userList)
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def message = "Notification for more discount is accepted by ${user} for customer ${quotationInstance.account.accountName}."
		def subject = "Discount Notification"
		for(User receiver : userList)
		{
			def note = new Notification()
			note.objectType = "Quotation"
			note.objectId = quotationInstance.id
			note.dateCreated = new Date()
			note.createdBy = user
			note.active = true
			note.receiverUsers = [receiver]
			note.receiverGroups = new ArrayList()
			note.message = message
	
			
			note.save(flush:true)
		}
		
		if(userList.size() > 0)
		{
			return ["message": message, "subject": subject, "receiverList": userList]
			//sendEmailNotification(note.message, subject, note.receiverUsers)
		}
		return [:]
	}
	
	def rejectDiscountNotification(Quotation quotationInstance, List userList)
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def message = "Notification for more discount is accepted by ${user} for customer ${quotationInstance.account.accountName}."
		def subject = "Discount Notification"
		
		for(User receiver : userList)
		{
			def note = new Notification()
			note.objectType = "Quotation"
			note.objectId = quotationInstance.id
			note.dateCreated = new Date()
			note.createdBy = user
			note.active = true
			note.receiverUsers = [receiver]
			note.receiverGroups = new ArrayList()
			note.message = "Notification for more discount is rejected by ${user} for customer ${quotationInstance.account.accountName}."
	
			
			note.save(flush:true)
		}
		
		if(userList.size() > 0)
		{
			return ["message": message, "subject": subject, "receiverList": userList]
			//sendEmailNotification(note.message, subject, note.receiverUsers)
		}
		return [:]
	}
	
	
	def sendAssignedToPortfolioManagerNotification(Portfolio portfolioInstance)
	{
		def note = new Notification()
		note.objectType = "Portfolio"
		note.objectId = portfolioInstance.id
		note.dateCreated = new Date()
		note.active = true
		note.receiverUsers = [portfolioInstance.portfolioManager]
		note.receiverGroups = new ArrayList()
		note.message = g.message(code: "notification.portfolioManagerAssigned", args: ["Portfolio Manager", "${portfolioInstance}"]);
		String subject = g.message(code: "notification.portfolioManagerAssigned.email.subject", args: ["Portfolio Manager"]);
		String emailMessage = g.message(code: "notification.portfolioManagerAssigned.email.message", args: ["Portfolio Manager", "${portfolioInstance}"]);
		
		note.save(flush:true)
		if(note.receiverUsers.size() > 0)
		{
			return ["message": emailMessage, "subject": subject, "receiverList": note.receiverUsers]
			//sendEmailNotification(note.message, subject, note.receiverUsers)
		}
		return [:]
	}
	
	def sendRequestToDefineRateCostForTerritories(DeliveryRole deliveryRoleInstance, Service serviceInstance, List territoryList)
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def note = new Notification()
		note.objectType = "Delivery Role"
		note.objectId = deliveryRoleInstance.id
		note.dateCreated = new Date()
		note.active = true
		note.receiverUsers = findUsersByRole("SYSTEM ADMINISTRATOR")
		note.receiverGroups = new ArrayList()
		def territoriesName = "", i = 1
		for(Geo territory : territoryList)
		{
			territoriesName = territoriesName + territory.name
			if(i<territoryList.size())
			{
				territoriesName = territoriesName + ", "
				i++
			}
		}
		note.message = g.message(code: "notification.defineRateCostForTerritories", args: [deliveryRoleInstance.name, user.profile.fullName, territoriesName, serviceInstance.serviceName]);
		String subject = g.message(code: "notification.defineRateCostForTerritories.email.subject", args: ["Portfolio Manager", user.profile.fullName, deliveryRoleInstance.name
			]);
		String emailMessage = g.message(code: "notification.defineRateCostForTerritories.email.message", args: [deliveryRoleInstance.name, user.profile.fullName, territoriesName, serviceInstance.serviceName]);
		
		note.save(flush:true)
		if(note.receiverUsers.size() > 0)
		{
			return ["message": emailMessage, "subject": subject, "receiverList": note.receiverUsers]
			//sendEmailNotification(note.message, subject, note.receiverUsers)
		}
		return [:]
	}
	
	def sendAssignedToGeneralManagerNotification(GeoGroup geo)
	{
		def note = new Notification()
		note.objectType = "GEO"
		note.objectId = geo.id
		note.dateCreated = new Date()
		note.active = true
		def generalManagers = []
		for(User gm : geo.generalManagers){
			generalManagers.add(gm)
		}
		note.receiverUsers = generalManagers
		//note.receiverUsers.addAll(geo.generalManagers)
		note.receiverGroups = new ArrayList()
		note.message = g.message(code: "notification.generalManagerAssigned", args: ["General Manager", "${geo}"]);
		String subject = g.message(code: "notification.generalManagerAssigned.email.subject", args: ["General Manager"]);
		String emailMessage = g.message(code: "notification.generalManagerAssigned.email.message", args: ["General Manager", "${geo}"]);
		
		note.save(flush:true)
		
		if(note.receiverUsers.size() > 0)
		{
			return ["message": emailMessage, "subject": subject, "receiverList": note.receiverUsers]
			//sendEmailNotification(note.message, subject, note.receiverUsers)
		}
		return [:]
	}
	
	def sendAssignedToSalesManagerNotification(Geo territory)
	{
		def note = new Notification()
		note.objectType = "Territory"
		note.objectId = territory.id
		note.dateCreated = new Date()
		note.active = true
		note.receiverUsers = [territory.salesManager]
		note.receiverGroups = new ArrayList()
		note.message = g.message(code: "notification.salesManagerAssigned", args: ["Sales Manager", "${territory}"]);
		String subject = g.message(code: "notification.salesManagerAssigned.email.subject", args: ["Sales Manager"]);
		String emailMessage = g.message(code: "notification.salesManagerAssigned.email.message", args: ["Sales Manager", "${territory}"]);
		
		note.save(flush:true)
		if(note.receiverUsers.size() > 0)
		{
			return ["message": emailMessage, "subject": subject, "receiverList": note.receiverUsers]
			//sendEmailNotification(note.message, subject, note.receiverUsers)
		}
		return [:]
	}
	
	def sendAssignedToSalesPersonNotification(Geo territory)
	{
		def note = new Notification()
		note.objectType = "Territory"
		note.objectId = territory.id
		note.dateCreated = new Date()
		note.active = true
		note.receiverUsers = [territory.salesPersons]
		note.receiverGroups = new ArrayList()
		note.message = g.message(code: "notification.salesPersonAssigned", args: ["Sales Person", "${territory}"]);
		String subject = g.message(code: "notification.salesPersonAssigned.email.subject", args: ["Sales Person"]);
		String emailMessage = g.message(code: "notification.salesPersonAssigned.email.message", args: ["Sales Person", "${territory}"]);
		
		note.save(flush:true)
		if(note.receiverUsers.size() > 0)
		{
			return ["message": emailMessage, "subject": subject, "receiverList": note.receiverUsers]
			//sendEmailNotification(note.message, subject, note.receiverUsers)
		}
		return [:]
	}
	
	def sendAssignedToNotification(Object ob, def type)
	{
		def note = new Notification()
		note.objectType = type
		note.objectId = ob.id
		note.dateCreated = new Date()
		note.active = true
		note.receiverUsers = [ob.assignTo]
		note.receiverGroups = new ArrayList()
		def name = ""
		if(type == "Account")
			{name = ob.accountName;	}
		else if(type == "Contact" || type == "Lead")
			{name = ob.firstname +" "+ ob.lastname;	}
		else if(type == "Opportunity")
			{name = ob.name;}
		
		note.message = g.message(code: "notification.assigned", args: [type, name]);
		String subject = g.message(code: "notification.assigned.email.subject", args: [type]);
		String emailMessage = g.message(code: "notification.assigned.email.message", args: [type, name]);
		
		note.save(flush:true)
		if(note.receiverUsers.size() > 0)
		{
			return ["message": emailMessage, "subject": subject, "receiverList": note.receiverUsers]
			//sendEmailNotification(note.message, subject, note.receiverUsers)
		}
		return [:]
	}
	
	def changeAssignedToNotification(Object ob, User user, def type)
	{
		def note = new Notification()
		note.objectType = type
		note.objectId = ob.id
		note.dateCreated = new Date()
		note.active = true
		note.receiverUsers = [user]
		note.receiverGroups = new ArrayList()
		def name = ""
		if(type == "Account")
			{name = ob.accountName;	}
		else if(type == "Contact" || type == "Lead")
			{name = ob.firstname +" "+ ob.lastname;	}
		else if(type == "Opportunity")
			{name = ob.name;}
		
		note.message = g.message(code: "notification.changedAssigned", args: [type, name]);
		String subject = g.message(code: "notification.changedAssigned.email.subject", args: [type, name]);
		String emailMessage = g.message(code: "notification.changedAssigned.email.message", args: [type, name]);
		
		note.save(flush:true)
		if(note.receiverUsers.size() > 0)
		{
			return ["message": emailMessage, "subject": subject, "receiverList": note.receiverUsers]
			//sendEmailNotification(note.message, subject, note.receiverUsers)
		}
		return [:]
	}
	def sendMoveServiceNotificationToOldPortfolioManager(ServiceProfile serviceProfile, Portfolio oldPortfolio)
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def note = new Notification()
		note.objectType = "ServiceProfile"
		note.objectId = serviceProfile.id
		note.dateCreated = new Date()
		note.active = true
		note.receiverUsers = [oldPortfolio.portfolioManager]
		note.receiverGroups = new ArrayList()
		note.message = g.message(code: "notification.servicePortfolioChangeFrom", args: ["${serviceProfile.service.serviceName}", "${serviceProfile.service.portfolio.portfolioName}", "${oldPortfolio.portfolioName}", user.profile.fullName]);
		String subject = g.message(code: "notification.servicePortfolioChangeFrom.email.subject", args: ["${serviceProfile.service.serviceName}"]);
		String emailMessage = g.message(code: "notification.servicePortfolioChangeFrom.email.message", args: ["${serviceProfile.service.serviceName}", "${serviceProfile.service.portfolio.portfolioName}", "${oldPortfolio.portfolioName}", user.profile.fullName]);
		note.save(flush:true)
		
		
		if(note.receiverUsers.size() > 0)
		{
			return ["messageFrom": emailMessage, "subjectFrom": subject, "receiverListFrom": note.receiverUsers]
			//sendEmailNotification(note.message, subject, note.receiverUsers)
		}
		return [:]
	}
	
	def sendMoveServiceNotificationToNewPortfolioManager(ServiceProfile serviceProfile, Portfolio oldPortfolio)
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def note2 = new Notification()
		note2.objectType = "ServiceProfile"
		note2.objectId = serviceProfile.id
		note2.dateCreated = new Date()
		note2.active = true
		note2.receiverUsers = [serviceProfile.service.portfolio.portfolioManager]
		note2.receiverGroups = new ArrayList()
		note2.message = g.message(code: "notification.servicePortfolioChangeTo", args: ["${serviceProfile.service.serviceName}", "${serviceProfile.service.portfolio.portfolioName}", "${oldPortfolio.portfolioName}", user.profile.fullName]);
		String subject2 = g.message(code: "notification.servicePortfolioChangeTo.email.subject", args: ["${serviceProfile.service.serviceName}", "${serviceProfile.service.portfolio.portfolioName}"]);
		String emailMessage2 = g.message(code: "notification.servicePortfolioChangeTo.email.message", args: ["${serviceProfile.service.serviceName}", "${serviceProfile.service.portfolio.portfolioName}", "${oldPortfolio.portfolioName}", user.profile.fullName]);
		note2.save(flush:true)
		
		
		if(note2.receiverUsers.size() > 0)
		{
			return ["messageTo": emailMessage2, "subjectTo": subject2, "receiverListTo": note2.receiverUsers]
			//sendEmailNotification(note.message, subject, note.receiverUsers)
		}
		return [:]
	}
	
	void sendEmailNotification(Object message, Object subject, Object receverList)
	{
		def emailId = ""
		for(User user in receverList)
		{
			if(user?.profile?.email != null)
			{
				emailId = user?.profile?.email
				println emailId
				sendMailService.serviceMethod(message, subject, emailId)
			}
		}
		
	}
}
