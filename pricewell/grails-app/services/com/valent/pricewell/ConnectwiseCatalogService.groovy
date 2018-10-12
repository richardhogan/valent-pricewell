package com.valent.pricewell

import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.xml.datatype.XMLGregorianCalendar;

import org.apache.shiro.SecurityUtils

import com.valent.pricewell.cw15.*

import cw.ContactFindResult
import cw15.*

class ConnectwiseCatalogService {

    static transactional = true
	def dateService

    def serviceMethod() {

    }
	
	public boolean isConnectwiseCredentialsAvailable()
	{
		if(ConnectwiseCredentials?.list()?.size() > 0)
		{
			return true
		}
		return false
	}
	
	public String generateFailureMessage(String errorMessage)
	{
		log.error "[Log Time: ${new Date()}] - Error: ${errorMessage}"
		if(errorMessage != null)
		{
			if(errorMessage.contains("Cannot find company in connectwise"))
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
		{
			return "Failed to import opportunities from Connecwise."
		}
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
	
	public List generateOpportunityIdsList(String opportunityIds)
	{
		List ids = new ArrayList()
		String idString = opportunityIds.replace("[", "").replace("]", "")
		
			if(idString.contains(","))
			{
				List listOfIds = idString.split("\\,")
				for(String id : listOfIds)
				{
					ids.add(id.replaceFirst(" ", ""))
				}
			}
			else
			{
				ids.add(idString)
			}
		
		return ids
	}
	
	public List generateStatusList(String status)
	{
		List allowedStatus = new ArrayList()
		def defaultStatus = "Open"
		if(status.size() == 0)
		{
			allowedStatus.add(defaultStatus)
		}
		else
		{
			if(status.contains(","))
			{
				List statusList = status.replace("[", "").replace("]", "").split("\\,")
				for(String sts : statusList)
				{
					allowedStatus.add(sts.replaceFirst(" ", ""))
				}
			}
			else
			{
				allowedStatus.add(status)
			}
		}
		
		return allowedStatus
	}
	
	public List generateStageList(String stage)
	{
		List allowedStage = new ArrayList()
		def defaultStage = "1.Prospect"
		if(stage.size() == 0)
		{
			allowedStage.add(defaultStage)
		}
		else
		{
			if(stage.contains(","))
			{
				List stageList = stage.replace("[", "").replace("]", "").split("\\,")
				for(String stg : stageList)
				{
					allowedStage.add(stg.replaceFirst(" ", ""))
				}
			}
			else
			{
				allowedStage.add(stage)
			}
		}
		
		return allowedStage
	}
	
	public List generateProductTypeList(String productTags)
	{
		List allowedTags = new ArrayList()
		def defaultTag = "Service"
		if(productTags.size() == 0)
		{
			allowedTags.add(defaultTag)
		}
		else
		{
			if(productTags.contains(","))
			{
				List tagList = productTags.replace("[", "").replace("]", "").split("\\,")
				for(String tag : tagList)
				{
					allowedTags.add(tag.replaceFirst(" ", ""))
				}
			}
			else
			{
				allowedTags.add(productTags)
			}
		}
		
		return allowedTags
	}
	
	public List generateEstimateTypeList(String estimateType)
	{
		List allowedTypes = new ArrayList()
		def defaultTag = "S"
		if(estimateType.size() == 0)
		{
			allowedTypes.add(defaultTag)
		}
		else
		{
			if(estimateType.contains(","))
			{
				List tagList = estimateType.replace("[", "").replace("]", "").split("\\,")
				for(String tag : tagList)
				{
					String type = tag.replaceFirst(" ", "")
					println type
					
					allowedTypes.add(getFormatedType(type))
				}
			}
			else
			{
				allowedTypes.add(getFormatedType(estimateType))
			}
		}
		
		return allowedTypes
	}
	
	public String getFormatedType(String type)
	{
		if(type == "Product")
		{
			type = "P"
		}
		else if(type == "Service")
		{
			type = "S"
		}
		else if(type == "Agreement")
		{
			type = "A"
		}
		else if(type == "Managed Service" || type == "ManagedService")
		{
			type = "O1"
		}
		else if(type == "Other")
		{
			type = "O2"
		}
		return type
	}
	
	public Date convertDate(XMLGregorianCalendar calendar){
		if(calendar == null) {
			return null;
		}
		
		return calendar.toGregorianCalendar().getTime();
	}

	public boolean checkOpportunityDate(Map importMap, OpportunityListItem opLItem)
	{
		boolean isValid = false
		Date endDate = importMap['endDate']
		
		Date modifiedDate = convertDate(opLItem.lastUpdate)
		
		if(importMap['startDate'] != null)
		{
			Date startDate = importMap['startDate']
			
			if(modifiedDate.before(endDate) && modifiedDate.after(startDate))
			{
				isValid = true
			}
		}
		else
		{
			if(modifiedDate.before(endDate))
			{
				isValid = true
			}
		}
		return isValid
	}
	
	public boolean checkOpportunityExist(String externalId)
	{
		boolean isExist = false
		
		Opportunity opportunity = Opportunity.findByExternalId(externalId)
		if(opportunity != null)
		{
			log.info "[Log Time: ${new Date()}] - Opportunity ${opportunity.name} is already exist."
			isExist = true
		}
		
		return isExist
	}
	
	public boolean checkAccountExist(String externalId)
	{
		boolean isExist = false
		
		def account = Account.findByExternalId(externalId)
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
	
	public double getForecastRevenue(cw15.Opportunity opportunity, Map forecastMap)
	{
		def revenue = 0
		//List<Integer> productIds = forecastMap['productIds']
		List<String> estimateTypes = forecastMap['allowedEstimateTypes']
		//List<String> forecastStatus = forecastMap['allowedForecastStatus']
		
		/*ArrayOfOpportunityItem oppItems = opportunity.getOpportunityItems()
		for(OpportunityItem opItem : oppItems.getOpportunityItem())
		{
			//println "Item Id : "+opItem.getItemId()
			if(productIds.contains(opItem.getItemId()))
			{
				revenue = revenue + opItem.getPrice()
			}
		}*/
		
		ArrayOfForecastDetail forecastDetails = opportunity.getForecastDetails();
		for(ForecastDetail fd : forecastDetails.getForecastDetail())
		{
			if(estimateTypes.contains(fd.getForecastType()) && /*forecastStatus.contains(fd.getStatus()) &&*/ fd.included == true)
			{
				revenue = revenue + fd.getRevenue()
			}
			//System.out.println("forecast type of estimate : " + fd.getForecastType()+" revenue : "+fd.getRevenue() + " cost : "+fd.getCost());
		}
		
		return revenue.toDouble()
	}
	
	public void addContactsInAccount(Account account, List <ContactFindResult>companyContacts)
	{
		//println "contact count : "+companyContacts.size()
		def user = User.findByUsername("admin")//User.get(new Long(SecurityUtils.subject.principal))
		CWContactToContactMapper contactMapper = new CWContactToContactMapper();
		for(ContactFindResult contact : companyContacts)
		{
			Contact ct = Contact.findByExternalId(contact.getId().toString())
			if(ct == null)
			{
				log.info "[Log Time: ${new Date()}] - Importing contact details : ${contact.getFirstName()} ${contact.getLastName()} with external Id : ${contact.getId().toString()}"
				Contact newContact = contactMapper.map(contact, Contact.class)
				newContact.createdBy = newContact.modifiedBy = newContact.assignTo = user
				newContact.billingAddress = getContactAddress(contact)
				newContact.externalId = contact.getId().toString()
				newContact.account = account
				
				if(!newContact.hasErrors() && newContact.save())
				{
					log.info "[Log Time: ${new Date()}] - Contact saved successfully."
				}
				else
				{
					log.info "[Log Time: ${new Date()}] - Saving Contact create errors."
					log.error "Errors : " + newContact.errors.allErrors
					
					newContact.errors.allErrors.each {
						println it
					}
				}
			}
			else
			{
				log.info "[Log Time: ${new Date()}] - Contact : ${contact.getFirstName()} ${contact.getLastName()} is already available in Valent Software."
			}
			
			//account.addToContacts(newContact)
			//printContactDetails(newContact)
		}
		//account.save()
	}
	
	public void printContactDetails(Contact contact)
	{
		println "------------------ Contact "+contact.firstname + " " + contact.lastname + "Details ------------------"
		println "ExternalId : "+contact.externalId
	}
	
	public void printOpportunityDetails(Opportunity opportunity)
	{
		println "--------------- Opportunity "+opportunity.name+" Details---------------------"
		println "Date Modified : "+opportunity.dateModified
		println "Close Date : "+opportunity.closeDate
		println "Close Probability : "+opportunity.probability
		println "Stage : "+opportunity.stagingStatus.name
		println "Geo : "+opportunity.geo.name
		println "External Id : "+ opportunity.externalId
		println "Amount : "+opportunity.amount
		println "Account : "+opportunity.account.accountName
		
	}
	
	public void printAccountDetails(Account account)
	{
		println "-------------------- Account "+account.accountName+" Details ---------------------"
		println "External Id : "+account.externalId
		println "Type : "+account.type
		println "Address : "+account.billingAddress.billAddressLine1 + " " + account.billingAddress.billAddressLine2
	}
	
	public Account putAccountData(Account account)
	{
		def user = User.findByUsername("admin")//User.get(new Long(SecurityUtils.subject.principal))
		account.shippingAddress = new ShippingAddress().save()
		account.dateCreated = new Date()
		account.dateModified = new Date()
		account.createdBy = account.modifiedBy = account.assignTo = user
		
		return account
	}
	
	public String geCountry(String country)
	{
		if(country != "" && country != null && country != "NULL")
		{
			return country
		}
		else
		{
			for(CompanyInformation ci in CompanyInformation.list()) {
				return ci.shippingAddress.shipCountry
			}
		}
	}
	
	public BillingAddress getAccountAddress(CompanyFindResult company)
	{
		BillingAddress billingAddressInstance = new BillingAddress()
		billingAddressInstance.billAddressLine1 = company.getAddressLine1()
		billingAddressInstance.billAddressLine2 = company.getAddressLine2()
		billingAddressInstance.billCity = company.getCity()
		billingAddressInstance.billState = company.getState()
		billingAddressInstance.billCountry = geCountry(company.getCountry())
		billingAddressInstance.billPostalcode = company.getZip()
		
		//println "Country : " +billingAddressInstance.billCountry
		//println "2nd : "+ company.getCountry()
		billingAddressInstance.save()
		
		return billingAddressInstance
	}
	
	public BillingAddress getContactAddress(ContactFindResult contact)
	{
		BillingAddress billingAddressInstance = new BillingAddress()
		billingAddressInstance.billAddressLine1 = contact.getAddressLine1()
		billingAddressInstance.billAddressLine2 = contact.getAddressLine2()
		billingAddressInstance.billCity = contact.getCity()
		billingAddressInstance.billState = contact.getState()
		billingAddressInstance.billCountry = geCountry(contact.getCountry())
		billingAddressInstance.billPostalcode = contact.getZip()
		
		//println billingAddressInstance.billCountry
		billingAddressInstance.save()
		
		return billingAddressInstance
	}
	
	public boolean isTerritoryAvailable(String geoName)
	{
		def territory = Geo.findByName(geoName)
		
		if(territory?.id != null)
		{
			return true
		}
		return false
	}
	
	public Geo getTerritory(String geoName)
	{
		//def geoName = sowProperties['geoName']
		def territory = Geo.findByName(geoName)
		
		if(territory?.id != null)
		{
			println "geo exist"
			return territory
		}
		else
		{
			Geo territoryInstance = new Geo()
			
			territoryInstance.name = geoName
			territoryInstance.isExternal = "yes"
			
			def companyInformation
			def currency = "Money"
			if(CompanyInformation.list().size() > 0)
			{
				companyInformation = CompanyInformation.list().get(0)
				if(companyInformation.baseCurrency != null)
						currency = companyInformation.baseCurrency
				
			}
			
			territoryInstance.currency = currency
			
			territoryInstance.save()
			/*println geoInstance.name
			println geoInstance.isExternal*/
			return territoryInstance
		}
	}

	public List getFieldValue(ArrayOfResultRow arrayResultRow, String fieldName)
	{
		def resultArray = []
		for(ResultRow row : arrayResultRow.getResultRow())
		{
			for(FieldValue field : row.getValue())
			{
				if(field.name == fieldName)
				{
					resultArray.add(field.value)
				}
				
			}
			
		}
		return resultArray
	}
	
	public List printFieldValue(ArrayOfResultRow arrayResultRow, String fieldName)
	{
		def resultArray = []
		for(ResultRow row : arrayResultRow.getResultRow())
		{
			for(FieldValue field : row.getValue())
			{
				if(field.name == fieldName)
				{
					resultArray.add(field.value)
				}
				
				println field.name +"-------"+ field.value
			}
			
		}
		return resultArray
	}
	public ServiceTicket addContactDetail(ServiceTicket ticket, Contact contactInstance)
	{
		ticket.addressLine1 = contactInstance.billingAddress.billAddressLine1
		ticket.addressLine2 = contactInstance.billingAddress.billAddressLine2
		ticket.city = contactInstance.billingAddress.billCity
		ticket.stateId = contactInstance.billingAddress.billState
		ticket.zip = contactInstance.billingAddress.billPostalcode
		ticket.contactName = contactInstance.firstname + " " + contactInstance.lastname
		ticket.contactEmailAddress = contactInstance.email
		ticket.contactPhoneNumber = contactInstance.phone
		
		return ticket
	}
	
	public Map getTimestampForConnectwiseImportOpportunity()
	{
		Map opportunityTimeStamp = [:]
		opportunityTimeStamp['toDate'] = null
		opportunityTimeStamp['fromDate'] = null
		
		TimeStampSaverObject timeStamp = TimeStampSaverObject.findByObjectName("connectwiseImportOpportunity")
		if(timeStamp != null)
		{
			opportunityTimeStamp["toDate"] = timeStamp.toDate
			opportunityTimeStamp["fromDate"] = timeStamp.fromDate
		}
		
		return opportunityTimeStamp
	}
	
	public void saveTimestampForConnectwiseImportOpportunity(Date fromDate, Date toDate)
	{
		User user = User.findByUsername("admin")
		TimeStampSaverObject timeStamp = TimeStampSaverObject.findByObjectName("connectwiseImportOpportunity")
		if(timeStamp == null)
		{
			timeStamp = new TimeStampSaverObject()
			timeStamp.objectName = "connectwiseImportOpportunity"
			println "timestamp new created for import opportunity from connectwise"
		}
		else println "timestamp is already exist for import opportunity from connectwise"
		
		timeStamp.fromDate = fromDate
		timeStamp.toDate = toDate
		timeStamp.modifiedDate = new Date()
		timeStamp.modifiedBy = user
		timeStamp.save()
		
	}
	
	public UpdateRecord getLastUpdateDateOfConnectwiseImportOpportunity()
	{
		List lastUpdatedRecord = UpdateRecord.findAll("FROM UpdateRecord ur WHERE ur.recordType='connectwiseImportOpportunity' ORDER BY dateCreated DESC")
		if(lastUpdatedRecord?.size() > 0)
		{
			return lastUpdatedRecord.first()
		}
		return null
	}
	
	public void saveUpdateRecordForConnectwiseImportOpportunity(Date fromDate, Date toDate, String comments)
	{
		User user = User.findByUsername("admin")
		UpdateRecord importOpportunity = new UpdateRecord()
		importOpportunity.beginUpdateDate = fromDate
		importOpportunity.lastUpdateDate = toDate
		importOpportunity.recordType = "connectwiseImportOpportunity"
		importOpportunity.updatedBy = user
		importOpportunity.comments = comments
		importOpportunity.dateCreated = new Date()
		
		importOpportunity.save()
		
	}
	
	public Map getTimestampForServiceTicket()
	{
		Map serviceTicketTimeStamp = [:]
		serviceTicketTimeStamp['toDate'] = null
		
		TimeStampSaverObject timeStamp = TimeStampSaverObject.findByObjectName("serviceTicket")
		if(timeStamp != null)
		{
			serviceTicketTimeStamp["toDate"] = timeStamp.toDate
		}
		
		return serviceTicketTimeStamp
	}
	
	public void saveTimestampForServiceTicket(Date fromDate, Date toDate)
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))
		TimeStampSaverObject timeStamp = TimeStampSaverObject.findByObjectName("serviceTicket")
		if(timeStamp != null)
		{
			timeStamp.fromDate = fromDate
			timeStamp.toDate = toDate
			timeStamp.modifiedDate = new Date()
			timeStamp.modifiedBy = user
			timeStamp.save()
		}
		else
		{
			TimeStampSaverObject newTimeStamp = new TimeStampSaverObject()
			newTimeStamp.fromDate = fromDate
			newTimeStamp.toDate = toDate
			newTimeStamp.modifiedDate = new Date()
			newTimeStamp.modifiedBy = user
			newTimeStamp.objectName = "serviceTicket"
			newTimeStamp.save()
		}
	}
	
	public boolean checkServiceTicketDate(Date fromDate, Date toDate, Ticket ticket)
	{
		boolean isValid = false
		
		Date modifiedDate = dateService.convertFromXMLToGregorianCalendar(ticket.lastUpdateDate)
		Long modifiedMillis  = dateService.convertDateToMillisecond(modifiedDate)
		//println "midified millis : "+ modifiedMillis
		Long fromMillis = new Long(0)
		Long toMillis = new Long(0)
		
		if(fromDate != null)
		{
			fromMillis = dateService.convertDateToMillisecond(fromDate)
			//println "from millis : "+ fromMillis
		}
		if(toDate != null)
		{
			toMillis = dateService.convertDateToMillisecond(toDate)
			//println "to millis : "+ toMillis
		}
		//Date modifiedDate = convertDate(ticket.lastUpdateDate)//dateService.setDate(convertDate(ticket.lastUpdateDate))
		
		/*XMLGregorianCalendar modifiedCal = ticket.lastUpdateDate
		XMLGregorianCalendar fromCal = null
		XMLGregorianCalendar toCal = null*/
		if(fromDate != null && toDate != null)
		{
			/*fromCal = dateService.asXMLGregorianCalendar(fromDate)
			toCal = dateService.asXMLGregorianCalendar(toDate)*/
			//if(dateService.compareXmlGregorianCalendars(modifiedCal, fromCal)==1 && dateService.compareXmlGregorianCalendars(modifiedCal, toCal)==-1)
			if(modifiedMillis > fromMillis && modifiedMillis < toMillis)
			{
				//println modifiedCal
				isValid = true
			}
		}
		else if(fromDate != null)
		{
			
			//fromCal = dateService.asXMLGregorianCalendar(fromDate)
			//if(dateService.compareXmlGregorianCalendars(modifiedCal, fromCal)==1)
			if(modifiedMillis > fromMillis)
			{
				//println modifiedCal
				isValid = true
			}
		}
		else if(toDate != null)
		{
			//toCal = dateService.asXMLGregorianCalendar(toDate)
			//if(dateService.compareXmlGregorianCalendars(modifiedCal, toCal)==-1)
			if(modifiedMillis < toMillis)
			{
				//println modifiedCal
				isValid = true
			}
		}
		return isValid
	}
	
	
	public ServiceQuotationTicket createTicket(ServiceQuotation sq, ServiceActivity sa, DeliveryRole role, String summary, BigDecimal budgetHours, User user)
	{
		ServiceQuotationTicket ticket = new ServiceQuotationTicket()
		ticket.actualHours = new BigDecimal(0)
		ticket.budgetHours = budgetHours
		ticket.serviceActivity = sa
		ticket.role = role
		ticket.summary = summary
		ticket.serviceQuotation = sq
		ticket.createdDate = ticket.modifiedDate = new Date()
		ticket.createdBy = ticket.modifiedBy = user
		ticket.status = ServiceQuotationTicket.TicketStatusTypes.NEW
		ticket.save()
		return ticket
	}
	
	public void updateServiceQuotationTicket(Ticket ticket)
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))
		
		ServiceQuotationTicket sqTicket = ServiceQuotationTicket.findByTicketId(ticket.srServiceRecID)//findBySummary(ticket.summary)
		if(sqTicket)
		{
			println sqTicket.summary
			sqTicket.actualHours = ticket.actualHours
			sqTicket.status = ServiceQuotationTicket.TicketStatusTypes.CLOSED
			sqTicket.modifiedBy = user
			sqTicket.modifiedDate = new Date()
			sqTicket.save()
		}
	}
	
	public void updateReferenceTicketWithCWTicketId(Integer ticketId, String summary)
	{
		ServiceQuotationTicket sqTicket = ServiceQuotationTicket.findBySummary(summary)
		if(sqTicket)
		{
			println "Summary : "+summary+" ticketId : "+ticketId
			sqTicket.ticketId = ticketId
			sqTicket.save()
		}
	}
}
