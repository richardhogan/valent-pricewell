package com.valent.pricewell
import grails.converters.JSON
import java.util.List;

import org.apache.shiro.SecurityUtils

class SowIntroductionController {

    static allowedMethods = [save: "POST", update: "POST"]


    def index = {
        redirect(action: "listsetup", params: params)
    }

	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		log.info("${actionUri} with params ${params}")
	}
	
    def list = {
		System.out.println("In list")
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
		if(params.source == "setup" || params.source == "firstsetup")
		{
			def source = (params.source == "firstsetup")?"firstsetup":"setup"
			render(template: "listsetup", model :[sowIntroductionInstanceList: SowIntroduction.list(), source: source, sowIntroductionInstanceTotal: SowIntroduction.count(),
													createPermission: SecurityUtils.subject.isPermitted("sowIntroduction:create")])
		}
		else
        	[sowIntroductionInstanceList: SowIntroduction.list(), sowIntroductionInstanceTotal: SowIntroduction.count(),
				createPermission: SecurityUtils.subject.isPermitted("sowIntroduction:create")]
    }
	
	def listsetup = {
		System.out.println("In listsetup")
		redirect(action: "list", params: params)
	}
	
	public boolean isSowIntroductionAvailable(def name)
	{
		System.out.println(" In isSowIntroductionAvailable Method");
		def sowIntroduction = SowIntroduction.findAllByName(name)
		if (sowIntroduction != null && sowIntroduction.size() > 0)
		{
			System.out.println("isSowIntroductionAvailable If");
		   return true			
		}
		else {
			System.out.println("isSowIntroductionAvailable else");
			return false
		}
	  }
	def isSowIntroductionDefined =
	{
		if(SowIntroduction.list().size() > 0)
		{
			render "true"
		}
		else
		{
			render "false"
		}
	}

    def create = {
        def sowIntroductionInstance = new SowIntroduction()
        sowIntroductionInstance.properties = params
        if(params.source == "setup" || params.source == "firstsetup")
		{
			def source = (params.source == "firstsetup")?"firstsetup":"setup"
			render(template: "createsetup", model: [sowIntroductionInstance: sowIntroductionInstance, source: source])
		}
		else
			return [sowIntroductionInstance: sowIntroductionInstance]
    }

	def createsetup = {
		redirect(action:"create", params: params)
	}
	
	def getName = {
		def sowIntroductionInstance = SowIntroduction.get(params.id)
		render sowIntroductionInstance.name
	}
	
	def getSowText = {
		Map resultMap = new HashMap()
		resultMap.put("sow_text", "")
		def sowIntroductionInstance = SowIntroduction.get(params.id)
		if(sowIntroductionInstance)
		{
			resultMap.put("sow_text", sowIntroductionInstance.sow_text)
		}
		render resultMap as JSON
	}
	
    def save = {
        def sowIntroductionInstance = new SowIntroduction(params)
		def geoInstance = Geo.get(params.territoryId)
		sowIntroductionInstance.geo = geoInstance
		if(isSowIntroductionAvailable(params.name))
		{
			render "SowIntroduction_Available"
		}
		else{
			if (sowIntroductionInstance.save(flush: true))
			{
				render "success"
			}
			else {
				if(params.source == "setup" || params.source == "firstsetup"){
					System.out.println(" AJAX Error ")
					render generateAJAXError(sowIntroductionInstance);
				}else{
				System.out.println(" create setup found ")
				render(view: "createsetup", model: [sowIntroductionInstance: sowIntroductionInstance])
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
        def sowIntroductionInstance = SowIntroduction.get(params.id)
        if (!sowIntroductionInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'sowIntroduction.label', default: 'SowIntroduction'), params.id])}"
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
			def relationSowIntroductionList =  sowIntroductionInstance?.listRateCostsPerGeos(null)
			 
			if(params.source == "setup" || params.source == "firstsetup")
			{
				def source = (params.source == "firstsetup")?"firstsetup":"setup"
				render(template: "showsetup", model: [sowIntroductionInstance: sowIntroductionInstance, source: source, relationSowIntroductionList: relationSowIntroductionList,
														message: message, createPermission: SecurityUtils.subject.isPermitted("sowIntroduction:create"), 
														updatePermission: SecurityUtils.subject.isPermitted("sowIntroduction:create")])
			}
			else
				[sowIntroductionInstance: sowIntroductionInstance, relationSowIntroductionList: relationSowIntroductionList, message: message,
					createPermission: SecurityUtils.subject.isPermitted("sowIntroduction:create"), 
					updatePermission: SecurityUtils.subject.isPermitted("sowIntroduction:create")]
        }
    }
	
	def showsetup = {
		redirect(action:"show", params: params)
    }

	
	
	
    def edit = {
		System.out.println("In edit");
        def sowIntroductionInstance = SowIntroduction.get(params.id)
		
		
        if (!sowIntroductionInstance) {
			
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'sowIntroduction.label', default: 'SowIntroduction'), params.id])}"
            redirect(action: "listsetup")
        }
        else {
			
			if(params.source == "setup" || params.source == "firstsetup")
			{
				def source = (params.source == "firstsetup")?"firstsetup":"setup"
				render(template: "editsetup", model: [sowIntroductionInstance: sowIntroductionInstance, source: source]);
			}
			else{
            	return [sowIntroductionInstance: sowIntroductionInstance]
			}
		}
	}
	
	def editsetup = {
		redirect(action:"edit", params: params)
	}
	
	def getTerritory = {
		def sowIntroductionInstance = Geo.get(params.territoryId)
		if (!sowIntroductionInstance) {
			//flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'setting.label', default: 'Setting'), params.id])}"
			//redirect(action: "list")
			render ""
		}
		else
		{			
			def territoryList = new ArrayList()
			
			territoryList = salesCatalogService.findUserTerritories()
			render(template: "listsetup", model: [sowIntroductionInstance: sowIntroductionInstance,territoryId:territoryId])
		}
		
	}
	
    def update = {		
		System.out.println("In update");
		def sowIntroductionInstance = SowIntroduction.get(params.id)
        if (sowIntroductionInstance) {
			System.out.println("In update if");
            if (params.version) {
				System.out.println("In update if version");
                def version = params.version.toLong()
                if (sowIntroductionInstance.version > version) {
					System.out.println("In update if version > version");
                    sowIntroductionInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'sowIntroduction.label', default: 'SowIntroduction')] as Object[], "Another user has updated this SowIntroduction while you were editing")
                    render(view: "editsetup", model: [sowIntroductionInstance: sowIntroductionInstance])
                    return
                }
            }			
			def oldName = sowIntroductionInstance?.name
			boolean sowIntroductionAvail = false
			if(params.name.toLowerCase() != oldName.toLowerCase())
			{
				if(isSowIntroductionAvailable(params.name))
				{				
					sowIntroductionAvail = true
				}
			}
			
			if(sowIntroductionAvail)
			{
				System.out.println("In update sowIntroductionAvail");
				render "SowIntroduction_Available"
			}
			else
			{
				System.out.println("In update if-else");
	            sowIntroductionInstance.properties = params
	            if (!sowIntroductionInstance.hasErrors() && sowIntroductionInstance.save(flush: true)) 
				{
					render "success"
	            }
	            else {
					System.out.println("In update if-else-else");
					if(params.source == "setup" || params.source == "firstsetup"){
						render generateAJAXError(sowIntroductionInstance);
					}else{
					System.out.println("In update if-else-if _edit_");
	                	render(view: "editsetup", model: [sowIntroductionInstance: sowIntroductionInstance])
					}
	            }
			}
        }
        else {
			System.out.println("In update else");
			System.out.println("In update if-else-if _list_");
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'sowIntroduction.label', default: 'SowIntroduction'), params.id])}"
            redirect(action: "listsetup")
        }
    }
   
	def deletesetup = {
		def sowIntroductionInstance = SowIntroduction.get(params.id)
		def name =  sowIntroductionInstance.name
		
		
		if (sowIntroductionInstance) 
		{
			List sowIntroductionList = new ArrayList()
			if(sowIntroductionList.size() == 0)
			{
				try {
					sowIntroductionInstance.delete(flush: true)
					render "success"
				}
				catch (org.springframework.dao.DataIntegrityViolationException e) {
					flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'sowIntroduction.label', default: 'SowIntroduction'), name])}"
					redirect(action: "showsetup", id: params.id)
				}
			}
			else {
				render "can_not_delete_sow_introduction"
			}
			
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'sowIntroduction.label', default: 'SowIntroduction'), params.id])}"
            redirect(action: "listsetup")
		}
	}	
	
	def getSowIntroductionName = {
		def sowIntroductionInstance = SowIntroduction.get(params.id)
		def sowIntroductionName = ""
		if (sowIntroductionInstance)
		{
			sowIntroductionName = sowIntroductionInstance.name
		}
		println "sowIntroductionName"
		render sowIntroductionName
		
	}
    def delete = {
        def sowIntroductionInstance = SowIntroduction.get(params.id)
		def name =  sowIntroductionInstance.name
        if (sowIntroductionInstance) {
            try {
                sowIntroductionInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'sowIntroduction.label', default: 'SowIntroduction'), name])}"
                redirect(action: "listsetup")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'sowIntroduction.label', default: 'SowIntroduction'), name])}"
                redirect(action: "showsetup", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'sowIntroduction.label', default: 'SowIntroduction'), params.id])}"
            redirect(action: "listsetup")
        }
    }
	
}
