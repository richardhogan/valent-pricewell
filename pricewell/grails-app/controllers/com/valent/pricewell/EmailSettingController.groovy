package com.valent.pricewell

import org.apache.shiro.SecurityUtils

class EmailSettingController {

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
        [emailSettingInstanceList: EmailSetting.list(params), emailSettingInstanceTotal: EmailSetting.count()]
    }
	
	def emailSetting = 
	{
		for(EmailSetting es in EmailSetting.list())
		{
			if(es.secret == null)
			{
				es.secret = "false"
				es.save()
			}
		}
		
		//def emailSettingList = []
		//emailSettingList = EmailSetting.findAll("FROM EmailSetting es")
		
		[emailSettings: EmailSetting.list()]
	}

	def emailSettings = {
		//def emailSettingList = []
		//emailSettingList = EmailSetting.findAll("FROM EmailSetting es")
	
		render(template: "emailSettings", model: [emailSettings: EmailSetting.list()])
		//[emailSettings: emailSettingList]
	}
	
	def saveSettings = {
		
		println params
		/*if(params?.username){
			EmailSetting es = map["username"];
			es.value = params?.username
			es.save(flush: true)
		}
		
		if(params.password){
			EmailSetting es = map["password"];
			es.value = params.password;
			es.save(flush: true)
		}
		
		if(params.smtphost){
			EmailSetting es = map["smtphost"];
			es.value = params.smtphost;
			es.save(flush: true)
		}
		
		flash.message = "EmailSettings saved successfully"*/
		redirect(action: "emailSettings")
	}
	
    def create = {
        def emailSettingInstance = new EmailSetting()
        emailSettingInstance.properties = params
        return [emailSettingInstance: emailSettingInstance]
    }

    def save = {
		def res = "fail"
		def emailSettingInstance = new EmailSetting()
		def value = params.value
		
		if(params.secret == "on")
		{
			emailSettingInstance.secret = true
			value = EncriptAndDecript.encrypt(params.value);
		}
		
		emailSettingInstance.name = params.key
		emailSettingInstance.value = value
        if (emailSettingInstance.save(flush: true))
		{
            //flash.message = "${message(code: 'default.created.message', args: [message(code: 'emailSetting.label', default: 'EmailSetting'), emailSettingInstance.id])}"
            //redirect(action: "emailSettings")
			res = "success"
        }
        else {
            //render(view: "create", model: [emailSettingInstance: emailSettingInstance])
			res = "fail"
        }
		render res
    }

    def show = {
        def emailSettingInstance = EmailSetting.get(params.id)
        if (!emailSettingInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'emailSetting.label', default: 'EmailSetting'), params.id])}"
            redirect(action: "list")
        }
        else {
            [emailSettingInstance: emailSettingInstance]
        }
    }

    def edit = {
        def emailSettingInstance = EmailSetting.get(params.id)
        if (!emailSettingInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'emailSetting.label', default: 'EmailSetting'), params.id])}"
            redirect(action: "list")
        }
        else {
			render(template: "edit", model: [emailSettingInstance: emailSettingInstance])
            
        }
    }

    def update = {
		def res = "fail"
        def emailSettingInstance = EmailSetting.get(params.id)
        if (emailSettingInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (emailSettingInstance.version > version) {
                    
                    //emailSettingInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'emailSetting.label', default: 'EmailSetting')] as Object[], "Another user has updated this EmailSetting while you were editing")
                    //render(view: "edit", model: [emailSettingInstance: emailSettingInstance])
                    //return
					render res
                }
            }
			
			def value = params.value
			if(emailSettingInstance.secret == "true")
			{
				value = EncriptAndDecript.encrypt(params.value);
			}
            emailSettingInstance.name = params.key
			emailSettingInstance.value = value
			
            if (!emailSettingInstance.hasErrors() && emailSettingInstance.save(flush: true)) {
                //flash.message = "${message(code: 'default.updated.message', args: [message(code: 'emailSetting.label', default: 'EmailSetting'), emailSettingInstance.id])}"
                //redirect(action: "show", id: emailSettingInstance.id)
				res = "success"
            }
            else {
                //render(view: "edit", model: [emailSettingInstance: emailSettingInstance])
            }
        }
        else {
            //flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'emailSetting.label', default: 'EmailSetting'), params.id])}"
            //redirect(action: "list")
        }
		render res
    }

    def delete = {
        def emailSettingInstance = EmailSetting.get(params.id)
		if (emailSettingInstance) {
            try {
                emailSettingInstance.delete(flush: true)
                //flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'emailSetting.label', default: 'EmailSetting'), params.id])}"
                redirect(action: "emailSettings")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
               // flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'emailSetting.label', default: 'EmailSetting'), params.id])}"
                redirect(action: "emailSettings", id: params.id)
            }
        }
        else {
            //flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'emailSetting.label', default: 'EmailSetting'), params.id])}"
            redirect(action: "emailSettings")
        }
    }
}
