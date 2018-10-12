package com.valent.pricewell

import org.apache.shiro.SecurityUtils

class GeneralStagingLogController {

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
        [generalStagingLogInstanceList: GeneralStagingLog.list(params), generalStagingLogInstanceTotal: GeneralStagingLog.count()]
    }

    def create = {
        def generalStagingLogInstance = new GeneralStagingLog()
        generalStagingLogInstance.properties = params
        return [generalStagingLogInstance: generalStagingLogInstance]
    }

    def save = {
        def generalStagingLogInstance = new GeneralStagingLog(params)
        if (generalStagingLogInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'generalStagingLog.label', default: 'GeneralStagingLog'), generalStagingLogInstance.id])}"
            redirect(action: "show", id: generalStagingLogInstance.id)
        }
        else {
            render(view: "create", model: [generalStagingLogInstance: generalStagingLogInstance])
        }
    }

    def show = {
        def generalStagingLogInstance = GeneralStagingLog.get(params.id)
        if (!generalStagingLogInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'generalStagingLog.label', default: 'GeneralStagingLog'), params.id])}"
            redirect(action: "list")
        }
        else {
            [generalStagingLogInstance: generalStagingLogInstance]
        }
    }

    def edit = {
        def generalStagingLogInstance = GeneralStagingLog.get(params.id)
        if (!generalStagingLogInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'generalStagingLog.label', default: 'GeneralStagingLog'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [generalStagingLogInstance: generalStagingLogInstance]
        }
    }

    def update = {
        def generalStagingLogInstance = GeneralStagingLog.get(params.id)
        if (generalStagingLogInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (generalStagingLogInstance.version > version) {
                    
                    generalStagingLogInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'generalStagingLog.label', default: 'GeneralStagingLog')] as Object[], "Another user has updated this GeneralStagingLog while you were editing")
                    render(view: "edit", model: [generalStagingLogInstance: generalStagingLogInstance])
                    return
                }
            }
            generalStagingLogInstance.properties = params
            if (!generalStagingLogInstance.hasErrors() && generalStagingLogInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'generalStagingLog.label', default: 'GeneralStagingLog'), generalStagingLogInstance.id])}"
                redirect(action: "show", id: generalStagingLogInstance.id)
            }
            else {
                render(view: "edit", model: [generalStagingLogInstance: generalStagingLogInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'generalStagingLog.label', default: 'GeneralStagingLog'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def generalStagingLogInstance = GeneralStagingLog.get(params.id)
        if (generalStagingLogInstance) {
            try {
                generalStagingLogInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'generalStagingLog.label', default: 'GeneralStagingLog'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'generalStagingLog.label', default: 'GeneralStagingLog'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'generalStagingLog.label', default: 'GeneralStagingLog'), params.id])}"
            redirect(action: "list")
        }
    }
}
