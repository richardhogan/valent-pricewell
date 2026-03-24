import grails.plugins.nimble.core.Role
import java.awt.image.BufferedImage
import javax.imageio.ImageIO;
import java.io.File;
import java.util.List;
import java.util.TimerTask;
import java.util.Timer;
import javax.imageio.stream.ImageInputStream
import javax.imageio.stream.ImageOutputStream
import jakarta.servlet.http.HttpSession

import grails.util.GrailsUtil
import org.springframework.context.ApplicationContext
import org.springframework.context.MessageSource
import grails.core.GrailsApplication
import grails.util.Holders

import com.valent.pricewell.*
import com.valent.pricewell.ServiceProfile.ServiceProfileType
import com.valent.pricewell.Staging.AuthorizedScope
import com.valent.pricewell.cw15.*


class BootStrap {

	def bootstrapProcessService
	def userManagementService
	def springSecurityService
	def phoneNumberService
	def serviceCatalogService
	def opportunityService
	def sendMailService, fileUploadService, salesCatalogService, cwimportService, serviceStagingService, connectwiseCatalogService, sfimportService
	SendMailTimer timer;
	OpportunityExpireTimer opportunityExpTimer
	OpportunityImportTimer opportunityImportTimer
	SalesforceOpportunityImportTimer salesforceOpportunityImportTimer

	boolean isDemo = false;

	def init = { servletContext -> 
		//addListener(MyHttpSessionListener)

		HttpRequestMetaClassEnhancer.enhanceRequest()

		ApplicationContext applicationContext = Holders.applicationContext
		GrailsApplication  grailsApplication = (GrailsApplication) applicationContext.getBean("grailsApplication")
		MessageSource messageSource = applicationContext.getBean(MessageSource.class);
		
		/*def g = grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')
		println g
		String subject = g.message(code: "notification.opportunityImportFromCWSuccess.email.subject");*/
		//println grailsApplication.config.grails.serverURL
		
		//HttpSession se = request.getSession(true)
		//MyHttpSessionListener//.sessionCreated(HttpSessionEvent(se))
		
		// Grails 7: BootStrap runs without an active Hibernate session/transaction.
		// Wrap all GORM operations in withTransaction so saves and flushes work.
		// startOpportunityImportTimer is declared here so it remains in scope
		// after the withTransaction block closes.
		boolean startOpportunityImportTimer = false
		Role.withTransaction {
		//Temporary fix for previous database which doesn't have get bootstrap revision
		if(getBootstrapRevision() == 0 && Role.findByAuthority("ROLE_SALES_PRESIDENT")){
			setBootstrapRevision(1);
		}
		//tmpDatabaseFixes()
		//Adding Roles
		initializeRoles()
		createDefaultUsers()
		changeAdminProtectedField()
		
		//1) Adding staging for service
		addServiceStages();

		if(isDemo) {
			insertDemoData()
		}

		checkForInactiveServices()
		/*****Setup Stages*****************/
		addSetupStages()
		/*def welcomeStage = Staging.findByName("welcom")
		if(welcomeStage != null){
			welcomeStage.name = "welcome"
			welcomeStage.displayName = "Welcome"
			welcomeStage.description = "Welcome"
			welcomeStage.save()
			
		}*/
		/***** Quotation changes ***********/
		addQuotationStages()

		/***********Lead stages**********************************/
		addLeadStages();

		/*******************Opportunity Stages*******************/
		addOpportunityStages();
		//checkForOpportunity()//check if opportunity is expired or not

		/*******************Service Quotation Stages*******************/
		addServiceQuotationStages()
		
		/**********Service sub stages********************************/
			
			//deleteAllServiceSubStages()
			//addServiceSubStages();
			//addNewSubStageInDesignStage()//adding new stage that is created for requirement
			initializeMetaphorsValueInServiceProfile()
		
		addDefaultSettings()
		
		correctTerritoryExternalValue()//makes external flag to "no"
		
		addTerritoryDateFormat()//add default dateformat if not exist
		
		checkForNotImportedService()//check if service is imported or no
		
		checkAccountImageFormat()//check if image is in correct format or not
		
		generateServiceProfileSOWDefinition()//convert definition value into definition object class
		convertDefinitionToSetting()
		
		setActiveStageProperty()//makes stage active
		//deleteTemporaryPricelist()
		//deleteOldRoleTimeCorrections()
		
		doServiceProfileFixis()//check for new profile and make old profile inactive
		doPricelistFixis()
		correctServiceProfileWorkflowMode()
		
		//giveAdministratorPermission()
		correctAccountWebsiteProtocol()//make wibsite field corrections
		//moveAccountLogos()
		
		//moveSowTemplateFiles()
		//deleteQuota()

		correctQuotationVersion() //This is new feature for setting all previous quotation version "not light"....
		
		convertQuotaAmountToBaseCurrency()
		
		fixPrimaryTerritoryForSalesPerson()
		
		/*********Adding default types service deliverables and activities and SOW Milestones***************/
			bootstrapProcessService.addDefaultDeliverableTypes()
			bootstrapProcessService.addDefaultActivityTypes()
			bootstrapProcessService.addDefaultSOWMilestoneTypes()
			bootstrapProcessService.addDefaultDeliverablePhase()
			
		/*********Adding description field of serviceDeliverables into description class***************/
			bootstrapProcessService.convertingServiceDeliverableDescriptionToDescriptionClass()
			
		/******************Correcting sequence order of serviceQuotation used for quotation *********************************/
			bootstrapProcessService.checkAndCorrectServiceQuotationSequenceOrder()
			bootstrapProcessService.correctServiceQuotationSequenceOrderForMultipleEntries()
			
		/*************Service description quick fix*********************************************/
			bootstrapProcessService.doServiceDescriptionQuickFix()
			
		/*************convert all default entity name to upper case letter**********************/
			bootstrapProcessService.convertAllDefaultEntityNameToUppercase()
			
		/*************Convert SOW discount to local discount and related changes****************/
			bootstrapProcessService.convertSowDiscountToLocalDiscount()
			
		/*************Correcting sequence order of existing deliverable default phases****************/
			bootstrapProcessService.correctSequenceOrderOfDefaultPhases()
			
		/*************Convert Territory SOW file to SowDocumentTemplate*******************************/
			bootstrapProcessService.convertSowFileToSowDocumentTemplate()
			
		/*************Correct all imported opportunity from connectwise for their sales user**********/
			bootstrapProcessService.correctOpportunityAssignedUser()
			
		/*********For Salesforce**********/
		if(salesCatalogService.isClass("com.salesforce.integration.SalesforceExportService", grailsApplication))
		{
			salesforceOpportunityImportTimer = new SalesforceOpportunityImportTimer(sfimportService, grailsApplication, messageSource)
			salesforceOpportunityImportTimer.init()
		}
		
		/*********For connectwise**********/
		if(salesCatalogService.isClass("com.connectwise.integration.ConnectwiseExporterService", grailsApplication))
		{
			connectwiseCredentialsSettings()//Settings related to newly added fields
			saveLastUpdateRecordOfConnectwiseImportOpportunity()
			startOpportunityImportTimer = true
			
			//println "class exist"
			/*doFixOfRejectedQuotationRelatedToConnectwise()//convert reject quotation to Accept
			
			createTicketForReference()//creat reference tickets in pricewell related to connectwise 
			updateReferenceTicektWithId()//update reference ticket id in pricewell related to connectwise
			
			doServiceTicketBudgetHoursFixs()//update service ticket's budget hours in connectwise from pricewell reference ticket
			*/
			//saveLastImportTimeStampOfConnectwiseOpportunity()
			
			/*************Remove all opportunity that are imported from Connectwise having forecast revanue with 0**************/
				bootstrapProcessService.removeSMPOpportunitiesWithZeroEstimateForecast()
				
			/*************change external source of connectwise opportunity**********************/
				bootstrapProcessService.changeExternalSourceOfOpportunity()
			
		}
		
		
		serviceCatalogService.updateNotification()//update service notification comment
		//		ServiceProfile sp = Service.get(10).serviceProfile
		//		sp.definition = "Foe this service there are [@@units@@] sdsd"
		//		sp.save(flush: true)
		//if(getBootstrapRevision() < 3)		
		//{
			addServiceSubStages();
			addNewSubStageInDesignStage()//adding new stage that is created for requirement
			initializeMetaphorsValueInServiceProfile()
		//}
		} // end Role.withTransaction

		//setBootstrapRevision(3);
		//startSendingMail()
		timer = new SendMailTimer(sendMailService);
		timer.init();
		
		opportunityExpTimer = new OpportunityExpireTimer(opportunityService)
		opportunityExpTimer.init()
		
		if(startOpportunityImportTimer)
		{
			opportunityImportTimer = new OpportunityImportTimer(cwimportService, grailsApplication, messageSource)
			opportunityImportTimer.init()
		}
		
		//ServiceStageFlow.init();
		
	}

	/*public startSendingMail()
	{
		Timer t = new Timer();
		println "start timer"
		t.schedule(new MailSendingTimer(), 0, 1000 * 5);
		
	}*/
	
	public void deleteAllServiceSubStages()
	{
		for(Staging stage : Staging.list())
		{
			stage.subStages = new ArrayList()
			stage.save()
		}
		
		for(SubStages substage : SubStages.list()){
			substage.delete()
		}
	}
	
	public void correctQuotationVersion()
	{
		for(Quotation quotation : Quotation?.list()){
			if(quotation?.isLight == null || quotation?.isLight == "NULL")
			{
				println "Setting default versiontype false for quotation : "+quotation
				quotation?.isLight = false
				quotation.save()
			}
		}
	}
	
	public void initializeMetaphorsValueInServiceProfile()
	{
		for(ServiceProfile sp : ServiceProfile.list())
		{
			if(sp?.metaphors?.size() == 0 )//|| sp?.metaphors == null || sp?.metaphors == "NULL" || sp?.metaphors == [])
			{
				sp?.metaphors = new ArrayList()
				sp.save()
			}
		}
	}
	
	public void connectwiseCredentialsSettings()
	{
		for(ConnectwiseCredentials cc : ConnectwiseCredentials?.list())
		{
			if(cc?.updateHours == null || cc?.updateHours == "NULL")
			{
				cc.updateHours = 0
				cc.save()
			}
		}
	}
	
	public void saveLastImportTimeStampOfConnectwiseOpportunity()
	{
		TimeStampSaverObject timeStamp = TimeStampSaverObject.findByObjectName("connectwiseImportOpportunity")
		if(timeStamp == null)
		{
			List opportunityList = Opportunity.findAll("FROM Opportunity op WHERE op.externalId != null ORDER BY dateCreated DESC")
			if(opportunityList?.size() > 0)
			{
				Opportunity opportunity = opportunityList.first()
				if(opportunity)
				{
					connectwiseCatalogService.saveTimestampForConnectwiseImportOpportunity(null, opportunity?.dateCreated)
				}
			}
		}
	}
	
	public void saveLastUpdateRecordOfConnectwiseImportOpportunity()
	{
		UpdateRecord lastUpdateRecord = connectwiseCatalogService.getLastUpdateDateOfConnectwiseImportOpportunity()
		//println lastUpdateRecord
		if(lastUpdateRecord == null)
		{
			List opportunityList = Opportunity.findAll("FROM Opportunity op WHERE op.externalId != null ORDER BY dateCreated DESC")
			if(opportunityList?.size() > 0)
			{
				Opportunity opportunity = opportunityList.first()
				if(opportunity)
				{
					connectwiseCatalogService.saveUpdateRecordForConnectwiseImportOpportunity(null, opportunity?.dateCreated, "Setting first record of connectwise import opportunities.")
				}
			}
		}
	}
	
	void changeAdminProtectedField()
	{
		Role adminRole = Role.findByAuthority('ROLE_SYSTEM_ADMINISTRATOR')
		
		if(adminRole && adminRole?.protect == true)
		{
			adminRole.protect = false
			adminRole.save()
			println "done";
			
			if (adminRole.hasErrors()) {
				adminRole.errors.each {
					log.error(it)
				}
				throw new RuntimeException("Unable to create valid administrative role")
			}
		}
	}
	
	void convertQuotaAmountToBaseCurrency()
	{
		CompanyInformation companyInformationInstance = null
		String currency = ""
		
		if(CompanyInformation.list().size() > 0)
		{
			companyInformationInstance = CompanyInformation.list().get(0);
			currency = companyInformationInstance?.baseCurrency
		}
		
		int ROUNDING_MODE = BigDecimal.ROUND_HALF_EVEN;
		for(Quota quota : Quota.list())
		{
			
			if(quota.currency != currency)
			{
				Geo territory = null
				if(quota?.territory?.id != null)
				{
					territory = Geo.get(quota?.territory?.id)
				}
				else if(quota?.person?.territory?.id)
				{
					territory = Geo.get(quota?.person?.territory?.id)
				}
				
				if(territory != null)
				{
					quota.amount = quota.amount.divide(territory?.convert_rate, ROUNDING_MODE)
					quota.currency = currency
					quota.save()
					println "Quota Id : "+quota.id+" Amount : "+quota.amount
				}
			}
		}
	}
	
	public fixPrimaryTerritoryForSalesPerson()
	{
		List salesPersonList = serviceCatalogService.findUsersByRole("SALES PERSON")
		for(User salesUser : salesPersonList)
		{
			if(salesUser?.primaryTerritory == null || salesUser?.primaryTerritory == "")
			{
				if(salesUser?.territory != null && salesUser?.territory != "")
				{
					salesUser.primaryTerritory = Geo.get(salesUser?.territory?.id)
					println salesUser
					salesUser.save()
				}
			}
		}
	}
	
	void correctServiceProfileWorkflowMode()
	{
		for(ServiceProfile sp : ServiceProfile.list())
		{
			if(sp?.workflowMode == null || sp?.workflowMode == "")
			{
				if(sp?.isImported == "true")
				{
					println "import : "+sp
					sp.workflowMode = "imported"
					sp.save()
				}
				else
				{
					println "detail : "+sp
					sp.workflowMode = "detailed"
					sp.save()
				}
			}
			
			
		}
	}
	
	public void addNewSubStageInDesignStage()
	{
		Staging design = Staging.findByNameAndEntity("design", Staging.StagingObjectType.SERVICE)
		boolean isPrerequsitesAvailable = false
		boolean isOutOfScopeAvailable = false
		
		if(design?.subStages?.size() > 0)
		{
			for(SubStages subStage :  design?.subStages)
			{
				if(subStage?.name == "showDetailedInfo" && (subStage.sequenceNumber == 4 || subStage.sequenceNumber == 5)) //shifted from 4 to 5 to 6
				{
					subStage.sequenceNumber = 6
					subStage.save()
				}
				else if(subStage?.name == "request" && (subStage.sequenceNumber == 5 || subStage.sequenceNumber == 6)) //shifted from 5 to 6 to 7
				{
					subStage.sequenceNumber = 7
					subStage.save()
				}
				else if(subStage?.name == "addMetaphors" || subStage?.name == "addMetaphor" || subStage?.name == "addPrerequsites" || subStage?.name == "addPrerequisites")
				{
					if(subStage?.name == "addMetaphors" || subStage?.name == "addMetaphor" || subStage?.name == "addPrerequsites"){
						subStage?.name = "addPrerequisites"//"addMetaphors"
						subStage?.displayName = "Add Pre-requisites"//"addMetaphors"
						subStage.save()
					}
					isPrerequsitesAvailable = true
				}
				else if(subStage?.name == "addOutOfScope")
				{
					isOutOfScopeAvailable = true
				}
			}
			
			if(!isPrerequsitesAvailable)
			{
				design.addToSubStages(createSubStage("addPrerequisites", "Add Pre-requisites", 4))//added new
				println "Stage added : Pre-requsites"
				design.save()
			}
			
			if(!isOutOfScopeAvailable)
			{
				design.addToSubStages(createSubStage("addOutOfScope", "Add Out of Scope", 5))//added new
				println "Stage added : Out of Scope"
				design.save()
			}
		}
		
	}
	
	public SubStages createSubStage(String name, String displayName, int sqNumber)
	{
		SubStages subStage = new SubStages()
		
		subStage.name = name
		subStage.displayName = displayName
		subStage.sequenceNumber = sqNumber
		subStage.save()
		println subStage.name
		return subStage
	}
	
	public boolean isSubStageAvailableInStage(Staging stage, String subStage)
	{
		boolean isSubstageAvailable = false
		
		for(SubStages ss : stage?.subStages)
		{
			if(ss?.name == subStage)
			{
				isSubstageAvailable = true
				
			}
		}
		
		return isSubstageAvailable
	}
	
	void addServiceSubStages()
	{	
			
		def concept = Staging.findByNameAndEntity("concept", Staging.StagingObjectType.SERVICE)
		
		if(concept?.subStages != null)// && concept?.subStages?.size() == 0)
		{
			if(!isSubStageAvailableInStage(concept, "edit"))
				concept.addToSubStages(createSubStage("edit", "Add requirement data", 1))
			
			if(!isSubStageAvailableInStage(concept, "editDeliverables"))
				concept.addToSubStages(createSubStage("editDeliverables", "Add Service Deliverables", 2))
					
			if(!isSubStageAvailableInStage(concept, "editDefinition"))
				concept.addToSubStages(createSubStage("editDefinition", "Add SOW Language", 3))
						
			if(!isSubStageAvailableInStage(concept, "showInfo"))
				concept.addToSubStages(createSubStage("showInfo", "Preview", 4))
						
			if(!isSubStageAvailableInStage(concept, "request"))
				concept.addToSubStages(createSubStage("request", "Request concept review", 5))
			
			concept.save()
		}		
		
		def conceptreview = Staging.findByNameAndEntity("conceptreview", Staging.StagingObjectType.SERVICE)
		
		if(conceptreview?.subStages != null)// && conceptreview?.subStages?.size() == 0)
		{
			if(!isSubStageAvailableInStage(conceptreview, "showInfo"))
				conceptreview.addToSubStages(createSubStage("showInfo", "Review Requirements", 1))
			
			if(!isSubStageAvailableInStage(conceptreview, "approveRequest"))
				conceptreview.addToSubStages(createSubStage("approveRequest", "Approve/Reject Concept", 2))
			
			conceptreview.save()
		}
				
		def conceptapproved = Staging.findByNameAndEntity("conceptapproved", Staging.StagingObjectType.SERVICE)
		
		if(conceptapproved?.subStages != null)// && conceptapproved?.subStages?.size() == 0)
		{
			if(!isSubStageAvailableInStage(conceptapproved, "assignDesigner"))
				conceptapproved.addToSubStages(createSubStage("assignDesigner", "Assign Designer", 1))
			
			conceptapproved.save()
		}
		
		def design = Staging.findByNameAndEntity("design", Staging.StagingObjectType.SERVICE)
		
		if(design?.subStages != null)// && design?.subStages?.size() == 0)
		{
			if(!isSubStageAvailableInStage(design, "showInfo"))
				design.addToSubStages(createSubStage("showInfo", "Review Requirements", 1))
			
			if(!isSubStageAvailableInStage(design, "addActivities"))
				design.addToSubStages(createSubStage("addActivities", "Add Activities and Roles", 2))
					
			if(!isSubStageAvailableInStage(design, "addProducts"))
				design.addToSubStages(createSubStage("addProducts", "Define Products", 3))
			
			if(!isSubStageAvailableInStage(design, "addPrerequisites"))
				design.addToSubStages(createSubStage("addPrerequisites", "Add Pre-requisites", 4))//added new
			
			if(!isSubStageAvailableInStage(design, "addOutOfScope"))
				design.addToSubStages(createSubStage("addOutOfScope", "Add Out of Scope", 5))//added new
						
			if(!isSubStageAvailableInStage(design, "showDetailedInfo"))
				design.addToSubStages(createSubStage("showDetailedInfo", "Preview", 6))//changing sequence order from 4 to 6
							
			if(!isSubStageAvailableInStage(design, "request"))
				design.addToSubStages(createSubStage("request", "Request Design Review", 7))//changing sequence order from 5 to 7
			
			design.save()
		}
			
		def designreview = Staging.findByNameAndEntity("designreview", Staging.StagingObjectType.SERVICE)
		 
		if(designreview?.subStages != null)// && designreview?.subStages?.size() == 0)
		{
			if(!isSubStageAvailableInStage(designreview, "showDetailedInfo"))
				designreview.addToSubStages(createSubStage("showDetailedInfo", "Review Design", 1))
			
			if(!isSubStageAvailableInStage(designreview, "editDefinition"))
				designreview.addToSubStages(createSubStage("editDefinition", "Edit SOW Language", 2))
			
			if(!isSubStageAvailableInStage(designreview, "approveRequest"))
				designreview.addToSubStages(createSubStage("approveRequest", "Approve/Reject Design", 3))
			
			designreview.save()
		}
			
		def designapproved = Staging.findByNameAndEntity("designapproved", Staging.StagingObjectType.SERVICE)
		 
		if(designapproved?.subStages != null)// && designapproved?.subStages?.size() == 0)
		{
			if(!isSubStageAvailableInStage(designapproved, "request"))
				designapproved.addToSubStages(createSubStage("request", "Request Sales Review", 1))
			
			designapproved.save()
		}
					
		def salesreview = Staging.findByNameAndEntity("salesreview", Staging.StagingObjectType.SERVICE)
		 
		if(salesreview?.subStages != null)// && salesreview?.subStages?.size() == 0)
		{
			if(!isSubStageAvailableInStage(salesreview, "showDetailedInfo"))
				salesreview.addToSubStages(createSubStage("showDetailedInfo", "Review Service Info", 1))
			
			if(!isSubStageAvailableInStage(salesreview, "approveRequest"))
				salesreview.addToSubStages(createSubStage("approveRequest", "Approve/Reject Sale", 2))
			
			salesreview.save()
		}
			
		def salesapproval = Staging.findByNameAndEntity("salesapproval", Staging.StagingObjectType.SERVICE)
		 
		if(salesapproval?.subStages != null)// && salesapproval?.subStages?.size() == 0)
		{
			if(!isSubStageAvailableInStage(salesapproval, "request"))
				salesapproval.addToSubStages(createSubStage("request", "Request Publish", 1))
			
			salesapproval.save()
		}
			
		def requestforpublished = Staging.findByNameAndEntity("requestforpublished", Staging.StagingObjectType.SERVICE)
		
		if(requestforpublished?.subStages != null)// && requestforpublished?.subStages?.size() == 0)
		{
			if(!isSubStageAvailableInStage(requestforpublished, "showDetailedInfo"))
				requestforpublished.addToSubStages(createSubStage("showDetailedInfo", "Review Service Info", 1))
			
			if(!isSubStageAvailableInStage(requestforpublished, "approveRequest"))
				requestforpublished.addToSubStages(createSubStage("approveRequest", "Approve publishing", 2))
			
			requestforpublished.save()
		}
			
		
	}
		
	public void setActiveStageProperty()
	{
			for(Staging st : Staging.list())
			{
				//if(st.isActive != true)
				//{
				//println st
					st.isActive = new Boolean(true)
					st.save()
				//}
			}
			
			def opportunityStagingList = Staging.findAll("from Staging st where st.entity = :entity and  (st.name = :opp1 or st.name = :opp2 or st.name = :opp3)",
				[entity: Staging.StagingObjectType.OPPORTUNITY, opp1 : "valueProposition",opp2:"decisionMakers", opp3: "perceptionAnalysis"])
			
			
			if(opportunityStagingList != null)
			{
				println opportunityStagingList
				
				for(Staging st in opportunityStagingList)
				{
					st.isActive = false
					st.save()
				}				
			}
	}
	
	
	boolean isURLContainsProtocols(String url)
	{
		if(url.startsWith("http://") || url.startsWith("https://") || url.startsWith("ftp://"))
			return true
		else
			return false
	}
	
	void correctAccountWebsiteProtocol()
	{
		for(Account account : Account.list())
		{
			if(account?.website != null && account?.website != "")
			{
				if(!isURLContainsProtocols(account?.website))
				{
					//add default start "http://"
					account.website = "http://"+account.website
					account.save()
				}
			}
		}
	}
	
	void updateReferenceTicektWithId()
	{
		cwimportService.updateReferenceTicektWithId()
	}
	
	void doFixOfRejectedQuotationRelatedToConnectwise()
	{
		def quotationList = Quotation.findAll("From Quotation qu WHERE qu.convertToTicket='yes' AND qu.contractStatus.name = 'rejected'")
		
		for(Quotation quotation : quotationList)
		{
			quotation.contractStatus = Staging.findByName("Accepted")
			quotation.save()
		}
	}
	
	void doServiceTicketBudgetHoursFixs()
	{
		def quotationList = Quotation.findAll("From Quotation qu WHERE qu.convertToTicket='yes' AND qu.contractStatus.name = 'Accepted'")
		
		for(Quotation quotation : quotationList)
		{
			cwimportService.addTotalBudgetHoursAsPerQuotationUnits(quotation)
		}
	}
	
	void createTicketForReference()
	{
		def quotationList = Quotation.findAll("From Quotation qu WHERE qu.convertToTicket='yes' AND qu.contractStatus.name = 'Accepted'")
		def user = User.findByUsername("admin")
		if(user)
		{
			for(Quotation quotation : quotationList)
			{
				cwimportService.createServiceQuotationTicket(quotation, user)//for pricewell
			}
		}
		
	}
	
	// giveAdministratorPermission() removed — Nimble WildcardPermissions are no longer used.
	// Role-based access is now controlled entirely by Spring Security interceptUrlMap in Config.groovy.
	
	void doPricelistFixis()
	{
		for(Pricelist pricelist : Pricelist.list())
		{
			ServiceProfile sp = ServiceProfile.get(pricelist?.serviceProfile?.id)
			Service ser = Service.get(sp?.service?.id)
			if(sp?.newProfile != null)
			{
				ServiceProfile np = ServiceProfile.get(sp?.newProfile?.id)
				if(np?.newProfile == null && np?.stagingStatus?.name == "publish")
				{
					if(ser.serviceProfile?.id != np?.id)
					{
						ser.serviceProfile = np
						if(!serviceStagingService.isProfileAvailableInService(ser, np))
						{
							ser.addToProfiles(np)
						}
						ser.save()
						sp.stagingStatus = Staging.findByName("inActive")
						sp.type = ServiceProfile.ServiceProfileType.INACTIVE
						sp.save()
					}
					
				}
				
				if(sp?.stagingStatus?.name == "publish" && np?.stagingStatus?.name == "publish")
				{
					sp.stagingStatus = Staging.findByName("inActive")
					sp.type = ServiceProfile.ServiceProfileType.INACTIVE
					sp.save()
				}
				
			}
			else
			{
				if(ser.serviceProfile?.id != sp?.id)
				{
					ser.serviceProfile = sp
					if(!serviceStagingService.isProfileAvailableInService(ser, sp))
					{
						ser.addToProfiles(sp)
					}
					ser.save()
				}
			}
		}
	}
	
	void doServiceProfileFixis()
	{
		for(ServiceProfile sp : ServiceProfile.list())
		{
			if(sp?.newProfile != null && sp?.oldProfile != null)
			{
				if(sp.id == sp.newProfile.id && sp.id == sp.oldProfile.id && sp.newProfile.id == sp.oldProfile.id)
				{
					sp.newProfile = null
					sp.oldProfile = null
					sp.save()
				}
			}
		}
	}
	
	void deleteTemporaryPricelist()
	{
		for(Pricelist pricelist : Pricelist.list())
		{
			
			if(pricelist?.isTemporary == "yes")
			{
				pricelist.delete()
			}
		}
	}
	
	void deleteOldRoleTimeCorrections()
	{
		/*for(ActivityRoleTimeCorrection correction : ActivityRoleTimeCorrection.list())
		{
			correction.delete()
		}*/
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
	
	void checkAccountImageFormat()
	{
		for(Account accountInstance : Account.list())
		{
			if(accountInstance?.imageFile?.filePath != null && accountInstance?.imageFile?.filePath != "" && accountInstance?.imageFile?.filePath != "null")
			{
				if(isFileExist(accountInstance?.imageFile?.filePath))
				{
					File imageFile = new File(accountInstance?.imageFile?.filePath);
					if(!fileUploadService.isValidImage(imageFile))
					{
						imageFile.delete()
						accountInstance.imageFile = null
						accountInstance.logo = null
						accountInstance.save()
					}
				}
			}
		}		
	}
	
	public boolean isFileExist(String filePath)
	{
		boolean isThere = false
		File f = new File(filePath);
		
		 if(f.exists())
		 {
			 isThere = true
		 }
		 
		 return isThere
	}
	
	void generateServiceProfileSOWDefinition()
	{
		for(ServiceProfile sp : ServiceProfile.list())
		{
			if(sp?.definition != null && sp?.definition != "")
			{
				boolean defaultAvailable = false
				if(sp?.defs?.size() > 0)
				{
					for(ServiceProfileSOWDef sowDef : sp?.defs)
					{
						if(sowDef?.part == "Default Section")
						{
							defaultAvailable = true
						}
					}
				}
				
				if(!defaultAvailable)
				{
					def sowDef = new ServiceProfileSOWDef()
					sowDef.sp = sp
					sowDef.part = "Default Section"
					sowDef.definitionSetting = new Setting(name: "sowDefinition", value: sp.definition).save(flush: true)
					//sowDef.save()
					sp.addToDefs(sowDef)
					if(sp.save(flush: true))
					{
						println sp.service?.serviceName
					}
				}
			}
		}	
	}
	
	public void convertDefinitionToSetting()
	{
		for(ServiceProfileSOWDef sowDef : ServiceProfileSOWDef.list())
		{
			if(sowDef.definition != null && (sowDef?.definitionSetting == null || sowDef?.definitionSetting == ""))
			{
				sowDef.definitionSetting = new Setting(name: "convertedSOWDefinitionId"+sowDef.id, value: sowDef.definition).save(flush: true)
				sowDef.save()
				println sowDef.part
			}
		}
	}
	
	void correctTerritoryExternalValue()
	{
		for(Geo territory : Geo.list())
		{
			if(territory.isExternal  == null || territory.isExternal == "" || territory.isExternal == "NULL")
			{
				println territory.name
				territory.isExternal = "no"
				territory.save()
			}
		}
	}
	
	void addTerritoryDateFormat()
	{
		for(Geo territory : Geo.list())
		{
			if(territory.dateFormat == null || territory.dateFormat == "")
			{
				println territory.dateFormat
				territory.dateFormat = "mm/dd/yy"
				territory.save()
			}
		}
	}
	
	void checkForOpportunity()
	{
		//opportunityService.checkOpportunities(Opportunity.list())
	}
	
	void checkForInactiveServices()
	{
		ServiceProfileType type = ServiceProfile.ServiceProfileType.INACTIVE
		def serviceList = Service.findAll("from Service service where service.serviceProfile.type=:type order by dateModified desc", [type: type] )
		for(Service service : serviceList)
		{
			if(service.serviceProfile.stagingStatus.name != "inActive")
			{
				def newStage = Staging.findByName("inActive")
				service.serviceProfile?.stagingStatus = newStage
				if(!service.save(flush:true))
				{
					//
				}
			}
		}
	}
	
	void checkForNotImportedService()
	{
		for(Service ser : Service.list())
		{
			if(ser.serviceProfile != null && ser.serviceProfile.isImported == null )
			{
				ser.serviceProfile.isImported = "false"
				println ser.serviceName
				ser.serviceProfile.dateModified = new Date()
				ser.serviceProfile.save()
			}
		}
	}
	
	void addDefaultSettings(){
		if(!Setting.findByName("sowLabel")){
			new Setting(name: "sowLabel", value: "").save(flush: true);
		}
		if(!Setting.findByName("sowTemplate")){
			new Setting(name: "sowTemplate", value: "<p> Use following tags to put place holder for dynamically generated contents. </p>"+
					"<ul>"+
					"<li> [@@sow_introduction_input@@] a placeholder where sales person can add introduction </li>"+
					"<li> [@@services@@] for print services details </li>"+
					"<li> [@@terms@@] for terms and conditions for given GEO </li>"+
					"<li> [@@billing_terms@@] for billing terms for given GEO </li>"+
					"<li> [@@signature_block@@] </li>"+
					"</ul>").save(flush: true);
		}

		if(!Setting.findByName("services")){
			new Setting(name: "services", value: "Currently This is disable.").save(flush: true);
		}

		if(Setting.findByName("services"))
		{
			def s = Setting.findByName("services")
			s.value = "Currently This is disable."
			s.save();
		}

		if(!Setting.findByName("terms")){
			new Setting(name: "terms", value: "").save(flush: true);
		}

		if(!Setting.findByName("billing_terms")){
			new Setting(name: "billing_terms", value: "").save(flush: true);
		}

		if(!Setting.findByName("signature_block")){
			new Setting(name: "signature_block", value: "").save(flush: true);
		}
	}


	void addServiceStages(){
		def serviceStagingList = Staging.findAll("from Staging st where st.entity = :entity and :stage in elements(st.types) order by sequenceOrder desc",
				[entity: Staging.StagingObjectType.SERVICE, stage: Staging.StagingType.NEW_STAGE])

		if(serviceStagingList.size()==0)
		{
			def stag1 = new Staging(entity: Staging.StagingObjectType.SERVICE,
					name: "init",
					displayName: "Initialization",
					description: "Create service and assign product manager to define core requirements of service",
					types: [
						Staging.StagingType.BEGIN_NEW,
						Staging.StagingType.NEW_STAGE
					],
					sequenceOrder: 1,
					scopeOfAuthorizedRole: AuthorizedScope.NA,
					authorizedRoles: [
						Role.findByCode(RoleId.PORTFOLIO_MANAGER.code)
					]).save(flush: true)

			def stag2 = new Staging(entity: Staging.StagingObjectType.SERVICE,
					name: "concept",
					displayName: "Conceptualization",
					description: "<ul> <li> Add requirement data for service </li> <li> Then send request to review requirements for concept </li> </ul>",
					types: [
						Staging.StagingType.NEW_STAGE
					],
					sequenceOrder: 10,
					scopeOfAuthorizedRole: AuthorizedScope.NA,
					authorizedRoles: [
						Role.findByCode(RoleId.PRODUCT_MANAGER.code)
					]).save(flush: true)

			def stag3 = new Staging(entity: Staging.StagingObjectType.SERVICE,
					name: "conceptreview",
					displayName: "Concept Review",
					description: "Review requirement data and approve if valid",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.REVIEW_REQUEST
					],
					sequenceOrder: 11,
					scopeOfAuthorizedRole: AuthorizedScope.SERVICE,
					authorizedRoles: [
						Role.findByCode(RoleId.PORTFOLIO_MANAGER.code) ]
					).save(flush: true)

			def stag4 = new Staging(entity: Staging.StagingObjectType.SERVICE,
					name: "conceptapproved",
					displayName: "Concept Approved",
					description: "Concept is Approved, now assign service designer to define detailed activities and estimate time required",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.APPROVAL
					],
					sequenceOrder: 12,
					scopeOfAuthorizedRole: AuthorizedScope.ADMIN,
					authorizedRoles: [
						Role.findByCode(RoleId.PRODUCT_MANAGER.code)]
					).save(flush: true)

			def stag5 = new Staging(entity: Staging.StagingObjectType.SERVICE,
					name: "design",
					displayName: "Design",
					description: "<ul> <li>Define detailed service activities and roles required for each activity </li> <li> Define estimate time and role required for each activity </li> <li> After design is done, send it for review request to product manager </li> </ul>",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.BEGIN_EDIT,
						Staging.StagingType.EDIT_STAGE
					],
					sequenceOrder: 20,
					scopeOfAuthorizedRole: AuthorizedScope.NA,
					authorizedRoles: [
						Role.findByCode(RoleId.SERVICE_DESIGNER.code)
					]).save(flush: true)

			def stag6 = new Staging(entity: Staging.StagingObjectType.SERVICE,
					name: "designreview",
					displayName: "Design Review",
					description: "Review design and approve if valid",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.EDIT_STAGE,
						Staging.StagingType.REVIEW_REQUEST
					],
					sequenceOrder: 21,
					scopeOfAuthorizedRole: AuthorizedScope.SERVICE,
					authorizedRoles: [
						Role.findByCode(RoleId.PRODUCT_MANAGER.code)
					],
					reviewerRoles: [
						Role.findByCode(RoleId.SERVICE_DESIGNER.code)]
					).save(flush: true)

			def stag7 = new Staging(entity: Staging.StagingObjectType.SERVICE,
					name: "designapproved",
					displayName: "Design Approved",
					description: "Design is approved, now send Sale approval request",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.EDIT_STAGE,
						Staging.StagingType.APPROVAL
					],
					sequenceOrder: 22,
					scopeOfAuthorizedRole: AuthorizedScope.SERVICE,
					authorizedRoles: [
						Role.findByCode(RoleId.PRODUCT_MANAGER.code)
					]).save(flush: true)

			def stag8 = new Staging(entity: Staging.StagingObjectType.SERVICE,
					name: "salesreview",
					displayName: "Sales Review",
					description: "Review Sales related concern and approve if valid",
					types: [
						Staging.StagingType.REVIEW_REQUEST,
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.EDIT_STAGE
					],
					sequenceOrder: 31,
					scopeOfAuthorizedRole: AuthorizedScope.SERVICE,
					authorizedRoles: [
						Role.findByCode(RoleId.PORTFOLIO_MANAGER.code)]
					).save(flush: true)

			def stag9 = new Staging(entity: Staging.StagingObjectType.SERVICE,
					name: "salesapproval",
					displayName: "Sales Approval",
					description: "Sales is approved so GEO admins will be notified to request to publish",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.EDIT_STAGE,
						Staging.StagingType.APPROVAL
					],
					sequenceOrder: 32,
					authorizedRoles: [
						Role.findByCode(RoleId.PORTFOLIO_MANAGER.code)
					],
					scopeOfAuthorizedRole: AuthorizedScope.LEGAL
					).save(flush: true)

			def stag10 = new Staging(entity: Staging.StagingObjectType.SERVICE,
					name: "requestforpublished",
					displayName: "Request to Publish",
					description: "Request to Publish",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.EDIT_STAGE,
						Staging.StagingType.REVIEW_REQUEST
					],
					sequenceOrder: 41,
					scopeOfAuthorizedRole: AuthorizedScope.SERVICE
					).save(flush: true)

			def stag11 = new Staging(entity: Staging.StagingObjectType.SERVICE,
					name: "published",
					displayName: "Published",
					description: "Published",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.EDIT_STAGE,
						Staging.StagingType.END_NEW,
						Staging.StagingType.END_EDIT
					],
					sequenceOrder: 42,
					scopeOfAuthorizedRole: AuthorizedScope.PORTFOLIO
					).save(flush: true)

			def stag12 = new Staging(entity: Staging.StagingObjectType.SERVICE,
					name: "requesttoremove",
					displayName: "Request to remove",
					description: "Request to remove",
					types: [
						Staging.StagingType.REMOVE_STAGE,
						Staging.StagingType.BEGIN_REMOVE,
						Staging.StagingType.REVIEW_REQUEST
					],
					sequenceOrder: 43,
					scopeOfAuthorizedRole: AuthorizedScope.SERVICE,
					authorizedRoles: [
						Role.findByCode(RoleId.PRODUCT_MANAGER.code)]
					).save(flush: true)

			def stag13 = new Staging(entity: Staging.StagingObjectType.SERVICE,
					name: "removed",
					displayName: "Removed",
					description: "Removed",
					types: [
						Staging.StagingType.REMOVE_STAGE,
						Staging.StagingType.END_REMOVE,
						Staging.StagingType.APPROVAL
					],
					sequenceOrder: 100,
					scopeOfAuthorizedRole: AuthorizedScope.PORTFOLIO,
					authorizedRoles: [
						Role.findByCode(RoleId.PORTFOLIO_MANAGER.code)]
					).save(flush: true)

			if(!Staging.findByName("inActive")) {
				def stag22 = new Staging(entity: Staging.StagingObjectType.SERVICE,
						name: "inActive",
						displayName: "Not Active",
						description: "New Version of service is being upgraded",
						types: [Staging.StagingType.INACTIVE],
						sequenceOrder: 23).save(flush: true)
			}

			println "------------List of staging for Service-----------"


			def stagingList = Staging.findAll("from Staging st where st.entity = :entity and :stage in elements(st.types) order by sequenceOrder desc",
					[entity: Staging.StagingObjectType.SERVICE, stage: Staging.StagingType.NEW_STAGE])

			stagingList.each() { println " ${it.sequenceOrder} - ${it.name} - ${it.types}" };
		}
	}

	void addOpportunityStages(){
		def opportunityStagingList = Staging.findAll("from Staging st where st.entity = :entity and :stage in elements(st.types) order by sequenceOrder desc",
				[entity: Staging.StagingObjectType.OPPORTUNITY, stage: Staging.StagingType.NEW_STAGE])

		if(opportunityStagingList.size()==0)
		{
			def opportunityStage1 = new Staging(entity: Staging.StagingObjectType.OPPORTUNITY,
					name: "prospecting",
					displayName: "Prospecting",
					description: "Prospecting Stage.",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.BEGIN_NEW
					],
					sequenceOrder: 60//,
					//scopeOfAuthorizedRole: AuthorizedScope.NA,
					//authorizedRoles: [Role.findByCode(RoleId.PRODUCT_MANAGER.code)]
					).save(flush: true)

			def opportunityStage2 = new Staging(entity: Staging.StagingObjectType.OPPORTUNITY,
					name: "qualification",
					displayName: "Qualification",
					description: "Qualification Stage.",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.BEGIN_EDIT,
						Staging.StagingType.EDIT_STAGE
					],
					sequenceOrder: 61//,
					//scopeOfAuthorizedRole: AuthorizedScope.NA,
					//authorizedRoles: [Role.findByCode(RoleId.PRODUCT_MANAGER.code)]
					).save(flush: true)

			def opportunityStage3 = new Staging(entity: Staging.StagingObjectType.OPPORTUNITY,
					name: "needAnalysis",
					displayName: "Need Analysis",
					description: "Need Analysis Stage.",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.BEGIN_EDIT,
						Staging.StagingType.EDIT_STAGE
					],
					sequenceOrder: 62//,
					//scopeOfAuthorizedRole: AuthorizedScope.NA,
					//authorizedRoles: [Role.findByCode(RoleId.PRODUCT_MANAGER.code)]
					).save(flush: true)

			def opportunityStage4 = new Staging(entity: Staging.StagingObjectType.OPPORTUNITY,
					name: "valueProposition",
					displayName: "Value Proposition",
					description: "Value Proposition Stage.",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.BEGIN_EDIT,
						Staging.StagingType.EDIT_STAGE
					],
					sequenceOrder: 63//,
					//scopeOfAuthorizedRole: AuthorizedScope.NA,
					//authorizedRoles: [Role.findByCode(RoleId.PRODUCT_MANAGER.code)]
					).save(flush: true)

			def opportunityStage5 = new Staging(entity: Staging.StagingObjectType.OPPORTUNITY,
					name: "decisionMakers",
					displayName: "Decision Makers",
					description: "Decision Makers Stage.",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.BEGIN_EDIT,
						Staging.StagingType.EDIT_STAGE
					],
					sequenceOrder: 64//,
					//scopeOfAuthorizedRole: AuthorizedScope.NA,
					//authorizedRoles: [Role.findByCode(RoleId.PRODUCT_MANAGER.code)]
					).save(flush: true)


			def opportunityStage6 = new Staging(entity: Staging.StagingObjectType.OPPORTUNITY,
					name: "perceptionAnalysis",
					displayName: "Perception Analysis",
					description: "Perception Analysis Stage.",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.BEGIN_EDIT,
						Staging.StagingType.EDIT_STAGE
					],
					sequenceOrder: 65//,
					//scopeOfAuthorizedRole: AuthorizedScope.NA,
					//authorizedRoles: [Role.findByCode(RoleId.PRODUCT_MANAGER.code)]
					).save(flush: true)


			def opportunityStage7 = new Staging(entity: Staging.StagingObjectType.OPPORTUNITY,
					name: "proposalPriceQuote",
					displayName: "Proposal/Price Quote",
					description: "Proposal/Price Quote Stage.",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.BEGIN_EDIT,
						Staging.StagingType.EDIT_STAGE
					],
					sequenceOrder: 66//,
					//scopeOfAuthorizedRole: AuthorizedScope.NA,
					//authorizedRoles: [Role.findByCode(RoleId.PRODUCT_MANAGER.code)]
					).save(flush: true)


			def opportunityStage8 = new Staging(entity: Staging.StagingObjectType.OPPORTUNITY,
					name: "negotiationReview",
					displayName: "Negotiation/Review",
					description: "Negotiation/Review Stage.",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.BEGIN_EDIT,
						Staging.StagingType.EDIT_STAGE
					],
					sequenceOrder: 67//,
					//scopeOfAuthorizedRole: AuthorizedScope.NA,
					//authorizedRoles: [Role.findByCode(RoleId.PRODUCT_MANAGER.code)]
					).save(flush: true)


			def opportunityStage9 = new Staging(entity: Staging.StagingObjectType.OPPORTUNITY,
					name: "closedWon",
					displayName: "Closed Won",
					description: "Closed Won Stage.",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.REMOVE_STAGE,
						Staging.StagingType.END_REMOVE
					],
					sequenceOrder: 68//,
					//scopeOfAuthorizedRole: AuthorizedScope.NA,
					//authorizedRoles: [Role.findByCode(RoleId.PRODUCT_MANAGER.code)]
					).save(flush: true)


			def opportunityStage10 = new Staging(entity: Staging.StagingObjectType.OPPORTUNITY,
					name: "closedLost",
					displayName: "Closed Lost",
					description: "<ul> <li>Closed Lost Stage.</li> <li>Click To Break Opportunity.</li><ul>",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.REMOVE_STAGE,
						Staging.StagingType.END_REMOVE
					],
					sequenceOrder: 69//,
					//scopeOfAuthorizedRole: AuthorizedScope.NA,
					//authorizedRoles: [Role.findByCode(RoleId.PRODUCT_MANAGER.code)]
					).save(flush: true)



			println "------------List of staging for Lead-----------"


			def opportunityStagList = Staging.findAll("from Staging st where st.entity = :entity and :stage in elements(st.types) order by sequenceOrder desc",
					[entity: Staging.StagingObjectType.OPPORTUNITY, stage: Staging.StagingType.NEW_STAGE])

			opportunityStagList.each() { println " ${it.sequenceOrder} - ${it.name} - ${it.types}" };
		}
	}

	void addLeadStages(){
		def leadStagingList = Staging.findAll("from Staging st where st.entity = :entity and :stage in elements(st.types) order by sequenceOrder desc",
				[entity: Staging.StagingObjectType.LEAD, stage: Staging.StagingType.NEW_STAGE])

		if(leadStagingList.size()==0)
		{
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			/*****************************Lead Stages***************************/


			def leadStage1 = new Staging(entity: Staging.StagingObjectType.LEAD,
					name: "uncontacted",
					displayName: "Uncontacted",
					description: "Create new Lead and add requirement fields.",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.BEGIN_NEW
					],
					sequenceOrder: 50//,
					//scopeOfAuthorizedRole: AuthorizedScope.NA,
					//authorizedRoles: [Role.findByCode(RoleId.PRODUCT_MANAGER.code)]
					).save(flush: true)

			def leadStage2 = new Staging(entity: Staging.StagingObjectType.LEAD,
					name: "contactinprogress",
					displayName: "Contact In Progress",
					description: "Lead is contacted and in progress.",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.BEGIN_EDIT,
						Staging.StagingType.EDIT_STAGE
					],
					sequenceOrder: 51//,
					//scopeOfAuthorizedRole: AuthorizedScope.NA,
					//authorizedRoles: [Role.findByCode(RoleId.PRODUCT_MANAGER.code)]
					).save(flush: true)

			def leadStage3 = new Staging(entity: Staging.StagingObjectType.LEAD,
					name: "converttoopportunity",
					displayName: "Convert To Opportunity",
					description: "Lead is converting to opportunity.",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.BEGIN_EDIT,
						Staging.StagingType.EDIT_STAGE
					],
					sequenceOrder: 52//,
					//scopeOfAuthorizedRole: AuthorizedScope.NA,
					//authorizedRoles: [Role.findByCode(RoleId.PRODUCT_MANAGER.code)]
					).save(flush: true)

			def leadStage4 = new Staging(entity: Staging.StagingObjectType.LEAD,
					name: "converted",
					displayName: "Converted",
					description: "Lead is converted to opportunity.",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.BEGIN_EDIT,
						Staging.StagingType.EDIT_STAGE
					],
					sequenceOrder: 53//,
					//scopeOfAuthorizedRole: AuthorizedScope.NA,
					//authorizedRoles: [Role.findByCode(RoleId.PRODUCT_MANAGER.code)]
					).save(flush: true)

			def leadStage5 = new Staging(entity: Staging.StagingObjectType.LEAD,
					name: "dead",
					displayName: "Dead",
					description: "Lead is dead.",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.REMOVE_STAGE,
						Staging.StagingType.END_REMOVE
					],
					sequenceOrder: 54//,
					//scopeOfAuthorizedRole: AuthorizedScope.NA,
					//authorizedRoles: [Role.findByCode(RoleId.PRODUCT_MANAGER.code)]
					).save(flush: true)


			println "------------List of staging for Lead-----------"


			leadStagingList = Staging.findAll("from Staging st where st.entity = :entity and :stage in elements(st.types) order by sequenceOrder desc",
					[entity: Staging.StagingObjectType.LEAD, stage: Staging.StagingType.NEW_STAGE])

			leadStagingList.each() { println " ${it.sequenceOrder} - ${it.name} - ${it.types}" };
		}
	}

	void addQuotationStages(){
		/**
		 *   Adding Stages for Qotation
		 */


		def quoteStagingList = Staging.findAll("from Staging st where st.entity = :entity and :stage in elements(st.types) order by sequenceOrder desc",
				[entity: Staging.StagingObjectType.QUOTATION, stage: Staging.StagingType.EDIT_STAGE])

		if(quoteStagingList.size() > 0)
		{
			//Fix Staging sequence no.
			for(Staging st: quoteStagingList){
				if(st.name == "rejected" && st.sequenceOrder != -1){
					st.sequenceOrder = -1
					st.save();
				}

				if(st.name == "closedAndNewOne" && st.sequenceOrder != 0){
					st.sequenceOrder = 0
					st.save();
				}

				if(st.name == "Accepted" && st.sequenceOrder != 5){
					st.sequenceOrder = 5
					st.save();
				}

				if(st.name == "generated" &&  st.displayName != "Click to Generate"){
					st.displayName = "Click to Generate"
				}

			}
			return;
		}

		def qStage = new Staging(entity: Staging.StagingObjectType.QUOTATION,
				name: "development",
				displayName: "Development",
				description: "In Development",
				types: [
					Staging.StagingType.EDIT_STAGE,
					Staging.StagingType.BEGIN_NEW,
					Staging.StagingType.EDIT_STAGE
				],
				sequenceOrder: 1
				).save(flush: true)
		qStage = new Staging(entity: Staging.StagingObjectType.QUOTATION,
				name: "generated",
				displayName: "Click to Generate",
				description: "Click to Generate",
				types: [
					Staging.StagingType.EDIT_STAGE
				],
				sequenceOrder: 2
				).save(flush: true)
		qStage = new Staging(entity: Staging.StagingObjectType.QUOTATION,
				name: "sent",
				displayName: "Sent",
				description: "Document Sent",
				types: [
					Staging.StagingType.EDIT_STAGE
				],
				sequenceOrder: 3
				).save(flush: true)
		qStage = new Staging(entity: Staging.StagingObjectType.QUOTATION,
				name: "received",
				displayName: "Customer Received",
				description: "Customer Received",
				types: [
					Staging.StagingType.EDIT_STAGE
				],
				sequenceOrder: 4
				).save(flush: true)
		qStage = new Staging(entity: Staging.StagingObjectType.QUOTATION,
				name: "rejected",
				displayName: "Rejected",
				description: "Document Rejected",
				types: [
					Staging.StagingType.END_REMOVE,
					Staging.StagingType.REMOVE_STAGE,
					Staging.StagingType.EDIT_STAGE
				],
				sequenceOrder: -1
				).save(flush: true)
		qStage = new Staging(entity: Staging.StagingObjectType.QUOTATION,
				name: "closedAndNewOne",
				displayName: "Closed And Created New One",
				description: "Closed And Created New One",
				types: [
					Staging.StagingType.END_REMOVE,
					Staging.StagingType.REMOVE_STAGE,
					Staging.StagingType.EDIT_STAGE
				],
				sequenceOrder: 0
				).save(flush: true)

		qStage = new Staging(entity: Staging.StagingObjectType.QUOTATION,
				name: "Accepted",
				displayName: "Accepted",
				description: "Document Accepted",
				types: [
					Staging.StagingType.END_EDIT,
					Staging.StagingType.EDIT_STAGE
				],
				sequenceOrder: 5
				).save(flush: true)


		println "------------List of staging for Quotation-----------"


		quoteStagingList = Staging.findAll("from Staging st where st.entity = :entity and :stage in elements(st.types) order by sequenceOrder desc",
				[entity: Staging.StagingObjectType.QUOTATION, stage: Staging.StagingType.EDIT_STAGE])

		quoteStagingList.each() { println " ${it.sequenceOrder} - ${it.name} - ${it.types}" };
	}
	
	////////////////////////SETUP STAGES///////////////////////////////////////////////////////
	
	void addSetupStages(){
		def setupStagingList = Staging.findAll("from Staging st where st.entity = :entity and :stage in elements(st.types) order by sequenceOrder desc",
				[entity: Staging.StagingObjectType.SETUP, stage: Staging.StagingType.NEW_STAGE])

		if(setupStagingList.size()==0)
		{
			def setupStage1 = new Staging(entity: Staging.StagingObjectType.SETUP,
					name: "welcome",
					displayName: "Welcome",
					description: "Welcome",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.BEGIN_NEW
					],
					sequenceOrder: 111
					).save(flush: true)

			def setupStage2 = new Staging(entity: Staging.StagingObjectType.SETUP,
					name: "companyInfo",
					displayName: "Company Information",
					description: "Company Information",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.BEGIN_EDIT,
						Staging.StagingType.EDIT_STAGE
					],
					sequenceOrder: 112
					).save(flush: true)

			def setupStage3 = new Staging(entity: Staging.StagingObjectType.SETUP,
					name: "addUsers",
					displayName: "Add Users",
					description: "Add Users",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.BEGIN_EDIT,
						Staging.StagingType.EDIT_STAGE
					],
					sequenceOrder: 114
					).save(flush: true)

			def setupStage4 = new Staging(entity: Staging.StagingObjectType.SETUP,
					name: "geos",
					displayName: "Create GEOs",
					description: "Create GEOs",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.BEGIN_EDIT,
						Staging.StagingType.EDIT_STAGE
					],
					sequenceOrder: 113
					).save(flush: true)


			def setupStage5 = new Staging(entity: Staging.StagingObjectType.SETUP,
					name: "deliveryRoles",
					displayName: "Create DeliveryRoles",
					description: "Create DeliveryRoles",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.BEGIN_EDIT,
						Staging.StagingType.EDIT_STAGE
					],
					sequenceOrder: 115
					).save(flush: true)

			def setupStage6 = new Staging(entity: Staging.StagingObjectType.SETUP,
					name: "portfolios",
					displayName: "Create Portfolios",
					description: "Create Portfolios",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.BEGIN_EDIT,
						Staging.StagingType.EDIT_STAGE
					],
					sequenceOrder: 116
					).save(flush: true)


			
			def setupStagList = Staging.findAll("from Staging st where st.entity = :entity and :stage in elements(st.types) order by sequenceOrder desc",
					[entity: Staging.StagingObjectType.SETUP, stage: Staging.StagingType.NEW_STAGE])

			setupStagList.each() { println " ${it.sequenceOrder} - ${it.name} - ${it.types}" };
		}
		else
		{
			def usersStage = Staging.findByName("addUsers")
			if(usersStage.sequenceOrder != 114)
			{
				usersStage.sequenceOrder = 114
				usersStage.save()
			}
			
			def geoStage = Staging.findByName("geos")
			if(geoStage.sequenceOrder != 113)
			{
				geoStage.sequenceOrder = 113
				geoStage.save()
			}
		}
		
	}
	
	void addServiceQuotationStages()
	{
		def serviceQuotationStages = Staging.findAll("from Staging st where st.entity = :entity and :stage in elements(st.types) order by sequenceOrder desc",
			[entity: Staging.StagingObjectType.SERVICEQUOTATION, stage: Staging.StagingType.NEW_STAGE])

		if(serviceQuotationStages.size()==0)
		{
			def stage1 = new Staging(entity: Staging.StagingObjectType.SERVICEQUOTATION,
					name: "new",
					displayName: "New",
					description: "New ServiceQuotation",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.BEGIN_NEW
					],
					sequenceOrder: 121
					).save(flush: true)
	
			def stage2 = new Staging(entity: Staging.StagingObjectType.SERVICEQUOTATION,
					name: "active",
					displayName: "Active",
					description: "Active ServiceQuotation",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.BEGIN_EDIT,
						Staging.StagingType.EDIT_STAGE
					],
					sequenceOrder: 122
					).save(flush: true)
	
			def stage3 = new Staging(entity: Staging.StagingObjectType.SERVICEQUOTATION,
					name: "edit",
					displayName: "Edit",
					description: "Edit ServiceQuotation",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.BEGIN_EDIT,
						Staging.StagingType.EDIT_STAGE
					],
					sequenceOrder: 123
					).save(flush: true)
	
			def stage4 = new Staging(entity: Staging.StagingObjectType.SERVICEQUOTATION,
					name: "delete",
					displayName: "Delete",
					description: "Delete ServiceQuotation",
					types: [
						Staging.StagingType.NEW_STAGE,
						Staging.StagingType.END_REMOVE,
						Staging.StagingType.REMOVE_STAGE,
						Staging.StagingType.EDIT_STAGE
					],
					sequenceOrder: 124
					).save(flush: true)
	
	
				
			def setupStagList = Staging.findAll("from Staging st where st.entity = :entity and :stage in elements(st.types) order by sequenceOrder desc",
					[entity: Staging.StagingObjectType.SERVICEQUOTATION, stage: Staging.StagingType.NEW_STAGE])
	
			setupStagList.each() { println " ${it.sequenceOrder} - ${it.name} - ${it.types}" };
		}
	}
	
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	

	void tmpDatabaseFixes()
	{
		//Check if expense is null and replace with 0
		for(Quotation q in Quotation.list()){
			if(q.expenseAmount == null){
				q.expenseAmount = 0;
				q.description = "Default Expense"
				q.save(flush: true)
			}
		}

		for(Account ac in Account.list())
		{
			phoneNumberService.databaseFix(ac, "Account")
		}

		for(Contact ct in Contact.list())
		{
			phoneNumberService.databaseFix(ct, "Contact")
		}

		for(Lead ld in Lead.list())
		{
			phoneNumberService.databaseFix(ld, "Lead")
		}

	}

	void initializeRoles()
	{
		if(getBootstrapRevision() == 0){
			// Spring Security Core uses role authority strings with ROLE_ prefix.
			// No Shiro WildcardPermissions needed — access is controlled by interceptUrlMap in Config.groovy.
			def roles = [
				[authority: 'ROLE_SYSTEM_ADMINISTRATOR',  description: 'System Administrator',  code: RoleId.ADMINISTRATOR.code],
				[authority: 'ROLE_PORTFOLIO_MANAGER',     description: 'Portfolio Manager',      code: RoleId.PORTFOLIO_MANAGER.code],
				[authority: 'ROLE_PRODUCT_MANAGER',       description: 'Product Manager',        code: RoleId.PRODUCT_MANAGER.code],
				[authority: 'ROLE_SERVICE_DESIGNER',      description: 'Service Designer',       code: RoleId.SERVICE_DESIGNER.code],
				[authority: 'ROLE_SALES_PRESIDENT',       description: 'Sales President',        code: RoleId.SALES_PRESIDENT.code],
				[authority: 'ROLE_SALES_MANAGER',         description: 'Sales Manager',          code: RoleId.SALES_MANAGER.code],
				[authority: 'ROLE_SALES_PERSON',          description: 'Sales Person',           code: RoleId.SALES_PERSON.code],
				[authority: 'ROLE_DELIVERY_ROLE_MANAGER', description: 'Delivery Role Manager',  code: RoleId.DELIVERY_ROLE_MANAGER.code],
				[authority: 'ROLE_GENERAL_MANAGER',       description: 'General Manager',        code: RoleId.GENERAL_MANAGER.code],
			]

			roles.each { rd ->
				userManagementService.findOrCreateRole(rd.authority, rd.description, rd.code)
			}
		}
	}

	void insertDemoData()
	{
		// Demo data insertion is disabled (isDemo = false).
		// If demo mode is re-enabled, this method needs to be rewritten using
		// UserManagementService and UserRole.create() instead of Nimble InstanceGenerator.
	}


	/**
	 * Creates the default admin users on first startup if they do not already exist.
	 * Replaces the user creation that was previously handled by NimbleBootStrap.groovy.
	 */
	void createDefaultUsers()
	{
		Role adminRole = Role.findByAuthority('ROLE_SYSTEM_ADMINISTRATOR')
		if (!adminRole) {
			log.warn("ROLE_SYSTEM_ADMINISTRATOR not found — skipping default user creation")
			return
		}

		[
			[username: 'admin',      password: 'admiN123!', fullName: 'Administrator',       email: 'rlsar.valent2010@gmail.com'],
			[username: 'superadmin', password: 'admiN123!', fullName: 'Super Administrator',  email: null],
		].each { ud ->
			if (!User.findByUsername(ud.username)) {
				User u = userManagementService.createUser(ud.username, ud.password, ud.fullName, ud.email)
				if (u.hasErrors()) {
					u.errors.each { log.error(it) }
					throw new RuntimeException("Error creating default user: ${ud.username}")
				}
				userManagementService.assignRole(u, adminRole)
			}
		}

		// 'nobody' user gets all roles — used as a catch-all in internal queries.
		if (!User.findByUsername('nobody')) {
			User nobody = userManagementService.createUser('nobody', 'admiN123!', 'No Body', null)
			if (nobody.hasErrors()) {
				nobody.errors.each { log.error(it) }
				throw new RuntimeException("Error creating nobody user")
			}
			Role.list().each { role -> userManagementService.assignRole(nobody, role) }
		}
	}

	int getBootstrapRevision(){
		InternalMap map = InternalMap.findByTypeAndInternalKey("bootstrap", "revision")
		if(map == null){
			return 0
		} else{
			return Integer.parseInt(map.value);
		}
	}


	void setBootstrapRevision(int val){
		InternalMap map = InternalMap.findByTypeAndInternalKey("bootstrap", "revision")
		if(map == null){
			map = new InternalMap(type: "bootstrap", internalKey: "revision", value: val);
		}else{
			map.value = val;
		}
		map.save(flush: true);
	}
	
	void deleteQuota()
	{
		for(Quota q : Quota.list())
		{
			q.delete(flush: true)
		}
	}

	def destroy = {
		if(timer != null){
			timer.stop();
		}
	}
}

