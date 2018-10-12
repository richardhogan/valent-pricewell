package com.connectwise.integration

import java.net.MalformedURLException;
import java.util.Date;
import java.util.Map;

import javax.xml.datatype.XMLGregorianCalendar;

import cw15.*

class CWServiceTicketExporter {

	String baseUrl;
	
	public CWServiceTicketExporter(String url){
		this.baseUrl = url;
	}
	
	public Map exportServiceTickets(Map dataMap)  throws MalformedURLException
	{
		String url = baseUrl + "/v4_6_release/apis/1.5/ServiceTicketApi.asmx?wsdl";
		
		ServiceTicketApi soapApi = new cw15.ServiceTicketApi(new URL(url));
		ServiceTicketApiSoap sTicketSoap = soapApi.getServiceTicketApiSoap()
		
		ApiCredentials credentials = dataMap['credentials']
		String condition = ""
		println dataMap['type']
		if(dataMap['type'] == "closed")
		{
			condition = "ClosedFlag = true AND Summary LIKE 'Quote #%'"
		}
		else
		{
			condition = "Summary LIKE 'Quote #%'"	
		}
		println condition
		int pageSize = 10;
		int count = 0;
		
		List<Ticket> ticketList = new ArrayList<Ticket>();
		ArrayOfTicket serviceTicketArray = sTicketSoap.findServiceTickets(credentials, condition, "", pageSize, count)
		
		while(serviceTicketArray != null && serviceTicketArray.getTicket().size() > 0)
		{
			for(Ticket ticket : serviceTicketArray.getTicket())
			{
				ticketList.add(ticket)
			}
			
			count+=pageSize;
			serviceTicketArray = sTicketSoap.findServiceTickets(credentials, condition, "", pageSize, count)
		}
		
		Map resultMap = new HashMap()
		resultMap.put("ticketList", ticketList)
		
		return resultMap
	}
	
	public void updateServiceTicketWithTotalBudgetHours(Map dataMap)
	{
		String url = baseUrl + "/v4_6_release/apis/1.5/ServiceTicketApi.asmx?wsdl";
		
		ServiceTicketApi soapApi = new cw15.ServiceTicketApi(new URL(url));
		ServiceTicketApiSoap sTicketSoap = soapApi.getServiceTicketApiSoap()
		
		ApiCredentials credentials = dataMap['credentials']
		
		String ticketId = dataMap['ticketId']
		def companyId = dataMap['companyId']
		
		/*List<Ticket> ticketList = new ArrayList<Ticket>();
		ArrayOfTicket serviceTicketArray = sTicketSoap.findServiceTickets(credentials, "Summary LIKE '"+summary+"'", "", 1, 0)
		
		if(serviceTicketArray.getTicket().size() > 0)
		{
			for(Ticket ticket : serviceTicketArray.getTicket())
			{*/
				ServiceTicket serviceTicket = sTicketSoap.getServiceTicket(credentials, ticketId.toInteger())
				if(serviceTicket && serviceTicket.budgetHours != dataMap['budgetHours'])
				{
					serviceTicket.budgetHours = dataMap['budgetHours']
					
					sTicketSoap.addOrUpdateServiceTicketViaCompanyId(credentials, companyId, serviceTicket)
				}				
			/*}
		}*/
		
	}
	
	public String isServiceTicketApiPermissionAvailable(ApiCredentials credentials)
	{
		String url = baseUrl + "/v4_6_release/apis/1.5/ServiceTicketApi.asmx?wsdl";
		
		ServiceTicketApi soapApi = new cw15.ServiceTicketApi(new URL(url));
		ServiceTicketApiSoap sTicketSoap = soapApi.getServiceTicketApiSoap()
		
		try{
			ArrayOfTicket serviceTicketArray = sTicketSoap.findServiceTickets(credentials, "", "", 10, 0)
			
			return "success_service_ticket_api"
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
			if(errorMessage.contains("You do not have access to the Ticket api on this server"))
			{
				return "failure_service_ticket_api"
			}
		}
	}
}
