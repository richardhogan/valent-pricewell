package com.valent.pricewell


import org.apache.shiro.SecurityUtils
import org.springframework.context.MessageSource

import com.valent.pricewell.cw15.SalesforceOpportunityImportTimer


class SfimportService {

	static transactional = true

	def salesforceExportService, dateService, salesforceCatalogService,sendMailService
	SalesforceOpportunityImportTimer newImportTimer
	
	def serviceMethod() {

	}
	
	public Map getCredentials()
	{
		SalesforceCredentials sCredentials = null
		for(SalesforceCredentials sc : SalesforceCredentials.list())
		{
			sCredentials = sc
			break;
		}
		
		Map salesforceCredentialsMap = [:]
		salesforceCredentialsMap["username"] = sCredentials.username
		salesforceCredentialsMap["password"] = sCredentials.password
		salesforceCredentialsMap["instanceUri"] = sCredentials.instanceUri
		salesforceCredentialsMap["securityToken"] = sCredentials.securityToken
		return salesforceCredentialsMap
	}
	
	public Map sendSFToPricewellOpportunityImportNotification(MessageSource messageSource, Opportunity opportunity, User user)
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
		
		note.message = messageSource.getMessage("notification.opportunityImportFromSFSuccess", args, Locale.getDefault())//g.message(code: "notification.opportunityImportFromSFSuccess", args: ["${opportunity.name}"]);
		String subject = messageSource.getMessage("notification.opportunityImportFromSFSuccess.email.subject", new Object[0], Locale.getDefault())//g.message(code: "notification.opportunityImportFromSFSuccess.email.subject");
		String emailMessage = messageSource.getMessage("notification.opportunityImportFromSFSuccess.email.message", args, Locale.getDefault())//g.message(code: "notification.opportunityImportFromSFSuccess.email.message", args: ["${opportunity.name}"]);
		
		
		note.save(flush:true)
		if(note.receiverUsers.size() > 0)
		{
			return ["message": emailMessage, "subject": subject, "receiverList": note.receiverUsers]
			//sendEmailNotification(note.message, subject, note.receiverUsers)
		}
		return []
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
			//comment = "Total number of opportunity imported : "+importedOpportunities?.size()
			salesforceCatalogService.saveUpdateRecordForSalesforceImportOpportunity(startDate, endDate, "Total number of opportunity imported : "+importedOpportunities?.size(), "regularInterval")
		}
		/*else
		{
			comment = "There is no more opportunity to import."
		}*/
		
		def totalImported = 0
		for(Opportunity opp : importedOpportunities)
		{
			def user = User.findByUsername("admin")//get(new Long(SecurityUtils.subject.principal))
			def map = sendSFToPricewellOpportunityImportNotification(messageSource, opp, user)//new NotificationGenerator(g).sendCWToPricewellOpportunityImportNotification(opp, user);
			sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], siteUrl+"/opportunity/show/"+opp.id)
			totalImported++
		}
	}
	
	public void importOpportunities(SalesforceOpportunityImportTimer sfimportTimer)
	{
		newImportTimer = new SalesforceOpportunityImportTimer(sfimportTimer.sfimportService, sfimportTimer.grailsApplication, sfimportTimer.messageSource)
		
		Object g = sfimportTimer.grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')
		String siteUrl = sfimportTimer.grailsApplication.config.grails.serverURL
		MessageSource messageSource = sfimportTimer.messageSource
		sfimportTimer.push()
		Map importMap = new HashMap()
		Date startDate = null, endDate = null
		UpdateRecord lastUpdateRecord = salesforceCatalogService.getLastUpdateDateOfSalesforceImportOpportunity()
		
		importMap['endDate'] = new Date()
		startDate = lastUpdateRecord?.lastUpdateDate!=null?lastUpdateRecord?.lastUpdateDate-1:null
		importMap['startDate'] = startDate
		
		if(salesforceCatalogService.isSalesforceCredentialsAvailable() && startDate != null)
		{
			try{
				Map responseMap = importOpportunities(importMap, "regulaInterval")
				saveOpportunityImportResponse(messageSource, siteUrl, responseMap, importMap['startDate']+1, importMap['endDate'] )	//g
			}
			catch(Exception e)
			{
				e.printStackTrace(System.out);
				String failureMessage = salesforceCatalogService.generateFailureMessage(e.getMessage())
				println failureMessage
			}
		}
		newImportTimer.resume()
	}
	
	public Map importOpportunities(Map importMap, String sourceFrom)
	{
		List imported = new ArrayList(), existed = new ArrayList(), updated = new ArrayList()
		Map dataMap = [:]
		User user = null
		if(sourceFrom == "regulaInterval")
		{
			user = User.findByUsername("admin")
		}
		else
		{
			user = User.get(new Long(SecurityUtils.subject.principal))
		}
		
		dataMap['credentials'] = getCredentials()
		dataMap['startDate'] = importMap["startDate"]//startDate
		dataMap['endDate'] = importMap["endDate"]//endDate
		
		List opportunityListMap = salesforceExportService.exportOpportunities(dataMap['credentials'], dataMap['startDate'])
		for(Map opportunityMap : opportunityListMap)
		{

			boolean isValid = salesforceCatalogService.checkOpportunityDate(importMap, opportunityMap)
			boolean isOpportunityExist = salesforceCatalogService.checkOpportunityExist(opportunityMap["Name"], opportunityMap["Id"])
			
			if(!isOpportunityExist && isValid)
			{
				Account account = null
				Geo geo = null
				
				 String accountId = opportunityMap["AccountId"]
				 List accountList = salesforceExportService.getAccountFromId(dataMap['credentials'], accountId)
				 for(Map accountMap : accountList)
				 {
					 boolean isAccountExist = salesforceCatalogService.checkAccountExist(accountMap["Name"], accountMap["Id"])
					 if(!isAccountExist)
					 {
						 account = createAccount(accountMap)
						 account.assignTo = account.createdBy = account.modifiedBy = user
						 account.save()
					 }
					 else
					 {
						 account = Account.findByAccountNameAndExternalId(accountMap["Name"], accountMap["Id"])
					 }
					 
					 List contactList = salesforceExportService.getContactListFromAccountId(dataMap['credentials'], accountId)
					 for(Map contactMap : contactList)
					 {
						 boolean isContactExist = salesforceCatalogService.checkContactExist(contactMap["Id"])
						 if(!isContactExist)
						 {
							 Contact contact = createContact(contactMap)
							 contact.assignTo = contact.createdBy = contact.modifiedBy = user
							 contact.account = account
							 contact.save()
						 }
						 
					 }
				 }
				 //println  "Contacts : " + salesforceExportService.getContactListFromAccountId(accountId)
				 
				
				//--------------Add Opportunity Data----------------------------------------------
				Opportunity opportunity = createOpportunity(opportunityMap)
				opportunity.createdBy = opportunity.modifiedBy = opportunity.assignTo = user;
				opportunity.account = account
				opportunity.geo = (user?.primaryTerritory != null ? user?.primaryTerritory : user?.territory)
				
				if(opportunity.save())
				{
					imported.add(opportunity)
				}
				
			}
			else if(isOpportunityExist && isValid)
			{
				Opportunity op = Opportunity.findByExternalId(opportunityMap["Id"])
				
				/*def amount = (opportunityMap['Amount'] != "" && opportunityMap['Amount'] != null) ? Double.valueOf(opportunityMap['Amount']) : new Double(0)//.toDouble()
				if(op.amount != amount)//Double.valueOf(opportunityMap["Amount"]))//?.toDouble())
				{
					//compare two dates one of salesforce and one of pricewell and whichever is later
					op.amount = amount//Double.valueOf(opportunityMap["Amount"])//?.toDouble()
					op.save()
					updated.add(op)
				}
				else*/ existed.add(op)
			}
		}
		
		/*opportunityTerritoryMap.put("opportunityList", opportunityList)
		opportunityTerritoryMap.put("opportunityIds", opportunityIds)
		opportunityTerritoryMap.put("territoryList", nonExistTerritoryList)
		println "count : "+countUnavailableTerritory*/
		Map responseMap = new HashMap()
		responseMap.put("imported", imported)
		responseMap.put("existed", existed)
		responseMap.put("updated", updated)
		//responseMap.put('opportunityTerritoryMap', opportunityTerritoryMap)
		//responseMap.put("countUnavailableTerritory", countUnavailableTerritory)

		return responseMap
	}
	
	public Account createAccount(Map accountMap)
	{
		//--------------Add Account Data----------------------------------------------
			Account account = salesforceCatalogService.putAccountData(accountMap)
			return account
		//--------------------------------------------------------------------------------
	}
	
	public Contact createContact(Map contactMap)
	{
		//--------------Add Contact Data----------------------------------------------
			Contact contact = salesforceCatalogService.putContactData(contactMap)
			return contact
		//--------------------------------------------------------------------------------
	}
	
	public Opportunity createOpportunity(Map opportunityMap)
	{
		//--------------Add Contact Data----------------------------------------------
			Opportunity opportunity = salesforceCatalogService.putOpportunityData(opportunityMap)
			return opportunity
		//---------------------------------------------------------------------------------
	}
	
}