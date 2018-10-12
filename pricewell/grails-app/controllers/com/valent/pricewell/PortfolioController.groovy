package com.valent.pricewell
import com.valent.pricewell.Service
import grails.converters.JSON
import org.apache.shiro.SecurityUtils

class PortfolioController {

	def serviceCatalogService
	def sendMailService

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}
	
    def index = {
		redirect(action: "list", params: params)
    }
	
	def unassignedPortfolio = {
		List portfolioList = new ArrayList();
		def portfolioManagerList = serviceCatalogService.findPortfolioManagers()
		def usenobody = User.findByUsername("nobody")
		for(Portfolio pf : Portfolio.list())
		{
			//if(pf?.portfolioManager == null || pf?.portfolioManager == "")
			if(pf?.portfolioManager?.id == usenobody?.id)
				portfolioList.add(pf)
		}
		
		if(portfolioList.size() > 0)
			render(template: "unassignedPortfolioList", model :[portfolioList: portfolioList, portfolioManagerList: portfolioManagerList])
		else render "noMorePortfolioLeftToAssign"
		
	}
	
	def savePortfolioManager = {
		Portfolio portfolioInstance = Portfolio.get(params.id.toLong())
		User portfolioManager = User.get(params.portfolioManagerId.toLong())
		portfolioInstance.portfolioManager = portfolioManager
		portfolioInstance.dateModified = new Date()
		portfolioInstance.save()
		new NotificationGenerator(g).sendAssignedToPortfolioManagerNotification(portfolioInstance);
		render "success"	
	}
	
    def list = {
		//params.max = Math.min(params.max ? params.int('max') : 10, 100)
		def user = User.get(new Long(SecurityUtils.subject.principal))
		List serviceProfileInstanceList = serviceCatalogService.findUserPortfolios(user, params)
	    
		if(params.source == "setup" || params.source == "firstsetup")
		{
			def source = (params.source == "firstsetup")?"firstsetup":"setup"
			render(template: "listsetup", model :[portfolioInstanceList: serviceProfileInstanceList, portfolioInstanceTotal: serviceProfileInstanceList.size(), source: source, allowCreate: isPermitted("create"), allowEdit: isPermitted("edit"), allowDelete: isPermitted("delete"), allowShow: isPermitted("show")])
		}
		else
			[portfolioInstanceList: serviceProfileInstanceList, portfolioInstanceTotal: serviceProfileInstanceList.size() , createPermit: isPermitted("create")]
    }
	
	def listsetup = {
		redirect(action: "list", params: params)
		
	}

	def isPortfolioDefined =
	{
		if(Portfolio.list().size() > 0)
		{
			render "true"
		}
		else
		{
			render "false"
		}
	}
	
    def create = {
        def portfolioInstance = new Portfolio()
        portfolioInstance.properties = params
	
		def portfolioManagerList = serviceCatalogService.findPortfolioManagers()
        if(params.source == "setup" || params.source == "firstsetup")
		{
			def source = (params.source == "firstsetup")?"firstsetup":"setup"
			render(template: "createsetup", model: [portfolioInstance: portfolioInstance, portfolioManagerList: portfolioManagerList, source: source])
		}
		else if(params.source == "importService")
		{
			render(template: "createsetup", model: [portfolioInstance: portfolioInstance, portfolioManagerList: portfolioManagerList, source: "importService"])
		}
		else
			return [portfolioInstance: portfolioInstance, portfolioManagerList: portfolioManagerList]
    }
	
	def createsetup = {
		redirect(action:"create", params: params)
	}

	public boolean isPortfolioAvailable(def portfolioName)
	{
		
			def portfolios = Portfolio.findAllByPortfolioName(portfolioName)
			if (portfolios != null && portfolios.size() > 0)
			{
			   return true
			  //response.status = 500
			}
			else {
				return false
			}
		
	  }
    def save = {
        def portfolioInstance = new Portfolio(params)
		portfolioInstance.stagingStatus = "Published"
		portfolioInstance.dateModified = new Date()
		def map = [:], resultMap = [:]
		if(isPortfolioAvailable(params.portfolioName)){
			render "Portfolio_Available"
			
		}
		else
		{
			if (portfolioInstance.save(flush: true))
			{
				map = new NotificationGenerator(g).sendAssignedToPortfolioManagerNotification(portfolioInstance);
				sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/portfolio/show/"+portfolioInstance.id)
				
				if(params.source == "setup" || params.source == "firstsetup"){
					render "success"
				}
				else if(params.source == "importService"){
					resultMap["result"] = "success"
					resultMap["id"] = portfolioInstance.id
					resultMap["name"] = portfolioInstance.portfolioName
					render resultMap as JSON
				}
				else{
					flash.message = "${message(code: 'default.created.message', args: [message(code: 'portfolio.label', default: 'Portfolio'), portfolioInstance.portfolioName])}"
					//redirect(action: "list", id: portfolioInstance.id)
					render "success"
				}
			}
			else {
				if(params.source == "setup" || params.source == "firstsetup"){
					render "Failed to create Portfolio."
				}
				else if(params.source == "importService"){
					resultMap["result"] = "fail"
					render resultMap as JSON
				}
				else{
					render(view: "create", model: [portfolioInstance: portfolioInstance])
				}
			}
		}
        
    }

	def getName = {
		def portfolioInstance = Portfolio.get(params.id)
		render portfolioInstance.portfolioName
	}
    def show = {
        def portfolioInstance = Portfolio.get(params.id)
        if (!portfolioInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'portfolio.label', default: 'Portfolio'), params.id])}"
            redirect(action: "list")
        }
        else {
			if(params.notificationId)
			{
				def note = Notification.get(params.notificationId)
				note.active = false
				note.save(flush:true)
			}
			if(params.source == "setup" || params.source == "firstsetup")
			{
				def source = (params.source == "firstsetup")?"firstsetup":"setup"
				render(template: "showsetup", model: [portfolioInstance: portfolioInstance, createPermission: SecurityUtils.subject.isPermitted("portfolio:create"), 
									updatePermission: SecurityUtils.subject.isPermitted("portfolio:update"), source: source])
			}
			else
            	[portfolioInstance: portfolioInstance, updatePermit: isPermitted("update"), createPermit: isPermitted("create")]
        }
    }

	def showsetup = {
		redirect(action: "show", params: params)
	}
	
    def edit = {
		if(!isPermitted("update"))
		{
			return  response.sendError(javax.servlet.http.HttpServletResponse.SC_FORBIDDEN)
		}
		
        def portfolioInstance = Portfolio.get(params.id)
        if (!portfolioInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'portfolio.label', default: 'Portfolio'), params.id])}"
            redirect(action: "list")
        }
        else {
			
			def portfolioManagerList = serviceCatalogService.findPortfolioManagers()
			def designerList = serviceCatalogService.findServiceDesigners()
            if(params.source == "setup" || params.source == "firstsetup")
			{
				def source = (params.source == "firstsetup")?"firstsetup":"setup"
				render(template: "editsetup", model: [portfolioInstance: portfolioInstance, portfolioManagerList: portfolioManagerList, source: source, designerList: designerList, createPermit: isPermitted("create")]);
			}
			else
				return [portfolioInstance: portfolioInstance, portfolioManagerList: portfolioManagerList, designerList: designerList, createPermit: isPermitted("create")]
        }
    }

	def editsetup = {
		redirect(action: "edit", params: params)
	}
	
    def update = {
		if(!isPermitted("update"))
		{
			return  response.sendError(javax.servlet.http.HttpServletResponse.SC_FORBIDDEN)
		}
		def previousPM, pm
		def portfolioInstance = Portfolio.get(params.id)
		def oldName = portfolioInstance?.portfolioName
		boolean portfolioAvail = false
		if(params.portfolioName.toLowerCase() != oldName.toLowerCase())
		{
			if(isPortfolioAvailable(params.portfolioName))
			{
				//render "Portfolio_Available"
				portfolioAvail = true
			}
		}
		
		if(portfolioAvail)
		{
			render "Portfolio_Available"
			
		}
		else
		{
	        if (portfolioInstance) {
	            if (params.version) {
	                def version = params.version.toLong()
	                if (portfolioInstance.version > version) {
	                    
	                    portfolioInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'portfolio.label', default: 'Portfolio')] as Object[], "Another user has updated this Portfolio while you were editing")
	                    render(view: "edit", model: [portfolioInstance: portfolioInstance])
	                    return
	                }
	            }
				previousPM = portfolioInstance.portfolioManager
				portfolioInstance.properties = params
				pm = portfolioInstance.portfolioManager
	            if (!portfolioInstance.hasErrors() && portfolioInstance.save(flush: true)) {
					if(previousPM != pm)
					{
						//println "Hi"
						new NotificationGenerator(g).sendAssignedToPortfolioManagerNotification(portfolioInstance);
					}
					if(params.source == "setup" || params.source == "firstsetup"){
						render "success"
					} else{
		                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'portfolio.label', default: 'Portfolio'), portfolioInstance.portfolioName])}"
		                //redirect(action: "show", id: portfolioInstance.id)
						render "success"
					}
	            }
	            else {
	                render(view: "edit", model: [portfolioInstance: portfolioInstance])
	            }
	        }
	        else {
	            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'portfolio.label', default: 'Portfolio'), params.id])}"
	            redirect(action: "list")
	        }
		}
    }

	def deletesetup = {
		def portfolioInstance = Portfolio.get(params.id)
		def name = portfolioInstance.portfolioName
		if(portfolioInstance.services.size()==0)
		{
			if (portfolioInstance) 
			{
				try {
					portfolioInstance.delete(flush: true)
					render "success"
	            
				}
				catch (org.springframework.dao.DataIntegrityViolationException e) {
					 flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'portfolio.label', default: 'Portfolio'), name])}"
	                redirect(action: "show", id: params.id)
				}
			}
		}
		else {
			//flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'portfolio.label', default: 'Portfolio'), name])}"
	        //redirect(action: "list")
			render "${message(code: 'portfolio.delete.message.failure', args: [name])}"
		}
	}
	
    def delete = {
        def portfolioInstance = Portfolio.get(params.id)
		def name = portfolioInstance.portfolioName
        if(portfolioInstance.services.size()==0)
		{
			if (portfolioInstance) 
			{
				try {
					
	                portfolioInstance.delete(flush: true)
	                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'portfolio.label', default: 'Portfolio'), name])}"
	                redirect(action: "list")
	            }
	            catch (org.springframework.dao.DataIntegrityViolationException e) {
	                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'portfolio.label', default: 'Portfolio'), name])}"
	                redirect(action: "show", id: params.id)
	            }
	        }
	        else {
	            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'portfolio.label', default: 'Portfolio'), name])}"
	            redirect(action: "list")
	        }
		}
		else
		{
			flash.message = "${message(code: 'portfolio.delete.message.failure', args: [name])}"
			redirect(action: "list")
		}
    }
	
	boolean isPermitted(String action)
	{	
		boolean permit = false
		if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR"))
		{
			permit = true
		}
		else
		{
			if(SecurityUtils.subject.hasRole("PORTFOLIO MANAGER"))
			{
				if(action =="show")
					{permit = true}
			}
		}
		return permit	
	}
}
