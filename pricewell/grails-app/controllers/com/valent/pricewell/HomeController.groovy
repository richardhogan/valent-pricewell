package com.valent.pricewell
import java.text.DateFormat
import java.text.SimpleDateFormat
import java.util.ArrayList;
import java.util.Date;
import java.util.Map;

import org.apache.shiro.SecurityUtils

import grails.converters.JSON
import grails.plugins.nimble.core.*
import com.valent.pricewell.ServiceProfile.ServiceProfileType
import com.valent.pricewell.util.*

import cw15.ApiCredentials;
//import cw15.*

class HomeController {
	
	def serviceCatalogService
	def chartService
	def reviewService, bootstrapProcessService
	def phoneNumberService, rTFToDocumentConverterService
	def opportunityService, cwimportService, fileUploadService, connectwiseCatalogService, salesCatalogService, salesforceExportService
	//def fileSystemService
	def dateService
	
	public static String DEFAULTUSERROLE  = 'DEFAULTUSERROLE';
	
	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}
	
	def removeFractionalSecondsAndTimeZone(String dateString)
	{
		def length = dateString.length()
		return dateString.substring(0, length-5)
	}
	
	def index = {	
		
		User user = User.get(new Long(SecurityUtils.subject.principal))
		
		if( session.getAttribute(DEFAULTUSERROLE) != null ){
			session.setAttribute("PARAMETERROLE", session.getAttribute(DEFAULTUSERROLE).value());
			redirect(action: "updaterole");
			return;
		}
		
		//rTFToDocumentConverterService.convertStringStyleToArrayList(g, "<b>Abhi<b/>", [])
		
		/*List styleList = new LinkedList()
		String str2 = '<p style="text-align: justify;">	<strong>Customer</strong>&nbsp;<em>has</em>&nbsp;engaged SMP to upgrade and virtualize their Cisco communications infrastructure including Unified Communications Manager (CUCM), Unified Contact Center Express (UCCX), Cisco Unity Connection (CUC) and Cisco Emergency Responder.</p>'
		println convertStringStyleToArrayList(str2, styleList)*/
		//checkString()
		//moveAccountLogos()
		//moveSowTemplateFiles()

		//new SendMail().main()
		//println g.render(template:"/home/test")
		/*if(CompanyInformation.list().size() == 0 || GeoGroup.list().size() == 0 || DeliveryRole.list().size() == 0 || Portfolio.list().size() == 0)
		{
			redirect(controller: "setup", action: "setup")
			return
		}
		else
		{
			for(Role role : Role.list())
			{
				if(role?.users.size() == 0)
				{
					redirect(controller: "setup", action: "setup")
					return
				}
			}
			
		}*/
		//refreshService()
		//cwimportService.showReportingApiFields()
		//cwimportService.importOpportunities("https://test.connectwise.com/v4_6_release");
		
		//List opportunityListMap = salesforceExportService.exportOpportunities()
		
		/*for(Map opportunityMap : opportunityListMap)
		{			
			//println "closed date : "+ dateService.getDate("yyyy-MM-dd", opportunityMap["CloseDate"])
			//println "create date : "+ dateService.getDate("yyyy-MM-dd'T'HH:mm:ss", removeFractionalSecondsAndTimeZone(opportunityMap["CreatedDate"]))
			//println "modified date : "+ dateService.getDate("yyyy-MM-dd'T'HH:mm:ss", removeFractionalSecondsAndTimeZone(opportunityMap["LastModifiedDate"]))
			
			String accountId = opportunityMap["AccountId"]
			println "Account : " + salesforceExportService.getAccountFromId(accountId)
			println "Contacts : " + salesforceExportService.getContactListFromAccountId(accountId)
			
			println "----------------------------------------------------------------------------------------------------------------------------"
		}*/
		
		if(isSuperAdmin())
		{
			Setting instanceSetting = Setting.findByName("instanceName")
			
			if(instanceSetting == null)
			{
				redirect(controller: "companyInformation", action: "createInstanceInfo")
				return
			}
			
		}
		
		try
		{
			/*if(session['toThrowException'])
			{
				session['toThrowException'] = false
				throw new java.sql.SQLException()
			}*/
			
			
			if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR"))
			{
				//createPriceList(user)
				/*if(CompanyInformation.list().size()!=0) {
					for(CompanyInformation ci in CompanyInformation.list()) {
						if(ci?.logo == null)
						{
							redirect(controller: "companyInformation", action: "addLogo", id: ci.id)
						}
					}
				}
				
				else */if(Portfolio.list().size() == 0)
				{
					session.setAttribute(DEFAULTUSERROLE, RoleEnum.SYSTEM_ADMINISTRATOR);
					user.lastLoginRole = RoleEnum.SYSTEM_ADMINISTRATOR.value()
					user.save()
					
					redirect(controller: "setup", action: "setup")
					return
				}
			}
		}
		catch(java.sql.SQLException ex)
		{
			println "SQL server access error.."
			redirect(controller: "home", action: "index")
		}
		catch(Exception ex)
		{
			redirect(controller: "home", action: "index")
		}		
		//ratan's code
		
		def c = LoginRecord.createCriteria()
		
		List logins = c.list 
		{
			eq("owner", user)
			order("dateCreated","desc")
			maxResults(30)
	   }
		
	   Date startDate = new Date()
	   Integer year = startDate.year + 1900
	   Integer month = startDate.month + 1
	   
	   def quarterOfMonth = dateService.getQuarter(month)
	   def quarterDates = dateService.getDatesOfGivenQuarter(quarterOfMonth, year)
	   
	   def endDate = new GregorianCalendar(year, month-1, 01)
	   
	   def curLogin = logins[0]?.dateCreated
	   def preLogin = logins[2]?.dateCreated
			   
	   /*def credentialsMap = cwimportService.getCredentials()
	   ApiCredentials credentials = credentialsMap["credentials"]
	   String baseUrl = credentialsMap["siteUrl"]
	   cwimportService.getConnectwiseOpportunity(baseUrl, credentials, convertDateToXmlGregorianCalendar(quarterDates))*/
	   
	   def notifications = []
	   notifications = Notification.listUserNotifications(user, "active")
	   
	   //fileSystemService.readXmlFile()
	   //fileSystemService.readXmlFile2()
	   for(ServiceQuotation sq : ServiceQuotation.list())
	   {
		   if(sq?.stagingStatus?.name != "active")
		   {
		   	   sq.stagingStatus = Staging.findByName("active")
			   sq.oldUnits = 0
			   sq.save()
		   }
	   }
	   
	   for(Quotation qu : Quotation.list())
	   {
		   if(qu.requestLevel3 == null || qu.requestLevel3 == "NULL" || qu.requestLevel3 == "null")
		   {
			   qu.requestLevel3 = false
			   qu.save()
		   }
		   
	   }
	   
	   def companyInformation
	   def currency = "Money"
	   if(CompanyInformation.list().size() > 0)
	   {
		   companyInformation = CompanyInformation.list().get(0)
		   if(companyInformation.baseCurrency != null)
		   		currency = companyInformation.baseCurrency
		   
	   }
	   
	   List opportunityList = chartService.getServiceTicketRelatedOpportunities()
	   Map serviceVarianceMap = new HashMap()
	   if(opportunityList.size() > 0)
	   {
		   serviceVarianceMap = chartService.calculateServiceVarianceForOpportunity(opportunityList[0])
	   }
	   serviceVarianceMap['opportunityList'] = opportunityList 
	   
	    //chartService.getServiceTicketRelatedOpportunities()
	    Map totaldiscount = [:]
		
		//String[] roles = ["SYSTEM ADMINISTRATOR", "PORTFOLIO MANAGER","PRODUCT MANAGER","SERVICE DESIGNER","DELIVERY ROLE MANAGER", "SALES PRESIDENT", "GENERAL MANAGER", "SALES MANAGER", "SALES PERSON"]; //"USER"
		
		RoleEnum defaultUserRole = PricewellUtils.getFirstMatchingRoleEnum()
		if(defaultUserRole == null)
		{
			redirect(controller: "home", action: "index")
			return
		}
		session.setAttribute(DEFAULTUSERROLE, defaultUserRole);
		user.lastLoginRole = defaultUserRole.value()
		user.save()
		
		//if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR"))
		if(defaultUserRole.value().equals("SYSTEM ADMINISTRATOR"))
		{
			
			def pmList = serviceCatalogService.findPortfolioManagers()
			
			def assignedPortfolioList = chartService.findPortfoliosAssignedByPortfolioManager(pmList)
			
			Map accountStatusByRoleData = chartService.buildChartDataForUserStatusByRole()
			
			Map unassignedExceptionReport = chartService.getUnassignedExceptionReport()
			
			//Getting details of last logins for distinct user only
			
			List recentLoginList = recentLoginRecord()
				
			totaldiscount = chartService.countVSOEDiscounting(startDate, dateService.getDate(quarterDates['from']), null)//get accepted quotation discount....
			
			//session.setAttribute(DEFAULTUSERROLE, RoleEnum.SYSTEM_ADMINISTRATOR);
			
			render(view: "admin", model: [unassignException: unassignedExceptionReport, serviceVarianceMap: serviceVarianceMap, currency: currency, assignedPortfolios: assignedPortfolioList,  totaldiscount: totaldiscount, notificationList: notifications, accountStatusByRoleData: accountStatusByRoleData, recentLoginList: recentLoginList])

		}
		//else if(SecurityUtils.subject.hasRole("PORTFOLIO MANAGER") || SecurityUtils.subject.hasRole("PRODUCT MANAGER") || SecurityUtils.subject.hasRole("SERVICE DESIGNER") || SecurityUtils.subject.hasRole("DELIVERY ROLE MANAGER")) // || SecurityUtils.subject.hasRole("USER")
		else if(defaultUserRole.value().equals("PORTFOLIO MANAGER") || defaultUserRole.value().equals("PRODUCT MANAGER") || defaultUserRole.value().equals("SERVICE DESIGNER") || defaultUserRole.value().equals("DELIVERY ROLE MANAGER"))
		{
			Map productManagerEstimatedVeriance = [:]
			def serviceQuoteList = []
			def assignedPortfolio = []
			def listForServiceDesigner = []
			//boolean instage = true
			
			boolean quote = false
			Map map = [:]
			Map salesTotalUnitsByServiceMap = [:], serviceException = [:], productException = [:]
			Map salesSoldByServicesMap = [:], serviceFunnelData = [:]
			def productsSoldByServiceMap = null;
			def serviceSoldPerPortfolioMap = [:], itCostPerQuotationMap = [:]
			
			Map serviceDesignerEstimatedVeriance = [:]
			//if(SecurityUtils.subject.hasRole("PORTFOLIO MANAGER"))
			if(defaultUserRole.value().equals("PORTFOLIO MANAGER"))
			{
				productManagerEstimatedVeriance = chartService.findEstimateVarianceForPMs()
				
				productException = serviceCatalogService.getProductExceptionReport()
				serviceException = serviceCatalogService.getServiceExceptionReport()
				salesTotalUnitsByServiceMap = chartService.generateSalesTotalUnitsByServiceMap(startDate, dateService.getDate(quarterDates['from']))
				salesSoldByServicesMap = chartService.generateSalesSoldByServicesMap(startDate, dateService.getDate(quarterDates['from']))
				productsSoldByServiceMap = chartService.generateProductsSoldByServiceMap(startDate, dateService.getDate(quarterDates['from']))
				 def territoryList=Geo.list() 
				PricewellUtils.Println("Hello" +territoryList)
				
				def userPortfolios = serviceCatalogService.findUserPortfolios(user, params)
				if(userPortfolios.size() > 0)
				{
					//userPortfolios = userPortfolios.sort(it.portfolioName)
					serviceSoldPerPortfolioMap = chartService.generateServiceSoldPerPortfolioMap(userPortfolios[0], startDate, dateService.getDate(quarterDates['from']),-1)
					serviceSoldPerPortfolioMap.put("portfolios", userPortfolios)
					serviceSoldPerPortfolioMap.put("portfolio", userPortfolios[0])
					serviceSoldPerPortfolioMap.put("territory",territoryList)  
					itCostPerQuotationMap = chartService.generateItCostPerQuotationMap(userPortfolios[0], startDate, dateService.getDate(quarterDates['from']),-1)
					
				}
				
				//println productsSoldByServiceMap
			}
			
			else if(defaultUserRole.value().equals("PRODUCT MANAGER"))//if(SecurityUtils.subject.hasRole("PRODUCT MANAGER"))
			{
				assignedPortfolio = serviceCatalogService.productManagerPortfolios(user)
				//println assignedPortfolio
				serviceDesignerEstimatedVeriance = chartService.findEstimateVarianceForSDs()
				serviceFunnelData = chartService.getServiceFunnelGraphData(startDate, null)//dateService.getDate(quarterDates['from']))
			}
			
			
			else if(defaultUserRole.value().equals("SERVICE DESIGNER"))//if(SecurityUtils.subject.hasRole("SERVICE DESIGNER"))
			{
				
				listForServiceDesigner = serviceCatalogService.findUserServicesByStaging(user, ServiceProfileType.DEVELOP)
			}
			
			
			
			//println salesTotalUnitsByServiceMap
			//println salesSoldByServicesMap
			
			//String[] roles = ["PORTFOLIO MANAGER","PRODUCT MANAGER","SERVICE DESIGNER","DELIVERY ROLE MANAGER"]; //"USER"
			//session.setAttribute(DEFAULTUSERROLE, PricewellUtils.getFirstMatchingRoleEnum(roles));
			
			render(view: "all",  model: [itCostPerQuotationMap: itCostPerQuotationMap, serviceSoldPerPortfolioMap: serviceSoldPerPortfolioMap, serviceFunnelData: serviceFunnelData, user: user, serviceList: serviceException["serviceList"], productList: productException["productList"], salesTotalUnitsByServiceMap: salesTotalUnitsByServiceMap, salesSoldByServicesMap: salesSoldByServicesMap, quote: quote, totaldiscount: totaldiscount, assignedPortfolio: assignedPortfolio, notificationList: notifications,productManagerEstimatedVeriance: productManagerEstimatedVeriance, serviceDesignerEstimatedVeriance: serviceDesignerEstimatedVeriance, serviceQuoteList: serviceQuoteList, productsSoldByServiceMap: productsSoldByServiceMap, currency: currency, listForServiceDesigner: listForServiceDesigner, serviceInstanceTotal: listForServiceDesigner.size(), title: "My Services In Development"])
		}
		//else if(SecurityUtils.subject.hasRole("GENERAL MANAGER") || SecurityUtils.subject.hasRole("SALES PERSON") || SecurityUtils.subject.hasRole("SALES MANAGER") || SecurityUtils.subject.hasRole("SALES PRESIDENT"))
		else if(defaultUserRole.value().equals("SALES PRESIDENT") || defaultUserRole.value().equals("GENERAL MANAGER") || defaultUserRole.value().equals("SALES MANAGER") || defaultUserRole.value().equals("SALES PERSON"))
		{
			//session.setAttribute(DEFAULTUSERROLE, PricewellUtils.getFirstMatchingRoleEnum((String[])["SALES PRESIDENT", "GENERAL MANAGER", "SALES MANAGER", "SALES PERSON"]));
			
			if(user?.primaryTerritory == null)
			{
				redirect(controller: "userSetup", action: "addPrimaryTerritory")
				return
			}
			
			//opportunityService.checkOpportunities(opportunityService.getUserOppoertunities(user, new FilterCriteria()))
			Map dateMap = dateService.getTimespanForQuota("This quarter")
			
			Map territoryMap =  chartService.getDefaultTerritory()
			Geo defaultTerritory = territoryMap['defaultTerritory']
			Map quarterlyTotalSalesMap = chartService.quarterlyTotalSalesByUser(defaultTerritory)
			
			Map map = chartService.buildSalesQuotesChartData(user, startDate, dateService.getDate(quarterDates['from']), defaultTerritory)
			def pendingDaysMap = chartService.buildChartDataForQuotesPendingDays(defaultTerritory,null,null)
			Map quotaData = [:]
			if(SecurityUtils.subject.hasRole("SALES PRESIDENT") || SecurityUtils.subject.hasRole("GENERAL MANAGER") || SecurityUtils.subject.hasRole("SALES MANAGER") || SecurityUtils.subject.hasRole("SALES PERSON"))
				{	
					quotaData = opportunityService.getQuotaAssignedVsQuotaAchivement(dateMap, defaultTerritory)
					
					}
			
			Map quotaPerPersons = [:]
			if(SecurityUtils.subject.hasRole("SALES PRESIDENT") || SecurityUtils.subject.hasRole("GENERAL MANAGER") || SecurityUtils.subject.hasRole("SALES MANAGER"))
			{
				quotaPerPersons = opportunityService.getQuotaAssignedVsQuotaAchivementPerPersons(dateMap, defaultTerritory)//quotaData['territory'])
			}
			
			Map opportunityFunnelData = chartService.getOpportunityFunnelGraphData(startDate, null, defaultTerritory)//dateService.getDate(quarterDates['from']))
			Map leadFunnelData = chartService.getLeadFunnelGraphData(startDate, null)//dateService.getDate(quarterDates['from']))
			
			totaldiscount = chartService.countVSOEDiscounting(startDate, dateService.getDate(quarterDates['from']), defaultTerritory)//get accepted quotation discount....
			
			render(view: "sales", model: [defaultTerritory: defaultTerritory, territoryList: territoryMap['territoryList'], leadFunnelData: leadFunnelData, opportunityFunnelData: opportunityFunnelData, currency: currency, quarterlyTotalSalesMap: quarterlyTotalSalesMap, quotaPerPersons: quotaPerPersons, quoteTypesMap: map, pendingDaysMap: pendingDaysMap, notificationList: notifications, totaldiscount: totaldiscount, quotaData: quotaData]);
		}
		
	}
	
	def adminHome = {
		render(view: "admin")
	}

	def productManagerHome = {
		render(view:"pm")
	}

	def serviceDesignerHome = {
		render(view:"sd")
	}

	def salesPersonHome = {
		render(view:"sales")
	}
	
	public Map convertDateToXmlGregorianCalendar(Map quarterDates)
	{
		Map dateMap = new HashMap()
		dateMap["startDate"] = dateService.toXMLGregorianCalendar(dateService.getDate(quarterDates["from"]))
		dateMap["endDate"] = dateService.toXMLGregorianCalendar(dateService.getDate(quarterDates["to"]))
		return dateMap
	}
	public List recentLoginRecord()
	{
		List<LoginRecord> lastLoginList = new ArrayList<LoginRecord>()
		List tempList = new ArrayList();
		User user = User.get(new Long(SecurityUtils.subject.principal))
		
		if(user?.username != "superadmin")
		{
			tempList = LoginRecord.findAll("FROM LoginRecord lr WHERE lr.owner.username != 'superadmin' ORDER BY lr.dateCreated DESC")
		}
		else
		{
			tempList = LoginRecord.findAll("FROM LoginRecord lr ORDER BY lr.dateCreated DESC")
		}
		
		Set userIdSet = new HashSet()
		int i = 0;
		for(LoginRecord lr : tempList)
		{
			if(i<10 && !userIdSet.contains(lr?.owner?.id))
			{
				userIdSet.add(lr?.owner?.id)
				lastLoginList.add(lr)
				i++
				
				if(i==10)
				{
					break
				}
			}
		}
		
		
		return lastLoginList//.sort{it?.owner?.profile?.fullName}
	}
	
	public void createPriceList(User user)
	{
		def services = Service.listPublished(user)
		for(Service service : services)
		{
			serviceCatalogService.updateServiceToPricelist(service?.serviceProfile, user)
		}
		
	}
	
	void moveAccountLogos()
	{
		for(Account ac : Account.list())
		{
			if(ac?.imageFile?.filePath != null && ac?.imageFile?.filePath != "" && ac?.imageFile?.filePath != "null")
			{
				if(fileUploadService.isFileExist(ac?.imageFile?.filePath))
				{
					def newFilePath = fileUploadService.getStoragePath("customerLogos")
					if(fileUploadService.moveUploadedFile(ac?.imageFile?.filePath, newFilePath))
					{
						UploadFile uf = UploadFile.get(ac?.imageFile?.id)
						uf.filePath = newFilePath+"/"+uf.name
						uf.save()
					}
				}
			}
		}
	}
	
	public boolean isConnectwiseIncluded()
	{
		//boolean isForConnectwise = false
		return salesCatalogService.isClass("com.connectwise.integration.ConnectwiseExporterService", grailsApplication)
	}
	
	void refreshService()
	{
		for(ServiceProfile sp : ServiceProfile.list())
		{
			if(sp?.stagingStatus == null)
			{
				Staging concept = Staging.findByName("concept")
				sp.stagingStatus = concept
				sp.save()
				println sp
			}
		}	
	}
	
	void moveSowTemplateFiles()
	{
		for(Geo territory in Geo.list())
		{
			boolean isFile = false
			def filePath = ""
			if(territory.sowFile?.filePath != null && territory.sowFile ?.filePath != "")
			{
				filePath = territory.sowFile?.filePath + "\\" + territory.sowFile?.name
				filePath = filePath.replaceAll('\\\\', '/')
				isFile = fileUploadService.isFileExist(filePath)
			}
			if(isFile)
			{
				def newFilePath = fileUploadService.getStoragePath("SOWFiles")
				if(fileUploadService.moveUploadedFile(filePath, newFilePath))
				{
					UploadFile uf = UploadFile.get(territory?.sowFile?.id)
					uf.filePath = newFilePath
					uf.save()
				}
			}
			
		}
	}
	
	public boolean isSuperAdmin()
	{
		def cred = SecurityUtils.subject.principal
		
		if(cred != null)
		{
			def user = User.get(new Long(SecurityUtils.subject.principal))
			if(user.username == "superadmin")
			{
				return true
			}
		}
		return false
	}

	def changerole = {
		String currentRole = params.role;
		
		session.setAttribute("PARAMETERROLE", currentRole);
		redirect(action: "updaterole");
	}
	
	def updaterole = {
		
		User user = User.get(new Long(SecurityUtils.subject.principal))
		
		String previousRole = "DEFAULT";
		
		if( session.getAttribute(DEFAULTUSERROLE) != null ){
			previousRole = session.getAttribute(DEFAULTUSERROLE).value();
		}
		
		String currentRole = session.getAttribute("PARAMETERROLE");
		user.lastLoginRole = currentRole
		user.save()
		
		if(isSuperAdmin())
		{
			Setting instanceSetting = Setting.findByName("instanceName")
			
			if(instanceSetting == null)
			{
				redirect(controller: "companyInformation", action: "createInstanceInfo")
				return
			}
			
		}
		
		if(currentRole.equals("SYSTEM ADMINISTRATOR"))
		{
			if(Portfolio.list().size() == 0)
			{
				session.setAttribute(DEFAULTUSERROLE,RoleEnum.SYSTEM_ADMINISTRATOR);
				
				redirect(controller: "setup", action: "setup")
				return
			}
		}
		
		def c = LoginRecord.createCriteria()
		
		List logins = c.list
		{
			eq("owner", user)
			order("dateCreated","desc")
			maxResults(30)
	   }
		
	   Date startDate = new Date()
	   Integer year = startDate.year + 1900
	   Integer month = startDate.month + 1
	   
	   def quarterOfMonth = dateService.getQuarter(month)
	   def quarterDates = dateService.getDatesOfGivenQuarter(quarterOfMonth, year)
	   
	   def endDate = new GregorianCalendar(year, month-1, 01)
	   
	   def curLogin = logins[0]?.dateCreated
	   def preLogin = logins[2]?.dateCreated
			   
	   def notifications = []
	   notifications = Notification.listUserNotifications(user, "active")
	   
	   for(ServiceQuotation sq : ServiceQuotation.list())
	   {
		   if(sq?.stagingStatus?.name != "active")
		   {
				  sq.stagingStatus = Staging.findByName("active")
			   sq.oldUnits = 0
			   sq.save()
		   }
	   }
	   
	   for(Quotation qu : Quotation.list())
	   {
		   if(qu.requestLevel3 == null || qu.requestLevel3 == "NULL" || qu.requestLevel3 == "null")
		   {
			   qu.requestLevel3 = false
			   qu.save()
		   }
		   
	   }
	   
	   def companyInformation
	   def currency = "Money"
	   if(CompanyInformation.list().size() > 0)
	   {
		   companyInformation = CompanyInformation.list().get(0)
		   if(companyInformation.baseCurrency != null)
				   currency = companyInformation.baseCurrency
		   
	   }
	   
	   List opportunityList = chartService.getServiceTicketRelatedOpportunities()
	   Map serviceVarianceMap = new HashMap()
	   if(opportunityList.size() > 0)
	   {
		   serviceVarianceMap = chartService.calculateServiceVarianceForOpportunity(opportunityList[0])
	   }
	   serviceVarianceMap['opportunityList'] = opportunityList
	   
		Map totaldiscount = [:]
		
		if(currentRole.equals("SYSTEM ADMINISTRATOR"))
		{
			
			def pmList = serviceCatalogService.findPortfolioManagers()
			
			def assignedPortfolioList = chartService.findPortfoliosAssignedByPortfolioManager(pmList)
			
			Map accountStatusByRoleData = chartService.buildChartDataForUserStatusByRole()
			
			Map unassignedExceptionReport = chartService.getUnassignedExceptionReport()
			
			List recentLoginList = recentLoginRecord()
				
			totaldiscount = chartService.countVSOEDiscounting(startDate, dateService.getDate(quarterDates['from']), null)//get accepted quotation discount....
			
			session.setAttribute(DEFAULTUSERROLE,RoleEnum.SYSTEM_ADMINISTRATOR);
			
			if( !previousRole.equalsIgnoreCase(currentRole) ){
				updateRoleNotification(previousRole, currentRole, user);
			}
			render(view: "admin", model: [unassignException: unassignedExceptionReport, serviceVarianceMap: serviceVarianceMap, currency: currency, assignedPortfolios: assignedPortfolioList,  totaldiscount: totaldiscount, notificationList: notifications, accountStatusByRoleData: accountStatusByRoleData, recentLoginList: recentLoginList])

		}
		else if(currentRole.equals("GENERAL MANAGER") || currentRole.equals("SALES PERSON")
			|| currentRole.equals("SALES MANAGER") || currentRole.equals("SALES PRESIDENT"))
		{
			session.setAttribute(DEFAULTUSERROLE, PricewellUtils.getRoleEnum(currentRole));
			
			if(user?.primaryTerritory == null)
			{
				redirect(controller: "userSetup", action: "addPrimaryTerritory")
				return
			}
			
			//opportunityService.checkOpportunities(opportunityService.getUserOppoertunities(user, new FilterCriteria()))
			Map dateMap = dateService.getTimespanForQuota("This quarter")
			
			Map territoryMap =  chartService.getDefaultTerritory()
			Geo defaultTerritory = territoryMap['defaultTerritory']
			Map quarterlyTotalSalesMap = chartService.quarterlyTotalSalesByUser(defaultTerritory)
			
			Map map = chartService.buildSalesQuotesChartData(user, startDate, dateService.getDate(quarterDates['from']), defaultTerritory)
			def pendingDaysMap = chartService.buildChartDataForQuotesPendingDays(defaultTerritory,null,null)
			Map quotaData = [:]
			if(currentRole.equals("SALES PRESIDENT") || currentRole.equals("GENERAL MANAGER") || currentRole.equals("SALES MANAGER") || currentRole.equals("SALES PERSON"))
				{quotaData = opportunityService.getQuotaAssignedVsQuotaAchivement(dateMap, defaultTerritory)}
			
			Map quotaPerPersons = [:]
			if(currentRole.equals("SALES PRESIDENT") || currentRole.equals("GENERAL MANAGER") || currentRole.equals("SALES MANAGER"))
			{
				quotaPerPersons = opportunityService.getQuotaAssignedVsQuotaAchivementPerPersons(dateMap, defaultTerritory)//quotaData['territory'])
			}
			
			Map opportunityFunnelData = chartService.getOpportunityFunnelGraphData(startDate, null, defaultTerritory)//dateService.getDate(quarterDates['from']))
			Map leadFunnelData = chartService.getLeadFunnelGraphData(startDate, null)//dateService.getDate(quarterDates['from']))
			
			totaldiscount = chartService.countVSOEDiscounting(startDate, dateService.getDate(quarterDates['from']), defaultTerritory)//get accepted quotation discount....
			
			if( !previousRole.equalsIgnoreCase(currentRole) ){
				updateRoleNotification(previousRole, currentRole, user);
			}
			
			
			render(view: "sales", model: [defaultTerritory: defaultTerritory, territoryList: territoryMap['territoryList'], leadFunnelData: leadFunnelData, opportunityFunnelData: opportunityFunnelData, currency: currency, quarterlyTotalSalesMap: quarterlyTotalSalesMap, quotaPerPersons: quotaPerPersons, quoteTypesMap: map, pendingDaysMap: pendingDaysMap, notificationList: notifications, totaldiscount: totaldiscount, quotaData: quotaData]);
		}
		else
		{
			Map productManagerEstimatedVeriance = [:]
			def serviceQuoteList = []
			def assignedPortfolio = []
			boolean quote = false
			Map map = [:]
			Map salesTotalUnitsByServiceMap = [:], serviceException = [:], productException = [:]
			Map salesSoldByServicesMap = [:], serviceFunnelData = [:]
			def productsSoldByServiceMap = null;
			def serviceSoldPerPortfolioMap = [:], itCostPerQuotationMap = [:]
			
			Map serviceDesignerEstimatedVeriance = [:]
			if(currentRole.equals("PORTFOLIO MANAGER"))
			{
				productManagerEstimatedVeriance = chartService.findEstimateVarianceForPMs()
				
				productException = serviceCatalogService.getProductExceptionReport()
				serviceException = serviceCatalogService.getServiceExceptionReport()
				salesTotalUnitsByServiceMap = chartService.generateSalesTotalUnitsByServiceMap(startDate, dateService.getDate(quarterDates['from']))
				salesSoldByServicesMap = chartService.generateSalesSoldByServicesMap(startDate, dateService.getDate(quarterDates['from']))
				productsSoldByServiceMap = chartService.generateProductsSoldByServiceMap(startDate, dateService.getDate(quarterDates['from']))
				def territoryList=Geo.list()
				def userPortfolios = serviceCatalogService.findUserPortfolios(user, params)
				if(userPortfolios.size() > 0)
				{
					//userPortfolios = userPortfolios.sort(it.portfolioName)
					serviceSoldPerPortfolioMap = chartService.generateServiceSoldPerPortfolioMap(userPortfolios[0], startDate, dateService.getDate(quarterDates['from']),-1)
					serviceSoldPerPortfolioMap.put("portfolios", userPortfolios)
					serviceSoldPerPortfolioMap.put("portfolio", userPortfolios[0])
					serviceSoldPerPortfolioMap.put("territory",territoryList)
					itCostPerQuotationMap = chartService.generateItCostPerQuotationMap(userPortfolios[0], startDate, dateService.getDate(quarterDates['from']),-1)
					
				}
			}
			
			if(currentRole.equals("PRODUCT MANAGER"))
			{
				assignedPortfolio = serviceCatalogService.productManagerPortfolios(user)
				serviceDesignerEstimatedVeriance = chartService.findEstimateVarianceForSDs()
				serviceFunnelData = chartService.getServiceFunnelGraphData(startDate, null)//dateService.getDate(quarterDates['from']))
			}
			def listForServiceDesigner = []
			//boolean instage = true
			if(currentRole.equals("SERVICE DESIGNER"))
			{
				
				listForServiceDesigner = serviceCatalogService.findUserServicesByStaging(user, ServiceProfileType.DEVELOP)
			}
			
			session.setAttribute(DEFAULTUSERROLE, PricewellUtils.getRoleEnum(currentRole));
			if( !previousRole.equalsIgnoreCase(currentRole)){
				updateRoleNotification(previousRole, currentRole, user);
			}
			render(view: "all",  model: [itCostPerQuotationMap: itCostPerQuotationMap, serviceSoldPerPortfolioMap: serviceSoldPerPortfolioMap, serviceFunnelData: serviceFunnelData, user: user, serviceList: serviceException["serviceList"], productList: productException["productList"], salesTotalUnitsByServiceMap: salesTotalUnitsByServiceMap, salesSoldByServicesMap: salesSoldByServicesMap, quote: quote, totaldiscount: totaldiscount, assignedPortfolio: assignedPortfolio, notificationList: notifications,productManagerEstimatedVeriance: productManagerEstimatedVeriance, serviceDesignerEstimatedVeriance: serviceDesignerEstimatedVeriance, serviceQuoteList: serviceQuoteList, productsSoldByServiceMap: productsSoldByServiceMap, currency: currency, listForServiceDesigner: listForServiceDesigner, serviceInstanceTotal: listForServiceDesigner.size(), title: "My Services In Development"])
		}
	}

	def updateRoleNotification(String previousRole, String role , User updatedUser)
	{
		def note = new Notification()
		note.objectType = "User"
		note.objectId = updatedUser.id
		note.dateCreated = new Date()
		note.active = true
		note.receiverUsers = [updatedUser]
		note.receiverGroups = new ArrayList()
		
		note.message = "Dashboard Role is changed from '"+previousRole+"' to '"+role+"'";
		
		note.save(flush:true)
		return []
	}
}
