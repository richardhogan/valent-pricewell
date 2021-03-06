package com.salesforce.integration

import java.util.List;
import java.util.Map;

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

class SFAccountExporter {

	PartnerConnection partnerConnection
	
	List fieldsArray = ['Fax', 'Id', 'Name', 'Phone', 'Website', 'Type', 'CreatedDate', 'LastModifiedDate', 'BillingCity', 'BillingCountry', 'BillingState', 'BillingStreet', 'BillingPostalCode']
	
	public SFAccountExporter(PartnerConnection partnerConnection){
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
	
	public Map getFieldValueMap(SObject accountObject)
	{
		Map accountMap = new HashMap()
		
		for(String field : fieldsArray)
		{
			accountMap[field] = accountObject.getField(field);
		}
		
		return accountMap
	}
	
	public List getAccountFromId(String id) 
	{
		List accountMapList = new ArrayList()
		try 
		{
			// Set query batch size
			partnerConnection.setQueryOptions(250);
			String accountId = id;//"001900000135g2QAAQ";
			
			String fieldString = getFieldString()
			// SOQL query to use
			String soqlQuery = "SELECT "+ fieldString +" FROM Account WHERE Id = '"+accountId+"'";
			// Make the query call and get the query results
			QueryResult queryResult = partnerConnection.query(soqlQuery);

			boolean done = false;
			
			while (!done) 
			{
				SObject[] records = queryResult.getRecords();
				// Process the query results
				for (int i = 0; i < records.length; i++) 
				{
					SObject accountObject = records[i];
					
					Map accountMap = getFieldValueMap(accountObject)
					
					accountMapList.add(accountMap)
					
				}
				
				if (queryResult.isDone()) {
					done = true;
				} else {
					queryResult = partnerConnection.queryMore(queryResult.getQueryLocator());
				}
			}
			
		} catch(ConnectionException ce) {
			ce.printStackTrace();
		}
		println "Query execution completed Accounts."
		//println accountMapList
		return accountMapList
	}

}
