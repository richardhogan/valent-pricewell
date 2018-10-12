package com.valent.pricewell

import cw15.*
import grails.converters.JSON

import java.text.SimpleDateFormat
import java.util.Date;

import org.apache.shiro.SecurityUtils

class CwController {
	static allowedMethods = [save: "POST", update: "POST", delete: "POST"]
	def cwimportService, sendMailService, connectwiseCatalogService, dateService, salesCatalogService, fieldMappingService

	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}
	
	def index = {
		cwimportService.importOpportunities("https://test.connectwise.com");///v4_6_release
	}
	
	def importOpportunities = {
		UpdateRecord lastUpdateRecord = connectwiseCatalogService.getLastUpdateDateOfConnectwiseImportOpportunity()
		render(view: "importOpportunities", model:[lastUpdateRecord: lastUpdateRecord])
	}

	def saveOpportunitiesFromConnectwise = {
		
		//println params
		Map importMap = new HashMap()
		/*importMap['allowedOpportunityStatus'] = connectwiseCatalogService.generateStatusList(params.status.toString())
		importMap['allowedForecastStatus'] = connectwiseCatalogService.generateStatusList(params.forecastStatus.toString())
		
		importMap['allowedStages'] = connectwiseCatalogService.generateStageList(params.stages.toString())
		importMap['allowedProductTypes'] = connectwiseCatalogService.generateProductTypeList(params.productTypes.toString())
		importMap['allowedEstimateTypes'] = connectwiseCatalogService.generateEstimateTypeList(params.estimateTypes.toString())*/
		
		//println generateEstimateTypeList(params.estimateTypes.toString())
		
		//println params.status.toString()
		
		Date startDate = null, endDate = null
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		//endDate = dateFormat.parse(params.endDate);//"2014-01-01")//
		
		/******** for the first time import*************************************/
			if(params.endDate != null && params.endDate != "null" && params.endDate != "")
			{
				endDate = dateFormat.parse(params.endDate);//"2006-01-01")//
			}
			if(params.startDate != null && params.startDate != "null" && params.startDate != "")
			{
				startDate = dateFormat.parse(params.startDate);//"2006-01-01")//
			}
		/***********************************************************************/
		
		//Note : end date is later than start Date Ex: end date = "2014-01-01" and start date = "2006-01-01"
		//Map opportunityTimeStamp = connectwiseCatalogService.getTimestampForConnectwiseImportOpportunity()
		//startDate = opportunityTimeStamp["toDate"]!=null?opportunityTimeStamp["toDate"]-1:null
		
		UpdateRecord lastUpdateRecord = connectwiseCatalogService.getLastUpdateDateOfConnectwiseImportOpportunity()
		if(lastUpdateRecord != null)
		{
			endDate = new Date()
			startDate = lastUpdateRecord?.lastUpdateDate!=null?lastUpdateRecord?.lastUpdateDate-1:null
		}
		
		importMap['endDate'] = endDate		
		importMap['startDate'] = startDate	
		def resultMap = [:]
		
		try{
			log.info "[Log Time: ${new Date()}] - Importing Opportuities manually from Connectwise CRM."
			Map responseMap = cwimportService.importOpportunities(importMap, "manual");
			
			
			List importedOpportunities = responseMap['imported'], existedOpportunities = responseMap['existed']
			Map opportunityTerritoryMap = responseMap['opportunityTerritoryMap']
			def countUnavailableTerritory = responseMap['countUnavailableTerritory']
			def comment = ""
			if(importedOpportunities?.size() > 0)
			{
				//Opportunity firstOpportunity = importedOpportunities.first()//Here first means last created in connectwise
				//connectwiseCatalogService.saveTimestampForConnectwiseImportOpportunity(importMap['startDate'], importMap['endDate'])
				comment = "Total number of opportunity imported : "+importedOpportunities?.size()
				log.info "[Log Time: ${new Date()}] - Total number of opportunity imported : from ${importedOpportunities?.size()} Connectwise CRM."
				connectwiseCatalogService.saveUpdateRecordForConnectwiseImportOpportunity(lastUpdateRecord?.lastUpdateDate, , importMap['endDate'], comment)//importMap['startDate']+1, importMap['endDate'], comment)
			}
			else
			{
				comment = "There is no more opportunity to import."
				log.info "[Log Time: ${new Date()}] - There is no more opportunity to import."
			}
			
			
			def totalImported = 0
			for(Opportunity opp : importedOpportunities)
			{
				def user = User.get(new Long(SecurityUtils.subject.principal))
				def map = new NotificationGenerator(g).sendCWToPricewellOpportunityImportNotification(opp, user);
				sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/opportunity/show/"+opp.id)
				totalImported++
			}
			
			String responseMessage = connectwiseCatalogService.generateMessage(totalImported)
			
			def content = g.render(template:"opportunityResponse", model:[responseMessage: responseMessage, importedOpportunities: importedOpportunities, existedOpportunities: existedOpportunities])
			resultMap.put("content", content)
			
			if(countUnavailableTerritory > 0)
			{
				resultMap.put("result", "mapTerritory")
				
				def opportunityList = new ArrayList(), territoryList = new ArrayList(), opportunityIds = new ArrayList()
				opportunityList = opportunityTerritoryMap["opportunityList"]
				territoryList = opportunityTerritoryMap["territoryList"]
				opportunityIds = opportunityTerritoryMap["opportunityIds"]
				
				content = g.render(template:"mapOpportunityTerritory", model:[opportunityList: opportunityList, territoryList: territoryList, opportunityIds: opportunityIds, content: content])
				resultMap.put("content", content)
				
			}
			else
			{
				resultMap.put("result", "success")
			}
			
			render resultMap as JSON
		}
		catch(Exception e)
		{
			e.printStackTrace(System.out);
			String failureMessage = connectwiseCatalogService.generateFailureMessage(e.getMessage())
			
			resultMap.put("failureMessage", failureMessage)
			resultMap.put("result", "Failed")
			render resultMap as JSON
		}
		
	}
	
	def saveTerritoryMapping = {
		List opportunityIds = connectwiseCatalogService.generateOpportunityIdsList(params.opportunityIds.toString())
		def responseContent = params.responseContent
		
		for(String id : opportunityIds)
		{
			Opportunity opportunityInstance = Opportunity.get(id.toLong())
			String territoryName = params.get("finalTerritory-"+id)
			if(territoryName != null && territoryName != "")
			{
				//println territoryName
				Geo geo = connectwiseCatalogService.getTerritory(territoryName)
				opportunityInstance.geo = geo
				opportunityInstance.assignTo = salesCatalogService.getSalesUserOfGeo(geo)
				opportunityInstance.save()
				
				def isMapped = params.get("isMapped-"+id)
				if(isMapped == true || isMapped == "true")
				{ 
					def connectwiseTerritory = params.get("connectwiseTerritoryName-"+id)
					
					if(connectwiseTerritory != "No Territory Specified")
					{
						if(!fieldMappingService.isMappingAvailable(connectwiseTerritory, FieldMapping.MappingType.TERRITORY))
						{
							fieldMappingService.addFieldMapping(connectwiseTerritory, geo?.name, FieldMapping.MappingType.TERRITORY)
						}
					}	
				}
			}
		}
		def resultMap = [:]
		resultMap.put("content", responseContent)
	
		resultMap.put("result", "success")
		render resultMap as JSON
	}
	
}