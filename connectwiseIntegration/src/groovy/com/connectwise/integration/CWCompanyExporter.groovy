package com.connectwise.integration

import java.net.URL;

import cw15.ApiCredentials;
import cw15.ArrayOfCompanyFindResult;
import cw15.CompanyApi;
import cw15.CompanyApiSoap;
import cw15.CompanyFindResult;
import cw15.OpportunityListItem

public class CWCompanyExporter {

	String baseUrl;
	
	public CWCompanyExporter(String url)
	{
		this.baseUrl = url //+ "/v4_6_release/apis/1.5/CompanyApi.asmx?wsdl"
	}
	
	public CompanyFindResult getCompany(ApiCredentials credentials, String companyName)//OpportunityListItem opLItem)
	{
		String companyUrl = baseUrl + "/v4_6_release/apis/1.5/CompanyApi.asmx?wsdl"
		CompanyApi companyApi = new cw15.CompanyApi(new URL(companyUrl));
		CompanyApiSoap companySoap = companyApi.getCompanyApiSoap();
		companyName = companyName.replaceAll("'", "\\\\'")
		//println "company Name is : " + companyName
		//ArrayOfCompanyFindResult companies = companySoap.findCompanies(credentials, "companyName LIKE '%"+ opLItem.getCompanyName() +"%'", "", 2, 0);
		ArrayOfCompanyFindResult companies = companySoap.findCompanies(credentials, "companyName LIKE '%"+ companyName +"%'", "", 2, 0);
		
		if(companies.getCompanyFindResult().size() > 0)
		{
			for(CompanyFindResult companyFResult : companies.getCompanyFindResult())
			{
				System.out.println("----------------Company Name : " + companyFResult.getCompanyName()+"---------------------------------");
				//new CW15ContactUtil().getContactIds(credentials, companyFResult.getCompanyName());
				//companyFResult;
				
				return companyFResult
				break
			}
		}
		
		return null
		
	}
	
	public String isCompanyApiPermissionAvailable(ApiCredentials credentials)
	{
		String url = baseUrl + "/v4_6_release/apis/1.5/CompanyApi.asmx?wsdl";
		
		CompanyApi companyApi = new cw15.CompanyApi(new URL(url));
		CompanyApiSoap companySoap = companyApi.getCompanyApiSoap();
		
		try{
			ArrayOfCompanyFindResult companies = companySoap.findCompanies(credentials, "", "", 10, 0);
			
			return "success_company_api"
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
			if(errorMessage.contains("You do not have access to the Company api on this server"))
			{
				return "failure_company_api"
			}
		}
	}
}
