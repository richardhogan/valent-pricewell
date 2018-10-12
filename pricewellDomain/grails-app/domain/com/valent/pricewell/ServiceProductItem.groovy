package com.valent.pricewell;

import java.util.List;

class ServiceProductItem {

	BigDecimal unitsSoldPerBaseUnits
	BigDecimal unitsSoldRatePerAdditionalUnit
	
    static constraints = {
		unitsSoldPerBaseUnits(nullable: true)
    }
	
	static belongsTo = [serviceProfile: ServiceProfile, product: Product]
}
