package com.valent.pricewell

import org.apache.shiro.SecurityUtils
import grails.converters.JSON
import org.json.simple.JSONObject;
import org.json.JSONObject

import com.valent.pricewell.ObjectType.Type

class ServiceActivityTaskController {

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
        [serviceActivityTaskInstanceList: ServiceActivityTask.list(params), serviceActivityTaskInstanceTotal: ServiceActivityTask.count()]
    }
	
	def updateSequenceOrder = {
		ServiceActivityTask serviceActivityTaskInstance = ServiceActivityTask.get(params.id)
		
		if(serviceActivityTaskInstance){
			serviceActivityTaskInstance.sequenceOrder = params.sequenceOrder.toInteger()
			serviceActivityTaskInstance.save()
			render "success"
		}
		else render "fail"
		
	}
	
	def listServiceActivityTasks = {
		
		def serviceActivity = null
		if(params.activityId != "" && params.activityId != null && params.activityId != "null" && params.activityId != "new")
		{
			serviceActivity = ServiceActivity.get(params.activityId.toLong())
		}
		
		String tasks = params.taskList.replaceAll("\"", "").replaceAll("\\[", "").replaceAll("\\]", "").replaceAll(" ", "")//.replaceAll("\\", "")
		println tasks
		ArrayList taskList =  (tasks != "" ? ((!tasks.contains(",")) ? [tasks] : tasks.split(",")) : [])
		
		ArrayList<ServiceActivityTask> serviceActivityTaskList = serviceCatalogService.getActivityTasks(taskList)
		
		render(template: "activityTaskList", model: [serviceActivityTaskList: serviceActivityTaskList, activityId: serviceActivity?.id ])
	}
	
	def create = {
        def serviceActivityTaskInstance = new ServiceActivityTask()
        serviceActivityTaskInstance.properties = params
        return [serviceActivityTaskInstance: serviceActivityTaskInstance]
    }
	
	def createFromServiceActivity = {
		def serviceActivity = null
		def templateRender = "create"
		if(params.activityId != "" && params.activityId != null && params.activityId != "null" && params.activityId != "new")
		{
			serviceActivity = ServiceActivity.get(params.activityId.toLong())
			//templateRender = "createFromEditActivity"
		}
		def serviceActivityTaskInstance = new ServiceActivityTask()
		serviceActivityTaskInstance.properties = params
		render(template: templateRender, model: [serviceActivityTaskInstance: serviceActivityTaskInstance, serviceActivityInstance: serviceActivity])
		//return [serviceActivityTaskInstance: serviceActivityTaskInstance]
	}

    def save = {
		Map resultMap = [:]
		def serviceActivity = null
		if(params.activityId != "" && params.activityId != null && params.activityId != "null" && params.activityId != "new")
		{
			serviceActivity = ServiceActivity.get(params.activityId.toLong())
		}
		
        def serviceActivityTaskInstance = new ServiceActivityTask(params)
        if (serviceActivityTaskInstance.save(flush: true)) {
            //flash.message = "${message(code: 'default.created.message', args: [message(code: 'serviceActivityTask.label', default: 'ServiceActivityTask'), serviceActivityTaskInstance.id])}"
            //redirect(action: "show", id: serviceActivityTaskInstance.id)
			
			if(serviceActivity)
			{
				serviceActivity.addToActivityTasks(serviceActivityTaskInstance)
				serviceActivity.save()
			}
			
			
			resultMap['taskId'] = serviceActivityTaskInstance.id
			resultMap['result'] = "success"
			render resultMap as JSON
        }
        else {
			
			resultMap['result'] = "fail"
			render resultMap as JSON
			
            //render(view: "create", model: [serviceActivityTaskInstance: serviceActivityTaskInstance])
        }
    }
	
	def changeOrders = {
		if(params.activityTasks)
		{
			String tasks = params.activityTasks.replaceAll("\"", "").replaceAll("\\[", "").replaceAll("\\]", "").replaceAll(" ", "")
			ArrayList taskList =  tasks != "" ? ((!tasks.contains(",")) ? [tasks] : tasks.split(",")) : []
			
			ArrayList<ServiceActivityTask> serviceActivityTaskList = serviceCatalogService.getActivityTasks(taskList)
			
			render(template: "changeOrders", model: [activityTaskList: serviceActivityTaskList, activityTasks: params.activityTasks])
		}
	}

	def upOrder = {
		
		if(params.activityTasks)
		{
			String tasks = params.activityTasks.replaceAll("\"", "").replaceAll("\\[", "").replaceAll("\\]", "").replaceAll(" ", "")
			ArrayList taskList =  tasks != "" ? ((!tasks.contains(",")) ? [tasks] : tasks.split(",")) : []
			
			ArrayList<ServiceActivityTask> serviceActivityTaskList = serviceCatalogService.getActivityTasks(taskList)
			
			if(params.check)
			{
				def selectedId = params.check.toLong()
				
				ArrayList<ServiceActivityTask> tmpList = serviceActivityTaskList
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
			
			render(template: "changeOrders", model: [activityTaskList: serviceActivityTaskList.sort{it?.sequenceOrder}, activityTasks: params.activityTasks])
			
		}
		
	}

	def downOrder = {
		
		if(params.activityTasks)
		{
			String tasks = params.activityTasks.replaceAll("\"", "").replaceAll("\\[", "").replaceAll("\\]", "").replaceAll(" ", "")
			ArrayList taskList =  tasks != "" ? ((!tasks.contains(",")) ? [tasks] : tasks.split(",")) : []
			
			ArrayList<ServiceActivityTask> serviceActivityTaskList = serviceCatalogService.getActivityTasks(taskList)
			
			if(params.check)
			{
				def selectedId = params.check.toLong()
				
				ArrayList<ServiceActivityTask> tmpList = serviceActivityTaskList
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
			
			render(template: "changeOrders", model: [activityTaskList: serviceActivityTaskList, activityTasks: params.activityTasks])
			
		}
		
	}
	
    def show = {
        def serviceActivityTaskInstance = ServiceActivityTask.get(params.id)
        if (!serviceActivityTaskInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceActivityTask.label', default: 'ServiceActivityTask'), params.id])}"
            redirect(action: "list")
        }
        else {
            [serviceActivityTaskInstance: serviceActivityTaskInstance]
        }
    }

    def edit = {
        def serviceActivityTaskInstance = ServiceActivityTask.get(params.id)
        if (!serviceActivityTaskInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceActivityTask.label', default: 'ServiceActivityTask'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [serviceActivityTaskInstance: serviceActivityTaskInstance]
        }
    }

	def editFromServiceActivity = {
		def serviceActivityTaskInstance = ServiceActivityTask.get(params.id)
		def serviceActivity = null
		
		def templateRender = "edit"
		if(params.activityId != "" && params.activityId != null && params.activityId != "null" && params.activityId != "new")
		{
			serviceActivity = ServiceActivity.get(params.activityId.toLong())
			//templateRender = "editFromEditActivity"
		}
		
		if (!serviceActivityTaskInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceActivityTask.label', default: 'ServiceActivityTask'), params.id])}"
			//redirect(action: "list")
		}
		else {
			render(template: templateRender, model: [serviceActivityTaskInstance: serviceActivityTaskInstance])
		}
	}
	
    def update = {
        def serviceActivityTaskInstance = ServiceActivityTask.get(params.id)
		Map resultMap = new HashMap()
        if (serviceActivityTaskInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (serviceActivityTaskInstance.version > version) {
                    
                    serviceActivityTaskInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'serviceActivityTask.label', default: 'ServiceActivityTask')] as Object[], "Another user has updated this ServiceActivityTask while you were editing")
                    render(view: "edit", model: [serviceActivityTaskInstance: serviceActivityTaskInstance])
                    return
                }
            }
            serviceActivityTaskInstance.properties = params
            if (!serviceActivityTaskInstance.hasErrors() && serviceActivityTaskInstance.save(flush: true)) {
                //flash.message = "${message(code: 'default.updated.message', args: [message(code: 'serviceActivityTask.label', default: 'ServiceActivityTask'), serviceActivityTaskInstance.id])}"
                //redirect(action: "show", id: serviceActivityTaskInstance.id)
				
				resultMap['taskId'] = serviceActivityTaskInstance.id
				resultMap['result'] = "success"
				render resultMap as JSON
            }
            else {
                //render(view: "edit", model: [serviceActivityTaskInstance: serviceActivityTaskInstance])
				
				resultMap['result'] = "fail"
				render resultMap as JSON
            }
        }
        else {
            //flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceActivityTask.label', default: 'ServiceActivityTask'), params.id])}"
            //redirect(action: "list")
			
			resultMap['result'] = "fail"
			render resultMap as JSON
        }
    }

    def delete = {
        def serviceActivityTaskInstance = ServiceActivityTask.get(params.id)
        if (serviceActivityTaskInstance) {
            try {
                serviceActivityTaskInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'serviceActivityTask.label', default: 'ServiceActivityTask'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'serviceActivityTask.label', default: 'ServiceActivityTask'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceActivityTask.label', default: 'ServiceActivityTask'), params.id])}"
            redirect(action: "list")
        }
    }
	
	def deleteFromServiceActivity = {
		def serviceActivityTaskInstance = ServiceActivityTask.get(params.id)
		if (serviceActivityTaskInstance) {
			try {
				serviceActivityTaskInstance.delete(flush: true)
				//flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'serviceActivityTask.label', default: 'ServiceActivityTask'), params.id])}"
				//redirect(action: "list")
				render "success"
			}
			catch (org.springframework.dao.DataIntegrityViolationException e) {
				//flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'serviceActivityTask.label', default: 'ServiceActivityTask'), params.id])}"
				//redirect(action: "show", id: params.id)
				render "fail"
			}
		}
		else {
			//flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceActivityTask.label', default: 'ServiceActivityTask'), params.id])}"
			//redirect(action: "list")
			
			render "fail"
		}
	}
}