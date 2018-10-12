package com.valent.pricewell

class SubStages {
	
		int sequenceNumber
		String displayName
		String name
		
		static belongsTo = [staging: Staging]
		
		static constraints = {
			displayName(nullable: true)
			name(nullable: true)
			sequenceNumber (nullable : true)	
			}	
}
