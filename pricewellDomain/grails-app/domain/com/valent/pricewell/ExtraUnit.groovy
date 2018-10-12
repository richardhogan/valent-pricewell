package com.valent.pricewell


class ExtraUnit {

	String unitOfSale
	Integer extraUnit
	String shortName
	//ServiceProfile serviceProfile
	
	static constraints = {
		unitOfSale(nullable: false)
		extraUnit(nullable: false)
		shortName(nullable: true)
		serviceProfile(nullable:true)
	}
	
	static belongsTo = [serviceProfile: ServiceProfile]
	
	static mappedBy = [serviceProfile: 'extraUnits']
	
	List listextraUnit()
	{
		ExtraUnit.findAll("from ExtraUnit eu")
	}
}
