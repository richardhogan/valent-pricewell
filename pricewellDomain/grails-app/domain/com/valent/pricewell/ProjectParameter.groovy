package com.valent.pricewell

class ProjectParameter {

	String value;
	Integer sequenceOrder
	
	static constraints = {
		value(maxSize: 2048000)
		sequenceOrder(nullable: true)
	}
	
	static mapping = {
		value type: "text"
	}

	static belongsTo = [quotation: Quotation]
}
