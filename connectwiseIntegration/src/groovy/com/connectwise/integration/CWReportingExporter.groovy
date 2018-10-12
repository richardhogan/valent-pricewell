package com.connectwise.integration

import cw15.ApiCredentials;
import cw15.ReportingApi
import cw15.ReportingApiSoap

class CWReportingExporter {

	String baseUrl;
	
	public CWReportingExporter(String url){
		this.baseUrl = url;
	}
	
	public String isReportingApiPermissionAvailable(ApiCredentials credentials)
	{
		String url = baseUrl + "/v4_6_release/apis/1.5/ReportingApi.asmx?wsdl"
		try{
			ReportingApi soapApi = new cw15.ReportingApi(new URL(url));
			ReportingApiSoap reportingSoap = soapApi.getReportingApiSoap()
			
			reportingSoap.runReportQuery(credentials, "Service", "", "", 10, 0)
			
			return "success_reporting_api"
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
			if(errorMessage.contains("You do not have access to the Reporting api on this server"))
			{
				return "failure_reporting_api"
			}
		}
	}
}
