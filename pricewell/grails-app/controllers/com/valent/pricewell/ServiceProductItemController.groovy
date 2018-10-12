package com.valent.pricewell

import org.apache.shiro.SecurityUtils
import grails.converters.JSON
import java.util.Set
import java.util.TreeSet

class ServiceProductItemController {

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
        [serviceProductItemInstanceList: ServiceProductItem.list(params), serviceProductItemInstanceTotal: ServiceProductItem.count()]
    }
	
	def listServiceProducts = {
		if(params.serviceProfileId)
		{
			def serviceProfile = ServiceProfile.get(params.serviceProfileId)
			render(template: "listServiceProductItems", model:[serviceProfileInstance: serviceProfile])
		}
	}

    def create = {
        def serviceProductItemInstance = new ServiceProductItem()
        serviceProductItemInstance.properties = params
        return [serviceProductItemInstance: serviceProductItemInstance]
    }
	
	def createFromService = {
		if(!params.id)
		{
			flash.message = "Invalid Request";
			//TODO: Redirect appropriately
		}
		
		def serviceProductItemInstance = new ServiceProductItem() 
		serviceProductItemInstance.properties = params
		println params
		def productList = []
		productList = Product.list()
		render(template:"createFromService",
					 model:[serviceProductItemInstance: serviceProductItemInstance,productList: productList, serviceProfileId: params.id.toLong()])	
	}
	
	def getproductsjson = {
		ServiceProfile sp = ServiceProfile.get(params.id);
		def results = []
		Set ids = new TreeSet();
		if(sp){
			for(ServiceProductItem pr: sp.productsRequired){
				ids.add(pr.product.id);
			}
		}
		
		for(Product product in Product.list(sort: "productName")){
			if(!ids.contains(product.id)){
				results.add([id: product.id, name: product.productName])
			}
		}
			
		def jsonData = [results: results]

		render jsonData as JSON
		
	}

	def saveFromService = {
		
		def serviceProductItemInstance = new ServiceProductItem()
		serviceProductItemInstance.properties = params
		println params
		def serviceProfile = ServiceProfile.get(params.serviceProfileId)
		if(!serviceProfile)
		{
			flash.message = "Service Profile is not valid"
		}
			
		if(serviceProfile)
		{
			serviceProductItemInstance.save()
			serviceProfile.addToProductsRequired(serviceProductItemInstance)
			serviceProfile.save(flush:true)
			render(template: "/serviceProductItem/listServiceProductItems", model: [serviceProfileInstance: serviceProfile])	
		}
		else {
		//TODO: redirect properly
		//render(view: "create", model: [serviceDeliverableInstance: serviceDeliverableInstance])
		}
    }
	
	def editFromService ={
			def serviceProductItemInstance = ServiceProductItem.get(params.id)
			
			if (!serviceProductItemInstance) {
				flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceProductItem.label', default: 'ServiceProductItem'), params.id])}"
				//redirect(action: "list")
				//TODO: Redirect properly
			}
			else {
				return render(template:"editFromService",
								model: [serviceProductItemInstance: serviceProductItemInstance])
			}
	
		}
	
	def updateFromService = {
		def pid = params.id
		def serviceProductItemInstance = ServiceProductItem.get(params.id)
		if (serviceProductItemInstance) {
			if (params.version) {
				def version = params.version.toLong()
				if (serviceProductItemInstance.version > version) {
					
					serviceProductItemInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'serviceProductItem.label', default: 'ServiceProductItem')] as Object[], "Another user has updated this ServiceProductItem while you were editing")
					render(view: "edit", model: [serviceProductItemInstance: serviceProductItemInstance])
					return
				}
			}
			serviceProductItemInstance.properties = params
			if (!serviceProductItemInstance.hasErrors() && serviceProductItemInstance.save(flush: true)) {
				redirect(action: "listServiceProducts", params: [serviceProfileId: serviceProductItemInstance?.serviceProfile?.id])
				//redirect(action: "show", id: serviceProductItemInstance.id)
			}
			else {
				//TODO: Redirect properly
				render(view: "edit", model: [serviceProductItemInstance: serviceProductItemInstance])
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceProductItem.label', default: 'ServiceProductItem'), params.id])}"
			//TODO: Redirect properly
			//redirect(action: "list")
		}
	}
	
    def save = {
        def serviceProductItemInstance = new ServiceProductItem(params)
        if (serviceProductItemInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'serviceProductItem.label', default: 'ServiceProductItem'), serviceProductItemInstance.id])}"
            redirect(action: "show", id: serviceProductItemInstance.id)
        }
        else {
            render(view: "create", model: [serviceProductItemInstance: serviceProductItemInstance])
        }
    }

    def show = {
        def serviceProductItemInstance = ServiceProductItem.get(params.id)
        if (!serviceProductItemInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceProductItem.label', default: 'ServiceProductItem'), params.id])}"
            redirect(action: "list")
        }
        else {
            [serviceProductItemInstance: serviceProductItemInstance]
        }
    }

    def edit = {
        def serviceProductItemInstance = ServiceProductItem.get(params.id)
        if (!serviceProductItemInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceProductItem.label', default: 'ServiceProductItem'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [serviceProductItemInstance: serviceProductItemInstance]
        }
    }

    def update = {
        def serviceProductItemInstance = ServiceProductItem.get(params.id)
        if (serviceProductItemInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (serviceProductItemInstance.version > version) {
                    
                    serviceProductItemInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'serviceProductItem.label', default: 'ServiceProductItem')] as Object[], "Another user has updated this ServiceProductItem while you were editing")
                    render(view: "edit", model: [serviceProductItemInstance: serviceProductItemInstance])
                    return
                }
            }
            serviceProductItemInstance.properties = params
            if (!serviceProductItemInstance.hasErrors() && serviceProductItemInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'serviceProductItem.label', default: 'ServiceProductItem'), serviceProductItemInstance.id])}"
                redirect(action: "show", id: serviceProductItemInstance.id)
            }
            else {
                render(view: "edit", model: [serviceProductItemInstance: serviceProductItemInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceProductItem.label', default: 'ServiceProductItem'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def serviceProductItemInstance = ServiceProductItem.get(params.id)
		def name = serviceProductItemInstance.productName
        if (serviceProductItemInstance) {
            try {
                serviceProductItemInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'serviceProductItem.label', default: 'ServiceProductItem'), name])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'serviceProductItem.label', default: 'ServiceProductItem'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceProductItem.label', default: 'ServiceProductItem'), params.id])}"
            redirect(action: "list")
        }
    }
	
	def deleteFromService = {
		def serviceProductItemInstance = ServiceProductItem.get(params.id)
		def serviceProfile = serviceProductItemInstance.serviceProfile
		if (serviceProductItemInstance) {
			try {
				serviceProductItemInstance.delete(flush: true)
				redirect(action: "listServiceProducts", params: [serviceProfileId: serviceProfile?.id])
			}
			catch (org.springframework.dao.DataIntegrityViolationException e) {
				flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'serviceProductItem.label', default: 'ServiceProductItem'), name])}"
				redirect(action: "show", id: params.id)
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceProductItem.label', default: 'ServiceProductItem'), name])}"
			redirect(action: "list")
		}
	}
}
