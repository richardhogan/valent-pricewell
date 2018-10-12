package com.valent.pricewell
import org.apache.shiro.SecurityUtils

class ServiceProfileController {
	
	def quotationService 
	def priceCalculationService

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
        [serviceProfileInstanceList: ServiceProfile.list(params), serviceProfileInstanceTotal: ServiceProfile.count()]
    }

    def create = {
        def serviceProfileInstance = new ServiceProfile()
        serviceProfileInstance.properties = params
        return [serviceProfileInstance: serviceProfileInstance]
    }

    def save = {
        def serviceProfileInstance = new ServiceProfile(params)
        if (serviceProfileInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'serviceProfile.label', default: 'ServiceProfile'), serviceProfileInstance.id])}"
            redirect(action: "show", id: serviceProfileInstance.id)
        }
        else {
            render(view: "create", model: [serviceProfileInstance: serviceProfileInstance])
        }
    }

    def show = {
        def serviceProfileInstance = ServiceProfile.get(params.id)
        if (!serviceProfileInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceProfile.label', default: 'ServiceProfile'), params.id])}"
            redirect(action: "list")
        }
        else {
            [serviceProfileInstance: serviceProfileInstance]
        }
    }
	
	

    def edit = {
        def serviceProfileInstance = ServiceProfile.get(params.id)
        if (!serviceProfileInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceProfile.label', default: 'ServiceProfile'), params.id])}"
            redirect(view:"edit", action: "list")
        }
        else {
            [serviceProfileInstance: serviceProfileInstance]
        }
    }

    def update = {
        def serviceProfileInstance = ServiceProfile.get(params.id)
        if (serviceProfileInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (serviceProfileInstance.version > version) {
                    
                    serviceProfileInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'serviceProfile.label', default: 'ServiceProfile')] as Object[], "Another user has updated this ServiceProfile while you were editing")
                    render(view: "edit", model: [serviceProfileInstance: serviceProfileInstance])
                    return
                }
            }
            serviceProfileInstance.properties = params
            if (!serviceProfileInstance.hasErrors() && serviceProfileInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'serviceProfile.label', default: 'ServiceProfile'), serviceProfileInstance.id])}"
                redirect(action: "show", id: serviceProfileInstance.id)
            }
            else {
                render(view: "edit", model: [serviceProfileInstance: serviceProfileInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceProfile.label', default: 'ServiceProfile'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def serviceProfileInstance = ServiceProfile.get(params.id)
        if (serviceProfileInstance) {
            try {
                serviceProfileInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'serviceProfile.label', default: 'ServiceProfile'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'serviceProfile.label', default: 'ServiceProfile'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceProfile.label', default: 'ServiceProfile'), params.id])}"
            redirect(action: "list")
        }
    }
}
