package com.valent.pricewell
// MIGRATION (Nimble→Spring Security): removed Apache Shiro imports; using PricewellSecurity helper instead
import com.valent.pricewell.PricewellSecurity

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
			user = PricewellSecurity.currentUser  // was: User.get(new Long(SecurityUtils.subject.principal))
		}
		
		List territoryList = salesCatalogService.findUserTerritories(user)
		render(template: "displayUserTerritories", model: [ territoryList: territoryList ])
	}
}
