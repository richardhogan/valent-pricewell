package com.valent.pricewell

class ServiceQuotationTicket {

	DeliveryRole role
	BigDecimal budgetHours;
	BigDecimal actualHours;
	ServiceActivity serviceActivity
	
	String summary
	Integer ticketId
	
	User createdBy
	User modifiedBy
	Date createdDate
	Date modifiedDate
	enum TicketStatusTypes {NEW, ASSIGNED, INPROGRESS, CLOSED}
	
	static belongsTo = [serviceQuotation : ServiceQuotation, status: TicketStatusTypes]
	
    static constraints = {
		summary(nullable: true)
		role(nullable: true)
		budgetHours(nullable: true)
		actualHours(nullable: true)
		serviceActivity(nullable: true)
		serviceQuotation(nullable: true)
		createdBy(nullable:true)
		modifiedBy(nullable:true)
		createdDate(nullable:true)
		modifiedDate(nullable:true)
		ticketId(nullable: true)
    }
	
	static mappedBy = [serviceQuotation: 'serviceQuotationTickets']
}
