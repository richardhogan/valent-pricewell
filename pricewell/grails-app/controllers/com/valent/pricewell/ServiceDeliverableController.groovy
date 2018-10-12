package com.valent.pricewell
import org.apache.shiro.SecurityUtils

class ServiceDeliverableController {

	def serviceCatalogService
	
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
        [serviceDeliverableInstanceList: ServiceDeliverable.list(params), serviceDeliverableInstanceTotal: ServiceDeliverable.count()]
    }
	
	def listServiceDeliverables = {
		def pid = params.serviceProfileId
		
		if(params.serviceProfileId)
		{
			def serviceProfile = ServiceProfile.get(params.serviceProfileId)
			
			render(template: "/serviceDeliverable/listCustomerDeliverables", 
					model: [serviceProfileInstance: serviceProfile,
						deliverablesList: serviceProfile.listCustomerDeliverables(params)])
		}
	}

    def create = {
        def serviceDeliverableInstance = new ServiceDeliverable()
        serviceDeliverableInstance.properties = params
		
		List<String> deliverableTypes = ServiceDeliverable.executeQuery("SELECT DISTINCT UPPER(sd.type) from ServiceDeliverable sd ORDER BY sd.type ASC")
        return [serviceDeliverableInstance: serviceDeliverableInstance, deliverableTypes: deliverableTypes]
    }
	
	def createFromService = {
		if(!params.serviceProfileId)
		{
			flash.message = "Invalid Request";
			//TODO: Redirect appropriately 
		}
		
		def serviceDeliverableInstance = new ServiceDeliverable()
		
		def serviceProfileInstance = ServiceProfile.get(params.serviceProfileId)
		def deliverablesList = serviceProfileInstance.listCustomerDeliverables(params)
		
        serviceDeliverableInstance.properties = params
		
		List<String> deliverableTypes = ServiceDeliverable.executeQuery("SELECT DISTINCT UPPER(sd.type) from ServiceDeliverable sd ORDER BY sd.type ASC")
		
        render(template: "newCustomerDeliverable", 
					model:[deliverableTypes: deliverableTypes, serviceDeliverableInstance: serviceDeliverableInstance, serviceProfileInstance: serviceProfileInstance, serviceProfileId: params.serviceProfileId, deliverablesList: deliverablesList])
	}
	
	def upOrder = {
		
		if(params.serviceProfileId)
		{
			
			def serviceProfile = ServiceProfile.get(params.serviceProfileId)
			
			if(params.check)
			{
				def selectedId = params.check.toLong()
				List tmpList = serviceProfile.listCustomerDeliverables(params)
				int i = 0;
				
				while(i < tmpList.size())
				{
					if(tmpList[i].id == selectedId)
					{ 
						if(i == 0)
						{
							break
						}
						else
						{
							int tmp = tmpList[i].sequenceOrder
							tmpList[i].sequenceOrder = tmpList[i - 1].sequenceOrder   
							tmpList[i - 1].sequenceOrder = tmp
							tmpList[i].save(flush: true)
							tmpList[i - 1].save(flush: true)
							break;
						}
					}
						
					i++;					
				}
				
				
			}
			render(template: "/serviceDeliverable/changeOrders",
				model: [serviceProfileInstance: serviceProfile,
						deliverablesList: serviceProfile.listCustomerDeliverables(params)])
		}
		
		
	}
	
	def downOrder = {
		
		if(params.serviceProfileId)
		{
			def serviceProfile = ServiceProfile.get(params.serviceProfileId)
			
			if(params.check)
			{
				def selectedId = params.check.toLong()
				List tmpList = serviceProfile.listCustomerDeliverables(params)
				int i = 0;
				
				while(i < tmpList.size())
				{
					if(tmpList[i].id == selectedId)
					{
						if(i == (tmpList.size() - 1))
						{
							break
						}
						else
						{
							int tmp = tmpList[i].sequenceOrder
							tmpList[i].sequenceOrder = tmpList[i + 1].sequenceOrder
							tmpList[i + 1].sequenceOrder = tmp
							tmpList[i].save(flush: true)
							tmpList[i + 1].save(flush: true)
							break;
						}
					}
						
					i++;
				}
				
				
			}
			render(template: "/serviceDeliverable/changeOrders",
				model: [serviceProfileInstance: serviceProfile,
						deliverablesList: serviceProfile.listCustomerDeliverables(params)])
		}
	}
	
	def changeOrders = {
		
		if(params.serviceProfileId)
		{
			def serviceProfile = ServiceProfile.get(params.serviceProfileId)
			
			render(template: "/serviceDeliverable/changeOrders",
					model: [serviceProfileInstance: serviceProfile,
						deliverablesList: serviceProfile.listCustomerDeliverables(params)])
		}
	}
	
	def saveFromService = {
		if(!params.serviceProfileId)
		{
			flash.message = "Argument is not valid"
		}
		
		println params.serviceProfileId
		def serviceProfile = ServiceProfile.get(params.serviceProfileId)
		
		if(!serviceProfile)
		{
			flash.message = "Service Profile is not valid"
		}
		
		def serviceDeliverableInstance = new ServiceDeliverable()
		serviceDeliverableInstance.properties['sequenceOrder','name','type', 'phase'] = params
		
		def result = ServiceDeliverable.executeQuery("select max(del.sequenceOrder) from ServiceDeliverable del where del.serviceProfile.id = ${serviceProfile?.id}")
		int order = (result[0]?result[0]+1:1)
				
		serviceDeliverableInstance.sequenceOrder = order 
		
		serviceProfile = serviceProfile.addToCustomerDeliverables(serviceDeliverableInstance)
		serviceProfile.save(flush:true)
		if (serviceProfile) 
		{
			serviceCatalogService.createNewServiceDeliverableDescription(serviceDeliverableInstance, params.description)
			//serviceDeliverableInstance.save(flush:true)
			flash.message = "${message(code: 'default.created.fromServiceDeliverable', args: [message(code: 'serviceDeliverable.label', default: 'ServiceDeliverable'), serviceDeliverableInstance.name, serviceProfile.service.serviceName])}"
			render(template: "listCustomerDeliverables", model: [serviceProfileInstance: serviceProfile])
			//render(view: "/service/show", model: [serviceProfileInstance: serviceProfile, selectedTab: 'deliverables']) 
			//redirect(action: "show", id: serviceDeliverableInstance.id)
		}
		else {
			//TODO: redirect properly
			render(view: "create", model: [serviceDeliverableInstance: serviceDeliverableInstance])
		}
		
	}
	

    def save = {
        def serviceDeliverableInstance = new ServiceDeliverable(params)
		
        if (serviceDeliverableInstance.save(flush: true)) {
			 flash.message = "${message(code: 'default.created.message', args: [message(code: 'serviceDeliverable.label', default: 'ServiceDeliverable'), serviceDeliverableInstance.id])}"
            redirect(action: "show", id: serviceDeliverableInstance.id)
        }
        else {
            render(view: "create", model: [serviceDeliverableInstance: serviceDeliverableInstance])
        }
    }

    def show = {
        def serviceDeliverableInstance = ServiceDeliverable.get(params.id)
        if (!serviceDeliverableInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceDeliverable.label', default: 'ServiceDeliverable'), params.id])}"
            redirect(action: "list")
        }
        else {
            [serviceDeliverableInstance: serviceDeliverableInstance]
        }
    }

    def edit = {
        def serviceDeliverableInstance = ServiceDeliverable.get(params.id)
        if (!serviceDeliverableInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceDeliverable.label', default: 'ServiceDeliverable'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [serviceDeliverableInstance: serviceDeliverableInstance]
        }
    }
	
	def editFromService = {
		def serviceDeliverableInstance = ServiceDeliverable.get(params.id)
		if (!serviceDeliverableInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceDeliverable.label', default: 'ServiceDeliverable'), params.id])}"
			return
			//redirect(action: "list")
		}
		else {
			List<String> deliverableTypes = ServiceDeliverable.executeQuery("SELECT DISTINCT UPPER(sd.type) from ServiceDeliverable sd ORDER BY sd.type ASC")
			render(template: "editCustomerDeliverable", model: [deliverableTypes: deliverableTypes, serviceDeliverableInstance: serviceDeliverableInstance])
		}
	}
	
	def updateFromService = {
		def serviceDeliverableInstance = ServiceDeliverable.get(params.id)
		if (serviceDeliverableInstance) {
			if (params.version) {
				def version = params.version.toLong()
				if (serviceDeliverableInstance.version > version) {
					
					serviceDeliverableInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'serviceDeliverable.label', default: 'ServiceDeliverable')] as Object[], "Another user has updated this ServiceDeliverable while you were editing")
					return
				}
			}
			serviceDeliverableInstance.properties['sequenceOrder','name','type', 'phase'] = params
			serviceDeliverableInstance.newDescription.value = params.description 
			if (!serviceDeliverableInstance.hasErrors() && serviceDeliverableInstance.save(flush: true)) {
				flash.message = "${message(code: 'default.updated.message', args: [message(code: 'serviceDeliverable.label', default: 'ServiceDeliverable'), serviceDeliverableInstance.name])}"
				render(template: "listCustomerDeliverables", model: [serviceProfileInstance: serviceDeliverableInstance?.serviceProfile])
				//render(view: "/service/show", model: [serviceProfileInstance: serviceDeliverableInstance?.serviceProfile, selectedTab: 'deliverables'])
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
        def serviceDeliverableInstance = ServiceDeliverable.get(params.id)
        if (serviceDeliverableInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (serviceDeliverableInstance.version > version) {
                    
                    serviceDeliverableInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'serviceDeliverable.label', default: 'ServiceDeliverable')] as Object[], "Another user has updated this ServiceDeliverable while you were editing")
                    render(view: "edit", model: [serviceDeliverableInstance: serviceDeliverableInstance])
                    return
                }
            }
            serviceDeliverableInstance.properties = params
            if (!serviceDeliverableInstance.hasErrors() && serviceDeliverableInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'serviceDeliverable.label', default: 'ServiceDeliverable'), serviceDeliverableInstance.id])}"
                redirect(action: "show", id: serviceDeliverableInstance.id)
            }
            else {
                render(view: "edit", model: [serviceDeliverableInstance: serviceDeliverableInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceDeliverable.label', default: 'ServiceDeliverable'), params.id])}"
            redirect(action: "list")
        }
    }

	def deleteFromService = {
		def serviceDeliverableInstance = ServiceDeliverable.get(params.id)
		def name = serviceDeliverableInstance.name
		if (serviceDeliverableInstance) {
			try {
				def serviceProfile = serviceDeliverableInstance.serviceProfile
				serviceDeliverableInstance.delete(flush:true)
				flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'serviceDeliverable.label', default: 'ServiceDeliverable'), name])}"
				render(template: "/serviceDeliverable/listCustomerDeliverables", model: [serviceProfileInstance: serviceProfile] )
				//render(view: "/service/show", model: [serviceProfileInstance: serviceProfile, selectedTab: 'deliverables'])
			}
			catch (org.springframework.dao.DataIntegrityViolationException e) {
				flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'serviceDeliverable.label', default: 'ServiceDeliverable'), name])}"
				redirect(action: "show", id: params.id)
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceDeliverable.label', default: 'ServiceDeliverable'), name])}"
			redirect(action: "list")
		}
	}
    def delete = {
        def serviceDeliverableInstance = ServiceDeliverable.get(params.id)
		def name = serviceDeliverableInstance.name
        if (serviceDeliverableInstance) {
            try {
                serviceDeliverableInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'serviceDeliverable.label', default: 'ServiceDeliverable'), name])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'serviceDeliverable.label', default: 'ServiceDeliverable'), name])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceDeliverable.label', default: 'ServiceDeliverable'), name])}"
            redirect(action: "list")
        }
    }
}
