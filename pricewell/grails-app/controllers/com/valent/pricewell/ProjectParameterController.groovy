package com.valent.pricewell

import grails.converters.JSON
import org.apache.shiro.SecurityUtils

class ProjectParameterController {

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
        [projectParameterInstanceList: ProjectParameter.list(params), projectParameterInstanceTotal: ProjectParameter.count()]
    }
	
	def listProjectParameters = {
		if(params.quotationId)
		{
			Quotation quotationInstance = Quotation.get(params.quotationId)
			
			if(quotationInstance)
			{
				if(quotationInstance?.projectParameters?.size() > 0)
					render(template: "listProjectParameters", model: [quotationInstance: quotationInstance, isReadOnly: false]);
				else 
					redirect(action: "createFromQuotationSow", params: ["quotationId": quotationInstance?.id])
			} 
		}
	}

	def getProjectParameterText = {
		Map resultMap = new HashMap()
		resultMap.put("project_parameter_text", "")
		def projectParameterInstance = ProjectParameter.get(params.id)
		if(projectParameterInstance)
		{
			resultMap.put("project_parameter_text", projectParameterInstance.value)
		}
		render resultMap as JSON
	}
	
    def create = {
        def projectParameterInstance = new ProjectParameter()
        projectParameterInstance.properties = params
        return [projectParameterInstance: projectParameterInstance]
    }

	def createFromQuotationSow = {
		
		if(params.quotationId)
		{
			Quotation quotationInstance = Quotation.get(params.quotationId)
			
			if(quotationInstance)
			{
				def projectParameterInstance = new ProjectParameter()
				projectParameterInstance.properties = params
				
				render(template: "createProjectParameter", model: [quotationId: quotationInstance?.id, projectParameterInstance: projectParameterInstance]);
			}
		}
		
		
	}
	
    def save = {
        def projectParameterInstance = new ProjectParameter(params)
        if (projectParameterInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'projectParameter.label', default: 'ProjectParameter'), projectParameterInstance.id])}"
            redirect(action: "show", id: projectParameterInstance.id)
        }
        else {
            render(view: "create", model: [projectParameterInstance: projectParameterInstance])
        }
    }
	
	def saveFromQuotationSow = {
		if(params.quotationId)
		{
			Quotation quotationInstance = Quotation.get(params.quotationId)
			
			if(quotationInstance)
			{
				def projectParameterInstance = new ProjectParameter(params)
				projectParameterInstance.sequenceOrder = quotationInstance?.projectParameters?.size() + 1
				projectParameterInstance.quotation = quotationInstance
				if (projectParameterInstance.save(flush: true)) 
				{
					//flash.message = "${message(code: 'default.created.message', args: [message(code: 'projectParameter.label', default: 'ProjectParameter'), projectParameterInstance.id])}"
					redirect(action: "listProjectParameters", params: ["quotationId": quotationInstance?.id])
				}
				else {
					redirect(action: "listProjectParameters", params: ["quotationId": quotationInstance?.id])
				}
			}
		}
	}

    def show = {
        def projectParameterInstance = ProjectParameter.get(params.id)
        if (!projectParameterInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'projectParameter.label', default: 'ProjectParameter'), params.id])}"
            redirect(action: "list")
        }
        else {
            [projectParameterInstance: projectParameterInstance]
        }
    }

    def edit = {
        def projectParameterInstance = ProjectParameter.get(params.id)
        if (!projectParameterInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'projectParameter.label', default: 'ProjectParameter'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [projectParameterInstance: projectParameterInstance]
        }
    }
	
	def editFromQuotationSow = {
		def projectParameterInstance = ProjectParameter.get(params.id)
		if (!projectParameterInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'projectParameter.label', default: 'ProjectParameter'), params.id])}"
			redirect(action: "listProjectParameters", params: ["quotationId": params.quotationId])
		}
		else {
			render(template: "editProjectParameter", model: [quotationId: projectParameterInstance?.quotation?.id, projectParameterInstance: projectParameterInstance]);
		}
	}

    def update = {
        def projectParameterInstance = ProjectParameter.get(params.id)
        if (projectParameterInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (projectParameterInstance.version > version) {
                    
                    projectParameterInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'projectParameter.label', default: 'ProjectParameter')] as Object[], "Another user has updated this ProjectParameter while you were editing")
                    render(view: "edit", model: [projectParameterInstance: projectParameterInstance])
                    return
                }
            }
            projectParameterInstance.properties = params
            if (!projectParameterInstance.hasErrors() && projectParameterInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'projectParameter.label', default: 'ProjectParameter'), projectParameterInstance.id])}"
                redirect(action: "show", id: projectParameterInstance.id)
            }
            else {
                render(view: "edit", model: [projectParameterInstance: projectParameterInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'projectParameter.label', default: 'ProjectParameter'), params.id])}"
            redirect(action: "list")
        }
    }

	def updateFromQuotationSow = {
		def projectParameterInstance = ProjectParameter.get(params.id)
		if (projectParameterInstance) {
			if (params.version) {
				def version = params.version.toLong()
				if (projectParameterInstance.version > version) {
					
					projectParameterInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'projectParameter.label', default: 'ProjectParameter')] as Object[], "Another user has updated this ProjectParameter while you were editing")
					render(view: "edit", model: [projectParameterInstance: projectParameterInstance])
					return
				}
			}
			projectParameterInstance.properties = params
			if (!projectParameterInstance.hasErrors() && projectParameterInstance.save(flush: true)) {
				flash.message = "${message(code: 'default.updated.message', args: [message(code: 'projectParameter.label', default: 'ProjectParameter'), projectParameterInstance.id])}"
				redirect(action: "listProjectParameters", params: ["quotationId": projectParameterInstance.quotation.id])
			}
			else {
				redirect(action: "listProjectParameters", params: ["quotationId": params.quotationId])
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'projectParameter.label', default: 'ProjectParameter'), params.id])}"
			redirect(action: "listProjectParameters", params: ["quotationId": params.quotationId])
		}
	}
	
    def delete = {
        def projectParameterInstance = ProjectParameter.get(params.id)
        if (projectParameterInstance) {
            try {
                projectParameterInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'projectParameter.label', default: 'ProjectParameter'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'projectParameter.label', default: 'ProjectParameter'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'projectParameter.label', default: 'ProjectParameter'), params.id])}"
            redirect(action: "list")
        }
    }
	
	def deleteFromQuotationSow = {
		def projectParameterInstance = ProjectParameter.get(params.id)
		def quotationInstance = Quotation.get(projectParameterInstance?.quotation?.id)
		
		if (projectParameterInstance) {
			try {
				projectParameterInstance.delete(flush: true)
				redirect(action: "listProjectParameters", params: ["quotationId": quotationInstance?.id])
			}
			catch (org.springframework.dao.DataIntegrityViolationException e) {
				//flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'projectParameter.label', default: 'ProjectParameter'), params.id])}"
				redirect(action: "listProjectParameters", params: ["quotationId": quotationInstance?.id])
			}
		}
		else {
			//flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'projectParameter.label', default: 'ProjectParameter'), params.id])}"
			//redirect(action: "list")
			redirect(action: "listProjectParameters", params: ["quotationId": quotationInstance?.id])
		}
	}
}
