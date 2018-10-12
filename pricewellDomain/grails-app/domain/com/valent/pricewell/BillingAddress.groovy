package com.valent.pricewell

class BillingAddress 
{
	
	String billAddressLine1;
	String billAddressLine2;
	String billCity;
	String billState;
	
	String billPostalcode;
	String billCountry;
	//static belongsTo = Contact
    static constraints = 
	{
		billCountry(nullable: true)
		billAddressLine1(nullable: true)
		billAddressLine2(nullable: true)
		billState(nullable: true)
		billCity(nullable: true)
		billPostalcode(nullable: true)
    }
	
}
