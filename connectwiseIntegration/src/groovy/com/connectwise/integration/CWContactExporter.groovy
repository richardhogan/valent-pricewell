package com.connectwise.integration

import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashSet;
import java.util.Set;

import cw.ArrayOfContactFindResult
import cw.ContactApi;
import cw.ContactApiSoap;
import cw.ContactFindResult
import cw15.ApiCredentials;
import cw15.ArrayOfCompanyFindResult;
import cw15.ArrayOfOpportunityItem;
import cw15.CompanyFindResult;
import cw15.Opportunity;
import cw15.OpportunityItem;
import cw15.OpportunityListItem;

public class CWContactExporter {

	String baseUrl;
	public CWContactExporter(String url)
	{
		this.baseUrl = url //+ "/v4_6_release/apis/1.5/ContactApi.asmx?wsdl"
	}
	
	public List<ContactFindResult> getContactList(ApiCredentials credentials, String companyName) throws MalformedURLException
	{
		String contactUrl = baseUrl + "/v4_6_release/apis/1.5/ContactApi.asmx?wsdl"
		cw.ApiCredentials contactCredentials = new cw.ApiCredentials();
		contactCredentials.setCompanyId(credentials.getCompanyId());
		contactCredentials.setIntegratorLoginId(credentials.getIntegratorLoginId());
		contactCredentials.setIntegratorPassword(credentials.getIntegratorPassword());
		
		ContactApi contactApi = new cw.ContactApi(new URL(contactUrl));
		ContactApiSoap contactSoap = contactApi.getContactApiSoap();
		
		List companyContacts = new ArrayList<ContactFindResult>()
		int pageSize = 10;
		int count = 0;
		
		companyName = companyName.replaceAll("'", "\\\\'")
		//println "company Name is : " + companyName
		
		ArrayOfContactFindResult contacts = contactSoap.findCompanies(contactCredentials, "companyName LIKE '"+ companyName +"'", "", pageSize, count)
		
		while(contacts != null && contacts.getContactFindResult().size() > 0)
		{
			for(ContactFindResult contact : contacts.getContactFindResult())
			{
				companyContacts.add(contact)
			}
			
			count+=pageSize;
			contacts = contactSoap.findCompanies(contactCredentials, "companyName LIKE '"+ companyName +"'", "", pageSize, count)
		}
		
		//System.out.println(contactSoap.findContactsCount(contactCredentials, "companyName LIKE '"+ companyName +"'"));
		
		return companyContacts
	}
	
	public String isContactApiPermissionAvailable(ApiCredentials credentials)
	{
		String url = baseUrl + "/v4_6_release/apis/1.5/ContactApi.asmx?wsdl";
		
		cw.ApiCredentials contactCredentials = new cw.ApiCredentials();
		contactCredentials.setCompanyId(credentials.getCompanyId());
		contactCredentials.setIntegratorLoginId(credentials.getIntegratorLoginId());
		contactCredentials.setIntegratorPassword(credentials.getIntegratorPassword());
		
		ContactApi contactApi = new cw.ContactApi(new URL(url));
		ContactApiSoap contactSoap = contactApi.getContactApiSoap();
		
		try{
			ArrayOfContactFindResult contacts = contactSoap.findCompanies(contactCredentials, "", "", 10, 0)
			
			return "success_contact_api"
		}catch(Exception e)
		{
			//e.printStackTrace(System.out);
			String failureMessage = generateFailureMessage(e.getMessage())
			
			return failureMessage
		}
		
		
	}
	
	public String generateFailureMessage(String errorMessage)
	{
		if(errorMessage != null)
		{
			if(errorMessage.contains("You do not have access to the Contact api on this server"))
			{
				return "failure_contact_api"
			}
		}
	}
}
