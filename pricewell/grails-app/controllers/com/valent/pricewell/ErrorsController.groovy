package com.valent.pricewell
// MIGRATION (Nimble→Spring Security): removed Apache Shiro imports; using PricewellSecurity helper instead
import com.valent.pricewell.PricewellSecurity
import grails.converters.JSON
class ErrorsController {

    def index = { }
	
	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		def user = PricewellSecurity.currentUser  // was: User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}
	
	def handle = {
		def exception = request.exception.cause.class
		
		
		if(request.exception?.cause instanceof org.hibernate.HibernateException ){
			
			StringBuilder sb = new StringBuilder();
			sb.append("Error occured at time: " + new Date() + " \n");
			sb.append("Request Object: " + "\n");
			
			sb.append(org.apache.commons.lang.builder.ReflectionToStringBuilder.toString(request) + "\n");
			//sb.append(request as JSON + "\n");
			sb.append("Exception FullStackTrace:" + "\n")
			sb.append(org.apache.commons.lang.exception.ExceptionUtils.getFullStackTrace(request.exception?.cause));
		    print sb.toString()
			render(view: '/errors', str: sb.toString())
		} else {
		render(view: '/error', exception: request.exception)
		}
			
	}
}
