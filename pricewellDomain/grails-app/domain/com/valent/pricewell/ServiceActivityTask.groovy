package com.valent.pricewell

class ServiceActivityTask {

	String task
	Integer sequenceOrder
	
    static constraints = {
		task(maxSize: 2048000, nullable:true)
		sequenceOrder(nullable: true)
		serviceActivity(nullable: true)
    }
	
	static mapping = {
		task type: "text"
	}
	
	static belongsTo = [serviceActivity: ServiceActivity]
}