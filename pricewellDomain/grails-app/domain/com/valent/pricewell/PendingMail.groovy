package com.valent.pricewell

class PendingMail 
{
	String emailId
	String message
	String subject
	String url
	Date createDate
	boolean active = true
	int activeBit = 1;
	String status = "pending"
	
    static constraints = {
		emailId(nullable: false)
		message(nullable: false)
		subject(nullable: false)
		url(nullable: true)
		status(nullable: true)
		createDate()
    }
}
