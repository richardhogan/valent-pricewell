package com.valent.pricewell
import org.apache.shiro.SecurityUtils

class ServiceProfileMetaphorsController {

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
        [serviceProfileMetaphorsInstanceList: ServiceProfileMetaphors.list(params), serviceProfileMetaphorsInstanceTotal: ServiceProfileMetaphors.count()]
    }
	
	def listMetaphors = {
		def serviceProfileInstance = ServiceProfile.get(params.serviceProfileId)
		
		List metaphorsList = getServiceProfileMetaphorsByType(serviceProfileInstance, params.metaphorType)
		
		if(metaphorsList.size() > 0)
		{
			render(template: "listMetaphors", model: [serviceProfileInstance: serviceProfileInstance, metaphorsList: metaphorsList, metaphorType: params.metaphorType, entityName: correctEntityName(params.entityName)])
		}
		else
		{
			redirect(action: "createFromService", params: [serviceProfileId : serviceProfileInstance.id, metaphorType: params.metaphorType, entityName: correctEntityName(params.entityName)])
		}
		
	}

    def create = {
        def serviceProfileMetaphorsInstance = new ServiceProfileMetaphors()
        serviceProfileMetaphorsInstance.properties = params
        return [serviceProfileMetaphorsInstance: serviceProfileMetaphorsInstance]
    }

	def createFromService = {
		if(!params.serviceProfileId)
		{
			flash.message = "Invalid Request";
			//TODO: Redirect appropriately
		}
		
		def serviceProfileMetaphorsInstance = new ServiceProfileMetaphors()
		def serviceProfileInstance = ServiceProfile.get(params.serviceProfileId)
		
		List metaphorsList = getServiceProfileMetaphorsByType(serviceProfileInstance, params.metaphorType)
		
		render(template: "createMetaphors",	model:[serviceProfileMetaphorsInstance: serviceProfileMetaphorsInstance, serviceProfileId: params.serviceProfileId, metaphorsList: metaphorsList, metaphorType: params.metaphorType, entityName: correctEntityName(params.entityName)])
	}
	
    def save = {
        def serviceProfileMetaphorsInstance = new ServiceProfileMetaphors(params)
        if (serviceProfileMetaphorsInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'serviceProfileMetaphors.label', default: 'ServiceProfileMetaphors'), serviceProfileMetaphorsInstance.id])}"
            redirect(action: "show", id: serviceProfileMetaphorsInstance.id)
        }
        else {
            render(view: "create", model: [serviceProfileMetaphorsInstance: serviceProfileMetaphorsInstance])
        }
    }

	def saveFromService = {
		
		if(!params.serviceProfileId)
		{
			flash.message = "Argument is not valid"
		}
		
		def serviceProfile = ServiceProfile.get(params.serviceProfileId)
		List metaphorsList = new ArrayList()
		def name = ""
		
		if(!serviceProfile)
		{
			flash.message = "Service Profile is not valid"
		}
	
		ServiceProfileMetaphors serviceProfileMetaphorsInstance = new ServiceProfileMetaphors()
		
		if(params.metaphorType == "preRequisite")
		{
			metaphorsList = serviceProfile.listServiceProfileMetaphors(ServiceProfileMetaphors.MetaphorsType.PRE_REQUISITE)
			serviceProfileMetaphorsInstance.type = ServiceProfileMetaphors.MetaphorsType.PRE_REQUISITE
			name = "metaphors_pre_requisite"
		}
		else if(params.metaphorType == "outOfScope")
		{
			metaphorsList = serviceProfile.listServiceProfileMetaphors(ServiceProfileMetaphors.MetaphorsType.OUT_OF_SCOPE)
			serviceProfileMetaphorsInstance.type = ServiceProfileMetaphors.MetaphorsType.OUT_OF_SCOPE
			name = "metaphors_out_of_scope"
		}
		
		serviceProfileMetaphorsInstance.sequenceOrder = metaphorsList?.size() + 1 //serviceProfile?.metaphors?.size() + 1
		serviceProfileMetaphorsInstance.definitionString = new Setting(name: name, value: params.description.toString()).save()
		serviceProfileMetaphorsInstance.serviceProfile = serviceProfile
		
		if (serviceProfileMetaphorsInstance.save(flush: true)) {
			flash.message = "${message(code: 'default.created.message', args: [message(code: 'serviceProfileMetaphors.label', default: 'ServiceProfileMetaphors'), serviceProfileMetaphorsInstance.id])}"
			//redirect(action: "show", id: serviceProfileMetaphorsInstance.id)
			redirect(action: "listMetaphors", params: [serviceProfileId : serviceProfile.id, metaphorType: params.metaphorType, entityName: correctEntityName(params.entityName)])
		}
		else {
			//render(view: "create", model: [serviceProfileMetaphorsInstance: serviceProfileMetaphorsInstance])
			redirect(action: "createFromService", params: [serviceProfileId : serviceProfile.id, metaphorType: params.metaphorType, entityName: correctEntityName(params.entityName)])
		}
	}
	
    def show = {
        def serviceProfileMetaphorsInstance = ServiceProfileMetaphors.get(params.id)
        if (!serviceProfileMetaphorsInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceProfileMetaphors.label', default: 'ServiceProfileMetaphors'), params.id])}"
            redirect(action: "list")
        }
        else {
            [serviceProfileMetaphorsInstance: serviceProfileMetaphorsInstance]
        }
    }

    def edit = {
        def serviceProfileMetaphorsInstance = ServiceProfileMetaphors.get(params.id)
        if (!serviceProfileMetaphorsInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceProfileMetaphors.label', default: 'ServiceProfileMetaphors'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [serviceProfileMetaphorsInstance: serviceProfileMetaphorsInstance]
        }
    }

	def editFromService = {
		
		def serviceProfileMetaphorsInstance = ServiceProfileMetaphors.get(params.id.toLong())
		if (!serviceProfileMetaphorsInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceProfileSOWDef.label', default: 'ServiceProfileSOWDef'), params.id])}"
			//redirect(action: "list")
		}
		else {
			def serviceProfileInstance = ServiceProfile.get(serviceProfileMetaphorsInstance?.serviceProfile?.id)
			List metaphorsList = getServiceProfileMetaphorsByType(serviceProfileInstance, params.metaphorType)
			
			render(template: "editMetaphors", model:[serviceProfileMetaphorsInstance: serviceProfileMetaphorsInstance, serviceProfileId: serviceProfileInstance?.id, metaphorsList: metaphorsList, metaphorType: params.metaphorType, entityName: correctEntityName(params.entityName)])
		}
		
	}
	
    def update = {
        def serviceProfileMetaphorsInstance = ServiceProfileMetaphors.get(params.id)
        if (serviceProfileMetaphorsInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (serviceProfileMetaphorsInstance.version > version) {
                    
                    serviceProfileMetaphorsInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'serviceProfileMetaphors.label', default: 'ServiceProfileMetaphors')] as Object[], "Another user has updated this ServiceProfileMetaphors while you were editing")
                    render(view: "edit", model: [serviceProfileMetaphorsInstance: serviceProfileMetaphorsInstance])
                    return
                }
            }
            serviceProfileMetaphorsInstance.properties = params
            if (!serviceProfileMetaphorsInstance.hasErrors() && serviceProfileMetaphorsInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'serviceProfileMetaphors.label', default: 'ServiceProfileMetaphors'), serviceProfileMetaphorsInstance.id])}"
                redirect(action: "show", id: serviceProfileMetaphorsInstance.id)
            }
            else {
                render(view: "edit", model: [serviceProfileMetaphorsInstance: serviceProfileMetaphorsInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceProfileMetaphors.label', default: 'ServiceProfileMetaphors'), params.id])}"
            redirect(action: "list")
        }
    }
	
	def updateFromService = {
		ServiceProfileMetaphors serviceProfileMetaphorsInstance = ServiceProfileMetaphors.get(params.id)
		ServiceProfile serviceProfile = ServiceProfile.get(params.serviceProfileId.toLong())
		if (serviceProfileMetaphorsInstance) {
			if (params.version) {
				def version = params.version.toLong()
				if (serviceProfileMetaphorsInstance.version > version) {
					
					serviceProfileMetaphorsInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'serviceProfileMetaphors.label', default: 'ServiceProfileMetaphors')] as Object[], "Another user has updated this ServiceProfileMetaphors while you were editing")
					render(view: "edit", model: [serviceProfileMetaphorsInstance: serviceProfileMetaphorsInstance])
					return
				}
			}
			serviceProfileMetaphorsInstance.definitionString?.value = params.description
			if (!serviceProfileMetaphorsInstance.hasErrors() && serviceProfileMetaphorsInstance.save(flush: true)) {
				flash.message = "${message(code: 'default.updated.message', args: [message(code: 'serviceProfileMetaphors.label', default: 'ServiceProfileMetaphors'), serviceProfileMetaphorsInstance.id])}"
				//redirect(action: "show", id: serviceProfileMetaphorsInstance.id)
				redirect(action: "listMetaphors", params: [serviceProfileId : serviceProfileMetaphorsInstance?.serviceProfile.id, metaphorType: params.metaphorType, entityName: correctEntityName(params.entityName)])
			}
			else {
				//render(view: "edit", model: [serviceProfileMetaphorsInstance: serviceProfileMetaphorsInstance])
				redirect(action: "editFromService", params: [id: serviceProfileMetaphorsInstance.id, metaphorType: params.metaphorType, entityName: correctEntityName(params.entityName)])
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceProfileMetaphors.label', default: 'ServiceProfileMetaphors'), params.id])}"
			//redirect(action: "list")
			redirect(action: "listMetaphors", params: [serviceProfileId : serviceProfile.id, metaphorType: params.metaphorType, entityName: correctEntityName(params.entityName)])
		}
	}

	def deleteFromService = {
		ServiceProfileMetaphors serviceProfileMetaphorsInstance = ServiceProfileMetaphors.get(params.id.toLong())
		
		if (serviceProfileMetaphorsInstance) {
			try {
				Setting definitionString = serviceProfileMetaphorsInstance?.definitionString
				def serviceProfile = serviceProfileMetaphorsInstance.serviceProfile
				
				serviceProfileMetaphorsInstance.delete(flush:true)
				definitionString.delete(flush: true)
				
				flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'serviceProfileMetaphors.label', default: 'ServiceProfileMetaphors'), params.id])}"
				redirect(action: "listMetaphors", params: [serviceProfileId : serviceProfile.id, metaphorType: params.metaphorType, entityName: correctEntityName(params.entityName)])
				//render(view: "/service/show", model: [serviceProfileInstance: serviceProfile, selectedTab: 'deliverables'])
			}
			catch (org.springframework.dao.DataIntegrityViolationException e) {
				flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'serviceProfileMetaphors.label', default: 'ServiceProfileMetaphors'), params.id])}"
                redirect(action: "show", id: params.id)
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceProfileMetaphors.label', default: 'ServiceProfileMetaphors'), params.id])}"
            redirect(action: "list")
		}
	}
	
    def delete = {
        def serviceProfileMetaphorsInstance = ServiceProfileMetaphors.get(params.id)
        if (serviceProfileMetaphorsInstance) {
            try {
                serviceProfileMetaphorsInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'serviceProfileMetaphors.label', default: 'ServiceProfileMetaphors'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'serviceProfileMetaphors.label', default: 'ServiceProfileMetaphors'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceProfileMetaphors.label', default: 'ServiceProfileMetaphors'), params.id])}"
            redirect(action: "list")
        }
    }
	
	public List getServiceProfileMetaphorsByType(ServiceProfile serviceProfileInstance, String metaphorType)
	{
		List metaphorsList = new ArrayList()
		
		if(metaphorType == "preRequisite")
		{
			metaphorsList = serviceProfileInstance.listServiceProfileMetaphors(ServiceProfileMetaphors.MetaphorsType.PRE_REQUISITE)
		}
		else if(metaphorType == "outOfScope")
		{
			metaphorsList = serviceProfileInstance.listServiceProfileMetaphors(ServiceProfileMetaphors.MetaphorsType.OUT_OF_SCOPE)
		}
		
		return metaphorsList
	}
	
	public String correctEntityName(String entityName)
	{
		entityName = entityName.replaceAll("[+]", " ")
		//println entityName
		return entityName
	}
}
