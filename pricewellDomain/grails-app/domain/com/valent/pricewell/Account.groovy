package com.valent.pricewell

import java.util.Date;

class Account 
{
	User assignTo
	LogoImage logo
	UploadFile imageFile
	String accountName;
	String website;         
	String phone;           
	String fax;             
	String email;
	String type;
	Date dateCreated;
	User createdBy;
	Date dateModified;
	User modifiedBy;
	BillingAddress billingAddress
	ShippingAddress shippingAddress
	
	String externalId
	String externalSource
	
    static constraints = 
	{
		assignTo(nullable: true)
		logo(nullable: true)
		imageFile(nullable: true)
		accountName(nullable: true, blank: true, unique: true);
		website(nullable: true);
		phone(nullable: true);
		fax(nullable: true);
		email(nullable: true);
		dateCreated()
		dateModified()
		createdBy(nullable: true)
		modifiedBy(nullable: true)
		billingAddress(nullable: true)
		shippingAddress(nullable: true)
		contacts(nullable: true)
		opportunities(nullable: true)
		type(nullable: true)
		
		externalId(nullable: true)
		externalSource(nullable: true)
    }
	static mapping = 
	{
		billingAddress lazy:false
		shippingAddress lazy:false
		
		//externalId column:'External_Id', index: 'External_Idx'
	}
	
	
	
	static hasMany = [quotations: Quotation, contacts: Contact, opportunities: Opportunity];
	
	String toString() {
		"${accountName}"
	}
	
}
