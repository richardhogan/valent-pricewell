package com.valent.pricewell

class SowSupportParameter {
	
	String name;
	String project_parameter_text;
	Geo geo;
	String type;
	
	static constraints = {
		
		name(nullable: true)
		project_parameter_text(maxSize: 2048000, nullable: true)
		geo(nullable: true)
		type(nullable: true)
	}
		
	String toString()
	{
		return name
	}
	
	static mapping = {
		project_parameter_text type: "text"
	}
}