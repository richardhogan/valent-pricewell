package com.valent.pricewell

class GeoGroup {

	String name;
	String description;
	//User generalManager
	
    static constraints = {
		name(nullable: false)
		description(nullable: true)
		geos(nullable: true)
		generalManagers(nullable: true)
    }
	
	static hasMany = [geos:Geo, generalManagers: User]
	
	static mappedBy = [generalManagers: "geoGroup"]
	
	String toString()
	{
		return name
	}
}
