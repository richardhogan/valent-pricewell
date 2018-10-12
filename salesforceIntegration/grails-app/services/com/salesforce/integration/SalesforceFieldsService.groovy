package com.salesforce.integration

class SalesforceFieldsService {

    static transactional = true

    def serviceMethod() {

    }
	
	public List getOpportunityFields()
	{
		return ['Id', 'Name', 'AccountId', 'sowPrice__c', 'CloseDate', 'Description', 'ExpectedRevenue', 'Type', 'StageName', 'Probability', 'LastModifiedDate', 'CreatedDate']
	}
	
	public List getAccountFields()
	{
		return ['Fax', 'Id', 'Name', 'Phone', 'Website', 'Type', 'CreatedDate', 'LastModifiedDate', 'BillingCity', 'BillingCountry', 'BillingState', 'BillingStreet', 'BillingPostalCode']
	}
	
	public List getContactFields()
	{
		return ['Fax', 'Phone', 'Id', 'CreatedDate', 'Department', 'Email', 'FirstName', 'LastModifiedDate', 'LastName', 'MailingCity', 'MailingCountry', 'MailingState', 'MailingStreet', 'MailingPostalCode', 'MobilePhone', 'Title']
	}
}
