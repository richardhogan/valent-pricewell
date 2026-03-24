package com.valent.pricewell
// MIGRATION (Nimble→Spring Security): removed Apache Shiro imports; using PricewellSecurity helper instead
import com.valent.pricewell.PricewellSecurity

class NavigationController {
	def debug() {
		def user = PricewellSecurity.currentUser  // was: User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}
	
    def index() { }
	def home() {
			saveNavigationState()
			redirect(controller: "home")
		}
	
	
	
	def administration() {
		saveNavigationState()
		if(session["administration"])
		{
			redirect(uri: session["administration"])
			return
		}
		redirect(controller: "admins")
	}
	
	def accounts() {
		saveNavigationState()
//		
		redirect(controller: "account", action: "list")
	}
	
	def leads() {
		saveNavigationState()
//		
		redirect(controller: "lead", action: "list")
	}
	
	def contacts() {
		saveNavigationState()
		redirect(controller: "contact", action: "list")
	}
	
	def opportunities() {
		saveNavigationState()
		redirect(controller: "opportunity", action: "list")
	}
	def portfolio() {
		saveNavigationState()
//		if(session["portfolio"])
//		{
//			redirect(uri: session["portfolio"])
//			return
//		}
		redirect(controller: "portfolio", action: "list")
	}
	
	def services() {
		saveNavigationState()
//		if(session["service"])
//		{
//			redirect(uri: session["service"])
//			return
//		}
		redirect(controller: "service")
	}
	
	def reviewBoard() {
		session["reviewShowSource"] = "reviewBoard";
		saveNavigationState()
		if(session["reviewRequest"])
		{
			redirect(uri: session["reviewRequest"])
			return
		}
		redirect(controller: "reviewRequest")
	}
	
	def deliveryRoles() {
		saveNavigationState()
		if(session["deliveryRole"])
		{
			redirect(uri: session["deliveryRole"])
			return
		}
		redirect(controller: "deliveryRole")
	}
	
	def quoteServices() {
		saveNavigationState()
		/*if(session["quotation"])
		{
			redirect(uri: session["quotation"])
			return
		}*/
		redirect(controller: "quotation")
	}
	
	def reports() {
		saveNavigationState()
		if(session["reports"])
		{
			redirect(uri: session["reports"])
			return
		}
		redirect(controller: "reports", action:"statusOfQuotes")
	}
	
	def manageRoles() {
		redirect(controller: "role")
	}
	
	def manageUsers() {
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
