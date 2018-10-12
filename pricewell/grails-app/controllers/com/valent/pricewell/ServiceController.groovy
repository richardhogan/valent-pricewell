package com.valent.pricewell

import grails.converters.JSON

import org.apache.shiro.SecurityUtils
import grails.plugins.nimble.core.*
import com.ibm.icu.text.SimpleDateFormat
import com.valent.pricewell.ServiceProfile.ServiceProfileType
import com.valent.pricewell.ServiceProfileMetaphors.MetaphorsType
import org.springframework.web.multipart.MultipartFile;
import java.text.SimpleDateFormat
//import org.hibernate.collection.PersistentSet;

class ServiceController {

	def serviceCatalogService
	def constant
	def priceCalculationService
	def serviceStagingService, fileUploadService, userService
	def exportService, serviceExportService, serviceImportService
	def sendMailService, reviewService, readImportedFileService, defaultEntityOperationService
	static allowedMethods = [save: "POST", update: "POST", delete: "POST", search: ["POST", "GET"]]

	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}
	
	public static def importServiceStageSteps = [concept: [["edit", "Add requirement data"],["editDeliverables","Add Service Deliverables"],["editDefinition", "Add SOW Language"]],
											     design:  [["addActivities","Add activities and roles"],["addProducts","Define products"],["addPrerequisites","Add Pre-requisites"],["addOutOfScope","Add Out of Scope"],["showDetailedInfo","Preview"]],
											     requestforpublished: [["showDetailedInfo", "Review Service Info"]]]
	
	public static def importServiceStages = [["init", "Initialization"], ["concept", "Conceptulization"], ["design", "Design"], ["publish", "Publish"]]

	static navigation = [
		[group:'my', action:'currentlyAvailable', title: "Published", order: 10],
		[group:'my', action:'inStaging', title: 'Develop',  order: 15],
		[group:'my', action:'endOfLife', title: 'Removed', order: 20],
		[group:'my', action:'myServices', title: 'All', order: 20],
		[group: 'all', action:'search', order: 30,title: 'Search' ]
	]

	def index = {
		if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("PORTFOLIO MANAGER") )
		{
			redirect(action: "catalog", params: params)
		}
		else if(SecurityUtils.subject.hasRole("GENERAL MANAGER") || SecurityUtils.subject.hasRole("SALES MANAGER") || SecurityUtils.subject.hasRole("SALES PRESIDENT") || SecurityUtils.subject.hasRole("SALES PERSON") )
		{
			redirect(action: "allInCatalog", params: params)
		}
		else
		{
			redirect(action: "inStaging", params: params)
		}
	}
	
	def unassignedServiceProductManager = {
		List serviceListNotAssignToProductManager = new ArrayList();
		def usenobody = User.findByUsername("nobody")
		//println usenobody
		def productManagerList = serviceCatalogService.findProductManagers()
		for(ServiceProfile sf : ServiceProfile.list())
		{
			if(sf?.service?.productManager?.id == usenobody?.id)
			//if(pf?.portfolioManager == null || pf?.portfolioManager == "")
				serviceListNotAssignToProductManager.add(sf)
		}
		//println serviceListNotAssignToProductManager
		
		if(serviceListNotAssignToProductManager.size() > 0)
			render(template: "unassignedProductManagerServiceList", model :[productManagerList: productManagerList, serviceListNotAssignToProductManager: serviceListNotAssignToProductManager])
		else render "noMoreServiceLeftToAssignToProductManager"
	
	}
	
	def saveProductManagerfromException = {
		
		
		ServiceProfile serviceProfileInstance = ServiceProfile.get(params.id.toLong())
		User productManager = User.get(params.productManagerId.toLong())
		serviceProfileInstance.service.productManager = productManager
		serviceProfileInstance.dateModified = new Date()
		//serviceProfileInstance.service.serviceDescription.value = params.description
		serviceProfileInstance.save()
		
		render "success"
		
	}
	def unassignedServiceDesigner = {
		List serviceListNotAssignToServiceDesigner = new ArrayList();
		def usenobody = User.findByUsername("nobody")
		//println usenobody
		def designerList = serviceCatalogService.findServiceDesigners()
		for(ServiceProfile sf : ServiceProfile.list())
		{
			if(sf?.serviceDesignerLead != null && sf?.serviceDesignerLead != "")
			{
				if(sf?.serviceDesignerLead?.id == usenobody?.id)
				{
					serviceListNotAssignToServiceDesigner.add(sf)
					//println "sp : "+sf+" designer : "+sf?.serviceDesignerLead
				}
			}
		}
		//println serviceListNotAssignToServiceDesigner
		
		if(serviceListNotAssignToServiceDesigner.size() > 0)
			render(template: "unassignedServiceDesignerServiceList", model :[designerList: designerList, serviceListNotAssignToServiceDesigner: serviceListNotAssignToServiceDesigner])
		else render "noMoreServiceLeftToAssignToDesigner"
		
		
	}
	
	def saveServiceDesignerfromException = {
		
		
		ServiceProfile serviceProfileInstance = ServiceProfile.get(params.id.toLong())
		User serviceDesigner = User.get(params.serviceDesignerId.toLong())
		serviceProfileInstance.serviceDesignerLead = serviceDesigner
		serviceProfileInstance.dateModified = new Date()
		serviceProfileInstance.save()
		
		render "success"
		
	}
	def serviceExceptionReport = {
		Map report = [:]
		report = serviceCatalogService.getServiceExceptionReport()
		render(template: "/reports/exceptionReport", model: [serviceList: report['serviceList'], deliveryRoleList: report['deliveryRoleList'], reportType: "serviceException"])
	}
	
	def productExceptionReport = {
		Map  productException = [:]
		productException = serviceCatalogService.getProductExceptionReport()
		render(template: "/reports/exceptionReport", model: [serviceList: productException['serviceList'], productList: productException['productList'], reportType: "productException"])
	}
	
	def serviceExport = {
		def map = [:]
		ServiceProfile sProfile = ServiceProfile.get(params.serviceProfileId)
		def filePath = serviceExportService.exportService(sProfile)
		map.put("result", "success")
		map.put("filePath", filePath.replaceAll("&", "%26"))
		render map as JSON
		//render "success"
		
	}
	
	
	def selectionOfWorkflow =
	{
		
		List stagingInstanceList = Staging.listServiceStages ("NEW_STAGE")
		List<Staging> customizableStages = new ArrayList<Staging>()
		
		
		def val = Setting.findByName("workflowmode");
		Boolean isDetailedChecked = true
		Boolean isCustomizedChecked = false
		if(val != null && val.value != null && val.value == "customized")
		{
			
		    isCustomizedChecked =  true
			isDetailedChecked = false		
		}
		
		render(template: "selectWorkflow", model: [stagingInstanceList : customizableStages,isCustomizedChecked : isCustomizedChecked,isDetailedChecked:isDetailedChecked ]);
	}
	
	
	def importFile =
	{
		params.max = Math.min(params.max ? params.int('max') : 10, 100)
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def portfolioList = serviceCatalogService.findUserPortfolios(user, params)
		//render(template: "importFile", model: [portfolioList: portfolioList])
		render(view: "importServiceFile", model: [portfolioList: portfolioList])
	}
	
	def serviceImport = {
		
		def resultMap = [:]
		
		MultipartFile file = request.getFile('file')
		
		Portfolio portfolio = Portfolio.get(params.portfolioId.toLong())
		def storagePath = fileUploadService.getStoragePath("sampleFiles")
		
		//newFile = 
		def destinationFilePath = readImportedFileService.readFileToCheckSpecialCharacter(file, storagePath)
		File newFile = new File(destinationFilePath)
		
		List services = readImportedFileService.readServiceFile(newFile)//gives list of service with properties map
		
		String unavailableServiceName = ""
		boolean isServiceAvailable = false
		for(Map serviceProperties : services)
		{
			unavailableServiceName = serviceProperties["serviceName"]
			
				if(serviceImportService.isServiceAlreadyExist(unavailableServiceName))
				{
					isServiceAvailable = true
					break;
				}
		}
		
		if(!isServiceAvailable)
		{
			def dataMap = [:]
			dataMap['services'] = services; dataMap['unAvailableDeliveryRoles'] = []; dataMap['mappedArray'] = []
			dataMap = serviceImportService.checkOrCorrectDeliveryRole(dataMap, "check")
			
			List unAvailableDeliveryRoles = dataMap['unavailableRoles']
			List roleActivityList = dataMap['roleActivityList']
			
			if(unAvailableDeliveryRoles.size() > 0)
			{
				def content = g.render(template: "checkForDeliveryRoles", model: [unAvailableDeliveryRoles: unAvailableDeliveryRoles, roleActivityList: roleActivityList, portfolio: portfolio, services: services, filePath: destinationFilePath])
				
				resultMap.put("result", "unmatchedDeliveryRoles")
				resultMap.put("content", content)
				render resultMap as JSON
			}
			else{
				redirect(action: "saveImport", params: [unAvailableDeliveryRoles: unAvailableDeliveryRoles, portfolioId: portfolio.id, source: "redirect", filePath: destinationFilePath])
			}
		}
		else
		{
			resultMap.put("result", "serviceAvailable")
			resultMap.put("responseMessage", "A service with the name ${unavailableServiceName} already exists. Please change it first and then import again.")
			render resultMap as JSON
		}
		
		
	}
	
	def saveImport = 
	{
		
		List services = [], unAvailableDeliveryRoles = [], mappedArray = []
		/*if(params.source == "checkedDeliveryRole")
		{
			*/
			File newFile = new File(params.filePath)
			services = readImportedFileService.readServiceFile(newFile)
			def fmap = [:]
			fmap['services'] = services; fmap['unAvailableDeliveryRoles'] = []; fmap['mappedArray'] = []
			fmap = serviceImportService.checkOrCorrectDeliveryRole(fmap, "check")
			
			unAvailableDeliveryRoles = fmap['unavailableRoles']
		/*}
		else if(params.source == "redirect")
		{
			services = params.services
			unAvailableDeliveryRoles = params.unAvailableDeliveryRoles
		}*/
		
		Portfolio portfolio = Portfolio.get(params.portfolioId.toLong())
		
		if(unAvailableDeliveryRoles.size() > 0)
		{
			for(int i = 0; i < unAvailableDeliveryRoles.size(); i++)
			{
				if(params.get("finalRole-"+i) != "")
				{
					mappedArray[i] = params.get("finalRole-"+i)
				}
				else
				{
					mappedArray[i] = unAvailableDeliveryRoles[i]
				}
			}
			
			def dataMap = [:]
			dataMap['services'] = services
			dataMap['unAvailableDeliveryRoles'] = unAvailableDeliveryRoles
			dataMap['mappedArray'] = mappedArray
			dataMap = serviceImportService.checkOrCorrectDeliveryRole(dataMap, "correct")
			services = dataMap['services']
			
		}
		
		String storagePath = fileUploadService.getStoragePath("sampleFiles")
		String dateString = System.currentTimeMillis().toString()//new SimpleDateFormat("-'date('yyyy-MM-dd')-time('HH.mm.ss')'").format(new Date())
		String randomUserId = UUID.randomUUID().toString()
		String responseFileName = storagePath+"/response"+dateString+randomUserId+".txt"
		File responseFile = new File(responseFileName)
		FileWriter fw = new FileWriter(responseFile.getAbsoluteFile())
		BufferedWriter bw = new BufferedWriter(fw)
		def resultArray = []
		
		def serviceProfileID = "";
		for(Map serviceProperties : services)
		{
			Map resultMap = serviceImportService.createImportedService(serviceProperties, portfolio)
			
			resultArray.add(resultMap["res"])
			
			serviceProfileID = resultMap["serviceProfileId"];
		
			bw.write(resultMap["res"])
			bw.newLine()
			if(resultMap["serviceId"] != null && resultMap["serviceId"] != "")
			{
				Service serviceInstance = Service.get(resultMap["serviceId"].toLong())
				def user = User.get(new Long(SecurityUtils.subject.principal))
				def map = new NotificationGenerator(g).sendServiceImportSuccessNotification(serviceInstance.serviceProfile, user);
				sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/service/show?serviceProfileId="+serviceInstance.serviceProfile.id)
				
			}
		}
		
		def content = g.render(template:"/service/response", model:[resultArray: resultArray, filePath: responseFileName, serviceProfileID: serviceProfileID])
		
		bw.newLine();bw.newLine();bw.newLine();
		bw.write("Note : See all imported files in development mode.")
		bw.close()
		//println services
		def rmap = [:]
		rmap.put("result", "success")
		rmap.put("content", content)
		rmap.put("filePath", storagePath+"/response"+dateString+".txt")
		
		render rmap as JSON
	}
	
	def serviceQuickFix = {
		ServiceProfile serviceProfileInstance = ServiceProfile.get(params.serviceProfileId)
		serviceProfileInstance.newProfile = null
		serviceProfileInstance.oldProfile = null
		serviceProfileInstance.save()
		redirect(action: "show", params: [serviceProfileId: serviceProfileInstance.id])
		
	}
	
	def myServices = {
		params.max = Math.min(params.max ? params.int('max') : 10, 100)
		def user = User.get(new Long(SecurityUtils.subject.principal))

		def servicesList = serviceCatalogService.findUserServicesByStaging(user, null)

		render(view:"list",
				model: [serviceInstanceList: servicesList, serviceInstanceTotal: servicesList.size(), title: "My All Services", , createPermit: isPermitted("create", 0)])
	}

	def look = {
		ServiceProfile profile = ServiceProfile.get(params.id);

		int index=0;
		def serviceActivity;
		def cols = profile.customerDeliverables.sort{a,b -> a.id <=> b.id};
		for(def tmp in  cols)
		{
			def cols2 = tmp.serviceActivities.sort{a,b -> a.id <=> b.id};
			for(def tmp2 in cols2){

				if(index == 1)
				{
					serviceActivity = tmp2;
				}
				index++;
			}

		}

		render(view: "/activityRoleTime/list", model: [serviceActivityInstance: serviceActivity]);
	}

	def currentlyAvailable = {
		params.max = Math.min(params.max ? params.int('max') : 10, 100)
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def servicesList = serviceCatalogService.findUserServicesByStaging(user, ServiceProfileType.PUBLISHED)

		render(view:"list",
				model: [serviceInstanceList: servicesList, serviceInstanceTotal: servicesList.size(), title: "My Published Services", createPermit: isPermitted("create", 0)])
	}

	def inStaging = {
		params.max = Math.min(params.max ? params.int('max') : 10, 100)
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def portfolioList = serviceCatalogService.findUserPortfolios(user, params)
		def servicesList = serviceCatalogService.findUserServicesByStaging(user, ServiceProfileType.DEVELOP)

		boolean instage = true
		render(view:"list",
				model: [instage: instage, serviceInstanceList: servicesList, portfolioList: portfolioList, serviceInstanceTotal: servicesList.size(), title: "My Services In Development", , createPermit: isPermitted("create", 0)])
	}

	def allInStaging = {
		params.max = Math.min(params.max ? params.int('max') : 10, 100)
		def c = ServiceProfile.createCriteria()
		ServiceProfileType type = ServiceProfileType.DEVELOP
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def portfolioList = serviceCatalogService.findUserPortfolios(user, params)
		def servicesList = ServiceProfile.findAll("from ServiceProfile sp where sp.type=:type order by dateModified desc", [type: type] )

		boolean instage = true
		render(view:"list",
				model: [instage: instage, showSearch: instage, serviceInstanceList: servicesList, portfolioList: portfolioList, serviceInstanceTotal: servicesList.size(), title: "All Services In Development", , createPermit: isPermitted("create", 0)])
	}

	def allInEndOfLife = {
		params.max = Math.min(params.max ? params.int('max') : 10, 100)
		def c = ServiceProfile.createCriteria()
		ServiceProfileType type = ServiceProfileType.INACTIVE
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def portfolioList = serviceCatalogService.findUserPortfolios(user, params)
		def servicesList = ServiceProfile.findAll("from ServiceProfile sp where sp.type=:type order by dateModified desc", [type: type] )

		boolean instage = true
		
		render(view:"list",
				model: [serviceInstanceList: servicesList, showSearch: instage, portfolioList: portfolioList, serviceInstanceTotal: servicesList.size(), title: "All Removed Services", createPermit: isPermitted("create", 0)])
	}

	def endOfLife = {
		params.max = Math.min(params.max ? params.int('max') : 10, 100)
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def portfolioList = serviceCatalogService.findUserPortfolios(user, params)
		def servicesList = serviceCatalogService.findUserServicesByStaging(user, ServiceProfileType.INACTIVE)

		render(view:"list",
				model: [serviceInstanceList: servicesList, portfolioList: portfolioList, serviceInstanceTotal: servicesList.size(), title: "My Removed Services", createPermit: isPermitted("create", 0)])
	}

	def catalog = {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def portfolioList = serviceCatalogService.findUserPortfolios(user, params)
		
		def services = Service.listPublished(user)
		[serviceInstanceList: services, portfolioList: portfolioList, createPermit: isPermitted("create", 0),  title: "My Published Services"]
	}

	def allInCatalog = {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def portfolioList = serviceCatalogService.findUserPortfolios(user, params)

		def services = Service.findAll("FROM Service s WHERE s.serviceProfile.stagingStatus.name = :status order by serviceName", [status: "published"])

		render(view:"catalog",
				model: [serviceInstanceList: services, portfolioList: portfolioList, createPermit: isPermitted("create", 0), title: "All Published Services"])
	}

	def refreshPricelist = {
		def services = Service.listPublished()
		def user = User.get(new Long(SecurityUtils.subject.principal))
		for(Service service in services)
		{
			serviceCatalogService.updateServiceToPricelist(service.serviceProfile, user)
		}

		redirect(action: (params.caller?: "pricelist"))
	}


	def searchServices = {
		params.max = Math.min(params.max ? params.int('max') : 10, 100)
		render(view:"list",
				model: [serviceInstanceList: ServiceProfile.list(params), serviceInstanceTotal: servicesList.size(), title: "Search Services", showSearch: true, , createPermit: isPermitted("create", 0)])
	}

	/*   Card#594 */
	def search = {

		String queryString = serviceCatalogService.buildServiceSearchQuery(params.searchFields,(params.mode == "sales"))

		def servicesList = ServiceProfile.findAll(queryString)

		boolean instage = false
		
		if( params.searchFields?.publishedFlag == "DEV" ){
			instage = true
		}
		
		if(params.mode == "sales")
		{
			render(view: "/quotation/searchServices",
					model: [instage:instage, serviceInstanceList: servicesList, serviceInstanceTotal: servicesList.size(), title: "Search Services", showSearch: true, searchFields: params.searchFields])
		}
		else
		{
			render(view:"list",
					model: [instage:instage, serviceInstanceList: servicesList, serviceInstanceTotal: servicesList.size(), title: "Search Services", showSearch: true, searchFields: params.searchFields, serviceMode: params.searchFields?.publishedFlag , createPermit: isPermitted("create", 0)])
		}
	}
	/*   Card#594 */

	def list = {
		redirect(action: "myServices", params: params)
	}

	def addDeliverable =
	{
		def serviceProfileInstance = ServiceProfile.get(params.id)
		def deliverablesList = serviceProfileInstance.listCustomerDeliverables(params)
		List<String> deliverableTypes = ServiceDeliverable.executeQuery("SELECT DISTINCT UPPER(sd.type) from ServiceDeliverable sd ORDER BY sd.type ASC")
		
		render(template: "/serviceDeliverable/newCustomerDeliverable", model: [serviceProfileId: serviceProfileInstance.id, deliverablesList: deliverablesList, deliverableTypes: deliverableTypes]);
	}
	
	def addActivity =
	{
		def del = ServiceDeliverable.get(params.deliverableId.toInteger())
		println del
		
		List<String> serviceActivityCategories = ServiceActivity.executeQuery("SELECT DISTINCT UPPER(sa.category) from ServiceActivity sa WHERE sa.category != null ORDER BY sa.category ASC")
		render(template: "/serviceActivity/createDeliverableActivity", model: [serviceDeliverableId: del.id, deliverable: del, serviceActivityCategories: serviceActivityCategories]);
	}

//*****************************old import method*****************************************************
	def importService = { //old import method
		def serviceInstance = new Service()
		
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def portfolioList = serviceCatalogService.findUserPortfolios(user, params)

		serviceInstance.properties = params
		serviceInstance.serviceProfile = new ServiceProfile()
		def productManagerList = serviceCatalogService.findProductManagers()
		
		render(view: "importService", model: [serviceInstance: serviceInstance, portfolioList: portfolioList, serviceProfileInstance: serviceInstance.serviceProfile, importServiceStages: importServiceStages]);
			
	} 
	
	def showImportStages = {
		String source = params.source
		
		def importStep = importServiceStageSteps[source]
		def user = User.get(new Long(SecurityUtils.subject.principal))
		
		def serviceProfileInstance = ServiceProfile.get(params.id)
		
		int stepNumber = (params.step_number && params.step_number.toInteger() > 0?params.step_number.toInteger(): 1);
				
		String stepName = importStep[stepNumber-1][0]
		
		def territorySet = new HashSet()
		
		List prerequisiteMetaphorsList = serviceProfileInstance.listServiceProfileMetaphors(ServiceProfileMetaphors.MetaphorsType.PRE_REQUISITE)
		List outOfScopeMetaphorsList = serviceProfileInstance.listServiceProfileMetaphors(ServiceProfileMetaphors.MetaphorsType.OUT_OF_SCOPE)
		
		boolean hasDefaultSOWDefinition = false
		ServiceProfileSOWDef defaultSowDef = null
		for(ServiceProfileSOWDef sowDefinition : serviceProfileInstance?.defs)
		{
			if(sowDefinition?.geo != null && sowDefinition?.geo != "")
			{
				territorySet.add(sowDefinition?.geo)
			}
			else
			{
				hasDefaultSOWDefinition = true
				defaultSowDef = ServiceProfileSOWDef.get(sowDefinition?.id)
			}
		}
		
		if(stepName == "editDefinition")
		{
			//render(template: "editDefinition", model: [serviceProfileInstance: serviceProfileInstance, hideButtons: true])
			def definitionList = serviceProfileInstance?.defs
			boolean readOnly = false
			def defaultSowLanguageTemplate = "${message(code: 'default.sow.language', args: [serviceProfileInstance?.service?.serviceName])}"
			render(
				template: "addServiceProfileSOWDefinition", model: [serviceProfileInstance: serviceProfileInstance, defaultSowLanguageTemplate: defaultSowLanguageTemplate, definitionList: definitionList, territoryList: territorySet.toList(), hasDefaultSOWDefinition: hasDefaultSOWDefinition, defaultSowDef: defaultSowDef, readOnly: readOnly])
			return;
		}
		else if(stepName == "showDetailedInfo")
		{
			session["designPermit"] = false;
			session["serviceUpdatePermit"] = false;
			boolean readOnly = true
			render(template: "showReadOnly", model: [serviceProfileInstance: serviceProfileInstance, outOfScopeMetaphorsList: outOfScopeMetaphorsList, prerequisiteMetaphorsList: prerequisiteMetaphorsList, territoryList: territorySet.toList(), hasDefaultSOWDefinition: hasDefaultSOWDefinition, defaultSowDef: defaultSowDef, readOnly: readOnly])
			return;
		}
		
		switch(source)
		{
			case "concept":
					params.currentStep = params.step_number.toInteger();
			
					if(stepName.equals("edit"))
					{
						println"In concept-Edit"
						List<String> serviceUnitOfSaleList = ServiceProfile.executeQuery("SELECT DISTINCT UPPER(sp.unitOfSale) from ServiceProfile sp WHERE sp.unitOfSale != null ORDER BY sp.unitOfSale ASC" )
						render(template: "stage/concept-${stepName}", model: [serviceProfileInstance: serviceProfileInstance, isLightWorkflow: true, serviceUnitOfSaleList: serviceUnitOfSaleList])
					}
					else if(stepName.equals("editDeliverables"))
					{
						def deliverablesList = serviceProfileInstance.listCustomerDeliverables(params)
						List<String> deliverableTypes = ServiceDeliverable.executeQuery("SELECT DISTINCT UPPER(sd.type) from ServiceDeliverable sd ORDER BY sd.type ASC")
						render(template: "stage/concept-${stepName}", model: [serviceProfileInstance: serviceProfileInstance, 'deliverablesList': deliverablesList, deliverableTypes: deliverableTypes])
					}
					break;
					
			case "design":
					params.currentStep = params.step_number.toInteger();
					if(stepName.equals("addActivities"))
					{
						def serviceDeliverable = serviceProfileInstance?.listCustomerDeliverables()?.toArray().getAt(0)
						def activitiesList = serviceDeliverable.listServiceActivities(params)
						
						render(template: "stage/design-${stepName}", model: [serviceProfileInstance: serviceProfileInstance, activitiesList: activitiesList, serviceDeliverableInstance: serviceDeliverable])
					}
					else if(stepName.equals("addProducts"))
					{
						def productList = []
						productList = Product.list()
						render(template: "stage/design-${stepName}", model: [serviceProfileInstance: serviceProfileInstance, productList: productList])
					}
					else if(stepName.equals("addPrerequisites"))
					{
						List metaphorsList = serviceProfileInstance.listServiceProfileMetaphors(ServiceProfileMetaphors.MetaphorsType.PRE_REQUISITE)
						
						render(template: "stage/design-addMetaphors", model: [serviceProfileInstance: serviceProfileInstance, metaphorsList: metaphorsList, metaphorType: "preRequisite", entityName: "Pre-requisite"])
					}
					else if(stepName.equals("addOutOfScope"))
					{
						List metaphorsList = serviceProfileInstance.listServiceProfileMetaphors(ServiceProfileMetaphors.MetaphorsType.OUT_OF_SCOPE)
						
						render(template: "stage/design-addMetaphors", model: [serviceProfileInstance: serviceProfileInstance, metaphorsList: metaphorsList, metaphorType: "outOfScope", entityName: "Out of Scope"])
					}
					break;
		}
	}
//**********************************************************************************************************************
	public String getWorkflowMode()
	{
		Setting wrkFlw = Setting.findByName("workflowmode");
		
		if(wrkFlw == null || wrkFlw?.value == null)
		{
			println "detailed"
			return "detailed"
		}
		println wrkFlw?.value
		return wrkFlw?.value
			
	}
	
	def create = {
		def serviceInstance = new Service()
		//tmp
		serviceInstance.portfolio = Portfolio.get(1)
		//serviceInstance.otherProductManagers = User.get()
		params.max = Math.min(params.max ? params.int('max') : 10, 100)
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def portfolioList = serviceCatalogService.findUserPortfolios(user, params)

		serviceInstance.properties = params
		serviceInstance.serviceProfile = new ServiceProfile()
		def productManagerList = serviceCatalogService.findProductManagers()
		
		//List stagingInstanceList = Staging.listServiceStages ("NEW_STAGE")
		def selectedWorkflow = getWorkflowMode()
		serviceInstance.serviceProfile.workflowMode = selectedWorkflow;		
		List stagingInstanceList
		def view = "main"
		if(selectedWorkflow.toString().toUpperCase() == "CUSTOMIZED")
		{
			stagingInstanceList = Staging.listShortServiceStages ("NEW_STAGE")			
			view = "shortcutMain"
		}
		else
		{
			stagingInstanceList = Staging.listServiceStages ("NEW_STAGE")
		}
			
		render(view: view, model: [serviceInstance: serviceInstance, portfolioList: portfolioList, serviceProfileInstance: serviceInstance.serviceProfile, productManagerList: productManagerList, stagingInstanceList: stagingInstanceList]);
			
	}

	def conceptapproved = {

		def serviceProfile = null;
		if(params.serviceProfileId)
		{
			serviceProfile = ServiceProfile.get(params.serviceProfileId)
		}
		else
		{
			def serviceInstance = Service.get(params.id)
			serviceProfile = serviceInstance?.serviceProfile
		}

		if(serviceProfile)
		{
			def designerList = serviceCatalogService.findServiceDesigners()
			List stagingInstanceList = Staging.listServiceStages ("NEW_STAGE")

			render(view: "main", model: [serviceProfileInstance: serviceProfile, designerList: designerList, stagingInstanceList: stagingInstanceList]);

		}
		else
		{
			throw new RuntimeException("Invalid Service Profile id")
		}


	}

	def pricelist = {
		String queryString = serviceCatalogService.buildServiceSearchQuery(params.searchFields, true)
		long geoId = 0

		if(!params.geoId)
		{
			List geoList = Geo.list()
			if(geoList && geoList.size() > 0)
			{
				geoId = geoList[0]?.id
			}
		}
		else
		{
			geoId = params.geoId?.toLong()
		}

		Geo geoInstance = Geo.get(geoId)

		if(geoInstance)
		{
			def servicesList = ServiceProfile.executeQuery(queryString)

			if(params?.format && params.format != "html"){
				response.contentType =  ConfigurationHolder.config.grails.mime.types[params.format]
				response.setHeader("Content-disposition", "attachment; filename=pricelist.${params.extension}")

				def results = []

				def fields = [
					'portfolio',
					'serviceName',
					'skuName',
					'unitOfSale',
					'baseUnits',
					'baseHrs',
					'addHrs',
					'basePrice',
					'additionalPrice',
					'premiumPercent',
					'currency',
					'publishedDate'
				]
				def labels = ['portfolio':'Portfolio','serviceName':'Service','skuName':'SKU','unitOfSale':'Unit of Sale',
							'baseUnits':'Base Units','baseHrs':'Base Hrs','addHrs':'Add.Unit Hrs','basePrice':'Base Price',
							'additionalPrice':'Additional Price per Unit','premiumPercent':'Premium','currency':'Currency','publishedDate':'Published Date']


				for(ServiceProfile service in servicesList)
				{

					def estimateMap = service.calculateTotalEstimatedTime()
					def pricelistInstance = Pricelist.findByServiceProfileAndGeo(service, geoInstance)
					if(pricelistInstance)
					{
						results.add([
									portfolio: service.service.portfolio.portfolioName,
									serviceName: service.service.serviceName,
									skuName: service.service.skuName,
									unitOfSale: service.unitOfSale,
									baseUnits: service.baseUnits,
									baseHrs: estimateMap["totalFlat"],
									addHrs: estimateMap["totalExtra"],
									basePrice: pricelistInstance.basePrice,
									additionalPrice: pricelistInstance.additionalPrice,
									premiumPercent: service.premiumPercent,
									currency: geoInstance.currency,
									publishedDate: service.datePublished,
									id: service.id ]
								);
					}
				}

				exportService.export(params.format, response.outputStream,results, fields, labels, [:], [:])
			}
			else
			{
				[serviceInstanceList: servicesList, geoInstance: geoInstance, searchFields: params.searchFields]
			}
		}
		else
		{
			flash.message = "Select GEO to get pricelist for"
			[serviceInstanceList: null, geoInstance: null, searchFields: params.searchFields]
		}
	}

	def pricelistJSON = {
		String queryString = serviceCatalogService.buildServiceSearchQuery(params.searchFields, true)
		long geoId = 0

		if(!params.geoId)
		{
			List geoList = Geo.list()
			if(geoList && geoList.size() > 0)
			{
				geoId = geoList[0]?.id
			}
		}
		else
		{
			geoId = params.geoId?.toLong()
		}

		Geo geoInstance = Geo.get(geoId)

		if(geoInstance)
		{
			def servicesList = ServiceProfile.executeQuery(queryString)

			def results = []

			for(def service in servicesList)
			{

				def estimateMap = service.calculateTotalEstimatedTime()
				def pricelistInstance = Pricelist.findByServiceProfileAndGeo(service, geoInstance)
				if(pricelistInstance)
				{
					results.add([
								cell: [
									service.service.portfolio.portfolioName,
									service.service.serviceName,
									service.service.skuName,
									service.unitOfSale,
									service.baseUnits,
									estimateMap["totalFlat"],
									estimateMap["totalExtra"],
									pricelistInstance.basePrice,
									pricelistInstance.additionalPrice,
									service.premiumPercent,
									geoInstance.currency,
									service.datePublished
								],
								id: service.id
							]);
				}
			}

			def jsonData = [rows: results]

			render jsonData as JSON

		}
		else
		{
			throw new RuntimeException("GEO not selected")
		}
	}

	def hasDeliverables = {
		def serviceProfileInstance = ServiceProfile.get(params.id)

		boolean val = false;

		if(serviceProfileInstance.customerDeliverables &&  serviceProfileInstance.customerDeliverables.size() > 0){
			val = true;
		}

		render val
	}
	
	def hasSOWDefinition = {
		def serviceProfileInstance = ServiceProfile.get(params.id)
		
		boolean hasDefaultSOWDefinition = false;

		if(serviceProfileInstance?.defs &&  serviceProfileInstance?.defs?.size() > 0)
		{
			for(ServiceProfileSOWDef sowDef : serviceProfileInstance?.defs)
			{
				if(sowDef?.geo == null || sowDef?.geo == "")
				{
					hasDefaultSOWDefinition = true
				}
			}
			
		}

		render hasDefaultSOWDefinition
	}

	def hasServiceProductItem = {
		def serviceProfileInstance = ServiceProfile.get(params.id)
		
		boolean available = false;

		if(serviceProfileInstance?.productsRequired &&  serviceProfileInstance?.productsRequired?.size() > 0)
		{
			available = true
			
		}

		render available
	}
	
	def hasActivityRoleDefine = {
		def serviceProfileInstance = ServiceProfile.get(params.id)

		boolean val = false;
		for(ServiceDeliverable sd in serviceProfileInstance.customerDeliverables)
		{
			if(sd.serviceActivities && sd.serviceActivities.size() > 0)
			{
				for(ServiceActivity sa in sd.serviceActivities)
				{
					if(sa.rolesRequired && sa.rolesRequired.size() > 0)
					{
						val = true
					}
					else
					{
						val = false
						break
					}
				}
			}
			else
			{
				val = false
				break
			}
		}


		render val
	}

	def editDefinition =
	{
		def serviceProfileInstance = ServiceProfile.get(params.id)
		render(template: "editDefinition", model: [serviceProfileInstance: serviceProfileInstance])
		return;
	}

	def saveDefinition =
	{
		def serviceProfileInstance = ServiceProfile.get(params.id)

		if (serviceProfileInstance) {
			if (params.version) {
				def version = params.version.toLong()
				if (serviceProfileInstance.version > version) {

					serviceProfileInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [
						message(code: 'serviceProfile.label', default: 'ServiceProfile')]
					as Object[], "Another user has updated this ServiceProfile while you were editing")
					render(template: "editDefinition", model: [serviceProfileInstance: serviceProfileInstance])
					return null
				}
			}

			serviceProfileInstance.definition = params.definition
			serviceProfileInstance.dateModified = new Date()

			if (!serviceProfileInstance.hasErrors() && serviceProfileInstance.save(flush: true)) {
				render(template: "showDefinition", model: [serviceProfileInstance: serviceProfileInstance])
				return
			}
		}
	}
	
	def show = 
	{
		
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def selectedTab = (params.selectedTab? params.selectedTab: 'deliverables')
		def serviceProfile = null;
		if(params.serviceProfileId)
		{
			serviceProfile = ServiceProfile.get(params.serviceProfileId)
			if(params.notificationId)
			{
				def note = Notification.get(params.notificationId)
				note.active = false
				//println note.reviewRequest.id
				note.save(flush:true)
			}
		}
		else
		{
			def serviceInstance = Service.get(params.id)
			serviceProfile = serviceInstance?.serviceProfile
		}
		
		if(serviceProfile)
		{
			ServiceProfileSecurityProvider profileSecurity =
					new ServiceProfileSecurityProvider(serviceProfile, User.get(new Long(SecurityUtils.subject.principal)))

			storePermissionsInSession(serviceProfile);
			def responsiblePersons = []
			
			boolean checkResponsiblity = false
			if(serviceProfile?.isImported == "true")
			{
				checkResponsiblity = true
				responsiblePersons = [user]
			}
			else
			{
				responsiblePersons = serviceProfile?.responsiblePerson()
				if(responsiblePersons.contains(user))
				{
					checkResponsiblity = true
				}
				else if(serviceProfile?.workflowMode.toString().toUpperCase() == "CUSTOMIZED")
				{
					if(isPermitted("design", 0) && !responsiblePersons.contains(user))
					{
						responsiblePersons.add(user)
						checkResponsiblity = true
					}
				}
			}
			
			/*println "sp Id : "+serviceProfile.id
			println "old sp id : "+serviceProfile?.oldProfile?.id
			println "new sp id : "+serviceProfile?.newProfile?.id*/
			session["checkResponsiblity"] = checkResponsiblity
			
			if(serviceProfile?.isImported == "true" && serviceProfile.stagingStatus.name != "published" && serviceProfile.stagingStatus.name != 'inActive')
			{
				redirect(action: "serviceStage", params: [serviceProfileId: serviceProfile.id])
			}
			else if(serviceProfile?.workflowMode == "customized" && serviceProfile.stagingStatus.name != "published" && serviceProfile.stagingStatus.name != 'inActive')
			{
				redirect(action: "serviceStage", params: [serviceProfileId: serviceProfile.id])
			}
			else if(ServiceStageFlow.stageFlowPermission[serviceProfile.stagingStatus.name]){
				String permission = ServiceStageFlow.stageFlowPermission[serviceProfile.stagingStatus.name]
				if(profileSecurity.isChangeOfCurrentStageAllowed())
				{
					redirect(action: "serviceStage", params: [serviceProfileId: serviceProfile.id])

				}
			}


			Staging nextStage = Staging.getNextServiceStage("NEW_STAGE", serviceProfile?.stagingStatus)

			def tmpUsers = responsiblePersons*.toString()
			if(tmpUsers.size() > 1 ){
				tmpUsers.remove('Administrator')
			}

			def responsiblePeople = tmpUsers.join(", ")
			
			def territorySet = new HashSet()
			boolean hasDefaultSOWDefinition = false
			ServiceProfileSOWDef defaultSOWDefinition = null
			for(ServiceProfileSOWDef sowDefinition : serviceProfile?.defs)
			{
				if(sowDefinition?.geo != null && sowDefinition?.geo != "")
				{
					territorySet.add(sowDefinition?.geo)
				}
				else
				{
					hasDefaultSOWDefinition = true
					defaultSOWDefinition = sowDefinition
				}
			}
			
			List prerequisitesList = serviceProfile.listServiceProfileMetaphors(ServiceProfileMetaphors.MetaphorsType.PRE_REQUISITE)
			List outOfScopeList = serviceProfile.listServiceProfileMetaphors(ServiceProfileMetaphors.MetaphorsType.OUT_OF_SCOPE)
			
			boolean readOnly = true
			return [serviceProfileInstance: serviceProfile, selectedTab: selectedTab,
				createPermitted: isPermitted("create", 0),
				updatePermitted: session["serviceUpdatePermit"],
				designPermitted: session["designPermit"],
				reviewStage: profileSecurity.isStageBeingReviewed(),
				nextStageReview: (nextStage?profileSecurity.isStageBeingReviewed(nextStage): false),
				stageChangedAllowed: (nextStage?profileSecurity.isChangeOfStageAllowed(serviceProfile?.stagingStatus): false),
				nextStage: nextStage,
				stagingInstanceList: Staging.listServiceStages ("NEW_STAGE"),
				responsiblePersons: responsiblePeople,
				territoryList: territorySet.toList(), hasDefaultSOWDefinition: hasDefaultSOWDefinition,
				defaultSOWDefinition: defaultSOWDefinition, readOnly: readOnly, prerequisitesList: prerequisitesList, outOfScopeList: outOfScopeList]
		}
		else
		{
			redirect(action: "list")
		}

	}

	def serviceStage = {
		def serviceProfile = null;
		if(params.serviceProfileId)
		{
			serviceProfile = ServiceProfile.get(params.serviceProfileId)
		}
		else
		{
			def serviceInstance = Service.get(params.id)
			serviceProfile = serviceInstance?.serviceProfile
		}

		if(serviceProfile)
		{
			if(serviceProfile?.isImported == "true")
			{
				String username = serviceProfile?.service?.productManager?.username;
				if( username != null && username.equals("product") && serviceProfile.importServiceStage.equals("init")){
					serviceProfile.importServiceStage = "concept"
					serviceProfile.stagingStatus = Staging.findByName('concept')
					serviceProfile.save();
				}
				
				//render(view: "importService", model: [serviceProfileInstance: serviceProfile, importServiceStages: importServiceStages, importServiceStageSteps: importServiceStageSteps]);
				render(view: "serviceImport", model: [serviceProfileInstance: serviceProfile, importServiceStages: importServiceStages, importServiceStageSteps: importServiceStageSteps]);
			}
			else
			{
				//List stagingInstanceList = Staging.listServiceStages ("NEW_STAGE")				
				//render(view: "main", model: [serviceProfileInstance: serviceProfile, stagingInstanceList: stagingInstanceList, reviewRequestInstanceId: ServiceProfile.findCurrentReviewRequest(serviceProfile)?.id]);
						
				List stagingInstanceList
				
				if(serviceProfile?.workflowMode.toString().toUpperCase() == "CUSTOMIZED")
				{					 
					
					 stagingInstanceList = Staging.listShortServiceStages ("NEW_STAGE")	
					 
					 List<String> concept = new  ArrayList<String>()
					 concept.add("edit");concept.add("editDeliverables");concept.add("editDefinition")
					 					 
					 List<String> design = new  ArrayList<String>()
					 design.add("addActivities");design.add("addProducts");design.add("addPrerequisites");design.add("addOutOfScope");design.add("showDetailedInfo")					 
					
					 List<String> requestforpublished = new  ArrayList<String>()
					 requestforpublished.add("showDetailedInfo")
					 

					 
					  def importServiceStageStep = [concept: ServiceStageFlow.retriveSubStages("concept",concept),									
										design: ServiceStageFlow.retriveSubStages("design",design)/*,										
										requestforpublished: ServiceStageFlow.retriveSubStages("requestforpublished",requestforpublished)*/
									]

					 
					 				 
					 render(view: "shortcutMain", model: [serviceProfileInstance: serviceProfile, importServiceStages: importServiceStages, importServiceStageSteps: importServiceStageStep, stagingInstanceList: stagingInstanceList, reviewRequestInstanceId: ServiceProfile.findCurrentReviewRequest(serviceProfile)?.id]);
				}
				else
				{					
					stagingInstanceList = Staging.listServiceStages ("NEW_STAGE")
					render(view: "main", model: [serviceProfileInstance: serviceProfile, stagingInstanceList: stagingInstanceList, reviewRequestInstanceId: ServiceProfile.findCurrentReviewRequest(serviceProfile)?.id]);
				}	
			}	
		}
		else
		{
			throw new RuntimeException("Invalid Service Profile id")
		}
	}
	
	public boolean isPortfolioManagerAssign(Portfolio portfolio)
	{
		boolean assignPortfolioManager = false
		
		User pm = User.get(portfolio.portfolioManager.id)
		Role pmRole = Role.findByName("PORTFOLIO MANAGER") 
		
		for(Role role : pm.roles)
		{
			if(role.name == pmRole.name)
			{
				assignPortfolioManager = true
			}
		}
		
		return assignPortfolioManager
	}
	
	def showServiceImportStages = {
		
		String source = params.source
		
		//def importStep = importServiceStageSteps[source]
		def user = User.get(new Long(SecurityUtils.subject.principal))
		
		def serviceProfileInstance = ServiceProfile.get(params.id)
		int stepNumber = (params.step_number && params.step_number.toInteger() > 0?params.step_number.toInteger(): 1);
				
		String stepName = ServiceStageFlow.findImportServiceStepName(source, stepNumber);
		
		def territorySet = new HashSet()
		boolean hasDefaultSOWDefinition = false
		ServiceProfileSOWDef defaultSowDef = null
		for(ServiceProfileSOWDef sowDefinition : serviceProfileInstance?.defs)
		{
			if(sowDefinition?.geo != null && sowDefinition?.geo != "")
			{
				territorySet.add(sowDefinition?.geo)
			}
			else
			{
				hasDefaultSOWDefinition = true
				defaultSowDef = ServiceProfileSOWDef.get(sowDefinition?.id)
			}
		}
		
		List prerequisiteMetaphorsList = serviceProfileInstance.listServiceProfileMetaphors(ServiceProfileMetaphors.MetaphorsType.PRE_REQUISITE)
		List outOfScopeMetaphorsList = serviceProfileInstance.listServiceProfileMetaphors(ServiceProfileMetaphors.MetaphorsType.OUT_OF_SCOPE)
		
		if(stepName == "editDefinition")
		{
			//render(template: "editDefinition", model: [serviceProfileInstance: serviceProfileInstance, hideButtons: true])
			def definitionList = serviceProfileInstance?.defs
			boolean readOnly = false
			def defaultSowLanguageTemplate = "${message(code: 'default.sow.language', args: [serviceProfileInstance?.service?.serviceName])}"
			render(
				template: "addServiceProfileSOWDefinition", model: [serviceProfileInstance: serviceProfileInstance, defaultSowLanguageTemplate: defaultSowLanguageTemplate, definitionList: definitionList, territoryList: territorySet.toList(), hasDefaultSOWDefinition: hasDefaultSOWDefinition, defaultSowDef: defaultSowDef, readOnly: readOnly])
			return;
		}
		else if(stepName == "showDetailedInfo")
		{
			session["designPermit"] = false;
			session["serviceUpdatePermit"] = false;
			boolean readOnly = true
			render(template: "showReadOnly", model: [serviceProfileInstance: serviceProfileInstance, outOfScopeMetaphorsList: outOfScopeMetaphorsList, prerequisiteMetaphorsList: prerequisiteMetaphorsList, territoryList: territorySet.toList(), hasDefaultSOWDefinition: hasDefaultSOWDefinition, defaultSowDef: defaultSowDef, readOnly: readOnly])
			return;
		}
		
		switch(source)
		{
			case "init": 
					params.currentStep = params.step_number.toInteger();
					
					if(stepName.equals("assignProductManager"))
					{
						def assignPortfolioManager = isPortfolioManagerAssign(serviceProfileInstance?.service?.portfolio)
						def portfolioManagerList = serviceCatalogService.findPortfolioManagers()
						def productManagerList = serviceCatalogService.findProductManagers()
						render(template: "serviceImport/assignProductManager", model: [serviceProfileInstance: serviceProfileInstance, productManagerList: productManagerList, assignPortfolioManager: assignPortfolioManager, portfolioManagerList: portfolioManagerList])
					}
					break;
			case "concept":
					params.currentStep = params.step_number.toInteger();
			
					if(stepName.equals("edit"))
					{
						List<String> serviceUnitOfSaleList = ServiceProfile.executeQuery("SELECT DISTINCT UPPER(sp.unitOfSale) from ServiceProfile sp WHERE sp.unitOfSale != null ORDER BY sp.unitOfSale ASC" )
						render(template: "stage/concept-${stepName}", model: [serviceProfileInstance: serviceProfileInstance, isLightWorkflow: false, serviceUnitOfSaleList: serviceUnitOfSaleList])
					}
					else if(stepName.equals("editDeliverables"))
					{
						def deliverablesList = serviceProfileInstance.listCustomerDeliverables(params)
						List<String> deliverableTypes = ServiceDeliverable.executeQuery("SELECT DISTINCT UPPER(sd.type) from ServiceDeliverable sd ORDER BY sd.type ASC")
						render(template: "stage/concept-${stepName}", model: [serviceProfileInstance: serviceProfileInstance, 'deliverablesList': deliverablesList, deliverableTypes: deliverableTypes])
					}
					else if(stepName == "showInfo")
					{
						render(template: "stage/concept-${stepName}", model: [serviceProfileInstance: serviceProfileInstance, territoryList: territorySet.toList(), hasDefaultSOWDefinition: hasDefaultSOWDefinition])
						return;
					}
					break;
					
			case "design":
					params.currentStep = params.step_number.toInteger();
					
					if(stepName.equals("assignDesigner")){
						def designerList = serviceCatalogService.findServiceDesigners()
						render(template: "serviceImport/assignDesigner", model: [serviceProfileInstance: serviceProfileInstance, designerList: designerList]);
					}

					else if(stepName.equals("addActivities"))
					{
						def serviceDeliverable = serviceProfileInstance?.listCustomerDeliverables()?.toArray().getAt(0)
						def activitiesList = serviceDeliverable.listServiceActivities(params)
		
						render(template: "stage/design-${stepName}", model: [serviceProfileInstance: serviceProfileInstance, activitiesList: activitiesList, serviceDeliverableInstance: serviceDeliverable])
					}
					
					else if(stepName.equals("addProducts"))
					{
						def productList = []
						productList = Product.list()
						render(template: "stage/design-${stepName}", model: [serviceProfileInstance: serviceProfileInstance, productList: productList])
					}
					
					else if(stepName.equals("addPrerequisites"))
					{
						List metaphorsList = serviceProfileInstance.listServiceProfileMetaphors(ServiceProfileMetaphors.MetaphorsType.PRE_REQUISITE)
						
						render(template: "stage/design-addMetaphors", model: [serviceProfileInstance: serviceProfileInstance, metaphorsList: metaphorsList, metaphorType: "preRequisite", entityName: "Pre-requisite"])
					}
					
					else if(stepName.equals("addOutOfScope"))
					{
						List metaphorsList = serviceProfileInstance.listServiceProfileMetaphors(ServiceProfileMetaphors.MetaphorsType.OUT_OF_SCOPE)
						
						render(template: "stage/design-addMetaphors", model: [serviceProfileInstance: serviceProfileInstance, metaphorsList: metaphorsList, metaphorType: "outOfScope", entityName: "Out of Scope"])
					}
					break;
		}
	}
	def loadExtraUnit = {
		println 'In loadExtraUnit Method'
		
		render (template:"../service/stage/createExtraUnit")
	}
	
	def showStage = {
		
		String source = params.source

		def user = User.get(new Long(SecurityUtils.subject.principal))
		println "in show stage"   

		def serviceProfileInstance = ServiceProfile.get(params.id)
		int stepNumber = (params.step_number && params.step_number.toInteger() > 0?params.step_number.toInteger(): 1);
		String stepName = ServiceStageFlow.findStepName(source, stepNumber);


		def territorySet = new HashSet()
		boolean hasDefaultSOWDefinition = false
		ServiceProfileSOWDef defaultSowDef = null
		for(ServiceProfileSOWDef sowDefinition : serviceProfileInstance?.defs)
		{
			if(sowDefinition?.geo != null && sowDefinition?.geo != "")
			{
				territorySet.add(sowDefinition?.geo)
			}
			else
			{
				hasDefaultSOWDefinition = true
				defaultSowDef = ServiceProfileSOWDef.get(sowDefinition?.id)
			}
		}
		
		List prerequisiteMetaphorsList = serviceProfileInstance.listServiceProfileMetaphors(ServiceProfileMetaphors.MetaphorsType.PRE_REQUISITE)
		List outOfScopeMetaphorsList = serviceProfileInstance.listServiceProfileMetaphors(ServiceProfileMetaphors.MetaphorsType.OUT_OF_SCOPE)
		
		if(stepName == "request"){
			render(template: "/staging/changeStaging", model: buildStageChangeRequestMap(serviceProfileInstance));
			return;
		}
		else if(stepName == "approveRequest"){
			redirect(controller: "reviewRequest", action: "showFromWizard", params: [id: ServiceProfile.findCurrentReviewRequest(serviceProfileInstance)?.id, serviceProfileId: serviceProfileInstance?.id]);
		}
		else if(stepName == "showInfo")
		{
			boolean readOnly = true
			render(template: "stage/concept-showInfo", model: [serviceProfileInstance: serviceProfileInstance, territoryList: territorySet.toList(), hasDefaultSOWDefinition: hasDefaultSOWDefinition, defaultSowDef: defaultSowDef, readOnly: readOnly])
			return;
		}
		else if(stepName == "showDetailedInfo")
		{
			session["designPermit"] = false;
			session["serviceUpdatePermit"] = false;
			boolean readOnly = true
			render(template: "showReadOnly", model: [serviceProfileInstance: serviceProfileInstance, outOfScopeMetaphorsList: outOfScopeMetaphorsList, prerequisiteMetaphorsList: prerequisiteMetaphorsList, territoryList: territorySet.toList(), hasDefaultSOWDefinition: hasDefaultSOWDefinition, defaultSowDef: defaultSowDef, readOnly: readOnly])
			return;
		}
		else if(stepName == "editDefinition")
		{
			session["designPermit"] = true;
			session["serviceUpdatePermit"] = true;
			//render(template: "editDefinition", model: [serviceProfileInstance: serviceProfileInstance, hideButtons: true])
			def definitionList = serviceProfileInstance?.defs
			boolean readOnly = false
			def defaultSowLanguageTemplate = "${message(code: 'default.sow.language', args: [serviceProfileInstance?.service?.serviceName])}"
			render(template: "addServiceProfileSOWDefinition", model: [serviceProfileInstance: serviceProfileInstance, defaultSowLanguageTemplate: defaultSowLanguageTemplate, definitionList: definitionList, territoryList: territorySet.toList(), hasDefaultSOWDefinition: hasDefaultSOWDefinition, defaultSowDef: defaultSowDef, readOnly: readOnly])
			return;
		}

		switch(source)
		{
			case "concept":

				params.currentStep = params.step_number.toInteger();

				if(stepName.equals("edit"))
				{
					List<String> serviceUnitOfSaleList = ServiceProfile.executeQuery("SELECT DISTINCT UPPER(sp.unitOfSale) from ServiceProfile sp WHERE sp.unitOfSale != null ORDER BY sp.unitOfSale ASC" )
					render(template: "stage/concept-${stepName}", model: [serviceProfileInstance: serviceProfileInstance, isLightWorkflow: false, serviceUnitOfSaleList: serviceUnitOfSaleList])
				}
				else if(stepName.equals("showInfo"))
				{
					
					render(template: "stage/concept-${stepName}", model: [serviceProfileInstance: serviceProfileInstance])
				}
				else if(stepName.equals("editDeliverables"))
				{
					def deliverablesList = serviceProfileInstance.listCustomerDeliverables(params)
					List<String> deliverableTypes = ServiceDeliverable.executeQuery("SELECT DISTINCT UPPER(sd.type) from ServiceDeliverable sd ORDER BY sd.type ASC")
					render(template: "stage/concept-${stepName}", model: [serviceProfileInstance: serviceProfileInstance, 'deliverablesList': deliverablesList, deliverableTypes: deliverableTypes])
				}

				break;

			case "conceptreview":
				if(stepName.equals("showInfo"))
				{
					render(template: "stage/concept-showInfo", model: [serviceProfileInstance: serviceProfileInstance])
				}
				break;
			case "conceptapproved":
				if(stepName.equals("assignDesigner")){
					def designerList = serviceCatalogService.findServiceDesigners()
					render(template: "stage/assignDesigner", model: [serviceProfileInstance: serviceProfileInstance, designerList: designerList]);
				}

				break;

			case "design":
				stepName = ServiceStageFlow.findStepName('design', params.step_number.toInteger());
				params.currentStep = params.step_number.toInteger();
				storePermissionsInSession(serviceProfileInstance);

				if(stepName.equals("addActivities"))
				{
					def serviceDeliverable = serviceProfileInstance?.listCustomerDeliverables()?.toArray().getAt(0)
					def activitiesList = serviceDeliverable.listServiceActivities(params)

					render(template: "stage/design-${stepName}", model: [serviceProfileInstance: serviceProfileInstance, activitiesList: activitiesList, serviceDeliverableInstance: serviceDeliverable])
				}
				else if(stepName.equals("addProducts"))
				{
					def productList = []
					productList = Product.list()
					render(template: "stage/design-${stepName}", model: [serviceProfileInstance: serviceProfileInstance, productList: productList])
				}
				/*else if(stepName.equals("addMetaphors"))
				{
					render(template: "stage/design-${stepName}", model: [serviceProfileInstance: serviceProfileInstance, metaphorsList: metaphorsList])
				}*/
				
				else if(stepName.equals("addPrerequisites"))
				{
					List metaphorsList = serviceProfileInstance.listServiceProfileMetaphors(ServiceProfileMetaphors.MetaphorsType.PRE_REQUISITE)
					
					render(template: "stage/design-addMetaphors", model: [serviceProfileInstance: serviceProfileInstance, metaphorsList: metaphorsList, metaphorType: "preRequisite", entityName: "Pre-requisite"])
				}
				else if(stepName.equals("addOutOfScope"))
				{
					List metaphorsList = serviceProfileInstance.listServiceProfileMetaphors(ServiceProfileMetaphors.MetaphorsType.OUT_OF_SCOPE)
					println "out of scope : "+metaphorsList
					render(template: "stage/design-addMetaphors", model: [serviceProfileInstance: serviceProfileInstance, metaphorsList: metaphorsList, metaphorType: "outOfScope", entityName: "Out of Scope"])
				}
				break

		}
	}
	
	def publishImportService = {
		def res = "fail"
		def serviceProfileInstance = ServiceProfile.get(params.id)
		
		serviceProfileInstance.stagingStatus = Staging.findByName("published")
		serviceProfileInstance.dateModified = new Date()
		serviceProfileInstance.currentStep = 1;
		
		serviceProfileInstance.type = ServiceProfileType.PUBLISHED
		serviceProfileInstance.datePublished = new Date()
		
		if (serviceProfileInstance.save(flush:true))
		{
			if(serviceProfileInstance.type == ServiceProfileType.PUBLISHED)
			{
				serviceCatalogService.updateServiceToPricelist(serviceProfileInstance)
				if(serviceProfileInstance?.oldProfile?.id != null)
				{
					serviceStagingService.assignServiceToNewProfile(serviceProfileInstance)
				}
			}
			
			res= "success"
			//redirect(action: "catalog")
		}
		render res
	}
	
	private Map buildStageChangeRequestMap(ServiceProfile serviceProfileInstance){

		def currentStage;
		def nextStage;
		def stagingLogInstance = new StagingLog()

		if(serviceProfileInstance.stagingStatus)
		{
			currentStage = serviceProfileInstance.stagingStatus
			nextStage = Staging.getNextServiceStage("NEW_STAGE", currentStage)
		}

		ServiceProfileSecurityProvider profileSecurity =
				new ServiceProfileSecurityProvider(serviceProfileInstance)

		boolean isNextReview = profileSecurity.isStageBeingReviewed(nextStage)

		List assigneesList = new ArrayList();

		if(isNextReview)
		{
			Set tmpSet = new HashSet()
			tmpSet = profileSecurity.listAuthorizedUsers(nextStage)
			for(UserBase user : tmpSet.toList())//(User user : tmpSet.toList())
			{
				if(user?.username != "superadmin")
				{
					assigneesList.add(user)
				}
			}
			//assigneesList.addAll(profileSecurity.listReviewerUsers(nextStage))
			//println assigneesList
		}


		return [
			stagingInstanceList: ([nextStage]),
			currentStage: currentStage,
			nextStage: nextStage,
			staginLogInstance: stagingLogInstance,
			serviceProfileId: serviceProfileInstance.id,
			nextStageDisabled: true,
			nextReviewStage: isNextReview,
			assigneesList: userService.filterUserList(assigneesList)
		];
	}

	
	def changeCustomizeServiceStage = {
		def serviceProfileInstance = ServiceProfile.get(params.id)
		if(serviceProfileInstance)
		{
			if(serviceProfileInstance.stagingStatus.name == "init")
			{
				serviceProfileInstance.stagingStatus = Staging.findByName('concept')
			}
			else if(serviceProfileInstance.stagingStatus.name == "concept")
			{
				serviceProfileInstance.stagingStatus = Staging.findByName('design')
			}
			else if(serviceProfileInstance.stagingStatus.name == "design")
			{
				serviceProfileInstance.stagingStatus = Staging.findByName('requestforpublished')				
			}
			serviceProfileInstance.currentStep = 1
			if(serviceProfileInstance.save())
			{
				println "stage changed successfully"
				
				redirect(action: "show", params: [serviceProfileId: serviceProfileInstance.id])
			}			
		}
	}
	
	def changeBackCustomizeServiceStage = {
		def serviceProfileInstance = ServiceProfile.get(params.id)
		if(serviceProfileInstance)
		{
			if(serviceProfileInstance.stagingStatus.name == "design")
			{
				serviceProfileInstance.stagingStatus = Staging.findByName('concept')
			}
			serviceProfileInstance.currentStep = 1
			if(serviceProfileInstance.save())
			{
				println "stage changed successfully"
				//println serviceProfileInstance.stagingStatus.name
				redirect(action: "show", params: [serviceProfileId: serviceProfileInstance.id])
			}
		}
	}
	
	
	def changeImportServiceStage = {
		def serviceProfileInstance = ServiceProfile.get(params.id)
		if(serviceProfileInstance)
		{
			if(serviceProfileInstance.importServiceStage == "init")
			{
				serviceProfileInstance.importServiceStage = "concept"
				serviceProfileInstance.stagingStatus = Staging.findByName('concept')
			}
			else if(serviceProfileInstance.importServiceStage == "concept")
			{
				serviceProfileInstance.importServiceStage = "design"
				serviceProfileInstance.stagingStatus = Staging.findByName('design')
			}
			else if(serviceProfileInstance.importServiceStage == "design")
			{
				serviceProfileInstance.stagingStatus = Staging.findByName('requestforpublished')
				serviceProfileInstance.importServiceStage = "publish"
			}
			serviceProfileInstance.currentStep = 1
			if(serviceProfileInstance.save())
			{
				println "stage changed successfully"
				
				redirect(action: "show", params: [serviceProfileId: serviceProfileInstance.id])
			}
			
		}
	}
	
	def changeBackImportServiceStage = {
		def serviceProfileInstance = ServiceProfile.get(params.id)
		if(serviceProfileInstance)
		{
			
			if(serviceProfileInstance.importServiceStage == "design")
			{
				serviceProfileInstance.stagingStatus = Staging.findByName('concept')
				serviceProfileInstance.importServiceStage = "concept"
			}
			serviceProfileInstance.currentStep = 1
			if(serviceProfileInstance.save())
			{
				println "stage changed successfully"
				//println serviceProfileInstance.importServiceStage
				redirect(action: "show", params: [serviceProfileId: serviceProfileInstance.id])
			}
			
		}
	}
	
	def getOtherPortfolios = {
		//----------
		def serviceProfile = ServiceProfile.get(params.serviceProfileId)
		def portfolioList = []
		if(serviceProfile != null)
		{
			portfolioList = Portfolio.findAll("from Portfolio pf WHERE pf.id != '$serviceProfile.service.portfolio.id'")
		}
		
		println portfolioList
		render(template: "getOtherPortfolios", model: [portfolioList: portfolioList, serviceProfile: serviceProfile])
	}
	
	def saveOtherPortfolios = {
		def serviceInstance = Service.get(params.serviceId)
		def portfolio = Portfolio.get(params.PortfolioId)
		Map map1 = [:],map2 = [:]
		if(serviceInstance != null && portfolio != null)
		{
			def oldPortfolio = Portfolio.get(serviceInstance.portfolio.id)
			serviceInstance.portfolio = portfolio
			if(serviceInstance.save(flush: true))
			{
				map1 = new NotificationGenerator(g).sendMoveServiceNotificationToOldPortfolioManager(serviceInstance.serviceProfile, oldPortfolio);
				map2 = new NotificationGenerator(g).sendMoveServiceNotificationToNewPortfolioManager(serviceInstance.serviceProfile, oldPortfolio);
				sendMailService.sendEmailNotification(map1["messageFrom"], map1["subjectFrom"], map1["receiverListFrom"], request.siteUrl+"/service/show?serviceProfileId="+serviceInstance.serviceProfile.id)
				sendMailService.sendEmailNotification(map2["messageTo"], map2["subjectTo"], map2["receiverListTo"], request.siteUrl+"/service/show?serviceProfileId="+serviceInstance.serviceProfile.id)
				render "success"
			}
			else
				render "failed"
		}
		else
			return "failed"
	}
	
	def saveProductManager =
	{
		def result = "fail"
		def serviceProfile = ServiceProfile.get(params.serviceProfileId)
		def serviceInstance = Service.get(serviceProfile?.service?.id)
		
		serviceInstance.properties[
			'skuName'/*,
			'description'*/] = params
		
		Description serviceDescription = Description.get(serviceInstance?.serviceDescription?.id)
		serviceDescription.value = params.description
		serviceDescription.save()
		
		if(params.portfolioManagerId)
		{
			Portfolio portfolio = Portfolio.get(serviceInstance?.portfolio.id)
			portfolio.portfolioManager = User.get(params.portfolioManagerId.toLong())
			portfolio.save()
			println "portfolio saved"
		}
		
		serviceInstance.productManager = User.get(params.productManagerId)
		def user = User.get(new Long(SecurityUtils.subject.principal))
		serviceInstance.modifiedBy = user
		serviceInstance.dateModified = new Date()
		
		if (serviceInstance.save(flush: true)) {
			result = "success"
		}
		
		render result
	}
	
	def saveServiceDesigner =
	{
		def result = "fail"
		params.currentStep = params.step_number.toInteger() + 1;
		ServiceProfile serviceProfileInstance  = updateServiceProfile(params);
		
		/*if (serviceProfileInstance.save(flush: true)) {
			result = "success"
		}
		*/
		render "success"//result
	}
	
	public boolean isServiceExist(String serviceName)
	{
		Service service = Service.findByServiceName(serviceName)
		
		if(service != null)
		{
			return true
		}
		return false
	}
	
	def isServiceAvailable = {
		String placeWhereAvailable = ""
		Map resultMap = new HashMap()
		
		if(params.serviceName)
		{
			String serviceName = params.serviceName
			Service service = Service.findByServiceName(params.serviceName)
			
			if(service != null)
			{
				if(service?.serviceProfile?.type == ServiceProfileType.DEVELOP)
				{
					placeWhereAvailable = "IN DEVELOPMENT"
				}
				else if(service?.serviceProfile?.type == ServiceProfileType.PUBLISHED)
				{
					placeWhereAvailable = "PUBLISHED"
				}
				else if(service?.serviceProfile?.type == ServiceProfileType.INACTIVE)
				{
					placeWhereAvailable = "ARCHIEVE"
				}
				
				
				resultMap['result'] = "serviceAvailable"
				resultMap['placeWhereAvailable'] = "There is already another solution " + placeWhereAvailable + " with this name."+
													" Please choose another or check the " + placeWhereAvailable + " catalog."
			}
			else
			{
				resultMap['result'] = "serviceNotAvailable"
			}
			
		}
		else
		{
			resultMap['result'] = "dataNotFound"
		}
		
		render resultMap as JSON
	}
	
	def saveStage = {

		//We can cache this
		def res = "fail"
		
		String source = params.source
		boolean msg = false;

		List stagingInstanceList = Staging.listServiceStages ("NEW_STAGE")
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def map = [:]
		switch(source)
		{
			case "init":
				Service serviceInstance = createNewService(params);

				if(serviceInstance?.serviceProfile)
				{
					if(serviceInstance?.id)
					{
						if(serviceInstance.serviceProfile.isImported  == "false" &&
							 (serviceInstance.serviceProfile.workflowMode == null || serviceInstance.serviceProfile.workflowMode != "customized"))
						{
							//Notify to product manager.
							serviceStagingService.changeStaging(serviceInstance.serviceProfile, Staging.findByName('concept'), "Created by ${user}")
							
							map = new NotificationGenerator(g).sendAssignedToConceptuzlizeNotification(serviceInstance.serviceProfile);
							sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/service/show?serviceProfileId="+serviceInstance.serviceProfile.id)
						}

						res = "success";

					}
					else
					{
						def portfolioList = serviceCatalogService.findUserPortfolios(user, params)
						def productManagerList = serviceCatalogService.findProductManagers()
						serviceInstance.serviceProfile = new ServiceProfile();
						
						render(view: "main", model: [serviceInstance: serviceInstance, portfolioList: portfolioList, serviceProfileInstance: serviceInstance?.serviceProfile, productManagerList: productManagerList, stagingInstanceList: stagingInstanceList]);
					}
				}
				else
				{
					//flash.message = "Service with specified name was created before, so try for another name...."
					//redirect(action: "catalog")
					res = "fail";

				}
				if(params.createdFrom == "import" || params.createdFrom == "customized")
				{
					
					def data = [:]
					data["res"] = res
					data["serviceProfileId"] = serviceInstance?.serviceProfile?.id
					render data as JSON
				}
				else
				{
					render res
				}
				
				break;
			case "designreview"	:
			case "concept":
			
				def serviceProfileInstance = ServiceProfile.get(params.id)
				String stepName = ""
				def stepNumber = params.step_number.toInteger()
				
				if(serviceProfileInstance.isImported  == "false" && serviceProfileInstance.workflowMode != "customized")
				{
					stepName = ServiceStageFlow.findStepName(source, stepNumber);
				}
				else
				{
					//def importStep = importServiceStageSteps[source]
					//stepName = importStep[stepNumber-1][0]
					stepName = ServiceStageFlow.findImportServiceStepName(source, stepNumber);
				}

				if(stepName.equals("edit") || stepName.equals("editDefinition"))
				{
					params.currentStep = params.step_number.toInteger() + 1;
					serviceProfileInstance  = updateServiceProfile(params);
					
					/*if(params.isNewUnitOfSale == true || params.isNewUnitOfSale == "true")
					{
						Map paramMap = new HashMap()
						paramMap['name'] = params.newUnitOfSale
						paramMap['type'] = ObjectType.Type.SERVICE_UNIT_OF_SALE
						if(!defaultEntityOperationService.isEntityTypeNameAvailable(paramMap))
						{
							ObjectType unitOfSaleInstance = new ObjectType("name": params.newUnitOfSale, "type": ObjectType.Type.SERVICE_UNIT_OF_SALE).save()
						}
						serviceProfileInstance.unitOfSale =  params.newUnitOfSale
					}
					else
					{
						serviceProfileInstance.unitOfSale =  params.defaultUnitOfSale
					}*/

					res = "success"
					//render serviceProfileInstance?.definition;
					//redirect(action: "show", params: [serviceProfileId: serviceProfileInstance.id ])
					//render(view: "main", model: [serviceProfileInstance: serviceProfileInstance, serviceInstance: serviceProfileInstance?.service, stagingInstanceList: stagingInstanceList]);
					
				}
				else if(stepName.equals("requestConcept"))
				{

				}

				render res;
				break;
			case "conceptapproved":
				ServiceProfile serviceProfileInstance  = updateServiceProfile(params);
				if(!serviceStagingService.changeStaging(serviceProfileInstance, Staging.findByName('design'), "${serviceProfileInstance.serviceDesignerLead} is assigned as service service designer"))
				{
					//TODO: Something wrong handle it properly
				}
				map = new NotificationGenerator(g).sendAssignedToDesignNotification(serviceProfileInstance);

				sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/service/show?serviceProfileId="+serviceProfileInstance.id)

			//flash.message = "Service created and notification is sent to product manager";
			//redirect(action: "show", params: [serviceProfileId: serviceProfileInstance.id])
				res = "success";
				render res
				break;

		}
		
		return
	}
	
	private Service createNewService(params)
	{
		def serviceInstance = new Service()
		
		try
		{
			serviceInstance.properties[
				'serviceName',
				'portfolio.id',
				'portfolio',
				'skuName',
				'productManager.id',
				//'description',
				'tags'
			] = params

			Description serviceDescription = new Description("name": "Service Description: ${serviceInstance.serviceName}", value: params?.description).save()
			
			serviceInstance.serviceDescription = serviceDescription
			
			def user = User.get(new Long(SecurityUtils.subject.principal))
			serviceInstance.createdBy = user
			serviceInstance.modifiedBy = user
			serviceInstance.active = true
		
			serviceInstance.dateCreated = new Date()
			serviceInstance.dateModified = new Date()
		
			def serviceProfile = new ServiceProfile()
			serviceProfile.totalEstimateInHoursPerBaseUnits = new BigDecimal(0);
			serviceProfile.totalEstimateInHoursFlat = new BigDecimal(0);
			serviceProfile.baseUnits = 0
			serviceProfile.revision = 1
			serviceProfile.dateCreated = new Date()
			serviceProfile.dateModified = new Date()
			serviceProfile.type = ServiceProfile.ServiceProfileType.DEVELOP
			
			if(params.createdFrom == "customized")
			{
				serviceProfile.workflowMode = "customized"
				serviceProfile.stagingStatus = Staging.findByName('concept')
				serviceProfile.isImported = "false"
			}
			
			else if(params.createdFrom == "import"){
				serviceProfile.workflowMode = "imported"
				serviceProfile.isImported = "true"
				serviceProfile.importServiceStage = "concept"
				serviceProfile.stagingStatus = Staging.findByName('concept')
			}
			else
			{
				serviceProfile.workflowMode = "detailed"
				serviceProfile.stagingStatus = Staging.findByName('init')
				serviceProfile.isImported = "false"
			}
		
			if (serviceInstance.save(flush: true)) {
				serviceInstance.addToProfiles(serviceProfile)
				serviceProfile.save(flush:true);
				serviceInstance.serviceProfile = serviceProfile
		
				return serviceInstance
			}
			
			if (serviceInstance.hasErrors()) {
				serviceInstance.errors.each { println(it) }
				throw new RuntimeException("Error creating Service")
			}
	
			if (serviceProfile.hasErrors()) {
				serviceProfile.errors.each { println(it) }
				throw new RuntimeException("Error creating Service Profile")
			}
			
			return null
		}catch(Exception ex)
		{
			ex.printStackTrace(System.out);
			return null
		}
		return null//serviceInstance;
	}

	def save = {
		def serviceInstance = new Service()
		serviceInstance.properties[
					'serviceName',
					'portfolio.id',
					'portfolio',
					'productManager.id',
					'otherProductManagers.id',
					'skuName',
					'description',
					'tags'
				] = params
		def user = User.get(new Long(SecurityUtils.subject.principal))
		serviceInstance.createdBy = user
		serviceInstance.active = true

		serviceInstance.dateCreated = new Date()
		serviceInstance.dateModified = new Date()

		def serviceProfile = new ServiceProfile()
		serviceProfile.properties['unitOfSale', 'baseUnits'] = params
		serviceProfile.totalEstimateInHoursPerBaseUnits = new BigDecimal(0);
		serviceProfile.totalEstimateInHoursFlat = new BigDecimal(0);
		serviceProfile.revision = 1
		serviceProfile.stagingStatus = Staging.findByName('conceptulization')
		serviceProfile.type = ServiceProfile.ServiceProfileType.DEVELOP
		serviceProfile.dateCreated = new Date()
		serviceProfile.dateModified = new Date()

		if (serviceInstance.save(flush: true)) {
			serviceInstance.addToProfiles(serviceProfile)
			serviceInstance.serviceProfile = serviceProfile
			flash.message = "${message(code: 'default.created.message', args: [message(code: 'service.label', default: 'Service'), serviceInstance.id])}"
			redirect(action: "show", params: [serviceProfileId: serviceProfile.id])
		}
		else {
			render(view: "create", model: [serviceInstance: serviceInstance])
		}
	}

	def createNewVersion = {
		if(!params.id)
		{
			//TODO: Handle validation failure
		}

		ServiceProfile serviceProfile = ServiceProfile.get(params.id)

		Service service = Service.get(serviceProfile?.service?.id)
		if(serviceProfile == null)
		{
			//TODO: Error invalid serviceProfile
		}

		ServiceProfile newProfile = serviceProfile.createUpgradedService(User.get(new Long(SecurityUtils.subject.principal)), getWorkflowMode())

		if(newProfile == null)
		{
			//TODO: Error invalid serviceProfile
		}
		
		
		def responsiblePersons = newProfile?.responsiblePerson()
		def tmpUsers = responsiblePersons*.toString()
		if(tmpUsers.size() > 1 ){
			tmpUsers.remove('Administrator')
		}

		def responsiblePeople = tmpUsers.join(", ")

		
		flash.dialogMessage = "${newProfile} has been created and assigned to ${responsiblePeople}"

		Map map = new NotificationGenerator(g).sendAssignedToConceptuzlizeNotification(newProfile);

		System.out.println(map);
		//println(map)
		if(map["receiverList"] &&  map["receiverList"]?.size() > 0)
			{sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/service/show?serviceProfileId="+newProfile.id)}

		redirect(action: "show", params: [serviceProfileId: newProfile.id])

	}

	def showAfterStageChange = {

		if(params.nextStageId){
			Staging stage = Staging.get(params.nextStageId);
			if(stage.name == 'designapproved' || stage.name == 'salesapproval'){
				redirect(action: 'show', params: params)
			}else if(stage.name == 'designreview'){

				redirect(action: 'inStaging')
			}
			else if(stage.name == 'conceptapproved' || stage.name == 'published' ||
			stage.name == 'conceptreview' || stage.name == 'design' ||
			stage.name == 'salesreview' || stage.name == 'requestforpublished'){
				redirect(controller: 'home')
			}
			else{
				redirect(action: 'show', params: params)
			}
		}
	}

	def makeInactive = {

		if(!params.id)
		{
			//TODO: Handle validation failure
		}
		else
		{
			def serviceProfile = ServiceProfile.get(params.id)
	
			if(serviceProfile != null)
			{
				if(!serviceStagingService.makeServiceInActive(serviceProfile.service))
				{
					//TODO: Handle error
				}
			}
		
		}

		redirect(action: "index")
	}
	
	def makeDevServiceInactive = {
		
		if(!params.id)
		{
			println "No Service has been received for inactivating"
		}
		else
		{
			def serviceProfile = ServiceProfile.get(params.id)
	
			if(serviceProfile != null)
			{
				//if(!serviceStagingService.makeServiceInActive(serviceProfile.service))
				if(!serviceStagingService.makeServiceProfileInActive(serviceProfile))
				{
					//TODO: Handle error
				}
				else{
					flash.message = "Service has been inactivated successfully"
				}
			}
		}
		redirect(action: "allInEndOfLife")
	}

	//isPermitted
	//If yes then give privilege


	private void storePermissionsInSession(ServiceProfile serviceProfile){
		session["designPermit"] = isPermitted("design", 0) && serviceProfile.type == ServiceProfile.ServiceProfileType.DEVELOP;
		session["serviceUpdatePermit"] =  isPermitted("update", 0) && serviceProfile.type == ServiceProfile.ServiceProfileType.DEVELOP
	}

	def edit = {

		def serviceProfileInstance = ServiceProfile.get(params.id)
	

		if(!isPermitted("update", 0))
		{
			return  response.sendError(javax.servlet.http.HttpServletResponse.SC_FORBIDDEN)
		}

		if (!serviceProfileInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceProfile.label', default: 'ServiceProfile'), params.id])}"
			redirect(view:"edit", action: "list")
		}
		else {
			def productManagerList = serviceCatalogService.findProductManagers()
			def portfolioManagerList = serviceCatalogService.findPortfolioManagers()
			def designerList = serviceCatalogService.findServiceDesigners()

			render(template: "editAll", model: [serviceProfileInstance: serviceProfileInstance, productManagerList: productManagerList,designerList: designerList, portfolioManagerList: portfolioManagerList, createPermitted: isPermitted("create", 0)])
		}
	}

	private ServiceProfile updateServiceProfile(Object params){
		def serviceProfileInstance = ServiceProfile.get(params.id)

		if(!isPermitted("update", 0))
		{
			return  response.sendError(javax.servlet.http.HttpServletResponse.SC_FORBIDDEN)
		}

		Service serviceInstance = serviceProfileInstance.service
		if (serviceProfileInstance) {
			if (params.version) {
				def version = params.version.toLong()
				if (serviceProfileInstance.version > version) {

					serviceProfileInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [
						message(code: 'serviceProfile.label', default: 'ServiceProfile')]
					as Object[], "Another user has updated this ServiceProfile while you were editing")
					render(view: "edit", model: [serviceProfileInstance: serviceProfileInstance])
					return null
				}
			}

			//serviceProfileInstance?.currentStep = params.step_number.toInteger()
			serviceInstance.properties[
						'serviceName',
						'skuName',
						//'description',
						'tags',
						'productManager'
					]=params
				
			serviceInstance.serviceDescription.value = params?.description
			serviceInstance.serviceDescription.name = "Service Description: ${serviceInstance?.serviceName}"
			serviceInstance.dateModified = new Date()

			serviceInstance.save(flush:true)

			serviceProfileInstance.properties[
						'unitOfSale',
						'baseUnits',
						'currentStep',
						'totalEstimateInHoursPerBaseUnits',
						'productManager.id',
						'totalEstimateInHoursFlat',
						'serviceDesignerLead',
						'premiumPercent',
						'definition'
					] = params

				/*ServiceProfileSOWDef deff = new ServiceProfileSOWDef()
				deff.part = "a"
				deff.definition = params.definition
				deff.sp = serviceProfileInstance
				deff.geo = null
				deff.save()
				
				//println "part : " +  deff.part +" definition : " +deff.definition
				serviceProfileInstance.addToDefs(deff)*/
				
				serviceProfileInstance.dateModified = new Date()

			if (!serviceProfileInstance.hasErrors() && serviceProfileInstance.save(flush: true)) {
				return serviceProfileInstance;
			}
		}
		else{
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceProfile.label', default: 'ServiceProfile'), params.id])}"
		}

		return null;
	}

	def update = {

		ServiceProfile serviceProfileInstance = updateServiceProfile(params)
		if(serviceProfileInstance){
			//flash.message = "${message(code: 'default.updated.message', args: [message(code: 'serviceProfile.label', default: 'ServiceProfile'), serviceProfileInstance.id])}"
			//flash.message = "Service edited successfully"
			redirect(action: "show",  params: [serviceProfileId: serviceProfileInstance.id])
		}
		else {
			render(view: "edit", model: [serviceProfileInstance: serviceProfileInstance])
		}

	}

	def removeService = {
		ServiceProfile serviceProfileInstance = ServiceProfile.get(params.serviceProfileId)
		/*if(serviceProfileInstance)
		{
			serviceProfileInstance = removeServiceProfileData(serviceProfileInstance)
		}*/
		Service serviceInstance = Service.get(serviceProfileInstance?.service?.id)
		println "Service Name : " + serviceInstance?.serviceName + " going to delete now."
		//serviceInstance.removeFromProfiles(serviceProfileInstance)
		//serviceInstance.serviceProfile = null
		
		deleteServiceProfileAndRelatedProperties(serviceProfileInstance, serviceInstance)
		
		serviceInstance.save()
		
		if(serviceInstance?.profiles?.size() == 0)
		{
			try {
				serviceInstance.delete()
			}
			catch (org.springframework.dao.DataIntegrityViolationException ex) {
				ex.printStackTrace(System.out);
			}
		}
	
		render "success"
	}
	
	private void deleteServiceProfileAndRelatedProperties(ServiceProfile serviceProfile, Service service)
	{
		def serviceQuotationList = ServiceQuotation.findAll("FROM ServiceQuotation sq WHERE sq.profile.id = :spId",[spId: serviceProfile?.id])
		
		//println serviceQuotationList
		Set<Opportunity> opportunitySet = new HashSet<Opportunity>()
		
		for(ServiceQuotation sQuotation: serviceQuotationList)
		{
			opportunitySet.add(sQuotation?.quotation?.opportunity)
		}
		
		for(Opportunity opportunity: opportunitySet?.toList())
		{
			for(Quotation quotation : opportunity?.quotations)
			{
				for(ServiceQuotation sQuotation: quotation?.serviceQuotations)
				{
					//println "coming"
					sQuotation.service = null
					sQuotation.profile = null
					//sQuotation.save()
					sQuotation.delete()
				}
				quotation.delete()
			}
			opportunity.delete()
		}
		
		//serviceProfile = 
		removeServiceProfileData(serviceProfile)
		ServiceProfile oldProfile = null
		//println serviceProfile?.service?.serviceName
		
		if(serviceProfile?.oldProfile?.id != null)
		{
			//println "assigned profile id : " + service?.serviceProfile?.id
			oldProfile = ServiceProfile.get(serviceProfile?.oldProfile?.id)
			service.serviceProfile = ServiceProfile.get(serviceProfile?.oldProfile?.id)
			
			//println "old profile id"
			serviceProfile.oldProfile = null
			//serviceProfile.save()
			oldProfile.newProfile = null
			oldProfile.save()
		}
		else
		{
			service.serviceProfile = null
		}
		
		service.removeFromProfiles(serviceProfile)
		service.save()
		
		/*if(oldProfile?.id != null)
		{
			
		}*/
		
		try {
			//println "above delete line"
			if(serviceProfile.delete(flush: true))
			{
				println "serviceProfile deleted"
			}
		}
		catch (org.springframework.dao.DataIntegrityViolationException ex) {
			ex.printStackTrace(System.out);
		}
		
		//if(oldProfile?.id != null)
			//deleteServiceProfileAndRelatedProperties(oldProfile, service)
	}
	
	private ServiceProfile removeServiceProfileData(ServiceProfile serviceProfile)
	{
		for(ServiceDeliverable sDeliverable : serviceProfile?.customerDeliverables)
		{
			for(ServiceActivity sActivity : sDeliverable?.serviceActivities)
			{
				for(ActivityRoleTime sARTime : sActivity?.rolesEstimatedTime)
				{
					sARTime.delete()
				}
				sActivity.rolesEstimatedTime = new ArrayList()
				
				/*for(DeliveryRole dRole : sActivity?.rolesRequired)
				{
					//dRole.delete()
					sActivity.removeFromRolesRequired(dRole)
				}*/
				sActivity.rolesRequired = new ArrayList()
				
				for(ServiceActivityTask sTask : sActivity?.activityTasks)
				{
					sTask.delete()
				}
				sActivity.activityTasks = new ArrayList()
				
				//sActivity.save()
				sActivity.delete()
			}
			
			sDeliverable.serviceActivities = new ArrayList()
			//sDeliverable.save()
			sDeliverable.delete()
		}
		serviceProfile.customerDeliverables = new ArrayList()
		
		for(ServiceProductItem sProduct : serviceProfile?.productsRequired)
		{
			sProduct.delete()
		}
		serviceProfile.productsRequired = new ArrayList()
		
		for(ServiceProfileSOWDef sowDef : serviceProfile?.defs)
		{
			sowDef.delete()
		}
		serviceProfile.defs = new ArrayList()
		
		for(DeliveryRole dRole : serviceProfile?.rolesRequired)
		{
			serviceProfile.removeFromRolesRequired(dRole)
			//serviceProfile.save()
		}
		serviceProfile.rolesRequired = new ArrayList()
		
		for(ServiceProfileMetaphors metaphor: serviceProfile?.metaphors)
		{
			metaphor.delete()
		}
		serviceProfile.metaphors = new ArrayList()
		
		if(serviceProfile?.currentReviewRequest?.id != null)
		{
			serviceProfile.currentReviewRequest = null
		}
		//println serviceProfile?.reviewRequests
		for(ReviewRequest rRequest: serviceProfile?.reviewRequests?.sort{-it?.id})
		{
			if(rRequest?.id != null && rRequest?.serviceProfile?.id == serviceProfile?.id)
			{
				//println "ReviewRequest Id : " + rRequest?.id
				rRequest.serviceProfile = null
				rRequest.save()
				
				//rRequest.delete()
			}
			
			serviceProfile.removeFromReviewRequests(rRequest)
		}
		serviceProfile.reviewRequests = new ArrayList()
		
		for(StagingLog sLog: serviceProfile?.stagingLogs)
		{
			sLog.delete()
		}
		serviceProfile.stagingLogs = new ArrayList()
		
		for(Pricelist pList : Pricelist.findAll("FROM Pricelist pl WHERE pl.serviceProfile.id = :sid", [sid: serviceProfile?.id]))
		{
			pList.delete()
		}
		
		//serviceProfile.save()
		return serviceProfile
	} 
	
	def delete = {
		def serviceInstance = Service.get(params.id)
		if (serviceInstance) {
			try {
				serviceInstance.delete(flush: true)
				flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'service.label', default: 'Service'), params.id])}"
				redirect(action: "list")
			}
			catch (org.springframework.dao.DataIntegrityViolationException e) {
				flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'service.label', default: 'Service'), params.id])}"
				redirect(action: "show", id: params.id)
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'service.label', default: 'Service'), params.id])}"
			redirect(action: "list")
		}
	}

	def calculateMargin = {
		if(params.profileId && params.marginFields.geoId)
		{
			def serviceProfileInstance = ServiceProfile.get(params.profileId?.toLong())
			def geo = Geo.get(params.marginFields.geoId)
			int units = params.marginFields.units?.toInteger()
			def errorMessage
			Map marginMap = null
			try
			{
				marginMap = priceCalculationService.calculteServiceMargin(serviceProfileInstance, geo, units)
			}
			catch(Exception e)
			{
				errorMessage = e.message
			}

			render(template: "marginCalculation", model: [marginFields: params.marginFields, marginMap: marginMap, serviceProfileInstance: serviceProfileInstance,errorMessage: errorMessage ])
		}
	}

	def salesTotalUnitsSoldGraph = {
		Date endDate = null
		Map salesTotalUnitsByServiceMap = [:]
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date startDate = dateFormat.parse(params.start);
		
		if(params.end == null || params.end == "null")
		{
			salesTotalUnitsByServiceMap = reviewService.generateSalesTotalUnitsByServiceMap(startDate, endDate)
		}
		else
		{
			endDate = dateFormat.parse(params.end);
			salesTotalUnitsByServiceMap = reviewService.generateSalesTotalUnitsByServiceMap(startDate, endDate)
		}
		render (view: "/reports/salesTotalUnitsByServiceOffering", model: [salesTotalUnitsByServiceMap: salesTotalUnitsByServiceMap])
	}
	
	def totalSalesSoldGraph = {
		Date endDate = null
		Map salesSoldByServicesMap = [:]
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date startDate = dateFormat.parse(params.start);
		
		if(params.end == null || params.end == "null")
		{
			salesSoldByServicesMap = reviewService.generateSalesSoldByServicesMap(startDate, endDate)
		}
		else
		{
			endDate = dateFormat.parse(params.end);
			salesSoldByServicesMap = reviewService.generateSalesSoldByServicesMap(startDate, endDate)
		}
		def companyInformation
		def currency = "Money"
		if(CompanyInformation.list().size() > 0)
		{
			companyInformation = CompanyInformation.list().get(0)
			currency = companyInformation.baseCurrency
			
		}
		render (view: "/reports/salesSoldInBaseCurrencyByServiceOffering", model: [salesSoldByServicesMap: salesSoldByServicesMap, currency: currency])
	}
	
	def totalProductSoldGraph = {
		Date endDate = null
		Map productsSoldByServiceMap = [:]
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date startDate = dateFormat.parse(params.start);
		
		if(params.end == null || params.end == "null")
		{
			productsSoldByServiceMap = reviewService.generateProductsSoldByServiceMap(startDate, endDate)
		}
		else
		{
			endDate = dateFormat.parse(params.end);
			productsSoldByServiceMap = reviewService.generateProductsSoldByServiceMap(startDate, endDate)
		}
		
		def companyInformation
		def currency = "Money"
		if(CompanyInformation.list().size() > 0)
		{
			companyInformation = CompanyInformation.list().get(0)
			currency = companyInformation.baseCurrency
			
		}
		render (view: "/reports/productsSoldByService", model: [productsSoldByServiceMap: productsSoldByServiceMap, currency: currency])
	}
	
	public boolean isDeletable(def serviceProfileId)
	{
		ServiceProfile serviceProfileInstance = ServiceProfile.get(serviceProfileId.toLong())
		
		if(serviceProfileInstance.type == ServiceProfile.ServiceProfileType.INACTIVE && serviceProfileInstance.oldProfile == null && serviceProfileInstance.newProfile == null)
		{
			def serviceQuotationList = ServiceQuotation.findAll("FROM ServiceQuotation sq WHERE sq.profile.id = :spId",[spId: serviceProfileInstance?.id])
			println serviceQuotationList
			if(serviceQuotationList?.size() == 0)
			{
				return true
			}
		}
		return false
	}
	
	def checkIsDeletable = {
		ServiceProfile serviceProfileInstance = ServiceProfile.get(params.serviceProfileId.toLong())
		Map resultMap = new HashMap()
		
		//deleteServiceProfileAndRelatedProperties(serviceProfile)
		
		if(/*serviceProfileInstance.oldProfile == null && */ serviceProfileInstance.newProfile == null)
		{
			/*def serviceQuotationList = ServiceQuotation.findAll("FROM ServiceQuotation sq WHERE sq.profile.id = :spId",[spId: serviceProfileInstance?.id])
			
			if(serviceQuotationList?.size() == 0)
			{*/
				resultMap['result'] = "success"
			/*}
			else
			{
				resultMap['result'] = "in_quotation"
			}*/
		}
		else
		{
			resultMap['result'] = "other_profile"
		}
		render resultMap as JSON
	}
	
	
	boolean isPermitted(String action, int id)
	{
		boolean permit = false

		if(SecurityUtils.subject.hasRole('SYSTEM ADMINISTRATOR') || SecurityUtils.subject.hasRole('PORTFOLIO MANAGER') )//|| SecurityUtils.subject.hasRole('PRODUCT MANAGER') || SecurityUtils.subject.hasRole('SERVICE DESIGNER'))
		{
			permit = true
		}
		else if(action == "design")
		{
			if(SecurityUtils.subject.hasRole('PRODUCT MANAGER') || SecurityUtils.subject.hasRole('SERVICE DESIGNER'))
				permit = true
		}
		else if(action == "update")
		{
			if(SecurityUtils.subject.hasRole('PRODUCT MANAGER'))
				permit = true
		}
		
		return permit
		/*
		 if(serviceProfile.type != ServiceProfileType.DEVELOP)
		 {
		 return false;
		 }*/

		permit = SecurityUtils.subject.isPermitted("service:${action}")

		/*
		 if(id && id>0)
		 {
		 permit = SecurityUtils.subject.isPermitted("service:${action}:${id}")
		 }
		 else
		 {
		 permit = SecurityUtils.subject.isPermitted("service:${action}")
		 }*/
		return permit
	}
	
	/*   Card#594 */
	def searchCatalog = {
		
		String queryString = serviceCatalogService.buildServiceSearchCatalogQuery(params.searchFields)
				def user = User.get(new Long(SecurityUtils.subject.principal))
				def portfolioList = serviceCatalogService.findUserPortfolios(user, params)
				def services = Service.findAll(queryString)
			
		String view = "catalog"
		String title = "All Published Services"
		
		if( params.searchFields?.publishedFlag == 'published'){
			view = "catalog"
		}
		else if( params.searchFields?.publishedFlag == 'In Development'){
			view  = "list"
			title = "All Services In Development"
		}
		else if( params.searchFields?.publishedFlag == 'Removed'){
			view  = "list"
			title = "All Removed Services"
		}
		
		render(view:view,
				model: [serviceInstanceList: services, portfolioList: portfolioList, 
					serviceInstanceTotal: services.size(), 
					title: title, showSearch: true, 
					searchFields: params.searchFields, , 
					createPermit: isPermitted("create", 0)])
	}
	/*   Card#594 */
	
	def createCopyServiceProfile = {
		ServiceProfile serviceProfile = ServiceProfile.get(params.id)
		Service service = Service.get(serviceProfile?.service?.id)
		
		ServiceProfile copyServiceProfile = serviceProfile.createNewProfile();
		
		Service newService = service.createNewService(params.serviceName,copyServiceProfile);
		
		copyServiceProfile.service = newService
		copyServiceProfile.belongsTo = newService;
		copyServiceProfile.save(flush:true);
		
		redirect(action: "show", params: [serviceProfileId: copyServiceProfile.ident()])
	}
	
	def userrolesection = {
		Long id = SecurityUtils.getSubject()?.getPrincipal()

		def user = UserBase.get(id)
		render(view: "/user/userroleselection", model: [roles: user.roles])
	}
	
	def generatePdfSOW =
	{
		Map resultMap=new HashMap()
		Geo geo  = Geo.get(new Long(params.geoId));
		boolean isSampleSOWThere = false

		if(geo != null && geo?.sowFile?.filePath != null && geo?.sowFile?.filePath != "")
		{
			def filePath = geo?.sowFile?.filePath + "\\" + geo?.sowFile?.name
			filePath = filePath.replaceAll('\\\\', '/')
			isSampleSOWThere = fileUploadService.isFileExist(filePath)
		
		}

		if(isSampleSOWThere)
		{
			ServiceProfile serviceProfileInstance = ServiceProfile.get(params.id.toLong())
			def generateSOW = new TestWord()
			String fileName = "${serviceProfileInstance.service.skuName}-SOW-${params.geoId}"
			fileName = fileName.replaceAll("[+^,.!@#\$]*", "")//.replaceAll(" ", "")//removed - from [] brecket
			def storagePath =  fileUploadService.getStoragePath("generatedCustomerSOW")
			def outputFilePath = storagePath+"/"+fileName+".docx"
			

			outputFilePath = generateSOW.main(serviceProfileInstance,params.geoId, g, grailsAttributes.getApplicationContext(), outputFilePath ) // g -> grails tags library directly inherit from grails
			resultMap['fileName']=fileName
			resultMap['outputfilePath']=URLEncoder.encode(outputFilePath, "UTF-8")
			render   resultMap as JSON
		}
		else
		{
			render "noFile"
		}
	}
	
	
	
}
