package com.valent.pricewell

import org.apache.shiro.SecurityUtils

class NavigationController {
	static navigation = [
		[group:'navigation', action:'home', order: 0],
		[action:'reviewBoard', order: 1, title: "Inbox"],
	/*	[action:'administration', order: 2, isVisible: {SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR")},
			subItems: [
						[action:'manageRoles', order:2],
						[action:'manageUsers', order:10]
						]], */
		[action:'deliveryRoles', order: 3, isVisible: {!SecurityUtils.subject.hasRole("SALES PERSON")}],
		[action:'portfolio', order: 5, isVisible: {!SecurityUtils.subject.hasRole("PRODUCT MANAGER") && !SecurityUtils.subject.hasRole("SALES PERSON") && !SecurityUtils.subject.hasRole("SERVICE DESIGNER")}],
		[action:'services', title: 'Service Catalog', order: 10, isVisible: {true}],
		[action:'reports', order: 25, isVisible: {SecurityUtils.subject.isPermitted("reports:show")}],
		[action:'accounts', order: 35, isVisible: {SecurityUtils.subject.hasRole("GENERAL MANAGER") || SecurityUtils.subject.hasRole("SALES PERSON") || SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("SALES PRESIDENT") || SecurityUtils.subject.hasRole("SALES MANAGER")}],
		[action:'contacts', order: 45, isVisible: {SecurityUtils.subject.hasRole("GENERAL MANAGER") || SecurityUtils.subject.hasRole("SALES PERSON") || SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("SALES PRESIDENT") || SecurityUtils.subject.hasRole("SALES MANAGER")}],
		[action:'leads', order: 55, isVisible: {SecurityUtils.subject.hasRole("GENERAL MANAGER") || SecurityUtils.subject.hasRole("SALES PERSON") || SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("SALES PRESIDENT") || SecurityUtils.subject.hasRole("SALES MANAGER")}],
		[action:'opportunities', order: 65, isVisible: {SecurityUtils.subject.hasRole("GENERAL MANAGER") || SecurityUtils.subject.hasRole("SALES PERSON") || SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("SALES PRESIDENT") || SecurityUtils.subject.hasRole("SALES MANAGER")}]
		
	]

	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}
	
    def index = { }
	
	def home = {
			saveNavigationState()
			redirect(controller: "home")
		}
	
	
	
	def administration = {
		saveNavigationState()
		if(session["administration"])
		{
			redirect(uri: session["administration"])
			return
		}
		redirect(controller: "admins")
	}
	
	def accounts = {
		saveNavigationState()
//		
		redirect(controller: "account", action: "list")
	}
	
	def leads = {
		saveNavigationState()
//		
		redirect(controller: "lead", action: "list")
	}
	
	def contacts = {
		saveNavigationState()
		redirect(controller: "contact", action: "list")
	}
	
	def opportunities = {
		saveNavigationState()
		redirect(controller: "opportunity", action: "list")
	}
	def portfolio = {
		saveNavigationState()
//		if(session["portfolio"])
//		{
//			redirect(uri: session["portfolio"])
//			return
//		}
		redirect(controller: "portfolio", action: "list")
	}
	
	def services = {
		saveNavigationState()
//		if(session["service"])
//		{
//			redirect(uri: session["service"])
//			return
//		}
		redirect(controller: "service")
	}
	
	def reviewBoard = {
		session["reviewShowSource"] = "reviewBoard";
		saveNavigationState()
		if(session["reviewRequest"])
		{
			redirect(uri: session["reviewRequest"])
			return
		}
		redirect(controller: "reviewRequest")
	}
	
	def deliveryRoles = {
		saveNavigationState()
		if(session["deliveryRole"])
		{
			redirect(uri: session["deliveryRole"])
			return
		}
		redirect(controller: "deliveryRole")
	}
	
	def quoteServices = {
		saveNavigationState()
		/*if(session["quotation"])
		{
			redirect(uri: session["quotation"])
			return
		}*/
		redirect(controller: "quotation")
	}
	
	def reports = {
		saveNavigationState()
		if(session["reports"])
		{
			redirect(uri: session["reports"])
			return
		}
		redirect(controller: "reports", action:"statusOfQuotes")
	}
	
	def manageRoles = {
		redirect(controller: "role")
	}
	
	def manageUsers = {
		redirect(controller: "user")
	}
	
	void saveNavigationState()
	{
		session["forwardURI"] = request.forwardURI
		def targetURI = getTargetURI()
		
		String controller = getController(targetURI)
		String tmpName= ""
		
		switch(controller)
		{
			case "service":
				tmpName = "service"
				break
			case "portfolio":
				tmpName = "portfolio"
				break
			case ["administration","role","user"]:
				tmpName = "administration"
				break
			case ["deliveryRole", "geo"]:
				tmpName = "deliveryRole"
				break
			case ["reviewRequest", "reviewComment"]:
				tmpName = "reviewRequest"
				break
			case ["quotation"]:
				tmpName = "quotation"
				break
			case ["reports"]:
				tmpName = "reports"
				break
		}
		
		if(tmpName == "")
		{ 
			return
		}
		session[tmpName] = targetURI;		
	}
	
	String getController(String URI)
	{		
		List lst = URI.split("/");
		if(lst.size() > 1)
		{
			return lst[1]
		}
		else
		{
			return ""
		}
	}
	
	String getTargetURI()
	{
		def baseURL = request.getRequestURL().toString() - request.getRequestURI()
		return (request.getHeader("Referer") - request.contextPath) - baseURL
	}
} 
