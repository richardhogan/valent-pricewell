package com.valent.pricewell

class CorrectionInActivityRoleTime {

    DeliveryRole role
	BigDecimal extraHours;
	BigDecimal originalHours;
	boolean deleted
	
	ServiceActivity serviceActivity
	
	static belongsTo = [serviceQuotation : ServiceQuotation]
    
	static constraints = {
		extraHours(nullable: true)
		originalHours(nullable: true)
		serviceActivity(nullable: true)
		serviceQuotation(nullable: true)
    }
	
	static mappedBy = [serviceQuotation: 'correctionsInRoleTime']
	
	static transients = [ 'deleted' ]
}
