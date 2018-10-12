package com.valent.pricewell

class Note {

	String notes
	User createdBy
	User modifiedBy
	Date createdDate
	Date modifiedDate	
	
	static mapping = {
	
		}
	
	static constraints = {
		notes(nullable: true)
		
	}
	
	
	static belongsTo = [opportunity: Opportunity]
}