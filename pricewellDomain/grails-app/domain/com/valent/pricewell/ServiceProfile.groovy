package com.valent.pricewell

import java.util.Date
import java.util.HashSet
import java.util.List
import com.valent.pricewell.ServiceProfileMetaphors.MetaphorsType

class ServiceProfile {

	static searchable = true

	private static int ROUNDING_MODE = BigDecimal.ROUND_HALF_EVEN;
	private static int DECIMALS = 2;


	int revision = 1
	String versionString = "1.0"
	ServiceProfileType type
	String unitOfSale;
	int baseUnits = 1;
	Date dateCreated;
	Date datePublished;
	Date dateModified;
	BigDecimal totalEstimateInHoursPerBaseUnits;
	BigDecimal totalEstimateInHoursFlat;
	BigDecimal premiumPercent = 0
	Staging stagingStatus; //InProgress, RequestForReview, NeedInfo, Approved, Published
	int currentStep = 1;
	User serviceDesignerLead
	ServiceProfile oldProfile
	ServiceProfile newProfile
	enum ServiceProfileType {DEVELOP,INACTIVE,PUBLISHED}
	ReviewRequest currentReviewRequest
	String definition = "";
	String workflowMode
	
	//********* For imported services ***********//
		String isImported
		String importServiceStage
		

	static constraints = {
		revision()
		versionString(nullable: true)
		unitOfSale(nullable:true)
		type(nullable:true)
		baseUnits(nullable:true)
		totalEstimateInHoursPerBaseUnits(nullable:true)
		totalEstimateInHoursFlat(nullable:true)
		stagingStatus(nullable:true)
		dateCreated()
		dateModified(nullable:true)
		datePublished(nullable: true)
		serviceDesignerLead(nullable: true)
		reviewRequests(nullable: true)
		currentReviewRequest(nullable: true)
		definition(nullable: true)
		workflowMode(nullable : true)
		defs(nullable: true)
		metaphors(nullable: true)
		//for imported service
		importServiceStage(nullable: true)
		isImported(nullable: true)
		extraUnits(nullable: true)
	}

	static hasMany = [ 	customerDeliverables: ServiceDeliverable,
		rolesRequired: DeliveryRole,
		productsRequired: ServiceProductItem,
		otherServiceDesigners: User,
		stagingLogs: StagingLog,
		reviewRequests: ReviewRequest,
		defs: ServiceProfileSOWDef,
		metaphors: ServiceProfileMetaphors, 
		extraUnits: ExtraUnit]

	static mappedBy = [productsRequired: 'serviceProfile',
						customerDeliverables: 'serviceProfile', 
						extraUnits: 'serviceProfile']

	static belongsTo = [service: Service]

	static mapping = { definition type: "text" 
		customerDeliverables sort: 'sequenceOrder'
  }

	List<ExtraUnit> listExtraUnitsOfSaleAndUnits()
	{
		List<ExtraUnit> listOfSalesUnits = ExtraUnit.findAll("FROM ExtraUnit eu WHERE eu.serviceProfile.id = ${this.id}")
		return listOfSalesUnits
	}

	List listCustomerDeliverables()
	{
		return listCustomerDeliverables(new HashMap())
	}
	
	List listServiceProfileMetaphors(ServiceProfileMetaphors.MetaphorsType type)
	{
		return listServiceProfileMetaphors(type, new HashMap())
	}

	List listServiceProfileMetaphors(ServiceProfileMetaphors.MetaphorsType type, Map params)
	{
		String orderByColumn = (params?.sort ? params?.sort : "sequenceOrder")
		String orderType = (params?.order ? params?.order : "asc")

		String query= "FROM ServiceProfileMetaphors spMetaphores WHERE spMetaphores.serviceProfile.id = ${this.id} ORDER BY ${orderByColumn} ${orderType}"
		List metaphorsList = filterMetaphorsByType(ServiceProfileMetaphors.findAll(query), type)
		
		return metaphorsList
	}
	
	public List filterMetaphorsByType(List metaphorsList, ServiceProfileMetaphors.MetaphorsType type)
	{
		List filteredList = new ArrayList()
		for(ServiceProfileMetaphors spMetaphor : metaphorsList)
		{
			if(spMetaphor?.type == type)
			{
				filteredList.add(spMetaphor)
			}
		}
		return filteredList
	}
	
	List stagingLogs(){
		return this.stagingLogs?.sort{a,b -> b.dateModified <=> a.dateModified}
	}

	def Set responsiblePerson()
	{
		ServiceProfileSecurityProvider profileSecurity =
				new ServiceProfileSecurityProvider(this)

		def currentStage = this.stagingStatus
		Set assigneesList = null;
		assigneesList = profileSecurity.listAuthorizedUsers(currentStage)
		return assigneesList
	}

	List listCustomerDeliverables(Map params)
	{
		String orderByColumn = (params.sort? params.sort: "sequenceOrder")
		String orderType = (params.order? params.order: "asc")

		String query= "from ServiceDeliverable del where del.serviceProfile.id = ${this.id} order by ${orderByColumn} ${orderType}"

		return ServiceDeliverable.findAll(query)
	}

	Map calculateTotalEstimatedTime()
	{
		def map = [:]

		BigDecimal totalFlat = 0;
		BigDecimal totalExtra = 0;

		for(custDel in this.customerDeliverables)
		{
			for(serviceActivity in custDel.serviceActivities)
			{
				totalFlat = totalFlat.add(serviceActivity.estimatedTimeInHoursFlat ?:0)
				totalExtra = totalExtra.add(serviceActivity.estimatedTimeInHoursPerBaseUnits ?:0)
			}
		}

		map["totalFlat"] = totalFlat.setScale(DECIMALS, ROUNDING_MODE)
		map["totalExtra"] = totalExtra.setScale(DECIMALS, ROUNDING_MODE)

		return map
	}

	String requiredRolesStringList()
	{
		Set roles = new HashSet()

		for(custDel in this.customerDeliverables)
		{
			for(serviceActivity in custDel.serviceActivities)
			{
				for(role in serviceActivity.rolesRequired)
				{
					roles.add(role.name)
				}
			}
		}

		return roles.join(",")
	}

	List requiredRolesList()
	{
		Set roles = new HashSet()

		for(custDel in this.customerDeliverables)
		{
			for(serviceActivity in custDel.serviceActivities)
			{
				for(role in serviceActivity.rolesRequired)
				{
					roles.add(role)
				}
			}
		}

		return roles.toList()
	}

	Map listRolesRequiredTable()
	{
		def map = [:]
		for(custDel in this.customerDeliverables)
		{
			for(serviceActivity in custDel.serviceActivities)
			{
				for(role in serviceActivity.rolesRequired)
				{

					if(!map.containsKey(role.name))
					{
						map.put(role.name, [:])
						map.get(role.name)["id"] = role?.id
						map.get(role.name)["activities"] = []
						map.get(role.name)["deliverables"] = []
						map.get(role.name)["flat"] = []
						map.get(role.name)["extra"] = []
						map.get(role.name)["totalExtra"] = new BigDecimal(0)
						map.get(role.name)["totalFlat"] = new BigDecimal(0)
					}

					
					BigDecimal flat =  new BigDecimal(0)
					BigDecimal extra = new BigDecimal(0)
					
					
					ActivityRoleTime roleTime = ActivityRoleTime.findByServiceActivityAndRole(serviceActivity, role)
					
					flat =  roleTime?.estimatedTimeInHoursFlat?:0
					extra =  roleTime?.estimatedTimeInHoursPerBaseUnits?:0
					

					map.get(role.name)["activities"].add("${serviceActivity.name}")
					map.get(role.name)["deliverables"].add("${custDel.name}")
					map.get(role.name)["flat"].add(flat)
					map.get(role.name)["extra"].add(extra)

					map.get(role.name)["totalFlat"] +=  flat
					map.get(role.name)["totalExtra"] += extra

					map.get(role.name)["totalFlat"].setScale(DECIMALS, ROUNDING_MODE)
					map.get(role.name)["totalExtra"].setScale(DECIMALS, ROUNDING_MODE)
				}

			}
		}
		return map
	}

	String toString()
	{
		"${this.service.serviceName} [revision ${this.revision}]"
	}

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
	
	ServiceProfile createUpgradedService(User modifyingUser, String workflowMode)
	{

		ServiceProfile sp = this

		ServiceProfile newProfile = new ServiceProfile()

		newProfile.properties = sp.properties

		newProfile.customerDeliverables = new ArrayList()
		newProfile.otherServiceDesigners = new ArrayList()
		newProfile.productsRequired = new ArrayList()
		newProfile.reviewRequests = new ArrayList()
		newProfile.rolesRequired = new ArrayList()
		newProfile.stagingLogs = new ArrayList()
		newProfile.defs = new ArrayList()
		newProfile.metaphors = new ArrayList()
		newProfile.extraUnits = new ArrayList()

		newProfile.revision = sp.revision + 1
		newProfile.type = ServiceProfileType.DEVELOP
		newProfile.stagingStatus = Staging.findByName('concept')
		newProfile.importServiceStage = ""
		newProfile.isImported = ""
		newProfile.dateCreated = new Date()
		newProfile.dateModified = new Date()
		newProfile.oldProfile = sp
		newProfile.newProfile = null
		newProfile.currentStep = 1
		newProfile.workflowMode = workflowMode

		newProfile.save(flush:true)

		sp.newProfile = newProfile
		sp.save(flush:true)

		//Copy Customer Deliverables
		for(ServiceDeliverable del in sp.customerDeliverables)
		{
			def newDel = new ServiceDeliverable()
			newDel.properties['sequenceOrder','name','type', 'phase'] = del.properties
			newDel.serviceActivities = new ArrayList()

			newProfile.addToCustomerDeliverables(newDel)
			newDel.save()
			
			createNewServiceDeliverableDescription(newDel, del?.newDescription?.value)

			for(activity in del?.serviceActivities)
			{
				def newAct = new ServiceActivity()
				newAct.properties = activity.properties

				newAct.rolesEstimatedTime = new ArrayList()
				newAct.rolesRequired = new ArrayList()
				newAct.activityTasks = new ArrayList()

				newDel.addToServiceActivities(newAct)

				newAct.save(flush:true)

				for(role in activity?.rolesRequired)
				{
					newAct.addToRolesRequired(role)
				}

				for(roleEstimate in activity?.rolesEstimatedTime)
				{
					def newEst = new ActivityRoleTime()
					newEst.properties = roleEstimate.properties
					newAct.addToRolesEstimatedTime(newEst)
					newEst.save(flush:true)
				}
				
				for(saTask in activity?.activityTasks)
				{
					ServiceActivityTask newSATask = new ServiceActivityTask()
					newSATask.task = saTask.task
					newSATask.sequenceOrder = saTask.sequenceOrder
					newAct.addToActivityTasks(newSATask)
					newSATask.save(flush:true)
				}


			}

		}

		for(ServiceProfileSOWDef sowDef : sp?.defs)
		{
			ServiceProfileSOWDef newSowDef = new ServiceProfileSOWDef()
			newSowDef.sp = newProfile
			newSowDef.geo = sowDef.geo
			newSowDef.part = sowDef.part
			
			newSowDef.definitionSetting = new Setting(name: sowDef.definitionSetting?.name, value: sowDef?.definitionSetting?.value).save()
			newSowDef.save()
			newProfile.addToDefs(newSowDef)
		}
		//Copy references of otherServiceDesigners

		for(designer in sp.otherServiceDesigners)
		{
			newProfile.addToOtherServiceDesigners(designer)
		}


		//Copy and create productsRequired
		for(product in sp.productsRequired)
		{
			def newProduct = new ServiceProductItem()
			newProduct.properties = product.properties
			newProfile.addToProductsRequired(newProduct)
			newProduct.save(flush:true)
		}

		//Copy references of rolesRequired
		for(role in sp.rolesRequired)
		{
			newProfile.addToRolesRequired(role)
		}
		
		//Copy references of all metaphors
		for(ServiceProfileMetaphors metaphor in sp?.metaphors)
		{
			ServiceProfileMetaphors newMetaphor = new ServiceProfileMetaphors()
			newMetaphor.sequenceOrder = metaphor.sequenceOrder
			newMetaphor.type = metaphor.type
			def name = metaphor?.definitionString?.name, value = metaphor?.definitionString?.value
			newMetaphor.definitionString = new Setting(name: name, value: value).save()
			newMetaphor.serviceProfile = newProfile
			newMetaphor.save(flush: true)
			
			newProfile.addToMetaphors(newMetaphor)
		}

		for(ExtraUnit eu: sp?.extraUnits)
		{
			ExtraUnit newEu = new ExtraUnit()
			newEu.unitOfSale = eu.unitOfSale
			newEu.extraUnit = eu.extraUnit
			newEu.shortName = eu.shortName
			newEu.save()
			
			newProfile.addToExtraUnits(newEu)
		}
		//Check for stagingLogs
		/*StagingLog log1 = new StagingLog(dateModified: new Date(), action: "new version", fromStage: "",
				toStage: newProfile.stagingStatus, comment: "Version ${newProfile.revision} created from version ${sp.revision}",
				modifiedBy: modifyingUser, revision: newProfile.revision).save(flush: true)
		//log1.save()//flush:true)
		
		newProfile.addToStagingLogs(log1)
		*/

		newProfile.save(flush:true)

		return newProfile
	}


	static ReviewRequest findCurrentReviewRequest(ServiceProfile sp)
	{
		if(sp.currentReviewRequest != null){
			return sp.currentReviewRequest;
		}

		Date maxDate = new Date(Long.MIN_VALUE)

		ReviewRequest ret = null

		for(ReviewRequest request: sp.reviewRequests)
		{
			if(request.fromStage == sp.stagingStatus && request.status == ReviewRequest.Status.REVIEW && request.dateCreated.after(maxDate) )
			{
				ret = request
				maxDate = request.dateCreated
			}
		}

		return ret
	}
	
	ServiceProfile createNewProfile() {
		ServiceProfile newProfile = new ServiceProfile();
		
		newProfile.properties = this.properties
		
		newProfile.customerDeliverables = new ArrayList()
		newProfile.otherServiceDesigners = new ArrayList()
		newProfile.productsRequired = new ArrayList()
		newProfile.reviewRequests = new ArrayList()
		newProfile.rolesRequired = new ArrayList()
		newProfile.stagingLogs = new ArrayList()
		newProfile.defs = new ArrayList()
		newProfile.metaphors = new ArrayList()
		
		newProfile.revision = 1
		newProfile.type = ServiceProfileType.DEVELOP
		newProfile.stagingStatus = Staging.findByName('concept')
		newProfile.importServiceStage = ""
		newProfile.isImported = ""
		newProfile.dateCreated = new Date()
		newProfile.dateModified = new Date()
		newProfile.oldProfile = null
		newProfile.newProfile = null
		newProfile.currentStep = 1
		newProfile.workflowMode = workflowMode
		
		newProfile.save(flush:true)
		
		for(ServiceDeliverable del in this.customerDeliverables)
		{
			def newDel = new ServiceDeliverable()
			newDel.properties['sequenceOrder','name','type', 'phase'] = del.properties['sequenceOrder','name','type', 'phase']
			newDel.serviceActivities = new ArrayList()

			newProfile.addToCustomerDeliverables(newDel)
			newDel.save()
			
			createNewServiceDeliverableDescription(newDel, del?.newDescription?.value)

			for(activity in del?.serviceActivities)
			{
				def newAct = new ServiceActivity()
				newAct.properties = activity.properties

				newAct.rolesEstimatedTime = new ArrayList()
				newAct.rolesRequired = new ArrayList()
				newAct.activityTasks = new ArrayList()

				newDel.addToServiceActivities(newAct)

				newAct.save(flush:true)

				for(role in activity?.rolesRequired)
				{
					newAct.addToRolesRequired(role)
				}

				for(roleEstimate in activity?.rolesEstimatedTime)
				{
					def newEst = new ActivityRoleTime()
					newEst.properties = roleEstimate.properties
					newAct.addToRolesEstimatedTime(newEst)
					newEst.save(flush:true)
				}
				
				for(saTask in activity?.activityTasks)
				{
					ServiceActivityTask newSATask = new ServiceActivityTask()
					newSATask.task = saTask.task
					newSATask.sequenceOrder = saTask.sequenceOrder
					newAct.addToActivityTasks(newSATask)
					newSATask.save(flush:true)
				}


			}

		}

		for(ServiceProfileSOWDef sowDef : this?.defs)
		{
			ServiceProfileSOWDef newSowDef = new ServiceProfileSOWDef()
			newSowDef.sp = newProfile
			newSowDef.geo = sowDef.geo
			newSowDef.part = sowDef.part
			
			newSowDef.definitionSetting = new Setting(name: sowDef.definitionSetting?.name, value: sowDef?.definitionSetting?.value).save()
			newSowDef.save()
			newProfile.addToDefs(newSowDef)
		}
		//Copy references of otherServiceDesigners

		for(designer in this.otherServiceDesigners)
		{
			newProfile.addToOtherServiceDesigners(designer)
		}


		//Copy and create productsRequired
		for(product in this.productsRequired)
		{
			def newProduct = new ServiceProductItem()
			newProduct.properties = product.properties
			newProfile.addToProductsRequired(newProduct)
			newProduct.save(flush:true)
		}

		//Copy references of rolesRequired
		for(role in this.rolesRequired)
		{
			newProfile.addToRolesRequired(role)
		}
		
		//Copy references of all metaphors
		for(ServiceProfileMetaphors metaphor in this?.metaphors)
		{
			ServiceProfileMetaphors newMetaphor = new ServiceProfileMetaphors()
			newMetaphor.sequenceOrder = metaphor.sequenceOrder
			newMetaphor.type = metaphor.type
			def name = metaphor?.definitionString?.name, value = metaphor?.definitionString?.value
			newMetaphor.definitionString = new Setting(name: name, value: value).save()
			newMetaphor.serviceProfile = newProfile
			newMetaphor.save(flush: true)
			
			newProfile.addToMetaphors(newMetaphor)
		}

		newProfile.save(flush:true)
		
		return newProfile;
	}
}
