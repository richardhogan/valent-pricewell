package com.valent.pricewell

class ServiceProfileMetaphors {

	Setting definitionString
	Integer sequenceOrder
	MetaphorsType type
	
	enum MetaphorsType {PRE_REQUISITE, POST_REQUISITE, OUT_OF_SCOPE}
	
    static constraints = {
		definitionString(nullable: true)
		serviceProfile(nullable: true)
		sequenceOrder(nullable: true)
		type(nullable: false)
    }
	
	static belongsTo = [serviceProfile: ServiceProfile]
}
