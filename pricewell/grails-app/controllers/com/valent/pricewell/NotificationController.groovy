package com.valent.pricewell
import org.apache.shiro.SecurityUtils
class NotificationController {

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
        [notificationInstanceList: Notification.list(params), notificationInstanceTotal: Notification.count()]
    }

	def myNotifications = 
	{
		def notificationList = []
		def activeNotification = listActiveNotification()
		boolean isActiveAvailable = false
		if(activeNotification?.size() > 0)
		{
			isActiveAvailable = true
		}
		
		/*if(activeNotification?.size() >= 6)
		{
			notificationList = activeNotification
		}
		else
		{
			def user = User.get(new Long(SecurityUtils.subject.principal))
			def notifications = Notification.listUserNotifications(user, "")
			for(int i = 0; i<6; i++)
			{
				if(notifications[i] != null)
				{
					notificationList.add(notifications[i])
				}
			}
		}*/
		
		
		render(view: "notifications", model: [notificationList: activeNotification, isActiveAvailable: isActiveAvailable])
	}
	
	def countActiveNotification =
	{
		def notifications = listActiveNotification()
		
		render notifications?.size()
	}
	public List listActiveNotification()
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def notifications = []
		notifications = Notification.listUserNotifications(user, "active")
		return notifications
	}
	
	def dismissNotifications = {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		
		def ids = []
		if(params.type == "selected")
		{
			String s = params.selectedNotifications
			ids = s.split(" ")
			for(def Id : ids)
			{
				deactiveNotification(Id)
			}
		}
		else if(params.type == "all")
		{
			def notifications = Notification.listUserNotifications(user, "active")
			for(Notification note: notifications)
			{
				deactiveNotification(note.id)
			}
		}
		render "success"
		
		//def notifications = Notification.listUserNotifications(user, "")
		
		//render(view: "notifications", model: [notificationList: notifications])
	}
	
	public deactiveNotification(def notificationId)
	{
		def note = Notification.get(notificationId.toLong())
		note.active = false
		note.save(flush:true)
	}
	
    def create = {
        def notificationInstance = new Notification()
        notificationInstance.properties = params
        return [notificationInstance: notificationInstance]
    }

    def save = {
        def notificationInstance = new Notification(params)
        if (notificationInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'notification.label', default: 'Notification'), notificationInstance.id])}"
            redirect(action: "show", id: notificationInstance.id)
        }
        else {
            render(view: "create", model: [notificationInstance: notificationInstance])
        }
    }

    def show = {
        def notificationInstance = Notification.get(params.id)
        if (!notificationInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'notification.label', default: 'Notification'), params.id])}"
            redirect(action: "list")
        }
        else {
            [notificationInstance: notificationInstance]
        }
    }

    def edit = {
        def notificationInstance = Notification.get(params.id)
        if (!notificationInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'notification.label', default: 'Notification'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [notificationInstance: notificationInstance]
        }
    }

    def update = {
        def notificationInstance = Notification.get(params.id)
        if (notificationInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (notificationInstance.version > version) {
                    
                    notificationInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'notification.label', default: 'Notification')] as Object[], "Another user has updated this Notification while you were editing")
                    render(view: "edit", model: [notificationInstance: notificationInstance])
                    return
                }
            }
            notificationInstance.properties = params
            if (!notificationInstance.hasErrors() && notificationInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'notification.label', default: 'Notification'), notificationInstance.id])}"
                redirect(action: "show", id: notificationInstance.id)
            }
            else {
                render(view: "edit", model: [notificationInstance: notificationInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'notification.label', default: 'Notification'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def notificationInstance = Notification.get(params.id)
        if (notificationInstance) {
            try {
                notificationInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'notification.label', default: 'Notification'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'notification.label', default: 'Notification'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'notification.label', default: 'Notification'), params.id])}"
            redirect(action: "list")
        }
    }
}
