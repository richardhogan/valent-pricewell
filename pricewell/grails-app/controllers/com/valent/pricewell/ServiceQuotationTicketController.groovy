package com.valent.pricewell
import org.apache.shiro.SecurityUtils

class ServiceQuotationTicketController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

	def cwimportService
	
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
        [serviceQuotationTicketInstanceList: ServiceQuotationTicket.list(), serviceQuotationTicketInstanceTotal: ServiceQuotationTicket.count()]
    }

	def importClosedTicket = {
		cwimportService.findServiceTickets("closed")
		render "success"
	}
	
    def create = {
        def serviceQuotationTicketInstance = new ServiceQuotationTicket()
        serviceQuotationTicketInstance.properties = params
        return [serviceQuotationTicketInstance: serviceQuotationTicketInstance]
    }

    def save = {
        def serviceQuotationTicketInstance = new ServiceQuotationTicket(params)
        if (serviceQuotationTicketInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'serviceQuotationTicket.label', default: 'ServiceQuotationTicket'), serviceQuotationTicketInstance.id])}"
            redirect(action: "show", id: serviceQuotationTicketInstance.id)
        }
        else {
            render(view: "create", model: [serviceQuotationTicketInstance: serviceQuotationTicketInstance])
        }
    }

    def show = {
        def serviceQuotationTicketInstance = ServiceQuotationTicket.get(params.id)
        if (!serviceQuotationTicketInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceQuotationTicket.label', default: 'ServiceQuotationTicket'), params.id])}"
            redirect(action: "list")
        }
        else {
            [serviceQuotationTicketInstance: serviceQuotationTicketInstance]
        }
    }

    def edit = {
        def serviceQuotationTicketInstance = ServiceQuotationTicket.get(params.id)
        if (!serviceQuotationTicketInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceQuotationTicket.label', default: 'ServiceQuotationTicket'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [serviceQuotationTicketInstance: serviceQuotationTicketInstance]
        }
    }

	def correctTicketId = {
		def serviceQuotationTicketInstance = ServiceQuotationTicket.get(params.id)
		if (!serviceQuotationTicketInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceQuotationTicket.label', default: 'ServiceQuotationTicket'), params.id])}"
			redirect(action: "list")
		}
		else {
			render(template: "correctTicketId", model: [serviceQuotationTicketInstance: serviceQuotationTicketInstance])
		}
	}
	
    def update = {
        def serviceQuotationTicketInstance = ServiceQuotationTicket.get(params.id)
        if (serviceQuotationTicketInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (serviceQuotationTicketInstance.version > version) {
                    
                    serviceQuotationTicketInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'serviceQuotationTicket.label', default: 'ServiceQuotationTicket')] as Object[], "Another user has updated this ServiceQuotationTicket while you were editing")
                    render(view: "edit", model: [serviceQuotationTicketInstance: serviceQuotationTicketInstance])
                    return
                }
            }
            serviceQuotationTicketInstance.properties = params
            if (!serviceQuotationTicketInstance.hasErrors() && serviceQuotationTicketInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'serviceQuotationTicket.label', default: 'ServiceQuotationTicket'), serviceQuotationTicketInstance.id])}"
                redirect(action: "show", id: serviceQuotationTicketInstance.id)
            }
            else {
                render(view: "edit", model: [serviceQuotationTicketInstance: serviceQuotationTicketInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceQuotationTicket.label', default: 'ServiceQuotationTicket'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def serviceQuotationTicketInstance = ServiceQuotationTicket.get(params.id)
        if (serviceQuotationTicketInstance) {
            try {
                serviceQuotationTicketInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'serviceQuotationTicket.label', default: 'ServiceQuotationTicket'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'serviceQuotationTicket.label', default: 'ServiceQuotationTicket'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceQuotationTicket.label', default: 'ServiceQuotationTicket'), params.id])}"
            redirect(action: "list")
        }
    }
}
