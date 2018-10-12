package com.valent.pricewell
import org.apache.shiro.SecurityUtils
class RelationDeliveryGeoController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST", addGeosForDeliveryRole: "POST", updateMultiple: "POST", editMultiple: "POST", deleteMultiple: "POST"]
	def serviceCatalogService
	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}
	
    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        [relationDeliveryGeoInstanceList: RelationDeliveryGeo.list(params), relationDeliveryGeoInstanceTotal: RelationDeliveryGeo.count()]
    }
	
	def listForDeliveryRole = {
		DeliveryRole.get(params.id)?.listForDeliveryRole()
	}
	
	def listForGeo = {
		Geo.get(params.id)?.listForGeo()
	}
	
	def deleteMultiple = {
		List checkedRelations = []
		long deliveryRoleId
		boolean anyChecked = false
		for(String key: params.check.keySet())
		{
			if(params.check[key] == "on")
			{
				 RelationDeliveryGeo relationDeliveryGeoInstance = RelationDeliveryGeo.get(key.toLong())				 
				 if(relationDeliveryGeoInstance)
				 {
					 deliveryRoleId = relationDeliveryGeoInstance?.deliveryRole?.id
					 def geo = relationDeliveryGeoInstance?.geo
					 try {
						 relationDeliveryGeoInstance.delete(flush: true)
						 serviceCatalogService.updatePricelistForGeo(geo)
						 anyChecked = true
					 }
					 catch (org.springframework.dao.DataIntegrityViolationException e) {
						 //error while deleting
					 }
				 }
			}
		}
		
		if(params.source == "setup" || params.source == "firstsetup")
		{
			if(anyChecked == true)
				render "success"
			else render "no_selected"
		}
		else
		{
			redirect(controller: "deliveryRole", action: "show", id: deliveryRoleId)
		}
	}
	
	def editMultiple = {
		def deliveryRoleInstance = DeliveryRole.get(params.deliveryRoleId)
		List checkedRelations = []
		for(String key: params.check.keySet())
		{
			if(params.check[key] == "on")
			{
				 RelationDeliveryGeo geo = RelationDeliveryGeo.get(key.toLong())
				 if(geo)
				 {
					 checkedRelations.add(geo)
				 }
			}
		}
		if(params.source == "setup" || params.source == "firstsetup")
		{
			def source = (params.source == "firstsetup")?"firstsetup":"setup"
			if(checkedRelations?.size() > 0)
				{render(template: "editMultiple", model: [relationsList: checkedRelations, deliveryRoleInstance: deliveryRoleInstance, source: source]);}
			else render "no_selected"
		}
		else
		{
			[relationsList: checkedRelations, deliveryRoleInstance: deliveryRoleInstance]
		}
	}
	
	def updateMultiple = {
		int entries = params.entries.toInteger()
		long deliveryRoleId;
		
		for(int i=0; i<entries; i++)
		{
			def relationDeliveryGeoInstance = RelationDeliveryGeo.get(params.relations[i.toString()]?.id)
			
			deliveryRoleId = relationDeliveryGeoInstance?.deliveryRole?.id
			
			if (relationDeliveryGeoInstance) {
				if (params.version) {
					def version = params.version.toLong()
					if (relationDeliveryGeoInstance.version > version) {
						
						relationDeliveryGeoInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'relationDeliveryGeo.label', default: 'RelationDeliveryGeo')] as Object[], "Another user has updated this RelationDeliveryGeo while you were editing")
						//Error in saving						
					}
				}
				relationDeliveryGeoInstance.properties = params.relations[i.toString()]
				if (!relationDeliveryGeoInstance.hasErrors() && relationDeliveryGeoInstance.save(flush: true)) 
				{
					serviceCatalogService.updatePricelistForGeo(relationDeliveryGeoInstance?.geo)
				}
				else {
					//Error in saving
				}
			}
			else {
				//Error in saving
			}
			
		}
		
		if(params.source == "setup" || params.source == "firstsetup")
		{
			render "success"
		}
		else
		{
			redirect(controller: "deliveryRole", action: "show", id: deliveryRoleId)
		}
	}
	
	
	def addGeosForDeliveryRoleSetup = {
		
		def deliveryRoleInstance = DeliveryRole.get(params.deliveryRoleId)
		
		List checkedGeos = [] 
		for(String key: params.check.keySet())
		{
			if(params.check[key] == "on")
			{
				 Geo geo = Geo.get(key.toLong())
				 if(geo)
				 {
					 checkedGeos.add(geo)
				 }
			}
		}
		
		def source = (params.source == "firstsetup")?"firstsetup":"setup"
		
		if(checkedGeos?.size() > 0)
			render(template: "addGeosForDeliveryRoleSetup", model: [geosList: checkedGeos, deliveryRoleInstance: deliveryRoleInstance, source: source]);
			
		else render "no_selected"
		
	}
	
	def addGeosForDeliveryRole = {
		
		def deliveryRoleInstance = DeliveryRole.get(params.deliveryRoleId)
		
		List checkedGeos = [] 
		for(String key: params.check.keySet())
		{
			if(params.check[key] == "on")
			{
				 Geo geo = Geo.get(key.toLong())
				 if(geo)
				 {
					 checkedGeos.add(geo)
				 }
			}
		}
		[geosList: checkedGeos, deliveryRoleInstance: deliveryRoleInstance]
		
		
	}
	
	def saveMultiple = {
		int entries = params.entries.toInteger()
		
		long deliveryRoleId
		
		for(int i=0; i<entries; i++)
		{	
			def relationDeliveryGeoInstance = new RelationDeliveryGeo(params.relations[i.toString()])
			deliveryRoleId = relationDeliveryGeoInstance?.deliveryRole?.id
			relationDeliveryGeoInstance.save(flush: true)
			
			serviceCatalogService.updatePricelistForGeo(relationDeliveryGeoInstance?.geo)
		}
		
		if(params.source == "setup" || params.source == "firstsetup")
		{
			render "success"
		}
		else
		{
			redirect(controller: "deliveryRole", action: "show", id: deliveryRoleId)
		}
	}

    def create = {
        def relationDeliveryGeoInstance = new RelationDeliveryGeo()
        relationDeliveryGeoInstance.properties = params
        return [relationDeliveryGeoInstance: relationDeliveryGeoInstance]
    }

    def save = {
        def relationDeliveryGeoInstance = new RelationDeliveryGeo(params)
        if (relationDeliveryGeoInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'relationDeliveryGeo.label', default: 'RelationDeliveryGeo'), relationDeliveryGeoInstance.id])}"
            redirect(action: "show", id: relationDeliveryGeoInstance.id)
        }
        else {
            render(view: "create", model: [relationDeliveryGeoInstance: relationDeliveryGeoInstance])
        }
    }

    def show = {
        def relationDeliveryGeoInstance = RelationDeliveryGeo.get(params.id)
        if (!relationDeliveryGeoInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'relationDeliveryGeo.label', default: 'RelationDeliveryGeo'), params.id])}"
            redirect(action: "list")
        }
        else {
            [relationDeliveryGeoInstance: relationDeliveryGeoInstance, createPermission: SecurityUtils.subject.isPermitted("relationDeliveryGeo:create"), updatePermission: SecurityUtils.subject.isPermitted("relationDeliveryGeo:update")]
        }
    }

    def edit = {
        def relationDeliveryGeoInstance = RelationDeliveryGeo.get(params.id)
        if (!relationDeliveryGeoInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'relationDeliveryGeo.label', default: 'RelationDeliveryGeo'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [relationDeliveryGeoInstance: relationDeliveryGeoInstance]
        }
    }

    def update = {
        def relationDeliveryGeoInstance = RelationDeliveryGeo.get(params.id)
        if (relationDeliveryGeoInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (relationDeliveryGeoInstance.version > version) {
                    
                    relationDeliveryGeoInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'relationDeliveryGeo.label', default: 'RelationDeliveryGeo')] as Object[], "Another user has updated this RelationDeliveryGeo while you were editing")
                    render(view: "edit", model: [relationDeliveryGeoInstance: relationDeliveryGeoInstance])
                    return
                }
            }
            relationDeliveryGeoInstance.properties = params
            if (!relationDeliveryGeoInstance.hasErrors() && relationDeliveryGeoInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'relationDeliveryGeo.label', default: 'RelationDeliveryGeo'), relationDeliveryGeoInstance.id])}"
                redirect(action: "show", id: relationDeliveryGeoInstance.id)
            }
            else {
                render(view: "edit", model: [relationDeliveryGeoInstance: relationDeliveryGeoInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'relationDeliveryGeo.label', default: 'RelationDeliveryGeo'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def relationDeliveryGeoInstance = RelationDeliveryGeo.get(params.id)
        if (relationDeliveryGeoInstance) {
            try {
                relationDeliveryGeoInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'relationDeliveryGeo.label', default: 'RelationDeliveryGeo'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'relationDeliveryGeo.label', default: 'RelationDeliveryGeo'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'relationDeliveryGeo.label', default: 'RelationDeliveryGeo'), params.id])}"
            redirect(action: "list")
        }
    }
}
