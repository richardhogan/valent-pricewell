package com.valent.pricewell
import org.apache.shiro.SecurityUtils

class QuotationMilestoneController {

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
        [quotationMilestoneInstanceList: QuotationMilestone.list(params), quotationMilestoneInstanceTotal: QuotationMilestone.count()]
    }

    def create = {
        def quotationMilestoneInstance = new QuotationMilestone()
        quotationMilestoneInstance.properties = params
        return [quotationMilestoneInstance: quotationMilestoneInstance]
    }

    def save = {
        def quotationMilestoneInstance = new QuotationMilestone(params)
        if (quotationMilestoneInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'quotationMilestone.label', default: 'QuotationMilestone'), quotationMilestoneInstance.id])}"
            redirect(action: "show", id: quotationMilestoneInstance.id)
        }
        else {
            render(view: "create", model: [quotationMilestoneInstance: quotationMilestoneInstance])
        }
    }

    def show = {
        def quotationMilestoneInstance = QuotationMilestone.get(params.id)
        if (!quotationMilestoneInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'quotationMilestone.label', default: 'QuotationMilestone'), params.id])}"
            redirect(action: "list")
        }
        else {
            [quotationMilestoneInstance: quotationMilestoneInstance]
        }
    }

    def edit = {
        def quotationMilestoneInstance = QuotationMilestone.get(params.id)
        if (!quotationMilestoneInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'quotationMilestone.label', default: 'QuotationMilestone'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [quotationMilestoneInstance: quotationMilestoneInstance]
        }
    }

    def update = {
        def quotationMilestoneInstance = QuotationMilestone.get(params.id)
        if (quotationMilestoneInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (quotationMilestoneInstance.version > version) {
                    
                    quotationMilestoneInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'quotationMilestone.label', default: 'QuotationMilestone')] as Object[], "Another user has updated this QuotationMilestone while you were editing")
                    render(view: "edit", model: [quotationMilestoneInstance: quotationMilestoneInstance])
                    return
                }
            }
            quotationMilestoneInstance.properties = params
            if (!quotationMilestoneInstance.hasErrors() && quotationMilestoneInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'quotationMilestone.label', default: 'QuotationMilestone'), quotationMilestoneInstance.id])}"
                redirect(action: "show", id: quotationMilestoneInstance.id)
            }
            else {
                render(view: "edit", model: [quotationMilestoneInstance: quotationMilestoneInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'quotationMilestone.label', default: 'QuotationMilestone'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def quotationMilestoneInstance = QuotationMilestone.get(params.id)
        if (quotationMilestoneInstance) {
            try {
                quotationMilestoneInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'quotationMilestone.label', default: 'QuotationMilestone'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'quotationMilestone.label', default: 'QuotationMilestone'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'quotationMilestone.label', default: 'QuotationMilestone'), params.id])}"
            redirect(action: "list")
        }
    }
}
