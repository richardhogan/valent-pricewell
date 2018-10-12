package com.valent.pricewell

import grails.converters.JSON
import java.text.SimpleDateFormat
import org.apache.shiro.SecurityUtils

class SalesforceController {

    def index = { }
	
	def salesforceCatalogService, sfimportService, sendMailService, dateService
	
	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}
	
	def importOpportunities = {
		UpdateRecord lastUpdateRecord = salesforceCatalogService.getLastUpdateDateOfSalesforceImportOpportunity()
		render(view: "importOpportunities", model:[lastUpdateRecord: lastUpdateRecord])
	}
	
	def saveOpportunitiesFromSalesforce = {
		
		Map importMap = new HashMap()
		
		Date startDate = null, endDate = null
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		//endDate = dateFormat.parse(params.endDate);//"2014-01-01")//
		
		/******** for the first time import*************************************/
			if(params.endDate != null && params.endDate != "null" && params.endDate != "")
			{
				endDate = dateService.getDate("yyyy-MM-dd", params.endDate)//dateFormat.parse(params.endDate);//"2006-01-01")//
			}
			if(params.startDate != null && params.startDate != "null" && params.startDate != "")
			{
				startDate = dateService.getDate("yyyy-MM-dd", params.startDate)//dateFormat.parse(params.startDate);//"2006-01-01")//
			}
		/***********************************************************************/
		
		//Note : end date is later than start Date Ex: end date = "2014-01-01" and start date = "2006-01-01"
		//Map opportunityTimeStamp = connectwiseCatalogService.getTimestampForConnectwiseImportOpportunity()
		//startDate = opportunityTimeStamp["toDate"]!=null?opportunityTimeStamp["toDate"]-1:null
		
		UpdateRecord lastUpdateRecord = salesforceCatalogService.getLastUpdateDateOfSalesforceImportOpportunity()
		if(lastUpdateRecord != null)
		{
			endDate = new Date()
			startDate = lastUpdateRecord?.lastUpdateDate!=null?lastUpdateRecord?.lastUpdateDate-1:startDate
		}
		
		importMap['endDate'] = endDate+1
		importMap['startDate'] = startDate
		//println startDate
		//println endDate
		def resultMap = [:]
		
		try{
			Map responseMap = sfimportService.importOpportunities(importMap, "manual");
			
			List importedOpportunities = responseMap['imported'], existedOpportunities = responseMap['existed'], updatedOpportunities = responseMap['updated']
			//Map opportunityTerritoryMap = responseMap['opportunityTerritoryMap']
			//def countUnavailableTerritory = responseMap['countUnavailableTerritory']
			def comment = ""
			if(importedOpportunities?.size() > 0 || updatedOpportunities?.size() > 0)
			{
				Opportunity firstImportedOpportunity = null, firstUpdatedOpportunity = null, firstOpportunity
				
				if(importedOpportunities?.size() > 0)
				{
					firstOpportunity = firstImportedOpportunity = importedOpportunities.first()//Here first means last created in salesforce
				}
				if(updatedOpportunities?.size() > 0)
				{
					firstOpportunity = firstUpdatedOpportunity = updatedOpportunities.first()//Here first means last updated in salesforce
				}
				
				if(firstImportedOpportunity != null && firstUpdatedOpportunity != null && dateService(firstImportedOpportunity?.dateModified, firstUpdatedOpportunity?.dateModified) > 0)
				{
					firstOpportunity = firstImportedOpportunity
				}
				else
				{
					firstOpportunity = firstUpdatedOpportunity
				}
				
				comment = "Total number of opportunity imported : "+importedOpportunities?.size()
				
				Date startDate1 = importMap["startDate"] != null ? importMap["startDate"]+1 : firstOpportunity?.dateModified-1
				salesforceCatalogService.saveUpdateRecordForSalesforceImportOpportunity(startDate1, importMap['endDate']-1, comment, "manual")
			}
			else
			{
				comment = "There is no more opportunity to import."
			}
			
			
			def totalImported = 0
			for(Opportunity opp : importedOpportunities)
			{
				def user = User.get(new Long(SecurityUtils.subject.principal))
				def map = new NotificationGenerator(g).sendSalesforceToPricewellOpportunityImportNotification(opp, user);
				sendMailService.sendEmailNotification(map["message"], map["subject"], map["receiverList"], request.siteUrl+"/opportunity/show/"+opp.id)
				totalImported++
			}
			
			String responseMessage = salesforceCatalogService.generateMessage(totalImported)
			
			def content = g.render(template:"opportunityResponse", model:[responseMessage: responseMessage, importedOpportunities: importedOpportunities, existedOpportunities: existedOpportunities, updatedOpportunities: updatedOpportunities])
			resultMap.put("content", content)
			
			/*if(countUnavailableTerritory > 0)
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
			}*/
			resultMap.put("result", "success")
			render resultMap as JSON
		}
		catch(Exception e)
		{
			e.printStackTrace(System.out);
			String failureMessage = salesforceCatalogService.generateFailureMessage(e.getMessage())
			
			resultMap.put("failureMessage", failureMessage)
			resultMap.put("result", "Failed")
			render resultMap as JSON
		}
		
	}
}
