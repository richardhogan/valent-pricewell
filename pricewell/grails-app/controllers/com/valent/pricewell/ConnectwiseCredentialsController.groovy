package com.valent.pricewell
import cw15.ApiCredentials
import cw15.ReportingApi
import cw15.ReportingApiSoap
import grails.converters.JSON
import org.apache.shiro.SecurityUtils
class ConnectwiseCredentialsController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

	def cwimportService
	
	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}
	
    def index = {
        if(ConnectwiseCredentials.list().size()!=0) {
			for(ConnectwiseCredentials cc in ConnectwiseCredentials.list()) {
				redirect(action: "show", id: cc.id)
			}
		}
		else {
			redirect(action: "create", params: params)
		}
    }

	def isCredentialsAvailable = {
		def isAvailable = "no"
		Map resultMap = [:]
		if(ConnectwiseCredentials.list().size() > 0)
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
			return "Connectwise Credentials not added. Please add it first by going to SETUP tab."
		}
		else if(SecurityUtils.subject.hasRole("GENERAL MANAGER") || SecurityUtils.subject.hasRole("SALES MANAGER") || SecurityUtils.subject.hasRole("SALES PERSON"))
		{
			return "Connectwise Credentials not added. Please contact SYSTEM ADMINISTATOR or SALES PRESIDENT."
		}
		else
		{
			return "Connectwise Credentials not added. Please contact SYSTEM ADMINISTATOR."
		}
	}
	
	def checkApiPermissions = {
		Map resultMap = new HashMap()
		def credentialsMap = cwimportService.getCredentials()
		ApiCredentials credentials = credentialsMap["credentials"]
		String siteUrl = credentialsMap["siteUrl"]
		
		resultMap = cwimportService.checkConnectwiseApiPermissions(siteUrl, credentials)
		/*if(resultMap["result"] == "failure")
		{*/
			def responseMessage = g.render(template:"credentialResponse", model:[responseList: resultMap["responseMessage"], responseType: "checkApiPermission"])
			resultMap["responseMessage"] = responseMessage
		//}
		render resultMap as JSON
	}
	
	def checkCredentials = {
		Map resultMap = new HashMap()
		def siteUrl = params.siteUrl
		def companyId = params.companyId
		def userId = params.userId
		def password = params.password
		
		ApiCredentials credentials = new ApiCredentials();
		credentials.setCompanyId(companyId);//"valent");
		credentials.setIntegratorLoginId(userId)//"int1");
		credentials.setIntegratorPassword(password)//"int1");
		
		resultMap = cwimportService.checkConnectwiseCredentials(siteUrl, credentials)
		
		//resultMap = cwimportService.checkConnectwiseApiPermissions(siteUrl, credentials)
		if(resultMap["result"] == "failure")
		{
			def responseMessage = g.render(template:"credentialResponse", model:[responseList: resultMap["failureMessage"], responseType: "checkCredentials"])
			resultMap["responseMessage"] = responseMessage
		}
		render resultMap as JSON
		/*
		String url = siteUrl + "/v4_6_release/apis/1.5/ReportingApi.asmx?wsdl"
		try{
			ReportingApi soapApi = new cw15.ReportingApi(new URL(url));
			ReportingApiSoap reportingSoap = soapApi.getReportingApiSoap()
			
			reportingSoap.runReportQuery(credentials, "Service", "", "", 10, 0)
			
			resultMap.put("result", "success")
			
			render resultMap as JSON
		}catch(Exception e)
		{
			e.printStackTrace(System.out);
			String failureMessage = generateFailureMessage(e.getMessage())
			
			resultMap.put("failureMessage", failureMessage)
			resultMap.put("result", "Failed")
			render resultMap as JSON
		}*/
	}
	
	public String generateFailureMessage(String errorMessage)
	{
		if(errorMessage != null)
		{
			if(errorMessage.contains("Cannot find company in connectwise"))
			{
				return "Invalid Company ID field. Please correct it first."
			}
			else if(errorMessage.contains("Username or password is incorrect"))
			{
				return  "Login ID or Password is incorrect. Please correct it first."
			}
			else if(errorMessage.contains("Failed to create service"))
			{
				return "Invalid URL field. Please correct it first."
			}
			else
			{
				return "Failed to save credentials due to internal error. Please contact to service provider."
			}
		}
	}
	
    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [connectwiseCredentialsInstanceList: ConnectwiseCredentials.list(params), connectwiseCredentialsInstanceTotal: ConnectwiseCredentials.count()]
    }

    def create = {
        def connectwiseCredentialsInstance = new ConnectwiseCredentials()
        connectwiseCredentialsInstance.properties = params
        return [connectwiseCredentialsInstance: connectwiseCredentialsInstance]
    }

	def createsetup = {
		def connectwiseCredentialsInstance = new ConnectwiseCredentials()
		connectwiseCredentialsInstance.properties = params
		def source = (params.source == "firstsetup")?"firstsetup":"setup"
		render(template: "create", model: [connectwiseCredentialsInstance: connectwiseCredentialsInstance, source: source])
	}
    def save = {
        def connectwiseCredentialsInstance = new ConnectwiseCredentials(params)
		def user = User.get(new Long(SecurityUtils.subject.principal))
		
		connectwiseCredentialsInstance.createdBy = user
		connectwiseCredentialsInstance.modifiedBy = user
		connectwiseCredentialsInstance.createdDate = new Date()
		connectwiseCredentialsInstance.modifiedDate = new Date()
		connectwiseCredentialsInstance.updateHours = new Integer(0)
		
        if (connectwiseCredentialsInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'connectwiseCredentials.label', default: 'ConnectwiseCredentials'), connectwiseCredentialsInstance.id])}"
            
			if(params.source == "setup" || params.source == "firstsetup"){
				render "success"
			} else{
				redirect(action: "show", id: connectwiseCredentialsInstance.id)
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

    def show = {
        def connectwiseCredentialsInstance = ConnectwiseCredentials.get(params.id)
        if (!connectwiseCredentialsInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'connectwiseCredentials.label', default: 'ConnectwiseCredentials'), params.id])}"
            redirect(action: "list")
        }
        else {
            [connectwiseCredentialsInstance: connectwiseCredentialsInstance]
        }
    }

	def showsetup = {
		def connectwiseCredentialsInstance = ConnectwiseCredentials.list().get(0);

		if (!connectwiseCredentialsInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'connectwiseCredentials.label', default: 'ConnectwiseCredentials'), params.id])}"
			redirect(action: "index")
		}
		else {
			if(params.source == "firstsetup")
			{
				render(template: "show", model: [connectwiseCredentialsInstance: connectwiseCredentialsInstance, source: "firstsetup"])
			}
			else
				render(template: "show", model: [connectwiseCredentialsInstance: connectwiseCredentialsInstance, source: "setup"])
		}
	}
	
    def edit = {
        def connectwiseCredentialsInstance = ConnectwiseCredentials.get(params.id)
        if (!connectwiseCredentialsInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'connectwiseCredentials.label', default: 'ConnectwiseCredentials'), params.id])}"
            redirect(action: "list")
        }
        else {
			if(params.source == "setup" || params.source == "firstsetup")
			{
				def source = (params.source == "firstsetup")?"firstsetup":"setup"
				render(template: "edit", model: [connectwiseCredentialsInstance: connectwiseCredentialsInstance, source: source])
			} else{
				return [connectwiseCredentialsInstance: connectwiseCredentialsInstance]
			}
            
        }
    }

    def update = {
        def connectwiseCredentialsInstance = ConnectwiseCredentials.get(params.id)
        if (connectwiseCredentialsInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (connectwiseCredentialsInstance.version > version) {
                    
                    connectwiseCredentialsInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'connectwiseCredentials.label', default: 'ConnectwiseCredentials')] as Object[], "Another user has updated this ConnectwiseCredentials while you were editing")
                    render(view: "edit", model: [connectwiseCredentialsInstance: connectwiseCredentialsInstance])
                    return
                }
            }
            connectwiseCredentialsInstance.properties = params
			def user = User.get(new Long(SecurityUtils.subject.principal))
			
			connectwiseCredentialsInstance.modifiedBy = user
			connectwiseCredentialsInstance.modifiedDate = new Date()
			
            if (!connectwiseCredentialsInstance.hasErrors() && connectwiseCredentialsInstance.save(flush: true)) {
                
				
				if(params.source == "setup" || params.source == "firstsetup"){
					render "success"
				} else{
					flash.message = "${message(code: 'default.updated.message', args: [message(code: 'connectwiseCredentials.label', default: 'ConnectwiseCredentials'), connectwiseCredentialsInstance.id])}"
					redirect(action: "show", id: connectwiseCredentialsInstance.id)
				}
            }
            else {
				if(params.source == "setup" || params.source == "firstsetup"){
					render "fail"
				} else{
					render(view: "edit", model: [connectwiseCredentialsInstance: connectwiseCredentialsInstance])
				}
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'connectwiseCredentials.label', default: 'ConnectwiseCredentials'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def connectwiseCredentialsInstance = ConnectwiseCredentials.get(params.id)
        if (connectwiseCredentialsInstance) {
            try {
                connectwiseCredentialsInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'connectwiseCredentials.label', default: 'ConnectwiseCredentials'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'connectwiseCredentials.label', default: 'ConnectwiseCredentials'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'connectwiseCredentials.label', default: 'ConnectwiseCredentials'), params.id])}"
            redirect(action: "list")
        }
    }
}
