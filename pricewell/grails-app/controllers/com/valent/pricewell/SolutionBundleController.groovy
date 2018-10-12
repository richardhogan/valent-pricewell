package com.valent.pricewell

import grails.converters.JSON
import java.util.List;

import org.apache.shiro.SecurityUtils
import org.codehaus.groovy.grails.web.json.JSONObject;

class SolutionBundleController {

    static allowedMethods = [save: "POST", update: "POST"]

    def index = {
        redirect(view: "list", params: params)
    }

	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		log.info("${actionUri} with params ${params}")
	}
	
    def list = {
		params.max = Math.min(params.max ? params.int('max') : 10, 100)
		def solutionBundleInstance = new SolutionBundle(); 
		def solutionBundleInstanceList = solutionBundleInstance.findAll("From SolutionBundle sb");

		def source = (params.source == "firstsetup")?"firstsetup":"setup"
		
		render(view: "list", model :[solutionBundleInstanceList: solutionBundleInstanceList, source: source,
			createPermission: SecurityUtils.subject.isPermitted("solutionBundle:create")])
	}
	
	def listsetup = {
		redirect(action: "list", params: params)
	}
	
	public boolean isSolutionBundleAvailable(String name)
	{
		def solutionBundle = SolutionBundle.findAllByName(name)
		if (solutionBundle != null && solutionBundle.size() > 0)
		{
		   return true			
		}
		else {
			return false
		}
	}
	
	def isSolutionBundleDefined =
	{
		if(SolutionBundle.list().size() > 0)
		{
			render "true"
		}
		else
		{
			render "false"
		}
	}

    def create = {
        def solutionBundleInstance = new SolutionBundle()
		solutionBundleInstance.properties = params
		if(params.source == "setup" || params.source == "firstsetup")
		{
			def source = (params.source == "firstsetup")?"firstsetup":"setup"
			render(view: "createsetup", model: [solutionBundleInstance: solutionBundleInstance, source: source])
		}
		else
			return [solutionBundleInstance: solutionBundleInstance]
    }

	def createsetup = {
		redirect(action:"create", params: params)
	}
	
	def manageservice = {
		redirect(action: "manageservicesetup", params: params)
	}
	
	def getName = {
		def solutionBundleInstance = SolutionBundle.get(params.id)
		render solutionBundleInstance.name
	}
	
    def save = {
        def solutionBundleInstance = new SolutionBundle(params)
		solutionBundleInstance.createdDate = new Date()
		if(isSolutionBundleAvailable(params.name))
		{
			render "SolutionBundle_Available"
		}
		else
		{
			if (solutionBundleInstance.save(flush: true))
			{
				render "success"
			}
			else 
			{
				if(params.source == "setup" || params.source == "firstsetup")
				{
					render generateAJAXError(solutionBundleInstance);
				}
				else
				{
					render(view: "createsetup", model: [solutionBundleInstance: solutionBundleInstance])
				}
			}
		}
    }

	def saveservices = {
		def flag

		def serviceList = params.solutionBundleServices 
		def solutionBundleID = new Long(params.solution_bundle_id)
		
		def solutionBundle = new SolutionBundle();
		def solutionBundleServicesAdd = solutionBundle.find("from SolutionBundle where id = :sbid",[sbid: solutionBundleID]);
		
		//Remove existing ones
		solutionBundleServicesAdd.solutionBundleServices.clear();
		
		for(int i = 0; i < serviceList.size(); i++){
			solutionBundleServicesAdd.addToSolutionBundleServices(Service.findById(serviceList[i]));
		}
		
		if(solutionBundleServicesAdd.save(flush: true))
		{
			redirect (action:"list")
		}
		else
		{
			if(params.source == "setup" || params.source == "firstsetup")
			{
				render generateAJAXError(solutionBundleServicesAdd);
			}
			else
			{
				redirect(action: "listsetup", model: [solutionBundleServicesInstance: solutionBundleServicesAdd])
			}
		}
		
	}
	
	def manageservicesetup = {
		def solutionBundleInstance = SolutionBundle.get(params.id)
		
		def serviceInstance = new Service();
		def serviceListInstance = serviceInstance.findAll("FROM Service s");
		serviceListInstance.removeAll(solutionBundleInstance.solutionBundleServices);
		
		render (view:"manageservicesetup", model: [solutionBundleInstance:solutionBundleInstance,serviceListInstance:serviceListInstance])
	}
	
	def manageservicesetup2 = {
		def sbInstance = new SolutionBundle(params)
		sbInstance.createdDate = new Date()
		if(isSolutionBundleAvailable(params.name))
		{
			render "SolutionBundle_Available"
		}
		else
		{
			if (sbInstance.save(flush: true))
			{
				Map resultMap = new HashMap()
				resultMap['result'] = "success"
				resultMap['sbInstance'] = sbInstance.id
				render resultMap as JSON;
			}
			else
			{
				if(params.source == "setup" || params.source == "firstsetup")
				{
					render generateAJAXError(sbInstance);
				}
				else
				{
					render(view: "createsetup", model: [solutionBundleInstance: sbInstance])
				}
			}
		}
	}
	def saveAndManageServices = {
		def solutionBundleInstance = new SolutionBundle(params)
		solutionBundleInstance.createdDate = new Date()
		def solutionBundle = SolutionBundle.get(params.id)

		def serviceInstance = new Service();
		def serviceListInstance = serviceInstance.findAll("FROM Service s");
		
		if(isSolutionBundleAvailable(params.name))
		{
			render "SolutionBundle_Available"
		}
		else
		{
			if (solutionBundleInstance.save(flush: true))
			{
				render(view: "manageservicesetup", model: [solutionBundleInstance:solutionBundle,serviceListInstance:serviceListInstance,solutionBundleInstance:solutionBundleInstance]);
			}
			else
			{
				if(params.source == "setup" || params.source == "firstsetup")
				{
					render generateAJAXError(solutionBundleInstance);
				}
				else
				{
					render(view: "createsetup", model: [solutionBundleInstance: solutionBundleInstance])
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
        def solutionBundleInstance = SolutionBundle.get(params.id)
        if (!solutionBundleInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'solutionBundle.label', default: 'SolutionBundle'), params.id])}"
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
			
			 
			if(params.source == "setup" || params.source == "firstsetup")
			{
				def source = (params.source == "firstsetup")?"firstsetup":"setup"
				
				render(view: "showsetup", model: [solutionBundleInstance: solutionBundleInstance, source: source, relationSolutionBundleList: relationSolutionBundleList,
														message: message, createPermission: SecurityUtils.subject.isPermitted("solutionBundle:create"), 
														updatePermission: SecurityUtils.subject.isPermitted("solutionBundle:create")])
			}
			else
				[solutionBundleInstance: solutionBundleInstance, message: message,
					createPermission: SecurityUtils.subject.isPermitted("solutionBundle:create"), 
					updatePermission: SecurityUtils.subject.isPermitted("solutionBundle:create")]
        }
    }
	
	def showsetup = {
		redirect(action:"show", params: params)
    }
	
    def edit = {
		def sbInstance = SolutionBundle.get(params.id)
		
		render(view: "editsetup", model: [solutionBundleInstance:sbInstance]);
	}
	
	def editsetup = {
		redirect(action:"edit",params: params)
	}
	
    def update = {
		def solutionBundleInstance = SolutionBundle.get(params.id)
        if (solutionBundleInstance) {
            if (params.version) {
                def version = params.version.toLong()
				def name = params.name.toString()
                if (solutionBundleInstance.version > version) {
                    solutionBundleInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'SolutionBundle.label', default: 'SolutionBundle')] as Object[], "Another user has updated this SolutionBundle while you were editing")
                    render(view: "editsetup", model: [solutionBundleInstance: solutionBundleInstance])
                    return
                }
            }
			def oldName = solutionBundleInstance?.name
			boolean solutionBundleAvail = false
			if(params.name.toLowerCase() != oldName.toLowerCase())
			{
				if(isSolutionBundleAvailable(params.name))
				{
					solutionBundleAvail = true
				}
			}
			
			if(solutionBundleAvail)
			{
				render "SolutionBundle_Available"
			}
			else
			{
	            solutionBundleInstance.properties = params
	            if (!solutionBundleInstance.hasErrors() && solutionBundleInstance.save(flush: true)) 
				{
					render "success"
	            }
	            else 
				{
					if(params.source == "setup" || params.source == "firstsetup")
					{
						render generateAJAXError(solutionBundleInstance);
					}
					else
					{
	                	render(view: "editsetup", model: [solutionBundleInstance: solutionBundleInstance])
					}
	            }
			}
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'SolutionBundle.label', default: 'SolutionBundle'), params.id])}"
            redirect(action: "listsetup")
        }
    }
   
	def deletesetup = {
		def solutionBundleInstance = SolutionBundle.get(params.id)
		if (solutionBundleInstance) {
			solutionBundleInstance.delete(flush: true)
		}
		
		render "success";
	}
	
}
