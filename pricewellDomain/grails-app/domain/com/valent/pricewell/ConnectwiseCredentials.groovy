package com.valent.pricewell

class ConnectwiseCredentials {

	String siteUrl
	String companyId
	String userId
	String password
	
	User createdBy
	User modifiedBy
	Date modifiedDate
	Date createdDate
	
	Integer updateHours
	enum firstUpdateFrom{
		Last_Quarter,
		Last_Year, 
		Last_Month,
		This_Month
	}
	
    static constraints = {
		createdBy(nullable: true)
		modifiedBy(nullable: true)
		modifiedDate(nullable: true)
		createdDate(nullable: true)
		updateHours(nullable: true)
    }
}
