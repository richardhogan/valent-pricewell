package com.valent.pricewell
import org.apache.shiro.SecurityUtils

class TimeStampSaverObjectController {

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
        [timeStampSaverObjectInstanceList: TimeStampSaverObject.list(params), timeStampSaverObjectInstanceTotal: TimeStampSaverObject.count()]
    }

    def create = {
        def timeStampSaverObjectInstance = new TimeStampSaverObject()
        timeStampSaverObjectInstance.properties = params
        return [timeStampSaverObjectInstance: timeStampSaverObjectInstance]
    }

    def save = {
        def timeStampSaverObjectInstance = new TimeStampSaverObject(params)
        if (timeStampSaverObjectInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'timeStampSaverObject.label', default: 'TimeStampSaverObject'), timeStampSaverObjectInstance.id])}"
            redirect(action: "show", id: timeStampSaverObjectInstance.id)
        }
        else {
            render(view: "create", model: [timeStampSaverObjectInstance: timeStampSaverObjectInstance])
        }
    }

    def show = {
        def timeStampSaverObjectInstance = TimeStampSaverObject.get(params.id)
        if (!timeStampSaverObjectInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'timeStampSaverObject.label', default: 'TimeStampSaverObject'), params.id])}"
            redirect(action: "list")
        }
        else {
            [timeStampSaverObjectInstance: timeStampSaverObjectInstance]
        }
    }

    def edit = {
        def timeStampSaverObjectInstance = TimeStampSaverObject.get(params.id)
        if (!timeStampSaverObjectInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'timeStampSaverObject.label', default: 'TimeStampSaverObject'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [timeStampSaverObjectInstance: timeStampSaverObjectInstance]
        }
    }

    def update = {
        def timeStampSaverObjectInstance = TimeStampSaverObject.get(params.id)
        if (timeStampSaverObjectInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (timeStampSaverObjectInstance.version > version) {
                    
                    timeStampSaverObjectInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'timeStampSaverObject.label', default: 'TimeStampSaverObject')] as Object[], "Another user has updated this TimeStampSaverObject while you were editing")
                    render(view: "edit", model: [timeStampSaverObjectInstance: timeStampSaverObjectInstance])
                    return
                }
            }
            timeStampSaverObjectInstance.properties = params
            if (!timeStampSaverObjectInstance.hasErrors() && timeStampSaverObjectInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'timeStampSaverObject.label', default: 'TimeStampSaverObject'), timeStampSaverObjectInstance.id])}"
                redirect(action: "show", id: timeStampSaverObjectInstance.id)
            }
            else {
                render(view: "edit", model: [timeStampSaverObjectInstance: timeStampSaverObjectInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'timeStampSaverObject.label', default: 'TimeStampSaverObject'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def timeStampSaverObjectInstance = TimeStampSaverObject.get(params.id)
        if (timeStampSaverObjectInstance) {
            try {
                timeStampSaverObjectInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'timeStampSaverObject.label', default: 'TimeStampSaverObject'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'timeStampSaverObject.label', default: 'TimeStampSaverObject'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'timeStampSaverObject.label', default: 'TimeStampSaverObject'), params.id])}"
            redirect(action: "list")
        }
    }
}
