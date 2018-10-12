package com.valent.pricewell
import java.util.List;

import grails.converters.JSON
import org.apache.shiro.SecurityUtils

class GeoGroupController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

	def serviceCatalogService
	def salesCatalogService
	def sendMailService
	
	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}
	
    def index = {
        redirect(action: "list", params: params)
    }
	
	def unassignedGeo = {
		List geoList = new ArrayList();
		
		for(GeoGroup geo : GeoGroup.list())
		{
			if(geo?.generalManagers?.size() == 0)
				geoList.add(geo)
		}
		render(template: "unassignedGeoGroup", model: [geoList: geoList])
	}

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
		def geoGroupInstanceList = new ArrayList()
		if(SecurityUtils.subject.hasRole("GENERAL MANAGER"))
		{
			def user = User.get(new Long(SecurityUtils.subject.principal))
			if(user?.geoGroup != null)
			{
				geoGroupInstanceList.add(user?.geoGroup)
			}
		}
		else if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("SALES PRESIDENT"))
		{
			geoGroupInstanceList = GeoGroup.list(params)
		}
		if(params.source == "setup" || params.source == "firstsetup")
		{
			def source = (params.source == "firstsetup")?"firstsetup":"setup"
			render(template: "listsetup", model :[geoGroupInstanceList: geoGroupInstanceList, geoGroupInstanceTotal: geoGroupInstanceList.size(), source: source, allowCreate: isPermitted("create"), allowEdit: isPermitted("edit"), allowDelete: isPermitted("delete"), allowShow: isPermitted("show")])//SecurityUtils.subject.isPermitted("geoGroup:create")]
		}
		else
        	[geoGroupInstanceList: geoGroupInstanceList, geoGroupInstanceTotal: geoGroupInstanceList.size(), createPermission: isPermitted("create")]//SecurityUtils.subject.isPermitted("geoGroup:create")]
    }
	

	def listsetup = {
		redirect(action: "list", params: params)
    }
	
	def isGeoGroupDefined =
	{
		if(GeoGroup.list().size() > 0)
		{
			render "true"
		}
		else
		{
			render "false"
		}
	}
	
	def create = {
        def geoGroupInstance = new GeoGroup()
        geoGroupInstance.properties = params
		def generalManagerList = new ArrayList()
		generalManagerList = salesCatalogService.findUnassignedGeneralManagerList()
		
		def territoriesList = TerritoriesList(geoGroupInstance)
		if(params.source == "setup" || params.source == "firstsetup")
		{
			def sourceFrom = ""
			if(params.sourceFrom == "user" || params.sourceFrom == "territory")
			{
				sourceFrom = params.sourceFrom
			}
			def source = (params.source == "firstsetup")?"firstsetup":"setup"
			render(template: "createsetup", model: [sourceFrom: sourceFrom, geoGroupInstance: geoGroupInstance, generalManagerList: generalManagerList, territoriesList: territoriesList, source: source])
		}
		else
			return [geoGroupInstance: geoGroupInstance, generalManagerList: generalManagerList, territoriesList: territoriesList]
    }
	

	def createsetup = {
		redirect(action:"create", params: params)
	}
	
	def getTerritories =
	{
		def geoGroupInstance = null
		if(params.geoId != null)
		{
			geoGroupInstance = GeoGroup.get(params.geoId)
		}
		def territoriesList = TerritoriesList(geoGroupInstance)
		render(template: "getTerritories", model: [territoriesList: territoriesList, geoGroupInstance: geoGroupInstance])
	}
	
	public List TerritoriesList(GeoGroup geoGroup)
	{
		def territoriesList = new ArrayList()
		for(Geo territory : Geo.list())
		{
			if(territory?.geoGroup == null)
			{
				territoriesList.add(territory)
			}
		}
		if(geoGroup != null)
		{
			for(Geo territory : geoGroup?.geos)
			{
				territoriesList.add(territory)
			}
		}
		
		return territoriesList
	}
	public boolean isGEOAvailable(def GEOname)
	{
		
			def GEOs = GeoGroup.findAllByName(GEOname)
			if (GEOs != null && GEOs.size() > 0)
			{
			   return true
			  //response.status = 500
			}
			else {
				return false
			}
		
	  }
	
	def save = {
        def geoGroupInstance = new GeoGroup(params)
		
		
		//geoGroupInstance.generalManager = generalManager
		//generalManager?.geoGroup = geoGroupInstance
		def map = [:]
		if(isGEOAvailable(params.name)){
			render "GEO_Available"
			
		}else{
		
			if(params.generalManagerId != null && params.generalManagerId != "")
			{
				def generalManager = User.get(params?.generalManagerId?.toInteger())
				geoGroupInstance.addToGeneralManagers(generalManager)
			}
			
			if (geoGroupInstance.save(flush: true) )//&& generalManager.save(flush: true))
			{
				if(params.generalManagerId != null && params.generalManagerId != "")
				{
					map = new NotificationGenerator(g).sendAssignedToGeneralManagerNotification(geoGroupInstance);
					sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/geoGroup/show/"+geoGroupInstance.id)
				}
				
				if(params.source == "setup" || params.source == "firstsetup")
				{
					Map resultMap = new HashMap()
					resultMap['result'] = "success"
					
					if(params.sourceFrom == "user" || params.sourceFrom == "territory")
					{
						
						resultMap['geoId'] = geoGroupInstance.id
						resultMap['geoName'] = geoGroupInstance.name
						
					}
					render resultMap as JSON
					
				} else{
					flash.message = "${message(code: 'default.created.message', args: [message(code: 'geo.label', default: 'Geo'), geoGroupInstance.name])}"
					redirect(action: "show", id: geoGroupInstance.id)
				}
			}
			else {
					if(params.source == "setup" || params.source == "firstsetup"){
						//Display error related messages.
					}else{
						render(view: "create", model: [geoGroupInstance: geoGroupInstance])
					}
				
			}
		
		}
		
    }
	

    def show = {
        def geoGroupInstance = GeoGroup.get(params.id)
		if(params.notificationId)
		{
			def note = Notification.get(params.notificationId)
			note.active = false
			note.save(flush:true)
		}
        if (!geoGroupInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'geo.label', default: 'Geo'), params.id])}"
            redirect(action: "list")
        }
        else {
            [geoGroupInstance: geoGroupInstance, createPermission: isPermitted("create")]//SecurityUtils.subject.isPermitted("geoGroup:create")]
        }
    }
	
	def edit = {
        def geoGroupInstance = GeoGroup.get(params.id)
        if (!geoGroupInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'geo.label', default: 'Geo'), params.id])}"
            redirect(action: "list")
        }
        else {
			def generalManagerList = []
			def generalManagerId = null
			generalManagerList = salesCatalogService.findUnassignedGeneralManagerList()
			if(geoGroupInstance?.generalManagers.size() > 0)
			{
				for(User gm : geoGroupInstance.generalManagers)
				{
					generalManagerId = gm.id //getting id of assigned general manager
					generalManagerList.add(gm)
				}
			}
			
			def territoriesList = TerritoriesList(geoGroupInstance)
			if(params.source == "setup" || params.source == "firstsetup")
			{
				def source = (params.source == "firstsetup")?"firstsetup":"setup"
				render(template: "editsetup", model: [geoGroupInstance: geoGroupInstance, generalManagerList: generalManagerList, generalManagerId: generalManagerId, territoriesList: territoriesList, source: source]);
			}
			else
            	return [geoGroupInstance: geoGroupInstance, generalManagerList: generalManagerList, generalManagerId: generalManagerId, territoriesList: territoriesList, createPermission: isPermitted("create")]
        }
    }

 	def editsetup = {
		 redirect(action: "edit", params: params)
    }
	
	def getName = 
	{
		def geoGroupInstance = GeoGroup.get(params.id)
		render geoGroupInstance.name
	}
	
    def update = {
        def geoGroupInstance = GeoGroup.get(params.id)
		
		def oldName = geoGroupInstance?.name
		boolean geoGroupAvail = false
		if(params.name.toLowerCase() != oldName.toLowerCase())
		{
			if(isGEOAvailable(params.name))
			{
				//render "Portfolio_Available"
				geoGroupAvail = true
			}
		}
		
		if(geoGroupAvail)
		{
			render "GEO_Available"
			
		}
		else
		{
	        if (geoGroupInstance) {
	            if (params.version) {
	                def version = params.version.toLong()
	                if (geoGroupInstance.version > version) {
	                    
	                    geoGroupInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'geo.label', default: 'Geo')] as Object[], "Another user has updated this GeoGroup while you were editing")
	                    render(view: "edit", model: [geoGroupInstance: geoGroupInstance])
	                    return
	                }
	            }
				
				geoGroupInstance.properties["name", "description"] = params
				
				//*******adding removing territories*********
					def oldTerritoriesIds = [] 
					for(Geo territory :  geoGroupInstance?.geos)
					{
						oldTerritoriesIds.add(territory.id)
					}
					
					def territoriesList = []
					List filteredList = generateTerritoryList(params.geos?.toString())
					
					for(Object i in filteredList)
					{
						//if(i != ",")
							//{
						territoriesList.add(i.toLong())//}
					}
					
					for(Long selectedId : territoriesList){
					  if(oldTerritoriesIds.contains(selectedId)){
						 oldTerritoriesIds.remove(selectedId)
					  } 
					  else
				  	  {
					     geoGroupInstance.addToGeos(Geo.get(selectedId.toLong()))
					  }
					}
					
					for(Long remainingId : oldTerritoriesIds)
					{
						geoGroupInstance.removeFromGeos(Geo.get(remainingId.toLong()))
					}
				//**************************************
				boolean changed = false
				//******changing General Manage***********
				if(params.generalManagerId != null && params.generalManagerId != "")
				{
					def generalManager = User.get(params?.generalManagerId.toInteger())
					if(geoGroupInstance?.generalManagers.size() == 0)
					{
						//geoGroupInstance.generalManager = generalManager
						//generalManager?.geoGroup = geoGroupInstance
						geoGroupInstance.addToGeneralManagers(generalManager)
						changed = true
					}
					else
					{
						for(User gm : geoGroupInstance.generalManagers)
						{
							if(generalManager?.id != gm.id)
							{
								/*def oldManager = User.get(geoGroupInstance?.generalManager.id)
								oldManager?.geoGroup = null
								oldManager.save()*/
								geoGroupInstance.removeFromGeneralManagers(gm)
								
								//geoGroupInstance.generalManager = generalManager
								//generalManager?.geoGroup = geoGroupInstance
								geoGroupInstance.addToGeneralManagers(generalManager)
								changed = true
							}
						}
						
		
					}	
				}		
				//*******************************************
				
				def map = [:]
	            if (!geoGroupInstance.hasErrors() && geoGroupInstance.save(flush: true))// && generalManager.save(flush: true)) 
				{
					if(changed == true)
					{
						if(params.generalManagerId != null && params.generalManagerId != "")
						{
							map = new NotificationGenerator(g).sendAssignedToGeneralManagerNotification(geoGroupInstance);
							sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/geoGroup/show/"+geoGroupInstance.id)
						}
					}
					
					if(params.source == "setup" || params.source == "firstsetup"){
						render "success"
					}else{
						flash.message = "${message(code: 'default.updated.message', args: [message(code: 'geo.label', default: 'Geo'), geoGroupInstance.name])}"
		                redirect(action: "show", id: geoGroupInstance.id)
					}
	                
	            }
	            else {
	                render(view: "edit", model: [geoGroupInstance: geoGroupInstance])
	            }
	        }
	        else {
	            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'geo.label', default: 'Geo'), geoGroupInstance.name])}"
	            redirect(action: "list")
	        }
		}
    }
	
	public List generateTerritoryList(String geos)//geos = territories
	{
		List territoryIds = new ArrayList()
		
		if(geos?.size() == 0)
		{
			//allowedStatus.add(defaultStatus)
		}
		else
		{
			if(geos.contains(","))
			{
				List territoryIdList = geos.replace("[", "").replace("]", "").split("\\,")
				for(String Id : territoryIdList)
				{
					territoryIds.add(Id.replaceFirst(" ", ""))
				}
			}
			else
			{
				territoryIds.add(geos)
			}
		}
		
		return territoryIds
	}
    
	def delete = {
        def geoGroupInstance = GeoGroup.get(params.id)
		def name = geoGroupInstance.name
        if (geoGroupInstance) 
		{
			checkForManagerAndTerritory(geoGroupInstance)
            try {
                geoGroupInstance.delete(flush: true)
				if(params.source == "setup" || params.source == "firstsetup"){
					render "success"
				}else{
	                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'geo.label', default: 'Geo'), name])}"
	                redirect(action: "list")
				}
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
				if(params.source == "setup" || params.source == "firstsetup"){
					render "${message(code: 'default.not.deleted.message', args: [message(code: 'geo.label', default: 'Geo'), name])}"
				}else{
	                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'geo.label', default: 'Geo'), name])}"
	                redirect(action: "show", id: params.id)
				}
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'geo.label', default: 'Geo'), name])}"
            redirect(action: "list")
        }
    }
	
	def deletesetup = 
	{
		//redirect(action: "delete", params: params)
		def geoGroupInstance = GeoGroup.get(params.id)
		def name = geoGroupInstance.name
		if (geoGroupInstance)
		{
			checkForManagerAndTerritory(geoGroupInstance)
			try {
				geoGroupInstance.delete(flush: true)
				render "success"
			}
			catch (org.springframework.dao.DataIntegrityViolationException e) {
				render "${message(code: 'default.not.deleted.message', args: [message(code: 'geo.label', default: 'Geo'), name])}"
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'geo.label', default: 'Geo'), name])}"
			redirect(action: "list")
		}
	}
	
	public void checkForManagerAndTerritory(GeoGroup geoGroupInstance)
	{
		def geosId = []
		for(User manager : geoGroupInstance?.generalManagers)
		{
			geoGroupInstance.removeFromGeneralManagers(manager)
		}
		for(Geo territory : geoGroupInstance?.geos)
		{
			geosId.add(territory.id)
			//geoGroupInstance.removeFromGeos(territory)
		}
		for(def Id : geosId)
		{
			geoGroupInstance.removeFromGeos(Geo.get(Id.toLong()))
		}
		geoGroupInstance.save()
	}
	
	boolean isPermitted(String action)
	{
		boolean permit = false
		if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("SALES PRESIDENT"))
		{
			permit = true
		}
		else
		{
			if(SecurityUtils.subject.hasRole("GENERAL MANAGER"))
			{
				if(action == "show" || action == "edit")
					{permit = true}
			}
		}
		return permit
	}
	
}

