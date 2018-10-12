package com.valent.pricewell

import java.util.Date;

class StagingLog {
	
	Date dateModified;
	String action
	Staging fromStage
	Staging toStage 
	String comment
	String modifiedBy
	int revision
	
    static constraints = {
		dateModified()
		fromStage(nullable: true)
		toStage(nullable: true)
    }
	
	static belongsTo = [serviceProfile: ServiceProfile]
}
