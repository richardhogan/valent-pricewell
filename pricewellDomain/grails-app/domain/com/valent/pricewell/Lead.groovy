package com.valent.pricewell

import java.util.Date;

class Lead 
{
	User assignTo;
	String firstname; 
	String lastname;   
	String title;       
	String company;     
	String status;      
	String email;       
	String altEmail;
	String phone;
	String mobile;
	String iso
	String format
	//String address;
	Date dateCreated;
	User createdBy;
	Date dateModified;
	User modifiedBy;
	BillingAddress billingAddress;
	Contact contact
	Staging stagingStatus;
	int currentStep = 1;

    static constraints = 
	{
		assignTo(nullable: true)
		firstname(nullable: false, blank: false)
		lastname(nullable: true)
		title(nullable: true)
		company(nullable: true)
		status(nullable: false)
		phone(nullable: false)
		mobile(nullable: true)
		iso(nullable: true)
		format(nullable: true)
		//address(nullable: true)
		altEmail(nullable: true)
		dateCreated()
		dateModified()
		billingAddress(nullable: true)
		modifiedBy(nullable: true)
		stagingStatus(nullable: true)
		contact(nullable: true)
		generalStagingLogs(nullable: true)
	}
	
	static mapping = {
		billingAddress lazy:false
		contact lazy:false
	}
	
	static hasMany = [generalStagingLogs: GeneralStagingLog]
	
	String toString()
	{
		"${this.firstname} ${this.lastname}"
	}
	
}
