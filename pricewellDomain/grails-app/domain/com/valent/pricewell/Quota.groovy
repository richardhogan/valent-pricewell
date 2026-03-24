package com.valent.pricewell

class Quota {

	BigDecimal amount
	String timespan
	String currency
	User createdBy
	Geo territory
	Date fromDate
	Date toDate
	static belongsTo = [person: User]
    
	static constraints = {
		amount(nullable: true)
		timespan(nullable: true)
		currency(nullable: true)
		createdBy(nullable: true)
		fromDate(nullable: true)
		toDate(nullable: true)
		person(nullable: true)
		territory(nullable: true)
    }
	
	static mappedBy = [person: "quotas"]
}
