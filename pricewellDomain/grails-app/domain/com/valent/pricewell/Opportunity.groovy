package com.valent.pricewell

import java.util.Date;

class Opportunity 
{
	User assignTo;
	String name;
	int probability = 0;
	double amount = 0;     
	int discount = 0;   
	Date closeDate;  
	Date dateCreated;
	User createdBy;
	Date dateModified;
	User modifiedBy;
	Account account;
	Geo geo;
	Staging stagingStatus;
	int currentStep = 1;
	Contact primaryContact
	String notes;
	
	String externalId
	String externalSource
	
    static constraints = 
	{
		assignTo(nullable: true)
		name(nullable: false, blank: false)
		probability(nullable: true)
		amount(nullable: true)
		discount(nullable: true)
		closeDate(nullable: true)
		dateCreated()
		dateModified()
		createdBy(nullable: false)
		modifiedBy(nullable: true)
		account(nullable: true)
		geo(nullable: true)
		stagingStatus(nullable: true)
		quotations(nullable: true)
		//contacts(nullable: true)
		primaryContact(nullable: true)
		notes(nullable: true, maxSize: 104800)
		generalStagingLogs(nullable: true)
		comments(nullable : true)
		
		externalId(nullable: true)
		externalSource(nullable: true)
    }
	
	static mapping = {
		account lazy:false
		primaryContact lazy:false
		//notes type: "text"
		
		//externalId column:'External_Id', index: 'External_Idx'
	}
	
	//static belongsTo = [contact: Contact], contacts: Contact
	
	def latestQuotations = {
		return Quotation.findAll("from Quotation q where q.opportunity.id = :oid order by q.modifiedDate desc", [oid: this.id])
	}
	
	def listNotes = {
		return Note.findAll("from Note n where n.opportunity.id = :oid order by n.modifiedDate desc", [oid: this.id])
	}
	
	def archivedQuotatinos = {
		
	}
	

	static hasMany = [quotations: Quotation, generalStagingLogs: GeneralStagingLog, comments: Note]
	
	String toString()
	{
		"${this.name}"
	}
	
}
