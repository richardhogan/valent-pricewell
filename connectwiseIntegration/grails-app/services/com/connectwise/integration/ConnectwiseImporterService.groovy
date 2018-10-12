package com.connectwise.integration;

import cw15.ServiceTicket;


class ConnectwiseImporterService {

    static transactional = true

    def serviceMethod() {

    }
	
	public ServiceTicket importServiceTicket(String siteUrl, Map dataMap)
	{
		return new CWServiceTicketImporter(siteUrl).importTicket(dataMap)
	}
	
}
