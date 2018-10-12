package com.valent.pricewell

import java.text.DateFormat
import org.springframework.context.MessageSource
import org.springframework.web.context.request.RequestContextHolder
import org.springframework.web.context.request.ServletRequestAttributes
import java.text.SimpleDateFormat
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javax.servlet.http.HttpServletRequest
import javax.xml.datatype.XMLGregorianCalendar
import java.net.MalformedURLException;
import org.apache.shiro.SecurityUtils

import com.valent.pricewell.cw15.*

import cw.ContactFindResult
import cw15.*


class CwimportService {

	static transactional = true

	def connectwiseExporterService, connectwiseImporterService, connectwiseCatalogService, dateService, sendMailService, fieldMappingService, salesCatalogService
	OpportunityImportTimer newImportTimer
	
	public Map checkConnectwiseCredentials(String siteUrl, ApiCredentials credentials)
	{
		Map resultMap = connectwiseExporterService.checkConnectwiseCredentials(siteUrl, credentials)
		return resultMap
	}
	
	public Map checkConnectwiseApiPermissions(String siteUrl, ApiCredentials credentials)
	{
		Map resultMap = connectwiseExporterService.checkConnectwiseApiPermissions(siteUrl, credentials)
		return resultMap
	}
	
	public void getConnectwiseOpportunity(String siteUrl, ApiCredentials credentials, Map dateMap)
	{
		XMLGregorianCalendar startDate = dateMap["startDate"]
		XMLGregorianCalendar endDate = dateMap["endDate"]
		println "ExpectedCloseDate >="+startDate+" AND ExpectedCloseDate < "+endDate
		connectwiseExporterService.getConnectwiseOpportunity(siteUrl, credentials, dateMap)
		//return resultMap
	}
	
	public void displayMessage(MessageSource messageSource)
	{
		Object[] args = new Object[10]
		args[0] = "My Test Op"
		String subject = messageSource.getMessage("notification.opportunityImportFromCWSuccess", args, Locale.getDefault())
		println subject
		
	}
	
	public void importOpportunities(OpportunityImportTimer importTimer)
	{
		newImportTimer = new OpportunityImportTimer(importTimer.cwimportService, importTimer.grailsApplication, importTimer.messageSource)
		Object g = importTimer.grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')
		String siteUrl = importTimer.grailsApplication.config.grails.serverURL
		MessageSource messageSource = importTimer.messageSource
		importTimer.push()
		
		Map importMap = new HashMap()
		Date startDate = null, endDate = null
		UpdateRecord lastUpdateRecord = connectwiseCatalogService.getLastUpdateDateOfConnectwiseImportOpportunity()
		
		importMap['endDate'] = new Date()
		startDate = lastUpdateRecord?.lastUpdateDate!=null?lastUpdateRecord?.lastUpdateDate-1:null
		importMap['startDate'] = startDate
		
		//HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		//println request.siteUrl
		
		if(connectwiseCatalogService.isConnectwiseCredentialsAvailable() && startDate != null)
		{
			try{
				Map responseMap = importOpportunities(importMap, "regulaInterval")
				saveOpportunityImportResponse(messageSource, siteUrl, responseMap, importMap['startDate']+1, importMap['endDate'] )	//g		
			}
			catch(Exception e)
			{
				e.printStackTrace(System.out);
				String failureMessage = connectwiseCatalogService.generateFailureMessage(e.getMessage())
				println failureMessage
			}
		}
		
		newImportTimer.resume()
	}
	
	public void saveOpportunityImportResponse(MessageSource messageSource, String siteUrl, Map responseMap, Date startDate, Date endDate)
	{
		List importedOpportunities = responseMap['imported'], existedOpportunities = responseMap['existed']
		Map opportunityTerritoryMap = responseMap['opportunityTerritoryMap']
		def countUnavailableTerritory = responseMap['countUnavailableTerritory']
		def comment = ""
		if(importedOpportunities?.size() > 0)
		{
			//Opportunity firstOpportunity = importedOpportunities.first()//Here first means last created in connectwise
			//connectwiseCatalogService.saveTimestampForConnectwiseImportOpportunity(importMap['startDate'], importMap['endDate'])
			comment = "Total number of opportunity imported : "+importedOpportunities?.size()
			connectwiseCatalogService.saveUpdateRecordForConnectwiseImportOpportunity(startDate, endDate, comment)
		}
		/*else
		{
			comment = "There is no more opportunity to import."
		}*/
		
		def totalImported = 0
		for(Opportunity opp : importedOpportunities)
		{
			def user = User.findByUsername("admin")//get(new Long(SecurityUtils.subject.principal))
			def map = sendCWToPricewellOpportunityImportNotification(messageSource, opp, user)//new NotificationGenerator(g).sendCWToPricewellOpportunityImportNotification(opp, user);
			sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], siteUrl+"/opportunity/show/"+opp.id)
			totalImported++
		}
	}
	
	public Map sendCWToPricewellOpportunityImportNotification(MessageSource messageSource, Opportunity opportunity, User user)
	{
		def note = new Notification()
		note.objectType = "Opportunity"
		note.objectId = opportunity.id
		note.dateCreated = new Date()
		note.active = true
		note.receiverUsers = [user]
		note.receiverGroups = new ArrayList()
		//note.message = "You have been assigned as  for  ${serviceProfile}, so define service deliverables.";
		
		Object[] args = new Object[10]
		args[0] = opportunity?.name
		
		note.message = messageSource.getMessage("notification.opportunityImportFromCWSuccess", args, Locale.getDefault())//g.message(code: "notification.opportunityImportFromCWSuccess", args: ["${opportunity.name}"]);
		String subject = messageSource.getMessage("notification.opportunityImportFromCWSuccess.email.subject", new Object[0], Locale.getDefault())//g.message(code: "notification.opportunityImportFromCWSuccess.email.subject");
		String emailMessage = messageSource.getMessage("notification.opportunityImportFromCWSuccess.email.message", args, Locale.getDefault())//g.message(code: "notification.opportunityImportFromCWSuccess.email.message", args: ["${opportunity.name}"]);
		
		
		note.save(flush:true)
		if(note.receiverUsers.size() > 0)
		{
			return ["message": emailMessage, "subject": subject, "receiverList": note.receiverUsers]
			//sendEmailNotification(note.message, subject, note.receiverUsers)
		}
		return []
	}
	
	public Map importOpportunities(Map importMap, String sourceFrom) 
	{
		
		List imported = new ArrayList(), existed = new ArrayList(), opportunityList = new ArrayList(), nonExistTerritoryList = new ArrayList(), opportunityIds = new ArrayList()
		def countUnavailableTerritory = 0
		Map forecastMap = new HashMap(), dataMap = new HashMap(), opportunityTerritoryMap = new HashMap()
		//Input: Credentials, URL, Service tags, allowed stages, allowed status, date range
		//By default allowed stages=["1.Prospect"] and allowed status=["Open"], Service tags = ["Service"], date range=All
		//String url = "https://test.connectwise.com/v4_6_release"
		User user = null
		if(sourceFrom == "regulaInterval")
		{
			user = User.findByUsername("admin")
		}
		else
		{
			user = User.get(new Long(SecurityUtils.subject.principal))	
		}
		
		
		def credentialsMap = getCredentials()
		ApiCredentials credentials = credentialsMap["credentials"]
		String baseUrl = credentialsMap["siteUrl"]
		
		//List<String> allowedProductTypes = importMap['allowedProductTypes']
		
		List<String> allowedEstimateTypes = ['S']//S : for service //importMap['allowedEstimateTypes']
		
		/*allowedTypes.add("Service")
		allowedTypes.add("Fixed")*/
		/*List<String> allowedOpportunityStatus = importMap['allowedOpportunityStatus']//new ArrayList()
		List<String> allowedForecastStatus = importMap['allowedForecastStatus']
		//allowedStatus.add("Open")
		List<String> allowedStages = importMap['allowedStages']
		/*allowedStages.add("Quote")
		allowedStages.add("Prospect")*/
		
		//CWProductExport productExport = new CWProductExport(baseUrl)
		//List<Integer> productIds = connectwiseExporterService.getOpportunityServiceIds(baseUrl, credentials, allowedProductTypes) //productExport.getOpportunityServiceIds(credentials, allowedProductTypes)
		//println productIds
		
		//forecastMap['productIds'] = productIds; 
		forecastMap['allowedEstimateTypes'] = allowedEstimateTypes; //forecastMap['allowedForecastStatus'] = allowedForecastStatus; 
		
		//dataMap['allowedStatus'] = allowedOpportunityStatus; dataMap['allowedStages'] = allowedStages; 
		dataMap['credentials'] = credentials
		dataMap['startDate'] = importMap["startDate"]//startDate
		dataMap['endDate'] = importMap["endDate"]//endDate
		
		CWToNativeMapper mapper = new CWToNativeMapper();
		CWCompanyToAccountMapper accountMapper = new CWCompanyToAccountMapper();
		//CWContactToContactMapper contactMapper = new CWContactToContactMapper();
		
		/*CWExporter exporter = new CWExporter(baseUrl);
		CWCompany companyExporter = new CWCompany(baseUrl)
		CWContact contactExporter = new CWContact(baseUrl)*/
		//println baseUrl
		//println dataMap['credentials']
		//println dataMap['startDate']
		Map opportunityExporterMap = connectwiseExporterService.exportOpportunities(baseUrl, dataMap['credentials'], dataMap['startDate'])//exporter.exportOpportunities(dataMap);
		
		List<OpportunityListItem> items = opportunityExporterMap["opportunityListItem"]
		log.info "[Log Time: ${new Date()}] - Total ${items.size()} opportunities that are found to be updated from Connectwise since last update in Valent Software."
		log.info "[Log Time: ${new Date()}] - Importing all updated opportunities from Connectwise."
		
		Map<Integer, cw15.Opportunity> opportunityMap = opportunityExporterMap["opportunityMap"]
		//println items
		for(OpportunityListItem opLItem: items)
		{
			
			log.info "[Log Time: ${new Date()}] ----------------------------- Importing Opportunity - ${opLItem.getOpportunityName()} ---------------------------------------"
			boolean isOpportunityExist = connectwiseCatalogService.checkOpportunityExist(opLItem.id.toString())
			boolean isValid = connectwiseCatalogService.checkOpportunityDate(importMap, opLItem), territoryAvailable = false
			double forecastRevenue = connectwiseCatalogService.getForecastRevenue(opportunityMap[opLItem.getId()], forecastMap)
			
			if(!isOpportunityExist)
			{
				if(isValid)
				{
					if(forecastRevenue > 0)
					{
						Account account = null
						Geo geo = null
						
						if(opLItem?.companyName != "" && opLItem?.companyName != null)
						{
							//println opLItem?.companyName
							log.info "[Log Time: ${new Date()}] --------- Getting Account : ${opLItem.getCompanyName()} details from Connectwise -------------"
							CompanyFindResult company = connectwiseExporterService.getCompany(baseUrl, credentials, opLItem?.companyName) //companyExporter.getCompany(credentials, opLItem)
							if(company != null)
							{
								log.info "[Log Time: ${new Date()}] - Importing account details in Valent Software."
								boolean isAccountExist = connectwiseCatalogService.checkAccountExist(company.getCompanyID().toString())
								if(!isAccountExist)
								{
									//--------------Add Account Data----------------------------------------------
										account = accountMapper.map(company, Account.class)
										account.billingAddress = connectwiseCatalogService.getAccountAddress(company)
										account = connectwiseCatalogService.putAccountData(account)
										account.externalId = company.getCompanyID().toString()
										
										if(!account.hasErrors() && account.save())
										{
											log.info "[Log Time: ${new Date()}] - Account saved successfully."
										}
										else
										{
											log.info "[Log Time: ${new Date()}] - Saving Account create errors."
											log.error "Errors : " + account.errors.allErrors
											
											account.errors.allErrors.each {
												println it
											}
										}
										
									//--------------------------------------------------------------------------------
									
									List<ContactFindResult> companyContacts = new ArrayList<ContactFindResult>()
									
									log.info "[Log Time: ${new Date()}] - Getting Contact list of account : ${opLItem.getCompanyName()} from Connectwise."
									companyContacts = connectwiseExporterService.getContactList(baseUrl, credentials, company.companyName) //contactExporter.getContactList(credentials, company.companyName)
									
									log.info "[Log Time: ${new Date()}] - Found ${companyContacts.size()} Contacts and adding then into Valent Software."
									connectwiseCatalogService.addContactsInAccount(account, companyContacts)
									
								}
								else
								{
									log.info "[Log Time: ${new Date()}] - Account details already exist in Valent Software."
									account = (Account) Account.findByExternalId(company.getCompanyID().toString())
								}
								
								
								//----------check for territory is available or not-----------------------------------
								//println "territory : "+ opLItem.type//company.territory
								
								log.info "[Log Time: ${new Date()}] - Find Connectwise territory ${opLItem.getType()} or it mapping in Valent Software.------------"
								
								if(opLItem?.getType() != null && opLItem?.getType() != "") //company.territory != null && company.territory != "")
								{
									
									if(connectwiseCatalogService.isTerritoryAvailable(opLItem.type))//company.territory))
									{
										log.info "[Log Time: ${new Date()}] - Territory is available in Valent Software."
										geo = connectwiseCatalogService.getTerritory(opLItem.type)//company.territory)
										territoryAvailable = true
									}
									else if(fieldMappingService.isMappingAvailable(opLItem.type.toString(), FieldMapping.MappingType.TERRITORY))
									{
										String territory =  fieldMappingService.getFieldMappingValue(opLItem.type.toString(), FieldMapping.MappingType.TERRITORY)
										geo = (Geo) Geo.findByName(territory)
										territoryAvailable = true
										log.info "[Log Time: ${new Date()}] - Territory mapping is available in Valent Software mapped with ${territory}"
									}
									else
									{
										log.info "[Log Time: ${new Date()}] - Territory or its mapping is not available in Valent Software."
										println "make available false"
										territoryAvailable = false
									}
								}
								else log.info "[Log Time: ${new Date()}] - Connectwise opportunity type is not available."
								
							}
							
							log.info "[Log Time: ${new Date()}] - Adding Opportunity details in Valent Software."
							
							//--------------Add Opportunity Data----------------------------------------------
								Opportunity opportunity = mapper.map(opLItem, Opportunity.class);
								opportunity.createdBy = opportunity.modifiedBy = user;
								opportunity.externalId = opLItem.id.toString()
								opportunity.amount = forecastRevenue//getForecastRevenue(opportunityMap[opLItem.getId()], forecastMap)
								opportunity.account = account
								opportunity.externalSource = "connectwiseImport"
								opportunity.geo = geo
								log.info "[Log Time: ${new Date()}] - Territory added in opportunity with name:  ${opportunity?.geo?.getName()}"
								
								if(opportunity?.geo != null)
								{
									User assignedUser = salesCatalogService.getSalesUserOfGeo(geo)
									log.info "[Log Time: ${new Date()}] - Found sales user of territory ${geo?.getName()} is ${assignedUser}"
									opportunity.assignTo = assignedUser
								}
								else
								{
									log.info "[Log Time: ${new Date()}] - Territory is not found so this opportunity is assigned to login user"
									opportunity.assignTo = user
								}
								
								log.info "[Log Time: ${new Date()}] - Opportunity is assigned to ${opportunity?.assignTo}"
								
								Contact primaryContact = (Contact) Contact.findByExternalId(opLItem?.contactId)
								if(primaryContact != null)
								{
									opportunity.primaryContact = primaryContact
								}
								//println "Opportunity Contact Id : "+opLItem.contactId
								if(!opportunity.hasErrors() && opportunity.save())
								{
									log.info "[Log Time: ${new Date()}] - Opportunity saved successfully."
									imported.add(opportunity)
									if(!territoryAvailable)
									{
										opportunityList.add(opportunity)
										opportunityIds.add(opportunity?.id)
										nonExistTerritoryList.add((opLItem?.type != "" && opLItem?.type != null) ? opLItem?.type : "No Territory Specified")//company?.territory)
										countUnavailableTerritory++
									}
								}
								else
								{
									log.info "[Log Time: ${new Date()}] - Saving Opportunity create errors."
									log.error "Errors : " + opportunity.errors.allErrors
									
									opportunity.errors.allErrors.each {
										println it
									}
									
								}
								
							//--------------------------------------------------------------------------------
							//printOpportunityDetails(opportunity)
							/*printAccountDetails(account)*/
							
							//println opportunity.errors
						}
					}
					else log.info "[Log Time: ${new Date()}] - Opportunity's forecast revenue is not > 0, so can not import it"
					
				}
				else log.info "[Log Time: ${new Date()}] - Opportunity is not updated between start and end valid date, So import is not possible"
			}
			else
			{
				log.info "[Log Time: ${new Date()}] - Opportunity already exist"
			}
			
			if(isOpportunityExist && isValid)
			{
				Opportunity op = Opportunity.findByExternalId(opLItem.id) 
				existed.add(op)
				
				if(op.amount != forecastRevenue)
				{
					op.amount = forecastRevenue
					op.save()
					
					log.info "[Log Time: ${new Date()}] - Updated Opportunity forecasted value."
				}
			}
			
		}
		
		opportunityTerritoryMap.put("opportunityList", opportunityList)
		opportunityTerritoryMap.put("opportunityIds", opportunityIds)
		opportunityTerritoryMap.put("territoryList", nonExistTerritoryList)
		println "count : "+countUnavailableTerritory
		Map responseMap = new HashMap()
		responseMap.put("imported", imported)
		responseMap.put("existed", existed)
		responseMap.put('opportunityTerritoryMap', opportunityTerritoryMap)
		responseMap.put("countUnavailableTerritory", countUnavailableTerritory)

		return responseMap
	}
	
	public String getTerritoryOfImportedOpportunity(Opportunity opportunity)
	{
		def credentialsMap = getCredentials()
		ApiCredentials credentials = credentialsMap["credentials"]
		String baseUrl = credentialsMap["siteUrl"]
		cw15.OpportunityListItem opportunityLItem = connectwiseExporterService.getOpportunityFormExternalId(baseUrl, credentials, opportunity?.externalId)
		/*cw15.Opportunity opportunityCW = connectwiseExporterService.getOpportunityFormExternalId(baseUrl, credentials, opportunity?.externalId)
		CompanyFindResult company = connectwiseExporterService.getCompany(baseUrl, credentials, opportunityCW?.company?.companyName)*/
		return ((opportunityLItem?.type != "" && opportunityLItem?.type != null) ? opportunityLItem?.type : "No Territory Specified")//company.territory
	}
	
	public Map getCredentials()
	{
		ConnectwiseCredentials cCredentials = null
		for(ConnectwiseCredentials cc : ConnectwiseCredentials.list())
		{
			cCredentials = cc
			break;
		}
		ApiCredentials credentials = new ApiCredentials();
		credentials.setCompanyId(cCredentials.companyId);
		credentials.setIntegratorLoginId(cCredentials.userId);
		credentials.setIntegratorPassword(cCredentials.password);
		
		def credentialsMap = [:]
		credentialsMap["credentials"] = credentials
		credentialsMap["siteUrl"] = cCredentials.siteUrl
		
		return credentialsMap
	}
	
	public ReportingApiSoap getReportingApiSoap(String siteUrl)
	{
		String url = siteUrl + "/v4_6_release/apis/1.5/ReportingApi.asmx?wsdl"
		ReportingApi soapApi = new cw15.ReportingApi(new URL(url));
		ReportingApiSoap reportingSoap = soapApi.getReportingApiSoap()
		
		return reportingSoap
	}
	
	public Map getTicketConfiguration()
	{
		def credentialsMap = getCredentials()
		ApiCredentials credentials = credentialsMap["credentials"]
		def siteUrl = credentialsMap["siteUrl"]
		
		ReportingApiSoap reportingSoap = getReportingApiSoap(siteUrl)
		
		Map configurationMap = [:]
		def serviceBoard = connectwiseCatalogService.getFieldValue(reportingSoap.runReportQuery(credentials, "ServiceBoard", "", "", 100, 0), "Board_Name")
		
		def condition = serviceBoard.size() > 0 ? "Board_Name LIKE '"+serviceBoard[0]+"'" : ""
		def serviceStatus = connectwiseCatalogService.getFieldValue(reportingSoap.runReportQuery(credentials, "ServiceStatus", condition, "", 100, 0), "Service_Status_Desc")
		def serviceType = connectwiseCatalogService.getFieldValue(reportingSoap.runReportQuery(credentials, "ServiceType", condition, "", 100, 0), "ServiceType")//board_name required
		
		def serviceSource = connectwiseCatalogService.getFieldValue(reportingSoap.runReportQuery(credentials, "Service_Source", "", "", 100, 0), "Service_Source_Desc")
		def priority = connectwiseCatalogService.getFieldValue(reportingSoap.runReportQuery(credentials, "ServicePriority", "", "", 100, 0), "Service_Priority_Desc")
		
		configurationMap['serviceBoard'] = serviceBoard
		configurationMap['serviceStatus'] = serviceStatus
		configurationMap['serviceType'] = serviceType
		configurationMap['serviceSource'] = serviceSource
		configurationMap['priority'] = priority
		
		return configurationMap
	}
	
	public Map getBoardRelatedConfiguration(String board)
	{
		def credentialsMap = getCredentials()
		ApiCredentials credentials = credentialsMap["credentials"]
		def siteUrl = credentialsMap["siteUrl"]
		
		ReportingApiSoap reportingSoap = getReportingApiSoap(siteUrl)
		Map configurationMap = [:]
		
		def condition = board!=null ? "Board_Name LIKE '"+board+"'" : ""
		def serviceStatus = connectwiseCatalogService.getFieldValue(reportingSoap.runReportQuery(credentials, "ServiceStatus", condition, "", 100, 0), "Service_Status_Desc")
		def serviceType = connectwiseCatalogService.getFieldValue(reportingSoap.runReportQuery(credentials, "ServiceType", condition, "", 100, 0), "ServiceType")//board_name required
		
		configurationMap['serviceStatus'] = serviceStatus
		configurationMap['serviceType'] = serviceType
		
		return configurationMap
	}
	
	public void showReportingApiFields(Opportunity opportunity)
	{
		def credentialsMap = getCredentials()
		ApiCredentials credentials = credentialsMap["credentials"]
		def siteUrl = credentialsMap["siteUrl"]
		
		ReportingApiSoap reportingSoap = getReportingApiSoap(siteUrl)
		
		def serviceSource = connectwiseCatalogService.printFieldValue(reportingSoap.runReportQuery(credentials, "Service_Source", "Service_Source_Desc LIKE 'Phone'", "", 100, 0), "Service_Source_Desc")
		def location = connectwiseCatalogService.printFieldValue(reportingSoap.runReportQuery(credentials, "OwnerLevel", "", "", 100, 0), "Location")
		//printFieldValue(reportingSoap.runReportQuery(credentials, "ServiceItem", "", "", 100, 0), "Service_Source_Desc")
		//printFieldValue(reportingSoap.runReportQuery(credentials, "ServiceSubType", "", "", 100, 0), "Service_Source_Desc")
		def serviceType = connectwiseCatalogService.printFieldValue(reportingSoap.runReportQuery(credentials, "ServiceType", "ServiceType LIKE 'Server' AND Board_Name LIKE 'Professional Services'", "", 100, 0), "ServiceType")//board_name required
		def priority = connectwiseCatalogService.printFieldValue(reportingSoap.runReportQuery(credentials, "ServicePriority", "Service_Priority_Desc LIKE 'Priority 3%'", "", 100, 0), "Service_Priority_Desc")
		def serviceBoard = connectwiseCatalogService.printFieldValue(reportingSoap.runReportQuery(credentials, "ServiceBoard", "Board_Name LIKE 'Professional Services'", "", 100, 0), "Board_Name")
		def serviceStatus = connectwiseCatalogService.printFieldValue(reportingSoap.runReportQuery(credentials, "ServiceStatus", "Service_Status_Desc LIKE 'New%' AND Board_Name LIKE 'Professional Services'", "", 100, 0), "Service_Status_Desc")
		
		//ArrayOfResultRow arrayResultRow = reportingSoap.runReportQuery(credentials, "Service_Source", "", "", 100, 0)
				
		//reportingSoap.runReportQuery(credentials, "ServiceType", "Board_Name LIKE 'Professional Services'", "", 100, 0)
		//reportingSoap.runReportQuery(credentials, "ServiceStatus", "Service_Status_Desc LIKE 'New%' AND Board_Name LIKE 'Professional Services'", "", 100, 0)
		
		Account accountInstance = Account.get(opportunity.account.id)
		Contact contactInstance = Contact.get(opportunity.primaryContact.id)
		
		ServiceTicket ticket = new ServiceTicket()
		ticket.summary = "My test ticket"
		ticket.board = "Professional Services"
		//ticket.status = NsnStatusId.fromValue("N")
		ticket.statusName = serviceStatus.size() > 0 ? serviceStatus[0] : ""
		ticket.priority = priority.size() > 0 ? priority[0] : "Priority 3 - Normal Response"
		ticket.serviceType = serviceType.size() > 0 ? serviceType[0] : ""
		ticket.addressLine1 = contactInstance.billingAddress.billAddressLine1
		ticket.addressLine2 = contactInstance.billingAddress.billAddressLine2
		ticket.city = contactInstance.billingAddress.billCity
		ticket.stateId = contactInstance.billingAddress.billState
		ticket.zip = contactInstance.billingAddress.billPostalcode
		ticket.contactName = contactInstance.firstname + " " + contactInstance.lastname
		ticket.contactEmailAddress = contactInstance.email
		ticket.contactPhoneNumber = contactInstance.phone
		ticket.source = serviceSource.size() > 0 ? serviceSource[0]: "Phone"
		ticket.opportunityId = opportunity.externalId.toInteger()
		ticket.budgetHours = new BigDecimal(10)
		
		def dataMap = [:]
		dataMap['credentials'] = credentials
		dataMap['serviceTicket'] = ticket
		dataMap['companyId'] = accountInstance.externalId
		connectwiseImporterService.importServiceTicket("https://test.connectwise.com", dataMap)
		
	}
	
	public int createServiceTicketForQuotation(Quotation quotation, Map paramsMap)
	{
		def credentialsMap = getCredentials()
		ApiCredentials credentials = credentialsMap["credentials"]
		def siteUrl = credentialsMap["siteUrl"]
		
		Opportunity opportunity = Opportunity.get(quotation.opportunity.id)
		Account accountInstance = Account.get(opportunity.account.id)
		Contact contactInstance = Contact.get(opportunity.primaryContact.id) 
		int count = 0
		def user = User.get(new Long(SecurityUtils.subject.principal))
		for(ServiceQuotation sq : quotation.serviceQuotations)
		{
			ServiceProfile sp = ServiceProfile.get(sq.profile.id)
			for(ServiceDeliverable sd : sp.customerDeliverables)
			{
				for(ServiceActivity sa : sd.serviceActivities)
				{
					for(ActivityRoleTime art : sa.rolesEstimatedTime)
					{
						ServiceTicket ticket = new ServiceTicket()
						def summary = "Quote #"+quotation.id+" : Activity "+sa.name+" for Role "+art.role.name
						ticket.summary = summary
						ticket.problemDescription = "<@@ Import Information: DO NOT REMOVE {Quote : #"+quotation.id+", Service Name: "+sp.service.serviceName+"} @@>"
						
						ticket.board = paramsMap['board']
						ticket.statusName = paramsMap['statusName']
						ticket.priority = paramsMap['priority']
						ticket.serviceType = paramsMap['serviceType']
						ticket.source = paramsMap['source']
						
						ticket = connectwiseCatalogService.addContactDetail(ticket, contactInstance)
						ticket.opportunityId = opportunity.externalId.toInteger()
						ticket.ticketNumber = 0
						BigDecimal budgetHours = getActivityRoleTimeTotalBudgetHours(sq, art)//new BigDecimal(art.estimatedTimeInHoursFlat + art.estimatedTimeInHoursPerBaseUnits)
						ticket.budgetHours = budgetHours
						
						def dataMap = [:]
						dataMap['credentials'] = credentials
						dataMap['serviceTicket'] = ticket
						dataMap['companyId'] = accountInstance.externalId
						try
						{
							ServiceTicket sticket = connectwiseImporterService.importServiceTicket(siteUrl, dataMap)
							ServiceQuotationTicket sqTicket = connectwiseCatalogService.createTicket(sq, sa, art.role, summary, budgetHours, user)
							sqTicket.ticketId = sticket.ticketNumber 
							sqTicket.save()
							count++
						}
						catch(Exception e)
						{
							println "something wrong"
							println e.getMessage()
							e.printStackTrace()
						}
						
					}
				}
			}
		}
		return count
	}
	
	public void myDo()
	{
		def credentialsMap = getCredentials()
		ApiCredentials credentials = credentialsMap["credentials"]
		String baseUrl = credentialsMap["siteUrl"]
		
		String url = baseUrl + "/v4_6_release/apis/1.5/ServiceTicketApi.asmx?wsdl";
		
		ServiceTicketApi soapApi = new cw15.ServiceTicketApi(new URL(url));
		ServiceTicketApiSoap sTicketSoap = soapApi.getServiceTicketApiSoap()
			
		Map transferMap = [:]
		transferMap['credentials'] = credentials
		transferMap['type'] = "all"
		
		Map serviceTicketExporterMap = connectwiseExporterService.exportServiceTickets(baseUrl, transferMap)
		
		for(Ticket ticket : serviceTicketExporterMap['ticketList'])
		{
			
		
		
				ServiceTicket serviceTicket = sTicketSoap.getServiceTicket(credentials, ticket.srServiceRecID)
				if(serviceTicket)
				{
					println "ticketId : "+ticket.srServiceRecID+" sTicket number : "+serviceTicket.ticketNumber
				}				
			
		}
	}
	
	public void updateReferenceTicektWithId()
	{
		def credentialsMap = getCredentials()
		ApiCredentials credentials = credentialsMap["credentials"]
		String baseUrl = credentialsMap["siteUrl"]
		
		Map transferMap = [:]
		transferMap['credentials'] = credentials
		transferMap['type'] = "all"
		
		Map serviceTicketExporterMap = connectwiseExporterService.exportServiceTickets(baseUrl, transferMap)
		println serviceTicketExporterMap['ticketList'].size()
		
		for(Ticket ticket : serviceTicketExporterMap['ticketList'])
		{
			println "ticketId : "+ticket.srServiceRecID+" Summary : "+ticket.summary
			connectwiseCatalogService.updateReferenceTicketWithCWTicketId(ticket.srServiceRecID, ticket.summary)
		}
	}
	
	public void findServiceTickets(String type)
	{
		def credentialsMap = getCredentials()
		ApiCredentials credentials = credentialsMap["credentials"]
		String baseUrl = credentialsMap["siteUrl"]
		
		Map transferMap = [:]
		transferMap['credentials'] = credentials
		transferMap['type'] = type
		
		Map serviceTicketTimeStamp = connectwiseCatalogService.getTimestampForServiceTicket()
		Date fromDate = serviceTicketTimeStamp['toDate']; 	Date toDate = new Date()
		transferMap['fromDate'] = fromDate; 				transferMap['toDate'] = toDate
		
		Map serviceTicketExporterMap = connectwiseExporterService.exportServiceTickets(baseUrl, transferMap)
		
		List filteredTickets = filterTicketsByTime(serviceTicketExporterMap['ticketList'], fromDate, toDate)
		updateActualHoursOfTickets(filteredTickets)
		connectwiseCatalogService.saveTimestampForServiceTicket(fromDate, toDate)//resultMap['toDate'])
	}
	
	public List filterTicketsByTime(List ticketList, Date fromDate, Date toDate)
	{
		if(fromDate != null)
			{fromDate = dateService.setDate(fromDate)}
		Date lastModifiedDate = null
		List filteredList = new ArrayList()
		
		for(Ticket ticket : ticketList)
		{
			if(connectwiseCatalogService.checkServiceTicketDate(fromDate, toDate, ticket))
			{
				println "Summary : "+ticket.summary+", ClosedFlag : "+ticket.closedFlag
				println "---------------------------------------------------"
				filteredList.add(ticket)
				
			}
				
		}
		
		return filteredList
	}
	
	public void updateActualHoursOfTickets(List ticketList)
	{
		for(Ticket ticket : ticketList)
		{
			connectwiseCatalogService.updateServiceQuotationTicket(ticket)
			//println ticket.actualHours
		}
		
	}
	
	public void createServiceQuotationTicket(Quotation quotation, User user)//for pricewell
	{
		for(ServiceQuotation sq : quotation.serviceQuotations)
		{
			if(sq?.serviceQuotationTickets?.size() == 0)
			{
				ServiceProfile sp = ServiceProfile.get(sq.profile.id)
				for(ServiceDeliverable sd : sp.customerDeliverables)
				{
					for(ServiceActivity sa : sd.serviceActivities)
					{
						for(ActivityRoleTime art : sa.rolesEstimatedTime)
						{
							String summary = "Quote #"+quotation.id+" : Activity "+sa.name+" for Role "+art.role.name
							BigDecimal totalHours = getActivityRoleTimeTotalBudgetHours(sq, art)
							connectwiseCatalogService.createTicket(sq, sa, art.role, summary, totalHours, user)
						}
					}
				}
			}
			
		}
	}
	
	public void addTotalBudgetHoursAsPerQuotationUnits(Quotation quotation)
	{
		Opportunity opportunity = Opportunity.get(quotation.opportunity.id)
		Account accountInstance = Account.get(opportunity.account.id)
		
		for(ServiceQuotation sq : quotation.serviceQuotations)
		{
			ServiceProfile sp = ServiceProfile.get(sq.profile.id)
			for(ServiceDeliverable sd : sp.customerDeliverables)
			{
				for(ServiceActivity sa : sd.serviceActivities)
				{
					for(ActivityRoleTime art : sa.rolesEstimatedTime)
					{
						String summary = "Quote #"+quotation.id+" : Activity "+sa.name+" for Role "+art.role.name
						ServiceQuotationTicket sqTicket = ServiceQuotationTicket.findBySummary(summary)
						if(sqTicket && sqTicket?.ticketId!=null){
							//BigDecimal totalHours = getActivityRoleTimeTotalBudgetHours(sq, art)
							def companyId = accountInstance.externalId
							updateServiceTicket(sqTicket?.ticketId, sqTicket?.budgetHours, companyId)//(summary, totalHours, companyId)
						}
						
					}
				}
			}
		}
	}
	
	public BigDecimal getActivityRoleTimeTotalBudgetHours(ServiceQuotation sq, ActivityRoleTime art)
	{
		CorrectionInActivityRoleTime activityRoleTimeCorrection = null
		for(CorrectionInActivityRoleTime roleTimeCorrection : sq?.correctionsInRoleTime)
		{
			if(roleTimeCorrection?.serviceActivity?.id == art?.serviceActivity?.id && roleTimeCorrection?.role?.id == art?.role?.id)
			{
				activityRoleTimeCorrection = roleTimeCorrection
			}
		}
		
		BigDecimal totalHours = new BigDecimal(0)
		
		if(activityRoleTimeCorrection != null)
		{
			totalHours = activityRoleTimeCorrection?.originalHours + activityRoleTimeCorrection?.extraHours
		}
		else
		{
			totalHours = art.countTotalHoursForServiceQuotationUnits(sq.totalUnits)
		}
		return totalHours
	}
	
	public void updateServiceTicket(Integer ticketId, BigDecimal budgetHours, def companyId)//(String summary, BigDecimal totalHours, def companyId)
	{
		def credentialsMap = getCredentials()
		ApiCredentials credentials = credentialsMap["credentials"]
		String baseUrl = credentialsMap["siteUrl"]
		
		Map transferMap = [:]
		transferMap['credentials'] = credentials
		transferMap['ticketId'] = ticketId
		transferMap['budgetHours'] = budgetHours
		transferMap['companyId'] = companyId
		
		connectwiseExporterService.updateServiceTicketWithTotalBudgetHours(baseUrl, transferMap)
	}
}
