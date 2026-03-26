class UrlMappings {

	static mappings = {
		"/$controller/$action?/$id?"{
			constraints {
				// apply constraints here
			}
		}

		"/"(controller: "home", action: "index")

		// Auth endpoints replacing the Nimble plugin's NimbleUrlMappings.groovy.
		// Spring Security Core intercepts POST /j_spring_security_check internally;
		// these mappings only cover the login page render, logout, and access-denied views.
		"/auth/login" (controller: "auth", action: "login")
		"/auth/logout"(controller: "auth", action: "logout")
		"/auth/denied"(controller: "auth", action: "denied")

		"500"(controller: 'errors', action: 'handle')
	}
}
