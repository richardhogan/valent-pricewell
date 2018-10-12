package com.valent.pricewell

class RelationDeliveryGeo {
	BigDecimal costPerDay = 0;
	BigDecimal ratePerDay = 0;

    static constraints = {
	
    }
	
    static belongsTo = [geo: Geo, deliveryRole: DeliveryRole ]
}
