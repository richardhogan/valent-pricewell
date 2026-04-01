class UrlMappings {

	static mappings = {
		// Administration URLs (ported from NimbleUrlMappings.groovy)
		// Must be before the generic pattern so they match first.
		"/administration/users/$action?/$id?"(controller: "user")
		"/administration/adminstrators/$action?/$id?"(controller: "admins")
		"/administration/groups/$action?/$id?"(controller: "group")
		"/administration/roles/$action?/$id?"(controller: "role")

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

		"500"(view: '/error')
	}
}
