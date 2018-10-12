package com.valent.pricewell

//Only used to store big text values.
class Setting {
    String name;
	String value;
	
	static constraints = {
		value(maxSize: 2048000)
	}
	
	static mapping = {
		value type: "text"
	}
}
