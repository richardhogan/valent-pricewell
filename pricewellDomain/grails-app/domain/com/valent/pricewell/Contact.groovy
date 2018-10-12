package com.valent.pricewell

import java.util.Date;

class Contact 
{
	User assignTo;
	String firstname;
	String lastname; 
	String department;
	String email;     
	String altEmail;
	String title;
	//String address; 
	String phone;     
	String mobile;    
	String fax;       
	Date dateCreated;
	User createdBy;
	Date dateModified;
	User modifiedBy;
	BillingAddress billingAddress
	Account account
	String iso 
	String format
	
	String externalId
	String externalSource
	
    static constraints =
	{
		assignTo(nullable: true)
		firstname(nullable: false, blank: false)
		lastname(nullable: false, blank: false)
		department(nullable: true)
		email(nullable: true)
		phone(nullable: true)
		mobile(nullable: true)
		altEmail(nullable: true)
		title(nullable: true)
		fax(nullable: true)
		createdBy(nullable: false)
		modifiedBy(nullable: true)
		dateCreated()
		dateModified()
		billingAddress(nullable: true)
		account(nullable: true)
		lead(nullable: true)
		format(nullable: true)
		iso(nullable: true)
		externalId(nullable: true)
		externalSource(nullable: true)
		//opportunities(nullable: true)
    }
	
	static hasMany = [address: BillingAddress, quotation: Quotation]//, opportunities: Opportunity
	
	static mapping = {
		billingAddress lazy:false
		account lazy:false
		
		//externalId column:'External_Id', index: 'External_Idx'
	}
	
	String toString()
	{
		"${this.firstname} ${this.lastname}"
	}
	
	static belongsTo = [lead: Lead]
}
