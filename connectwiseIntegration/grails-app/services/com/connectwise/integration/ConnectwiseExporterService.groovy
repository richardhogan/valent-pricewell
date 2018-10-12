package com.connectwise.integration

import java.net.MalformedURLException;
import java.util.List;
import java.util.Map;

import cw.ContactFindResult;
import cw15.ApiCredentials;
import cw15.CompanyFindResult;
import cw15.OpportunityListItem;

class ConnectwiseExporterService {

    static transactional = true

	static {
		XTrustProvider.install();
	}
	
    def serviceMethod() {

    }
	
	public Map exportOpportunities(String url, ApiCredentials credentials, Date oldestDateAllowed)throws MalformedURLException//from opportunity exporter
	{
		return new CWOpportunityExporter(url).exportOpportunities(credentials, oldestDateAllowed)
	}
	
	public List<Integer> getOpportunityServiceIds(String url, ApiCredentials credentials, List<String> productTypes)throws MalformedURLException//from product exporter
	{
		return new CWProductExporter(url).getOpportunityServiceIds(credentials, productTypes)
	}
	
	public cw15.OpportunityListItem getOpportunityFormExternalId(String url, ApiCredentials credentials, String opportunityId)
	{
		return new CWOpportunityExporter(url).getOpportunityFormExternalId(credentials, opportunityId)
	}
	
	public List<ContactFindResult> getContactList(String url, ApiCredentials credentials, String companyName) throws MalformedURLException//from contact exporter
	{
		return new CWContactExporter(url).getContactList(credentials, companyName)
	}
	
	public CompanyFindResult getCompany(String url, ApiCredentials credentials, String companyName)/*OpportunityListItem opLItem)*/throws MalformedURLException//from company exporter
	{
		return new CWCompanyExporter(url).getCompany(credentials, companyName)//opLItem)//from company exporter
	}
	
	public Map exportServiceTickets(String url, Map dataMap)throws MalformedURLException//from opportunity exporter
	{
		return new CWServiceTicketExporter(url).exportServiceTickets(dataMap)
	}
	
	public void updateServiceTicketWithTotalBudgetHours(String url, Map dataMap)throws MalformedURLException//from opportunity exporter
	{
		new CWServiceTicketExporter(url).updateServiceTicketWithTotalBudgetHours(dataMap)
	}
	
	public void getConnectwiseOpportunity(String url, ApiCredentials credentials, Map dateMap)
	{
		new CWOpportunityExporter(url).getConnectwiseOpportunity(credentials, dateMap)
	}
	
	public Map checkConnectwiseCredentials(String url, ApiCredentials credentials)
	{
		String opportunityApiMessage = new CWOpportunityExporter(url).isOpportunityApiPermissionAvailable(credentials)
		boolean isFailed = false
		Map resultMap = new HashMap()
		List messageList = new ArrayList()
		
		if(opportunityApiMessage == "invalid_company_id" || opportunityApiMessage == "invalid_loginid_password" || opportunityApiMessage == "invalid_url")
		{
			isFailed = true
			messageList.add(generateMessageToDisplay(opportunityApiMessage))
		}
		
		if(isFailed == true)
		{
			resultMap['result'] = "failure"
			resultMap["failureMessage"] = messageList
		}
		else resultMap['result'] = "success"
		
		return resultMap
	}
	
	public Map checkConnectwiseApiPermissions(String url, ApiCredentials credentials)
	{
		String opportunityApiMessage = new CWOpportunityExporter(url).isOpportunityApiPermissionAvailable(credentials)
		
		boolean isFailed = false
		Map resultMap = new HashMap()
		List messageList = new ArrayList()
		
		if(opportunityApiMessage == "invalid_company_id" || opportunityApiMessage == "invalid_loginid_password" || opportunityApiMessage == "invalid_url")
		{
			isFailed = true
			messageList.add(generateMessageToDisplay(opportunityApiMessage))
		}
		else
		{
			String productApiMessage = new CWProductExporter(url).isProductApiPermissionAvailable(credentials)
			String companyApiMessage = new CWCompanyExporter(url).isCompanyApiPermissionAvailable(credentials)
			String contactApiMessage = new CWContactExporter(url).isContactApiPermissionAvailable(credentials)
			String serviceTicketApiMessage = new CWServiceTicketExporter(url).isServiceTicketApiPermissionAvailable(credentials)
			String reportingApiMessage = new CWReportingExporter(url).isReportingApiPermissionAvailable(credentials)
			
			messageList.add(generateMessageToDisplay(opportunityApiMessage))
			messageList.add(generateMessageToDisplay(productApiMessage))
			messageList.add(generateMessageToDisplay(companyApiMessage))
			messageList.add(generateMessageToDisplay(contactApiMessage))
			messageList.add(generateMessageToDisplay(serviceTicketApiMessage))
			messageList.add(generateMessageToDisplay(reportingApiMessage))
			
			if(opportunityApiMessage == "failure_opportunity_api" || productApiMessage == "failure_product_api" || companyApiMessage == "failure_company_api" || contactApiMessage == "failure_contact_api" || serviceTicketApiMessage == "failure_service_ticket_api" || reportingApiMessage == "failure_reporting_api")
			{
				isFailed = true
			}
						
		}
		
		if(isFailed == true)
		{
			resultMap['result'] = "failure"
		}
		else resultMap['result'] = "success"
		
		resultMap["responseMessage"] = messageList
		
		return resultMap
	}
	
	public String generateMessageToDisplay(String shortMessage)
	{
		switch(shortMessage)
		{
			case "invalid_company_id": return "Integrator Company Id is invalid. Please correct it first."; break;
			case "invalid_loginid_password": return "Integrator LoginId or Password is incorrect. Please correct it first."; break;
			case "invalid_url": return "Invalid PSA URL. Please correct it first."; break;
			
			case "success_opportunity_api": return "Access to Opportunity API is successfull."; break;
			case "failure_opportunity_api": return "Fail to access to Opportunity API. Please give Permission to access it."; break;
			
			case "success_product_api": return "Access to Product API is successfull."; break;
			case "failure_product_api": return "Fail to access to Product API. Please give Permission to access it."; break;
			
			case "success_company_api": return "Access to Company API is successfull."; break;
			case "failure_company_api": return "Fail to access to Company API. Please give Permission to access it."; break;
			
			case "success_contact_api": return "Access to Contact API is successfull."; break;
			case "failure_contact_api": return "Fail to access to Contact API. Please give Permission to access it."; break;
			
			case "success_service_ticket_api": return "Access to Service Ticket API is successfull."; break;
			case "failure_service_ticket_api": return "Fail to access to Service Ticket API. Please give Permission to access it."; break;
			
			case "success_reporting_api": return "Access to Reporting API is successfull."; break;
			case "failure_reporting_api": return "Fail to access to Reporting API. Please give Permission to access it."; break;
		}
	}
}
