package com.valent.pricewell
import grails.plugins.nimble.core.*
import org.apache.shiro.SecurityUtils
import com.valent.pricewell.Service
import java.util.*

import com.valent.pricewell.ServiceProfile.ServiceProfileType;
class ServiceCatalogService {

    static transactional = true
	def priceCalculationService, userService
	
	List getMyServices(User user)
	{
		
	}
	
	List searchMyServices(User user, Object searchFields)
	{
		
	}
	
	public void correctServiceActivityTaskSequenceOrder(ServiceActivity serviceActivity)
	{
		def sequenceOrder = 1
		for(ServiceActivityTask aTask : serviceActivity?.activityTasks?.sort{it.sequenceOrder})
		{
			aTask.sequenceOrder = sequenceOrder
			aTask.save()
			sequenceOrder++
		}
	}
	
	public void addServiceActivityTaskToServiceActivity(ServiceActivity serviceActivityInstance, ArrayList<ServiceActivityTask> serviceActivityTaskList)
	{
		def sequenceOrder = 1
		for(ServiceActivityTask aTask : serviceActivityTaskList)
		{
			aTask.sequenceOrder = sequenceOrder
			aTask.save()
			serviceActivityInstance.addToActivityTasks(aTask)
			sequenceOrder++
		}
		
		serviceActivityInstance.save()
	}
	
	//method is converting activityTasks IDs in String to real task object ServiceActivityTask
	public ArrayList<ServiceActivityTask> getActivityTasks(ArrayList<String> activityTasks)
	{
		ArrayList<ServiceActivityTask> activityTaskList = new ArrayList<ServiceActivityTask>()
		
		for(String taskId : activityTasks)
		{
			taskId = getIdFromSrting(taskId)
			activityTaskList.add(ServiceActivityTask.get(taskId.toLong()))
		}
		
		return activityTaskList?.sort{it?.sequenceOrder}
	}
	
	public getIdFromSrting(String taskId)
	{
		String Id = ""
		for(int i=0; i < taskId.length(); i++)
		{
			if(!taskId[i].equals("\\"))
				Id = Id + taskId[i]
		}
		return Id
	}
	/*below method convert old descriptionvalue of service Deliverable into description class by creating new object of it*/
	
	public void createNewServiceDeliverableDescription(ServiceDeliverable sDeliverable, String description)
	{
		Description deliverableDescription = new Description()
		deliverableDescription.setDeliverableDescriptionName(sDeliverable?.serviceProfile?.service?.serviceName, sDeliverable?.serviceProfile?.id,
															sDeliverable?.name, sDeliverable?.id)
		deliverableDescription.setValue(description)
		
		deliverableDescription.save()
		
		sDeliverable.newDescription = deliverableDescription
		sDeliverable.save()
		
		println "created description class object for service deliverable #${sDeliverable?.id}"
	}
	
	public List getServiceProfileMetaphors(ServiceProfile serviceProfile, ServiceProfileMetaphors.MetaphorsType metaphorType)
	{
		List serviceProfileMetaphors = new ArrayList()
		for(ServiceProfileMetaphors metaphor : serviceProfile?.metaphors)
		{
			if(metaphor?.type == metaphorType)
			{
				serviceProfileMetaphors.add(metaphor)
			}
		}
		return serviceProfileMetaphors
	}
	
	public Map getServiceExceptionReport()
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def portfolioList = findUserPortfolios(user, [:])
		def serviceList = [], newServiceList = [], deliveryRoleList = [], territoryList = []
		Set tmpSet = new HashSet()
		for(Portfolio p : portfolioList)
		{
			serviceList.addAll(getPortfolioPublishServices(p))
		}
		serviceList?.sort{it?.serviceName}
		for(Service service : serviceList)
		{
			for(ServiceDeliverable sDeliverable : service?.serviceProfile?.customerDeliverables)
			{
				for(ServiceActivity sActivity : sDeliverable?.serviceActivities)
				{
					for(DeliveryRole dRole : sActivity?.rolesRequired)
					{
						if(dRole.listUndefinedGeos().size() > 0)
						{
							tmpSet.add(dRole)
						}
					}
				}
			}
			
			if(tmpSet.toList().size() > 0)
			{
				newServiceList.add(service)
				int index = newServiceList.indexOf(service)
				deliveryRoleList.add(index, tmpSet.toList())
			}
			
			tmpSet = new HashSet()
			
		}
		
		return ["serviceList": newServiceList, "deliveryRoleList": deliveryRoleList]
	}
	
	public Map getProductExceptionReport()
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def portfolioList = findUserPortfolios(user, [:])
		def serviceList = [], newServiceList = [], productList = [], territoryList = [], finalServices = []
		Set tmpSet = new HashSet(), productSet = new HashSet()
		for(Portfolio p : portfolioList)
		{
			serviceList.addAll(getPortfolioPublishServices(p))
		}
		
		for(Service service : serviceList)
		{
			if(service?.serviceProfile?.type != ServiceProfileType.INACTIVE)
			{
				for(ServiceProductItem sProductItem : service?.serviceProfile?.productsRequired)
				{				
					if(sProductItem.product.listUndefinedGeos().size() > 0)
					{
						tmpSet.add(sProductItem?.product)
					}
				}
				
				if(tmpSet.toList().size() > 0)
				{
					newServiceList.add(service)
					productSet.addAll(tmpSet)
					//int index = newServiceList.indexOf(service)
					//productList.add(index, tmpSet.toList())
				}
				
				tmpSet = new HashSet()
			}
			
		}
		println newServiceList
		serviceList = new ArrayList()
		productList = productSet.toList()
		productList.sort{it.productName}
		for(Product product : productList)
		{
			for(ServiceProductItem sProductItem : product?.serviceProductItems)
			{
				if(sProductItem?.serviceProfile?.type != ServiceProfileType.INACTIVE)
				{
					if(newServiceList.contains(sProductItem?.serviceProfile?.service))
					{
						serviceList.add(sProductItem?.serviceProfile?.service)
					}
				}
			}
			
			if(serviceList.size() > 0)
			{
				int index = productList.indexOf(product)
				//finalServices.add(index, serviceList)
				finalServices.addAll(serviceList);
				serviceList = new ArrayList()
			}
		}
		
		return ["serviceList": finalServices, "productList": productList]
	}
	
	public def updateNotification()
	{
		def notificationList = Notification.findAll("FROM Notification noti WHERE noti.objectType = 'ServiceProfile'")
		
		for(Notification noti in notificationList)
		{
			if(noti.active == true)
			{
				if(noti.reviewRequest)
				{
					def commentsList = ReviewComment.findAll("FROM ReviewComment rc WHERE rc.reviewRequest.id=:rid ORDER BY rc.dateModified DESC", [rid: noti.reviewRequest.id])
					if(commentsList.size() > 0)
					{
						def comment = commentsList[0].comment
						noti.comment = comment
						//println comment
						noti.save()
					}
				}
			}
		}	
	}
	
	public List listUserNotifications(User user, Date preLogin, Date curLogin)
	{
		def list1 = Notification.findAll("FROM Notification noti WHERE  noti.dateCreated >= :preLogin AND noti.dateCreated <= :curLogin",[ preLogin: preLogin, curLogin: curLogin])
		//println list1
		def array = []
		for(Object n in list1)
		{
			if(user in (n.receiverUsers))
			{
				//println n.receiverUsers
				array.add(n)
			}
		}
		return array.toList()
	}
	
	String buildServiceSearchQuery(Object searchFields, boolean onlyPublished)
	{
		String queryString = "from ServiceProfile ser "
		
		boolean isFirst = true
		
		List tags = null
		if(searchFields?.tags)
		{
			for(String searchword: searchFields.tags.split(" "))
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
				
				queryString += " (ser.service.tags LIKE '${searchword}%' OR ser.service.tags LIKE '%${searchword}' OR ser.service.tags LIKE '%${searchword}%' OR ser.service.tags = '${searchword}') "
				
			}
		}
		
		
		if(searchFields?.skuName)
		{
			if(isFirst)
			{
				queryString += " WHERE ser.service.skuName LIKE '%${searchFields.skuName}%'"
				isFirst = false
			}
			else
			{
				queryString += " AND ser.service.skuName LIKE '%${searchFields.skuName}%'"
			}
		}
									
		if(searchFields?.serviceName)
		{
			if(isFirst)
			{
				queryString += " WHERE ser.service.serviceName LIKE '%${searchFields.serviceName}%'"
				isFirst = false
			}
			else
			{
				queryString += " AND ser.service.serviceName LIKE '%${searchFields.serviceName}%'"
			}
		}
		
		
		if(searchFields?.portfolio?.id && searchFields?.portfolio?.id != "all")
		{
			if(isFirst)
			{
				queryString += " WHERE ser.service.portfolio.id = ${searchFields.portfolio.id}"
				isFirst = false
			}
			else
			{
				queryString += " AND ser.service.portfolio.id = ${searchFields.portfolio.id}"
			}
		}
		
		//if(onlyPublished || searchFields?.publishedFlag == 'Published Only')
		if( searchFields?.publishedFlag )
		{
			if(isFirst)
			{
				//queryString += " WHERE ser.stagingStatus.name = 'published'"
				if( searchFields?.publishedFlag == 'published' ){
					queryString += " WHERE ser.stagingStatus.name = 'published'"
				}
				else if( searchFields?.publishedFlag == 'DEV' ){
					queryString += " WHERE ser.stagingStatus.name not in ('published','removed','requesttoremove','rejected','inActive') "
				}
				else if( searchFields?.publishedFlag == 'REMOVE' ){
					queryString += " WHERE  ser.stagingStatus.name in ('removed','requesttoremove','rejected','inActive') "
				}
				isFirst = false
			}
			else
			{
				//queryString += " AND ser.stagingStatus.name = 'published'"
				if( searchFields?.publishedFlag == 'published' ){
					queryString += " AND ser.stagingStatus.name = 'published'"
				}
				else if( searchFields?.publishedFlag == 'DEV' ){
					queryString += " AND ser.stagingStatus.name not in ('published','removed','requesttoremove','rejected','inActive') "
				}
				else if( searchFields?.publishedFlag == 'REMOVE' ){
					queryString += " AND ser.stagingStatus.name in ('removed','requesttoremove','rejected','inActive') "
				}
			}
			
		}
		def user1 = User.get(new Long(SecurityUtils.subject.principal))
		def us = user1.id
		
		List map = new ArrayList()
		
		int counter = 0;
		for(Object r in user1.roles)
		{
			map[counter++] = r.name
		}
		
		if(!map.contains("SYSTEM ADMINISTRATOR"))
		{
			//if(SecurityUtils.subject.hasRole("PRODUCT MANAGER"))
			//{
				if(isFirst)
				{
					queryString += " WHERE (ser.service.productManager.id = ${us} OR ser.serviceDesignerLead.id = ${us} OR ser.service.portfolio.portfolioManager.id = ${us})"
					isFirst = false
				}
				else
				{
					queryString += " AND (ser.service.productManager.id = ${us} OR ser.serviceDesignerLead.id = ${us} OR ser.service.portfolio.portfolioManager.id = ${us}) "
				}
				
			/*}
			if(SecurityUtils.subject.hasRole("SERVICE DESIGNER"))
			{
				if(isFirst)
				{
					queryString += " WHERE (ser.serviceDesignerLead.id = ${us} )"//OR ser.service.portfolio.portfolioManager.id = ${us})"
					isFirst = false
				}
				else
				{
					queryString += " AND (ser.serviceDesignerLead.id = ${us} )"//OR ser.service.portfolio.portfolioManager.id = ${us}) "
				}
			}
			if(SecurityUtils.subject.hasRole("PORTFOLIO MANAGER"))
			{
				if(isFirst)
				{
					queryString += " WHERE (ser.service.portfolio.portfolioManager.id = ${us})"
					isFirst = false
				}
				else
				{
					queryString += " AND (ser.service.portfolio.portfolioManager.id = ${us}) "
				}
			}*/
		}
		
		return queryString
	}

	String buildServiceSearchCatalogQuery(Object searchFields)
	{
		String queryString = "from Service s WHERE 1 = 1 "
		
		boolean isFirst = true
		
		List tags = null
		if(searchFields?.tags)
		{
			queryString += " and ("
			for(String searchword: searchFields.tags.split(" "))
			{
				if(isFirst)
				{
					isFirst = false
				}
				else
				{
					queryString += " OR "
				}
		
				queryString += " (s.tags LIKE '${searchword}%' OR s.tags LIKE '%${searchword}' OR s.tags LIKE '%${searchword}%' OR s.tags = '${searchword}') "
			
			}
			queryString += ")"
		}

		if(searchFields?.skuName)
		{
			queryString += " AND s.skuName LIKE '%${searchFields.skuName}%'"
		}
									
		if(searchFields?.serviceName)
		{
			queryString += " AND s.serviceName LIKE '%${searchFields.serviceName}%'"
		}
		
		if(searchFields?.datePublished)
		{
			queryString += " AND date(s.serviceProfile.dateModified) = STR_TO_DATE('${searchFields.datePublished}','%m/%d/%Y')"
		}
		
		if(searchFields?.portfolio?.id && searchFields?.portfolio?.id != "all")
		{
			queryString += " AND s.portfolio.id = ${searchFields.portfolio.id}"
		}
		
		if(searchFields?.publishedFlag == "published"){
			queryString += " AND s.serviceProfile.stagingStatus.name = '"+searchFields?.publishedFlag+"'"
		}
		
		def user1 = User.get(new Long(SecurityUtils.subject.principal))
		def us = user1.id
		
		List map = new ArrayList()
		
		int counter = 0;
		for(Object r in user1.roles)
		{
			map[counter++] = r.name
		}
		
		if(!map.contains("SYSTEM ADMINISTRATOR"))
		{
			/*if(isFirst)
			{
				queryString += " WHERE (s.productManager.id = ${us} OR s.serviceDesignerLead.id = ${us} OR s.portfolio.portfolioManager.id = ${us})"
				isFirst = false
			}
			else
			{*/
				queryString += " AND (s.productManager.id = ${us} OR s.serviceProfile.serviceDesignerLead.id = ${us} OR s.portfolio.portfolioManager.id = ${us}) "
			//}
		}
		
		return queryString
	}
	/*   Card#594 */
	
	List findUserPortfolios(User user, Map params)
	{
		if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR"))
		{
			return Portfolio.list([max:params.max, offset: params.offset?:0,sort: (params.sort?:"dateModified"), order: (params.order?: "desc")] )
		}
		
		return Portfolio.findAll("from Portfolio p where p.portfolioManager = :user", [user: user], [sort: (params.sort?:"dateModified"), order: (params.order?: "desc")  ])
	}
	
	List getPortfolioPublishServices(Portfolio portfolio)
	{
		return Service.findAll("FROM Service s WHERE s.portfolio.id=:pid AND s.serviceProfile.stagingStatus.name = :status order by serviceName", [status: "published", pid: portfolio.id])
	}
	
	List findUserServicesByStaging(User user, ServiceProfileType type )
	{
		List retList 
		
		def c = ServiceProfile.createCriteria()
					
		if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR"))
		{
			if(type)
				retList = ServiceProfile.findAll("from ServiceProfile sp where sp.type=:type order by dateModified desc", [type: type] )
			else
				retList = ServiceProfile.findAll("from ServiceProfile sp order by dateModified desc")
		}
		else
		{
			if(type)
				retList = ServiceProfile.findAll("from ServiceProfile sp where sp.type=:type and (sp.serviceDesignerLead = :user or sp.service.productManager = :user or sp.service.portfolio.portfolioManager = :user) order by dateModified desc", [type: type, user: user] )
			else
				retList = ServiceProfile.findAll("from ServiceProfile sp where sp.serviceDesignerLead = :user or sp.service.productManager = :user or sp.service.portfolio.portfolioManager = :user order by dateModified desc", [user: user] )
		}
		
		return retList
		
	}
	
	
		
	private List buildQueryForFindUserPortfolioServices(User user , Object findField)
	{
		def pid = findField.portfolio.id
		def servicesList
		if(findField?.portfolio?.id && findField?.portfolio?.id != "all")
		{
			servicesList = Service.findAll("from Service sr WHERE sr.portfolio.portfolioManager.id = :uid AND sr.portfolio.id = ${findField.portfolio.id} ", [uid: user.id])
		}
		
		else if(findField?.portfolio?.id == "all" || findField?.role?.id == null)
		{
			servicesList = Service.findAll("from Service sr WHERE sr.portfolio.portfolioManager.id = :uid", [uid: user.id])
		}
		// OR sr.portfolio.otherPortfolioManagers.id = :uid
		return servicesList
	}
	
	
	private List findUsersByRole(String roleName)
	{println roleName
		List roles = Role.findAll("FROM Role role WHERE role.code=:roleCode", [roleCode: roleName])
		List tmpList = new ArrayList()
		for(Role role : roles)
		{
			for(UserBase user in role?.users)//Role.findByCode(roleName)?.users)
			{
				tmpList.add(User.get(user.id))
			}
		}
		
		
		return userService.filterUserList(tmpList)
	}
	
	public int countAssignedPortfolios(User user)
	{
		def portfolioList = Portfolio.findAll("from Portfolio pf WHERE pf.portfolioManager.id = :uid",[uid: user.id])
		//println portfolioList
		return portfolioList.size()	
	}
	
	public List findProductManagers()
	{
		
		 List pms = findUsersByRole("PRODUCT MANAGER")
		 return pms.sort{x,y -> x.toString() <=> y.toString()}
	}
	
	public List findPortfolioManagers()
	{
		 List pms = findUsersByRole("PORTFOLIO MANAGER")
		 return pms.sort{x,y -> x.toString() <=> y.toString()}
	}
	
	public List findServiceDesigners()
	{
		 List sds = findUsersByRole("SERVICE DESIGNER")
		 return sds.sort{x,y -> x.toString() <=> y.toString()}
	}
	
	public boolean updateServiceToPricelist(ServiceProfile serviceProfile)
	{
		return updateServiceToPricelist(serviceProfile, null)
	}
	
	public List productManagerPortfolios(User user)
	{
		Set sr = []
		def serviceList = Service.findAll("from Service sr WHERE sr.productManager.id = :uid", [uid: user.id])
		for(Service ser in serviceList)
		{
			sr.add(ser.portfolio.portfolioName)
		}
		
		return sr.toList()
	}
	
	public boolean	updateServiceToPricelist(ServiceProfile serviceProfile, User user)
	{
		def geoList = Geo.list()
		
		for(Geo geo in geoList)
		{
			pricelistForGeoService(geo, serviceProfile, user)
		}
		
		return true
	}
	
	public void updatePricelistForGeo(Geo geo)
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def services = Service.listPublished(user)
		
		for(Service service : services)
		{
			pricelistForGeoService(geo, service?.serviceProfile, user)
		}
	}
	
	public void pricelistForGeoService(Geo geo, ServiceProfile serviceProfile, User user)
	{
		List roles = serviceProfile.requiredRolesList()
		
		def pricelists = Pricelist.findAll("FROM Pricelist pl WHERE pl.serviceProfile.id = :sid AND pl.geo.id = :gid", [sid: serviceProfile?.id, gid: geo?.id])//Pricelist.findByServiceProfileAndGeo(serviceProfile, geo)
			
		//println serviceProfile?.service.serviceName + " : " +geo + " : " + roles + " : "+ pricelist
		if(pricelists.size() > 0)
		{
			for(Pricelist pricelist : pricelists)
			{
				if(pricelist && pricelist.isTemporary != "yes")
				{
					if(geo.hasAllRolesDefined(geo, roles))
					{
						Map prices = priceCalculationService.deriveServicePrice(serviceProfile, geo)
						pricelist.basePrice =  prices["basePrice"]
						pricelist.additionalPrice = prices["additionalPrice"]
						pricelist.dateModified = new Date()
						pricelist.modifiedBy = user
						pricelist.save(flush: true)
						println "Pricelist saved for ${serviceProfile}" + " : " + geo
						
					}
					else
					{
						if(pricelist.isTemporary != "yes")
						{
							pricelist.delete(flush: true)
							println "Pricelist deleted for ${serviceProfile}" + " : " + geo
						}
						
					}
				}
				
			}
		}
		else
		{
			
			if(geo.hasAllRolesDefined(geo, roles))
			{
				Map prices = priceCalculationService.deriveServicePrice(serviceProfile, geo)
				def pricelist = new Pricelist(serviceProfile: serviceProfile, geo: geo, basePrice: prices["basePrice"],
							additionalPrice: prices["additionalPrice"], dateModified: new Date(), modifiedBy: user).save(flush:true)
							
				println "Pricelist created for ${serviceProfile}" + " : " + geo
							
			}
		}
		
		
			
	}
	
	private int countUserByRole(String roleName)
	{
		int counter = 0
		
		def userlist = User.findAll("from User us")
		List list1 = new ArrayList()
		
			for(Object u in userlist)
			{
				for(Object r in u.roles)
				{
					if(r.name == roleName)
					{
						counter++
					}
				}
				
			}
		return counter
	}
	
	/*public User grantPermission(User user)
	{
		def serviceList = Service.findAll()
		println serviceList
		boolean permit
		for(Service ser in serviceList)
		{
			if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR"))
			{
				//user.addToPermissions("Service:*:${ser.serviceProfile.id}")
					if(SecurityUtils.subject.isPermitted("service:create"))
						{println "create"}
					if(SecurityUtils.subject.isPermitted("service:read"))
						{println "read"}
					if(SecurityUtils.subject.isPermitted("service:update"))
						{println "update"}
			}
			else
			{
				if(ser.portfolio.portfolioManager.id == user.id)
				{
					//user.addToPermissions("Service:*:${ser.serviceProfile.id}")
					
					if(SecurityUtils.subject.isPermitted("service:create"))
						{println "create"}
					if(SecurityUtils.subject.isPermitted("service:read"))
						{println "read"}
					if(SecurityUtils.subject.isPermitted("service:update"))
						{println "update"}
				}
				else
				{
					//user.addToPermissions("Service:read:${ser.serviceProfile.id}")
					
					if(SecurityUtils.subject.isPermitted("service:create"))
						{println "create"}
					if(SecurityUtils.subject.isPermitted("service:read"))
						{println "read"}
					if(SecurityUtils.subject.isPermitted("service:update"))
						{println "update"}
				}
			}
		}
		//user.addToPermissions("service:*:*")
		user.save()
		return user
	}*/
}

