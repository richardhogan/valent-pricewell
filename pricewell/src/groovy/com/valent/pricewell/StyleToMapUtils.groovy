package com.valent.pricewell

public class StyleToMapUtils {
	
	// This helper function parses the RTE css style text into a Map for us.
	// - How to use
	//      Map<String, String> parsed = StyleToMapUtils.transformStyleToMap
	// - Sample style string
	//      style="margin-left: 30px;"
	
	public static Map<String, String> transformStyleToMap(String styleString)
	{
	   Map<String, String> map = new HashMap<String, String>();
	   
	   try {
		  // - How does it work?
		  //   + Splitting on semicolon (;) to tokenize the data.
		  //   + Use "trim()" to omit leading and trailing whitespace.
		  //   + 7 to remove 'style="'
		  //   + 1 to remove '"'
		  // - The result
		  //      margin-left:
		  //      30px
		   
		  String[] tokens = styleString.trim().substring(7, styleString.trim().length() - 1).split(";");
 
		  for (int i = 0; i < tokens.length; i += 1) {
			  
			  String[] secondSplitTokens = tokens[i].trim().split(":")
			  // key: margin-left
			  String key = secondSplitTokens[0].trim();
 
			  // Value: 30px
			  String val = secondSplitTokens[1].trim();
 
			  // - Result
			  //     Map item: ('margin-left', '30px')
			  map.put(key, getStylePropertiesValue(key, val));
		  }
	   }
	   catch (StringIndexOutOfBoundsException e)
	   {
		  System.err.println(styleString);
	   }
	   return map;
	}
	
	public static String getStylePropertiesValue(String prop, String value)
	{
		switch(prop)
		{
			case "margin-left":
				return value.contains("px") ? value.split("px")[0]: value
			default :
				return ""
		}
	}
 }