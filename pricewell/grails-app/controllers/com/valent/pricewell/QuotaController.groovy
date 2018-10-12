package com.valent.pricewell
import grails.converters.JSON
import org.apache.shiro.SecurityUtils
class QuotaController {

	def serviceCatalogService
	def salesCatalogService
	def dateService
	def opportunityService
	def sendMailService
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
		User user = User.get(new Long(SecurityUtils.subject.principal))
		def quotaInstanceList = new ArrayList(), tmpList = new ArrayList()
		
		tmpList = salesCatalogService.getUserQuota(user)
				
		def range = (params.range != "" && params.range != null)?params.range:"This quarter"
		
		Map dateMap = dateService.getTimespanForQuota(range)
		
		for(Quota qu : tmpList)
		{
			if(dateService.compareDates(qu.fromDate, dateMap['fromDate']) >= 0 && dateService.compareDates(qu.toDate, dateMap['toDate']) <= 0)
					quotaInstanceList.add(qu)
		}
		
		def quaterList = salesCatalogService.createQuaterList()
		if(params.source == "setup" || params.source == "firstsetup")
		{
			def source = (params.source == "firstsetup")?"firstsetup":"setup"
			
			render(template: "listsetup", model :[quotaInstanceList: quotaInstanceList, range: range, quaterList: quaterList, quotaInstanceTotal: quotaInstanceList.size(), source: source, allowCreate: isPermitted("create"), allowEdit: isPermitted("edit"), allowDelete: isPermitted("delete"), allowShow: isPermitted("show")])//SecurityUtils.subject.isPermitted("geoGroup:create")]
		}
		else
			[quotaInstanceList: quotaInstanceList, quotaInstanceTotal: quotaInstanceList.size(), range: range]
			
        
    }
	
	Map filterAssignedAndSubmitedList(List quotaList)
	{
		User user = User.get(new Long(SecurityUtils.subject.principal))
		List myAssigned = new ArrayList(), mySubmitted = new ArrayList()
		
		for(Quota quota : quotaList)
		{
			if(quota?.createdBy?.id == user.id)
			{
				mySubmitted.add(quota)
			}else if(quota?.person?.id == user.id)
			{
				myAssigned.add(quota)
			}
		}
		
		return [myAssigned: myAssigned, mySubmitted: mySubmitted]
	}
	
	def listsetup = {
		redirect(action: "list", params: params)
	}
	
	def getQuotaAssignedVsQuotaAchivementChartData = 
	{
		Map dateMap = dateService.getTimespanForQuota(params.range)
		def territoryInstance = null

		if(params.territoryId != null && params.territoryId != "")
		{
			territoryInstance = Geo.get(params.territoryId.toLong())
		}
		
		Map quotaData = [:]
		if(SecurityUtils.subject.hasRole("SALES MANAGER") || SecurityUtils.subject.hasRole("SALES PERSON"))
			{quotaData = opportunityService.getQuotaAssignedVsQuotaAchivement(dateMap, territoryInstance)}
			
		if(quotaData['Greater'] != "" && quotaData['Greater'] != null)
		{
			if(quotaData['Greater'] == 'assigned')
			{
				render(view: "/reports/quotaAssignedVsQuotaAchivementGraph", model: [quotaData: quotaData])
			}
			else if(quotaData['Greater'] == 'achieved')
			{
				render(view: "/reports/quotaAssignedVsQuotaAchivementGraph2", model: [quotaData: quotaData])
			}
		}
		//render(view: "/reports/quotaAssignedVsQuotaAchivementGraph", model: [quotaData: quotaData])
	}
	
	def getQuotaAssignedVsQuotaAchivementPerPersonChartData =
	{
		Map dateMap = dateService.getTimespanForQuota(params.range)
		def territoryInstance = null
		
		if(params.territoryId != null && params.territoryId != "")
		{
			territoryInstance = Geo.get(params.territoryId.toLong())
		}
				
		Map quotaPerPersons = [:]
			if(SecurityUtils.subject.hasRole("SALES MANAGER"))
				{quotaPerPersons = opportunityService.getQuotaAssignedVsQuotaAchivementPerPersons(dateMap, territoryInstance)}
			
		render(view: "/reports/quotaAssignedVsQuotaAchivementPerPerson", model: [quotaPerPersons: quotaPerPersons])
	}
	
    def create = {
        def quotaInstance = new Quota()
        quotaInstance.properties = params
		def user = User.get(new Long(SecurityUtils.subject.principal))
		/*def territoryList = new ArrayList()
		territoryList = salesCatalogService.findUserTerritories(user)
		def salesPersonList = new ArrayList()
		
		/*for(Geo territory : territoryList)
		{
			for(User person : territory?.salesPersons)
			{
				salesPersonList.add(person)
			}
		}*/
		//salesPersonList = serviceCatalogService.findUsersByRole("SALES PERSON")
		
		def quaterList = salesCatalogService.createQuaterList()
				
		if(params.source == "setup" || params.source == "firstsetup")
		{
			def source = (params.source == "firstsetup")?"firstsetup":"setup"
			render(template: "createsetup", model: [quotaInstance: quotaInstance, quaterList: quaterList, source: source])//, salesPersonList: salesPersonList
		}
		else
			return [quotaInstance: quotaInstance]//, salesPersonList: salesPersonList
			
    }

	def createsetup = {
		redirect(action:"create", params: params)
	}
	
	public boolean isQuotaAvailableInAssignedUser(Map params)
	{
		def assignedToId = params.get("person.id")
		User person = User.get(assignedToId.toLong())
		//Geo assignedTerritory = Geo.get(params.territoryId.toLong())
		
		def quotaList = new ArrayList(), tmpList = new ArrayList()
		tmpList = Quota.findAll("FROM Quota quota WHERE quota.person.id=:pid", [pid: person.id])//, tid: assignedTerritory?.id])// AND quota.territory.id = :tid
		
		def range = (params.timespan != "" && params.timespan != null)?params.timespan:"This quarter"
		
		Map dateMap = dateService.getTimespanForQuota(range)
		
		for(Quota qu : tmpList)
		{
			if(dateService.compareQuotasTwoDates(qu.fromDate, dateMap['fromDate']) == 0 && dateService.compareQuotasTwoDates(qu.toDate, dateMap['toDate']) == 0)
					quotaList.add(qu)
		}
		
		if(quotaList.size() > 0)
		{
			return true
		}
		
		return false
	}
	
	public Map isInRangeOfCreaterForCreateQuota(Map params)
	{
		Geo assignedTerritory = Geo.get(params.territoryId.toLong())
		User user = User.get(new Long(SecurityUtils.subject.principal))
		BigDecimal assignedAmount = new BigDecimal(params.amount)
		String message = ""
		boolean isInRange = false
		def range = (params.timespan != "" && params.timespan != null)?params.timespan:"This quarter"
		Map dateMap = dateService.getTimespanForQuota(range)
		BigDecimal totalAssigned = calculateTotalAssigned(user, assignedTerritory, dateMap)
		BigDecimal totalSubmitted = calculateTotalSubmitted(user, assignedTerritory, dateMap)
		
		BigDecimal totalLeft = totalAssigned - totalSubmitted
		if(totalAssigned == 0)
		{
			isInRange = false
			message = "You have no quota assigned for the selected time duration. You can not create quota. Please contact your higher level sales user."
		}
		else if(totalLeft >= assignedAmount)
		{
			isInRange = true
		}
		else
		{
			isInRange = false
			message = "You have left "+totalLeft+" "+assignedTerritory?.currency+" to assign. Please correct amount in this new Quota."
		}
		
		return [isInRange: isInRange, message: message]		
	}
	
	public Map isInRangeOfCreaterForEditQuota(Quota quotaInstance, Map params)
	{
		Geo assignedTerritory = Geo.get(quotaInstance?.territory?.id)
		User user = User.get(quotaInstance?.createdBy?.id)
		BigDecimal assignedAmount = new BigDecimal(params.amount.replaceAll(",", ""))
		String message = ""
		boolean isInRange = false
		
		Map dateMap = ['fromDate': quotaInstance?.fromDate, 'toDate': quotaInstance?.toDate]
		BigDecimal totalAssigned = calculateTotalAssigned(user, assignedTerritory, dateMap)
		BigDecimal totalSubmitted = calculateTotalSubmitted(user, assignedTerritory, dateMap) - quotaInstance?.amount
		
		BigDecimal totalLeft = totalAssigned - totalSubmitted
		if(totalAssigned == 0)
		{
			isInRange = false
			message = "You have no quota assigned for the specified time duration. You can not edit quota. Please contact your higher level sales user."
		}
		else if(totalLeft >= assignedAmount)
		{
			isInRange = true
		}
		else
		{
			isInRange = false
			message = "You have left "+totalLeft+" "+assignedTerritory?.currency+" to assign. Please correct amount in this Quota."
		}
		
		return [isInRange: isInRange, message: message]
	}
	
	public BigDecimal calculateTotalAssigned(User user, Geo territory, Map dateMap)
	{
		BigDecimal totalAssigned = new BigDecimal(0)
		def quotaList = new ArrayList(), tmpList = new ArrayList()
		tmpList = Quota.findAll("FROM Quota quota WHERE quota.person.id=:uid AND quota.territory.id = :tid", [uid: user.id, tid: territory?.id])
		
		
		for(Quota qu : tmpList)
		{
			if(dateService.compareQuotasTwoDates(qu.fromDate, dateMap['fromDate']) <= 0 && dateService.compareQuotasTwoDates(qu.toDate, dateMap['toDate']) >= 0)
			{
				totalAssigned = totalAssigned + qu?.amount
			}
		}
		
		return totalAssigned
	}
	
	public BigDecimal calculateTotalSubmitted(User user, Geo territory, Map dateMap)
	{
		BigDecimal totalSubmitted = new BigDecimal(0)
		def quotaList = new ArrayList(), tmpList = new ArrayList()
		tmpList = Quota.findAll("FROM Quota quota WHERE quota.createdBy.id=:uid AND quota.territory.id = :tid", [uid: user.id, tid: territory?.id])
		
		for(Quota qu : tmpList)
		{
			if(dateService.compareQuotasTwoDates(qu.fromDate, dateMap['fromDate']) <= 0 && dateService.compareQuotasTwoDates(qu.toDate, dateMap['toDate']) >= 0)
			{
				totalSubmitted = totalSubmitted + qu?.amount
			}
		}
		
		return totalSubmitted
	}
	
    def save = {
		
		boolean isQuotaAvailable = isQuotaAvailableInAssignedUser(params)//check if quota is available in specified date range
		boolean isInRange = true
		Map checkRangeMap = [:];
		/*if(!SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") && !SecurityUtils.subject.hasRole("SALES PRESIDENT"))
		{
			checkRangeMap = isInRangeOfCreaterForCreateQuota(params)//check amount is in range of assigned amount of creater
			isInRange = checkRangeMap['isInRange']
		}
		*/
		
		Map resultMap = new HashMap()
		if(isQuotaAvailable)
		{
			resultMap['result'] = "quotaAvailable"
			resultMap['message'] = "Quota available for selected time duration for selected sales user. Please change time duration."
			render resultMap as JSON
		}
		/*else if(!isInRange)
		{
			resultMap['result'] = "notInRange"
			resultMap['message'] = checkRangeMap['message']
			render resultMap as JSON
		}*/
		else
		{
			def quotaInstance = new Quota(params)
			Map dates = dateService.getTimespanForQuota(params.timespan)
			//quotaInstance.territory = Geo.get(params.territoryId.toLong())
			quotaInstance.fromDate = dates["fromDate"]
			quotaInstance.toDate = dates["toDate"]
			quotaInstance.createdBy = User.get(new Long(SecurityUtils.subject.principal))
			def map = [:]
			if (quotaInstance.save(flush: true))
			{
				map = new NotificationGenerator(g).sendQuotaAssignedToSalesUserNotification(quotaInstance);
				sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/quota/show/"+quotaInstance.id)
				
				if(params.source == "setup" || params.source == "firstsetup"){
					resultMap['result'] = "success"
					render resultMap as JSON
				} else{
					flash.message = "${message(code: 'default.created.message', args: [message(code: 'quota.label', default: 'Quota'), quotaInstance.id])}"
					redirect(action: "show", id: quotaInstance.id)
				}
			}
			else {
				if(params.source == "setup" || params.source == "firstsetup"){
					//Display error related messages.
				}else{
					render(view: "create", model: [quotaInstance: quotaInstance])
				}
			}
		}
        
    }

    def show = {
        def quotaInstance = Quota.get(params.id)
        if (!quotaInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'quota.label', default: 'Quota'), params.id])}"
            redirect(action: "list")
        }
        else 
		{
			if(params.notificationId)
			{
				def note = Notification.get(params.notificationId)
				note.active = false
				note.save(flush:true)
			}
            [quotaInstance: quotaInstance]
        }
    }

    def edit = {
        Quota quotaInstance = Quota.get(params.id)
        if (!quotaInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'quota.label', default: 'Quota'), params.id])}"
            redirect(action: "list")
        }
        else 
		{			
			//User assignedUser = User.get(quotaInstance?.person?.id)
			//List territoryList = salesCatalogService.findUserTerritories(assignedUser)
			if(params.source == "setup" || params.source == "firstsetup")
			{
				def source = (params.source == "firstsetup")?"firstsetup":"setup"
				render(template: "editSetup", model: [quotaInstance: quotaInstance, source: source])//, territoryList: territoryList]);
			}
			else
				return [quotaInstance: quotaInstance]
        }
    }

	def editsetup = {
		redirect(action: "edit", params: params)
	}
	
    def update = {
        def quotaInstance = Quota.get(params.id)
		boolean isChanged = false
        if (quotaInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (quotaInstance.version > version) {
                    
                    quotaInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'quota.label', default: 'Quota')] as Object[], "Another user has updated this Quota while you were editing")
                    render(view: "edit", model: [quotaInstance: quotaInstance])
                    return
                }
            }
			
			Map resultMap = new HashMap()
			/*if(params.territoryId != null || params.territoryId != "")
			{
				Geo territory = Geo.get(params.territoryId?.toLong())
				if(quotaInstance?.territory?.id != territory?.id)
				{
					isChanged = true
					quotaInstance.territory = territory
					quotaInstance?.currency = params.currency
				}
			}*/
			
			//quotaInstance.properties = params
			BigDecimal amount = new BigDecimal(params.amount.replaceAll(",", ""))
			boolean isInRange = true
			if(quotaInstance.amount != amount)
			{
				isChanged = true
				/*if(amount > quotaInstance?.amount)
				{
					Map checkRangeMap = isInRangeOfCreaterForEditQuota(quotaInstance, params)//check that creator having limit to assign more quota
					isInRange = checkRangeMap['isInRange']
					if(!isInRange)
					{
						resultMap['result'] = "notInRange"
						resultMap['message'] = checkRangeMap['message']
					}
					else
					{
						//isChanged = true
						quotaInstance.amount = amount
					}
				}
				else
				{*/
					
					quotaInstance.amount = amount
				//}
			}
			
			if(!isChanged)
			{
				if(params.source == "setup" || params.source == "firstsetup"){
					resultMap['result'] = "noChanges"
					render resultMap as JSON
				} else{
					flash.message = "${message(code: 'default.updated.message', args: [message(code: 'quota.label', default: 'Quota'), quotaInstance.id])}"
					redirect(action: "show", id: quotaInstance.id)
				}
			}
			/*else if(!isInRange)
			{
				render resultMap as JSON
			}*/
			else
			{
				def map = new NotificationGenerator(g).sendQuotaModifiedToSalesUserNotification(quotaInstance);
				sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/quota/show/"+quotaInstance.id)
				
				if (!quotaInstance.hasErrors() && quotaInstance.save(flush: true))
				{
					if(params.source == "setup" || params.source == "firstsetup"){
						resultMap['result'] = "success"
						render resultMap as JSON
					} else{
						flash.message = "${message(code: 'default.updated.message', args: [message(code: 'quota.label', default: 'Quota'), quotaInstance.id])}"
						redirect(action: "show", id: quotaInstance.id)
					}
					
				}
				else {
					if(params.source == "setup" || params.source == "firstsetup"){
						render generateAJAXError(quotaInstance);
					}else{
						render(view: "edit", model: [quotaInstance: quotaInstance])
					}
					
				}
			}
			
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'quota.label', default: 'Quota'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def quotaInstance = Quota.get(params.id)
        if (quotaInstance) {
            try {
                quotaInstance.delete(flush: true)
				
				if(params.source == "setup" || params.source == "firstsetup"){
					render "success"
				}else{
					flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'quota.label', default: 'Quota'), params.id])}"
					redirect(action: "list")
				}
                
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                
				if(params.source == "setup" || params.source == "firstsetup"){
					render "${message(code: 'default.not.deleted.message', args: [message(code: 'quota.label', default: 'Quota'), params.id])}"
				}else{
					flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'quota.label', default: 'Quota'), params.id])}"
                redirect(action: "show", id: params.id)
				}
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'quota.label', default: 'Quota'), params.id])}"
            redirect(action: "list")
        }
    }
	
	def deletesetup =
	{
		def quotaInstance = Quota.get(params.id)
		if (quotaInstance) {
			try {
				quotaInstance.delete(flush: true)
				render "success"				
			}
			catch (org.springframework.dao.DataIntegrityViolationException e) {
				render "${message(code: 'default.not.deleted.message', args: [message(code: 'quota.label', default: 'Quota'), params.id])}"
			}
		}
		else {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'quota.label', default: 'Quota'), params.id])}"
			redirect(action: "list")
		}
		
	}
	
	boolean isPermitted(String action)
	{
		boolean permit = false
		if(SecurityUtils.subject.hasRole('SYSTEM ADMINISTRATOR') || SecurityUtils.subject.hasRole('SALES PRESIDENT') || SecurityUtils.subject.hasRole('GENERAL MANAGER') || SecurityUtils.subject.hasRole("SALES MANAGER"))
		{
			permit = true
		}
		
		return permit
	}
}
