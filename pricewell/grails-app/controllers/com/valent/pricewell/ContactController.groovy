package com.valent.pricewell
import org.apache.shiro.SecurityUtils
import org.codehaus.groovy.grails.commons.ConfigurationHolder
class ContactController {

	def salesServicesService
	def phoneNumberService
	def leadService
	def reviewService
	def salesCatalogService
	def sendMailService
    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}
	
    def list = {
		//def accountList = Account.findAll("FROM Account ac")
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def leadList = [], contactList = []
		Set set = new HashSet()
		Set set1 = new HashSet()
		FilterCriteria filterCriteria = new FilterCriteria()
		leadList = leadService.getUserLeads(user, filterCriteria)
		
		for(Lead ld in leadList)
		{
			if(ld.stagingStatus.name == "converted")
			{
				set.add(ld.contact)
				//contactList.add(ld.contact)
			}
		}
		//println PhoneNumberFormat.list()
		def contacts
		def accountList = []
		def unAssignedList = [], assignedList = []
		if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("SALES PRESIDENT"))
		{
			contacts = Contact.findAll("FROM Contact ct")
			set.addAll(contacts)
		}
		else if(SecurityUtils.subject.hasRole("GENERAL MANAGER"))
		{
			
			accountList = reviewService.findUserAccounts()
			
			for(Account ac : accountList)
			{
				for(Contact ct : ac.contacts)
				{
					set.add(ct)
				}
			}
		}
		else if(SecurityUtils.subject.hasRole("SALES MANAGER"))
		{
			accountList = reviewService.findUserAccounts()
			for(Account ac : accountList)
			{
				for(Contact ct : ac.contacts)
				{
					set.add(ct)
				}
			}
		} 
		else
		{
			contacts = Contact.findAll("FROM Contact ct WHERE ct.assignTo.id=${user.id} OR ct.createdBy.id=${user.id}")
			if(SecurityUtils.subject.hasRole("SALES PERSON"))
			{
				for(Contact c in contacts)
				{
					if(c?.assignTo?.id == user?.id)
					{
						assignedList.add(c)
					}
					else{
						unAssignedList.add(c)
					}
					
				}
				
				set.addAll(assignedList)
				
			}
		}
		
		contactList = set.toList()
		
		
		 
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [contactInstanceList: contactList, contactInstanceTotal: contactList?.size(), unAssignedList: unAssignedList, isSearchList: false]
    }
	
	String buildContactSearchQuery(Object searchFields)
	{
		String queryString = "from Contact ct "
		
		boolean isFirst = true
		
		List tags = null
		if(searchFields?.firstname)
		{
			for(String searchword: searchFields.firstname.split(" "))
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
				
				queryString += " (ct.firstname LIKE '${searchword}%' OR ct.firstname LIKE '%${searchword}' OR ct.firstname LIKE '%${searchword}%' OR ct.firstname = '${searchword}') "
				
			}
		}
		
		if(searchFields?.lastname)
		{
			for(String searchword: searchFields.lastname.split(" "))
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
				
				queryString += " (ct.lastname LIKE '${searchword}%' OR ct.lastname LIKE '%${searchword}' OR ct.lastname LIKE '%${searchword}%' OR ct.lastname = '${searchword}') "
				
			}
		}
		
		if(searchFields?.email)
		{
			if(isFirst)
			{
				queryString += " WHERE ct.email = '${searchFields.email}'"
				isFirst = false
			}
			else
			{
				queryString += " AND ct.email = '${searchFields.email}'"
			}
		}

		if(searchFields?.phone)
		{
			if(isFirst)
			{
				queryString += " WHERE ct.phone = ${searchFields.phone}"
				isFirst = false
			}
			else
			{
				queryString += " AND ct.phone = ${searchFields.phone}"
			}
		}
		return queryString
	}
	
	def search = {
		String queryString =  buildContactSearchQuery(params.searchFields)
		def contactList = Contact.findAll(queryString)
		List assignedList = new ArrayList(), unAssignedList = new ArrayList()
		def user = User.get(new Long(SecurityUtils.subject.principal))
		List contacts = contactList
		if(SecurityUtils.subject.hasRole("SALES PERSON"))
		{
			for(Contact c in contacts)
			{
				if(c?.assignTo?.id == user?.id)
				{
					assignedList.add(c)
				}
				else{
					unAssignedList.add(c)
				}
				
			}
			
			contactList = assignedList
			
		}
		
		render(view:"list",
			model: [contactInstanceList: contactList, contactInstanceTotal: contactList?.size(), searchFields: params.searchFields, unAssignedList: unAssignedList, isSearchList: true])
		
	}
	
	def addContactFromAccount = {
		def contactInstance = new Contact()
		contactInstance.properties = params
		
		//def salesUsers = []
		Set salesUsers = new HashSet()
		salesUsers = salesCatalogService.findSalesUsers()//reviewService.findSalesUsers()
		
		render(template: "/contact/addContact",  model: [contactInstance: contactInstance, accountId: params.accountId, salesUsers: salesUsers.toList()])
	}

	def addContactFromOpportunity = {
		def contactInstance = new Contact()
		contactInstance.properties = params
		
		//def salesUsers = []
		Set salesUsers = new HashSet()
		salesUsers = salesCatalogService.findSalesUsers()//reviewService.findSalesUsers()
		
		render(template: "create",  model: [contactInstance: contactInstance, sourceFrom: params.sourceFrom, accountId: params.accountId, salesUsers: salesUsers.toList()])
	}
	
    def create = {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def territoryList = new ArrayList()
		territoryList = salesCatalogService.findUserTerritories(user)
		
		if(user?.primaryTerritory != null && user?.primaryTerritory != "null" && user?.primaryTerritory != "NULL" )
		{
			boolean checkPrimaryTerritory = salesCatalogService.checkListContainsPrimaryTerritory(territoryList, user?.primaryTerritory)
			if(checkPrimaryTerritory)
			{
		        def contactInstance = new Contact()
		        contactInstance.properties = params
				
				//def salesUsers = []
				Set salesUsers = new HashSet()
				salesUsers = salesCatalogService.findSalesUsers()
				//println contactInstance
				def option = "select"
				List accountList = reviewService.findUserAccounts()
		        return [contactInstance: contactInstance, accountList: accountList, option:option, salesUsers: salesUsers.toList()]
			}
			else
			{
				render(view: "/userSetup/addTerritory", model: ["controller": "contact", territoryList: territoryList ])
			}
		}
		else
		{
			render(view: "/userSetup/addTerritory", model: ["controller": "contact", territoryList: territoryList])
		}
    }
	
	def accountFromContact = 
	{
		def option = params.option
		if(option == "select")
		{
			option = "new"
		}
		else
		{
			option = "select"
		}
		render(template: "/contact/getAccount",  model: [option: option])
	}

    def save = {
		def res = "fail"
		boolean i = false
		
		def phone = phoneNumberService.getValidatedPhonenumber(params.phone, params.billCountry)
		if(phone == "Invalid")
		{
			res = "invalidPhone"
			render res
		}
		else
		{
			params.phone = phone
			
			if(params.mobile != "" || params.fax != "")
			{
				def mobile = "", fax = ""
				if(params.mobile != "")
					mobile = phoneNumberService.getValidatedPhonenumber(params.mobile, params.billCountry)
				if(params.fax != "")
					fax = phoneNumberService.getValidatedPhonenumber(params.fax, params.billCountry)
					
				if(mobile == "Invalid")
				{
					res = "invalidMobile"
					render res
					return
				}
				else if(fax == "Invalid")
				{
					res = "invalidFax"
					render res
					return
				}
				else
				{
					params.mobile = mobile
					params.fax = fax
					i = createContact(params)
				}
			}
			else
			{
				i = createContact(params)
			}
			
			if(i == true)
			{
				res = "success"
				render res
			}
			else
			{
				render res
			}
	     }
    }

	public boolean createContact(Object params)
	{
		def contactInstance = new Contact()
		contactInstance.properties['firstname', 'lastname', 'department', 'phone', 'email', 'alrEmail', 'mobile', 'fax', 'address', 'title', 'iso', 'format'] = params
		contactInstance.dateCreated = new Date()
		contactInstance.dateModified = new Date()
		//contactInstance.assignTo = params.assingTo
		def accountInstance = Account.get(params.accountId)
		accountInstance.dateModified = new Date()
		accountInstance.save(flush:true)
		contactInstance.account = accountInstance
		
		def billingAddress = new BillingAddress()
		billingAddress.properties["billAddressLine1", "billAddressLine2", "billCity", "billState", "billPostalcode", "billCountry"] =params
		
		
		contactInstance.billingAddress = billingAddress
		println params
		def user = User.get(new Long(SecurityUtils.subject.principal))
		contactInstance.createdBy = user
		contactInstance.assignTo = User.get(params.assignToId)
		def map = [:]
		if ( billingAddress.save() && contactInstance.save(flush: true))
		{
			if(contactInstance.createdBy.id != contactInstance.assignTo.id)
			{
				map = new NotificationGenerator(g).sendAssignedToNotification(contactInstance, "Contact")
				sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/contact/show/"+contactInstance.id)
			}
			def contactname = contactInstance.firstname + " "+ contactInstance.lastname
			flash.message = "${message(code: 'default.created.message', args: [message(code: 'contact.label', default: 'Contact'), contactname])}"
			/*if(params.createdFrom == "account")
			{
				redirect(action: "show", controller: "account", id: params.accountId)
			}
			else
			{
				redirect(action: "list", id: contactInstance.id)
			}*/
			//contactInstance?.billingAddresses = billingAddress
			
			return true
		}
		else {
			//def salesUsers = []
			//salesUsers = reviewService.findSalesUsers()
			//render(view: "create", model: [contactInstance: contactInstance, salesUsers: salesUsers])
			return false
		}

	}
	public boolean isUpdated(Contact contactInstance)
	{
		 boolean check = false
	 
		 if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("SALES PRESIDENT"))
		 {
			 check = true
		 }
		 else
		 {
			 def user = User.get(new Long(SecurityUtils.subject.principal))
			 if(SecurityUtils.subject.hasRole("SALES PERSON"))
			 {
				 if(contactInstance?.assignTo?.id == user?.id)
				 {
					 check = true
				 }
			 }
			 else
			 {
				 check = true
			 }
			
		 }
	 
		 return check
	}
	
    def show = {
        def contactInstance = Contact.get(params.id)
		if(params.notificationId)
		{
			def note = Notification.get(params.notificationId)
			note.active = false
			note.save(flush:true)
		}
        if (!contactInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'contact.label', default: 'Contact'), params.id])}"
            redirect(action: "list")
        }
        else {
            [contactInstance: contactInstance, updatePermission: isUpdated(contactInstance)]
        }
    }

    def edit = {
        def contactInstance = Contact.get(params.id)
        if (!contactInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'contact.label', default: 'Contact'), params.id])}"
            redirect(action: "list")
        }
        else {
			//def salesUsers = []
			Set salesUsers = new HashSet()
			salesUsers = salesCatalogService.findSalesUsers()
			List accountList = reviewService.findUserAccounts()
            return [contactInstance: contactInstance, salesUsers: salesUsers.toList(), accountList: accountList]
        }
    }

    def update = {
		def res = "fail"
		boolean i = false
		
		def phone = phoneNumberService.getValidatedPhonenumber(params.phone, params.billCountry)
		if(phone == "Invalid")
		{
			res = "invalidPhone"
			render res
		}
		else
		{
			params.phone = phone
			if(params.mobile != "" || params.fax != "")
			{
				def mobile = "", fax = ""
			if(params.mobile != "")
				mobile = phoneNumberService.getValidatedPhonenumber(params.mobile, params.billCountry)
			if(params.fax != "")
				fax = phoneNumberService.getValidatedPhonenumber(params.fax, params.billCountry)
				if(mobile == "Invalid")
				{
					res = "invalidMobile"
					render res
					return
				}
				else if(fax == "Invalid")
				{
					res = "invalidFax"
					render res
					return

				}
				else
				{
					params.mobile = mobile
					params.fax = fax
					i = updateContact(params)
				}
			}
			else
			{
				i = updateContact(params)
			}
			
			if(i == true)
			{
				res = "success"
				render res
			}
			else
			{
				render res
			}
		 }
    }

	public boolean updateContact(Object params)
	{
		Contact contactInstance = Contact.get(params.id)
		if (contactInstance) {
			if (params.version) {
				def version = params.version.toLong()
				if (contactInstance.version > version) {
					
					contactInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'contact.label', default: 'Contact')] as Object[], "Another user has updated this Contact while you were editing")
					//render(view: "edit", model: [contactInstance: contactInstance])
					return false
				}
			}
			def previousAssignToId = contactInstance.assignTo.id
			def previousAccountId = contactInstance.account.id
			
			contactInstance.properties["firstname", "lastname", "department", "email", "altEmail", "title", "fax"] = params
			contactInstance.phone = params.phone
			contactInstance.mobile = params.mobile
			def user = User.get(new Long(SecurityUtils.subject.principal))
			contactInstance.dateModified = new Date()
			
			
			contactInstance.modifiedBy = user
			contactInstance.assignTo = User.get(params.assignToId)
			contactInstance.account = Account.get(params.accountId.toLong())
			
			contactInstance.billingAddress = BillingAddress.get(params.billingAddressId)
			contactInstance?.billingAddress?.properties["billAddressLine1", "billAddressLine2", "billCity", "billState", "billPostalcode", "billCountry"] =params
			def map = [:]
			if (!contactInstance.hasErrors() && contactInstance.save(flush: true)) 
			{
				if(previousAssignToId != contactInstance.assignTo.id && contactInstance.createdBy.id != contactInstance.assignTo.id)
				{
					map = new NotificationGenerator(g).sendAssignedToNotification(contactInstance, "Contact")
					sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/contact/show/"+contactInstance.id)
					
					map = [:]
					map = new NotificationGenerator(g).changeAssignedToNotification(contactInstance, User.get(previousAssignToId), "Contact")
					sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/contact/show/"+contactInstance.id)
					
				}
				def string = contactInstance.firstname + " " + contactInstance.lastname 
				flash.message = "${message(code: 'default.updated.message', args: [message(code: 'contact.label', default: 'Contact'), string])}"
				//redirect(action: "show", id: contactInstance.id)
				return true
			}
			else {
				def salesUsers = []
				salesUsers = reviewService.findSalesUsers()
				//render(view: "edit", model: [contactInstance: contactInstance, salesUsers: salesUsers])
				return false
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'contact.label', default: 'Contact'), params.id])}"
			//redirect(action: "list")
			return false
		}

			
	}
	
    def delete = {
        def contactInstance = Contact.get(params.id)
        if (contactInstance) {
            try {
                contactInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'contact.label', default: 'Contact'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'contact.label', default: 'Contact'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'contact.label', default: 'Contact'), params.id])}"
            redirect(action: "list")
        }
    }
}
