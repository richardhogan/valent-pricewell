package com.valent.pricewell

class TimeStampSaverObject {
	
	Date fromDate
	Date toDate
	String objectName
	User modifiedBy
	Date modifiedDate

    static constraints = {
		fromDate(nullable: true)
		toDate(nullable: true)
		objectName(nullable: true)
		modifiedBy(nullable: true)
		modifiedDate(nullable: true)
    }
}
