package com.valent.pricewell

import grails.converters.JSON
import org.apache.shiro.SecurityUtils

import org.springframework.dao.DataIntegrityViolationException

class DocumentTemplateController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

	def fileUploadService, salesCatalogService
	
    def index() {
        redirect(action: "list", params: params)
    }
	
	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}
	
	def sowDocumentTemplates()
	{
		def territoryList = new ArrayList()
		territoryList = salesCatalogService.findUserTerritories()
		
		def territoryInstance = Geo.get(params.territoryId)
		def definedTerritories = [], undefinedTerritories = []
		
		for(Geo territory in territoryList)
		{
			/*boolean isFile = false
			if(territory.sowFile?.filePath != null && territory.sowFile ?.filePath != "")
			{
				def filePath = territory.sowFile?.filePath + "\\" + territory.sowFile?.name
				filePath = filePath.replaceAll('\\\\', '/')
				isFile = fileUploadService.isFileExist(filePath)
			}*/
			if(territory?.sowDocumentTemplates?.size() > 0)
			{
				definedTerritories.add(territory)
			}
			else
			{
				undefinedTerritories.add(territory)
			}
		}
		
		render(template: "sowDocumentTemplates", model: [territoryInstance: territoryInstance, definedTerritories: definedTerritories, undefinedTerritories: undefinedTerritories])
	}
	
	def getTerritorySowTemplates()
	{
		def territoryInstance = Geo.get(params.territoryId)
		def ssptype = SowSupportParameter.get(params.type)
		if (!territoryInstance) {
			//flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'setting.label', default: 'Setting'), params.id])}"
			//redirect(action: "list")
			render ""
		}
		else
		{
			def content = ""
			boolean isFile = false
			/*if(territoryInstance.sowFile?.filePath != null && territoryInstance.sowFile ?.filePath != "")
			{
				def filePath = territoryInstance.sowFile?.filePath + "\\" + territoryInstance.sowFile?.name
				filePath = filePath.replaceAll('\\\\', '/')
				isFile = fileUploadService.isFileExist(filePath)
			}*/
			//ReadFile fileContent = new ReadFile()
			//content = fileContent.main("")
			def sowIntroductionInstanceList = new ArrayList();
			sowIntroductionInstanceList = SowIntroduction.findAll("FROM SowIntroduction s WHERE s.geo.id = :gid ", [gid:territoryInstance.id]);
			
			System.out.println("In getTerritorySOWTemplate "+territoryInstance.id+" Parameter "+params.territoryId)
			
			def sowSupportParameterInstanceList = new ArrayList();
			sowSupportParameterInstanceList = SowSupportParameter.findAll("FROM SowSupportParameter ssp WHERE ssp.geo.id = :gid  AND ssp.type = :type", [gid:territoryInstance.id, type:'PROJECTPARAMS']);

			render(template: "territorySowTemplates", model: [sowSupportParameterInstanceList: sowSupportParameterInstanceList, sowSupportParameterInstanceTotal: sowSupportParameterInstanceList.size(), sowIntroductionInstanceList: sowIntroductionInstanceList, sowIntroductionInstanceTotal: sowIntroductionInstanceList.size(), geoInstance: territoryInstance, content: content, isFile: isFile])
			//render(template: "territorySOWTemplate", model: [geoInstance: geoInstance, content: content, isFile: isFile])
		}
	}
	
	def importSowTemplate()
	{
		Geo geoInstance = Geo.get(params.id.toLong())
		render(template: "importSowTemplate", model: [geoInstance: geoInstance])
	}
	
	def saveSowTemplate()
	{
		def map = [:]
		Geo geoInstance = Geo.get(params.id.toLong())
		
		def documentName = params.documentName
		def destinationDirectory = "SOWFiles"
		def file = request.getFile('file')
		
		def result = fileUploadService.uploadDocumentFile(geoInstance, file, documentName, destinationDirectory)
		//file.transferTo(new File('G:/my/i.docx'))
		map.put("result", result)
		map.put("id", geoInstance?.id)
		render map as JSON
	}

	def downloadSowPreview(){
		def documentTemplateInstance = DocumentTemplate.get(params.id)
		
		if (!documentTemplateInstance) {
			println "sorry not downloaded..."
			render ""
		}
		else
		{
			def filePath = documentTemplateInstance?.documentFile?.filePath + "\\" + documentTemplateInstance?.documentFile?.name
			filePath = filePath.replaceAll('\\\\', '/').replaceAll("&", "%26")//+ "/" + geoInstance?.sowFile?.name
			
			//downloadSOWFile(filePath)
			redirect(controller: "downloadFile", action: "downloadDocumentFile", params: [filePath: filePath])
			
		}
	}
	
    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [documentTemplateInstanceList: DocumentTemplate.list(params), documentTemplateInstanceTotal: DocumentTemplate.count()]
    }

    def create() {
        [documentTemplateInstance: new DocumentTemplate(params)]
    }

    def save() {
        def documentTemplateInstance = new DocumentTemplate(params)
        if (!documentTemplateInstance.save(flush: true)) {
            render(view: "create", model: [documentTemplateInstance: documentTemplateInstance])
            return
        }

		flash.message = message(code: 'default.created.message', args: [message(code: 'documentTemplate.label', default: 'DocumentTemplate'), documentTemplateInstance.id])
        redirect(action: "show", id: documentTemplateInstance.id)
    }

    def show() {
        def documentTemplateInstance = DocumentTemplate.get(params.id)
        if (!documentTemplateInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'documentTemplate.label', default: 'DocumentTemplate'), params.id])
            redirect(action: "list")
            return
        }

        [documentTemplateInstance: documentTemplateInstance]
    }

    def edit() {
        def documentTemplateInstance = DocumentTemplate.get(params.id)
        if (!documentTemplateInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'documentTemplate.label', default: 'DocumentTemplate'), params.id])
            redirect(action: "list")
            return
        }

        [documentTemplateInstance: documentTemplateInstance]
    }

	def editsetup()
	{
		def documentTemplateInstance = DocumentTemplate.get(params.id)
		if (!documentTemplateInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'documentTemplate.label', default: 'DocumentTemplate'), params.id])
			redirect(action: "list")
			return
		}

		render(template: "editsetup", model: [documentTemplateInstance: documentTemplateInstance])
	}
	
    def update() {
		Map resultMap = new HashMap()
        def documentTemplateInstance = DocumentTemplate.get(params.id)
        if (!documentTemplateInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'documentTemplate.label', default: 'DocumentTemplate'), params.id])
            redirect(action: "list")
            return
        }

        if (params.version) {
            def version = params.version.toLong()
            if (documentTemplateInstance.version > version) {
                documentTemplateInstance.errors.rejectValue("version", "default.optimistic.locking.failure",
                          [message(code: 'documentTemplate.label', default: 'DocumentTemplate')] as Object[],
                          "Another user has updated this DocumentTemplate while you were editing")
                render(view: "edit", model: [documentTemplateInstance: documentTemplateInstance])
                return
            }
        }

        //documentTemplateInstance.properties = params
		def oldDocumentName = documentTemplateInstance.documentName
		def documentName = params.documentName
		def destinationDirectory = "SOWFiles"
		def storagePath = fileUploadService.getStoragePath(destinationDirectory)
		resultMap.put("nameChanged", "noNameChange")
		
		if(oldDocumentName != documentName)
		{
			def inputFileName = (documentTemplateInstance?.territory?.name + oldDocumentName).toString().toLowerCase().replaceAll(" ", "").replaceAll("[-+^,.!@#\$]*", "") + "SOW.docx"
			def outputFileName = (documentTemplateInstance?.territory?.name + documentName).toString().toLowerCase().replaceAll(" ", "").replaceAll("[-+^,.!@#\$]*", "") + "SOW.docx"
			
			if(fileUploadService.isFileContentCopied(storagePath+"/"+inputFileName, storagePath+"/"+outputFileName))
			{
				documentTemplateInstance.documentName = documentName
				resultMap.put("nameChanged", "true")
			}
			else resultMap.put("nameChanged", "false")
			
		}
		if(params.isreimported == true || params.isreimported == "true")
		{
			def file = request.getFile('file')
			def result = fileUploadService.updateUploadedDocumentFile(documentTemplateInstance, file, documentName, destinationDirectory)
			resultMap.put("reimportResult", result)
			
		}
		resultMap.put("id", documentTemplateInstance?.territory?.id)
		render resultMap as JSON
		
        /*if (!documentTemplateInstance.save(flush: true)) {
            render(view: "edit", model: [documentTemplateInstance: documentTemplateInstance])
            return
        }

		flash.message = message(code: 'default.updated.message', args: [message(code: 'documentTemplate.label', default: 'DocumentTemplate'), documentTemplateInstance.id])
        redirect(action: "show", id: documentTemplateInstance.id)
        */
    }

    def delete() {
        def documentTemplateInstance = DocumentTemplate.get(params.id)
        if (!documentTemplateInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'documentTemplate.label', default: 'DocumentTemplate'), params.id])
            redirect(action: "list")
            return
        }

        try {
            documentTemplateInstance.delete(flush: true)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'documentTemplate.label', default: 'DocumentTemplate'), params.id])
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
			flash.message = message(code: 'default.not.deleted.message', args: [message(code: 'documentTemplate.label', default: 'DocumentTemplate'), params.id])
            redirect(action: "show", id: params.id)
        }
    }
	
	def deletesetup() {
		def documentTemplateInstance = DocumentTemplate.get(params.id)
		if (!documentTemplateInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'documentTemplate.label', default: 'DocumentTemplate'), params.id])
			redirect(action: "list")
			return
		}

		try {
			Geo territoryInstance = Geo.get(documentTemplateInstance?.territory?.id)
			territoryInstance.removeFromSowDocumentTemplates(documentTemplateInstance)
			territoryInstance.save()
			
			
			documentTemplateInstance.delete(flush: true)
			//flash.message = message(code: 'default.deleted.message', args: [message(code: 'documentTemplate.label', default: 'DocumentTemplate'), params.id])
			//redirect(action: "list")
			
			render "success"
		}
		catch (DataIntegrityViolationException e) {
			//flash.message = message(code: 'default.not.deleted.message', args: [message(code: 'documentTemplate.label', default: 'DocumentTemplate'), params.id])
			//redirect(action: "show", id: params.id)
			render "failed"
		}
	}
}
