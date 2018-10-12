package com.valent.pricewell

import org.apache.commons.collections.list.LazyList;
import org.apache.commons.collections.FactoryUtils;


class ServiceActivity {
	String name;
	String description;
	BigDecimal estimatedTimeInHoursPerBaseUnits;
	BigDecimal estimatedTimeInHoursFlat;
	String category;
	String results
	int sequenceOrder
	 
	//List rolesEstimatedTime = new ArrayList();
	
/*	public List getRolesEstimatedTime() {
		return new ArrayList(this.rolesEstimatedTime);	
	};*/
	
	static constraints = {
		name(nullable: false)
		description(nullable: true)
		estimatedTimeInHoursPerBaseUnits(nullable: true)
		estimatedTimeInHoursFlat(nullable: true)
		category(nullable: false)
		results(nullable: true)
		activityTasks(nullable:true)
	}
	
	static belongsTo = [serviceDeliverable: ServiceDeliverable]
	
	static hasMany = [rolesRequired: DeliveryRole,
						rolesEstimatedTime: ActivityRoleTime, 
						activityTasks: ServiceActivityTask]
							
	static mapping = {
		rolesEstimatedTime cascade:"all-delete-orphan"
		activityTasks sort: 'sequenceOrder'
	}
	
	static mappedBy = [rolesEstimatedTime: 'serviceActivity']
	
	
	
	
	String toString() {
		"${name}"
	}
	
}
