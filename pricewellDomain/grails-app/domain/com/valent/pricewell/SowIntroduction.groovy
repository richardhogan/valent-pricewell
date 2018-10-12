package com.valent.pricewell

class SowIntroduction {
	
	String name;
	String sow_text;
	Geo geo;
	
	static constraints = {
		
		name(nullable: true)
		sow_text(maxSize: 2048000)
		geo(nullable: true)
	}
		
	static mapping = {
		sow_text type: "text"
	}
	
	String toString()
	{
		return name
	}
}
