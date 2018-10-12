package com.valent.pricewell

class TestController {
	SendMailService sendMailService;
	
	def testemail = {
		sendMailService.serviceMethod("Hey what's up?", "Just sending you", params.email)
	}
	
	def emailtest = {
		return []
	}
}
