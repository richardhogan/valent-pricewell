package com.valent.pricewell

class FieldMapping {

	String name
	String value
	MappingType type
	
	enum MappingType {TERRITORY}
	
	static constraints = {
		value(maxSize: 2048000)
		type(nullable: false)
    }
	
	static mapping = {
		value type: "text"
	}
}
