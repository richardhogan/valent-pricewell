package com.valent.pricewell

import grails.converters.JSON
import org.springframework.dao.DataIntegrityViolationException

class SowDiscountController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    }

	def listsetup()
	{
		render(template: "listsetup", model: [sowDiscountInstanceList: SowDiscount.list(params), sowDiscountInstanceTotal: SowDiscount.count()])
	}
	
    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [sowDiscountInstanceList: SowDiscount.list(params), sowDiscountInstanceTotal: SowDiscount.count()]
    }

    def create() {
		def quotationInstance = Quotation.get(params.quotationId)
		render(view: "create", model: [sowDiscountInstance: new SowDiscount(), quotationInstance: quotationInstance])
    }
	
	def createsetup() {
		render(template: "createsetup", model: [sowDiscountInstance: new SowDiscount()])
	}
	
	def addSowDiscount()
	{
		def quotationInstance = Quotation.get(params.quotationId)
		
		List<SowDiscount> discountsList = new ArrayList<SowDiscount>()
		
		quotationInstance?.geo?.sowDiscounts.each { sowDiscount ->
			discountsList.add(sowDiscount)
		}
		
		render(template: "addSowDiscount", model: [discountsList: discountsList, quotationInstance: quotationInstance])
	}

	def getDiscountAmount()
	{
		def sowDiscountInstance = SowDiscount.get(params.id)
		render sowDiscountInstance?.amount
	}
	
    def save() {
		Map resultMap = new HashMap()
        def sowDiscountInstance = new SowDiscount()
		sowDiscountInstance.properties["description", "amount"] = params
		
		Geo territoryInstance = Geo.get(params.territoryId)
		sowDiscountInstance.addToTerritories(territoryInstance)
		
        if (!sowDiscountInstance.save(flush: true)) {
            //render(view: "create", model: [sowDiscountInstance: sowDiscountInstance])
            //return
			resultMap.put("result", "fail")
        }
		else
		{
			resultMap.put("result", "success")
		}

		render resultMap as JSON
		//flash.message = message(code: 'default.created.message', args: [message(code: 'sowDiscount.label', default: 'SowDiscount'), sowDiscountInstance.id])
        //redirect(action: "show", id: sowDiscountInstance.id)
    }

    def show() {
        def sowDiscountInstance = SowDiscount.get(params.id)
        if (!sowDiscountInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'sowDiscount.label', default: 'SowDiscount'), params.id])
            redirect(action: "list")
            return
        }

        [sowDiscountInstance: sowDiscountInstance]
    }

    def edit() {
        def sowDiscountInstance = SowDiscount.get(params.id)
        if (!sowDiscountInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'sowDiscount.label', default: 'SowDiscount'), params.id])
            redirect(action: "list")
            return
        }

		[sowDiscountInstance: sowDiscountInstance]        
    }

	def editsetup() 
	{
		def sowDiscountInstance = SowDiscount.get(params.id)
		if (!sowDiscountInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'sowDiscount.label', default: 'SowDiscount'), params.id])
			redirect(action: "list")
			return
		}
		
		//println sowDiscountInstance?.territories*.id
		render(template: "editsetup", model: [sowDiscountInstance: sowDiscountInstance])
	}
	
    def update() {
		Map resultMap = new HashMap()
        def sowDiscountInstance = SowDiscount.get(params.id)
        if (!sowDiscountInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'sowDiscount.label', default: 'SowDiscount'), params.id])
            redirect(action: "list")
            return
        }

        if (params.version) {
            def version = params.version.toLong()
            if (sowDiscountInstance.version > version) {
                sowDiscountInstance.errors.rejectValue("version", "default.optimistic.locking.failure",
                          [message(code: 'sowDiscount.label', default: 'SowDiscount')] as Object[],
                          "Another user has updated this SowDiscount while you were editing")
                render(view: "edit", model: [sowDiscountInstance: sowDiscountInstance])
                return
            }
        }

        sowDiscountInstance.properties = params
		Geo territoryInstance = Geo.get(params.territoryId)
		
		List<Geo> oldTerritories = new ArrayList<Geo>()
		if(!sowDiscountInstance?.territories*.id.contains(territoryInstance?.id))
		{
			sowDiscountInstance?.territories.each {territory ->
				oldTerritories.add(territory)
			}
			
			oldTerritories.each { territory ->
				sowDiscountInstance.removeFromTerritories(territory)
			}
			
			sowDiscountInstance.addToTerritories(territoryInstance)
		}
		
        if (!sowDiscountInstance.save(flush: true)) {
            //render(view: "edit", model: [sowDiscountInstance: sowDiscountInstance])
            //return
			resultMap.put("result", "fail")
        }
		else
		{
			resultMap.put("result", "success")
		}
		//flash.message = message(code: 'default.updated.message', args: [message(code: 'sowDiscount.label', default: 'SowDiscount'), sowDiscountInstance.id])
        //redirect(action: "show", id: sowDiscountInstance.id)
		
		render resultMap as JSON
    }

    def delete() {
        def sowDiscountInstance = SowDiscount.get(params.id)
        if (!sowDiscountInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'sowDiscount.label', default: 'SowDiscount'), params.id])
            redirect(action: "list")
            return
        }

        try {
            sowDiscountInstance.delete(flush: true)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'sowDiscount.label', default: 'SowDiscount'), params.id])
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
			flash.message = message(code: 'default.not.deleted.message', args: [message(code: 'sowDiscount.label', default: 'SowDiscount'), params.id])
            redirect(action: "show", id: params.id)
        }
    }
	
	def deletesetup() {
		def result = "fail"
		def sowDiscountInstance = SowDiscount.get(params.id)
		if (!sowDiscountInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'sowDiscount.label', default: 'SowDiscount'), params.id])
			//redirect(action: "list")
			//return
			
		}
		
		if(sowDiscountInstance?.quotations?.size() == 0)
		{
			try {
				
				sowDiscountInstance?.territories.each {territory ->
					sowDiscountInstance.removeFromTerritories(territory)
				}
				sowDiscountInstance.save()
				
				sowDiscountInstance.delete(flush: true)
				//flash.message = message(code: 'default.deleted.message', args: [message(code: 'sowDiscount.label', default: 'SowDiscount'), params.id])
				//redirect(action: "list")
				result = "success"
			}
			catch (DataIntegrityViolationException e) {
				flash.message = message(code: 'default.not.deleted.message', args: [message(code: 'sowDiscount.label', default: 'SowDiscount'), params.id])
				//redirect(action: "show", id: params.id)
				
			}
		}
		
		render result
	}
}
