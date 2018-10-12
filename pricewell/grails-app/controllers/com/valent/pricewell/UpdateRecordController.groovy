package com.valent.pricewell

import org.apache.shiro.SecurityUtils
class UpdateRecordController {

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
        [updateRecordInstanceList: UpdateRecord.list(params), updateRecordInstanceTotal: UpdateRecord.count()]
    }

    def create = {
        def updateRecordInstance = new UpdateRecord()
        updateRecordInstance.properties = params
        return [updateRecordInstance: updateRecordInstance]
    }

    def save = {
        def updateRecordInstance = new UpdateRecord(params)
        if (updateRecordInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'updateRecord.label', default: 'UpdateRecord'), updateRecordInstance.id])}"
            redirect(action: "show", id: updateRecordInstance.id)
        }
        else {
            render(view: "create", model: [updateRecordInstance: updateRecordInstance])
        }
    }

    def show = {
        def updateRecordInstance = UpdateRecord.get(params.id)
        if (!updateRecordInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'updateRecord.label', default: 'UpdateRecord'), params.id])}"
            redirect(action: "list")
        }
        else {
            [updateRecordInstance: updateRecordInstance]
        }
    }

    def edit = {
        def updateRecordInstance = UpdateRecord.get(params.id)
        if (!updateRecordInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'updateRecord.label', default: 'UpdateRecord'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [updateRecordInstance: updateRecordInstance]
        }
    }

    def update = {
        def updateRecordInstance = UpdateRecord.get(params.id)
        if (updateRecordInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (updateRecordInstance.version > version) {
                    
                    updateRecordInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'updateRecord.label', default: 'UpdateRecord')] as Object[], "Another user has updated this UpdateRecord while you were editing")
                    render(view: "edit", model: [updateRecordInstance: updateRecordInstance])
                    return
                }
            }
            updateRecordInstance.properties = params
            if (!updateRecordInstance.hasErrors() && updateRecordInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'updateRecord.label', default: 'UpdateRecord'), updateRecordInstance.id])}"
                redirect(action: "show", id: updateRecordInstance.id)
            }
            else {
                render(view: "edit", model: [updateRecordInstance: updateRecordInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'updateRecord.label', default: 'UpdateRecord'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def updateRecordInstance = UpdateRecord.get(params.id)
        if (updateRecordInstance) {
            try {
                updateRecordInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'updateRecord.label', default: 'UpdateRecord'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'updateRecord.label', default: 'UpdateRecord'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'updateRecord.label', default: 'UpdateRecord'), params.id])}"
            redirect(action: "list")
        }
    }
}
