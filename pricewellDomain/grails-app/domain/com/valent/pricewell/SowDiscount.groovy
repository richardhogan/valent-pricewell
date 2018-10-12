package com.valent.pricewell

class SowDiscount {

	String description
	BigDecimal amount
	BigDecimal amountPercentage
	
	Boolean isGlobal = false
	
    static constraints = {
		description(maxSize: 2048000, nullable: true)
		amount(nullable: true)
		amountPercentage(nullable: true)
		isGlobal(nullable:true)
		territories(nullable: true)
		quotations(nullable: true)
    }
	
	static mapping = {
		description type: "text"
	}
	
	static belongsTo = [Quotation, Geo]
	
	static hasMany = [quotations: Quotation, territories: Geo]
	
	static mappedBy = [quotations: "sowDiscounts", territories: "sowDiscounts"]
}
