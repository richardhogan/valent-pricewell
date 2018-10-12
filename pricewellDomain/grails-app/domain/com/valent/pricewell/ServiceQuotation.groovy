package com.valent.pricewell

import org.codehaus.groovy.grails.web.json.JSONObject

class ServiceQuotation {
	Service service
	ServiceProfile profile
	int totalUnits = 0
	Integer oldUnits = 0
	Geo geo
	BigDecimal price
	Staging stagingStatus
	String oldStage
	//for correction in service profile activity role time
	String isCorrected
	//Pricelist pricelist
	
	String additionalUnitOfSaleJsonArray
	
	Integer sequenceOrder
	
	
    static constraints = {
		service(nullable: false)
		totalUnits(nullable: true)
		oldUnits(nullable: true)
		geo(nullable: true)
		price(nullable: true)
		quotation(nullable: false)
		stagingStatus(nullable: true)
		isCorrected(nullable: true)
		correctionsInRoleTime(nullable: true)
		oldStage(nullable: true)
		//pricelist(nullable: true)
		
		sequenceOrder(nullable: true)
		additionalUnitOfSaleJsonArray (nullable: true)
    }
	
	static belongsTo = [quotation: Quotation]
	
	static hasMany = [correctionsInRoleTime: CorrectionInActivityRoleTime, serviceQuotationTickets: ServiceQuotationTicket]//[roleTimeCorrections: ActivityRoleTimeCorrection]
	
	static mappedBy = [correctionsInRoleTime: 'serviceQuotation', serviceQuotationTickets: 'serviceQuotation']
}
