package com.valent.pricewell
import org.apache.shiro.SecurityUtils

class ServiceActivityController {

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
        [serviceActivityInstanceList: ServiceActivity.list(params), serviceActivityInstanceTotal: ServiceActivity.count()]
    }
	
	def listSelectedDeliverableActivities = {
		if(params.selectCustomerDeliverableId)
		{
			redirect(action: "listDeliverableActivities", id: params.selectCustomerDeliverableId)
		}
	}
	
	def listDeliverableActivities = {
		
		//println "listDeliverableActivities"
		if(params.id)
		{
			//println "id exists"
			def del = ServiceDeliverable.get(params.id);
			def activitiesList = del.listServiceActivities(params)
			println del
			boolean isImported = false
			if(del.serviceProfile?.isImported == "true")
			{
				isImported = true
			}
			
			/*if(activitiesList && activitiesList.size() > 0)
			{
				render(template: "listDeliverableActivities", model: [serviceDeliverableInstance: del, activitiesList: activitiesList])
			}	
			else
			{
				render(template: "createDeliverableActivity", model: [serviceDeliverableId: del.id, deliverable: del, activitiesList: activitiesList])
				
			}*/
			
			List<String> serviceActivityCategories = ServiceActivity.executeQuery("SELECT DISTINCT UPPER(sa.category) from ServiceActivity sa WHERE sa.category != null ORDER BY sa.category ASC")
			
			render(template: "deliverableActivities", model: [del: del,activitiesList: activitiesList, isImported: isImported, serviceActivityCategories: serviceActivityCategories])
		}
	}
	
	def changeOrders = {
		if(params.id)
		{
			def del = ServiceDeliverable.get(params.id);
			
			render(template: "changeOrders", model: [serviceDeliverableInstance: del,
						activitiesList: del.listServiceActivities(params)])
		}
	}
	
	def upOrder = {
		
		if(params.id)
		{
			
			def del = ServiceDeliverable.get(params.id);
			
			if(params.check)
			{
				def selectedId = params.check.toLong()
				List tmpList = del.listServiceActivities(params)
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
				
				render(template: "changeOrders", model: [serviceDeliverableInstance: del,
									activitiesList: del.listServiceActivities(params)])
			}
		}
		
	}
	
	def downOrder = {
		
		if(params.id)
		{		
			def del = ServiceDeliverable.get(params.id);
			
			if(params.check)
			{
				def selectedId = params.check.toLong()
				List tmpList = del.listServiceActivities(params)
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
				
				render(template: "changeOrders", model: [serviceDeliverableInstance: del,
						activitiesList: del.listServiceActivities(params)])
			}
		}
	}
	

    def create = {
        def serviceActivityInstance = new ServiceActivity()
        serviceActivityInstance.properties = params
        return [serviceActivityInstance: serviceActivityInstance]
    }
	
	def newActivityFromDeliverable = {
		if(params.id)
		{
			def del = ServiceDeliverable.get(params.id)
			def serviceActivityInstance = new ServiceActivity()
			List<String> serviceActivityCategories = ServiceActivity.executeQuery("SELECT DISTINCT UPPER(sa.category) from ServiceActivity sa WHERE sa.category != null ORDER BY sa.category ASC")
			
			render(template: "createDeliverableActivity", 
					model:[serviceActivityInstance: serviceActivityInstance, 
								serviceDeliverableId: params.id, deliverable: del, serviceActivityCategories: serviceActivityCategories])
		}
	}
	
	def saveFromDeliverable = 
	{
		if(params.serviceDeliverableId)
		{
			def del = ServiceDeliverable.get(params.serviceDeliverableId)
			
			def serviceActivityInstance = new ServiceActivity()
			
			serviceActivityInstance.properties['name','description',
											'estimatedTimeInHoursFlat', 'estimatedTimeInHoursPerBaseUnits', 'category',
											'sequenceOrder', 'results'] = params
	
			def result = ServiceActivity.executeQuery("select max(act.sequenceOrder) from ServiceActivity act where act.serviceDeliverable.id = ${del?.id}")
			int order = (result[0]?result[0]+1:1)
					
			serviceActivityInstance.sequenceOrder = order
			serviceActivityInstance.estimatedTimeInHoursFlat = new BigDecimal(0)
			serviceActivityInstance.estimatedTimeInHoursPerBaseUnits = new BigDecimal(0)
			
			del.addToServiceActivities(serviceActivityInstance)
			serviceActivityInstance.save(flush: true)
			if(serviceActivityInstance)
			{
				String tasks = params.activityTasks.replaceAll("\"", "").replaceAll("\\[", "").replaceAll("\\]", "").replaceAll(" ", "")
				ArrayList taskList =  tasks != "" ? ((!tasks.contains(",")) ? [tasks] : tasks.split(",")) : []
				
				ArrayList<ServiceActivityTask> serviceActivityTaskList = serviceCatalogService.getActivityTasks(taskList)
				serviceCatalogService.addServiceActivityTaskToServiceActivity(serviceActivityInstance, serviceActivityTaskList)
				
				//updateActivityRoles(serviceActivityInstance, params);
				
				del.save(flush:true)
				//flash.message = "${message(code: 'default.created.message.activity', args: [message(code: 'serviceActivity.label', default: 'ServiceActivity'), serviceActivityInstance.name, del.name])}"			
				render(template:'showActivity', model:[serviceActivityInstance: serviceActivityInstance, edit: false])
				//redirect(action: "listDeliverableActivities", id: serviceActivityInstance?.serviceDeliverable?.id)
				
			}
			else
			{
				flash.message = "Error while saving service Activity"
			}
		}
		else
		{
			
			flash.message = "Not valid service Deliverable id"
			//TODO: redirect properly	
		}
	}

	def getActivityTaskList = {
		def serviceActivityInstance = ServiceActivity.get(params.id)
		serviceCatalogService.correctServiceActivityTaskSequenceOrder(serviceActivityInstance)
		//println serviceActivityInstance?.activityTasks
		render(template:'/serviceActivityTask/activityTaskListReadOnly', model:[serviceActivityInstance: serviceActivityInstance, serviceActivityTaskList: serviceActivityInstance?.activityTasks?.sort{it.sequenceOrder}, edit: false])
	}
	
	
	def isRoleDefined = {
		def serviceActivityInstance = ServiceActivity.get(params.id)
		if(serviceActivityInstance?.rolesRequired.size() > 0)
			render "success"
		else
			render "fail"
	}
	
	def showActivity = {
		def serviceActivityInstance = ServiceActivity.get(params.id)
		render(template:'showActivity', model:[serviceActivityInstance: serviceActivityInstance])
	}
	
    def save = {
        def serviceActivityInstance = new ServiceActivity(params)
        if (serviceActivityInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'serviceActivity.label', default: 'ServiceActivity'), serviceActivityInstance.id])}"
            redirect(action: "show", id: serviceActivityInstance.id)
        }
        else {
            render(view: "create", model: [serviceActivityInstance: serviceActivityInstance])
        }
    }
	
	def show = {
        def serviceActivityInstance = ServiceActivity.get(params.id)
        if (!serviceActivityInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceActivity.label', default: 'ServiceActivity'), params.id])}"
            redirect(action: "list")
        }
        else {
            [serviceActivityInstance: serviceActivityInstance]
        }
    }

    def edit = {
        def serviceActivityInstance = ServiceActivity.get(params.id)
        if (!serviceActivityInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceActivity.label', default: 'ServiceActivity'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [serviceActivityInstance: serviceActivityInstance]
        }
    }
	
	def editInfo = {
		def serviceActivityInstance = ServiceActivity.get(params.id)
		List<String> serviceActivityCategories = ServiceActivity.executeQuery("SELECT DISTINCT UPPER(sa.category) from ServiceActivity sa WHERE sa.category != null ORDER BY sa.category ASC")

		boolean edit = true
		render(template: "editActivity", model: [serviceActivityInstance: serviceActivityInstance, edit: edit, serviceActivityCategories: serviceActivityCategories])
		
	}
	
	def editFromDeliverable = {
		def serviceActivityInstance = ServiceActivity.get(params.id)
		if (!serviceActivityInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceActivity.label', default: 'ServiceActivity'), params.id])}"
			redirect(action: "list")
		}
		else {
			serviceCatalogService.correctServiceActivityTaskSequenceOrder(serviceActivityInstance)
			boolean edit = true
			render(template: "editDeliverableActivity", model: [serviceActivityInstance: serviceActivityInstance, edit: edit])
			
		}
	}
	
	def displayActivityTasks = {
		def serviceActivityInstance = ServiceActivity.get(params.id)
		List taskIdList = new ArrayList()
		
		for(ServiceActivityTask saTask : serviceActivityInstance?.activityTasks?.sort{it.sequenceOrder})
		{
			taskIdList.add(saTask?.id)
		}
		
		println taskIdList.toArray().toString()
		render(template: "displayActivityTasks", model: [serviceActivityInstance: serviceActivityInstance, activityTaskList: serviceActivityInstance?.activityTasks?.sort{it.sequenceOrder}, activityTaskIds: taskIdList.toArray().toString()])
	}
	
	def updateFromDeliverable = {
		def serviceActivityInstance = ServiceActivity.get(params.id)
		if (serviceActivityInstance) {
			if (params.version) {
				def version = params.version.toLong()
				if (serviceActivityInstance.version > version) {
					
					serviceActivityInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'serviceActivity.label', default: 'ServiceActivity')] as Object[], "Another user has updated this ServiceActivity while you were editing")
					render(view: "edit", model: [serviceActivityInstance: serviceActivityInstance])
					return
				}
			}
			
			
			serviceActivityInstance.properties['name','description',
										'estimatedTimeInHoursFlat', 'estimatedTimeInHoursPerBaseUnits', 'category',
										'sequenceOrder', 'results'] = params
			
			//updateActivityRoles(serviceActivityInstance, params);				
			
			if (!serviceActivityInstance.hasErrors() && serviceActivityInstance.save(flush: true)) {
				flash.message = "${message(code: 'default.updated.message', args: [message(code: 'serviceActivity.label', default: 'ServiceActivity'), serviceActivityInstance.name])}"
				//redirect(action: "listDeliverableActivities", id: serviceActivityInstance?.serviceDeliverable?.id)
				redirect(action: "editFromDeliverable", id: serviceActivityInstance?.id)
			}
			else {
				render(template: "editFromDeliverable", model: [serviceActivityInstance: serviceActivityInstance])
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceActivity.label', default: 'ServiceActivity'), params.id])}"
			redirect(action: "list")
		}
	}
	
	private void updateActivityRoles(ServiceActivity serviceActivityInstance, Object params)
	{
		int count = 0;
		
		while(true){
			Object var = params["rolesEstimatedTimeList[${count}]"]
			
			if(!var){
				break;
			}
			//println var
			if(var.deleted == "true" && var.new == "false" && var.id.isNumber()){
				ActivityRoleTime ar = ActivityRoleTime.get(var.id.toLong());
				serviceActivityInstance.removeFromRolesEstimatedTime(ar);
			}
			else if(var.new == "true" && var.deleted == "false"){
				ActivityRoleTime ar = new ActivityRoleTime();
				ar.properties = var;
				serviceActivityInstance.addToRolesEstimatedTime(ar);
			}
			else if(var.id.isNumber()){
				ActivityRoleTime ar = ActivityRoleTime.get(var.id.toLong());
				
				ar.properties = var;
				
				ar.save(flush:true);
			}
			
			count++;
		}
		
		serviceActivityInstance.rolesRequired = null
		serviceActivityInstance.estimatedTimeInHoursFlat=new BigDecimal(0)
		serviceActivityInstance.estimatedTimeInHoursPerBaseUnits=new BigDecimal(0)
		
		for(ActivityRoleTime rt in serviceActivityInstance.rolesEstimatedTime){
			
			serviceActivityInstance.estimatedTimeInHoursFlat+=new BigDecimal(rt?.estimatedTimeInHoursFlat)
			serviceActivityInstance.estimatedTimeInHoursPerBaseUnits+=new BigDecimal(rt?.estimatedTimeInHoursPerBaseUnits)
			serviceActivityInstance?.addToRolesRequired(rt.role)			
		}
		
		serviceActivityInstance.save(flush:true);
	}

    def update = {
        def serviceActivityInstance = ServiceActivity.get(params.id)
        if (serviceActivityInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (serviceActivityInstance.version > version) {
                    
                    serviceActivityInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'serviceActivity.label', default: 'ServiceActivity')] as Object[], "Another user has updated this ServiceActivity while you were editing")
                    render(view: "edit", model: [serviceActivityInstance: serviceActivityInstance])
                    return
                }
            }
            serviceActivityInstance.properties = params
            if (!serviceActivityInstance.hasErrors() && serviceActivityInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'serviceActivity.label', default: 'ServiceActivity'), serviceActivityInstance.id])}"
                redirect(action: "show", id: serviceActivityInstance.id)
            }
            else {
                render(view: "edit", model: [serviceActivityInstance: serviceActivityInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceActivity.label', default: 'ServiceActivity'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def serviceActivityInstance = ServiceActivity.get(params.id)
        if (serviceActivityInstance) {
            try {
                serviceActivityInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'serviceActivity.label', default: 'ServiceActivity'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'serviceActivity.label', default: 'ServiceActivity'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceActivity.label', default: 'ServiceActivity'), params.id])}"
            redirect(action: "list")
        }
    }
	
	def deleteFromDeliverable = {
		def serviceActivityInstance = ServiceActivity.get(params.id)
		def name =  serviceActivityInstance.name
		def del = serviceActivityInstance.serviceDeliverable
		if (serviceActivityInstance) {
			try {
				serviceActivityInstance.delete(flush: true)
				flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'serviceActivity.label', default: 'ServiceActivity'), name])}"
				redirect(action: "listDeliverableActivities", id: del?.id)
			}
			catch (org.springframework.dao.DataIntegrityViolationException e) {
				flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'serviceActivity.label', default: 'ServiceActivity'), name])}"
				redirect(action: "show", id: params.id)
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceActivity.label', default: 'ServiceActivity'), name])}"
			redirect(action: "list")
		}
	}
}
