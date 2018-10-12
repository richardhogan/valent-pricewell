package com.valent.pricewell.util

enum RoleEnum {
	SYSTEM_ADMINISTRATOR("SYSTEM ADMINISTRATOR"),
	PORTFOLIO_MANAGER("PORTFOLIO MANAGER"),
	PRODUCT_MANAGER("PRODUCT MANAGER"),
	SERVICE_DESIGNER("SERVICE DESIGNER"),
	DELIVERY_ROLE_MANAGER("DELIVERY ROLE MANAGER"),
	SALES_PRESIDENT("SALES PRESIDENT"),
	GENERAL_MANAGER("GENERAL MANAGER"),
	SALES_MANAGER("SALES MANAGER"),
	SALES_PERSON("SALES PERSON"),
	USER("USER");
	
	String role;
	RoleEnum(String s){
		this.role = s;
		PricewellUtils.addRole(s, this);
	}
	
	public String value() {
		return this.role;
	}
	
	public String toString() {
		println "to string is called "+this.role
		return this.role;
	}
}