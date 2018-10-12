package com.valent.pricewell

import org.apache.shiro.SecurityUtils
import grails.converters.JSON
import java.util.Set
import java.util.TreeSet

class ProductPricelistController {

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
        [productPricelistInstanceList: ProductPricelist.list(params), productPricelistInstanceTotal: ProductPricelist.count()]
    }

	def listforproduct = {
		def product = Product.get(params.id)
		render(template: "list", model: ["productInstance": product])
	}

    def create = {
        def productPricelistInstance = new ProductPricelist()
        productPricelistInstance.properties = params
		render(template: "create", model: ["productPricelistInstance": productPricelistInstance, "productId": params.pid])
    }

    def save = {
        def productPricelistInstance = new ProductPricelist(params)
		def user = User.get(new Long(SecurityUtils.subject.principal))
		productPricelistInstance.modifiedBy = user;
		productPricelistInstance.dateModified = new Date();
        if (productPricelistInstance.save(flush: true)) {
			redirect(action: "listforproduct", id: productPricelistInstance.product.id )
        }
        else {
            render(view: "create", model: [productPricelistInstance: productPricelistInstance])
        }
    }

    def show = {
        def productPricelistInstance = ProductPricelist.get(params.id)
        if (!productPricelistInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'productPricelist.label', default: 'ProductPricelist'), params.id])}"
            redirect(action: "list")
        }
        else {
            [productPricelistInstance: productPricelistInstance]
        }
    }

	def edit = {
        def productPricelistInstance = ProductPricelist.get(params.id)
        if (!productPricelistInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'productPricelist.label', default: 'ProductPricelist'), params.id])}"
            redirect(action: "list")
        }
        else {
			render(template: "edit", model: ["productPricelistInstance": productPricelistInstance])
        }
    }

    def update = {
        def productPricelistInstance = ProductPricelist.get(params.id)
        if (productPricelistInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (productPricelistInstance.version > version) {
                    
                    productPricelistInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'productPricelist.label', default: 'ProductPricelist')] as Object[], "Another user has updated this ProductPricelist while you were editing")
                    render(view: "edit", model: [productPricelistInstance: productPricelistInstance])
                    return
                }
            }
            productPricelistInstance.properties = params
			def user = User.get(new Long(SecurityUtils.subject.principal))
			productPricelistInstance.modifiedBy = user;
			productPricelistInstance.dateModified = new Date();
            if (!productPricelistInstance.hasErrors() && productPricelistInstance.save(flush: true)) {
                redirect(action: "listforproduct", id: productPricelistInstance.product.id)
            }
            else {
                render(view: "edit", model: [productPricelistInstance: productPricelistInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'productPricelist.label', default: 'ProductPricelist'), params.id])}"
            redirect(action: "list")
        }
    }

	def getgeostoaddjson = {
		def product = Product.get(params.id);
		def results = []
		Set ids = new TreeSet();
		if(product){
			for(ProductPricelist pl: product.productPricelists){
				ids.add(pl.geo.id);
			}
		}
		
		for(Geo geo in Geo.list(sort: "name")){
			if(!ids.contains(geo.id)){
				results.add([id: geo.id, name: geo.name])
			}
		}
	
		def jsonData = [results: results]

		render jsonData as JSON
		
	}

    def delete = {
        def productPricelistInstance = ProductPricelist.get(params.id)
		def pid = productPricelistInstance.product.id
        if (productPricelistInstance) {
            try {
                productPricelistInstance.delete(flush: true)
				redirect(action: "listforproduct", id: pid)
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'productPricelist.label', default: 'ProductPricelist'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'productPricelist.label', default: 'ProductPricelist'), params.id])}"
            redirect(action: "list")
        }
    }
}
