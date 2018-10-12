package com.valent.pricewell



public interface SubstituionMapGenerator {
	Map<String, String> generateStringSubstutionMap();
	Map<String, List<Object>> generateSubstutionMap();
}
