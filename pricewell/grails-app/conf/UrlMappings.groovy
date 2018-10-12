class UrlMappings {

	static mappings = {
		"/$controller/$action?/$id?"{
			constraints {
				// apply constraints here
			}
		}

		"/"
		 {
		    controller = "home"
		 }
		 
		 "500"(controller: 'errors', action: 'handle')
		//"500"(view:'/error')
	}
}
