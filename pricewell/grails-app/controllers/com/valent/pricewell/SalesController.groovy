package com.valent.pricewell
import org.apache.shiro.SecurityUtils

class SalesController {

	def salesCatalogService// = new SalesCatalogService()
    def index = { }
	
	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}
	
	def getUserTerritoriesForQuota = {
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
		render(template: "/sales/displayUserTerritoriesForQuota", model: [ territoryList: territoryList ])
	}
	
	public def generateAssignedToList(def selectId)
	{
		Map salesUsersMap = salesCatalogService.getMapOfAssignedToSalesUsers()
		
		def content = g.render(template: "/sales/selectOptionOfAssignedToUsers",  model: [selectId: selectId, sPresidents : salesUsersMap['sPresidents'], gManagers : salesUsersMap['gManagers'],
																							 sManagers : salesUsersMap['sManagers'], sPersons : salesUsersMap['sPersons']])
		
		return content
	}
	
	public def generateAssignedToListForNewObject()
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))
		Map salesUsersMap = salesCatalogService.getMapOfAssignedToSalesUsers()
		
		def content = g.render(template: "/sales/selectOptionOfAssignedToUsers",  model: [selectId: user.id, sPresidents : salesUsersMap['sPresidents'], gManagers : salesUsersMap['gManagers'],
																							 sManagers : salesUsersMap['sManagers'], sPersons : salesUsersMap['sPersons']])
		
		return content
	}
	
	public def generateAssignedToListForQuota()
	{
		def selectId = null
		Map salesUsersMap = salesCatalogService.getAssignedToSalesUserForQuota()
		
		def content = g.render(template: "/sales/selectOptionOfAssignedToUsersForQuota",  model: [selectId: selectId, sPresidents : salesUsersMap['sPresidents'], gManagers : salesUsersMap['gManagers'],
																							 sManagers : salesUsersMap['sManagers'], sPersons : salesUsersMap['sPersons']])
		
		return content
	}
	
	public boolean isConnectwiseIncluded()
	{
		//boolean isForConnectwise = false
		
		return salesCatalogService.isClass("com.connectwise.integration.ConnectwiseExporterService", grailsApplication)
	}
	
	public boolean isSalesforceIncluded()
	{
		//boolean isForConnectwise = false
		
		return salesCatalogService.isClass("com.salesforce.integration.SalesforceExportService", grailsApplication)
	}
	
	public boolean isQuoteForConnectwiseOpportunity(def id)
	{
		Quotation quote = Quotation.get(id)
		if(quote.contractStatus.name == 'Accepted' && quote.opportunity.externalId !='' && quote.opportunity.externalId != null)
		{
			if(quote.convertToTicket != 'yes')
			{
				return true
			}
		}
		return false
	}
	
	public boolean isSalesPerson(def userId)
	{
		User user = User.get(userId.toLong())
		if(salesCatalogService.checkUserRoleCode(user, RoleId.SALES_PERSON.code))
			return true
		return false
	}
	
	public def convertAmountToUserCurrency(def userId, BigDecimal amount)
	{
		User user = User.get(userId.toLong())
		if(user?.territory != null && user?.territory != "")
		{
			return amount.multiply(user?.territory?.convert_rate).setScale(0, BigDecimal.ROUND_HALF_EVEN);
		}
		return amount.setScale(0, BigDecimal.ROUND_HALF_EVEN);
	}
}
