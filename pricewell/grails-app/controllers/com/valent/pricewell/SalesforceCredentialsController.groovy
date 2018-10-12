package com.valent.pricewell

import grails.converters.JSON
import org.apache.shiro.SecurityUtils
class SalesforceCredentialsController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}
	
	def salesforceExportService
    def index = {
        if(SalesforceCredentials.list().size()!=0) {
			for(SalesforceCredentials sc in SalesforceCredentials.list()) {
				redirect(action: "show", id: sc.id)
			}
		}
		else {
			redirect(action: "create", params: params)
		}
    }

	def checkCredentials = {
		Map resultMap = new HashMap()
		def instanceUri = params.instanceUri
		def username = params.username
		def password = params.password
		def securityToken = params.securityToken
		
		Map salesforceCredentialsMap = [:]
		salesforceCredentialsMap["username"] = username
		salesforceCredentialsMap["password"] = password
		salesforceCredentialsMap["instanceUri"] = instanceUri
		salesforceCredentialsMap["securityToken"] = securityToken
		
		Map canLogin = salesforceExportService.isLogin(salesforceCredentialsMap)
		
		//resultMap = cwimportService.checkConnectwiseApiPermissions(siteUrl, credentials)
		if(!canLogin['result'])
		{
			resultMap["result"] = "failure"
			//def responseMessage = g.render(template:"credentialResponse", model:[responseList: resultMap["failureMessage"], responseType: "checkCredentials"])
			resultMap["responseMessage"] = canLogin['responseMessage']
		}
		else{
			resultMap["result"] = "success"
		}
		render resultMap as JSON
	}
	
	def isCredentialsAvailable = {
		def isAvailable = "no"
		Map resultMap = [:]
		if(SalesforceCredentials.list().size() > 0)
		{
			isAvailable = "yes"
		}
		else
		{
			resultMap["failureMessage"] = generateFailureMessageForUser()
		}
		
		resultMap["result"] = isAvailable
		render resultMap as JSON
	}
	
	public def generateFailureMessageForUser()
	{
		if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("SALES PRESIDENT"))
		{
			return "Salesforce Credentials not added. Please add it first by going to SETUP tab."
		}
		else if(SecurityUtils.subject.hasRole("GENERAL MANAGER") || SecurityUtils.subject.hasRole("SALES MANAGER") || SecurityUtils.subject.hasRole("SALES PERSON"))
		{
			return "Salesforce Credentials not added. Please contact SYSTEM ADMINISTATOR or SALES PRESIDENT."
		}
		else
		{
			return "Salesforce Credentials not added. Please contact SYSTEM ADMINISTATOR."
		}
	}
	
    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [salesforceCredentialsInstanceList: SalesforceCredentials.list(params), salesforceCredentialsInstanceTotal: SalesforceCredentials.count()]
    }

    def create = {
        def salesforceCredentialsInstance = new SalesforceCredentials()
        salesforceCredentialsInstance.properties = params
        return [salesforceCredentialsInstance: salesforceCredentialsInstance]
    }

	def createsetup = {
		def salesforceCredentialsInstance = new SalesforceCredentials()
		salesforceCredentialsInstance.properties = params
		def source = (params.source == "firstsetup")?"firstsetup":"setup"
		render(template: "create", model: [salesforceCredentialsInstance: salesforceCredentialsInstance, source: source])
	}
	
    def save = {
        def salesforceCredentialsInstance = new SalesforceCredentials(params)
		
		def user = User.get(new Long(SecurityUtils.subject.principal))
		
		salesforceCredentialsInstance.createdBy = user
		salesforceCredentialsInstance.modifiedBy = user
		salesforceCredentialsInstance.createdDate = new Date()
		salesforceCredentialsInstance.modifiedDate = new Date()
		
		if (salesforceCredentialsInstance.save(flush: true)) {
			flash.message = "${message(code: 'default.created.message', args: [message(code: 'salesforceCredentials.label', default: 'SalesforceCredentials'), salesforceCredentialsInstance.id])}"
			
			if(params.source == "setup" || params.source == "firstsetup"){
				render "success"
			} else{
				redirect(action: "show", id: salesforceCredentialsInstance.id)
			}
		}
		else {
			if(params.source == "setup" || params.source == "firstsetup"){
				render "fail"
			} else{
				render(view: "index")
			}
		}
    }

	def showsetup = {
		def salesforceCredentialsInstance = SalesforceCredentials.list().get(0);

		if (!salesforceCredentialsInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'salesforceCredentials.label', default: 'SalesforceCredentials'), params.id])}"
			redirect(action: "index")
		}
		else {
			if(params.source == "firstsetup")
			{
				render(template: "show", model: [salesforceCredentialsInstance: salesforceCredentialsInstance, source: "firstsetup"])
			}
			else
				render(template: "show", model: [salesforceCredentialsInstance: salesforceCredentialsInstance, source: "setup"])
		}
	}
	
    def show = {
        def salesforceCredentialsInstance = SalesforceCredentials.get(params.id)
        if (!salesforceCredentialsInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'salesforceCredentials.label', default: 'SalesforceCredentials'), params.id])}"
            redirect(action: "list")
        }
        else {
            [salesforceCredentialsInstance: salesforceCredentialsInstance]
        }
    }

    def edit = {
        def salesforceCredentialsInstance = SalesforceCredentials.get(params.id)
        if (!salesforceCredentialsInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'salesforceCredentials.label', default: 'SalesforceCredentials'), params.id])}"
            redirect(action: "list")
        }
        else {
			if(params.source == "setup" || params.source == "firstsetup")
			{
				def source = (params.source == "firstsetup")?"firstsetup":"setup"
				render(template: "edit", model: [salesforceCredentialsInstance: salesforceCredentialsInstance, source: source])
			} else{
				return [salesforceCredentialsInstance: salesforceCredentialsInstance]
			}
            
        }
    }

    def update = {
        SalesforceCredentials salesforceCredentialsInstance = SalesforceCredentials.get(params.id)
        if (salesforceCredentialsInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (salesforceCredentialsInstance.version > version) {
                    
                    salesforceCredentialsInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'salesforceCredentials.label', default: 'SalesforceCredentials')] as Object[], "Another user has updated this SalesforceCredentials while you were editing")
                    render(view: "edit", model: [salesforceCredentialsInstance: salesforceCredentialsInstance])
                    return
                }
            }
            salesforceCredentialsInstance.properties = params
			
			def user = User.get(new Long(SecurityUtils.subject.principal))
			
			salesforceCredentialsInstance.modifiedBy = user
			salesforceCredentialsInstance.modifiedDate = new Date()
			
            if (!salesforceCredentialsInstance.hasErrors() && salesforceCredentialsInstance.save(flush: true)) {
				
                if(params.source == "setup" || params.source == "firstsetup"){
					render "success"
				} else{
					flash.message = "${message(code: 'default.updated.message', args: [message(code: 'salesforceCredentials.label', default: 'SalesforceCredentials'), salesforceCredentialsInstance.id])}"
					redirect(action: "show", id: salesforceCredentialsInstance.id)
				}
            }
            else {
                if(params.source == "setup" || params.source == "firstsetup"){
					render "fail"
				} else{
					render(view: "edit", model: [salesforceCredentialsInstance: salesforceCredentialsInstance])
				}
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'salesforceCredentials.label', default: 'SalesforceCredentials'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def salesforceCredentialsInstance = SalesforceCredentials.get(params.id)
        if (salesforceCredentialsInstance) {
            try {
                salesforceCredentialsInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'salesforceCredentials.label', default: 'SalesforceCredentials'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'salesforceCredentials.label', default: 'SalesforceCredentials'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'salesforceCredentials.label', default: 'SalesforceCredentials'), params.id])}"
            redirect(action: "list")
        }
    }
}
