package com.valent.pricewell

import java.util.Date;

class Pricelist {

	ServiceProfile serviceProfile
	Geo geo
	BigDecimal basePrice
	BigDecimal additionalPrice
	Date dateModified;
	User modifiedBy
	
	//for edited service quotation isTemporary = "yes"
	String isTemporary = ""
	
    static constraints = {
		modifiedBy(nullable: true)
		isTemporary(nullable: true)
    }
}
