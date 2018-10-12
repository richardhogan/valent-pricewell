package com.valent.pricewell

import org.apache.shiro.SecurityUtils

class ShippingAddressController {

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
        [shippingAddressInstanceList: ShippingAddress.list(params), shippingAddressInstanceTotal: ShippingAddress.count()]
    }

    def create = {
        def shippingAddressInstance = new ShippingAddress()
        shippingAddressInstance.properties = params
        return [shippingAddressInstance: shippingAddressInstance]
    }

    def save = {
        def shippingAddressInstance = new ShippingAddress(params)
        if (shippingAddressInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'shippingAddress.label', default: 'ShippingAddress'), shippingAddressInstance.id])}"
            redirect(action: "show", id: shippingAddressInstance.id)
        }
        else {
            render(view: "create", model: [shippingAddressInstance: shippingAddressInstance])
        }
    }

    def show = {
        def shippingAddressInstance = ShippingAddress.get(params.id)
        if (!shippingAddressInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'shippingAddress.label', default: 'ShippingAddress'), params.id])}"
            redirect(action: "list")
        }
        else {
            [shippingAddressInstance: shippingAddressInstance]
        }
    }

    def edit = {
        def shippingAddressInstance = ShippingAddress.get(params.id)
        if (!shippingAddressInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'shippingAddress.label', default: 'ShippingAddress'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [shippingAddressInstance: shippingAddressInstance]
        }
    }

    def update = {
        def shippingAddressInstance = ShippingAddress.get(params.id)
        if (shippingAddressInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (shippingAddressInstance.version > version) {
                    
                    shippingAddressInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'shippingAddress.label', default: 'ShippingAddress')] as Object[], "Another user has updated this ShippingAddress while you were editing")
                    render(view: "edit", model: [shippingAddressInstance: shippingAddressInstance])
                    return
                }
            }
            shippingAddressInstance.properties = params
            if (!shippingAddressInstance.hasErrors() && shippingAddressInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'shippingAddress.label', default: 'ShippingAddress'), shippingAddressInstance.id])}"
                redirect(action: "show", id: shippingAddressInstance.id)
            }
            else {
                render(view: "edit", model: [shippingAddressInstance: shippingAddressInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'shippingAddress.label', default: 'ShippingAddress'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def shippingAddressInstance = ShippingAddress.get(params.id)
        if (shippingAddressInstance) {
            try {
                shippingAddressInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'shippingAddress.label', default: 'ShippingAddress'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'shippingAddress.label', default: 'ShippingAddress'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'shippingAddress.label', default: 'ShippingAddress'), params.id])}"
            redirect(action: "list")
        }
    }
}
