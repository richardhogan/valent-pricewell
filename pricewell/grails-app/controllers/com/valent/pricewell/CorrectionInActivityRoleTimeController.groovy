package com.valent.pricewell

import org.apache.shiro.SecurityUtils
import java.util.Map;

class CorrectionInActivityRoleTimeController {

	private static int ROUNDING_MODE = BigDecimal.ROUND_HALF_EVEN;
	private static int DECIMALS = 0;
	
    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

	def priceCalculationService, quotationService
    def index = {
        redirect(action: "list", params: params)
    }
	
	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [correctionInActivityRoleTimeInstanceList: CorrectionInActivityRoleTime.list(params), correctionInActivityRoleTimeInstanceTotal: CorrectionInActivityRoleTime.count()]
    }

    def create = {
		def activityRoleTime = ActivityRoleTime.get(params.roleTimeId.toLong())
		def serviceQuotation = ServiceQuotation.get(params.sqId.toLong())
		def extraUnits = Integer.parseInt(params.extraUnits)
		
        def correctionInActivityRoleTimeInstance = new CorrectionInActivityRoleTime()
        correctionInActivityRoleTimeInstance.properties = params
        //return [correctionInActivityRoleTimeInstance: correctionInActivityRoleTimeInstance]
		
		render(template: "create", model: [correctionInActivityRoleTimeInstance: correctionInActivityRoleTimeInstance, activityRoleTime: activityRoleTime, serviceQuotation: serviceQuotation, extraUnits: extraUnits])
    }

	
    def save = {
		
		ActivityRoleTime activityRoleTime = ActivityRoleTime.get(params.roleTimeId.toLong())
		ServiceQuotation serviceQuotation = ServiceQuotation.get(params.sqId.toLong())
		
		BigDecimal originalHours = activityRoleTime.countTotalHoursForServiceQuotationUnits(serviceQuotation.totalUnits)
		BigDecimal totalHours = new BigDecimal(params.totalHours.toBigDecimal())
		BigDecimal extraHours = new BigDecimal(0)
		
		extraHours = totalHours - originalHours
		
        def correctionInActivityRoleTimeInstance = new CorrectionInActivityRoleTime()
		
		correctionInActivityRoleTimeInstance.originalHours = new BigDecimal(originalHours)
		correctionInActivityRoleTimeInstance.extraHours = new BigDecimal(extraHours)
		correctionInActivityRoleTimeInstance.role = DeliveryRole.get(activityRoleTime.role.id)
		correctionInActivityRoleTimeInstance.serviceActivity = ServiceActivity.get(activityRoleTime.serviceActivity.id)
		correctionInActivityRoleTimeInstance.serviceQuotation  = serviceQuotation
		
        if (correctionInActivityRoleTimeInstance.save(flush: true)) {
			
			serviceQuotation.isCorrected = "yes"
			serviceQuotation.quotation.isCorrected = "yes"
			serviceQuotation.quotation.save()
			Map roleHrsCorrections = quotationService.createRoleHoursMap(serviceQuotation)
			Map priceMap = quotationService.calculteServiceProfilePrice(serviceQuotation.profile, serviceQuotation.geo, serviceQuotation.totalUnits, roleHrsCorrections, Integer.parseInt(params.extraUnits))
			
			double serviceQuotationPrice = priceMap["totalPrice"].toDouble()
			serviceQuotationPrice = Math.round(serviceQuotationPrice).toDouble()
			
			serviceQuotation.price = serviceQuotationPrice.toBigDecimal().setScale(DECIMALS, ROUNDING_MODE)
			
			serviceQuotation.save()
			
           // flash.message = "${message(code: 'default.created.message', args: [message(code: 'correctionInActivityRoleTime.label', default: 'CorrectionInActivityRoleTime'), correctionInActivityRoleTimeInstance.id])}"
           // redirect(action: "show", id: correctionInActivityRoleTimeInstance.id)
			redirect(action: "edit", controller: "serviceQuotation", params: [sqid: serviceQuotation.id, activityId: correctionInActivityRoleTimeInstance.serviceActivity.id])
        }
        else {
            //render(view: "create", model: [correctionInActivityRoleTimeInstance: correctionInActivityRoleTimeInstance])
			render "failed"
        }
    }
	
    def show = {
        def correctionInActivityRoleTimeInstance = CorrectionInActivityRoleTime.get(params.id)
        if (!correctionInActivityRoleTimeInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'correctionInActivityRoleTime.label', default: 'CorrectionInActivityRoleTime'), params.id])}"
            redirect(action: "list")
        }
        else {
            [correctionInActivityRoleTimeInstance: correctionInActivityRoleTimeInstance]
        }
    }

    def edit = {
		
		ServiceQuotation serviceQuotation = ServiceQuotation.get(params.sqId.toLong())
		def extraUnits = Integer.parseInt(params.extraUnits)
		
        def correctionInActivityRoleTimeInstance = CorrectionInActivityRoleTime.get(params.roleTimeCorrectionId.toLong())//params.id)
        if (!correctionInActivityRoleTimeInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'correctionInActivityRoleTime.label', default: 'CorrectionInActivityRoleTime'), params.id])}"
            redirect(action: "list")
        }
        else {
            //return [correctionInActivityRoleTimeInstance: correctionInActivityRoleTimeInstance]
			render(template: "edit", model: [correctionInActivityRoleTimeInstance: correctionInActivityRoleTimeInstance, serviceQuotation: serviceQuotation, extraUnits: extraUnits])
        }
    }

    def update = {
		//println params.extraUnits+"correction" 
        CorrectionInActivityRoleTime correctionInActivityRoleTimeInstance = CorrectionInActivityRoleTime.get(params.id)
		ServiceQuotation serviceQuotation = ServiceQuotation.get(params.sqId.toLong())
        if (correctionInActivityRoleTimeInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (correctionInActivityRoleTimeInstance.version > version) {
                    
                    correctionInActivityRoleTimeInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'correctionInActivityRoleTime.label', default: 'CorrectionInActivityRoleTime')] as Object[], "Another user has updated this CorrectionInActivityRoleTime while you were editing")
                    render(view: "edit", model: [correctionInActivityRoleTimeInstance: correctionInActivityRoleTimeInstance])
                    return  
                }
            }
			
			BigDecimal originalHours = correctionInActivityRoleTimeInstance?.originalHours
			BigDecimal totalHours = new BigDecimal(params.totalHours.toBigDecimal())
			BigDecimal extraHours = new BigDecimal(0)
			
			extraHours = totalHours - originalHours
			
            correctionInActivityRoleTimeInstance.extraHours = extraHours
            if (!correctionInActivityRoleTimeInstance.hasErrors() && correctionInActivityRoleTimeInstance.save(flush: true)) {
				Map roleHrsCorrections = quotationService.createRoleHoursMap(serviceQuotation)
				//println "Rolehrscorrections" + roleHrsCorrections   
				Map priceMap = quotationService.calculteServiceProfilePrice(serviceQuotation.profile, serviceQuotation.geo, serviceQuotation.totalUnits, roleHrsCorrections, Integer.parseInt(params.extraUnits))
				
				double serviceQuotationPrice = priceMap["totalPrice"].toDouble()
				serviceQuotationPrice = Math.round(serviceQuotationPrice).toDouble()
				
				serviceQuotation.price = serviceQuotationPrice.toBigDecimal().setScale(DECIMALS, ROUNDING_MODE)
				
				//serviceQuotation.price = priceMap["totalPrice"]
				serviceQuotation.quotation.isCorrected = "yes"
				serviceQuotation.quotation.save()
				serviceQuotation.save()
				
                //flash.message = "${message(code: 'default.updated.message', args: [message(code: 'correctionInActivityRoleTime.label', default: 'CorrectionInActivityRoleTime'), correctionInActivityRoleTimeInstance.id])}"
                //redirect(action: "show", id: correctionInActivityRoleTimeInstance.id)
				
				redirect(action: "edit", controller: "serviceQuotation", params: [sqid: serviceQuotation.id, activityId: correctionInActivityRoleTimeInstance.serviceActivity.id])
            }
            else {
                //render(view: "edit", model: [correctionInActivityRoleTimeInstance: correctionInActivityRoleTimeInstance])
				render "failed"
            }
        }
        else {
            /*flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'correctionInActivityRoleTime.label', default: 'CorrectionInActivityRoleTime'), params.id])}"
            redirect(action: "list")*/
			render "failed"
        }
    }

    def delete = {
        def correctionInActivityRoleTimeInstance = CorrectionInActivityRoleTime.get(params.id)
        if (correctionInActivityRoleTimeInstance) {
            try {
                correctionInActivityRoleTimeInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'correctionInActivityRoleTime.label', default: 'CorrectionInActivityRoleTime'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'correctionInActivityRoleTime.label', default: 'CorrectionInActivityRoleTime'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'correctionInActivityRoleTime.label', default: 'CorrectionInActivityRoleTime'), params.id])}"
            redirect(action: "list")
        }
    }
}
