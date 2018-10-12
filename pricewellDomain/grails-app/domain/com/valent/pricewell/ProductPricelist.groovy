package com.valent.pricewell

import java.util.Date;

class ProductPricelist {

	Geo geo
	BigDecimal unitPrice
	Date dateModified;
	User modifiedBy
	
    static constraints = {
		modifiedBy(nullable: true)
    }

	static belongsTo = [product: Product]
}
