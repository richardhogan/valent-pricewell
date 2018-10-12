package com.valent.pricewell

import java.util.Date;

class CompanyInformation {

	String name
	//byte[] logo
	LogoImage logo
	String website
	String SMTPserver
	String fromEmail
	String phone
	String mobile
	Date dateCreated
	Date dateModified
	ShippingAddress shippingAddress
	String baseCurrency
	String baseCurrencySymbol
	
    static constraints = {
		name(nullable: false)
		logo(nullable: true)
		website(nullable: true)
		SMTPserver(nullable: true)
		fromEmail(nullable: true)
		phone(nullable: true)
		mobile(nullable: true)
		dateCreated(nullable: true)
		dateModified(nullable: true)
		shippingAddress(nullable: true)
    }
	
	
}
