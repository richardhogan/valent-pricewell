package com.valent.pricewell
// MIGRATION (Nimble→Spring Security): removed Apache Shiro imports; using PricewellSecurity helper instead
import com.valent.pricewell.PricewellSecurity
import grails.converters.JSON
class ErrorsController {

    def index() { }
	def debug() {
		def user = PricewellSecurity.currentUser  // was: User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}
	
	def handle() {
		def ex = request.exception
		if (ex == null) {
			render(view: '/error')
			return
		}
		def cause = ex.cause
		if (cause instanceof org.hibernate.HibernateException) {
			StringBuilder sb = new StringBuilder()
			sb.append("Error occurred at time: " + new Date() + " \n")
			sb.append("Request Object: \n")
			try {
				sb.append(org.apache.commons.lang.builder.ReflectionToStringBuilder.toString(request) + "\n")
			} catch (Exception ignored) {}
			sb.append("Exception FullStackTrace:\n")
			sb.append(org.apache.commons.lang.exception.ExceptionUtils.getFullStackTrace(cause))
			print sb.toString()
			render(view: '/errors', model: [str: sb.toString()])
		} else {
			render(view: '/error', model: [exception: ex])
		}
	}
}
