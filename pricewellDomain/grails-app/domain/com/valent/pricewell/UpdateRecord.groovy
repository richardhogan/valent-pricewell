package com.valent.pricewell

class UpdateRecord {

	String recordType
	Date beginUpdateDate
	Date lastUpdateDate
	String comments
	User updatedBy
	Date dateCreated
	
	static indexes = {
		String recordType

	}
	
    static constraints = {
		recordType(nullable: true)
		beginUpdateDate(nullable: true)
		lastUpdateDate(nullable: true)
		comments(nullable: true)
		updatedBy(nullable: true)
    }
}
