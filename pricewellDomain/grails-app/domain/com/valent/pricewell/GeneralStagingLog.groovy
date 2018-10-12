package com.valent.pricewell

import java.util.Date;


class GeneralStagingLog {

	Object object
    Date dateModified;
	String action
	Staging fromStage
	Staging toStage 
	String comment
	String modifiedBy
	int revision
	enum StagingLogObjectType { LEAD, OPPORTUNITY, QUOTATION, CONTRACT}
	
    static constraints = {
		object(nullable: true)
		dateModified()
		fromStage(nullable: true)
		toStage(nullable: true)
    }
	
	static belongsTo = [type: StagingLogObjectType]
}
