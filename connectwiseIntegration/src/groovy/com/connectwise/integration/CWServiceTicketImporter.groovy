package com.connectwise.integration

import cw15.ApiCredentials
import cw15.ServiceTicket
import cw15.ServiceTicketApi
import cw15.ServiceTicketApiSoap
import java.net.MalformedURLException;

class CWServiceTicketImporter {

	String baseUrl;
	
	public CWServiceTicketImporter(String url){
		this.baseUrl = url;
	}
	
	public ServiceTicket importTicket(Map dataMap) throws MalformedURLException
	{
		String url = baseUrl + "/v4_6_release/apis/1.5/ServiceTicketApi.asmx?wsdl";
		
		ServiceTicketApi soapApi = new cw15.ServiceTicketApi(new URL(url));
		ServiceTicketApiSoap serviceTicketSoap = soapApi.getServiceTicketApiSoap();
		
		ApiCredentials credentials = dataMap['credentials']
		def companyId = dataMap['companyId']
		ServiceTicket serviceTicket = dataMap['serviceTicket']
		
		serviceTicket = serviceTicketSoap.addOrUpdateServiceTicketViaCompanyId(credentials, companyId, serviceTicket)
		return serviceTicket
	}
	
	
}
