package com.valent.pricewell

class ReviewRequest {

	String subject
	String description
	Date dateCreated
	Date dateModified
	boolean open = true
	Status status = Status.REVIEW
	User submitter
	Staging fromStage
	Staging toStage
	
	
	enum Status {REVIEW,APPROVED,REJECTED,CANCELLED}
	
    static constraints = {
		subject(nullable: false)
		description(nullable: true)
		dateCreated(nullable: false)
		dateModified(nullable: true)
		submitter(nullable: false)
		assignees(nullable: false)
		dateCreated()
		dateModified()
		fromStage(nullable: true)
		toStage(nullable: true)
		
		serviceProfile(nullable: true)
		quotation(nullable: true)
    }
	
	static belongsTo = [serviceProfile: ServiceProfile, quotation: Quotation]
	
	static hasMany = [ 	assignees: User, reviewComments: ReviewComment]
	
	static mapping = {
		sort id:'desc'
	}
	
	List listReviewComments(){
		return ReviewComment.findAll("from ReviewComment c where c.reviewRequest.id=:id order by dateCreated desc", [id:this.id ])
		
		}
}
