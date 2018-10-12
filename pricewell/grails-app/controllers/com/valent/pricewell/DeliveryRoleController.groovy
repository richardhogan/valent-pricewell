package com.valent.pricewell

import org.apache.shiro.SecurityUtils

class DeliveryRoleController {

    static allowedMethods = [save: "POST", update: "POST"]

	def sendMailService
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
		if(params.source == "setup" || params.source == "firstsetup")
		{
			def source = (params.source == "firstsetup")?"firstsetup":"setup"
			render(template: "listsetup", model :[deliveryRoleInstanceList: DeliveryRole.list(), source: source, deliveryRoleInstanceTotal: DeliveryRole.count(),
													createPermission: SecurityUtils.subject.isPermitted("deliveryRole:create")])
		}
		else
        	[deliveryRoleInstanceList: DeliveryRole.list(), deliveryRoleInstanceTotal: DeliveryRole.count(),
				createPermission: SecurityUtils.subject.isPermitted("deliveryRole:create")]
    }
	
	def listsetup = {
		redirect(action: "list", params: params)
	}
	
	public boolean isDeliveryRoleAvailable(def name)
	{
		
			def deliveryRoles = DeliveryRole.findAllByName(name)
			if (deliveryRoles != null && deliveryRoles.size() > 0)
			{
			   return true
			  //response.status = 500
			}
			else {
				return false
			}
		
	  }
	def isDeliveryRoleDefined =
	{
		if(DeliveryRole.list().size() > 0)
		{
			render "true"
		}
		else
		{
			render "false"
		}
	}

	def requestForUndefinedTerritories = {
		def deliveryRoleInstance = DeliveryRole.get(params.deliveryRoleId.toLong())	
		def serviceInstance = Service.get(params.serviceId.toLong())
		render(template: "requestToDefineTerritories", model: [deliveryRoleInstance: deliveryRoleInstance, serviceInstance: serviceInstance])
	}
	
	def sendRequest = {
		println params
		def map = [:]
		def deliveryRoleInstance = DeliveryRole.get(params.deliveryRoleId)
		def serviceInstance = Service.get(params.serviceId)
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
		
		map = new NotificationGenerator(g).sendRequestToDefineRateCostForTerritories(deliveryRoleInstance, serviceInstance, checkedGeos);
		
		sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/deliveryRole/show/"+deliveryRoleInstance.id)
		render "success"
	}
	
    def create = {
        def deliveryRoleInstance = new DeliveryRole()
        deliveryRoleInstance.properties = params
        if(params.source == "setup" || params.source == "firstsetup")
		{
			def source = (params.source == "firstsetup")?"firstsetup":"setup"
			render(template: "createsetup", model: [deliveryRoleInstance: deliveryRoleInstance, source: source])
		}
		else
			return [deliveryRoleInstance: deliveryRoleInstance]
    }

	def createsetup = {
		redirect(action:"create", params: params)
	}
	
	def getName = {
		def deliveryRoleInstance = DeliveryRole.get(params.id)
		render deliveryRoleInstance.name
	}
	
    def save = {
        def deliveryRoleInstance = new DeliveryRole(params)
		if(isDeliveryRoleAvailable(params.name))
		{
			render "DeliveryRole_Available"
		}
		else{
			if (deliveryRoleInstance.save(flush: true))
			{
				if(params.source == "setup" || params.source == "firstsetup"){
					render "success"
				} else{
					flash.message = "${message(code: 'default.created.message', args: [message(code: 'deliveryRole.label', default: 'DeliveryRole'), deliveryRoleInstance.name])}"
					//redirect(action: "show", id: deliveryRoleInstance.id)
					render "success"
				}
			}
			else {
				if(params.source == "setup" || params.source == "firstsetup"){
					render generateAJAXError(deliveryRoleInstance);
				}else{
					render(view: "create", model: [deliveryRoleInstance: deliveryRoleInstance])
				}
			}
		}
        
    }

    def show = {
        def deliveryRoleInstance = DeliveryRole.get(params.id)
        if (!deliveryRoleInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'deliveryRole.label', default: 'DeliveryRole'), params.id])}"
            redirect(action: "list")
        }
        else {
			def message = ""
			if(params.notificationId)
			{
				def note = Notification.get(params.notificationId)
				note.active = false
				note.save(flush:true)
				message = note.message
			}
			def relationDeliveryGeoList =  deliveryRoleInstance?.listRateCostsPerGeos(null)
			 
			if(params.source == "setup" || params.source == "firstsetup")
			{
				def source = (params.source == "firstsetup")?"firstsetup":"setup"
				render(template: "showsetup", model: [deliveryRoleInstance: deliveryRoleInstance, source: source, relationDeliveryGeoList: relationDeliveryGeoList,
														message: message, createPermission: SecurityUtils.subject.isPermitted("deliveryRole:create"), 
														updatePermission: SecurityUtils.subject.isPermitted("deliveryRole:create")])
			}
			else
				[deliveryRoleInstance: deliveryRoleInstance, relationDeliveryGeoList: relationDeliveryGeoList, message: message,
					createPermission: SecurityUtils.subject.isPermitted("deliveryRole:create"), 
					updatePermission: SecurityUtils.subject.isPermitted("deliveryRole:create")]
        }
    }
	
	def showsetup = {
		redirect(action:"show", params: params)
    }

    def edit = {
        def deliveryRoleInstance = DeliveryRole.get(params.id)
        if (!deliveryRoleInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'deliveryRole.label', default: 'DeliveryRole'), params.id])}"
            redirect(action: "list")
        }
        else {
			if(params.source == "setup" || params.source == "firstsetup")
			{
				def source = (params.source == "firstsetup")?"firstsetup":"setup"
				render(template: "editsetup", model: [deliveryRoleInstance: deliveryRoleInstance, source: source]);
			}
			else
            	return [deliveryRoleInstance: deliveryRoleInstance]
        }
    }

	def editsetup = {
		redirect(action:"edit", params: params)
	}
	
    def update = {
		def deliveryRoleInstance = DeliveryRole.get(params.id)
        if (deliveryRoleInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (deliveryRoleInstance.version > version) {
                    
                    deliveryRoleInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'deliveryRole.label', default: 'DeliveryRole')] as Object[], "Another user has updated this DeliveryRole while you were editing")
                    render(view: "edit", model: [deliveryRoleInstance: deliveryRoleInstance])
                    return
                }
            }
			
			def oldName = deliveryRoleInstance?.name
			boolean deliveryRoleAvail = false
			if(params.name.toLowerCase() != oldName.toLowerCase())
			{
				if(isDeliveryRoleAvailable(params.name))
				{
					//render "Portfolio_Available"
					deliveryRoleAvail = true
				}
			}
			
			if(deliveryRoleAvail)
			{
				render "DeliveryRole_Available"
			}
			else
			{
	            deliveryRoleInstance.properties = params
	            if (!deliveryRoleInstance.hasErrors() && deliveryRoleInstance.save(flush: true)) 
				{
					if(params.source == "setup" || params.source == "firstsetup"){
						render "success"
					} else{
		                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'deliveryRole.label', default: 'DeliveryRole'), deliveryRoleInstance.name])}"
		                //redirect(action: "show", id: deliveryRoleInstance.id)
						render "success"
					}
	            }
	            else {
					if(params.source == "setup" || params.source == "firstsetup"){
						render generateAJAXError(deliveryRoleInstance);
					}else{
	                	render(view: "edit", model: [deliveryRoleInstance: deliveryRoleInstance])
					}
	            }
			}
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'deliveryRole.label', default: 'DeliveryRole'), params.id])}"
            redirect(action: "list")
        }
    }

	public List getServiceProfilesUsedByDeliveryRole(DeliveryRole deliveryRole)
	{
		boolean isDeliveryRoleUsed = false;
		def serviceList = Service.findAll()
		Set serviceProfileList = new HashSet();
		
		
		for(ServiceProfile serviceProfile : ServiceProfile.list())
		{
			for(ServiceDeliverable sDeliverable : serviceProfile?.customerDeliverables)
			{
				for(ServiceActivity sActivity : sDeliverable?.serviceActivities)
				{
					for(DeliveryRole dRole : sActivity?.rolesRequired)
					{
						if(deliveryRole?.id == dRole?.id)
						{
							serviceProfileList.add(serviceProfile)
						}
					}
				}
			}
		}
	 
	 //println isDeliveryRoleUsed
	 return serviceProfileList.toList()
	 
	}
   
	def deletesetup = {
		def deliveryRoleInstance = DeliveryRole.get(params.id)
		def name =  deliveryRoleInstance.name
		
		
		if (deliveryRoleInstance) 
		{
			List serviceProfileList = getServiceProfilesUsedByDeliveryRole(deliveryRoleInstance)
			if(serviceProfileList.size() == 0)
			{
				try {
					deliveryRoleInstance.delete(flush: true)
					render "success"
				}
				catch (org.springframework.dao.DataIntegrityViolationException e) {
					flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'deliveryRole.label', default: 'DeliveryRole'), name])}"
					redirect(action: "show", id: params.id)
				}
			}
			else {
				render "can_not_delete_delivery_role"
			}
			
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'deliveryRole.label', default: 'DeliveryRole'), params.id])}"
            redirect(action: "list")
		}
	}
	
	def reportsetup = {
		
		def deliveryRoleInstance = DeliveryRole.get(params.id)
		List serviceProfileList = new ArrayList()
		
		if (deliveryRoleInstance) 
		{
			serviceProfileList = getServiceProfilesUsedByDeliveryRole(deliveryRoleInstance)
		}
		
		render(template: "deletereport", model: [deliveryRoleInstance: deliveryRoleInstance, serviceProfileList: serviceProfileList]);
	}
	
	
	def getDeliveryRoleName = {
		def deliveryRoleInstance = DeliveryRole.get(params.id)
		def deliveryRoleName = ""
		if (deliveryRoleInstance)
		{
			deliveryRoleName = deliveryRoleInstance.name
		}
		println deliveryRoleName
		render deliveryRoleName
		
	}
    def delete = {
        def deliveryRoleInstance = DeliveryRole.get(params.id)
		def name =  deliveryRoleInstance.name
        if (deliveryRoleInstance) {
            try {
                deliveryRoleInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'deliveryRole.label', default: 'DeliveryRole'), name])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'deliveryRole.label', default: 'DeliveryRole'), name])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'deliveryRole.label', default: 'DeliveryRole'), params.id])}"
            redirect(action: "list")
        }
    }
}
