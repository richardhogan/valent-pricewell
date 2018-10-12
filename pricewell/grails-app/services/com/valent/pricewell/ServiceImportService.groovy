package com.valent.pricewell

import java.util.Map;
import org.apache.shiro.SecurityUtils

class ServiceImportService {

	static transactional = true
	def sendMailService, serviceCatalogService
	def serviceMethod() {

	}
	
	public boolean isServiceAlreadyExist(String serviceName)
	{
		println "comming to check service name"
		Service serviceInstance = Service.findByServiceName(serviceName)
		
		if(serviceInstance)
			return true
			
		return false
	}
	
	public Map checkOrCorrectDeliveryRole(Map dataMap, String type)
	{
		List services = dataMap['services'], roleActivityList = []
		List unAvailableDeliveryRoles = dataMap['unAvailableDeliveryRoles']
		List mappedArray = dataMap['mappedArray']
		println "comming to check for not matched delivery role"
		Set unavailableRoles = new HashSet()
		Map roleActivityMap = new HashMap(), finalMap = new HashMap()
		for(Map serviceProperties : services)
		{
			for(String serviceProp : serviceProperties.keySet())
			{
				if(serviceProp == "serviceProfile")
				{
					Map serviceProfileProperties = serviceProperties[serviceProp];
					
					for(String profileProp : serviceProfileProperties.keySet())
					{
						
						if(profileProp == "customerDeliverables")
						{
							List customerDeliverables = serviceProfileProperties[profileProp]
							for(int i=0; i<customerDeliverables.size(); i++)
							{
								Map cDeliverableProperties = customerDeliverables[i]
								
								for(String sDeliverableProp : cDeliverableProperties.keySet())
								{
									if(sDeliverableProp == "serviceActivities")
									{
										List serviceActivities = cDeliverableProperties[sDeliverableProp]
										for(int j=0; j<serviceActivities?.size(); j++)
										{
											Map sActivityProperties = serviceActivities[j]
											String sName = sActivityProperties['name']
											for(String sActivityProp : sActivityProperties.keySet())
											{
												if(sActivityProp == "rolesRequired")
												{
													List rolesRequired = sActivityProperties[sActivityProp]
													
													for(int k=0; k<rolesRequired.size(); k++)
													{
														Map deliveryRoleProperties = rolesRequired[k]
														def roleName = deliveryRoleProperties['name']
														
														if(type == "check")
														{
															def deliveryRole = DeliveryRole.findByName(roleName)
															if(deliveryRole?.id != null)
															{
																//to do nothing
															}
															else
															{
																unavailableRoles.add(roleName)
																if(roleActivityMap.containsKey(roleName))
																{
																	roleActivityMap[roleName].add(sName)
																}
																else
																{
																	roleActivityMap.put(roleName, new ArrayList())
																	roleActivityMap[roleName].add(sName)
																}
															}
														}
														else if(type == "correct")
														{
															if(unAvailableDeliveryRoles.contains(roleName))
															{
																def index = unAvailableDeliveryRoles.indexOf(roleName)
																deliveryRoleProperties['name'] = mappedArray[index]
															}
														}
													}
												}
												if(sActivityProp == "rolesEstimatedTime" && type == "correct")
												{
													def rEstimateTimeList = sActivityProperties[sActivityProp]
													for(int l=0; l<rEstimateTimeList.size(); l++)
													{
														Map roleEstimateProperties = rEstimateTimeList[l]
														
														for(String aRoleTimeProp : roleEstimateProperties.keySet())
														{
															if(aRoleTimeProp == "role")
															{
																Map roleProperties = roleEstimateProperties[aRoleTimeProp]
																def roleName = roleProperties['name']
																
																if(unAvailableDeliveryRoles.contains(roleName))
																{
																	def index = unAvailableDeliveryRoles.indexOf(roleName)
																	roleProperties['name'] = mappedArray[index]
																}
															}
														}
													}
												}
												
											}
										}
									}
									
								}
							}
						}
						
					}
				}
				
			}
		}
		
		//println roleActivityMap
		if(type == "check")
		{
			println "finish to check of delivery role"
			for(String roleName : unavailableRoles.toList())
			{
				roleActivityList.add(roleActivityMap[roleName])
			}
			
			finalMap['roleActivityList'] = roleActivityList
			finalMap['unavailableRoles'] = unavailableRoles.toList()
			
		}
		else if(type == "correct")
		{
			finalMap['services'] = services
			
		}
		return finalMap
	}
	
	public Map createImportedService(Map serviceProperties, Portfolio portfolio)
	{
		def serviceInstance = new Service()
		def serviceProfile = null
		String res = ""
		def resultMap = [:]
		serviceInstance = createService(serviceInstance, serviceProperties, portfolio)
		if(serviceInstance != "service Exist")
		{
			for(String serviceProp : serviceProperties.keySet())
			{
				if(serviceProp == "serviceProfile")
				{
					def serviceProfileProperties = serviceProperties[serviceProp];
					serviceProfile = createServiceProfile(serviceInstance, serviceProfileProperties)
				}
				//else
					//serviceInstance.properties[serviceProp] = serviceProperties[serviceProp]
			}
			
			serviceInstance.save(flush:true)
			
			System.out.println("Service ID "+serviceInstance.serviceProfile.id)
			
			res = "Service Name : ${serviceInstance.serviceName} || Status : Imported Successfully"
			resultMap["res"] = res
			resultMap["serviceId"] = serviceInstance?.id
			resultMap["serviceProfileId"] = serviceInstance?.serviceProfile?.id
		}
		else
		{
			res = "Service Name : "+serviceProperties['serviceName'] + " || Status : Already Exist, Not Imported"
			resultMap["res"] = res
		}
		
		return resultMap
	}
	
	public def createService(Service serviceInstance, Map serviceProperties, Portfolio portfolio)
	{
		def serviceName = serviceProperties['serviceName']
		def service = Service.findByServiceName(serviceName)
		if(!service)
		{
			serviceInstance.properties['serviceName', 'skuName', 'tags'] = serviceProperties //'description',
			serviceInstance.serviceDescription = new Description(name: "Service Description: "+serviceProperties['serviceName'], value: serviceProperties['description']).save() 
			//serviceInstance.serviceName = serviceProperties['serviceName']
			def user = User.get(new Long(SecurityUtils.subject.principal))
			serviceInstance.createdBy = serviceInstance.modifiedBy = user
			
			serviceInstance.active = true
	
			serviceInstance.dateCreated = new Date()
			serviceInstance.dateModified = new Date()
			
			serviceInstance?.portfolio = portfolio//addPortfolio(serviceProperties)
			
			def productManager = User.find("from User where username='product'");
			serviceInstance.productManager = productManager
			
			serviceInstance.save(flush: true)
			return serviceInstance//"success"
		}
		else
			return "service Exist"
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
			portfolioInstance.save(flush:true)
			return portfolioInstance
		}
	}
	
	public ServiceProfile createServiceProfile(Service service, Map serviceProfileProperties)
	{
		println serviceProfileProperties
		ServiceProfile serviceProfile = new ServiceProfile()
		serviceProfile = addProfileRequiredProperties( service, serviceProfile, serviceProfileProperties)
		
		for(String profileProp : serviceProfileProperties.keySet())
		{
			
			if(profileProp == 'productsRequired')
			{
				def productsRequired = serviceProfileProperties[profileProp]
				for(int i=0; i<productsRequired.size(); i++)
				{
					addServiceProductItem(serviceProfile, productsRequired[i])
				}
			}
			else if(profileProp == "customerDeliverables")
			{
				def customerDeliverables = serviceProfileProperties[profileProp]
				for(int i=0; i<customerDeliverables.size(); i++)
				{
					addServiceDeliverable(serviceProfile, customerDeliverables[i], i+1)
				}
			}
			else if(profileProp == "defs")
			{
				def defs = serviceProfileProperties[profileProp]
				for(int i=0; i<defs?.size(); i++)
				{
					addServiceProfileSOWDefs(serviceProfile, defs[i])
				}
			}
			else if(profileProp == "metaphors")
			{
				def metaphors = serviceProfileProperties[profileProp]
				for(int i=0; i<metaphors?.size(); i++)
				{
					addServiceProfileMetaphors(serviceProfile, metaphors[i])//, i+1)
				}
			}
			else if(profileProp == "extraUnits")
			{
				def extraUnits = serviceProfileProperties[profileProp]
				for(int i=0; i<extraUnits?.size(); i++)
				{
					addServiceProfileExtraUnits(serviceProfile, extraUnits[i])//, i+1)
				}
			}
			
			//else
				//serviceProfile.properties[profileProp] = serviceProfileProperties[profileProp]
		}
		
		serviceProfile.save(flush:true)
		
		
		return serviceProfile
	}
	
	public ServiceProfileSOWDef addServiceProfileSOWDefs(ServiceProfile sProfile, Map sowDefProperties)
	{
		def serviceProfileSOWDefInstance = new ServiceProfileSOWDef()
		serviceProfileSOWDefInstance.part = sowDefProperties['part']
		serviceProfileSOWDefInstance.definitionSetting = new Setting(name: sowDefProperties['name'], value: sowDefProperties['value']).save()
		
		if(sowDefProperties['geoName'] != null && sowDefProperties['geoName'] != "")
		{
			serviceProfileSOWDefInstance.geo = getGeo(sowDefProperties)
		}
		else 
		{
			serviceProfileSOWDefInstance.geo = null
		}
		
		serviceProfileSOWDefInstance.sp = sProfile
		sProfile.addToDefs(serviceProfileSOWDefInstance)
		serviceProfileSOWDefInstance.save(flush:true)
		sProfile.save(flush: true)
		
		return serviceProfileSOWDefInstance
	}
	
	public int getMetaphoresSequenceOrder(ServiceProfile serviceProfile, String metaphoreType)
	{
		int sequenceOrder = 0
		for(ServiceProfileMetaphors serviceProfileMetaphorInstance : serviceProfile?.metaphors)
		{
			if(serviceProfileMetaphorInstance.type?.toString() == metaphoreType)
				sequenceOrder++
		}
		
		return (++sequenceOrder).toInteger()
	}
	
	public ServiceProfileMetaphors addServiceProfileMetaphors(ServiceProfile sProfile, Map metaphorsProperties)//, int sequenceOrder)
	{
		ServiceProfileMetaphors serviceProfileMetaphorsInstance = new ServiceProfileMetaphors()
		serviceProfileMetaphorsInstance.sequenceOrder = (metaphorsProperties['sequenceOrder']) ? metaphorsProperties['sequenceOrder']?.toInteger() : 
															getMetaphoresSequenceOrder(sProfile, metaphorsProperties['type'])//sequenceOrder
															
		serviceProfileMetaphorsInstance.definitionString = new Setting(name: metaphorsProperties['name'], value: metaphorsProperties['value']).save()
		serviceProfileMetaphorsInstance.serviceProfile = sProfile
		
		if(metaphorsProperties['type'] == "PRE_REQUISITE")
		{
			serviceProfileMetaphorsInstance.type = ServiceProfileMetaphors.MetaphorsType.PRE_REQUISITE
		}
		else if(metaphorsProperties['type'] == "OUT_OF_SCOPE")
		{
			serviceProfileMetaphorsInstance.type = ServiceProfileMetaphors.MetaphorsType.OUT_OF_SCOPE
		}
		sProfile.addToMetaphors(serviceProfileMetaphorsInstance)
		serviceProfileMetaphorsInstance.save(flush:true)
		sProfile.save(flush: true)
		
		return serviceProfileMetaphorsInstance
	}
	
	public Geo getGeo(Map sowProperties)
	{
		def geoName = sowProperties['geoName']
		def geo = Geo.findByName(geoName)
		
		if(geo?.id != null)
		{
			println "geo exist"
			return geo
		}
		else
		{
			Geo geoInstance = new Geo()
			//for(String productProp : productProperties.keySet())
			//{
				geoInstance.properties['name', 'currency'] = [sowProperties['geoName'], sowProperties['geoCurrency']]
			//}
			
			geoInstance.save(flush:true)
			return geoInstance
		}
	}
	
	public ServiceProfile addProfileRequiredProperties(Service service, ServiceProfile sProfile, Map profileProperties)
	{
		sProfile.customerDeliverables = new ArrayList()
		sProfile.otherServiceDesigners = new ArrayList()
		sProfile.productsRequired = new ArrayList()
		sProfile.reviewRequests = new ArrayList()
		sProfile.rolesRequired = new ArrayList()
		sProfile.defs = new ArrayList()
		sProfile.stagingLogs = new ArrayList()
		def user = User.get(new Long(SecurityUtils.subject.principal))
		
		sProfile.properties['unitOfSale', 'baseUnits', 'premiumPercent', 'definition']	= profileProperties
						
		sProfile.totalEstimateInHoursPerBaseUnits = new BigDecimal(profileProperties['totalEstimateInHoursPerBaseUnits'])
		sProfile.totalEstimateInHoursFlat = new BigDecimal(profileProperties['totalEstimateInHoursFlat'])
						
		sProfile.revision = 1//profileProperties['revision']
		sProfile.dateCreated = new Date()
		sProfile.dateModified = new Date()
		
		def serviceDesignerLead = User.find("from User where username='designer'");
		sProfile.serviceDesignerLead = serviceDesignerLead
		
		sProfile.stagingStatus = Staging.findByName("init")
		sProfile.importServiceStage = "init"
		sProfile.isImported = "true"
		sProfile.type = ServiceProfile.ServiceProfileType.DEVELOP
		sProfile.service = service
		sProfile.newProfile = sProfile.oldProfile = null//sProfile
		
		service.serviceProfile = sProfile
		service.addToProfiles(sProfile)
		
		sProfile.save(flush:true)
		service.save(flush: true)
		return sProfile
	}
	
	public ExtraUnit addServiceProfileExtraUnits(ServiceProfile sProfile, Map eUnitProperties)
	{
		def newExtraUnit = new ExtraUnit()
		//newProductItem.unitsSoldPerBaseUnits = new BigDecimal(sProductItemProperties['unitsSoldPerBaseUnits']!=null?sProductItemProperties['unitsSoldPerBaseUnits']:0)
		newExtraUnit.unitOfSale = eUnitProperties['unitOfSale']
		newExtraUnit.extraUnit = eUnitProperties['extaUnit']
		newExtraUnit.shortName = eUnitProperties['shortName']
		
		
		sProfile.addToExtraUnits(newExtraUnit)
		newExtraUnit.save(flush:true)
		sProfile.save(flush: true)
		
		return newExtraUnit
	}
	
	public ServiceProductItem addServiceProductItem(ServiceProfile sProfile, Map sProductItemProperties)
	{
		def newProductItem = new ServiceProductItem()
		//newProductItem.unitsSoldPerBaseUnits = new BigDecimal(sProductItemProperties['unitsSoldPerBaseUnits']!=null?sProductItemProperties['unitsSoldPerBaseUnits']:0)
		newProductItem.unitsSoldRatePerAdditionalUnit = new BigDecimal(sProductItemProperties['unitsSoldRatePerAdditionalUnit']!=null?sProductItemProperties['unitsSoldRatePerAdditionalUnit']:0)
		
		newProductItem.product = getProduct(sProductItemProperties['product'])
		newProductItem.serviceProfile = sProfile
		sProfile.addToProductsRequired(newProductItem)
		newProductItem.save(flush:true)
		sProfile.save(flush: true)
		
		return newProductItem
	}
	
	public Product getProduct(Map productProperties)
	{
		def productName = productProperties['productName']
		def product = Product.findByProductName(productName)
		
		if(product?.id != null)
		{
			println "product exist"
			return product
		}
		else
		{
			Product productInstance = new Product()
			//for(String productProp : productProperties.keySet())
			//{
				productInstance.properties['productName', 'product_id', 'unitOfSale', 'productType'] = productProperties//[productProp]
			//}
			
			productInstance.dateCreated = new Date()
			productInstance.dateModified = new Date()
			productInstance.datePublished = new Date()
			
			productInstance.save(flush:true)
			return productInstance
		}
	}
	
	public ServiceDeliverable addServiceDeliverable(ServiceProfile serviceProfile, Map cDeliverableProperties, int sequenceOrder)
	{
		def sDeliverableInstance = new ServiceDeliverable()
		sDeliverableInstance.properties['name', 'type', 'description', 'phase'] = cDeliverableProperties//['name']
		sDeliverableInstance.sequenceOrder = sequenceOrder
		
		sDeliverableInstance.serviceProfile = serviceProfile
		serviceProfile.addToCustomerDeliverables(sDeliverableInstance)
		sDeliverableInstance.save(flush:true)
		serviceProfile.save(flush:true)
		
		def description = (!cDeliverableProperties['newDescription'] || cDeliverableProperties['newDescription'] == null || cDeliverableProperties['newDescription'] == "" || cDeliverableProperties['newDescription'] == [:]) ? 
								sDeliverableInstance?.description : cDeliverableProperties['newDescription']['value']
		
		serviceCatalogService.createNewServiceDeliverableDescription(sDeliverableInstance, description)
		
		for(String sDeliverableProp : cDeliverableProperties.keySet())
		{
			if(sDeliverableProp == "serviceActivities")
			{
				def serviceActivities = cDeliverableProperties[sDeliverableProp]
				for(int i=0; i<serviceActivities?.size(); i++)
				{
					def sActivity = addServiceActivity(sDeliverableInstance, serviceActivities[i], i+1)
				}
			}
			//else
				//sDeliverableInstance.properties[sDeliverableProp] = cDeliverableProperties[sDeliverableProp]
		}
		
		sDeliverableInstance.save(flush:true)
		return sDeliverableInstance
	}
	
	public ServiceActivity addServiceActivity(ServiceDeliverable sDeliverable, Map sActivityProperties, int sequenceOrder)
	{
		ServiceActivity sActivityInstance = new ServiceActivity()
		sActivityInstance.properties['name', 'category', 'description', 'result'] = sActivityProperties//['name']
		sActivityInstance.estimatedTimeInHoursPerBaseUnits = new BigDecimal(sActivityProperties['estimatedTimeInHoursPerBaseUnits'])
		sActivityInstance.estimatedTimeInHoursFlat = new BigDecimal(sActivityProperties['estimatedTimeInHoursFlat'])
		//sActivityInstance.properties['category'] = sActivityProperties['category']
		sActivityInstance.sequenceOrder = sequenceOrder
		
		sActivityInstance.serviceDeliverable = sDeliverable
		sDeliverable.addToServiceActivities(sActivityInstance)
		
		sActivityInstance.save(flush:true)
		sDeliverable.save(flush:true)
		
		for(String sActivityProp : sActivityProperties.keySet())
		{
			if(sActivityProp == "rolesRequired")
			{
				def rolesRequired = sActivityProperties[sActivityProp]
				for(int i=0; i<rolesRequired.size(); i++)
				{
					def deliveryRoleInstance = addDeliveryRole(sActivityInstance, rolesRequired[i])
					if(deliveryRoleInstance?.id != null)
					{
						sActivityInstance.addToRolesRequired(deliveryRoleInstance)
					}
				}
			}
			else if(sActivityProp == "rolesEstimatedTime")
			{
				def rEstimateTimeList = sActivityProperties[sActivityProp]
				for(int i=0; i<rEstimateTimeList.size(); i++)
				{
					def aRoleTimeInstance = addActivityRoleTime(sActivityInstance, rEstimateTimeList[i])
					sActivityInstance.addToRolesEstimatedTime(aRoleTimeInstance)
				}
			}
			else if(sActivityProp == "activityTasks")
			{
				def saTaskList = sActivityProperties[sActivityProp]
				for(int i=0; i<saTaskList.size(); i++)
				{
					println saTaskList[i]
					def saTaskInstance = addServiceActivityTask(sActivityInstance, saTaskList[i])
					sActivityInstance.addToActivityTasks(saTaskInstance)
				}
			}
			//else
				//sActivityInstance.properties[sActivityProp] = sActivityProperties[sActivityProp]
		}
		
		sActivityInstance.save(flush:true)
		return sActivityInstance
	}
	
	public DeliveryRole addDeliveryRole(ServiceActivity sActivity, Map deliveryRoleProperties)
	{
		def deliveryRoleInstance = getDeliveryRole(deliveryRoleProperties)
		//sActivity.addToRolesRequired(deliveryRoleInstance)
		//sActivity.save()
		return deliveryRoleInstance
	}
	
	public ActivityRoleTime addActivityRoleTime(ServiceActivity sActivity, Map roleEstimateProperties)
	{
		ActivityRoleTime activityRoleTime = new ActivityRoleTime()
		
		activityRoleTime.estimatedTimeInHoursPerBaseUnits = new BigDecimal(roleEstimateProperties['estimatedTimeInHoursPerBaseUnits'])
		activityRoleTime.estimatedTimeInHoursFlat = new BigDecimal(roleEstimateProperties['estimatedTimeInHoursFlat'])
		
		//activityRoleTime.properties['estimatedTimeInHoursPerBaseUnits', 'estimatedTimeInHoursFlat'] = roleEstimateProperties//[aRoleTimeProp]
		for(String aRoleTimeProp : roleEstimateProperties.keySet())
		{
			if(aRoleTimeProp == "role")
			{
				def deliveryRoleInstance = getDeliveryRole(roleEstimateProperties[aRoleTimeProp])
				activityRoleTime.role = deliveryRoleInstance
			}
			//else
				//activityRoleTime.properties[aRoleTimeProp] = roleEstimateProperties[aRoleTimeProp]
		}
		
		activityRoleTime.serviceActivity = sActivity
		//sActivity.addToRolesEstimatedTime(activityRoleTime)
		activityRoleTime.save(flush:true)
		
		return activityRoleTime
	}
	
	public ServiceActivityTask addServiceActivityTask(ServiceActivity sActivity, Map serviceActivityTaskProperties)
	{
		println serviceActivityTaskProperties
		ServiceActivityTask serviceActivityTask = new ServiceActivityTask()
		
		serviceActivityTask.task = serviceActivityTaskProperties['task']
		serviceActivityTask.sequenceOrder = serviceActivityTaskProperties['sequenceOrder']
		
		
		serviceActivityTask.serviceActivity = sActivity
		//sActivity.addToRolesEstimatedTime(activityRoleTime)
		serviceActivityTask.save(flush:true)
		
		return serviceActivityTask
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
			dRole.save(flush:true)
			return dRole
		}
	}
	
}
