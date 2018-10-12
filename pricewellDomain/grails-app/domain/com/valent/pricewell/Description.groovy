package com.valent.pricewell

class Description {

	String name
	String value
	
	
    static constraints = {
		value(maxSize: 2048000, nullable: true)
		name(nullable: true)
    }
	
	static mapping = {
		value type: "text"
	}
	
	public void setDeliverableDescriptionName(String serviceName, Long serviceProfileId, String deliverableName, Long deliverableId)
	{
		name = "Description of Deliverable : #${deliverableId} " + deliverableName + " And Service Profile : #${serviceProfileId} " + serviceName
	}
	
	public void setValue(String descriptionValue)
	{
		value = descriptionValue
	}
}
