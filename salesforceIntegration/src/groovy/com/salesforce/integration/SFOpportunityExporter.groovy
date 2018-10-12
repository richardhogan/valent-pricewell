package com.salesforce.integration

import com.sforce.soap.partner.PartnerConnection;
import com.sforce.soap.partner.QueryResult;
import com.sforce.soap.partner.sobject.*;
import com.sforce.soap.partner.*;
import com.sforce.ws.ConnectorConfig;
import com.sforce.ws.ConnectionException;
import com.sforce.soap.partner.Error;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.text.DateFormat
import java.text.SimpleDateFormat
import java.util.Date;

class SFOpportunityExporter {
	
	PartnerConnection partnerConnection
	
	List fieldsArray = ['Id', 'Name', 'AccountId', 'sowPrice__c', 'CloseDate', 'Description', 'ExpectedRevenue', 'Type', 'StageName', 'Probability', 'LastModifiedDate', 'CreatedDate']
	
	public SFOpportunityExporter(PartnerConnection partnerConnection){
		this.partnerConnection = partnerConnection
	}
	
	public String getFieldString()
	{
		String fields = ""
		for(String field : fieldsArray)
		{
			fields = fields + field + ", "
		}
		return fields.substring(0, fields.length()-2)
	}
	
	public Map getFieldValueMap(SObject opportunityObject)
	{
		Map opportunityMap = new HashMap()
		
		for(String field : fieldsArray)
		{
			opportunityMap[field] = opportunityObject.getField(field);
		}
		
		return opportunityMap
	}
	
	public List exportOpportunities(Date oldestDateAllowed)
	{
		List opportunityMapList = new ArrayList()
		try
		{
			partnerConnection.setQueryOptions(250);// Set query batch size
			
			String fieldString = getFieldString()
			// SOQL query to use
			//String soqlQuery = "SELECT "+fieldString+" FROM Opportunity ORDER BY LastModifiedDate DESC";
			
			String soqlQuery = "SELECT "+fieldString+" FROM Opportunity WHERE isSOWNeeded__c = 'Y' ORDER BY LastModifiedDate DESC";
			
			// Make the query call and get the query results
			QueryResult qr = partnerConnection.query(soqlQuery);
			
			boolean done = false, isOlder = false
			int loopCount = 0;
			Set<String> a1 = new HashSet<String>();
			
			while(!done)
			{
				SObject[] records = qr.getRecords();
				
				if(records.length > 0)
				{
					
					int startIndex = 0, endIndex = 0, pageSize = 10, totalRecords = records.length, pageNumber = 1
					boolean reachLastRecord = false  //last opportunity created or updated in specified date range
					
					endIndex = ( totalRecords < pageSize ) ? totalRecords : ( pageSize * pageNumber )
					
					List opportunityObjects = getOpportunitiesOfCurrentPage(records, startIndex, endIndex)
					
					while(opportunityObjects.size() > 0)
					{
						
						SObject lastOpportunityObject = opportunityObjects[opportunityObjects.size()-1]
						Map lastOpportunityMap = getFieldValueMap(lastOpportunityObject)
						
						isOlder = isOpportunityOlder(oldestDateAllowed, lastOpportunityMap)
						
						for(int i = 0; i < opportunityObjects.size(); i++)
						{
							SObject opportunityObject = opportunityObjects[i];
							Map opportunityMap = getFieldValueMap(opportunityObject)
							
							if(isOlder && isOpportunityOlder(oldestDateAllowed, opportunityMap))
							{
								reachLastRecord = true
								break; //Break this loop if oldest opp allowed is found
							}
							opportunityMapList.add(opportunityMap)
						}
						
						opportunityObjects = new ArrayList()
						if(!reachLastRecord)// && endIndex != totalRecords)
						{
							pageNumber++
							startIndex = endIndex
							int remaining = totalRecords - endIndex
							endIndex = (remaining < pageSize) ? (endIndex + remaining) : (endIndex + pageSize)
							
							opportunityObjects = getOpportunitiesOfCurrentPage(records, startIndex, endIndex)
						}
					}
				}
				
				if (qr.isDone()) {
					done = true;
				} else {
					qr = partnerConnection.queryMore(qr.getQueryLocator());
				}
			}
		}
		catch(ConnectionException ce) {
			ce.printStackTrace();
		}
		
		println "Query execution completed Opportunities."
		println opportunityMapList
		return opportunityMapList
	}
	
	public List getOpportunitiesOfCurrentPage(SObject[] records, int startIndex, int endIndex)
	{
		List opportunityList = new ArrayList()
		int j = 0
		for(int i = startIndex; i<endIndex; i++)
		{
			//opportunityList[j] = records[i]
			opportunityList.add(records[i])
			j++
		}
		println opportunityList
		return opportunityList
	}
	
	public boolean isOpportunityOlder(Date oldestDateAllowed, Map opportunityMap)
	{
		Date opportunityUpdateDate = getDate("yyyy-MM-dd'T'HH:mm:ss", removeFractionalSecondsAndTimeZone(opportunityMap["LastModifiedDate"]))
		
		if(oldestDateAllowed != null)
		{
			if(opportunityUpdateDate < oldestDateAllowed)
			{
				return true
			}
		}
		return false
	}
	
	public Date getDate(String dateFormat, String dateString)
	{
		DateFormat df = new SimpleDateFormat(dateFormat);
		return df.parse(dateString);
	}
	
	def removeFractionalSecondsAndTimeZone(String dateString)
	{
		def length = dateString.length()
		return dateString.substring(0, length-5)
	}
}
