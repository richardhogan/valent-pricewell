package com.valent.pricewell
import grails.converters.JSON
import java.awt.image.BufferedImage
import javax.imageio.stream.ImageInputStream
import javax.imageio.stream.ImageOutputStream
import javax.imageio.ImageIO;

import org.apache.shiro.SecurityUtils
import org.codehaus.groovy.grails.commons.ConfigurationHolder;
import org.springframework.web.multipart.MultipartHttpServletRequest
import org.springframework.web.multipart.commons.CommonsMultipartFile


class AccountController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]
	def leadService
	def reviewService
	def phoneNumberService
	def salesCatalogService, fileUploadService
	def sendMailService
    def index = {
        redirect(action: "list", params: params)
    }

	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}
	
	boolean isURLContainsProtocols(String url)
	{
		if(url.startsWith("http://") || url.startsWith("https://") || url.startsWith("ftp://"))
			return true
		else
			return false
	} 
	
    def list = {
		def accountList = []
		
		def unAssignedList = [], assignedList = []
		accountList = reviewService.findUserAccounts()
		def user = User.get(new Long(SecurityUtils.subject.principal))
		if(SecurityUtils.subject.hasRole("SALES PERSON"))
		{
			for(Account ac in accountList)
			{
				if(ac?.assignTo?.id == user?.id)
				{
					assignedList.add(ac)
				}
				else
				{
					unAssignedList.add(ac)
				}
			}
			accountList = assignedList
		}
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [accountInstanceList: accountList, accountInstanceTotal: accountList?.size(), unAssignedList: unAssignedList]
    }

    def create = {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		//if(user.country != null && user.country != "null" && user.country != "NULL")// && user.primaryTerritory != null && user.primaryTerritory != "null" && user.primaryTerritory != "NULL")
		def territoryList = new ArrayList()
		territoryList = salesCatalogService.findUserTerritories(user)
		
		if(user?.primaryTerritory != null && user?.primaryTerritory != "null" && user?.primaryTerritory != "NULL" )
		{
			boolean checkPrimaryTerritory = salesCatalogService.checkListContainsPrimaryTerritory(territoryList, user?.primaryTerritory)
			if(checkPrimaryTerritory)
			{
		        def accountInstance = new Account()
		        accountInstance.properties = params
				//def salesUsers = []
				Set salesUsers = new HashSet()
				salesUsers = salesCatalogService.findSalesUsers()//reviewService.findSalesUsers()
				
		        return [accountInstance: accountInstance, salesUsers: salesUsers.toList()]
			}
			else
			{
				render(view: "/userSetup/addTerritory", model: ["controller": "account", territoryList: territoryList ])
			}
		}
		else
		{
			render(view: "/userSetup/addTerritory", model: ["controller": "account", territoryList: territoryList])//, userInstance: user])
		}
    }
	
	def createAccount = {
		
			def accountInstance = new Account()
			accountInstance.properties = params
			//def salesUsers = []
			Set salesUsers = new HashSet()
			salesUsers = salesCatalogService.findSalesUsers()//reviewService.findSalesUsers()
			
			render(template: "createAccount", model: [accountInstance: accountInstance, salesUsers: salesUsers.toList()])

			//<g:render template="/account/createAccount" model="['contactInstance': contactInstance, 'option': option, 'salesUsers': salesUsers]"/>
	}
	
	String buildAccountSearchQuery(Object searchFields)
	{
		String queryString = "from Account ac "
		
		boolean isFirst = true
		
		List tags = null
		if(searchFields?.accountName)
		{
			for(String searchword: searchFields.accountName.split(" "))
			{
				if(searchword?.contains("'"))
				{
					searchword = searchword.substring(0, searchword?.indexOf("'"))
				}
				
				if(isFirst)
				{
					queryString += " WHERE "
					isFirst = false
				}
				else
				{
					queryString += " OR "
				}
				
				queryString += " (ac.accountName LIKE '${searchword}%' OR ac.accountName LIKE '%${searchword}' OR ac.accountName LIKE '%${searchword}%' OR ac.accountName = '${searchword}') "
				
			}
		}
		
		if(searchFields?.website)
		{
			if(isFirst)
			{
				queryString += " WHERE ac.website = '${searchFields.website}'"
				isFirst = false
			}
			else
			{
				queryString += " AND ac.website = '${searchFields.website}'"
			}
		}

		if(searchFields?.phone)
		{
			if(isFirst)
			{
				queryString += " WHERE ac.phone = ${searchFields.phone}"
				isFirst = false
			}
			else
			{
				queryString += " AND ac.phone = ${searchFields.phone}"
			}
		}
		return queryString
	}
	
	def search = {
		String queryString =  buildAccountSearchQuery(params.searchFields)
		def accountList = Account.findAll(queryString)
		
		def unAssignedList = [], assignedList = []
		def user = User.get(new Long(SecurityUtils.subject.principal))
		if(SecurityUtils.subject.hasRole("SALES PERSON"))
		{
			for(Account ac in accountList)
			{
				if(ac?.assignTo?.id == user?.id)
				{
					assignedList.add(ac)
				}
				else
				{
					unAssignedList.add(ac)
				}
			}
			accountList = assignedList
		}
		
		render(view:"list",	model: [accountInstanceList: accountList, accountInstanceTotal: accountList.size(), searchFields: params.searchFields, unAssignedList: unAssignedList])
		
	}

	def save = {
		def res = "fail"
		
		boolean i = false
		if(params.phone != "" || params.fax != "")
		{
			
			def phone = "", fax = ""
			if(params.phone != "")
				phone = phoneNumberService.getValidatedPhonenumber(params.phone, params.billCountry)
			
			if(params.fax != "")
				fax = phoneNumberService.getValidatedPhonenumber(params.fax, params.billCountry)
			
			if(phone == "Invalid")
			{
				res = "invalidPhone"
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
				params.phone = phone
				params.fax = fax
				i = saveAccount(params)
				
			}	
		}
		else
		{
			i = saveAccount(params)
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

	public boolean saveAccount(Object params)
	{
		Account accountInstance = new Account(shippingAddress: new ShippingAddress().save(), billingAddress: new BillingAddress().save())
		def user = User.get(new Long(SecurityUtils.subject.principal))
		
		if(params.website != null && params.website != "")
		{
			if(!isURLContainsProtocols(params.website))
			{
				//add default start "http://"
				params.website = "http://"+params.website
			}
		}
		accountInstance.properties['accountName','website','phone','fax','email','sameAsBillingAddress'] = params
		
		accountInstance.assignTo = User.get(params.accountAssignToId)
		accountInstance.createdBy = user
		
		if(params.logoId != null && params.logoId != "")
		{
			def accountLogo = LogoImage.get(params.logoId.toInteger())
			accountInstance.logo = accountLogo
			
			accountInstance.imageFile = getUploadedImage(accountInstance, params.filePath)
		}
		
		accountInstance.dateCreated = new Date()
		accountInstance.dateModified = new Date()
		
		BillingAddress billingAddress = accountInstance.billingAddress//new BillingAddress()	
		billingAddress.properties["billAddressLine1", "billAddressLine2", "billCity", "billState", "billPostalcode", "billCountry"] =params

		//billingAddress.save()
		//accountInstance.billingAddress = billingAddress
		
		ShippingAddress shippingAddress = accountInstance.shippingAddress//new ShippingAddress()
		if(params.sameAsBillingAddress == 'on' )
		{
			
			shippingAddress?.shipAddressLine1 = params?.billAddressLine1
			shippingAddress?.shipAddressLine2 = params?.billAddressLine2
			shippingAddress?.shipCity = params?.billCity
			shippingAddress?.shipState = params?.billState
			shippingAddress?.shipPostalcode = params?.billPostalcode
			shippingAddress?.shipCountry = params?.billCountry
			
		}
		else
		{
			shippingAddress.properties["shipAddressLine1", "shipAddressLine2", "shipCity", "shipState", "shipPostalcode", "shipCountry"] =params
		}
		//accountInstance.shippingAddress = shippingAddress
		
		def map = [:]
		//println accountInstance.save()
		if(accountInstance.save())//billingAddress.save() && shippingAddress.save())
		{
			if(accountInstance.createdBy.id != accountInstance.assignTo.id)
			{
				map = new NotificationGenerator(g).sendAssignedToNotification(accountInstance, "Account")
				sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/account/show/"+accountInstance.id)
			}
			/*if(params.createFrom == "contact")
			{
				res = "success"
				render res
			}
			else
			{
				flash.message = "${message(code: 'default.created.message', args: [message(code: 'account.label', default: 'Account'), accountInstance.id])}"
				redirect(action: "show", id: accountInstance.id)
			}*/
			return true
		}
		else 
		{
			/*def salesUsers = []
			salesUsers = reviewService.findSalesUsers()
			render(view: "create", model: [accountInstance: accountInstance, salesUsers: salesUsers])*/
			return false
		}
	}
	
	public UploadFile getUploadedImage(Account accountInstance, def filePath)
	{
		Map map = getNewFileProperties(accountInstance, filePath)
		def fileName = map["fileName"]
		def newFilePath = map["newFilePath"]
		
		if(accountInstance.imageFile != null && accountInstance.imageFile != "")
		{
			UploadFile fileInstance = UploadFile.get(accountInstance.imageFile.id)
			
			if(filePath != newFilePath)
			{
				moveFile(filePath, newFilePath)
				fileInstance.name = fileName
				fileInstance.filePath = newFilePath
				fileInstance.save()
			}
			return fileInstance
		}
		else
		{			
			moveFile(filePath, newFilePath)
			
			UploadFile fileInstance = new UploadFile()
			fileInstance.name = fileName
			fileInstance.filePath = newFilePath
			fileInstance.save()
			return fileInstance
		}
		
	}
	
	public Map getNewFileProperties(Account accountInstance, def filePath)
	{
		File tmpFile = new File(filePath)
		
		def fileExtension = getFileExtension(tmpFile.getName())
		println fileExtension
		
		def fileName = accountInstance?.accountName?.toString()?.toLowerCase().replaceAll(" ", "") + "Logo."+fileExtension
		def destinationDirectory = "customerLogos"
		def storagePath = fileUploadService.getStoragePath(destinationDirectory)
		def newFilePath = "${storagePath}/${fileName}"
		
		Map map = new HashMap()
		map.put("newFilePath", newFilePath)
		map.put("fileName", fileName)
		return map
	}
	
	public def moveFile(def inputFilePath, def outputFilePath)
	{		
		InputStream inStream = null;
		OutputStream outStream = null;
	 
		try{
 
			File inputFile = new File(inputFilePath);
			File outputFile =new File(outputFilePath);
 
			inStream = new FileInputStream(inputFile);
			outStream = new FileOutputStream(outputFile);
 
			byte[] buffer = new byte[(int)inputFile.length()];
 
			int length;
			//copy the file content in bytes
			while ((length = inStream.read(buffer)) > 0){
 
				outStream.write(buffer, 0, length);
 
			}
 
			inStream.close();
			outStream.close();
 
			//delete the original file
			inputFile.delete();
 
			println "File is copied successful!"
 
		}catch(IOException e){
			e.printStackTrace();
		}

	}
	
	public def getFileExtension(String fileName)
	{
		String extension = "";

		int i = fileName.lastIndexOf('.');
		if (i >= 0) {
			extension = fileName.substring(i+1);
		}
		return extension
	}
	
	public boolean isUpdated(Account accountInstance)
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
				 if(accountInstance?.assignTo?.id == user?.id)
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
        def accountInstance = Account.get(params.id)
		if(params.notificationId)
		{
			def note = Notification.get(params.notificationId)
			note.active = false
			note.save(flush:true)
		}
        if (!accountInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'account.label', default: 'Account'), params.id])}"
            redirect(action: "list")
        }
        else {
			boolean isLogoAvailable = isLogoAvailable(accountInstance)
            [accountInstance: accountInstance, isLogoAvailable: isLogoAvailable, updatePermission: isUpdated(accountInstance)]
        }
    }

	public boolean isLogoAvailable(Account accountInstance)
	{
		boolean isThere = false
		if(accountInstance?.imageFile?.filePath != null && accountInstance?.imageFile?.filePath != "" && accountInstance?.imageFile?.filePath != "null")
		{
			isThere = fileUploadService.isFileExist(accountInstance?.imageFile?.filePath)
		}
		return isThere
	}
	
    def edit = {
        def accountInstance = Account.get(params.id)
        if (!accountInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'account.label', default: 'Account'), params.id])}"
            redirect(action: "list")
        }
        else {
			//def salesUsers = []
			boolean isLogoAvailable = isLogoAvailable(accountInstance)
			Set salesUsers = new HashSet()
			salesUsers = salesCatalogService.findSalesUsers()
            return [accountInstance: accountInstance, salesUsers: salesUsers.toList(), isLogoAvailable: isLogoAvailable]
        }
    }

    def update = {
		def res = "fail"
		boolean i = false
		
		if(params.phone != "" || params.fax != "")
		{
			def phone = "", fax = ""
			if(params.phone != "")
				phone = phoneNumberService.getValidatedPhonenumber(params.phone, params.billCountry)
			
			if(params.fax != "")
				fax = phoneNumberService.getValidatedPhonenumber(params.fax, params.billCountry)
			
				if(phone == "Invalid")
				{
					res = "invalidPhone"
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
					params.phone = phone
					params.fax = fax
					i = updateAccount(params)
				}
   	
		}
		else
		{
			i = updateAccount(params)
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

	public boolean updateAccount(Object params)
	{
		def accountInstance = Account.get(params.id)
		def salesUsers = []
		salesUsers = reviewService.findSalesUsers()
		if (accountInstance) {
			if (params.version) {
				def version = params.version.toLong()
				if (accountInstance.version > version) {
					
					accountInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'account.label', default: 'Account')] as Object[], "Another user has updated this Account while you were editing")
					//render(view: "edit", model: [accountInstance: accountInstance, salesUsers: salesUsers])
					return false
				}
			}
			
			if(params.website != null && params.website != "")
			{
				if(!isURLContainsProtocols(params.website))
				{
					//add default start "http://"
					params.website = "http://"+params.website
				}
			}
			
			accountInstance.properties['accountName','website','phone','fax','email','createdBy','dateCreated'] = params
			def user = User.get(new Long(SecurityUtils.subject.principal))
			accountInstance.modifiedBy = user
			def previousAssignedUserId = accountInstance.assignTo.id
			accountInstance.assignTo = User.get(params.accountAssignToId)
			accountInstance.dateModified = new Date()
			
			if(params.logoId != null && params.logoId != "")
			{
				def accountLogo = LogoImage.get(params.logoId.toInteger())
				accountInstance.logo = accountLogo
				
				accountInstance.imageFile = getUploadedImage(accountInstance, params.filePath)
			}
			
			def billingAddress = BillingAddress.get(params.billingAddressId)
			billingAddress.properties["billAddressLine1", "billAddressLine2", "billCity", "billState", "billPostalcode", "billCountry"] =params
			accountInstance.billingAddress = billingAddress
			
			def shippingAddress = ShippingAddress.get(params.shippingAddressId)
			shippingAddress.properties["shipAddressLine1", "shipAddressLine2", "shipCity", "shipState", "shipPostalcode", "shipCountry"] =params
			accountInstance.shippingAddress = shippingAddress
			def map = [:]
			if (billingAddress.save() && shippingAddress.save() && !accountInstance.hasErrors() && accountInstance.save(flush: true)) 
			{
				if(previousAssignedUserId != accountInstance.assignTo.id && accountInstance.createdBy.id != accountInstance.assignTo.id)
				{
					map = new NotificationGenerator(g).sendAssignedToNotification(accountInstance, "Account")
					sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/account/show/"+accountInstance.id)
					
					map = [:]
					map = new NotificationGenerator(g).changeAssignedToNotification(accountInstance, User.get(previousAssignedUserId), "Account")
					sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/account/show/"+accountInstance.id)
					
				}
				
				flash.message = "${message(code: 'default.updated.message', args: [message(code: 'account.label', default: 'Account'), accountInstance.id])}"
				//redirect(action: "show", id: accountInstance.id)
				return true
			}
			else {
				//render(view: "edit", model: [accountInstance: accountInstance, salesUsers: salesUsers])
				return false
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'account.label', default: 'Account'), params.id])}"
			//redirect(action: "list")
			return false
		}
	}
	
    def delete = {
        def accountInstance = Account.get(params.id)
        if (accountInstance) {
            try {
                accountInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'account.label', default: 'Account'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'account.label', default: 'Account'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'account.label', default: 'Account'), params.id])}"
            redirect(action: "list")
        }
    }
}
