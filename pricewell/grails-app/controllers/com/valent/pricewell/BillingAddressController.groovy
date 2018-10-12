package com.valent.pricewell

class BillingAddressController {

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
        [billingAddressInstanceList: BillingAddress.list(params), billingAddressInstanceTotal: BillingAddress.count()]
    }

    def create = {
        def billingAddressInstance = new BillingAddress()
        billingAddressInstance.properties = params
        return [billingAddressInstance: billingAddressInstance]
    }

    def save = {
        def billingAddressInstance = new BillingAddress(params)
        if (billingAddressInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'billingAddress.label', default: 'BillingAddress'), billingAddressInstance.id])}"
            redirect(action: "show", id: billingAddressInstance.id)
        }
        else {
            render(view: "create", model: [billingAddressInstance: billingAddressInstance])
        }
    }

    def show = {
        def billingAddressInstance = BillingAddress.get(params.id)
        if (!billingAddressInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'billingAddress.label', default: 'BillingAddress'), params.id])}"
            redirect(action: "list")
        }
        else {
            [billingAddressInstance: billingAddressInstance]
        }
    }

    def edit = {
        def billingAddressInstance = BillingAddress.get(params.id)
        if (!billingAddressInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'billingAddress.label', default: 'BillingAddress'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [billingAddressInstance: billingAddressInstance]
        }
    }

    def update = {
        def billingAddressInstance = BillingAddress.get(params.id)
        if (billingAddressInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (billingAddressInstance.version > version) {
                    
                    billingAddressInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'billingAddress.label', default: 'BillingAddress')] as Object[], "Another user has updated this BillingAddress while you were editing")
                    render(view: "edit", model: [billingAddressInstance: billingAddressInstance])
                    return
                }
            }
            billingAddressInstance.properties = params
            if (!billingAddressInstance.hasErrors() && billingAddressInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'billingAddress.label', default: 'BillingAddress'), billingAddressInstance.id])}"
                redirect(action: "show", id: billingAddressInstance.id)
            }
            else {
                render(view: "edit", model: [billingAddressInstance: billingAddressInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'billingAddress.label', default: 'BillingAddress'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def billingAddressInstance = BillingAddress.get(params.id)
        if (billingAddressInstance) {
            try {
                billingAddressInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'billingAddress.label', default: 'BillingAddress'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'billingAddress.label', default: 'BillingAddress'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'billingAddress.label', default: 'BillingAddress'), params.id])}"
            redirect(action: "list")
        }
    }
}
