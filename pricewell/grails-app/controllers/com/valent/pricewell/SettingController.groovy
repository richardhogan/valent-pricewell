package com.valent.pricewell

import grails.converters.JSON
import org.springframework.web.multipart.MultipartFile;
import org.apache.shiro.SecurityUtils

class SettingController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

	def sowIntroduction
	def salesCatalogService
	def sowSupportParameter
	def fileUploadService
    def index = {
        redirect(action: "list", params: params)
    }
	
	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}
	
	def sowSettings = 
	{
		def map = [:]
		for(Setting s: Setting.list()){
			map[s.name] = s.value
		}
		
		[map:map]
	}
	
	def importSOWTemplate = 
	{
		Geo geoInstance = Geo.get(params.id.toLong())
		render(view: "importSOW", model: [geoInstance: geoInstance])
	}
	
	def saveimportedSOW = 
	{
		def map = [:]
		Geo geoInstance = Geo.get(params.id.toLong())
		
		def file = request.getFile('file')
		
		def fileName = geoInstance?.name?.toString()?.toLowerCase().replaceAll(" ", "").replaceAll("[-+^,.!@#\$]*", "") + "SOW.docx"
		def destinationDirectory = "SOWFiles"
		
		def result = fileUploadService.uploadFile(geoInstance, file, fileName, destinationDirectory)
		//file.transferTo(new File('G:/my/i.docx'))
		map.put("result", result)
		map.put("id", geoInstance?.id)
		render map as JSON
	}
	
	def SOWTemplates = {
		def territoryList = new ArrayList()
		territoryList = salesCatalogService.findUserTerritories()
		
		def territoryInstance = Geo.get(params.territoryId)
		def definedTerritories = [], undefinedTerritories = []
		
		for(Geo territory in territoryList)
		{
			boolean isFile = false
			if(territory.sowFile?.filePath != null && territory.sowFile ?.filePath != "")
			{
				def filePath = territory.sowFile?.filePath + "\\" + territory.sowFile?.name
				filePath = filePath.replaceAll('\\\\', '/')
				isFile = fileUploadService.isFileExist(filePath)
			}
			if(isFile)
			{
				definedTerritories.add(territory)
			}
			else
			{
				undefinedTerritories.add(territory)
			}
		}
		
		render(view: "SOWTemplates", model: [territoryInstance: territoryInstance, definedTerritories: definedTerritories, undefinedTerritories: undefinedTerritories])
	}
	
	def getTerritorySOWTemplate = {
		def geoInstance = Geo.get(params.territoryId)
		def ssptype = SowSupportParameter.get(params.type)
		if (!geoInstance) {
			//flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'setting.label', default: 'Setting'), params.id])}"
			//redirect(action: "list")
			render ""
		}
		else
		{
			def content = ""
			boolean isFile = false
			if(geoInstance.sowFile?.filePath != null && geoInstance.sowFile ?.filePath != "")
			{
				def filePath = geoInstance.sowFile?.filePath + "\\" + geoInstance.sowFile?.name
				filePath = filePath.replaceAll('\\\\', '/')
				isFile = fileUploadService.isFileExist(filePath)
			}
			//ReadFile fileContent = new ReadFile()
			//content = fileContent.main("")
			def sowIntroductionInstanceList = new ArrayList();
			def sowIntroductionInstance = new SowIntroduction();
			System.out.println("In getTerritorySOWTemplate "+geoInstance.id+" Parameter "+params.territoryId)
			
			sowIntroductionInstanceList = sowIntroductionInstance.findAll("FROM SowIntroduction s WHERE s.geo.id = :gid ", [gid:geoInstance.id]);
			
			def sowSupportParameterInstanceList = new ArrayList();
			def sowSupportParameterInstance = new SowSupportParameter();
			
			sowSupportParameterInstanceList = sowSupportParameterInstance.findAll("FROM SowSupportParameter ssp WHERE ssp.geo.id = :gid  AND ssp.type = :type",[gid:geoInstance.id,type:'PROJECTPARAMS']);

			render(template: "territorySOWTemplate", model: [sowSupportParameterInstanceList: sowSupportParameterInstanceList,sowSupportParameterInstanceTotal: sowSupportParameterInstanceList.size(),sowIntroductionInstanceList: sowIntroductionInstanceList,sowIntroductionInstanceTotal: sowIntroductionInstanceList.size(),geoInstance: geoInstance, content: content, isFile: isFile])
			//render(template: "territorySOWTemplate", model: [geoInstance: geoInstance, content: content, isFile: isFile])
		}
		
	}
	
	def downloadSOWPreview = {
		def geoInstance = Geo.get(params.id)
		if (!geoInstance) {
			println "sorry not downloaded..."
			render ""
		}
		else
		{
			def filePath = geoInstance?.sowFile?.filePath + "\\" + geoInstance?.sowFile?.name
			filePath = filePath.replaceAll('\\\\', '/').replaceAll("&", "%26")//+ "/" + geoInstance?.sowFile?.name
			
			//downloadSOWFile(filePath)
			redirect(controller: "downloadFile", action: "downloadDocumentFile", params: [filePath: filePath])
			
		}
	}
	
	def settings = 
	{
		for(EmailSetting es in EmailSetting.list())
		{
			if(es.secret == null)
			{
				es.secret = "false"
				es.save()
			}
		}
		def map = [:]
		for(Setting s: Setting.list()){
			map[s.name] = s.value
		}	
		
		def emailSettingList = []
		emailSettingList = EmailSetting.findAll("FROM EmailSetting es")
		
		CompanyInformation companyInformationInstance
		if(CompanyInformation.list().size()!=0)
		{
			for(CompanyInformation ci in CompanyInformation.list())
			{
				companyInformationInstance = ci
			}
			
		}
		
		def stagingInstanceList = []
		stagingInstanceList = Staging.findAll("FROM Staging st WHERE st.entity = 'SERVICE' ")
		session["stagingType"] = "service"
		[map: map, emailSettings: emailSettingList, companyInformationInstance: companyInformationInstance, stagingInstanceList: stagingInstanceList, title: "Service Staging List"] 
	}
	
	/*def sowSettings = {
		def map = [:]
		for(Setting s: Setting.list()){
			map[s.name] = s.value
		}
		println "hi"
		render(template: "settings", model: [map: map])
	}*/
	
	def saveSettings = {
		def map = [:]
		for(Setting s: Setting.list()){
			map[s.name] = s
		}
		if(params.sowLabel){
			Setting s = map["sowLabel"];
			s.value = params.sowLabel;
			s.save(flush: true) 
		}
		
		if(params.sowTemplate){
			Setting s = map["sowTemplate"];
			s.value = params.sowTemplate;
			s.save(flush: true)
		}
		
		if(params.services){
			Setting s = map["services"];
			s.value = params.services;
			s.save(flush: true)
		}
		
		if(params.terms){
			Setting s = map["terms"];
			s.value = params.terms;
			s.save(flush: true)
		}
		
		if(params.billing_terms){
			Setting s = map["billing_terms"];
			s.value = params.billing_terms;
			s.save(flush: true)
		}
		
		if(params.signature_block){
			Setting s = map["signature_block"];
			s.value = params.signature_block;
			s.save(flush: true)
		}
		
		if(params.expense_amount){
			Setting s = map["expense_amount"];
			s.value = params.expense_amount;
			s.save(flush: true)
		}
		
		if(params.expense_desciption){
			Setting s = map["expense_desciption"];
			s.value = params.expense_desciption;
			s.save(flush: true)
		}
		flash.message = "Setting saved successfully"
		redirect(action: "sowSettings")
		//render "success"
	}

	
	def territorySettings = 
	{
		[params: params]	
	}
	
	def settingsetup = 
	{
		def territoryList = new ArrayList()
		territoryList = salesCatalogService.findUserTerritories()
		
		def territoryInstance = Geo.get(params.territoryId)
		def definedTerritories = [], undefinedTerritories = []
		
		for(Geo geo in territoryList)
		{
			if(geo.sowLabel != null && geo.sowLabel!="")
			{
				definedTerritories.add(geo)
			}
			else
			{
				undefinedTerritories.add(geo)
			}
		}
		
		render(template: "settingsetup", model: [territoryInstance: territoryInstance, definedTerritories: definedTerritories, undefinedTerritories: undefinedTerritories])
	}
	
	def getTerritorySetting = 
	{
		def geoInstance = Geo.get(params.territoryId)
		if (!geoInstance) {
            //flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'setting.label', default: 'Setting'), params.id])}"
            //redirect(action: "list")
			render ""
        }
        else {
			if(geoInstance.sowLabel != null && geoInstance.sowLabel != "")
			{
				if(params.source == "setup" || params.source == "firstsetup")
				{
					render(template: "territorysetup", model: [geoInstance: geoInstance, sowLabel: geoInstance?.sowLabel, sowTemplate: geoInstance?.sowTemplate, terms: geoInstance?.terms, billing_terms: geoInstance?.billing_terms, signature_block: geoInstance?.signature_block])
				}else
				{
					render(template: "territorySettings", model: [geoInstance: geoInstance, sowLabel: geoInstance?.sowLabel, sowTemplate: geoInstance?.sowTemplate, terms: geoInstance?.terms, billing_terms: geoInstance?.billing_terms, signature_block: geoInstance?.signature_block])
				}
				return
			}
			else{
				def map = [:]
				for(Setting s: Setting.list()){
					map[s.name] = s.value
				}
				if(params.source == "setup" || params.source == "firstsetup")
				{
					render(template: "territorysetup", model: [geoInstance: geoInstance, sowLabel: map["sowLabel"], sowTemplate: map["sowTemplate"], terms: map["terms"], billing_terms: map["billing_terms"], signature_block: map["signature_block"], source: "globle"])
				}else
				{
					render(template: "territorySettings", model: [geoInstance: geoInstance, sowLabel: map["sowLabel"], sowTemplate: map["sowTemplate"], terms: map["terms"], billing_terms: map["billing_terms"], signature_block: map["signature_block"], source: "globle"])	
				}
				return
			}
            
        }
	}
	
	
    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [settingInstanceList: Setting.list(params), settingInstanceTotal: Setting.count()]
    }

    def create = {
        def settingInstance = new Setting()
        settingInstance.properties = params
        return [settingInstance: settingInstance]
    }

    def save = {
        def settingInstance = new Setting(params)
        if (settingInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'setting.label', default: 'Setting'), settingInstance.id])}"
            redirect(action: "show", id: settingInstance.id)
        }
        else {
            render(view: "create", model: [settingInstance: settingInstance])
        }
    }

    def show = {
        def settingInstance = Setting.get(params.id)
        if (!settingInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'setting.label', default: 'Setting'), params.id])}"
            redirect(action: "list")
        }
        else {
            [settingInstance: settingInstance]
        }
    }

    def edit = {
        def settingInstance = Setting.get(params.id)
        if (!settingInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'setting.label', default: 'Setting'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [settingInstance: settingInstance]
        }
    }

    def update = {
        def settingInstance = Setting.get(params.id)
        if (settingInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (settingInstance.version > version) {
                    
                    settingInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'setting.label', default: 'Setting')] as Object[], "Another user has updated this Setting while you were editing")
                    render(view: "edit", model: [settingInstance: settingInstance])
                    return
                }
            }
            settingInstance.properties = params
            if (!settingInstance.hasErrors() && settingInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'setting.label', default: 'Setting'), settingInstance.id])}"
                redirect(action: "show", id: settingInstance.id)
            }
            else {
                render(view: "edit", model: [settingInstance: settingInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'setting.label', default: 'Setting'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def settingInstance = Setting.get(params.id)
        if (settingInstance) {
            try {
                settingInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'setting.label', default: 'Setting'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'setting.label', default: 'Setting'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'setting.label', default: 'Setting'), params.id])}"
            redirect(action: "list")
        }
    }
}
