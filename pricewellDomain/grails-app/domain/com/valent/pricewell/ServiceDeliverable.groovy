package com.valent.pricewell

import java.util.List;
import java.util.Map;

class ServiceDeliverable {
	int sequenceOrder
	String name;
	String type;
	String description;
	String phase
	Description newDescription
	
    static constraints = {
		name(nullable: false)
		type(nullable: true)
		description(nullable: true)
		phase(nullable: true)
		newDescription(nullable: true)
    }
	
	String toString() {
		"${name}"
	}
	
	static belongsTo = [serviceProfile: ServiceProfile]
	
	static hasMany = [serviceActivities: ServiceActivity]
	
	static mapping = {
		serviceActivities sort: 'sequenceOrder'
	}
	
	List listServiceActivities(Map params)
	{
		String orderByColumn = (params.sort? params.sort: "sequenceOrder")
		String orderType = (params.order? params.order: "asc")
		
		String query= "from ServiceActivity act where act.serviceDeliverable.id = ${this.id} order by ${orderByColumn} ${orderType}"
		
		return ServiceActivity.findAll(query)
	}
	
}
