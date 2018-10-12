package com.valent.pricewell

class TextTemplate {

	String name;
	String text;
	Date dateCreated;
	Date dateModified;
	Geo geo;
	TemplateType type = TemplateType.SOW;  
	
	enum TemplateType {SOW} 
	
    static constraints = {
		geo(nullable: true)
    }
	
}
