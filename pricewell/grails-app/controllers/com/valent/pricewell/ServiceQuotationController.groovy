package com.valent.pricewell
import org.apache.shiro.SecurityUtils
import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONObject

import grails.converters.JSON

class ServiceQuotationController {

	def quotationService, priceCalculationService
    static allowedMethods = [save: "POST", update: "POST", delete: "POST", map: "GET"]
    private static int ROUNDING_MODE = BigDecimal.ROUND_HALF_EVEN;
	private static int DECIMALS = 0;
	
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
		println ServiceQuotation.list(params)
        [serviceQuotationInstanceList: ServiceQuotation.list(params), serviceQuotationInstanceTotal: ServiceQuotation.count()]
    }

    def create = {
        def serviceQuotationInstance = new ServiceQuotation()
        serviceQuotationInstance.properties = params
        return [serviceQuotationInstance: serviceQuotationInstance]
    }
	
	def addServiceToQuote = {
		if(session["quotationId"])
		{
			Quotation quotationInstance = Quotation.get(session["quotationId"])
			
			def serviceQuotationInstance = new ServiceQuotation()
			serviceQuotationInstance.quotation = quotationInstance
			serviceQuotationInstance.geo = quotationInstance?.geo
			//serviceQuotationInstance.sequenceOrder = (quotationInstance?.serviceQuotations?.size() > 0) ? quotationInstance?.serviceQuotations?.size() + 1 : 1
						
			Map catalogCache = buildCatalogCache(quotationInstance?.geo, quotationInstance);
		//	Map catcalogSortedCache = buildSortedCatalogCache(quotationInstance?.geo);
			/*
			for(ServiceQuotation sq in quotationInstance.serviceQuotations){
				catalogCache["services"].remove(sq.service.id);
			}*/
			
			render(template: "create", model: [catcalogCache: catalogCache, serviceQuotationInstance: serviceQuotationInstance, portfolioCount: catalogCache['portfolioCount'], territory: quotationInstance?.geo.name])
				
		}
	}
	
	def map = {
		Quotation quotationInstance = Quotation.get(params.id)
		Map tempMap = buildSessionList(quotationInstance)
		
		render session["quoteMaster-${quotationInstance.geo.name}"] as JSON
	}
	
	//It can be cached 
	private Map buildCatalogCache(Geo geo, Quotation quotationInstance) {
		def pricelists = Pricelist.findAll("from Pricelist pl Where pl.geo.id = :geoId order by pl.serviceProfile.service.serviceName", [geoId: geo.id])
		
			def portfolios = []
			Map portfolioServices = new HashMap()
			Set portfoliosSet = new HashSet()
			Set serviceSet = new HashSet()
			portfolios.add([id: -1, name: "All"])
			
			
			/*for(Portfolio p in Portfolio.list(sort: "portfolioName"))
			{
				portfolios.add([id: p.id, name: p.portfolioName])
				portfolioServices.put(p.id, [])
			}*/
			
			for(Pricelist pr in pricelists)
			{
				if(pr.serviceProfile.stagingStatus.name != "inActive" && !isServiceInQuotation(quotationInstance, pr.serviceProfile))
				{
					Portfolio p = pr.serviceProfile.service.portfolio
					portfoliosSet.add([id: p.id, name: p.portfolioName])
					portfolioServices.put(p.id, [])
				}
				
			}
			
			for(Object ob : portfoliosSet.toList())
			{
				portfolios.add(ob)
			}
			portfolioServices.put(-1, [])
						
			for(Pricelist pr in pricelists)
			{
				if(pr.serviceProfile.stagingStatus.name != "inActive" && !isServiceInQuotation(quotationInstance, pr.serviceProfile))
				{
					Service s = pr.serviceProfile.service
					if(!serviceSet.contains(s))
					{
						if(s.serviceProfile != null)
						{
							serviceSet.add(s)
							def revision = " [Version ${s.serviceProfile.revision}]"//" [Version ${pr.serviceProfile.revision}]"
							portfolioServices.get(-1).add([id: s.serviceProfile.id, name: s.serviceName])//[id: pr.serviceProfile.id, name: s.serviceName+revision])
							//portfolioServices[s.portfolio.id].add([id: pr.serviceProfile.id, name: s.serviceName+revision])
							portfolioServices[s.portfolio.id].add([id: s.serviceProfile.id, name: s.serviceName])
						}
					}
				}
				
			}
			
			Map cache = [portfolios: portfolios, portfolioServices: portfolioServices, portfolioCount: portfoliosSet.toList().size()]
			
		return cache;	
	
	}
	
	private boolean isServiceInQuotation(Quotation quotationInstance, ServiceProfile serviceProfile)
	{
		ServiceQuotation serviceQuotation = ServiceQuotation.findByQuotationAndProfile(quotationInstance, serviceProfile)
		ServiceQuotation activeSq = null
		def countActive = 0, countDeleted = 0
		def activeSQId = null
		for(ServiceQuotation sq : quotationInstance?.serviceQuotations)
		{
			if(sq?.profile?.id == serviceProfile?.id)
			{
				if(activeSQId == null)
				{
					activeSQId = sq?.id
					activeSq = ServiceQuotation.get(sq?.id)
				}
				else
				{
					if(activeSQId < sq?.id)
					{
						activeSQId = sq?.id
						activeSq = ServiceQuotation.get(sq?.id)
					}
				}
			}
		}
		
		if(activeSQId != null && activeSq?.stagingStatus?.name != "delete")
		{
			return true
		}
		
		return false
	}

	private Map buildSortedCatalogCache(Geo geo) {
		def pricelists = Pricelist.findAll("from Pricelist pl Where pl.geo.id = :geoId order by pl.serviceProfile.service.serviceName", [geoId: geo.id])
		
			Map portfolios = [results: []]
			Map portfolioServices = [:]
			
			Map cache = [portfolios: portfolios, portfolioServices: portfolioServices]
			
			portfolios['results'].add([id: -1, name: "All"])
			
			for(Portfolio p in Portfolio.list(sort: "portfolioName"))
			{
				portfolios['results'].add([id: p.id, name: p.portfolioName])
				portfolioServices.put(p.id, [results: []])
			}
			
			portfolioServices.put(-1, [results: []])
						
			for(Pricelist pr in pricelists)
			{
				Service s = pr.serviceProfile.service
				portfolioServices.get(-1)['results'].add([id: s.id, name: s.serviceName])
				portfolioServices[s.portfolio.id]['results'].add([id: s.id, name: s.serviceName])
				
				
			}
			
		return cache;	
	
	}
	
	def upOrder = {
		
		if(params.quotationId)
		{
			
			def quotation = Quotation.get(params.quotationId)
			
			if(params.check)
			{
				def selectedId = params.check.toLong()
				List tmpList = quotation.serviceQuotations?.sort{it?.sequenceOrder}
				int i = 0;
				
				while(i < tmpList.size())
				{
					if(tmpList[i].id == selectedId)
					{
						if(i == 0)
						{
							break
						}
						else
						{
							int tmp = tmpList[i].sequenceOrder
							tmpList[i].sequenceOrder = tmpList[i - 1].sequenceOrder
							tmpList[i - 1].sequenceOrder = tmp
							tmpList[i].save(flush: true)
							tmpList[i - 1].save(flush: true)
							break;
						}
					}
						
					i++;
				}
				
				
			}
			render(template: "/serviceQuotation/changeOrders",
				model: [quotationInstance: quotation,
						serviceQuotationList : quotationService.getActiveServiceOfQuotation(quotation)])
		}
		
		
	}
	
	def downOrder = {
		
		if(params.quotationId)
		{
			def quotation = Quotation.get(params.quotationId)
			
			if(params.check)
			{
				def selectedId = params.check.toLong()
				List tmpList = quotation.serviceQuotations?.sort{it?.sequenceOrder}
				int i = 0;
				
				while(i < tmpList.size())
				{
					if(tmpList[i].id == selectedId)
					{
						if(i == (tmpList.size() - 1))
						{
							break
						}
						else
						{
							int tmp = tmpList[i].sequenceOrder
							tmpList[i].sequenceOrder = tmpList[i + 1].sequenceOrder
							tmpList[i + 1].sequenceOrder = tmp
							tmpList[i].save(flush: true)
							tmpList[i + 1].save(flush: true)
							break;
						}
					}
						
					i++;
				}
				
				
			}
			render(template: "/serviceQuotation/changeOrders",
				model: [quotationInstance: quotation,
						serviceQuotationList : quotationService.getActiveServiceOfQuotation(quotation)])
		}
	}
	
	def changeOrders = {
		
		if(params.quotationId)
		{
			def quotation = Quotation.get(params.quotationId)
			
			render(template: "/serviceQuotation/changeOrders",
					model: [quotationInstance: quotation,
						serviceQuotationList : quotationService.getActiveServiceOfQuotation(quotation)])
		}
	}
	
	def displayUnitOfSaleAndBaseUnits = 
	{
		Map resultMap = new HashMap()
		def serviceQuotationInstance = new ServiceQuotation()
		serviceQuotationInstance.properties = params
		ServiceProfile serviceProfile = ServiceProfile.get(params.serviceProfile.id)
		def unitOfSale = serviceProfile.unitOfSale
		BigDecimal baseUnits = serviceProfile?.baseUnits
		
		resultMap['unitOfSale'] = unitOfSale
		resultMap['baseUnits'] = baseUnits
		def additionalUnitOfSaleList = ExtraUnit.findAll("From ExtraUnit eu Where eu.serviceProfile.id = :serviceProfileId",[serviceProfileId:params.serviceProfile.id.toLong()]);
		println "List is" + additionalUnitOfSaleList
		resultMap['additionalUnitOfSaleList']=additionalUnitOfSaleList
		
		JSONArray additionalUnitOfSaleJSONArray = new JSONArray()
		additionalUnitOfSaleList.each { additionalUnit->
			additionalUnitOfSaleJSONArray.add(new JSONObject().put("id", additionalUnit.id.toInteger()).put("unitOfSale", additionalUnit.unitOfSale).put("units", additionalUnit.extraUnit))
		}
		
		JSONObject additionalUnitOfSaleJson = new JSONObject().put("additionalUnitOfSaleJSONArray", additionalUnitOfSaleJSONArray)
		
		resultMap.put("additionalUnitOfSaleJson", additionalUnitOfSaleJson.toString())
		
		render resultMap as JSON    
	}
	
	def displayCalculatedPrice = {
		def serviceQuotationInstance = new ServiceQuotation()
		//println "Extra Units :"+ params.addtionalExtraUnit;
		int addtionalExtraUnit=Integer.parseInt(params.addtionalExtraUnit)
		serviceQuotationInstance.properties = params
		ServiceProfile serviceProfile = ServiceProfile.get(params.serviceProfile.id)//this is profile id not a service id, from gsp sending profile id but name given as service id because of so many changes need so not changing name.
		serviceQuotationInstance.service = serviceProfile.service
		Map priceMap = new HashMap()
		try
		{
			if(serviceQuotationInstance?.isCorrected == "yes" && serviceQuotationInstance?.correctionsInRoleTime?.size() > 0)
			{
				Map roleHrsCorrections = quotationService.createRoleHoursMap(serviceQuotationInstance)
				priceMap = quotationService.calculteServiceProfilePrice(serviceProfile, serviceQuotationInstance.geo, serviceQuotationInstance.totalUnits, roleHrsCorrections ,addtionalExtraUnit)

			}
			else 
			{
				priceMap = quotationService.calculteServiceProfilePrice(serviceProfile, serviceQuotationInstance.geo, serviceQuotationInstance.totalUnits ,addtionalExtraUnit)
			}
			
			double serviceQuotationPrice = priceMap["totalPrice"].toDouble()
			serviceQuotationPrice = Math.round(serviceQuotationPrice).toDouble()
			
			serviceQuotationInstance.price = serviceQuotationPrice.toBigDecimal()
			
			render serviceQuotationInstance.price.setScale(DECIMALS, ROUNDING_MODE)
			
			/*Map finalPriceMap = calculatePriceByAddingExtraIncrement(priceMap["totalPrice"])
			
			serviceQuotationInstance.price = finalPriceMap['servicePrice']
			serviceQuotationInstance.extraIncrement = finalPriceMap['extraIncrement']
			
			render serviceQuotationInstance.price*/
			
		}
		catch(Exception e)
		{
			log.error "Error while calculating price of service ${serviceQuotationInstance.service} and GEO: ${serviceQuotationInstance.geo}"
			log.error e
			log.error e.stackTrace
		}
		
	}
	
	public Map calculatePriceByAddingExtraIncrement(BigDecimal servicePrice)
	{
		BigDecimal moduloTenth = servicePrice % 10
		
		BigDecimal extraIncrement = 10 - moduloTenth
		
		servicePrice = servicePrice + extraIncrement
		
		return [servicePrice: servicePrice, extraIncrement: extraIncrement]
	}
	
	def jt = {
		
	}
	
	def clearTotal = {
		def serviceQuotationInstance = new ServiceQuotation()
		serviceQuotationInstance.properties = params
		serviceQuotationInstance.totalUnits = 0
		serviceQuotationInstance.price = 0
		
		Map tempMap = buildSessionList( serviceQuotationInstance.quotation)
		List portfolioList = tempMap["portfolioList"]
		List servicesList = tempMap["servicesList"]
		
		render(template: "create", model: [portfolioList: portfolioList, servicesList: servicesList,serviceQuotationInstance: serviceQuotationInstance, portfolioId: params.portfolioId])
		
	}
	
	def displayCalculatedPriceInEdit = {
        ServiceQuotation serviceQuotationInstance = ServiceQuotation.get(params.id)
		//println serviceQuotationInstance
		//serviceQuotationInstance.properties = params
		ServiceProfile serviceProfile = ServiceProfile.get(params.profile.id)
		//println params.extraUnits   
		Map priceMap = new HashMap()
		try  
		{
			if(serviceQuotationInstance?.isCorrected == "yes" && serviceQuotationInstance?.correctionsInRoleTime?.size() > 0)
			{
				Map roleHrsCorrections = quotationService.createRoleHoursMap(serviceQuotationInstance)
				priceMap = quotationService.calculteServiceProfilePrice(serviceQuotationInstance.profile, serviceQuotationInstance.geo, params.totalUnits.toInteger(), roleHrsCorrections,params.extraUnits.toInteger())
				
			}
			else 
			{
				priceMap = quotationService.calculteServiceProfilePrice(serviceQuotationInstance.profile, serviceQuotationInstance.geo, params.totalUnits.toInteger(),params.extraUnits.toInteger())
			}
			double serviceQuotationPrice = priceMap["totalPrice"].toDouble()
			serviceQuotationPrice = Math.round(serviceQuotationPrice).toDouble()
			
			serviceQuotationInstance.price = serviceQuotationPrice.toBigDecimal()
			
			render serviceQuotationInstance.price.setScale(DECIMALS, ROUNDING_MODE)
			
			/*
			Map finalPriceMap = calculatePriceByAddingExtraIncrement(priceMap["totalPrice"])
			
			serviceQuotationInstance.price = finalPriceMap['servicePrice']
			serviceQuotationInstance.extraIncrement = finalPriceMap['extraIncrement']
			
			render serviceQuotationInstance.price
			*/
		}
		catch(Exception e)
		{
			log.error "Error while calculating price of service ${serviceQuotationInstance.service} and GEO: ${serviceQuotationInstance.geo}"
			log.error e
			log.error e.stackTrace
		}
		
	}

    def save = {
        ServiceQuotation serviceQuotationInstance = new ServiceQuotation(params)
		serviceQuotationInstance.stagingStatus = Staging.findByName("new")
		serviceQuotationInstance.oldStage = "new"
		Quotation quotationInstance = Quotation.get(serviceQuotationInstance?.quotation?.id)
		serviceQuotationInstance.sequenceOrder = (quotationInstance?.serviceQuotations?.size() > 0) ? quotationInstance?.serviceQuotations?.size() + 1 : 1
		
		if(params.additionalUnitOfSaleJson)
		{
			JSONObject additionalUnitOfSaleJson  = new JSONObject(params.additionalUnitOfSaleJson.toString());
			JSONArray additionalUnitOfSaleJsonArray = new JSONArray(additionalUnitOfSaleJson.get("additionalUnitOfSaleJSONArray").toString())
			serviceQuotationInstance.additionalUnitOfSaleJsonArray = additionalUnitOfSaleJsonArray.toString()
		}
		
		def serviceProfile = ServiceProfile.get(params.serviceProfile.id)
		serviceQuotationInstance.service = serviceProfile.service
		serviceQuotationInstance.profile =  ServiceProfile.get(params.serviceProfile.id)
		
        if (serviceQuotationInstance.save(flush: true)) {
            flash.message = "Service added to quote successfully"
            //redirect(action: "show", id: serviceQuotationInstance.id)
			//quotationService.processAndSaveChanges(serviceQuotationInstance?.quotation)
			//redirect(action: "show", controller: "quotation", id: serviceQuotationInstance?.quotation?.id, params: ["tab": "show"])
			//render(template: "/quotation/showPart", model: [quotationInstance: Quotation.get(serviceQuotationInstance?.quotation.id), serviceQuotations: quotationService.getActiveServiceOfQuotation(quotationInstance)] )
			redirect(action: "show", controller: "quotation", id: serviceQuotationInstance?.quotation?.id,, params: [source: 'fromOpportunity',addtionalExtraUnit:ExtraUnit])  
        }
        else {
            render(view: "create", model: [serviceQuotationInstance: serviceQuotationInstance])
        }
    }

    def show = {
		
        def serviceQuotationInstance = ServiceQuotation.get(params.id)
        if (!serviceQuotationInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceQuotation.label', default: 'ServiceQuotation'), params.id])}"
            redirect(action: "list")
        }
        else {
            [serviceQuotationInstance: serviceQuotationInstance]
        }
    }

    def edit = {
        ServiceQuotation serviceQuotationInstance = ServiceQuotation.get(params.sqid)
		   
		String activityId = "null"   
		if(params.activityId)
		{
			activityId = params.activityId
		}
        if (!serviceQuotationInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceQuotation.label', default: 'ServiceQuotation'), params.id])}"
            redirect(action: "list")
        }
        else {
			//println serviceQuotationInstance?.roleTimeCorrections
			def extraUnit = ExtraUnit.executeQuery("select sum(extraUnit) From ExtraUnit eu Where eu.serviceProfile.id = :serviceProfileId",[serviceProfileId:serviceQuotationInstance.profile.id]);
			def totalextraUnit;
			if(extraUnit[0]!=null)
			{
				totalextraUnit=extraUnit[0]
			}
			else
			{
				totalextraUnit=0
			}
			
			JSONArray additionalUnitOfSaleJSONArray = (serviceQuotationInstance?.additionalUnitOfSaleJsonArray != null) ? new JSONArray(serviceQuotationInstance?.additionalUnitOfSaleJsonArray) : new JSONArray()
			JSONObject additionalUnitOfSaleJSONObject = new JSONObject().put("additionalUnitOfSaleJSONArray", additionalUnitOfSaleJSONArray)
			//println additionalUnitOfSaleJSONObject.toString()
			
			render(template: "edit", model: [serviceQuotationInstance: serviceQuotationInstance, activityId: activityId, extraUnits:totalextraUnit, additionalUnitOfSaleJSONObject: additionalUnitOfSaleJSONObject, additionalUnitOfSaleJSONObjectString: additionalUnitOfSaleJSONObject.toString()])//, resultJsonMap: resultJsonMap as JSON])
        
		}
		
    }

    def update = {
        def serviceQuotationInstance = ServiceQuotation.get(params.sqid)
		 if (serviceQuotationInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (serviceQuotationInstance.version > version) 
				{
                    serviceQuotationInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'serviceQuotation.label', default: 'ServiceQuotation')] as Object[], "Another user has updated this ServiceQuotation while you were editing")
                    render(view: "edit", model: [serviceQuotationInstance: serviceQuotationInstance])
                    return
                }
            }
			
			if(serviceQuotationInstance.stagingStatus.name != "new" && serviceQuotationInstance.stagingStatus.name != "edit")
			{
				serviceQuotationInstance.stagingStatus = Staging.findByName("edit")
				serviceQuotationInstance.oldUnits = serviceQuotationInstance.totalUnits
				serviceQuotationInstance.oldStage = "edit"
			}
            serviceQuotationInstance.properties = params
			def serviceProfile = ServiceProfile.get(params.service.id)
			
			if(params.editedAdditionalUnitOfSaleJson)
			{
				JSONObject editedAdditionalUnitOfSaleJson  = new JSONObject(params.editedAdditionalUnitOfSaleJson.toString());
				JSONArray additionalUnitOfSaleJSONArray = new JSONArray(editedAdditionalUnitOfSaleJson.get("additionalUnitOfSaleJSONArray").toString())
				serviceQuotationInstance.additionalUnitOfSaleJsonArray = additionalUnitOfSaleJSONArray.toString()
			}
			
            if (!serviceQuotationInstance.hasErrors() && serviceQuotationInstance.save(flush: true)) {
                flash.message = "Quotation updated successfully"
                quotationService.processAndSaveChanges(serviceQuotationInstance?.quotation)
				//redirect(action: "show", controller: "quotation", id: serviceQuotationInstance?.quotation?.id, params: ["tab": "show"])
				//render(template: "/quotation/showPart", model: [quotationInstance: serviceQuotationInstance?.quotation] )
				//redirect(action: "showPart", controller: "quotation", id: serviceQuotationInstance?.quotation?.id)
				redirect(action: "show", controller: "quotation", id: serviceQuotationInstance.quotation.id, params: [source: 'fromOpportunity'])
            }
            else {
                render(view: "edit", model: [serviceQuotationInstance: serviceQuotationInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceQuotation.label', default: 'ServiceQuotation'), params.id])}"
            redirect(action: "list")
        }
    }
	
    def delete = {
        def serviceQuotationInstance = ServiceQuotation.get(params.sqid)
		long qid = serviceQuotationInstance.quotation.id
        if (serviceQuotationInstance) {
            try {
                serviceQuotationInstance.stagingStatus = Staging.findByName("delete")
				serviceQuotationInstance.oldUnits = serviceQuotationInstance.totalUnits
				serviceQuotationInstance.save()
				Quotation quotation = Quotation.get(qid)
				quotationService.processAndSaveChanges(quotation)
				flash.message = "Service deleted successfully"                
				//redirect(action: "show", controller: "quotation", id: quotation?.id, params: ["tab": "show"])
				//render(template: "/quotation/showPart", model: [quotationInstance: quotation] )
				redirect(action: "show", controller: "quotation", id: quotation?.id, params: [source: 'fromOpportunity'])
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'serviceQuotation.label', default: 'ServiceQuotation'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'serviceQuotation.label', default: 'ServiceQuotation'), params.id])}"
            redirect(action: "list")
        }
    }
}
