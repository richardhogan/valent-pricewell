package com.valent.pricewell
import org.apache.shiro.SecurityUtils

class TextTemplateController {

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
        [textTemplateInstanceList: TextTemplate.list(params), textTemplateInstanceTotal: TextTemplate.count()]
    }

    def create = {
        def textTemplateInstance = new TextTemplate()
        textTemplateInstance.properties = params
        return [textTemplateInstance: textTemplateInstance]
    }

    def save = {
        def textTemplateInstance = new TextTemplate(params)
		textTemplateInstance.dateCreated = new Date()
		textTemplateInstance.dateModified = new Date()
		
        if (textTemplateInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'textTemplate.label', default: 'TextTemplate'), textTemplateInstance.id])}"
            redirect(action: "show", id: textTemplateInstance.id)
        }
        else {
            render(view: "create", model: [textTemplateInstance: textTemplateInstance])
        }
    }

    def show = {
        def textTemplateInstance = TextTemplate.get(params.id)
        if (!textTemplateInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'textTemplate.label', default: 'TextTemplate'), params.id])}"
            redirect(action: "list")
        }
        else {
            [textTemplateInstance: textTemplateInstance]
        }
    }

    def edit = {
        def textTemplateInstance = TextTemplate.get(params.id)
        if (!textTemplateInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'textTemplate.label', default: 'TextTemplate'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [textTemplateInstance: textTemplateInstance]
        }
    }

    def update = {
        def textTemplateInstance = TextTemplate.get(params.id)
		textTemplateInstance.dateModified = new Date()
        if (textTemplateInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (textTemplateInstance.version > version) {
                    
                    textTemplateInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'textTemplate.label', default: 'TextTemplate')] as Object[], "Another user has updated this TextTemplate while you were editing")
                    render(view: "edit", model: [textTemplateInstance: textTemplateInstance])
                    return
                }
            }
            textTemplateInstance.properties = params
            if (!textTemplateInstance.hasErrors() && textTemplateInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'textTemplate.label', default: 'TextTemplate'), textTemplateInstance.id])}"
                redirect(action: "show", id: textTemplateInstance.id)
            }
            else {
                render(view: "edit", model: [textTemplateInstance: textTemplateInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'textTemplate.label', default: 'TextTemplate'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def textTemplateInstance = TextTemplate.get(params.id)
        if (textTemplateInstance) {
            try {
                textTemplateInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'textTemplate.label', default: 'TextTemplate'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'textTemplate.label', default: 'TextTemplate'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'textTemplate.label', default: 'TextTemplate'), params.id])}"
            redirect(action: "list")
        }
    }
}
