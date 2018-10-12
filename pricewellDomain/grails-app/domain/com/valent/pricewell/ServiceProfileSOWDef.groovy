package com.valent.pricewell;

public class ServiceProfileSOWDef {
	    ServiceProfile sp;
	    Geo geo;
	    String part;
		Setting definitionSetting
		
	    String definition;
	   
	    static constraints = {
	    	geo(nullable: true)
	    	part(nullable: true)
			definition(nullable: true)
			sp(nullable: true)
	    }
		
}
