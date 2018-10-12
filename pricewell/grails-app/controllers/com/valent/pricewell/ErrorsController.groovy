package com.valent.pricewell
import grails.converters.JSON
import org.apache.shiro.SecurityUtils

class ErrorsController {

    def index = { }
	
	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		def user = User.get(new Long(SecurityUtils.subject.principal))
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
