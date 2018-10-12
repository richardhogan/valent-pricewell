package com.valent.pricewell

class ActivityRoleTime {
	DeliveryRole role
	BigDecimal estimatedTimeInHoursPerBaseUnits;
	BigDecimal estimatedTimeInHoursFlat;
	boolean deleted
	
	
    static constraints = {
    }
	
	static belongsTo = [serviceActivity: ServiceActivity]
	
	static transients = [ 'deleted' ]
	
	BigDecimal countTotalHoursForServiceQuotationUnits(BigDecimal totalUnits)
	{
		ServiceProfile serviceProfile = ServiceProfile.get(this.serviceActivity.serviceDeliverable.serviceProfile.id)
		
		BigDecimal baseUnits = serviceProfile.baseUnits
		BigDecimal additionalUnits = new BigDecimal(0)
		
		BigDecimal flatHours = this.estimatedTimeInHoursFlat
		BigDecimal extraHours = this.estimatedTimeInHoursPerBaseUnits
		
		BigDecimal totalHours = new BigDecimal(0)
		
		if(totalUnits >= baseUnits)
		{
			additionalUnits = totalUnits - baseUnits
			
			totalHours = flatHours + (additionalUnits * extraHours)
		}
		
		return totalHours
	}
}
