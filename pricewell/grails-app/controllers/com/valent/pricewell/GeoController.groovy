package com.valent.pricewell
import java.util.List;

import grails.converters.JSON
import org.apache.shiro.SecurityUtils
import grails.plugins.nimble.core.*
class GeoController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

	def serviceCatalogService
	def reviewService
	def salesCatalogService
	def roleService;
	def sendMailService
    def index = {
        redirect(action: "list", params: params)
    }
	
	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}
	
	def unassignedTerritory = {
		List territoryList = new ArrayList()
		List geoList = GeoGroup.findAll()
		
		for(Geo territory : Geo.list())
		{
			if(territory?.geoGroup == null || territory?.geoGroup == "")
				territoryList.add(territory)
		}
		
		if(territoryList.size() > 0)
			render(template: "unassignedGeo", model :[territoryList: territoryList, geoList: geoList])
		else render "noMoreTerritoryLeftToAssign"
	}
	def saveGeo = {
		Geo geoInstance = Geo.get(params.id.toLong())
		GeoGroup geo = GeoGroup.get(params.geoId.toLong())
		geoInstance.geoGroup = geo
		geoInstance.save()
		render "success"
	}
    
	def list = {
		
		/*for(Permission perm:  Permission.findByTarget("geo:*")){
			perm.target = "*"
			perm.save(flush:true)
			println " role: ${perm.role?.name} actions: ${perm.actions} Target: ${perm.target}" 
		}*/
		
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
		def territoryList = new ArrayList()
		def user = User.get(new Long(SecurityUtils.subject.principal))
		territoryList = salesCatalogService.findUserTerritories(user)
		
		/*if(user.primaryTerritory != null && user.primaryTerritory != "null" && user.primaryTerritory != "NULL")
		{
			if(!territoryList.contains(user.primaryTerritory))
			{
				territoryList.add(user.primaryTerritory)
			}
		}*/
		
		if(params.source == "setup" || params.source == "firstsetup")
		{
			def source = (params.source == "firstsetup")?"firstsetup":"setup"
			render(template: "listsetup", model :[geoInstanceList: territoryList, geoInstanceTotal: territoryList.size(), source: source, allowCreate: isPermitted("create"), allowEdit: isPermitted("edit"), allowDelete: isPermitted("delete"), allowShow: isPermitted("show")])
		}
		else
			[geoInstanceList: territoryList, geoInstanceTotal: territoryList.size(), countGeos: countGeos(), createPermission: isPermitted("create")]
    }

	def saveDefaultDocumentTemplate(){
		def territoryInstance = Geo.get(params.id.toLong())
		def selectedDocumentTemplate = DocumentTemplate.get(params.selectedId)
		
		territoryInstance?.sowDocumentTemplates.each {
			if(it.isDefault)
			{
				it.isDefault = new Boolean(false)
				it.save()
			}
		}
		
		selectedDocumentTemplate.isDefault = new Boolean(true)
		selectedDocumentTemplate.save()
		
		render "success"
	}
	
	
	def isCountryDefined = 
	{
		def territory = Geo.get(params.id.toLong())
		if(territory?.country != null && territory?.country != "NULL" && territory?.country != "" )
		{
			render "countryDefined"
		}
		else
		{
			render(template: "addCountry")
		}
	}
	
	public def countGeos()
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def counts = 0
		if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("SALES PRESIDENT") || SecurityUtils.subject.hasRole("PRODUCT MANAGER"))
		{
			counts = Geo.list().size()
		}
		else if(SecurityUtils.subject.hasRole("GENERAL MANAGER"))
		{
			if(user?.geoGroup != null)
				counts = 1
		}
		return counts
	}
	
	def listsetup = {
		redirect(action: "list", params: params)
    }
	
    def create = {
		def geoInstance = new Geo()
		GeoGroup geoGroupInstance = null
		if(params.geoId != null && params.geoId != "" && params.geoId != "null")//in UI GEO = GeoGroup class, territory = Geo class
		{
			geoGroupInstance = GeoGroup.get(params.geoId.toLong())
		}
		def salesManagerList = serviceCatalogService.findUsersByRole("SALES MANAGER")
		
		def salesPersonList = new ArrayList()
		salesPersonList = salesCatalogService.findUnassignedSalesPersonList()
		
		geoInstance.properties = params
        if(params.source == "setup" || params.source == "firstsetup")
		{
			def sourceFrom = ""
			if(params.sourceFrom == "geoGroup" || params.sourceFrom == "user")
			{
				sourceFrom = params.sourceFrom
			}
			def source = (params.source == "firstsetup")?"firstsetup":"setup"
			render(template: "createsetup", model: [geoGroupInstance: geoGroupInstance, geoInstance: geoInstance,territoryType: params.territoryType, baseCurrency: getBaseCurrency(), salesManagerList: salesManagerList, salesPersonList: salesPersonList, source: source, sourceFrom: sourceFrom])
		}
		else
			return [geoGroupInstance: geoGroupInstance, geoInstance: geoInstance, baseCurrency: getBaseCurrency(), salesManagerList: salesManagerList, salesPersonList: salesPersonList]
    }
	
	def getCurrency = {
		Geo geoInstance = Geo.get(params.id)
		def currency = ""
		if(geoInstance?.currency != null)
		{
			currency = geoInstance?.currency
		}
		render currency
	}

	def getCurrencySymbol = 
	{
		def geoInstance = Geo.get(params.id)
		def symbol = ""
		if(geoInstance?.currencySymbol != null)
		{
			symbol = geoInstance?.currencySymbol
		}
		render symbol
	}
	
	def getDateFormat =
	{
		def geoInstance = Geo.get(params.id)
		def dateFormat = ""
		if(geoInstance?.dateFormat != null)
		{
			dateFormat = geoInstance?.dateFormat
		}
		render dateFormat
	}
	
	def createsetup = {
		redirect(action: 'create', params: params)
	}
	
	private String getBaseCurrency() {
		Collection col = CompanyInformation.list();
		if(col.size() > 0) {
			return col.iterator().next().baseCurrencySymbol;
		}
		return null;
		
	}
	public boolean isTerritoryAvailable(def name)
	{
		
			def territories = Geo.findAllByName(name)
			if (territories != null && territories.size() > 0)
			{
			   return true
			  //response.status = 500
			}
			else {
				return false
			}
		
	  }

    def save = {
		def geoInstance = new Geo();
		if(isTerritoryAvailable(params.geoName))
		{
			render "territory_Available"
		}
		else
		{
			def salesManager, salesPerson
			bindData(geoInstance, params, ['geoGroup']);
			geoInstance.name = params.geoName
			/*if(params.geoGroup){
				geoInstance.geoGroup = GeoGroup.get(params.geoGroup.toLong())
			}*/		
			
			if(params.sourceFrom != "geoGroup" && params.sourceFrom != "user")
			{
				if(SecurityUtils.subject.hasRole("GENERAL MANAGER"))
				{
					def user = User.get(new Long(SecurityUtils.subject.principal))
					geoInstance.geoGroup = user?.geoGroup
					
				}
			}
			
			if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("SALES PRESIDENT"))
			{
				if(params.geoGroupId)
				{
					def geoGroupInstance = GeoGroup.get(params.geoGroupId.toLong())
					geoInstance.geoGroup = geoGroupInstance
				}
			}
			
			if(params.salesManagerId != null && params.salesManagerId != "")
			{
				salesManager = User.get(params.salesManagerId.toLong())	
				geoInstance.salesManager = salesManager
			}
			
			def map = [:]
		
			if (geoInstance.save(flush: true))
			{			
				if(params.salesManagerId != null && params.salesManagerId != "")
				{
					map = new NotificationGenerator(g).sendAssignedToSalesManagerNotification(geoInstance)
					sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/geo/show/"+geoInstance.id)
				}
				
				if(params.source == "setup" || params.source == "firstsetup")
				{
					map['res'] = "success"
					if(params.sourceFrom == "geoGroup" || params.sourceFrom == "user")
					{
						
						map['id'] = geoInstance.id
						map['name'] = geoInstance.name
						//render map as JSON
					}
					
					render map as JSON
				} else{
					flash.message = "${message(code: 'default.created.message', args: [message(code: 'territory.label', default: 'Territory'), geoInstance.name])}"
					redirect(action: "show", id: geoInstance.id)
				}
				
			}
			else {
				if(params.source == "setup" || params.source == "firstsetup"){
					render generateAJAXError(geoInstance);
				}else{
					render(view: "create", model: [geoInstance: geoInstance, baseCurrency: getBaseCurrency()])
				}
				
				
		
				//render(view: "create", model: [geoInstance: geoInstance, baseCurrency: getBaseCurrency()])
			}
		}
        
    }

	private String generateAJAXError(Object obj){
		StringBuilder sb = new StringBuilder();
		sb.append("<ul>");
		if(obj.hasErrors()){
			obj.errors.each {
				sb.append("<li>${it}</li>")
			}
		}
		sb.append("</ul>");
	}

	def saveTerritorySettings = 
	{
		def res = "fail"
		HashMap map = new HashMap();
		def geoInstance = Geo.get(params.id)
		if (geoInstance) {
			if (params.version) {
				def version = params.version.toLong()
				if (geoInstance.version > version) {
					geoInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'geo.label', default: 'Geo')] as Object[], "Another user has updated this Geo while you were editing")
					//render(template: "../setting/territorySettings", model: [geoInstance: geoInstance, sowLabel: params.sowLabel, sowTemplate: params.sowTemplate, terms: params.terms, billing_terms: params.billing_terms, signature_block: params.signature_block, source: "globle", res: "fail"])	
					map.put("res", res)
					render map as JSON
					return
				}
			}
			
			geoInstance.properties = params
			if(geoInstance.convert_rate == null)
			{
				geoInstance.convert_rate = 1
			}
			if (!geoInstance.hasErrors() && geoInstance.save(flush: true))
			{
				//flash.message = "${message(code: 'default.updated.message', args: [message(code: 'geo.label', default: 'Geo'), geoInstance.name])}"
				//render(template: "../setting/territorySettings", model: [geoInstance: geoInstance, sowLabel: params.sowLabel, sowTemplate: params.sowTemplate, terms: params.terms, billing_terms: params.billing_terms, signature_block: params.signature_block, res: "success"])
				res = "success"
				map.put("res", res)
				map.put("id", geoInstance?.id)
				render map as JSON
				return

			}
			else {
				println geoInstance.errors
				//render(template: "../setting/territorySettings", model: [geoInstance: geoInstance, sowLabel: params.sowLabel, sowTemplate: params.sowTemplate, terms: params.terms, billing_terms: params.billing_terms, signature_block: params.signature_block, source: "globle", res: "fail"])	
				map.put("res", res)
				render map as JSON
				return
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'territory.label', default: 'Territory'), params.name])}"
			//render(template: "../setting/territorySettings", model: [geoInstance: geoInstance, sowLabel: params.sowLabel, sowTemplate: params.sowTemplate, terms: params.terms, billing_terms: params.billing_terms, signature_block: params.signature_block, source: "globle", res: "fail"])	
			map.put("res", res)
			render map as JSON
			return
		}
	}
	
    def show = {
        def geoInstance = Geo.get(params.id)
		if(params.notificationId)
		{
			def note = Notification.get(params.notificationId)
			note.active = false
			note.save(flush:true)
		}
        if (!geoInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'geo.label', default: 'Geo'), params.id])}"
            redirect(action: "list")
        }
        else {
            if(params.source == "setup" || params.source == "firstsetup")
			{
				def source = (params.source == "firstsetup")?"firstsetup":"setup"
				render(template: "showsetup", model: [geoInstance: geoInstance, createPermission: isPermitted("create"), 
				updatePermission: isPermitted("edit"), baseCurrency: getBaseCurrency(), source: source])
			}
			else
				[geoInstance: geoInstance, createPermission: isPermitted("create"), 
					updatePermission: isPermitted("edit"), baseCurrency: getBaseCurrency()]
        }
    }

	def showsetup = {
        redirect(action: "show", params: params)
    }
	
	def edit = {
        def geoInstance = Geo.get(params.id)
		def salesManagerList = serviceCatalogService.findUsersByRole("SALES MANAGER")
		
		def salesPersonList = new ArrayList()
		/*serviceCatalogService.findUsersByRole("SALES PERSON")*/
		salesPersonList = salesCatalogService.findUnassignedSalesPersonList()
		
		for(User salesPerson : geoInstance?.salesPersons)
		{
			salesPersonList.add(salesPerson)
		}
        if (!geoInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'geo.label', default: 'Geo'), params.id])}"
            redirect(action: "list")
        }
        else {
            if(params.source == "setup" || params.source == "firstsetup")
			{
				def source = (params.source == "firstsetup")?"firstsetup":"setup"
				render(template: "editsetup", model: [geoInstance: geoInstance, baseCurrency: getBaseCurrency(), salesManagerList: salesManagerList, salesPersonList: salesPersonList, source: source]);
			}
			else
				return [geoInstance: geoInstance, baseCurrency: getBaseCurrency(), salesManagerList: salesManagerList, salesPersonList: salesPersonList, createPermission: isPermitted("create")]
        }
    }

	def editsetup = {
        redirect(action: "edit", params: params)
    }
	
	

    def update = {
		def geoInstance = Geo.get(params.id)
        if (geoInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (geoInstance.version > version) {
                    
                    geoInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'geo.label', default: 'Geo')] as Object[], "Another user has updated this Geo while you were editing")
                    render(view: "edit", model: [geoInstance: geoInstance, baseCurrency: getBaseCurrency()])
                    return
                }
            }
			
			def oldName = geoInstance?.name
			boolean geoAvail = false
			if(params.geoName.toLowerCase() != oldName.toLowerCase())
			{
				if(isTerritoryAvailable(params.geoName))
				{
					//render "Portfolio_Available"
					geoAvail = true
				}
			}
			
			if(geoAvail)
			{
				render "territory_Available"
			}
			else
			{
				//*************remove old sales persons**********************
					def oldSalesPersonsId = []
					for(User salesPerson :  geoInstance?.salesPersons)
					{
						oldSalesPersonsId.add(salesPerson.id)
					}
					
					for(Long remainingId : oldSalesPersonsId)
					{
						geoInstance.removeFromSalesPersons(User.get(remainingId.toLong()))
					}
				//***********************************************************
				
				if(geoInstance.convert_rate == null)
				{
					geoInstance.convert_rate = 1
				}
				bindData(geoInstance, params, ['geoGroup']);
				geoInstance.name = params.geoName
				
				if(params.geoGroup){
					geoInstance.geoGroup = GeoGroup.get(params.geoGroup.toLong())
				}
				boolean changed = false
				
				if(params.salesManagerId != null && params.salesManagerId != "")
				{
					if((geoInstance?.salesManager != null && geoInstance?.salesManager?.id != params.salesManagerId) || geoInstance?.salesManager == null)
					{
						changed = true
					}
					geoInstance.salesManager = User.get(params.salesManagerId.toLong())
				}
				
				//*******adding removing territories*********
					 
					/* def salesPersonsList = []
					 if(params.salesPersons != null)
					 {
						 for(Long remainingId : oldSalesPersonsId)
						 {
							 geoInstance.removeFromSalesPersons(User.get(remainingId.toLong()))
						 }
						 
						 for(Object i in params.salesPersons.toList())
						 {
							 if(i != ",")
								 {salesPersonsList.add(i.toLong())}
						 }
						 
						 for(Long selectedId : salesPersonsList){
						   /*if(oldSalesPersonsId.contains(selectedId)){
							  oldSalesPersonsId.remove(selectedId)
						   }
						   else
							 {*/
							 // geoInstance.addToSalesPersons(User.get(selectedId.toLong()))
						   //}
						 //}
						 
						
					 //}
				 //**************************************
					 def map = [:]
	            if (!geoInstance.hasErrors() && geoInstance.save(flush: true)) 
				{
					if(params.salesManagerId != null && params.salesManagerId != "")
					{
						if(changed == true)
						{
							map = new NotificationGenerator(g).sendAssignedToSalesManagerNotification(geoInstance)
							sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/geo/show/"+geoInstance.id)
						}
					}
					
					if(params.source == "setup" || params.source == "firstsetup"){
						render "success"
					} else{
	                	flash.message = "${message(code: 'default.updated.message', args: [message(code: 'territory.label', default: 'Territory'), geoInstance.name])}"
	                	redirect(action: "show", id: geoInstance.id)
					}
	            }
	            else {
						if(params.source == "setup" || params.source == "firstsetup"){
							render generateAJAXError(geoInstance);
						}else{
							render(view: "edit", model: [geoInstance: geoInstance, baseCurrency: getBaseCurrency()])
						}
	            }
			}
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'territory.label', default: 'Territory'), params.name])}"
            redirect(action: "list")
        }
    }

	def deletesetup = {
		def geoInstance = Geo.get(params.id)
		def name = geoInstance.name
		if (geoInstance) {
			
			
			//def priceList = Pricelist.findAll("FROM Pricelist pl WHERE pl.geo.id = :gid", [gid: geoInstance?.id])
			def opportunityList = Opportunity.findAll("FROM Opportunity op WHERE op.geo.id = :gid", [gid: geoInstance?.id])
			
			//if(opportunityList.size() > 0)
			//{
				//flash.message = "${geoInstance?.name} can not deleted, it is used in Service."
				//render "${geoInstance?.name} can not deleted, it is used in Service."
				//flash.message = name + " can not deleted, it is used in Service."
				//def userMessage = "Territory ('${geoInstance?.name}') has opportunities "+opportunityList+" associated with it and cannot be deleted"

				//render userMessage
			//}
			//else
			//{
				if(opportunityList.size() > 0){
					for(Opportunity oppo : opportunityList){
						oppo.delete(flush: true)
					}
			    }
				
				def priceList = Pricelist.findAll("FROM Pricelist pl WHERE pl.geo.id = :gid", [gid: geoInstance?.id]);
				if(priceList.size() > 0 ){
					for(Pricelist plist : priceList){
						plist.delete(flush: true)
					}
				}
				
				def productPriceList = ProductPricelist.findAll("FROM ProductPricelist pl WHERE pl.geo.id = :gid", [gid: geoInstance?.id]);
				if(productPriceList.size() > 0 ){
					for(ProductPricelist plist : productPriceList){
						plist.delete(flush: true)
					}
				}
				
				geoInstance.salesManager = null
				geoInstance.geoGroup = null
				
				def persons = geoInstance?.salesPersons
				for(User person : persons)
				{
					geoInstance.removeFromSalesPersons(person)
				}
				
				def managers = geoInstance?.salesManager
				for(User person : managers)
				{
					geoInstance.removeFromSalesManager(person)
				}
				geoInstance.save()
								
				try {
					def userList = User.findAll("FROM User user WHERE user.primaryTerritory.id = :gid", [gid: geoInstance?.id])
				
					for(User person : userList)
					{
						person.primaryTerritory = null;
						person.save(flush: true)
					}
					
					geoInstance.delete(flush: true)
					render "success"
				}
				catch (org.springframework.dao.DataIntegrityViolationException e) {
					flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'territory.label', default: 'Territory'), name])}"
					redirect(action: "show", id: params.id)
				}
			//}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'territory.label', default: 'Territory'), name])}"
			redirect(action: "list")
		}
	}
	
    def delete = {
        def geoInstance = Geo.get(params.id)
		def name = geoInstance.name
        if (geoInstance) 
		{
			ArrayList<Pricelist> priceList = Pricelist.findAll("FROM Pricelist pl WHERE pl.geo.id = :gid", [gid: geoInstance?.id])
			ArrayList<Opportunity> opportunityList = Opportunity.findAll("FROM Opportunity op WHERE op.geo.id = :gid", [gid: geoInstance?.id])
			
			if(opportunityList?.size() > 0 || priceList?.size() > 0)
			{
				flash.message = "${geoInstance?.name} can not deleted, it is used in Service."
				redirect(action: "show", id: params.id)
			}
			else
			{
				geoInstance.salesManager = null
				geoInstance.geoGroup = null
				for(User person : geoInstance?.salesPersons)
				{
					geoInstance.removeFromSalesPersons(person)
				}
				
				geoInstance.save()
								
				try {
					geoInstance.delete(flush: true)
					flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'territory.label', default: 'Territory'), name])}"
					redirect(action: "list")
				}
				catch (org.springframework.dao.DataIntegrityViolationException e) {
					flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'territory.label', default: 'Territory'), name])}"
					redirect(action: "show", id: params.id)
				}
			}
            
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'territory.label', default: 'territory'), params.id])}"
            redirect(action: "list")
        }
    }
	
	boolean checkPermission(def type)
	{
		if(type == "create")
	 	{
			 if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("SALES PRESIDENT") || SecurityUtils.subject.hasRole("GENERAL MANAGER"))
			 {
				 return true
			 }
			 else
			 return false
		 }
	 
		 else if(type == "update")
		 {
			 if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("SALES PRESIDENT") || SecurityUtils.subject.hasRole("GENERAL MANAGER") || SecurityUtils.subject.hasRole("SALES MANAGER"))
			 {
				 return true
			 }
			 else
			 	return false
		 }
	}
	
	boolean isPermitted(String action)
	{
		boolean permit = false
		if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("SALES PRESIDENT") || SecurityUtils.subject.hasRole("GENERAL MANAGER"))
		{
			permit = true
		}
		else
		{
			if(SecurityUtils.subject.hasRole("SALES MANAGER"))
			{
				if(action == "show" || action == "edit")
					{permit = true}
			}
			else if(SecurityUtils.subject.hasRole("PORTFOLIO MANAGER"))
			{
				if(action == "show")
					{permit = true}
			}
		}
		return permit
	}
}
