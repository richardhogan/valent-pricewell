package com.valent.pricewell

import java.util.Date;

class SalesforceCredentials {

	String username
	String password
	String securityToken
	String instanceUri
	
	User createdBy
	User modifiedBy
	Date modifiedDate
	Date createdDate
	
    static constraints = {
		username(nullable: true)
		password(nullable: true)
		securityToken(nullable:true)
		instanceUri(nullable: true)
		
		createdBy(nullable: true)
		modifiedBy(nullable: true)
		modifiedDate(nullable: true)
		createdDate(nullable: true)
    }
}
