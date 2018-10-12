package com.valent.pricewell

import org.apache.shiro.SecurityUtils
class CompanyInformationController {

	static allowedMethods = [save: "POST", update: "POST", delete: "POST"]
	
	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}

	def index = {
		if(CompanyInformation.list().size()!=0) {
			for(CompanyInformation ci in CompanyInformation.list()) {
				redirect(action: "show", id: ci.id)
			}
		}
		else {
			redirect(action: "create", params: params)
		}
	}
	
	public String getBaseCurrency(){
		CompanyInformation companyInformationInstance = CompanyInformation.list().get(0);
		return companyInformationInstance?.baseCurrency
	}
	
	def isInfoDefined =
	{
		if(CompanyInformation.list().size() > 0)
		{
			render "true"
		}	
		else
		{
			render "false"
		}
	}
	
	boolean isURLContainsProtocols(String url)
	{
		if(url.startsWith("http://") || url.startsWith("https://") || url.startsWith("ftp://"))
			return true
		else
			return false
	}
	
	def list = {
		params.max = Math.min(params.max ? params.int('max') : 10, 100)
		[companyInformationInstanceList: CompanyInformation.list(params), companyInformationInstanceTotal: CompanyInformation.count()]
	}
	
	def addLogo = {
		def companyInformationInstance = CompanyInformation.get(params.id)
		[companyInformationInstance: companyInformationInstance]
	}
	
	def createInstanceInfo = {
		
		Setting instanceSetting = Setting.findByName("instanceName")
		
		if(params.source == "firstsetup")
		{
			if(instanceSetting == null)
			{
				render(template: "createInstanceInfo", model: [source: params.source])
			}
			else
			{
				render(template: "showInstanceInfo", model: [instanceInfo: instanceSetting, source: params.source])
			}
			
		}
		else
		{
			def page = (instanceSetting == null) ? "create" : "show"
			render(view: "main", model: [source: params.source, page: page, instanceInfo: instanceSetting])
		}
	}
	
	def saveInstanceInfo = {
		if(params.instanceName)
		{
			Setting instanceSetting = new Setting(name: "instanceName", value: params.instanceName).save()
			render(template: "showInstanceInfo", model: [instanceInfo: instanceSetting, source: params.source])
		}
		else render "none"
	}
	
	def showInstanceInfo = {
		Setting instanceSetting = Setting.findByName("instanceName")
		if(instanceSetting != null)
		{
			render(template: "showInstanceInfo", model: [instanceInfo: instanceSetting, source: params.source])
		}
		else render "none"
	}
	
	def editInstanceInfo = {
		if(params.instanceId)
		{
			Setting instanceSetting = Setting.get(params.instanceId?.toLong())
			if(instanceSetting)
			{
				render(template: "editInstanceInfo", model: [instanceInfo: instanceSetting, source: params.source])
			}
			else render "none"
		}
		else render "none"
	}
	
	def updateInstanceInfo = {
		if(params.instanceId)
		{
			Setting instanceSetting = Setting.get(params.instanceId?.toLong())
			if(instanceSetting)
			{
				instanceSetting.value = params.instanceName
				instanceSetting.save()
				render(template: "showInstanceInfo", model: [instanceInfo: instanceSetting, source: params.source])
			}
			else render "none"
		}
		else render "none"
	}
	
	def create = {
		def companyInformationInstance = new CompanyInformation()
		companyInformationInstance.properties = params
		//render(template: "create", model: [companyInformationInstance: companyInformationInstance])

		model: [companyInformationInstance: companyInformationInstance]
	}

	def createFromSetup = {
		def companyInformationInstance = new CompanyInformation()
		companyInformationInstance.properties = params
		def source = (params.source == "firstsetup")?"firstsetup":"setup"
		render(template: "create", model: [companyInformationInstance: companyInformationInstance, source: source])
	}


	def save = {
		//def res = "fail"
		def companyInformationInstance = new CompanyInformation(params)

		if(params.website != null && params.website != "")
		{
			if(!isURLContainsProtocols(params.website))
			{
				//add default start "http://"
				params.website = "http://"+params.website
			}
		}
		
		companyInformationInstance.properties[
					'name',
					'logo',
					'website',
					'SMTPserver',
					'fromEmail',
					'phone',
					'mobile',
					'baseCurrency',
					'baseCurrencySymbol'
				] = params

		if(params.logoId != null && params.logoId != "")
		{
			def companyLogo = LogoImage.get(params.logoId.toInteger())
			companyInformationInstance.logo = companyLogo
		}
		companyInformationInstance.dateCreated = new Date()
		companyInformationInstance.dateModified = new Date()

		def shippingAddress = new ShippingAddress()
		shippingAddress.properties[
					"shipAddressLine1",
					"shipAddressLine2",
					"shipCity",
					"shipState",
					"shipPostalcode",
					"shipCountry"
				] =params
		companyInformationInstance.shippingAddress = shippingAddress

		if (shippingAddress.save() && companyInformationInstance.save(flush: true)) {
			flash.message = "${message(code: 'default.created.message', args: [message(code: 'companyInformation.label', default: 'CompanyInformation'), companyInformationInstance.name])}"
			if(params.source == "setup" || params.source == "firstsetup"){
				render "success"
			} else{
				redirect(action: "show", id: companyInformationInstance.id)
			}
		}
		else {
			if(params.source == "setup" || params.source == "firstsetup"){
				render "fail"
			} else{
				render(view: "index")
			}
		}
		
	}

	def showLogo = 
	{
		def companyInformationInstance = CompanyInformation.get(params.id.toInteger())
		render(template: "showLogo", model: [companyInformationInstance: companyInformationInstance])
	}
	
	def renderImage =
	{
		def companyInformationInstance = CompanyInformation.get(params.id)
		if (companyInformationInstance?.logo)
		{
			response.setContentLength(companyInformationInstance.logo.length)
			response.outputStream.write(companyInformationInstance.logo)
		}
		else
		{
			response.sendError(404)
		}
	}

	def show = {
		def companyInformationInstance = CompanyInformation.get(params.id)

		if (!companyInformationInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'companyInformation.label', default: 'CompanyInformation'), params.id])}"
			redirect(action: "index")
		}
		else {

			if(params.source == "setup"){
				render(template: "show", model: [companyInformationInstance: companyInformationInstance, source: params.source])
			} else{
				model: [companyInformationInstance: companyInformationInstance]
			}

		}
	}

	def showsetup = {
		def companyInformationInstance = CompanyInformation.list().get(0);

		if (!companyInformationInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'companyInformation.label', default: 'CompanyInformation'), params.id])}"
			redirect(action: "index")
		}
		else {
			if(params.source == "firstsetup")
			{
				render(template: "showsetup", model: [companyInformationInstance: companyInformationInstance, source: "firstsetup"])
			}
			else 
				render(template: "show", model: [companyInformationInstance: companyInformationInstance, source: "setup"])
		}
	}

	def edit = {
		def companyInformationInstance = CompanyInformation.get(params.id)
		if (!companyInformationInstance) {
			//flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'companyInformation.label', default: 'CompanyInformation'), params.id])}"
			redirect(action: "show", id: params.id)
		}
		else {
			if(params.source == "setup" || params.source == "firstsetup")
			{
				def source = (params.source == "firstsetup")?"firstsetup":"setup"
				render(template: "edit", model: [companyInformationInstance: companyInformationInstance, source: source])
			} else{
				model: [companyInformationInstance: companyInformationInstance]
			}

		}
	}

	def update = {
		def res = "fail"
		def companyInformationInstance = CompanyInformation.get(params.id)
		if (companyInformationInstance) {
			if (params.version) {
				def version = params.version.toLong()
				if (companyInformationInstance.version > version) {

					companyInformationInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [
						message(code: 'companyInformation.label', default: 'CompanyInformation')]
					as Object[], "Another user has updated this CompanyInformation while you were editing")
					render(view: "edit", model: [companyInformationInstance: companyInformationInstance])
					return

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
			companyInformationInstance.properties[
						'name',
						'website',
						'SMTPserver',
						'fromEmail',
						'phone',
						'mobile',
						'baseCurrency',
						'baseCurrencySymbol'
					] = params
			if(params.logoId != null && params.logoId != "")
			{
				def companyLogo = LogoImage.get(params.logoId.toInteger())
				companyInformationInstance.logo = companyLogo
			}
			companyInformationInstance.shippingAddress = ShippingAddress.get(params.shippingAddressId)
			companyInformationInstance.shippingAddress.properties[
						"shipAddressLine1",
						"shipAddressLine2",
						"shipCity",
						"shipState",
						"shipPostalcode",
						"shipCountry"
					] =params

			if (!companyInformationInstance.hasErrors() && companyInformationInstance.save(flush: true)) {

				if(params.source == "setup" || params.source == "firstsetup"){
					render "success"
				} else{
					flash.message = "${message(code: 'default.updated.message', args: [message(code: 'companyInformation.label', default: 'CompanyInformation'), companyInformationInstance.name])}"
					redirect(action: "show", id: companyInformationInstance.id)
				}

				//res = "success"
			}
			else {
				if(params.source == "setup" || params.source == "firstsetup"){
					render "fail"
				} else{
					render(view: "edit", model: [companyInformationInstance: companyInformationInstance])
				}

			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'companyInformation.label', default: 'CompanyInformation'), params.id])}"
			redirect(action: "index")

		}
		//render res
	}

	def delete = {
		def res = "fail"
		def companyInformationInstance = CompanyInformation.get(params.id)
		if (companyInformationInstance) {
			try {
				companyInformationInstance.delete(flush: true)
				flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'companyInformation.label', default: 'CompanyInformation'), params.id])}"
				redirect(action: "index")
				//res = "success"
			}
			catch (org.springframework.dao.DataIntegrityViolationException e) {
				flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'companyInformation.label', default: 'CompanyInformation'), params.id])}"
				redirect(action: "show", id: params.id)
				//res = "fail"
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'companyInformation.label', default: 'CompanyInformation'), params.id])}"
			redirect(action: "index")
			//res = "fail"
		}
		//render res
	}
}
