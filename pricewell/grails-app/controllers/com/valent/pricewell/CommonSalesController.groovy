package com.valent.pricewell

import org.apache.shiro.SecurityUtils
class CommonSalesController {

	def salesCatalogService
    def index = { }
	
	def getUserTerritories = {
		User user = null
		if(params.id && params.id != null)
		{
			user = User.get(params.id.toLong())
		}
		else
		{
			user = User.get(new Long(SecurityUtils.subject.principal))
		}
		
		List territoryList = salesCatalogService.findUserTerritories(user)
		render(template: "displayUserTerritories", model: [ territoryList: territoryList ])
	}
}
