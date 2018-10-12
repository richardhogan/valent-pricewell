package com.valent.pricewell

class ReviewComment {

	String statusChanged
	String comment
	User submitter
	Date dateCreated
	Date dateModified
	
    static constraints = {
		comment(nullable: false)
		submitter(nullable: false)
		dateCreated(nullable: false)
		dateModified(nullable: true)
		statusChanged(nullable:true)
    }
	
	static belongsTo = [reviewRequest: ReviewRequest]
}
