package com.valent.pricewell
import java.util.Map;

class EmailSetting {
	
	String name;
	String value;
	String secret = "false";
	
	static constraints = {
		
	}
	
	static mapping = {
		value type: "text"
	}
}
