package com.valent.pricewell

class SowTag{

	Quotation quotation;
	String tagName;
	String tagValue;
	
	static belongsTo = [quotation: Quotation]
	
	static constraints = {
		quotation(nullable: false)
		tagName(nullable: false)
		tagValue(nullable: false, maxSize: 204800)
	}
	
	static mapping = {
		tagValue type: "text"
	}
	
}
