package com.valent.pricewell

class ShippingAddress 
{
	
	String shipAddressLine1;
	String shipAddressLine2;
	String shipCity;
	String shipState;
	
	String shipPostalcode;
	String shipCountry;
    static constraints =
	{
		shipCountry(nullable: true)
		shipAddressLine1(nullable: true)
		shipAddressLine2(nullable: true)
		shipState(nullable: true)
		shipCity(nullable: true)
		shipPostalcode(nullable: true)
    }
	
}
