package com.valent.pricewell
import org.apache.shiro.SecurityUtils

class StagingLogController {

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
        [stagingLogInstanceList: StagingLog.list(params), stagingLogInstanceTotal: StagingLog.count()]
    }
	
	def listServiceStagingLog = {
		
		def serviceProfileInstance
		if(params.serviceProfileId)
		{
			serviceProfileInstance = ServiceProfile.get(params.serviceProfileId)
		}
		
		[serviceProfileInstance: serviceProfileInstance]
	}

    def create = {
        def stagingLogInstance = new StagingLog()
        stagingLogInstance.properties = params
        return [stagingLogInstance: stagingLogInstance]
    }

    def save = {
        def stagingLogInstance = new StagingLog(params)
        if (stagingLogInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'stagingLog.label', default: 'StagingLog'), stagingLogInstance.id])}"
            redirect(action: "show", id: stagingLogInstance.id)
        }
        else {
            render(view: "create", model: [stagingLogInstance: stagingLogInstance])
        }
    }

    def show = {
        def stagingLogInstance = StagingLog.get(params.id)
        if (!stagingLogInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'stagingLog.label', default: 'StagingLog'), params.id])}"
            redirect(action: "list")
        }
        else {
            [stagingLogInstance: stagingLogInstance]
        }
    }

    def edit = {
        def stagingLogInstance = StagingLog.get(params.id)
        if (!stagingLogInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'stagingLog.label', default: 'StagingLog'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [stagingLogInstance: stagingLogInstance]
        }
    }

    def update = {
        def stagingLogInstance = StagingLog.get(params.id)
        if (stagingLogInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (stagingLogInstance.version > version) {
                    
                    stagingLogInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'stagingLog.label', default: 'StagingLog')] as Object[], "Another user has updated this StagingLog while you were editing")
                    render(view: "edit", model: [stagingLogInstance: stagingLogInstance])
                    return
                }
            }
            stagingLogInstance.properties = params
            if (!stagingLogInstance.hasErrors() && stagingLogInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'stagingLog.label', default: 'StagingLog'), stagingLogInstance.id])}"
                redirect(action: "show", id: stagingLogInstance.id)
            }
            else {
                render(view: "edit", model: [stagingLogInstance: stagingLogInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'stagingLog.label', default: 'StagingLog'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def stagingLogInstance = StagingLog.get(params.id)
        if (stagingLogInstance) {
            try {
                stagingLogInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'stagingLog.label', default: 'StagingLog'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'stagingLog.label', default: 'StagingLog'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'stagingLog.label', default: 'StagingLog'), params.id])}"
            redirect(action: "list")
        }
    }
}
