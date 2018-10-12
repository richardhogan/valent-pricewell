package com.valent.pricewell

import java.util.Date;
import java.util.Map;
import org.apache.shiro.SecurityUtils

class SalesforceCatalogService {

    static transactional = true

    def serviceMethod() {

    }
	def dateService
	
	public Map opportunityStageMap = ["Prospecting": "prospecting", "Qualification": "qualification", "Needs Analysis": "needAnalysis", "Value Proposition": "needAnalysis", "Id. Decision Makers": "needAnalysis", "Perception Analysis": "needAnalysis", "Proposal/Price Quote": "proposalPriceQuote", "Negotiation/Review": "negotiationReview", "Closed Won": "closedWon", "Closed Lost": "closedLost" ]
	
	public Map getOpportunityFieldsMap()
	{
		Map opportunityFieldsMap = ['Id': 'externalId', 'Name': 'name', 'AccountId': 'accountId', 'sowPrice__c': 'amount', 'CloseDate': 'closeDate', 'Description':'description', 'ExpectedRevenue':'expectedRevenue', 'Type':'type', 'StageName':'stageName', 'Probability': 'probability', 'LastModifiedDate': 'dateModified', 'CreatedDate': 'dateCreated']
	}
	
	public boolean isSalesforceCredentialsAvailable()
	{
		if(SalesforceCredentials?.list()?.size() > 0)
		{
			return true
		}
		return false
	}
	
	public UpdateRecord getLastUpdateDateOfSalesforceImportOpportunity()
	{
		List lastUpdatedRecord = UpdateRecord.findAll("FROM UpdateRecord ur WHERE ur.recordType='salesforceImportOpportunity' ORDER BY dateCreated DESC")
		if(lastUpdatedRecord?.size() > 0)
		{
			return lastUpdatedRecord.first()
		}
		return null
	}
	
	public void saveUpdateRecordForSalesforceImportOpportunity(Date fromDate, Date toDate, String comments, String sourceFrom)
	{
		User user = null
		if(sourceFrom == "regularInterval")
		{
			user = User.findByUsername("admin")
		}
		else
		{
			user = User.get(new Long(SecurityUtils.subject.principal))
		}
		
		UpdateRecord importOpportunity = new UpdateRecord()
		importOpportunity.beginUpdateDate = fromDate
		importOpportunity.lastUpdateDate = toDate
		importOpportunity.recordType = "salesforceImportOpportunity"
		importOpportunity.updatedBy = user
		importOpportunity.comments = comments
		importOpportunity.dateCreated = new Date()
		
		importOpportunity.save()
		
	}
	
	public String generateMessage(def totalImported)
	{
		if(totalImported == 0)
		{
			return "There is no more opportunity to import now."//coming in specified filter criteria."
		}
		else if(totalImported == 1)
		{
			return "Only 1 opportunity has been imported."// within specified filter criteria."
		}
		else if(totalImported > 1)
		{
			return "Total "+ totalImported +" opportunities have been imported."// within specified filter criteria."
		}
	}
	
	public String generateFailureMessage(String errorMessage)
	{
		/*if(errorMessage != null)
		{
			if(errorMessage.contains("Cannot find company in salesforce"))
			{
				return "Invalid Company ID field. Please correct it first."
			}
			else if(errorMessage.contains("Username or password is incorrect"))
			{
				return  "Login ID or Password is incorrect. Please correct it first."
			}
			else if(errorMessage.contains("Failed to create service"))
			{
				return "Invalid URL field. Please correct it first."
			}
			else
			{
				return "Failed to import opportunities from Connecwise."
			}
		}
		else
		{*/
			return "Failed to import opportunities from Salesforce."
		//}
	}
	
	def removeFractionalSecondsAndTimeZone(String dateString)
	{
		def length = dateString.length()
		return dateString.substring(0, length-5)
	}
	
	public BillingAddress getAccountBillingAddress(Map accountMap)
	{
		BillingAddress billingAddressInstance = new BillingAddress()
		billingAddressInstance.billAddressLine1 = accountMap['BillingStreet']
		billingAddressInstance.billAddressLine2 = ""
		billingAddressInstance.billCity = accountMap['BillingCity']
		billingAddressInstance.billState = accountMap['BillingState']
		billingAddressInstance.billCountry = accountMap['BillingCountry']
		billingAddressInstance.billPostalcode = accountMap['BillingPostalCode']
		
		billingAddressInstance.save()
		return billingAddressInstance
	}
	
	public BillingAddress getContactBillingAddress(Map contactMap)
	{
		BillingAddress billingAddressInstance = new BillingAddress()
		billingAddressInstance.billAddressLine1 = contactMap['MailingStreet']
		billingAddressInstance.billAddressLine2 = ""
		billingAddressInstance.billCity = contactMap['MailingCity']
		billingAddressInstance.billState = contactMap['MailingState']
		billingAddressInstance.billCountry = contactMap['MailingCountry']
		billingAddressInstance.billPostalcode = contactMap['MailingPostalCode']
		
		billingAddressInstance.save()
		return billingAddressInstance
	}
	
	public ShippingAddress getAccountShippingAddress(Map accountMap)
	{
		ShippingAddress shippingAddressInstance = new ShippingAddress()
		shippingAddressInstance.shipAddressLine1 = accountMap['ShippingStreet']
		shippingAddressInstance.shipAddressLine2 = ""
		shippingAddressInstance.shipCity = accountMap['ShippingCity']
		shippingAddressInstance.shipState = accountMap['ShippingState']
		shippingAddressInstance.shipCountry = accountMap['ShippingCountry']
		shippingAddressInstance.shipPostalcode = accountMap['ShippingPostalCode']
		
		shippingAddressInstance.save()
		return shippingAddressInstance
	}
	
	public Opportunity putOpportunityData(Map opportunityMap)
	{
		Opportunity opportunity = new Opportunity()
		opportunity.name = opportunityMap['Name']
		opportunity.amount = (opportunityMap['sowPrice__c'] != "" && opportunityMap['sowPrice__c'] != null) ? Double.valueOf(opportunityMap['sowPrice__c']) : new Double(0)//.toDouble()
		opportunity.closeDate = dateService.getDate("yyyy-MM-dd", opportunityMap["CloseDate"])
		opportunity.dateCreated = dateService.getDate("yyyy-MM-dd'T'HH:mm:ss", removeFractionalSecondsAndTimeZone(opportunityMap["CreatedDate"]))
		opportunity.dateModified = dateService.getDate("yyyy-MM-dd'T'HH:mm:ss", removeFractionalSecondsAndTimeZone(opportunityMap["LastModifiedDate"]))
		opportunity.externalId = opportunityMap['Id']
		opportunity.externalSource = "salesforceImport"
		
		if(opportunityMap['Probability'] != null && opportunityMap['Probability'] != "")
		{
			def dotIndex = opportunityMap['Probability'].indexOf(".")
			def probability = opportunityMap['Probability'].substring(0, dotIndex)
			opportunity.probability = Integer.parseInt(probability)//.toInteger()
		}
		else
		{
			opportunity.probability = new Integer(10)//.toInteger()
		}
		
		Staging opStage = getOpportunityStage(opportunityMap['StageName'])
		opportunity.stagingStatus = opStage//getOpportunityStage(opportunityMap['StageName'])
		
		return opportunity
	}
	
	public Staging getOpportunityStage(String stageName)
	{
		Staging stagingStatus = Staging.findByName(opportunityStageMap[stageName])
		
		if(stagingStatus)
		{
			println "coming inside"
			return stagingStatus
		}
		else
		{
			println "coming other side"
			return Staging.findByName("prospecting")
		}
	}
	
	public boolean checkOpportunityDate(Map importMap, Map opportunityMap)
	{
		boolean isValid = false
		Date endDate = importMap['endDate']
		
		Date modifiedDate = dateService.getDate("yyyy-MM-dd'T'HH:mm:ss", removeFractionalSecondsAndTimeZone(opportunityMap["LastModifiedDate"]))
		
		if(importMap['startDate'] != null)
		{
			Date startDate = importMap['startDate']
			
			if(modifiedDate <= endDate && modifiedDate >= startDate)
			{
				isValid = true
			}
		}
		else
		{
			if(modifiedDate <= endDate)
			{
				isValid = true
			}
		}
		return isValid
	}
	
	public Account putAccountData(Map accountMap)
	{
		Account account = new Account()
		account.accountName = accountMap["Name"]
		account.dateCreated = dateService.getDate("yyyy-MM-dd'T'HH:mm:ss", removeFractionalSecondsAndTimeZone(accountMap["CreatedDate"]))
		account.dateModified = dateService.getDate("yyyy-MM-dd'T'HH:mm:ss", removeFractionalSecondsAndTimeZone(accountMap["LastModifiedDate"]))
		account.externalId = accountMap["Id"]
		account.externalSource = "salesforceImport"
		account.phone = accountMap["Phone"]
		account.fax = accountMap["Fax"]
		account.website = accountMap["Website"]
		account.type = accountMap["Type"]
		account.billingAddress = getAccountBillingAddress(accountMap)
		account.shippingAddress = getAccountShippingAddress(accountMap)
		
		account.save()
		
		return account
	}
	
	public Contact putContactData(Map contactMap)
	{
		Contact contact = new Contact()
		contact.firstname = contactMap["FirstName"]
		contact.lastname = contactMap["LastName"]
		contact.dateCreated = dateService.getDate("yyyy-MM-dd'T'HH:mm:ss", removeFractionalSecondsAndTimeZone(contactMap["CreatedDate"]))
		contact.dateModified = dateService.getDate("yyyy-MM-dd'T'HH:mm:ss", removeFractionalSecondsAndTimeZone(contactMap["LastModifiedDate"]))
		contact.externalId = contactMap["Id"]
		contact.externalSource = "salesforceImport"
		contact.mobile = contactMap["MobilePhone"]
		contact.title = contactMap["Title"]
		contact.phone = contactMap["Phone"]
		contact.fax = contactMap["Fax"]
		contact.email = contactMap["Email"]
		contact.department = contactMap["Department"]
		contact.billingAddress = getContactBillingAddress(contactMap)
		
		//contact.save()
		
		return contact
	}
	
	public boolean checkOpportunityExist(String name, String externalId)
	{
		boolean isExist = false
		
		def opportunity = Opportunity.findByNameAndExternalId(name, externalId)
		if(opportunity != null)
		{
			isExist = true
		}
		
		return isExist
	}
	
	public boolean checkAccountExist(String name, String externalId)
	{
		boolean isExist = false
		
		def account = Account.findByAccountNameAndExternalId(name, externalId)
		if(account != null)
		{
			isExist = true
		}
		
		return isExist
	}
	
	public boolean checkContactExist(String externalId)
	{
		boolean isExist = false
		
		def contact = Contact.findByExternalId(externalId)
		if(contact != null)
		{
			isExist = true
		}
		
		return isExist
	}
}
