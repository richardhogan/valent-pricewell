package com.valent.pricewell

import org.apache.shiro.SecurityUtils

class PendingMailController {

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
        [pendingMailInstanceList: PendingMail.list(params), pendingMailInstanceTotal: PendingMail.count()]
    }

    def create = {
        def pendingMailInstance = new PendingMail()
        pendingMailInstance.properties = params
        return [pendingMailInstance: pendingMailInstance]
    }

    def save = {
        def pendingMailInstance = new PendingMail(params)
        if (pendingMailInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'pendingMail.label', default: 'PendingMail'), pendingMailInstance.id])}"
            redirect(action: "show", id: pendingMailInstance.id)
        }
        else {
            render(view: "create", model: [pendingMailInstance: pendingMailInstance])
        }
    }

    def show = {
        def pendingMailInstance = PendingMail.get(params.id)
        if (!pendingMailInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'pendingMail.label', default: 'PendingMail'), params.id])}"
            redirect(action: "list")
        }
        else {
            [pendingMailInstance: pendingMailInstance]
        }
    }

    def edit = {
        def pendingMailInstance = PendingMail.get(params.id)
        if (!pendingMailInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'pendingMail.label', default: 'PendingMail'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [pendingMailInstance: pendingMailInstance]
        }
    }

    def update = {
        def pendingMailInstance = PendingMail.get(params.id)
        if (pendingMailInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (pendingMailInstance.version > version) {
                    
                    pendingMailInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'pendingMail.label', default: 'PendingMail')] as Object[], "Another user has updated this PendingMail while you were editing")
                    render(view: "edit", model: [pendingMailInstance: pendingMailInstance])
                    return
                }
            }
            pendingMailInstance.properties = params
            if (!pendingMailInstance.hasErrors() && pendingMailInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'pendingMail.label', default: 'PendingMail'), pendingMailInstance.id])}"
                redirect(action: "show", id: pendingMailInstance.id)
            }
            else {
                render(view: "edit", model: [pendingMailInstance: pendingMailInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'pendingMail.label', default: 'PendingMail'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def pendingMailInstance = PendingMail.get(params.id)
        if (pendingMailInstance) {
            try {
                pendingMailInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'pendingMail.label', default: 'PendingMail'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'pendingMail.label', default: 'PendingMail'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'pendingMail.label', default: 'PendingMail'), params.id])}"
            redirect(action: "list")
        }
    }
}
