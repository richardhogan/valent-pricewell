package com.valent.pricewell

import java.util.List;

class DeliveryRole {
	String name;
	String description;
	
    	static constraints = {
		name(nullable: false)
		description(nullable: true)
		relationDeliveryGeos(nullable: true)
	}
	
	String toString() {
		"${name}"
	}
	
	static hasMany = [relationDeliveryGeos:RelationDeliveryGeo]
	
	List listRateCostsPerGeos(List params)
	{
		def relList =  RelationDeliveryGeo.createCriteria().list(sort: params?.sort)
									{
										eq("deliveryRole.id", this.id)
									}
		return relList
	}
	
	List listUndefinedGeos()
	{
		List unDefinedList = []
		
		for(Geo geo: Geo.list())
		{
			boolean defined = false
			for(RelationDeliveryGeo rel: this.relationDeliveryGeos)
			{
				if(rel.geo.id == geo.id)
				{
					defined = true
					break
				}
			}
			
			if(!defined)
			{
				unDefinedList.add(geo)
			}
		}
		
		return unDefinedList
	}
}
