package com.valent.pricewell

import java.util.Map;
import org.apache.shiro.SecurityUtils

class ImportService {

    static transactional = true

    def serviceMethod() {

    }
	
	public def createImportedService(Map serviceProperties)
	{
		def serviceInstance = new Service()
		def serviceProfile = null
		serviceInstance = createService(serviceInstance, serviceProperties)
		
		for(String serviceProp : serviceProperties.keySet())
		{
			if(serviceProp == "serviceProfile")
			{
				def serviceProfileProperties = serviceProperties[serviceProp];
				serviceProfile = createServiceProfile(serviceProfileProperties)
			}
			else
				serviceInstance.properties[serviceProp] = serviceProperties[serviceProp]
		}
		
		serviceInstance.serviceProfile = serviceProfile
		serviceInstance.addToProfiles(serviceProfile)
		
		serviceInstance.save()
		
	}
	
	public Service createService(Service serviceInstance, Map serviceProperties)
	{
		serviceInstance.serviceName = serviceProperties['serviceName']
		def user = User.get(new Long(SecurityUtils.subject.principal))
		serviceInstance.createdBy = serviceInstance.productManager = serviceInstance.modifiedBy = user
		
		serviceInstance.active = true

		serviceInstance.dateCreated = new Date()
		serviceInstance.dateModified = new Date()
		
		serviceInstance?.portfolio = addPortfolio(serviceProperties)
		
		serviceInstance.save()
		
		return serviceInstance
	}
	
	public Portfolio addPortfolio(Map serviceProperties)
	{
		def portfolioProperties = serviceProperties['portfolio']
		def portfolioName = portfolioProperties['portfolioName']
		def portfolio = Portfolio.findByPortfolioName(portfolioName)
		if(portfolio?.id != null)
		{
			return portfolio
		}
		else
		{
			def portfolioInstance = new Portfolio()
			def user = User.get(new Long(SecurityUtils.subject.principal))
			portfolioInstance.portfolioName = portfolioName
			portfolioInstance.description = portfolioProperties['description']
			portfolioInstance.stagingStatus = "Published"
			portfolioInstance.dateModified = new Date()
			portfolioInstance.portfolioManager = user
			portfolioInstance.save()
			return portfolioInstance
		}
	}
	
	public ServiceProfile createServiceProfile(Map serviceProfileProperties)
	{
		ServiceProfile serviceProfile = new ServiceProfile()
		addProfileRequiredProperties( serviceProfile, serviceProfileProperties)
		
		for(String profileProp : serviceProfileProperties.keySet())
		{
			if(profileProp == "customerDeliverables")
			{
				def customerDeliverables = serviceProfileProperties[profileProp]
				for(int i=0; i<customerDeliverables.size(); i++)
				{
					addServiceDeliverable(serviceProfile, customerDeliverables[i])
				}
			}
			else if(profileProp == 'productsRequired')
			{
				def productsRequired = serviceProfileProperties[profileProp]
				for(int i=0; i<productsRequired.size(); i++)
				{
					addServiceProductItem(serviceProfile, productsRequired[i])
				}
			}
			else
				serviceProfile.properties[profileProp] = serviceProfileProperties[profileProp]
		}
		
		serviceProfile.save()
		
		return serviceProfile
	}
	
	public void addProfileRequiredProperties(ServiceProfile sProfile, Map profileProperties)
	{
		sProfile.customerDeliverables = new ArrayList()
		sProfile.otherServiceDesigners = new ArrayList()
		sProfile.productsRequired = new ArrayList()
		sProfile.reviewRequests = new ArrayList()
		sProfile.rolesRequired = new ArrayList()
		sProfile.stagingLogs = new ArrayList()
		def user = User.get(new Long(SecurityUtils.subject.principal))
		
		sProfile.revision = profileProperties['revision']
		sProfile.dateCreated = new Date()
		sProfile.serviceDesignerLead = user
		sProfile.newProfile = sProfile.oldProfile = sProfile
		
		sProfile.save()
	}
	
	public ServiceProductItem addServiceProductItem(ServiceProfile sProfile, Map sProductItemProperties)
	{
		def newProductItem = new ServiceProductItem()
		newProductItem.properties['unitsSoldPerBaseUnits'] = sProductItemProperties['unitsSoldPerBaseUnits']
		newProductItem.properties['unitsSoldRatePerAdditionalUnit'] = sProductItemProperties['unitsSoldRatePerAdditionalUnit']
		
		newProductItem.product = getProduct(sProductItemProperties['product'])
		sProfile.addToProductsRequired(newProductItem)
		newProductItem.save(flush:true)
		
		return newProductItem
	}
	
	public Product getProduct(Map productProperties)
	{
		def productName = productProperties['productName']
		def product = Product.findByProductName(productName)
		
		if(product?.id != null)
		{
			return product
		}
		else
		{
			Product productInstance = new Product()
			for(String productProp : productProperties.keySet())
			{
				productInstance.properties[productProp] = productProperties[productProp]
			}
			
			productInstance.dateCreated = new Date()
			productInstance.dateModified = new Date()
			productInstance.datePublished = new Date()
			
			productInstance.save()
			return productInstance
		}
	}
	
	public ServiceDeliverable addServiceDeliverable(ServiceProfile serviceProfile, Map cDeliverableProperties)
	{
		def sDeliverableInstance = new ServiceDeliverable()
		sDeliverableInstance.name = cDeliverableProperties['name']
		serviceProfile.addToCustomerDeliverables(sDeliverableInstance)
		sDeliverableInstance.save()
		
		for(String sDeliverableProp : cDeliverableProperties.keySet())
		{
			if(sDeliverableProp == "serviceActivities")
			{
				def serviceActivities = cDeliverableProperties[sDeliverableProp]
				for(int i=0; i<serviceActivities?.size(); i++)
				{
					def sActivity = addServiceActivity(sDeliverableInstance, serviceActivities[i])
				}
			}
			else
				sDeliverableInstance.properties[sDeliverableProp] = cDeliverableProperties[sDeliverableProp]
		}
		
		sDeliverableInstance.save()
		return sDeliverableInstance
	}
	
	public ServiceActivity addServiceActivity(ServiceDeliverable sDeliverable, Map sActivityProperties)
	{
		ServiceActivity sActivityInstance = new ServiceActivity()
		sActivityInstance.properties['name'] = sActivityProperties['name']
		sActivityInstance.properties['category'] = sActivityProperties['category']
		sDeliverable.addToServiceActivities(sActivityInstance)
		sActivityInstance.save()
		
		for(String sActivityProp : sActivityProperties.keySet())
		{
			if(sActivityProp == "rolesRequired")
			{
				def rolesRequired = sActivityProperties[sActivityProp]
				for(int i=0; i<rolesRequired.size(); i++)
				{
					addDeliveryRole(sActivityInstance, rolesRequired[i])
				}
			}
			else if(sActivityProp == "rolesEstimatedTime")
			{
				def rEstimateTimeList = sActivityProperties[sActivityProp]
				for(int i=0; i<rEstimateTimeList.size(); i++)
				{
					addActivityRoleTime(sActivityInstance, rEstimateTimeList[i])
				}
			}
			else
				sActivityInstance.properties[sActivityProp] = sActivityProperties[sActivityProp]
		}
		
		sActivityInstance.save()
		return sActivityInstance
	}
	
	public void addDeliveryRole(ServiceActivity sActivity, Map deliveryRoleProperties)
	{
		def deliveryRoleInstance = getDeliveryRole(deliveryRoleProperties)
		sActivity.addToRolesRequired(deliveryRoleInstance)
	}
	
	public ActivityRoleTime addActivityRoleTime(ServiceActivity sActivity, Map roleEstimateProperties)
	{
		ActivityRoleTime activityRoleTime = new ActivityRoleTime()
		
		for(String aRoleTimeProp : roleEstimateProperties.keySet())
		{
			if(aRoleTimeProp == "role")
			{
				def deliveryRoleInstance = getDeliveryRole(roleEstimateProperties[aRoleTimeProp])
				activityRoleTime.role = deliveryRoleInstance
			}
			else
				activityRoleTime.properties[aRoleTimeProp] = roleEstimateProperties[aRoleTimeProp]
		}
		
		sActivity.addToRolesEstimatedTime(activityRoleTime)
		activityRoleTime.save(flush:true)
		
		return activityRoleTime
	}
	
	public DeliveryRole getDeliveryRole(Map roleProperties)
	{
		def roleName = roleProperties['name']
		def deliveryRole = DeliveryRole.findByName(roleName)
		if(deliveryRole?.id != null)
		{
			return deliveryRole
		}
		else
		{
			DeliveryRole dRole = new DeliveryRole()
			dRole.name = roleProperties['name']
			dRole.description = roleProperties['description']
			dRole.save()
			return dRole
		}
	}
	
}
