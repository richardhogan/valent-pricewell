package com.connectwise.integration;

import java.net.MalformedURLException;
import java.util.Date;
import java.util.List;
import java.util.Map;
import javax.xml.datatype.XMLGregorianCalendar
import javax.xml.ws.WebServiceException

import cw15.*

public class CWOpportunityExporter {

	String baseUrl;

	public CWOpportunityExporter(String url){
		this.baseUrl = url;
	}

	//"https://test.connectwise.com/v4_6_release/apis/1.5/OpportunityApi.asmx?wsdl"
	/*public Map exportOpportunities(Map dataMap){
		String url = baseUrl + "/v4_6_release/apis/1.5/OpportunityApi.asmx?wsdl";
		return exportFromUrl(url, dataMap);
	}*/
	
	public cw15.OpportunityListItem getOpportunityFormExternalId(ApiCredentials credentials, String opportunityId)
	{
		String url = baseUrl + "/v4_6_release/apis/1.5/OpportunityApi.asmx?wsdl";
		
		OpportunityApi soapApi = new cw15.OpportunityApi(new URL(url));
		OpportunityApiSoap oppSoap = soapApi.getOpportunityApiSoap();
		ArrayOfOpportunityListItem opportunities = oppSoap.findOpportunities(credentials, "Id = ${opportunityId.toInteger()}", "LastUpdate DESC",10, 0);
		//println opportunities
		OpportunityListItem opportunityLItem = null
		if(opportunities != null && opportunities.getOpportunityListItem().size() > 0)
		{
			for(OpportunityListItem opLItem : opportunities.getOpportunityListItem())
			{
				if(opLItem.id == opportunityId.toInteger())
				{
					opportunityLItem = opLItem
					break;
				}
			}
		}
		
		//cw15.Opportunity opportunity = oppSoap.getOpportunity(credentials, opportunityId.toInteger())
		return opportunityLItem
	}
	
	public Map exportOpportunities(ApiCredentials credentials, Date oldestDateAllowed)  throws MalformedURLException, WebServiceException
	{
		//stage=1.Prospect
		//Status=Open
		//Get only quotations which has service items only (Type: Service) Upgrade to Windows 2003 for reference..
		//Avoid existing ones
		String url = baseUrl + "/v4_6_release/apis/1.5/OpportunityApi.asmx?wsdl";
		
		try
		{
			OpportunityApi soapApi = new cw15.OpportunityApi(new URL(url));
			OpportunityApiSoap oppSoap = soapApi.getOpportunityApiSoap();
			
			//ApiCredentials credentials = dataMap['credentials']
			/*credentials.setCompanyId("valent");
			credentials.setIntegratorLoginId("int1");
			credentials.setIntegratorPassword("int1");*/
	
			StringBuffer conditionStr = new StringBuffer(), stageStr = new StringBuffer(), statusStr = new StringBuffer()
			/*statusStr = createStatusString(dataMap['allowedStatus'])
			stageStr = createStageString(dataMap['allowedStage'])
			
			if(statusStr.length() > 0)
			{
				conditionStr.append(" (" + statusStr + ") ");
			}
			
			if(stageStr.length() > 0)
			{
				if(statusStr.length > 0)
				{
					conditionStr.append(" AND ");
				}
				conditionStr.append(" (" + stageStr + ") ");
			}*/
			
			conditionStr.append( "Closed = false")
			//int totalPage = 10
			int pageSize = 100;
			int count = 0;
			boolean reachedLastUpdate = false, isOlder = false
			List<OpportunityListItem> opportunityItemList = new ArrayList<OpportunityListItem>();
			
			Map opportunityMap = new HashMap()
			ArrayOfOpportunityListItem opportunities = oppSoap.findOpportunities(credentials, conditionStr.toString(), "LastUpdate DESC",pageSize, count);
			
			while(opportunities != null && opportunities.getOpportunityListItem().size() > 0 && !reachedLastUpdate)
			{
				List<OpportunityListItem> opLItems = opportunities.getOpportunityListItem()
				OpportunityListItem lastOpListItem = opLItems.get(opLItems.size()-1)//.last()
				
				reachedLastUpdate = isOpportunityOlder(oldestDateAllowed, lastOpListItem)
				
				if(reachedLastUpdate)
				{
					opLItems = getAllOpportunitiesAfterLastUpdatedDate(oldestDateAllowed, opLItems)
				}
				
				for(OpportunityListItem opLItem : opLItems)
				{
					//println opLItem.getId()
					//println opLItem.opportunityName +" "+ convertXMLGregorianCalendarToDate(opLItem.lastUpdate)
					//println "is " + opLItem_1.opportunityName + " date gone : "
					//if(isOlder && isOpportunityOlder(oldestDateAllowed, opLItem))
						//break; //Break this loop if oldest opp allowed is found
	
					Opportunity opp = oppSoap.getOpportunity(credentials, opLItem.getId());
					
					if(opp != null)
					{
						opportunityItemList.add(opLItem)
						
						println opLItem?.opportunityName
						opportunityMap.put(opLItem.getId(), opp)
					}
								
				}
				
				println opportunityMap
				if(!reachedLastUpdate)
				{
					count+=pageSize;
					opportunities = oppSoap.findOpportunities(credentials, conditionStr.toString(), "LastUpdate DESC", pageSize, count);
					//totalPage--
				}
			}
			
			Map resultMap = new HashMap()
			resultMap.put("opportunityListItem", opportunityItemList)
			resultMap.put("opportunityMap", opportunityMap)
			
			return resultMap
	
		}
		catch(WebServiceException wse)
		{
			println wse.getMessage()
			println "Can not create Opportunity API Service due to wrong site URL."
		}
		
		return [:]
	}
	
	public List<OpportunityListItem> getAllOpportunitiesAfterLastUpdatedDate(Date lastUpdatedDate, List<OpportunityListItem> opLItems)
	{
		int listSize = opLItems.size()
		List<OpportunityListItem> finalList = new ArrayList<OpportunityListItem>()
		
		if(listSize > 1)
		{
			
			List<OpportunityListItem> firstHalf = getSubListFromList(opLItems, 0, Math.ceil(listSize/2).toInteger())
			List<OpportunityListItem> secondHalf = getSubListFromList(opLItems, Math.ceil(listSize/2).toInteger(), listSize)
			
			boolean foundLastUpdated = isOpportunityOlder(lastUpdatedDate, firstHalf.get(firstHalf.size()-1))
			if(foundLastUpdated)
			{
				finalList.addAll(getAllOpportunitiesAfterLastUpdatedDate(lastUpdatedDate, firstHalf))
			}
			else
			{
				finalList.addAll(firstHalf)
				finalList.addAll(getAllOpportunitiesAfterLastUpdatedDate(lastUpdatedDate, secondHalf))
			}
		}
		else
		{
			if(opLItems.size() > 0 && !isOpportunityOlder(lastUpdatedDate, opLItems.get(opLItems.size()-1)))
			{
				finalList.add(opLItems.get(opLItems.size()-1))
			}
		}
		return finalList
	}
	
	public List<OpportunityListItem> getSubListFromList(List<OpportunityListItem> opLItems, int from, int to)
	{
		List<OpportunityListItem> newList =  new ArrayList<OpportunityListItem>()
		
		for(int i = from; i<to; i++)
		{
			newList.add(opLItems.get(i))
		}
		return newList
	}
	
	public boolean isOpportunityOlder(Date oldestDateAllowed, OpportunityListItem opLItem)
	{
		Date opportunityUpdateDate = convertXMLGregorianCalendarToDate(opLItem.lastUpdate)//opLItem.getExpectedCloseDate())//opLItem.lastUpdate)
		
		if(oldestDateAllowed != null)
		{
			//println oldestDateAllowed.compareTo(opportunityUpdateDate)
			/*if(oldestDateAllowed.compareTo(opportunityUpdateDate) == -1)
			{
				return true
			}*/
			if(opportunityUpdateDate.before(oldestDateAllowed))
			{
				return true
			}
		}
		return false
	}
	
	public Date convertXMLGregorianCalendarToDate(XMLGregorianCalendar calendar){
		if(calendar == null) {
			return null;
		}
		
		return calendar.toGregorianCalendar().getTime();
	}
	
	public String isOpportunityApiPermissionAvailable(ApiCredentials credentials)
	{
		String url = baseUrl + "/v4_6_release/apis/1.5/OpportunityApi.asmx?wsdl";
		
		Map opportunityMap = new HashMap()
		try{
			
			OpportunityApi soapApi = new cw15.OpportunityApi(new URL(url));
			OpportunityApiSoap oppSoap = soapApi.getOpportunityApiSoap();
		
			ArrayOfOpportunityListItem opportunities = oppSoap.findOpportunities(credentials, "", "",10, 0);
			
			return "success_opportunity_api"
		}catch(Exception e)
		{
			//e.printStackTrace(System.out);
			String failureMessage = generateFailureMessage(e.getMessage())
			
			return failureMessage
		}
		
		
	}
	
	public void getConnectwiseOpportunity(ApiCredentials credentials, Map dateMap)
	{
		String url = baseUrl + "/v4_6_release/apis/1.5/OpportunityApi.asmx?wsdl";
		
		Map opportunityMap = new HashMap()
		try{
			
			OpportunityApi soapApi = new cw15.OpportunityApi(new URL(url));
			OpportunityApiSoap oppSoap = soapApi.getOpportunityApiSoap();
		
			XMLGregorianCalendar startDate = dateMap["startDate"]
			XMLGregorianCalendar endDate = dateMap["endDate"]
			ArrayOfOpportunityListItem opportunities = oppSoap.findOpportunities(credentials, "ExpectedCloseDate >="+startDate+" AND ExpectedCloseDate < "+endDate, "",10, 0);
			println opportunities
			println  "success_opportunity_api"
		}catch(Exception e)
		{
			//e.printStackTrace(System.out);
			String failureMessage = generateFailureMessage(e.getMessage())
			
			println failureMessage
		}
		
		
	}
	
	public String generateFailureMessage(String errorMessage)
	{
		if(errorMessage != null)
		{
			if(errorMessage.contains("Cannot find company in connectwise"))
			{
				return "invalid_company_id"
			}
			else if(errorMessage.contains("Username or password is incorrect"))
			{
				return  "invalid_loginid_password"
			}
			else if(errorMessage.contains("Failed to create service") || errorMessage.contains("The remote name could not be resolved"))
			{
				return "invalid_url"
			}
			else if(errorMessage.contains("You do not have access to the Opportunity api on this server"))
			{
				return "failure_opportunity_api"
			}
			else {
				if(!errorMessage.contains("System.ApplicationException: Action company name is required")){
					return "invalid_url"
				}
			}
		}
	}
	public StringBuffer createStageString(List<String> allowedStages)
	{
		StringBuffer stageStr = new StringBuffer()
		boolean isFirst = true;
		for(String stage: allowedStages){
			if(!isFirst){
				stageStr.append(" OR ");
			} else {
				isFirst = false;
			}
			stageStr.append( " stageName LIKE '%" + stage + "%' ");
		}
		
		return stageStr
	}
	
	public StringBuffer createStatusString(List<String> allowedStatus)
	{
		StringBuffer statusStr = new StringBuffer()
		boolean isFirst = true;
		for(String status: allowedStatus){
			if(!isFirst){
				statusStr.append(" OR ");
			} else {
				isFirst = false;
			}
			statusStr.append( " status LIKE '%" + status + "%' ");
		}
		
		return statusStr
	}
}
