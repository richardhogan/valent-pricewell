package com.valent.pricewell
import org.apache.shiro.SecurityUtils
import java.util.List;

import grails.plugins.nimble.core.*
import grails.converters.JSON

class SetupController {
	def serviceCatalogService
	def salesCatalogService
	def fileUploadService
	def userService
	static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}
	
	private static int currentStepSequenceOrder = 0 //for setup stages sequence Order
	private static int currentStepNo = 1
	private static String currentStepName = "" //for setup stages name
	
	private static int c_instance_info = 0;
	private static int c_company_info = 0;
	private static int c_geo = 0;
	private static int c_territories = 0;
	private static int c_sow_settings = 0;
	private static int c_sow_templates = 0;
	private static int c_delivery_roles = 0;
	private static int c_portfolios = 0;
	private static int c_workflow_settings = 0;
	private static int c_email_settings = 0;
	private static int c_users = 0;
	private static int c_users_all = 0;
	private static int c_quota = 0
	private static int c_connectwise_credentials = 0
	private static int c_salesforce_credentials = 0
	private static int c_clarizen_credentials= 0
	private static int c_default_entities = 0
	
	private static int c_sow_discounts = 0
	//Ankit Start
	private static int c_sow_introduction = 0
	//Ankit End


	private void reloadValues()
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))
		
		def quotaInstanceList = salesCatalogService.getUserQuota(user)//Quota.findAll("FROM Quota quota WHERE quota.createdBy.id=:uid", [uid: user.id])
		
		
		
		//for territory*******************************************************************
		def territoryList = new ArrayList()
		territoryList = salesCatalogService.findUserTerritories(user)
		
		def definedGeoCount = 0
		for(Geo geo in territoryList) {
			if(geo.sowLabel != null && geo.sowLabel!="") {
				definedGeoCount++;
			}
		}
		//for geo*************************************************************************
		def geoGroupInstanceList = new ArrayList()
		if(SecurityUtils.subject.hasRole("GENERAL MANAGER"))
		{
			if(user?.geoGroup != null)
			{
				geoGroupInstanceList.add(user?.geoGroup)
			}
		}
		else if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("SALES PRESIDENT"))
		{
			geoGroupInstanceList = GeoGroup.list(params)
		}
		
		//for SOW Templates***************************************************************
		
		def definedSOWTemplates = countDefinedSOWTemplates()
		//********************************************************************************
		Setting instanceSetting = Setting.findByName("instanceName")
		
		c_instance_info = (instanceSetting == null) ? 0 : 1
		
		c_company_info = CompanyInformation.list().size();
		
		c_geo = geoGroupInstanceList.size();
		
		c_territories = territoryList.size();
		
		c_sow_settings = definedGeoCount;
		
		c_sow_templates = definedSOWTemplates;
		
		c_delivery_roles = DeliveryRole.list().size();
		
		c_portfolios = serviceCatalogService.findUserPortfolios(user, params).size()//Portfolio.list().size();
		
		c_workflow_settings = workflowSettingsCounts();
		c_email_settings = 0;
		c_users = countUser()//User.list().size();
		c_users_all = 0;
		
		c_quota = quotaInstanceList?.size()
		c_connectwise_credentials = ConnectwiseCredentials?.list()?.size()
		
		c_salesforce_credentials = SalesforceCredentials?.list()?.size()
		c_clarizen_credentials=ClarizenCredentials?.list()?.size()
		//Ankit Start
		c_sow_introduction = SowIntroduction?.list()?.size()
		//Ankit End

		c_default_entities = ObjectType.listObjectTypes(ObjectType.Type.SOW_MILESTONE).size() + 
								ObjectType.listObjectTypes(ObjectType.Type.DELIVERABLE_PHASE).size()
		
									/*ObjectType.listObjectTypes(ObjectType.Type.SERVICE_DELIVERABLE).size() +
										ObjectType.listObjectTypes(ObjectType.Type.SERVICE_ACTIVITY).size() +
										ObjectType.listObjectTypes(ObjectType.Type.SERVICE_UNIT_OF_SALE).size() +
										ObjectType.listObjectTypes(ObjectType.Type.SOW_MILESTONE).size()*/
						
		c_sow_discounts = SowDiscount?.list()?.size()

	}

	public int countUser()
	{
		def userList = userService.filterUserList(User.list())//User.findAll("FROM User user WHERE user.username!='superadmin' AND user.username!='user'")
		return userList.size()
	}
	
	public def workflowSettingsCounts()
	{
		def stagingList = Staging.findAll("FROM Staging st WHERE st.entity = 'SERVICE' OR st.entity = 'LEAD' OR st.entity = 'OPPORTUNITY' OR st.entity = 'QUOTATION'")
		return stagingList.size()
	}
	
	def index = {
		redirect(action: "firstsetup", params: params)
	}

	def setup2 = { render(view: "firstsetup2") }

	def firstsetup = {

		boolean displayUsersCount = true
		if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR"))
		{
			displayUsersCount = false
		}
		float k = 1000;

		for(int i=0; i<50; i++){
			k = k + (k * 4.28/100);
		}

		println "=========="
		println k
		println k - 10
		println "=========="

		reloadValues();

		def viewMap = [
			[
				title: "Instance Info",
				image: displayImage(c_instance_info),
				counts: displayCounts(c_instance_info, true),
				link: "link_instance_info",
				isVisible: isVisible("instanceInfo")
			],
			[
				title: "Company Info",
				image: displayImage(c_company_info),
				counts: displayCounts(c_company_info, true),
				link: "link_company_info",
				isVisible: isVisible("companyInfo")
			],
			[
				title: "Users",
				image: displayImage(c_users),
				counts: displayCounts(c_users, displayUsersCount),
				link: "link_users",
				isVisible: isVisible("users")
			],
			[
				title: "GEOs",
				image: displayImage(c_geo),
				counts: displayCounts(c_geo, false),
				link: "link_geos",
				isVisible: isVisible("geos")
			],
			[
				title: "Territories",
				image: displayImage(c_territories),
				counts: displayCounts(c_territories, false),
				link: "link_territories",
				isVisible: isVisible("territories")
			],
			/*[
				title: "SOW Settings",
				image: displayImage(c_sow_settings),
				counts: displayCountsSow(c_sow_settings, false),
				link: "link_sow_settings",
				isVisible: isVisible("sowSettings")
			],*/
			[
				title: "SOW Templates",
				image: displayImage(c_sow_templates),
				counts: displayCountsSow(c_sow_templates, false),
				link: "link_sow_templates",
				isVisible: isVisible("sowTemplates")
			],
			[
				title: "SOW Discounts", 
				image: displayImage(c_sow_discounts), 
				counts: displayCounts(c_sow_discounts, false),
				link: "link_sow_discounts",
				isVisible: isVisible("sowDiscounts")
			],
			[
				title: "Delivery Roles",
				image: displayImage(c_delivery_roles),
				counts: displayCounts(c_delivery_roles, false),
				link: "link_delivery_roles",
				isVisible: isVisible("deliveryRoles")
			],
			[
				title: "Portfolios",
				image: displayImage(c_portfolios),
				counts: displayCounts(c_portfolios, false),
				link: "link_portfolios",
				isVisible: isVisible("portfolios")
			],
			[
				title: "Workflow Settings",
				image: displayImage(c_workflow_settings),
				counts: displayCounts(c_workflow_settings, false),
				link: "link_workflow",
				isVisible: isVisible("workflowSettings")
			],
			[
				title: "Quota",
				image: displayImage(c_quota),
				counts: displayCounts(c_quota, false),
				link: "link_quota",
				isVisible: isVisible("quota")
			],
			[
				title: "Connectwise Credentials",
				image: displayImage(c_connectwise_credentials),
				counts: displayCounts(c_connectwise_credentials, true),
				link: "link_connectwise_credentials",
				isVisible: isVisible("connectwiseCredentials")
			]
			,
			[
				title: "Salesforce Credentials",
				image: displayImage(c_salesforce_credentials),
				counts: displayCounts(c_salesforce_credentials, true),
				link: "link_salesforce_credentials",
				isVisible: isVisible("salesforceCredentials")
			],
				[
				title: "Clarizen Credentials",
				image: displayImage(c_clarizen_credentials),
				counts: displayCounts(c_clarizen_credentials, true),
				link: "link_clarizen_credentials",
				isVisible: isVisible("clarizenCredentials")
				]
				,
			[
				title: "Default Entities",
				image: displayImage(c_default_entities),
				counts: displayCounts(c_default_entities, false),
				link: "link_default_entities",
				isVisible: isVisible("defaultEntities")
			]


			
			//["Email Settings", displayImage(c_email_settings), displayCounts(c_email_settings, true), "link_email_settings"],
			
		]

		if(params.isajax){
			render viewMap as JSON;
		} else{
			return [viewMap: viewMap]
		}

	}

	public boolean isVisible(def string)
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))
		
		if(string == "instanceInfo")
		{
			if(user.username == "superadmin"){return true}else {return false}
		}
		else if(string == "companyInfo")
		{
			if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR")){return true}else {return false}
		}

		else if(string == "users")
		{
			if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole('PORTFOLIO MANAGER') || SecurityUtils.subject.hasRole('PRODUCT MANAGER') || SecurityUtils.subject.hasRole('SALES PRESIDENT') || SecurityUtils.subject.hasRole('GENERAL MANAGER') || SecurityUtils.subject.hasRole('SALES MANAGER')){return true}else {return false}
		}
		else if(string == "geos")
		{
			if(SecurityUtils.subject.hasRole('SYSTEM ADMINISTRATOR') || SecurityUtils.subject.hasRole('SALES PRESIDENT') || SecurityUtils.subject.hasRole('GENERAL MANAGER')){return true}else {return false}
		}
		else if(string == "territories")
		{
			if(SecurityUtils.subject.hasRole('SYSTEM ADMINISTRATOR') || SecurityUtils.subject.hasRole('PORTFOLIO MANAGER') || SecurityUtils.subject.hasRole('SALES PRESIDENT') || SecurityUtils.subject.hasRole('GENERAL MANAGER') || SecurityUtils.subject.hasRole('SALES MANAGER')){return true}else {return false}
		}
		else if(string == "sowSettings")
		{
			if(SecurityUtils.subject.hasRole('SYSTEM ADMINISTRATOR') || SecurityUtils.subject.hasRole('SALES PRESIDENT') || SecurityUtils.subject.hasRole('GENERAL MANAGER') || SecurityUtils.subject.hasRole('SALES MANAGER')){return true}else {return false}
		}
		else if(string == "sowTemplates")
		{
			if(SecurityUtils.subject.hasRole('SYSTEM ADMINISTRATOR') || SecurityUtils.subject.hasRole('SALES PRESIDENT') || SecurityUtils.subject.hasRole('GENERAL MANAGER') || SecurityUtils.subject.hasRole('SALES MANAGER')){return true}else {return false}
		}
		else if(string == "sowDiscounts")
		{
			if(SecurityUtils.subject.hasRole('SYSTEM ADMINISTRATOR') || SecurityUtils.subject.hasRole('SALES PRESIDENT') || SecurityUtils.subject.hasRole('GENERAL MANAGER') || SecurityUtils.subject.hasRole('SALES MANAGER')){return true}else {return false}
		}
		else if(string == "deliveryRoles")
		{
			if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("DELIVERY ROLE MANAGER")){return true}else {return false}
		}
		else if(string == "portfolios")
		{
			if(SecurityUtils.subject.hasRole('PORTFOLIO MANAGER') || SecurityUtils.subject.hasRole('SYSTEM ADMINISTRATOR')){return true}else {return false}
		}
		else if(string == "workflowSettings")
		{
			if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR")){return true}else {return false}
		}
		else if(string == "quota")
		{
			if(SecurityUtils.subject.hasRole('SYSTEM ADMINISTRATOR') || SecurityUtils.subject.hasRole('SALES PRESIDENT') || SecurityUtils.subject.hasRole('GENERAL MANAGER') || SecurityUtils.subject.hasRole("SALES MANAGER") || SecurityUtils.subject.hasRole("SALES PERSON")){return true}else {return false}
		}
		else if(string == "connectwiseCredentials")
		{
			boolean isForConnectwise = salesCatalogService.isClass("com.connectwise.integration.ConnectwiseExporterService", grailsApplication)
			
			if(isForConnectwise && (SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("SALES PRESIDENT"))){return true}else {return false}
		}// || SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("GENERAL MANAGER") || SecurityUtils.subject.hasRole("SALES PRESIDENT")
		else if(string == "salesforceCredentials")
		{
			boolean isForSalesforce = salesCatalogService.isClass("com.salesforce.integration.SalesforceExportService", grailsApplication)
			

			if(isForSalesforce && (SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("SALES PRESIDENT"))){return true}else {return false}
		}
		else if(string == "clarizenCredentials")
		{
//			boolean isForClarizen = salesCatalogService.isClass("com.clarizen.integration.ClarizenExportService", grailsApplication)
//			
//
//			if(isForClarizen && (SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("SALES PRESIDENT"))){return true}else {return false}
			return true
			}
		else if(string == "defaultEntities")
		{
			if(SecurityUtils.subject.hasRole('SYSTEM ADMINISTRATOR')){return true} else {return false}
		}
		//Ankit Start
		else if(string == "sowIntroduction")
		{
			if(SecurityUtils.subject.hasRole('SYSTEM ADMINISTRATOR')){return true} else {return false}
		}
		//Ankit End

	}
	
	def process = {
		if(params.id == 'link_instance_info'){
			if(c_instance_info == 0){
				redirect(controller: "companyInformation", action: "createInstanceInfo", params: [source: "firstsetup"])
			} else {
				redirect(controller: "companyInformation", action: "showInstanceInfo", params: [source: "firstsetup"])
			}
		}
		else if(params.id == 'link_company_info'){
			if(c_company_info == 0){
				redirect(controller: "companyInformation", action: "createFromSetup", params: [source: "firstsetup"])
			} else {
				params.source = "setup";
				redirect(controller: "companyInformation", action: "showsetup", params: [source: "firstsetup"])
			}
		}
		else if(params.id == 'link_geos'){
			redirect(controller: "geoGroup", action: "listsetup", params: [source: "firstsetup"])
		}
		else if(params.id == 'link_sow_settings'){
			redirect(controller: "setting", action: "settingsetup", params: [source: "firstsetup"])
			//redirect(controller: "setting", action: "settingsOfSow", params: [source: "firstsetup"])
		}
		else if(params.id == 'link_sow_templates'){
			//redirect(controller: "setting", action: "SOWTemplates", params: [source: "firstsetup"])
			redirect(controller: "documentTemplate", action: "sowDocumentTemplates", params: [source: "firstsetup"])
		}
		else if(params.id == 'link_sow_discounts'){
			redirect(controller: "sowDiscount", action: "listsetup", params: [source: "firstsetup"])
		}
		else if(params.id == 'link_territories'){
			redirect(controller: "geo", action: "listsetup", params: [source: "firstsetup"])
		}
		else if(params.id == 'link_users'){
			redirect(controller: "userSetup", action: "listroles", params: [source: "firstsetup"])
		}
		else if(params.id == 'link_delivery_roles'){
			redirect(controller: "deliveryRole", action: "listsetup", params: [source: "firstsetup"])
		}
		else if(params.id == 'link_portfolios'){
			redirect(controller: "portfolio", action: "listsetup", params: [source: "firstsetup"])
		}
		else if(params.id == 'link_workflow'){
			redirect(controller: "staging", action: "listsetup", params: [source: "firstsetup"])
		}
		else if(params.id == 'link_quota'){
			redirect(controller: "quota", action: "listsetup", params: [source: "firstsetup"])
		}
		else if(params.id == 'link_connectwise_credentials'){
			
			if(ConnectwiseCredentials.list().size() == 0){
				redirect(controller: "connectwiseCredentials", action: "createsetup", params: [source: "firstsetup"])
			} else {
				redirect(controller: "connectwiseCredentials", action: "showsetup", params: [source: "firstsetup"])
			}
		}
		else if(params.id == 'link_salesforce_credentials'){
			
			if(SalesforceCredentials.list().size() == 0){
				redirect(controller: "salesforceCredentials", action: "createsetup", params: [source: "firstsetup"])
			} else {
				redirect(controller: "salesforceCredentials", action: "showsetup", params: [source: "firstsetup"])
			}
		}
		else if(params.id == 'link_clarizen_credentials'){
			
			if(ClarizenCredentials.list().size() == 0){
				redirect(controller: "clarizenCredentials", action: "createsetup", params: [source: "firstsetup"])
			} else {
				redirect(controller: "clarizenCredentials", action: "showsetup", params: [source: "firstsetup"])
			}
		}
		else if(params.id == "link_default_entities")
		{
			redirect(controller: "objectType", action: "listsetup", params: [source: "firstsetup", type: "deliverablePhase"])
		}
		//Ankit Start
		else if(params.id == 'link_sow_introduction'){
					
				redirect(controller: "sowIntroduction", action: "listsetup", params: [source: "firstsetup"])
				
		}
		//Ankit End
	}

	private String displayImage(int i){
		return (i > 0? "star-on.png": "star-off.png");
	}

	private String displayCounts(int i, boolean isBoolean){
		if(isBoolean){
			return (i == 0? "": "")
		} else {
			return ("(" + i + ")")
		}
	}

	private String displayCountsSow(int i, boolean isBoolean){
		def user = User.get(new Long(SecurityUtils.subject.principal))
		if(isBoolean){
			return (i == 0? "": "")
		} else {
			return ("(" + i +"/"+salesCatalogService.findUserTerritories(user).size()+ ")")
		}
	}

	def changeStage =
	{
		currentStepSequenceOrder++
		println currentStepSequenceOrder
		
		def setupStage = Staging.findBySequenceOrder(currentStepSequenceOrder)
		currentStepName = setupStage.name
		currentStepNo = 1
		
		redirect(action: "setup")
	}
	
	def isUserDefined =
	{
		println "coming here user"
		String roleName = ServiceStageFlow.findUserRole("addUsers", currentStepNo);
		def roleInstance = Role.findByName(roleName)
		
		if(roleInstance?.users.size() > 0)
		{
			render "true"
		}
		else
		{
			render "false"
		}
	}
	
	def showStage = {
		
		String source = params.source
		
		int stepNumber = (params.step_number && params.step_number.toInteger() > 0?params.step_number.toInteger(): 1);
		currentStepNo = stepNumber
		String stepName = ServiceStageFlow.findSetupStepName(source, stepNumber);
		
		switch(source)
		{
			case "welcome":
				
				if(stepName.equals("welcome"))
				{
					render(template: "stage/welcome-welcomepage")
				}
				break;
			
			case "companyInfo":
				if(stepName.equals("addCompanyInfo"))
				{
					def companyInformationInstance = new CompanyInformation()
					def companyInformationId = null
					
					if(CompanyInformation.list().size()>0) {
						for(CompanyInformation ci in CompanyInformation.list()) {
							companyInformationInstance = ci
							companyInformationId = ci.id
						}
					}
					else {
						companyInformationInstance = new CompanyInformation()
						companyInformationInstance.properties = params
					}
					
					render(template: "../companyInformation/aboutCompanyInfo", model: [companyInformationInstance: companyInformationInstance, companyInformationId: companyInformationId, source: "setup"])
				}
				break;
				
			case "addUsers":
				if(stepName.equals("createUser"))
				{
					String roleName = ServiceStageFlow.findUserRole(source, stepNumber);
					def roleInstance = Role.findByName(roleName)
					def territoriesList = new ArrayList(), geoGroupList = new ArrayList()
					def roleUserList = []
					//roleUserList = roleInstance?.users
					roleUserList = userService.filterUserList(roleInstance?.users.toList())
					
					def userInstance = new User()
					userInstance.properties = params
					
					/*if(roleInstance.name == "SYSTEM ADMINISTRATOR")
					{
						
						roleUserList = new ArrayList()
						for(User user : roleInstance?.users)
						{
							if(user.username != "superadmin")
							{
								roleUserList.add(user)
							}
						}
						
					}
					else*/ if(roleInstance.name == "SALES PRESIDENT")
					{
						territoriesList = Geo.list()
					}
					
					else if(roleInstance.name == "GENERAL MANAGER")
					{
						/*if(params.sourceFrom != "geoGroup")
						{*/
							def map = [:]
							map = salesCatalogService.findUnassignedGeosWithTerritoriesForGeneralManager()//.findUnassignedGeosForGeneralManager()
							geoGroupList = map['geoGroupList']
							territoriesList = map['territoriesList']
						//}
					}
					else if(roleInstance.name == "SALES MANAGER")
					{
						/*if(params.sourceFrom != "geo")
						{*/
							def map = [:]
							map = salesCatalogService.findUnassignedTerritoriesForSalesManager(null)
							geoGroupList = map['geoGroupList']
							territoriesList = map['territoriesList']
						//}
					}
					else if(roleInstance.name == "SALES PERSON")
					{
						/*if(params.sourceFrom != "geo")
						{*/
							geoGroupList = GeoGroup.list()
							territoriesList = salesCatalogService.findTerritoriesForSalesPerson(null)
						//}
					}
					
					//generating random password
					//CommonFunctionsUtil generateRandomPassword = new CommonFunctionsUtil()
					//def randomPassword = generateRandomPassword.generatePswd(8, 8, 1, 1, 1)
					
					render(template: "../userSetup/aboutUser", model: [user: userInstance, roleInstance: roleInstance, roleUserList: roleUserList, source: 'setup', geoGroupList: geoGroupList, territoriesList: territoriesList])
					
				}
				break;
				
				case "geos":
				if(stepName.equals("createGeos"))
				{
					def geoGroupInstance = new GeoGroup()
					geoGroupInstance.properties = params
					def generalManagerList = new ArrayList()
					generalManagerList = salesCatalogService.findUnassignedGeneralManagerList()
					
					def territoriesList = TerritoriesList(geoGroupInstance)
					render(template: "../geoGroup/aboutGeoGroup", model: [geoGroupInstance: geoGroupInstance, generalManagerList: generalManagerList, territoriesList: territoriesList, geoGroupList: GeoGroup.list(), source: 'setup'])
				}
				break;
			
			case "deliveryRoles":
				if(stepName.equals("createDeliveryRoles"))
				{
					def deliveryRoleInstance = new DeliveryRole()
					deliveryRoleInstance.properties = params
					render(template: "../deliveryRole/aboutDeliveryRole", model: [deliveryRoleInstance: deliveryRoleInstance, deliveryRoleList: DeliveryRole.list(), source: 'setup'])
				}
				break;
				
			case "portfolios":
				if(stepName.equals("createPortfolios"))
				{
					def portfolioInstance = new Portfolio()
					portfolioInstance.properties = params
					def portfolioManagerList = serviceCatalogService.findPortfolioManagers()
					render(template: "../portfolio/aboutPortfolio", model: [portfolioInstance: portfolioInstance, portfolioManagerList: portfolioManagerList, portfolioList: Portfolio.list(), source: 'setup'])
				}
				break;
			//9879000099

		}
	}
	
	private String getBaseCurrency() {
		Collection col = CompanyInformation.list();
		if(col.size() > 0) {
			return col.iterator().next().baseCurrencySymbol;
		}
		return null;
		
	}
	
	public int countDefinedSOWTemplates()
	{
		def definedSOWTemplates = 0
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def territoryList = new ArrayList()
		territoryList = salesCatalogService.findUserTerritories(user)
		
		for(Geo territory in territoryList)
		{
			boolean isFile = false
			/*if(territory.sowFile?.filePath != null && territory.sowFile ?.filePath != "")
			{
				def filePath = territory.sowFile?.filePath + "\\" + territory.sowFile?.name
				filePath = filePath.replaceAll('\\\\', '/')
				isFile = fileUploadService.isFileExist(filePath)
			}
			if(isFile)
			{
				definedSOWTemplates++
			}*/
			
			if(territory?.sowDocumentTemplates?.size() > 0)
			{
				definedSOWTemplates++
			}
			
		}
		
		return definedSOWTemplates
	}
	
	public List TerritoriesList(GeoGroup geo)
	{
		def territoriesList = new ArrayList()
		for(Geo territory : Geo.list())
		{
			if(territory.geoGroup == null || territory.geoGroup.id == geo?.id)
			{
				territoriesList.add(territory)
			}
		}
		return territoriesList
	}
	def setup = {
		List stagingInstanceList = Staging.listSetupStages("NEW_STAGE")
		//currentStepSequenceOrder = 0
		if(currentStepSequenceOrder == 0)
		{
			println stagingInstanceList[0].sequenceOrder
			currentStepSequenceOrder = stagingInstanceList[0].sequenceOrder
			currentStepName = stagingInstanceList[0].name
			currentStepNo = 1
		}
		/*else
		{
			currentStepSequenceOrder = params.currentStepSequenceOrder.toInteger()
		}*/
		
		
		render(view: "main", model: [stagingInstanceList: stagingInstanceList, currentStepNo: currentStepNo, currentStepName: currentStepName, currentStepSequenceOrder: currentStepSequenceOrder])
	}
	
	public boolean isClass(String className)
	{
		boolean exist = false;
		
		for (grailsClass in grailsApplication.allClasses)
		{
			if(grailsClass.name == className)
			{
				exist = true;
				println grailsClass.name
			}
		}
		
		return exist;
	}

}
