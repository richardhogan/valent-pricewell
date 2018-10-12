package com.valent.pricewell

import org.apache.shiro.SecurityUtils

class ObjectTypeController {

	def defaultEntityOperationService
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
        [objectTypeInstanceList: ObjectType.list(params), objectTypeInstanceTotal: ObjectType.count()]
    }

	def listsetup = {
		List objectTypes = []
		String title = ""
		if(params.type == "serviceDeliverable" || params.type[0] == "serviceDeliverable")
		{
			objectTypes = ObjectType.listObjectTypes(ObjectType.Type.SERVICE_DELIVERABLE)
			title = "Service Deliverable Types"
			session["objectType"] = "serviceDeliverable"
		}
		else if(params.type == "serviceActivity")
		{
			objectTypes = ObjectType.listObjectTypes(ObjectType.Type.SERVICE_ACTIVITY)
			title = "Service Activity Types"
			session["objectType"] = "serviceActivity"
		}
		else if(params.type == "serviceUnitOfSale")
		{
			objectTypes = ObjectType.listObjectTypes(ObjectType.Type.SERVICE_UNIT_OF_SALE)
			title = "Service Unit of Sale"
			session["objectType"] = "serviceUnitOfSale"
		}
		else if(params.type == "sowMilestone")
		{
			objectTypes = ObjectType.listObjectTypes(ObjectType.Type.SOW_MILESTONE)
			title = "SOW Milestone"
			session["objectType"] = "sowMilestone"
		}
		else if(params.type == "deliverablePhase")
		{
			objectTypes = ObjectType.listObjectTypes(ObjectType.Type.DELIVERABLE_PHASE)
			title = "Service Delivery Phases"
			session["objectType"] = "deliverablePhase"
		}
		
		
		render(template: "listsetup", model: [objectTypes: objectTypes, title: title, type: params.type, changeOrder: false])
	}
	
	def changeOrders = {
		List objectTypes = []
		String title = ""
		
		if(params.type == "deliverablePhase")
		{
			objectTypes = ObjectType.listObjectTypes(ObjectType.Type.DELIVERABLE_PHASE)
			title = "Service Delivery Phases"
			session["objectType"] = "deliverablePhase"
		}
		
		
		render(template: "listsetup", model: [objectTypes: objectTypes.sort{it.sequenceOrder}, title: title, type: params.type, changeOrder: true])
	}
	
	def saveOrder = {
		if(params.id)
		{
			def deliverablePhaseInstance = ObjectType.get(params.id)
			List objectTypes = ObjectType.listObjectTypes(ObjectType.Type.DELIVERABLE_PHASE).sort{it?.sequenceOrder}
			
			int i = 0
			
			for(ObjectType deliverablePhase: objectTypes)
			{
				if(deliverablePhase.id == deliverablePhaseInstance?.id)
				{
					if(params.order == "upOrder")
					{
						if(i != 0)
						{
							def tmpOrder = deliverablePhase.sequenceOrder
							deliverablePhase.sequenceOrder = objectTypes[i-1].sequenceOrder
							objectTypes[i-1].sequenceOrder = tmpOrder
							
							deliverablePhase.save()
							objectTypes[i-1].save()
						}
					}
					else
					{
						if(i != objectTypes.size()-1)
						{
							def tmpOrder = deliverablePhase.sequenceOrder
							deliverablePhase.sequenceOrder = objectTypes[i+1].sequenceOrder
							objectTypes[i+1].sequenceOrder = tmpOrder
							
							deliverablePhase.save()
							objectTypes[i+1].save()
						}
					}
					break
				}
				i++
			}
		}
		
		redirect(action: "changeOrders", params: [source: "firstsetup", type: params.type])
	}
	
	def create = {
        def objectTypeInstance = new ObjectType()
        objectTypeInstance.properties = params
		
		return [objectTypeInstance: objectTypeInstance]
    }
	
	def createsetup = {
		def objectTypeInstance = new ObjectType()
		objectTypeInstance.properties = params
		
		List<ObjectType.Type> objectTypeList = new ArrayList<ObjectType.Type>()
		objectTypeList.add(ObjectType.Type.DELIVERABLE_PHASE)
		objectTypeList.add(ObjectType.Type.SOW_MILESTONE)
		
		render(template: "createsetup", model: [objectTypeInstance: objectTypeInstance, objectTypeList: objectTypeList])
		
	}

	def createForSingleType = {
		def objectTypeInstance = new ObjectType()
		String updateId = ""
		if(params.updateId != "" && params.updateId != "" )
		{
			updateId = params.updateId
		}
		
		def entityType = (params.entityType?.toString() == "SERVICE_DELIVERABLE") ? ObjectType.Type.SERVICE_DELIVERABLE :
							((params.entityType?.toString() == "SERVICE_ACTIVITY") ? ObjectType.Type.SERVICE_ACTIVITY :
							((params.entityType?.toString() == "SERVICE_UNIT_OF_SALE") ? ObjectType.Type.SERVICE_UNIT_OF_SALE :
							((params.entityType?.toString() == "SOW_MILESTONE") ? ObjectType.Type.SOW_MILESTONE : "")))
		
		objectTypeInstance.properties = params
		render(template: "createForSelectedType", model: [objectTypeInstance: objectTypeInstance, entityType: entityType, updateId: updateId])
		
	}
	
    def save = {
        def objectTypeInstance = new ObjectType(params)
        if (objectTypeInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'objectType.label', default: 'ObjectType'), objectTypeInstance.id])}"
            redirect(action: "show", id: objectTypeInstance.id)
        }
        else {
            render(view: "create", model: [objectTypeInstance: objectTypeInstance])
        }
    }
	
	def checkForTypeAvailability = 
	{
		if(defaultEntityOperationService.isEntityTypeNameAvailable(params))
		{
			render "name_available"
		}
		else
		{
			render "name_not_available"
		}
	}
	
	def saveType = {
		def objectTypeInstance = new ObjectType(params)
		
		def type = (params.type?.toString() == "SERVICE_DELIVERABLE") ? "serviceDeliverable" :
						((params.type?.toString() == "SERVICE_ACTIVITY") ? "serviceActivity" :
							((params.type?.toString() == "SERVICE_UNIT_OF_SALE") ? "serviceUnitOfSale" :
								((params.type?.toString() == "SOW_MILESTONE") ? "sowMilestone" : "deliverablePhase")))
			
		if(type == "deliverablePhase")
		{
			int phaseSize = ObjectType.listObjectTypes(ObjectType.Type.DELIVERABLE_PHASE).size()
			objectTypeInstance.sequenceOrder = (phaseSize + 1)
		}

		if (objectTypeInstance.save(flush: true)) 
		{
			flash.message = "${message(code: 'default.created.message', args: [message(code: 'objectType.label', default: 'ObjectType'), objectTypeInstance.id])}"
			if(params.createdFrom == "setup")
			{
				redirect(action: "listsetup", params: [source: "firstsetup", type: type])
			}
			else
			{
				render "success"
			}
		}
		else {
			//render(view: "create", model: [objectTypeInstance: objectTypeInstance])
			redirect(action: "listsetup", params: [source: "firstsetup", type: "serviceDeliverable"])
		}
	}

    def show = {
        def objectTypeInstance = ObjectType.get(params.id)
        if (!objectTypeInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'objectType.label', default: 'ObjectType'), params.id])}"
            redirect(action: "list")
        }
        else {
            [objectTypeInstance: objectTypeInstance]
        }
    }

    def edit = {
        def objectTypeInstance = ObjectType.get(params.id)
        if (!objectTypeInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'objectType.label', default: 'ObjectType'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [objectTypeInstance: objectTypeInstance]
        }
    }
	
	def editsetup = {
		def objectTypeInstance = ObjectType.get(params.id?.toLong())
		if (!objectTypeInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'objectType.label', default: 'ObjectType'), params.id])}"
			//redirect(action: "list")
			redirect(action: "listsetup", params: [source: "firstsetup", type: "serviceDeliverable"])
		}
		else {
			//return [objectTypeInstance: objectTypeInstance]
			def type = (objectTypeInstance.type?.toString() == "SERVICE_DELIVERABLE") ? "serviceDeliverable" :
					((objectTypeInstance.type?.toString() == "SERVICE_ACTIVITY") ? "serviceActivity" :
						((objectTypeInstance.type?.toString() == "SERVICE_UNIT_OF_SALE") ? "serviceUnitOfSale" :
							((objectTypeInstance.type?.toString() == "SOW_MILESTONE") ? "sowMilestone" : "deliverablePhase")))
			
			render(template: "editsetup", model: [objectTypeInstance: objectTypeInstance, type: type])
		}
	}

    def update = {
        def objectTypeInstance = ObjectType.get(params.id)
        if (objectTypeInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (objectTypeInstance.version > version) {
                    
                    objectTypeInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'objectType.label', default: 'ObjectType')] as Object[], "Another user has updated this ObjectType while you were editing")
                    render(view: "edit", model: [objectTypeInstance: objectTypeInstance])
                    return
                }
            }
            objectTypeInstance.properties = params
            if (!objectTypeInstance.hasErrors() && objectTypeInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'objectType.label', default: 'ObjectType'), objectTypeInstance.id])}"
                redirect(action: "show", id: objectTypeInstance.id)
            }
            else {
                render(view: "edit", model: [objectTypeInstance: objectTypeInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'objectType.label', default: 'ObjectType'), params.id])}"
            redirect(action: "list")
        }
    }
	
	def updateType = {
		def objectTypeInstance = ObjectType.get(params.id?.toLong())
		
		if (objectTypeInstance) {
			
			//def type = (objectTypeInstance.type?.toString() == "SERVICE_DELIVERABLE") ? "serviceDeliverable" : "serviceActivity"
			
			def type = (objectTypeInstance.type?.toString() == "SERVICE_DELIVERABLE") ? "serviceDeliverable" :
							((objectTypeInstance.type?.toString() == "SERVICE_ACTIVITY") ? "serviceActivity" :
								((objectTypeInstance.type?.toString() == "SERVICE_UNIT_OF_SALE") ? "serviceUnitOfSale" :
									((objectTypeInstance.type?.toString() == "SOW_MILESTONE") ? "sowMilestone" : "deliverablePhase")))
					
			if (params.version) {
				def version = params.version.toLong()
				if (objectTypeInstance.version > version) {
					
					objectTypeInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'objectType.label', default: 'ObjectType')] as Object[], "Another user has updated this ObjectType while you were editing")
					redirect(action: "listsetup", params: [source: "firstsetup", type: type])
				}
			}
			objectTypeInstance.properties["name", "description"] = params
			if (!objectTypeInstance.hasErrors() && objectTypeInstance.save(flush: true)) {
				flash.message = "${message(code: 'default.updated.message', args: [message(code: 'objectType.label', default: 'ObjectType'), objectTypeInstance.id])}"
				redirect(action: "listsetup", params: [source: "firstsetup", type: type])
			}
			else {
				redirect(action: "listsetup", params: [source: "firstsetup", type: type])
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'objectType.label', default: 'ObjectType'), params.id])}"
			redirect(action: "listsetup", params: [source: "firstsetup", type: "serviceDeliverable"])
		}
	}

    def delete = {
        def objectTypeInstance = ObjectType.get(params.id)
        if (objectTypeInstance) {
            try {
                objectTypeInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'objectType.label', default: 'ObjectType'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'objectType.label', default: 'ObjectType'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'objectType.label', default: 'ObjectType'), params.id])}"
            redirect(action: "list")
        }
    }
	
	def deletesetup = {
		ObjectType objectTypeInstance = ObjectType.get(params.id.toLong())
		
		def type = (objectTypeInstance.type?.toString() == "SERVICE_DELIVERABLE") ? "serviceDeliverable" :
						((objectTypeInstance.type?.toString() == "SERVICE_ACTIVITY") ? "serviceActivity" :
							((objectTypeInstance.type?.toString() == "SERVICE_UNIT_OF_SALE") ? "serviceUnitOfSale" :
								((objectTypeInstance.type?.toString() == "SOW_MILESTONE") ? "sowMilestone" : "deliverablePhase")))
			
		
		if (objectTypeInstance) {
			try {
				objectTypeInstance.delete(flush: true)
				flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'objectType.label', default: 'ObjectType'), params.id])}"
				redirect(action: "listsetup", params: [source: "firstsetup", type: type])
			}
			catch (org.springframework.dao.DataIntegrityViolationException e) {
				flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'objectType.label', default: 'ObjectType'), params.id])}"
				//redirect(action: "show", id: params.id)
				redirect(action: "listsetup", params: [source: "firstsetup", type: type])
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'objectType.label', default: 'ObjectType'), params.id])}"
			//redirect(action: "list")
			redirect(action: "listsetup", params: [source: "firstsetup", type: "serviceDeliverable"])
		}
	}
}
