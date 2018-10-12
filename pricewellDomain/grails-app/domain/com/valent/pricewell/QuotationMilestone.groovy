package com.valent.pricewell

class QuotationMilestone {

	String milestone
	BigDecimal amount
    BigDecimal percentage
	
	static constraints = {
		milestone(nullable: true)
		percentage(nullable: true)
    }
	
	static belongsTo = [quotation: Quotation]
}
