package com.valent.pricewell
import com.valent.pricewell.Staging.StagingType;

import grails.plugins.nimble.core.Role;
import com.valent.pricewell.UserRole;

class ServiceProfileSecurityProvider {

	ServiceProfile serviceProfile
	User user
	
	public ServiceProfileSecurityProvider(ServiceProfile serviceProfile, User loginUser)
	{
		this.serviceProfile = serviceProfile
		this.user = loginUser
	}
	
	public ServiceProfileSecurityProvider(ServiceProfile serviceProfile)
	{
		this.serviceProfile = serviceProfile
	}
	
	boolean isChangeOfStageAllowed(Staging stage)
	{
		if(!user) 
			return false
			
		if(isAdmin())
			return true;
		
			
		for(Role role: UserRole.findAllByUser(user)*.role)
		{
			if(stage.authorizedRoles?.contains(role))
			{
				switch(role.code)
				{
					case RoleId.SERVICE_DESIGNER.code:
						if(serviceProfile?.serviceDesignerLead == user || serviceProfile?.otherServiceDesigners?.contains(user))
							return true;
						break;
					
					case RoleId.PRODUCT_MANAGER.code:
						if(serviceProfile?.service?.productManager == user || serviceProfile?.service?.otherProductManagers?.contains(user))
							return true;
						break;
					
					case RoleId.PORTFOLIO_MANAGER.code:
						if(serviceProfile?.service?.portfolio?.portfolioManager == user || 
									serviceProfile?.service?.portfolio?.otherPortfolioManagers?.contains(user))
							return true;
						break;
				}
			}
		}
		
		return false;
	}
	
	private boolean isAdmin()
	{
		if((UserRole.findAllByUser(user)*.role*.code).contains(RoleId.ADMINISTRATOR.code))
			return true;
		return false;
	}
	
	boolean isChangeOfCurrentStageAllowed()
	{
		return isChangeOfStageAllowed(serviceProfile?.stagingStatus)
	}
	
	boolean isChangeOfNextStageAllowed()
	{
		return isChangeOfStageAllowed(Staging.getNextServiceStage("NEW_STAGE", serviceProfile?.stagingStatus))
	}
	
	boolean isStageBeingReviewed()
	{
		return isStageBeingReviewed(serviceProfile?.stagingStatus)
	}
	
	boolean isStageBeingReviewed(Staging stage)
	{
		if(stage.types?.contains(StagingType.REVIEW_REQUEST))
			return true;
			
		return false;
	}
	
	Set listAuthorizedUsers()
	{
		return listAuthorizedUsers(serviceProfile?.stagingStatus)
	}
	
	Set listAuthorizedUsers(Staging stage)
	{
		Set users = new LinkedHashSet(); 
		
		for(Role role in stage.authorizedRoles)
		{
			switch(role.code)
			{
				case RoleId.SERVICE_DESIGNER.code:
					  	(serviceProfile?.serviceDesignerLead != null) ? users.add(serviceProfile?.serviceDesignerLead) : ""
						(serviceProfile?.otherServiceDesigners?.size() > 0) ? users.addAll(serviceProfile?.otherServiceDesigners) : ""
					break;
				
				case RoleId.PRODUCT_MANAGER.code:
						(serviceProfile?.service?.productManager != null) ? users.add(serviceProfile?.service?.productManager) : ""
						(serviceProfile?.service?.otherProductManagers?.size() > 0) ? users.addAll(serviceProfile?.service?.otherProductManagers) : ""
					break;
				
				case RoleId.PORTFOLIO_MANAGER.code:
						(serviceProfile?.service?.portfolio?.portfolioManager != null) ? users.add(serviceProfile?.service?.portfolio?.portfolioManager) : ""
					break;
					
				case RoleId.SALES_PERSON.code:
						users.addAll(UserRole.findAllByRole(role)*.user)
					break;
					
				case RoleId.DELIVERY_ROLE_MANAGER.code:
						users.addAll(UserRole.findAllByRole(role)*.user)
					break;
				
				case RoleId.ADMINISTRATOR.code:
						users.addAll(UserRole.findAllByRole(role)*.user)
					break;
			}
		}
		
		def adminRole = Role.findByCode(RoleId.ADMINISTRATOR.code); users.addAll(UserRole.findAllByRole(adminRole)*.user)
		
		return users
	}
	
	Set listReviewerUsers(Staging stage)
	{
		Set users = new LinkedHashSet();
		
		for(Role role in stage.reviewerRoles)
		{
			switch(role.code)
			{
				case RoleId.SERVICE_DESIGNER.code:
					  users.addAll(UserRole.findAllByRole(Role.findByCode(RoleId.SERVICE_DESIGNER.code))*.user)
					break;
				
				case RoleId.PRODUCT_MANAGER.code:
					users.add(serviceProfile?.service?.productManager)
					users.addAll(serviceProfile?.service?.otherProductManagers)
					break;
				
				case RoleId.PORTFOLIO_MANAGER.code:
					users.add(serviceProfile?.service?.portfolio?.portfolioManager)
					break;
					
				case RoleId.SALES_PERSON.code:
					users.addAll(UserRole.findAllByRole(role)*.user)
					break;
					
				case RoleId.DELIVERY_ROLE_MANAGER.code:
					users.addAll(UserRole.findAllByRole(role)*.user)
					break;
				
				case RoleId.ADMINISTRATOR.code:
					users.addAll(UserRole.findAllByRole(role)*.user)
					break;
			}
		}
		
		return users
	}
	
	boolean isCommentAllowed(ReviewRequest reviewRequest)
	{	
		return (reviewRequest.submitter == user || reviewRequest.assignees.contains(user))
	}
	
	boolean isStatusChangedAllowed(ReviewRequest reviewRequest)
	{
		if(reviewRequest.fromStage != null)
		{
			return (reviewRequest.assignees.contains(user) && isChangeOfStageAllowed(reviewRequest.fromStage) )
		}
		else
		{
			if(reviewRequest.assignees.contains(user))
			{
				return true
			}
			else
			{
				return false
			}
			
		}
	}
}
