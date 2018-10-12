package com.valent.pricewell
import org.apache.shiro.SecurityUtils

class ServiceProfileSOWDefController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}
	
    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [serviceProfileSOWDefInstanceList: ServiceProfileSOWDef.list(params), serviceProfileSOWDefInstanceTotal: ServiceProfileSOWDef.count()]
    }

	def listServiceProfileSOWDefinition = {
		def pid = params.serviceProfileId
		
		if(params.serviceProfileId)
		{
			def serviceProfile = ServiceProfile.get(params.serviceProfileId)
			
			if(serviceProfile?.defs && serviceProfile?.defs?.size() > 0)
			{
				def territorySet = new HashSet()
				boolean hasDefaultSOWDefinition = false
				ServiceProfileSOWDef defaultSowDef = null
				for(ServiceProfileSOWDef sowDefinition : serviceProfile.defs)
				{
					if(sowDefinition?.geo != null && sowDefinition?.geo != "")
					{
						territorySet.add(sowDefinition?.geo)
					}
					else
					{
						hasDefaultSOWDefinition = true
						defaultSowDef = ServiceProfileSOWDef.get(sowDefinition?.id)
					}
				}
				boolean readOnly = false
				render(template: "listServiceProfileSOWDefinition", model: [defaultSowDef: defaultSowDef, readOnly: readOnly, serviceProfileInstance: serviceProfile, territoryList: territorySet.toList(), hasDefaultSOWDefinition: hasDefaultSOWDefinition])
			}
			else
			{
				def serviceProfileSOWDefInstance = new ServiceProfileSOWDef()
				
				render(template: "newServiceProfileSOWDefinition",
							model:[serviceProfileSOWDefInstance: serviceProfileSOWDefInstance, serviceProfileId: serviceProfile?.id, definitionList: serviceProfile?.defs])
			}
		}
	}
	
	def getDefaultSOWDefinition = {
		if(params.id)
		{
			def serviceProfileInstance = ServiceProfile.get(params.id)
			
			ServiceProfileSOWDef defaultSOWDefinition = null
			
			for(ServiceProfileSOWDef sowDefinition : serviceProfileInstance?.defs)
			{
				if(sowDefinition?.geo == null || sowDefinition?.geo == "")
				{
					defaultSOWDefinition = sowDefinition
				}
			}
			boolean readOnly = false
			if(params.type && params.type == "readOnly")
			{
				readOnly = true
			}
			render(template: "/service/showDefinition", model: [serviceProfileInstance: serviceProfileInstance, defaultSOWDefinition: defaultSOWDefinition, readOnly: readOnly])
		}
	}
	
	def getTerritorySOWDefinition = {
		
		def sowDefinitionList = []
		if(params.serviceProfileId)
		{
			def serviceProfileInstance = ServiceProfile.get(params.serviceProfileId)
			def territoryInstance = Geo.get(params.territoryId)
			
			for(ServiceProfileSOWDef sowDefinition : serviceProfileInstance?.defs)
			{
				if(sowDefinition?.geo?.id == territoryInstance.id)
				{
					sowDefinitionList.add(sowDefinition)
				}
			}
		}
		if(params.type == "readOnly")
		{
			render(template: "displayTerritorySOWDefinitionReadOnly", model:[sowDefinitionList: sowDefinitionList])
		}
		else{
			render(template: "displayTerritorySOWDefinition", model:[sowDefinitionList: sowDefinitionList])
		}
		
		
		//return sowDefinitionList
	}
	
    def create = {
        def serviceProfileSOWDefInstance = new ServiceProfileSOWDef()
        serviceProfileSOWDefInstance.properties = params
        return [serviceProfileSOWDefInstance: serviceProfileSOWDefInstance]
    }
	
	def createFromService = {
		if(!params.serviceProfileId)
		{
			flash.message = "Invalid Request";
			//TODO: Redirect appropriately
		}
		
		def serviceProfileSOWDefInstance = new ServiceProfileSOWDef()
		
		def serviceProfileInstance = ServiceProfile.get(Long.valueOf(params.serviceProfileId))
		def definitionList = serviceProfileInstance?.defs
		
		def defaultSowLanguageTemplate = "${message(code: 'default.sow.language', args: [serviceProfileInstance?.service?.serviceName])}"
		
		render(template: "newServiceProfileSOWDefinition",
					model:[serviceProfileSOWDefInstance: serviceProfileSOWDefInstance, serviceProfileId: params.serviceProfileId, definitionList: definitionList, defaultSowLanguageTemplate: defaultSowLanguageTemplate])
	}

    def save = {
        def serviceProfileSOWDefInstance = new ServiceProfileSOWDef(params)
        if (serviceProfileSOWDefInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'serviceProfileSOWDef.label', default: 'ServiceProfileSOWDef'), serviceProfileSOWDefInstance.id])}"
            redirect(action: "show", id: serviceProfileSOWDefInstance.id)
        }
        else {
            render(view: "create", model: [serviceProfileSOWDefInstance: serviceProfileSOWDefInstance])
        }
    }

	def saveFromService = {
		if(!params.serviceProfileId)
		{
			flash.message = "Argument is not valid"
		}
		
		def serviceProfile = ServiceProfile.get(params.serviceProfileId)
		
		if(!serviceProfile)
		{
			flash.message = "Service Profile is not valid"
		}
	
		
		def sowDefinitionInstance = new ServiceProfileSOWDef()
		if(params.type == "default")
		{
			sowDefinitionInstance.part = "Default Section"
		}
		else
		{
			def territoryInstance = Geo.get(params.geoId)
			sowDefinitionInstance.part = getPartString(territoryInstance, serviceProfile)
			sowDefinitionInstance.geo = territoryInstance
		}
		
		//sowDefinitionInstance.definition = params.definition
		sowDefinitionInstance.definitionSetting = new Setting(name: "sowDefinition", value: params.definition).save(flush: true)
		sowDefinitionInstance.sp = serviceProfile
		
		
		serviceProfile = serviceProfile.addToDefs(sowDefinitionInstance)
		serviceProfile.save(flush:true)
		if (serviceProfile)
		{
			//render(template: "listServiceProfileSOWDefinition", model: [serviceProfileInstance: serviceProfile])
			redirect(action: "listServiceProfileSOWDefinition", params:[serviceProfileId: serviceProfile?.id])
		}
		else {
			//TODO: redirect properly
			render(view: "create", model: [sowDefinitionInstance: sowDefinitionInstance])
		}
		
	}
	
	public def getPartString(Geo territory, ServiceProfile serviceProfile)
	{
		def sowDefinitionList = []
		for(ServiceProfileSOWDef sowDefinition : serviceProfile?.defs)
		{
			if(sowDefinition?.geo?.id == territory.id)
			{
				sowDefinitionList.add(sowDefinition)
			}
		}
		def partString = ""
		boolean check = false
		
		for(int i = 0; check == false; )
		{
			partString = "Section - "+(char)(65+i)
			if(ckeckPartStringAvailable(sowDefinitionList, partString))
			{
				i++
			}
			else
			{
				check = true
				break
			}
		}
		
		return partString
	}
	
	public boolean ckeckPartStringAvailable(List sowDefinitionList, def partString)
	{
		boolean available = false
		for(ServiceProfileSOWDef sowDefinition: sowDefinitionList)
		{
			if(sowDefinition?.part == partString)
			{
				available = true
			}
		}
		println partString + available
		return available
	}
    def show = {
        def serviceProfileSOWDefInstance = ServiceProfileSOWDef.get(params.id)
        if (!serviceProfileSOWDefInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceProfileSOWDef.label', default: 'ServiceProfileSOWDef'), params.id])}"
            redirect(action: "list")
        }
        else {
            [serviceProfileSOWDefInstance: serviceProfileSOWDefInstance]
        }
    }

	def editFromService = {
		
		def serviceProfileSOWDefInstance = ServiceProfileSOWDef.get(params.id)
		if (!serviceProfileSOWDefInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceProfileSOWDef.label', default: 'ServiceProfileSOWDef'), params.id])}"
			redirect(action: "list")
		}
		else {
			def serviceProfileInstance = ServiceProfile.get(serviceProfileSOWDefInstance?.sp?.id)
			def definitionList = serviceProfileInstance?.defs
			
			render(template: "editServiceProfileSOWDefinition",
					model:[serviceProfileSOWDefInstance: serviceProfileSOWDefInstance, serviceProfileId: serviceProfileInstance?.id, definitionList: definitionList])
		}
		
	}
	
	def editDefaultSOWDefinition = {
		def serviceProfileSOWDefInstance = ServiceProfileSOWDef.get(params.id)
		if (!serviceProfileSOWDefInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceProfileSOWDef.label', default: 'ServiceProfileSOWDef'), params.id])}"
			redirect(action: "list")
		}
		else {
			def serviceProfileInstance = ServiceProfile.get(serviceProfileSOWDefInstance?.sp?.id)
			def definitionList = serviceProfileInstance?.defs
			
			render(template: "editDefaultSOWDefinition",
					model:[serviceProfileSOWDefInstance: serviceProfileSOWDefInstance, serviceProfileId: serviceProfileInstance?.id, definitionList: definitionList])
		}
	}
	
    def edit = {
        def serviceProfileSOWDefInstance = ServiceProfileSOWDef.get(params.id)
        if (!serviceProfileSOWDefInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceProfileSOWDef.label', default: 'ServiceProfileSOWDef'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [serviceProfileSOWDefInstance: serviceProfileSOWDefInstance]
        }
    }

	def updateFromService = {
		def serviceProfileSOWDefInstance = ServiceProfileSOWDef.get(params.id)
		if (serviceProfileSOWDefInstance) {
			if (params.version) {
				def version = params.version.toLong()
				if (serviceProfileSOWDefInstance.version > version) {
					
					serviceProfileSOWDefInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'serviceProfileSOWDef.label', default: 'ServiceProfileSOWDef')] as Object[], "Another user has updated this ServiceProfileSOWDef while you were editing")
					return
				}
			}
			serviceProfileSOWDefInstance.definitionSetting?.value = params.definition
			if (!serviceProfileSOWDefInstance.hasErrors() && serviceProfileSOWDefInstance.save(flush: true)) {
				redirect(action: "listServiceProfileSOWDefinition", params:[serviceProfileId: serviceProfileSOWDefInstance?.sp?.id])
			}
			else {
				return
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceDeliverable.label', default: 'ServiceDeliverable'), params.id])}"
			return
		}

	}
	
    def update = {
        def serviceProfileSOWDefInstance = ServiceProfileSOWDef.get(params.id)
        if (serviceProfileSOWDefInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (serviceProfileSOWDefInstance.version > version) {
                    
                    serviceProfileSOWDefInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'serviceProfileSOWDef.label', default: 'ServiceProfileSOWDef')] as Object[], "Another user has updated this ServiceProfileSOWDef while you were editing")
                    render(view: "edit", model: [serviceProfileSOWDefInstance: serviceProfileSOWDefInstance])
                    return
                }
            }
            serviceProfileSOWDefInstance.properties = params
            if (!serviceProfileSOWDefInstance.hasErrors() && serviceProfileSOWDefInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'serviceProfileSOWDef.label', default: 'ServiceProfileSOWDef'), serviceProfileSOWDefInstance.id])}"
                redirect(action: "show", id: serviceProfileSOWDefInstance.id)
            }
            else {
                render(view: "edit", model: [serviceProfileSOWDefInstance: serviceProfileSOWDefInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceProfileSOWDef.label', default: 'ServiceProfileSOWDef'), params.id])}"
            redirect(action: "list")
        }
    }

	def deleteFromService = {
		def serviceProfileSOWDefInstance = ServiceProfileSOWDef.get(params.id)
		
		if (serviceProfileSOWDefInstance) {
			try {
				def serviceProfile = serviceProfileSOWDefInstance.sp
				serviceProfileSOWDefInstance.delete(flush:true)
				redirect(action: "listServiceProfileSOWDefinition", params:[serviceProfileId: serviceProfile?.id])
				
			}
			catch (org.springframework.dao.DataIntegrityViolationException e) {
				//flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'serviceDeliverable.label', default: 'ServiceDeliverable'), name])}"
				redirect(action: "show", id: params.id)
			}
		}
		else {
			//flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceDeliverable.label', default: 'ServiceDeliverable'), name])}"
			redirect(action: "list")
		}
	}
	
    def delete = {
        def serviceProfileSOWDefInstance = ServiceProfileSOWDef.get(params.id)
        if (serviceProfileSOWDefInstance) {
            try {
                serviceProfileSOWDefInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'serviceProfileSOWDef.label', default: 'ServiceProfileSOWDef'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'serviceProfileSOWDef.label', default: 'ServiceProfileSOWDef'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceProfileSOWDef.label', default: 'ServiceProfileSOWDef'), params.id])}"
            redirect(action: "list")
        }
    }
}
