package com.valent.pricewell

import org.apache.shiro.SecurityUtils

class DescriptionController {

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
        [descriptionInstanceList: Description.list(params), descriptionInstanceTotal: Description.count()]
    }

    def create = {
        def descriptionInstance = new Description()
        descriptionInstance.properties = params
        return [descriptionInstance: descriptionInstance]
    }

    def save = {
        def descriptionInstance = new Description(params)
        if (descriptionInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'description.label', default: 'Description'), descriptionInstance.id])}"
            redirect(action: "show", id: descriptionInstance.id)
        }
        else {
            render(view: "create", model: [descriptionInstance: descriptionInstance])
        }
    }

    def show = {
        def descriptionInstance = Description.get(params.id)
        if (!descriptionInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'description.label', default: 'Description'), params.id])}"
            redirect(action: "list")
        }
        else {
            [descriptionInstance: descriptionInstance]
        }
    }

    def edit = {
        def descriptionInstance = Description.get(params.id)
        if (!descriptionInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'description.label', default: 'Description'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [descriptionInstance: descriptionInstance]
        }
    }

    def update = {
        def descriptionInstance = Description.get(params.id)
        if (descriptionInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (descriptionInstance.version > version) {
                    
                    descriptionInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'description.label', default: 'Description')] as Object[], "Another user has updated this Description while you were editing")
                    render(view: "edit", model: [descriptionInstance: descriptionInstance])
                    return
                }
            }
            descriptionInstance.properties = params
            if (!descriptionInstance.hasErrors() && descriptionInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'description.label', default: 'Description'), descriptionInstance.id])}"
                redirect(action: "show", id: descriptionInstance.id)
            }
            else {
                render(view: "edit", model: [descriptionInstance: descriptionInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'description.label', default: 'Description'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def descriptionInstance = Description.get(params.id)
        if (descriptionInstance) {
            try {
                descriptionInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'description.label', default: 'Description'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'description.label', default: 'Description'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'description.label', default: 'Description'), params.id])}"
            redirect(action: "list")
        }
    }
}
