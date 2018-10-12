package com.valent.pricewell

import org.apache.shiro.SecurityUtils
class ActivityRoleTimeController {

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
        if(!params.serviceActivityId)
		{
				flash.message = "service activity id is not valid"
		}
		
		def activity = ServiceActivity.get(params.serviceActivityId)
		
		if(!activity)
		{
			flash.message = "Activity is not valid"
		}
		  
        render(template: "listActivityRoleTime", model:[serviceActivityInstance: activity])
    }
	
	def create = {
		def activityRoleTimeInstance = new ActivityRoleTime()
        activityRoleTimeInstance.properties = params
		def serviceActivityInstance = ServiceActivity.get(params.id)
		def roleList = []
		for(DeliveryRole role : DeliveryRole.list())
		{
			if(!serviceActivityInstance?.rolesRequired?.contains(role))
			{
				roleList.add(role)
			}
		}
		render(template: "create" ,model: [activityRoleTimeInstance: activityRoleTimeInstance, roleList: roleList, serviceActivityId: params.id, serviceActivityInstance: serviceActivityInstance])
	}
	
    def save = {
		if(!params.serviceActivityId)
		{
			flash.message = "Service activity id is not valid"
		}
		
		def activity = ServiceActivity.get(params.serviceActivityId)
		
		if(!activity)
		{
			flash.message = "Activity is not valid"
		}
		
        def activityRoleTimeInstance = new ActivityRoleTime()
		activityRoleTimeInstance.properties = params
		
        if (activity.addToRolesEstimatedTime(activityRoleTimeInstance)) {
			/*activity.save(flush:true)
			activity.estimatedTimeInHoursFlat+=new BigDecimal(params?.estimatedTimeInHoursFlat)
			activity.estimatedTimeInHoursPerBaseUnits+=new BigDecimal(params?.estimatedTimeInHoursPerBaseUnits)*/
			
			activity?.addToRolesRequired(activityRoleTimeInstance.role)
			activity.save(flush:true)
			calculateActivityRoleTime(activity)
			
			flash.message = "${message(code: 'default.created.message.activityRoleTime', args: [activityRoleTimeInstance.role.name, activity.name])}"
			//render(template: "list", model:[serviceActivityInstance: activity])
			//redirect(action: "showActivity", controller: "serviceActivity", id: activity?.id)
			redirect(action: "list", params: [serviceActivityId: activityRoleTimeInstance.serviceActivity?.id])
        }
        else {
            //TODO: redirect properly
        }
    }

	public void calculateActivityRoleTime(ServiceActivity activity)
	{
		activity.rolesRequired = null
		activity.estimatedTimeInHoursFlat = new BigDecimal(0)
		activity.estimatedTimeInHoursPerBaseUnits = new BigDecimal(0)
		for(ActivityRoleTime art : activity?.rolesEstimatedTime)
		{
			activity.estimatedTimeInHoursFlat+=new BigDecimal(art?.estimatedTimeInHoursFlat)
			activity.estimatedTimeInHoursPerBaseUnits+=new BigDecimal(art?.estimatedTimeInHoursPerBaseUnits)
			activity?.addToRolesRequired(art.role)
		}
		activity.save(flush:true)
	}
	
    def show = {
        def activityRoleTimeInstance = ActivityRoleTime.get(params.id)
        if (!activityRoleTimeInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'activityRoleTime.label', default: 'ActivityRoleTime'), params.id])}"
            redirect(action: "list")
        }
        else {
            [activityRoleTimeInstance: activityRoleTimeInstance]
        }
    }

    def edit = {
        def activityRoleTimeInstance = ActivityRoleTime.get(params.id)
        if (!activityRoleTimeInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'activityRoleTime.label', default: 'ActivityRoleTime'), params.id])}"
			//TODO: redirect properly
            return
        }
        else {
            render(template: "edit", model: [activityRoleTimeInstance: activityRoleTimeInstance])
        }
    }

    def update = {
		
		if(!params.serviceActivityId)
		{
			flash.message = "Service activity id is not valid"
		}
		
		def activity = ServiceActivity.get(params.serviceActivityId)
		
		if(!activity)
		{
			flash.message = "Activity is not valid"
		}
		
		/*
		activity.estimatedTimeInHoursFlat+=new BigDecimal(params?.estimatedTimeInHoursFlat)
		activity.estimatedTimeInHoursPerBaseUnits+=new BigDecimal(params?.estimatedTimeInHoursPerBaseUnits)
		*/
		//println params.serviceActivityId
        def activityRoleTimeInstance = ActivityRoleTime.get(params.activityRoleId)
		
		
        if (activityRoleTimeInstance) {
            if (params.activityRoleVersion) {
                def version = params.activityRoleVersion.toLong()
                if (activityRoleTimeInstance.version > version) {
                    
                    activityRoleTimeInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'activityRoleTime.label', default: 'ActivityRoleTime')] as Object[], "Another user has updated this ActivityRoleTime while you were editing")
                    render(template: "edit", model: [activityRoleTimeInstance: activityRoleTimeInstance])
                    return
                }
            }
			/*activity.estimatedTimeInHoursFlat-=new BigDecimal(activityRoleTimeInstance.estimatedTimeInHoursFlat)
			activity.estimatedTimeInHoursPerBaseUnits-=new BigDecimal(activityRoleTimeInstance.estimatedTimeInHoursPerBaseUnits)
			*/
            activityRoleTimeInstance.properties = params
			
			/*activity.estimatedTimeInHoursFlat+=new BigDecimal(activityRoleTimeInstance.estimatedTimeInHoursFlat)
			activity.estimatedTimeInHoursPerBaseUnits+=new BigDecimal(activityRoleTimeInstance.estimatedTimeInHoursPerBaseUnits)*/
			activity.save(flush:true)
			calculateActivityRoleTime(activity)
			
			if (!activityRoleTimeInstance.hasErrors() && activityRoleTimeInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'activityRoleTime.label', default: 'ActivityRoleTime'), activityRoleTimeInstance.id])}"
                redirect(action: "list", params: [serviceActivityId: activityRoleTimeInstance.serviceActivity?.id])
            }
            else {
                render(template: "edit", model: [activityRoleTimeInstance: activityRoleTimeInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'activityRoleTime.label', default: 'ActivityRoleTime'), params.id])}"
            return
        }
    }

    def delete = {
        def activityRoleTimeInstance = ActivityRoleTime.get(params.id)
		def role = activityRoleTimeInstance.role.name
		
		def serviceActivityId = activityRoleTimeInstance.serviceActivity?.id
		
		def activity = ServiceActivity.get(serviceActivityId)
		/*activity.estimatedTimeInHoursFlat-=new BigDecimal(activityRoleTimeInstance?.estimatedTimeInHoursFlat)
		activity.estimatedTimeInHoursPerBaseUnits-=new BigDecimal(activityRoleTimeInstance?.estimatedTimeInHoursPerBaseUnits)
		*/
		
        if (activityRoleTimeInstance) {
            try {
                activityRoleTimeInstance.delete(flush: true)
				calculateActivityRoleTime(activity)
                flash.message = "${message(code: 'default.deleted.message.activityRoleTime', args: [message(code: 'activityRoleTime.label', default: 'ActivityRoleTime'), role, activity.name])}"
                redirect(action: "list", params: [serviceActivityId: serviceActivityId])
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'activityRoleTime.label', default: 'ActivityRoleTime'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'activityRoleTime.label', default: 'ActivityRoleTime'), params.id])}"
        	return
        }
    }
}
