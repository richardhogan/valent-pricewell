package com.valent.pricewell
import grails.converters.JSON
import java.util.List;

import org.apache.shiro.SecurityUtils

class SowSupportParameterController {

    static allowedMethods = [save: "POST", update: "POST"]


    def index = {
        redirect(action: "listsetup", params: params)
    }

	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		log.info("${actionUri} with params ${params}")
	}
	
    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
		if(params.source == "setup" || params.source == "firstsetup")
		{
			def source = (params.source == "firstsetup")?"firstsetup":"setup"
			render(template: "listsetup", model :[sowSupportParameterInstanceList: SowSupportParameter.list(), source: source, sowSupportParameterInstanceTotal: SowSupportParameter.count(),
													createPermission: SecurityUtils.subject.isPermitted("sowSupportParameter:create")])
		}
		else
        	[sowSupportParameterInstanceList: SowSupportParameter.list(), sowSupportParameterInstanceTotal: SowSupportParameter.count(),
				createPermission: SecurityUtils.subject.isPermitted("sowSupportParameter:create")]
    }
	
	def getParameterText = {
		Map resultMap = new HashMap()
		resultMap.put("project_parameter_text", "")
		def sowSupportParameterInstance = SowSupportParameter.get(params.id)
		if(sowSupportParameterInstance)
		{
			resultMap.put("project_parameter_text", sowSupportParameterInstance.project_parameter_text)
		}
		render resultMap as JSON
	}
	
	def listsetup = {
		redirect(action: "list", params: params)
	}
	
	public boolean isSowSupportParameterAvailable(def name)
	{
		def sowSupportParameter = SowSupportParameter.findAllByName(name)
		if (sowSupportParameter != null && sowSupportParameter.size() > 0)
		{
		   return true			
		}
		else {
			return false
		}
	  }
	def isSowSupportParameterDefined =
	{
		if(SowSupportParameter.list().size() > 0)
		{
			render "true"
		}
		else
		{
			render "false"
		}
	}

    def create = {
        def sowSupportParameterInstance = new SowSupportParameter()
        sowSupportParameterInstance.properties = params
        if(params.source == "setup" || params.source == "firstsetup")
		{
			def source = (params.source == "firstsetup")?"firstsetup":"setup"
			
			render(template: "createsetup", model: [sowSupportParameterInstance: sowSupportParameterInstance, source: source])
		}
		else
			return [sowSupportParameterInstance: sowSupportParameterInstance]
    }

	def createsetup = {
		redirect(action:"create", params: params)
	}
	
	def getName = {
		def sowSupportParameterInstance = SowSupportParameter.get(params.id)
		render sowSupportParameterInstance.name
	}
	
    def save = {
        def sowSupportParameterInstance = new SowSupportParameter(params)
		def geoInstance = Geo.get(params.territoryId)
		sowSupportParameterInstance.geo = geoInstance
		if(isSowSupportParameterAvailable(params.name))
		{
			render "SowSupportParameter_Available"
		}
		else{
			if (sowSupportParameterInstance.save(flush: true))
			{
				render "success"
			}
			else {
				if(params.source == "setup" || params.source == "firstsetup"){
					render generateAJAXError(sowSupportParameterInstance);
				}else{
					render(view: "createsetup", model: [sowSupportParameterInstance: sowSupportParameterInstance])
				}
			}
		}
        
    }
	private String generateAJAXError(Object obj){
		StringBuilder sb = new StringBuilder();
		sb.append("<ul>");
		if(obj.hasErrors()){
			obj.errors.each {
				sb.append("<li>${it}</li>")
			}
		}
		sb.append("</ul>");
	}
    def show = {
        def sowSupportParameterInstance = SowSupportParameter.get(params.id)
        if (!sowSupportParameterInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'sowSupportParameter.label', default: 'SowSupportParameter'), params.id])}"
            redirect(action: "listsetup")
        }
        else {
			def message = ""
			if(params.notificationId)
			{
				def note = Notification.get(params.notificationId)
				note.active = false
				note.save(flush:true)
				message = note.message
			}
			def relationSowSupportParameterList =  sowSupportParameterInstance?.listRateCostsPerGeos(null)
			 
			if(params.source == "setup" || params.source == "firstsetup")
			{
				def source = (params.source == "firstsetup")?"firstsetup":"setup"
				
				render(template: "showsetup", model: [sowSupportParameterInstance: sowSupportParameterInstance, source: source, relationSowSupportParameterList: relationSowSupportParameterList,
														message: message, createPermission: SecurityUtils.subject.isPermitted("sowSupportParameter:create"), 
														updatePermission: SecurityUtils.subject.isPermitted("sowSupportParameter:create")])
			}
			else
				[sowSupportParameterInstance: sowSupportParameterInstance, relationSowSupportParameterList: relationSowSupportParameterList, message: message,
					createPermission: SecurityUtils.subject.isPermitted("sowSupportParameter:create"), 
					updatePermission: SecurityUtils.subject.isPermitted("sowSupportParameter:create")]
        }
    }
	
	def showsetup = {
		redirect(action:"show", params: params)
    }

    def edit = {
        def sowSupportParameterInstance = SowSupportParameter.get(params.id)
		
		
        if (!sowSupportParameterInstance) {
			
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'sowSupportParameter.label', default: 'SowSupportParameter'), params.id])}"
            redirect(action: "listsetup")
        }
        else {
			
			if(params.source == "setup" || params.source == "firstsetup")
			{
				def source = (params.source == "firstsetup")?"firstsetup":"setup"
				render(template: "editsetup", model: [sowSupportParameterInstance: sowSupportParameterInstance, source: source]);
			}
			else{
            	return [sowSupportParameterInstance: sowSupportParameterInstance]
			}
		}
	}
	
	def editsetup = {
		redirect(action:"edit", params: params)
	}
	
	def getTerritory = {
		def sowSupportParameterInstance = Geo.get(params.territoryId)
		if (!sowSupportParameterInstance) {
			//flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'setting.label', default: 'Setting'), params.id])}"
			//redirect(action: "list")
			render ""
		}
		else
		{			
			def territoryList = new ArrayList()
			
			territoryList = salesCatalogService.findUserTerritories()
			render(template: "listsetup", model: [sowSupportParameterInstance: sowSupportParameterInstance,territoryId:territoryId])
		}
		
	}
	
    def update = {		
		def sowSupportParameterInstance = SowSupportParameter.get(params.id)
        if (sowSupportParameterInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (sowSupportParameterInstance.version > version) {
                    sowSupportParameterInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'sowSupportParameter.label', default: 'SowSupportParameter')] as Object[], "Another user has updated this SowSupportParameter while you were editing")
                    render(view: "editsetup", model: [sowSupportParameterInstance: sowSupportParameterInstance])
                    return
                }
            }			
			def oldName = sowSupportParameterInstance?.name
			boolean sowSupportParameterAvail = false
			if(params.name.toLowerCase() != oldName.toLowerCase())
			{
				if(isSowSupportParameterAvailable(params.name))
				{				
					sowSupportParameterAvail = true
				}
			}
			
			if(sowSupportParameterAvail)
			{
				render "SowSupportParameter_Available"
			}
			else
			{
	            sowSupportParameterInstance.properties = params
	            if (!sowSupportParameterInstance.hasErrors() && sowSupportParameterInstance.save(flush: true)) 
				{
					render "success"
	            }
	            else {
					if(params.source == "setup" || params.source == "firstsetup"){
						render generateAJAXError(sowSupportParameterInstance);
					}else{
	                	render(view: "editsetup", model: [sowSupportParameterInstance: sowSupportParameterInstance])
					}
	            }
			}
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'sowSupportParameter.label', default: 'SowSupportParameter'), params.id])}"
            redirect(action: "listsetup")
        }
    }
   
	def deletesetup = {
		def sowSupportParameterInstance = SowSupportParameter.get(params.id)
		def name =  sowSupportParameterInstance.name
		
		
		if (sowSupportParameterInstance) 
		{
			List sowSupportParameterList = new ArrayList()
			if(sowSupportParameterList.size() == 0)
			{
				try {
					sowSupportParameterInstance.delete(flush: true)
					render "success"
				}
				catch (org.springframework.dao.DataIntegrityViolationException e) {
					flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'sowSupportParameter.label', default: 'SowSupportParameter'), name])}"
					redirect(action: "showsetup", id: params.id)
				}
			}
			else {
				render "can_not_delete_sow_introduction"
			}
			
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'sowSupportParameter.label', default: 'SowSupportParameter'), params.id])}"
            redirect(action: "listsetup")
		}
	}	
	
	def getSowSupportParameterName = {
		def sowSupportParameterInstance = SowSupportParameter.get(params.id)
		def sowSupportParameterName = ""
		if (sowSupportParameterInstance)
		{
			sowSupportParameterName = sowSupportParameterInstance.name
		}
		render sowSupportParameterName
		
	}
    def delete = {
        def sowSupportParameterInstance = SowSupportParameter.get(params.id)
		def name =  sowSupportParameterInstance.name
        if (sowSupportParameterInstance) {
            try {
                sowSupportParameterInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'sowSupportParameter.label', default: 'SowSupportParameter'), name])}"
                redirect(action: "listsetup")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'sowSupportParameter.label', default: 'SowSupportParameter'), name])}"
                redirect(action: "showsetup", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'sowSupportParameter.label', default: 'SowSupportParameter'), params.id])}"
            redirect(action: "listsetup")
        }
    }
	
}