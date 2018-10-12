package com.valent.pricewell

import org.apache.shiro.SecurityUtils;


import grails.converters.JSON

class ClarizenCredentialsController {
	def clarizenExportService
		static allowedMethods = [save: "POST", update: "POST", delete: "POST"]
	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}
	def index = {
		if(ClarizenCredentials.list().size()!=0) {
			for(ClarizenCredentials cc in ClarizenCredentials.list()) {
				redirect(action: "show", id: cc.id)
			}
		}
		else {
			redirect(action: "create", params: params)
		}
	}
	def create = {
		def clarizenCredentialsInstance = new ClarizenCredentials()
		clarizenCredentialsInstance.properties = params
		return [clarizenCredentialsInstance: clarizenCredentialsInstance]
	}

	def createsetup = {
		def clarizenCredentialsInstance = new ClarizenCredentials()
		clarizenCredentialsInstance.properties = params
		def source = (params.source == "firstsetup")?"firstsetup":"setup"
		render(template: "create", model: [clarizenCredentialsInstance: clarizenCredentialsInstance, source: source])
	}
	def showsetup = {
		def clarizenCredentialsInstance = ClarizenCredentials.list().get(0);

		if (!clarizenCredentialsInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'clarizenCredentials.label', default: 'ClarizenCredentials'), params.id])}"
			redirect(action: "index")
		}
		else {
			if(params.source == "firstsetup")
			{
				render(template: "show", model: [clarizenCredentialsInstance: clarizenCredentialsInstance, source: "firstsetup"])
			}
			else
				render(template: "show", model: [clarizenCredentialsInstance: clarizenCredentialsInstance, source: "setup"])
		}
	}
	def save = {
		def clarizenCredentialsInstance = new ClarizenCredentials(params)
		println "hello"+clarizenCredentialsInstance
		def user = User.get(new Long(SecurityUtils.subject.principal))
		
		clarizenCredentialsInstance.createdBy = user
		clarizenCredentialsInstance.modifiedBy = user
		clarizenCredentialsInstance.createdDate = new Date()
		clarizenCredentialsInstance.modifiedDate = new Date()
		
		if (clarizenCredentialsInstance.save(flush: true)) {
			flash.message = "${message(code: 'default.created.message', args: [message(code: 'clarizenCredentials.label', default: 'ClarizenCredentials'), clarizenCredentialsInstance.id])}"
			
			if(params.source == "setup" || params.source == "firstsetup"){
				render "success"
			} else{
				redirect(action: "show", id: clarizenCredentialsInstance.id)
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
	def checkCredentials = {
		Map resultMap = new HashMap()
		def instanceUri = params.instanceUri
		def username = params.username
		def password = params.password
		
		
		Map clarizenCredentialsMap = [:]
		clarizenCredentialsMap["username"] = username
		clarizenCredentialsMap["password"] = password
		clarizenCredentialsMap["instanceUri"] = instanceUri
	//	println 'h'+clarizenCredentialsMap
		println "before" 
		Map canLogin = clarizenExportService.isLogin(clarizenCredentialsMap)
		println "after"
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
	def edit = {
		def clarizenCredentialsInstance = ClarizenCredentials.get(params.id)
		if (!clarizenCredentialsInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'clarizenCredentials.label', default: 'ClarizenCredentials'), params.id])}"
			redirect(action: "list")
		}
		else {
			if(params.source == "setup" || params.source == "firstsetup")
			{
				def source = (params.source == "firstsetup")?"firstsetup":"setup"
				render(template: "edit", model: [clarizenCredentialsInstance: clarizenCredentialsInstance, source: source])
			} else{
				return [clarizenCredentialsInstance: clarizenCredentialsInstance]
			}
			
		}
	}

	def update = {
		ClarizenCredentials clarizenCredentialsInstance = ClarizenCredentials.get(params.id)
		if (clarizenCredentialsInstance) {
			if (params.version) {
				def version = params.version.toLong()
				if (clarizenCredentialsInstance.version > version) {
					
					clarizenCredentialsInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'clarizenCredentials.label', default: 'ClarizenCredentials')] as Object[], "Another user has updated this ClarizenCredentials while you were editing")
					render(view: "edit", model: [clarizenCredentialsInstance: clarizenCredentialsInstance])
					return
				}
			}
			clarizenCredentialsInstance.properties = params
			
			def user = User.get(new Long(SecurityUtils.subject.principal))
			
			clarizenCredentialsInstance.modifiedBy = user
			clarizenCredentialsInstance.modifiedDate = new Date()
			
			if (!clarizenCredentialsInstance.hasErrors() && clarizenCredentialsInstance.save(flush: true)) {
				
				if(params.source == "setup" || params.source == "firstsetup"){
					render "success"
				} else{
					flash.message = "${message(code: 'default.updated.message', args: [message(code: 'clarizenCredentials.label', default: 'clarizenCredentials'), clarizenCredentialsInstance.id])}"
					redirect(action: "show", id: clarizenCredentialsInstance.id)
				}
			}
			else {
				if(params.source == "setup" || params.source == "firstsetup"){
					render "fail"
				} else{
					render(view: "edit", model: [clarizenCredentialsInstance: clarizenCredentialsInstance])
				}
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'clarizenCredentials.label', default: 'ClarizenCredentials'), params.id])}"
			redirect(action: "list")
		}
	}
}
