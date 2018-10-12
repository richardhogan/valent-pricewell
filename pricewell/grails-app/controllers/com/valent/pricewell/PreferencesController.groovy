package com.valent.pricewell

class PreferencesController {

    def listServiceStages = {     
        [stagingInstanceList: Staging.listAllServiceStages()]
    }
	
	def editServiceStages = {
		
	}
	
	def saveServiceStages = {
		
	}
}
