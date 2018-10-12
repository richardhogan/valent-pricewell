package com.valent.pricewell
import org.apache.shiro.SecurityUtils

import com.valent.pricewell.util.PricewellUtils;

import grails.converters.JSON
import java.text.SimpleDateFormat

class ChartsController {

    def index = { }
	def chartService
	def opportunityService
	def dateService
	
	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}
		
	def refreshUnassignedExceptionReport = 
	{
		Map unassignedExceptionReport = chartService.getUnassignedExceptionReport()
		render (template: "/reports/unassignExceptionReport", model: [unassignException: unassignedExceptionReport])
	}
	
	def drilldownServiceVariance = {
		//println params
		Opportunity opportunity = Opportunity.get(params.opportunityId?.toLong())
		Service service = Service.findByServiceName(params.serviceName?.toString())
		Map activityRoleHoursMap = chartService.drilldownServiceByOpportunity(service, opportunity)
		//println activityRoleHoursMap
		render (template: "/reports/drilldownServiceVariance", model: [activityRoleHoursMap: activityRoleHoursMap])
	}
	
	def drilldownActivityRoleTime = {
		//println params
		Opportunity opportunity = Opportunity.get(params.opportunityId?.toLong())
		Service service = Service.findByServiceName(params.serviceName?.toString())
		String activityRoleString = params.activityRoleString.toString()
		Map activityRoleHoursMap = chartService.drilldownServiceActivityRoleByOpportunity(service, opportunity, activityRoleString)
		//println activityRoleHoursMap
		render (template: "/reports/drilldownActivityRoleTime", model: [activityRoleHoursMap: activityRoleHoursMap])
	}
	
	def getOpportunityServiceVariance = {
		Opportunity opportunity = Opportunity.get(params.opportunityId?.toLong())
		
		Map serviceVarianceMap = new HashMap()
		if(opportunity)
		{
			serviceVarianceMap = chartService.calculateServiceVarianceForOpportunity(opportunity)
		}
		render (template: "/reports/serviceVariance", model: [serviceVarianceMap: serviceVarianceMap])
	}
	
	public String getCurrency()
	{
		def companyInformation
		def currency = "Money"
		if(CompanyInformation.list().size() > 0)
		{
			companyInformation = CompanyInformation.list().get(0)
			if(companyInformation.baseCurrency != null)
					currency = companyInformation.baseCurrency
			
		}
		return currency
	}
	
	def quarterlySales = {
		
		Geo territory = null
		/*if(params.end != null && params.end != "null")
		{
			endDate = dateFormat.parse(params.end);
		}*/
		if(params.territory_id)
		{
			territory = Geo.get(params.territory_id.toLong())
		}
		Map quarterlyTotalSalesMap = chartService.quarterlyTotalSalesByUser(territory)
		
		render (view: "/reports/quarterlyTotalSalesBySalesUser", model: ['quarterlyTotalSalesMap': quarterlyTotalSalesMap, 'currency': getCurrency()])
	}
	def quarterlySaleswithDate = {
		

		Geo territory = null
		PricewellUtils.Println("Territory_Id",params.territory_id)
		if(params.territory_id)
		{
			territory = Geo.get(params.territory_id.toLong())
		}
		Map quarterlyTotalSalesMap = chartService.quarterlyTotalSalesByUserWithDate(territory, params.start, params.end)  
		
		render (view: "/reports/quarterlyTotalSalesBySalesUser", model: ['quarterlyTotalSalesMap': quarterlyTotalSalesMap, 'currency': getCurrency()])
	}
	def dealStatusAging = {
		Map dateMapping=[:]
		Map pendingDaysMap=[:]
		Geo territory = null
		/*if(params.end != null && params.end != "null")
		{
			endDate = dateFormat.parse(params.end);
		}*/
		if(params.territoryId)
		{
			territory = Geo.get(params.territoryId.toLong())
		}
		if(params.end!=null || params.end !='null')
		{
			dateMapping=dateService.getTimespanForQuotaWithDate(params.start, params.end)
			pendingDaysMap = chartService.buildChartDataForQuotesPendingDays(territory,dateMapping['fromDate'],dateMapping['toDate'])
		}
		else
		{
			pendingDaysMap = chartService.buildChartDataForQuotesPendingDays(territory,null,null)
		}
		render (view: "/reports/dealStatusAgingGraph", model: [pendingDaysMap: pendingDaysMap])
	}
	/*********************************Service Sold As Per Portfolio*********************************************/
		
	def serviceSoldPerPortfolio = {
		Date endDate = null
		Map serviceSoldPerPortfolioMap = [:]
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date startDate = dateFormat.parse(params.start);
		def territory_id=(params.territory_id).toLong();
		println params
		Portfolio portfolioInstance = Portfolio.get(params.portfolioId)
		
		if(params.end == null || params.end == "null")
		{
			serviceSoldPerPortfolioMap = chartService.generateServiceSoldPerPortfolioMap(portfolioInstance, startDate, endDate,territory_id)
		}
		else
		{
			endDate = dateFormat.parse(params.end);
			serviceSoldPerPortfolioMap = chartService.generateServiceSoldPerPortfolioMap(portfolioInstance, startDate, endDate,territory_id)
		}
		
		serviceSoldPerPortfolioMap.put("portfolio", portfolioInstance.portfolioName)
		
		def piGraphData = g.render(template: "/reports/serviceSoldPerPortfolioPiGraph", model: [serviceSoldPerPortfolioMap: serviceSoldPerPortfolioMap])
		def lineGraphData = g.render(template: "/reports/serviceSoldPerPortfolioLineGraph", model: [serviceSoldPerPortfolioMap: serviceSoldPerPortfolioMap])
		def portfolioName = portfolioInstance.portfolioName
		
		def returnMap = [:]
		returnMap.put("piGraphData", piGraphData)
		returnMap.put("lineGraphData", lineGraphData)
		returnMap.put("portfolioName", portfolioName)
		
		render returnMap as JSON
	}	
	
	def itCostPerQuotationAndPortfolio = {
		Date endDate = null
		Map itCostPerQuotationMap = [:]
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date startDate = dateFormat.parse(params.start);
		def territory_id=(params.territory_id).toLong();
		println params
		Portfolio portfolioInstance = Portfolio.get(params.portfolioId)   
		
		if(params.end == null || params.end == "null")
		{
			itCostPerQuotationMap = chartService.generateItCostPerQuotationMap(portfolioInstance, startDate, endDate,territory_id)
		}
		else
		{
			endDate = dateFormat.parse(params.end);
			itCostPerQuotationMap = chartService.generateItCostPerQuotationMap(portfolioInstance, startDate, endDate,territory_id)
		}
		
		itCostPerQuotationMap.put("portfolio", portfolioInstance.portfolioName)
		
		def graphData = g.render(template: "/reports/itCostPerQuotationAndPortfolio", model: [itCostPerQuotationMap: itCostPerQuotationMap, currency: params.currency])
		
		def portfolioName = portfolioInstance.portfolioName
		
		def returnMap = [:]
		returnMap.put("graphData", graphData)
		returnMap.put("portfolioName", portfolioName)
		
		render returnMap as JSON
	}
	
	/****************************************Opportunity Funnel Chart*******************************************/
	def opportunityFunnelChart = {
		Date endDate = null
		Map opportunityFunnelData = [:]
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date startDate = dateFormat.parse(params.start);//new Date()
		
		Geo territory = null
		if(params.end != null && params.end != "null")
		{
			endDate = dateFormat.parse(params.end);
		}
		if(params.territoryId)
		{
			territory = Geo.get(params.territoryId.toLong())
		}
		opportunityFunnelData = chartService.getOpportunityFunnelGraphData(startDate, endDate, territory)
		
		render (view: "/reports/opportunityFunnel", model: [opportunityFunnelData: opportunityFunnelData])
	}	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	/****************************************Service Funnel Chart*******************************************/
	def serviceFunnelChart = {
		Date endDate = null
		Map serviceFunnelData = [:]
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date startDate = dateFormat.parse(params.start);
		
		if(params.end == null || params.end == "null")
		{
			serviceFunnelData = chartService.getServiceFunnelGraphData(startDate, endDate)
		}
		else
		{
			endDate = dateFormat.parse(params.end);
			serviceFunnelData = chartService.getServiceFunnelGraphData(startDate, endDate)
		}
		
		render (view: "/reports/serviceFunnel", model: [serviceFunnelData: serviceFunnelData])
	}
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	/****************************************Lead Funnel Chart*******************************************/
	def leadFunnelChart = {
		Date endDate = null
		Map leadFunnelData = [:]
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date startDate = dateFormat.parse(params.start);
		
		if(params.end == null || params.end == "null")
		{
			leadFunnelData = chartService.getLeadFunnelGraphData(startDate, endDate)
		}
		else
		{
			endDate = dateFormat.parse(params.end);
			leadFunnelData = chartService.getLeadFunnelGraphData(startDate, endDate)
		}
		
		render (view: "/reports/leadFunnel", model: [leadFunnelData: leadFunnelData])
	}
	def leadFunnelChartWithDate = {
		Date endDate = null
		Map leadFunnelData = [:]
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date startDate = dateFormat.parse(params.start);
		
		if(params.end == null || params.end == "null")
		{
			leadFunnelData = chartService.getLeadFunnelGraphData(startDate, endDate)   
		}
		else
		{
			endDate = dateFormat.parse(params.end);
			leadFunnelData = chartService.getLeadFunnelGraphData(startDate, endDate)
		}
		
		render (view: "/reports/leadFunnel", model: [leadFunnelData: leadFunnelData])
	}
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
	/*****************************************VSOE Discounting Chart********************************************/
	def VSOEDiscount = {
		Date endDate = null
		Map totaldiscount = [:]
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date startDate = dateFormat.parse(params.start);
		Geo territory = null
		if(params.end != null && params.end != "null")
		{
			endDate = dateFormat.parse(params.end);
		}	
		if(params.territoryId)
		{
			territory = Geo.get(params.territoryId.toLong())
		}
		
		totaldiscount = chartService.countVSOEDiscounting(startDate, endDate, territory)
		
		render (view: "/reports/VSOEDiscounting", model: [totaldiscount: totaldiscount])
	}
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	/**************************************Sales Total Units Sold Graph****************************************/
	def salesTotalUnitsSoldGraph = {
		Date endDate = null
		Map salesTotalUnitsByServiceMap = [:]
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date startDate = dateFormat.parse(params.start);
		def territory_id=(params.territory_id).toLong();
		PricewellUtils.Println("In salesTotalUnitsSoldGraph")
		if(params.end == null || params.end == "null")
		{
			if(params.portfolio_id=="null" || params.portfolio_id==null)
			{
			salesTotalUnitsByServiceMap = chartService.generateSalesTotalUnitsByServiceMap(startDate, endDate)
			}
			else
			{
				def portfoilo_id=(params.portfolio_id).toLong()
				salesTotalUnitsByServiceMap = chartService.generateSalesTotalUnitsByServiceMapUsingPortfolio(startDate, endDate,portfoilo_id,territory_id)
			}
			
		}
		else
		{
			endDate = dateFormat.parse(params.end);
			if(params.portfolio_id=="null" || params.portfolio_id==null)
			{
			salesTotalUnitsByServiceMap = chartService.generateSalesTotalUnitsByServiceMap(startDate, endDate)
			}
			else
			{
				def portfoilo_id=(params.portfolio_id).toLong()
				salesTotalUnitsByServiceMap = chartService.generateSalesTotalUnitsByServiceMapUsingPortfolio(startDate, endDate,portfoilo_id,territory_id)
			}
			
		}
		render (view: "/reports/salesTotalUnitsByServiceOffering", model: [salesTotalUnitsByServiceMap: salesTotalUnitsByServiceMap])
	}
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	/*******************************************Total Sales Sold Graph****************************************/
	def totalSalesSoldGraph = {
		Date endDate = null
		Map salesSoldByServicesMap = [:]
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date startDate = dateFormat.parse(params.start);
		//PricewellUtils.Println("TerritoryId", params.territory_id.toString())
		def territory_id=(params.territory_id).toLong();
		if(params.end == null || params.end == "null")
		{
			if(params.portfolio_id=="null" || params.portfolio_id==null)
			{
			salesSoldByServicesMap = chartService.generateSalesSoldByServicesMap(startDate, endDate)
			}
			else
			{
				def portfoilo_id=(params.portfolio_id).toLong()
				
				salesSoldByServicesMap = chartService.generateSalesSoldByServicesMapUsingPortfolio(startDate, endDate,portfoilo_id,territory_id)
			}
		}
		else
		{
			endDate = dateFormat.parse(params.end);
			
			if(params.portfolio_id=="null" || params.portfolio_id==null)
			{
			salesSoldByServicesMap = chartService.generateSalesSoldByServicesMap(startDate, endDate)
			}
			else
			{
				def portfoilo_id=(params.portfolio_id).toLong()
				salesSoldByServicesMap = chartService.generateSalesSoldByServicesMapUsingPortfolio(startDate, endDate,portfoilo_id,territory_id)
			}
		}
		def companyInformation
		def currency = "Money"
		if(CompanyInformation.list().size() > 0)
		{
			companyInformation = CompanyInformation.list().get(0)
			currency = companyInformation.baseCurrency
			
		}
		render (view: "/reports/salesSoldInBaseCurrencyByServiceOffering", model: [salesSoldByServicesMap: salesSoldByServicesMap, currency: currency])
	}
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	/***************************************** Total Product Sold Graph****************************************/
	def totalProductSoldGraph = {
		Date endDate = null
		Map productsSoldByServiceMap = [:]
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date startDate = dateFormat.parse(params.start);
		def territory_id=(params.territory_id).toLong();
		if(params.end == null || params.end == "null")
		{
			if(params.portfolio_id=="null" || params.portfolio_id==null)
			{
			productsSoldByServiceMap = chartService.generateProductsSoldByServiceMap(startDate, endDate)
			}
			else
			{
				def portfoilo_id=(params.portfolio_id).toLong()
				productsSoldByServiceMap = chartService.generateProductsSoldByServiceMapUsingPortfolio(startDate, endDate,portfoilo_id,territory_id)
			}
			
		}
		else
		{
			endDate = dateFormat.parse(params.end);
			if(params.portfolio_id=="null" || params.portfolio_id==null)
			{
			productsSoldByServiceMap = chartService.generateProductsSoldByServiceMap(startDate, endDate)
			}
			else
			{
				def portfoilo_id=(params.portfolio_id).toLong()
				productsSoldByServiceMap = chartService.generateProductsSoldByServiceMapUsingPortfolio(startDate, endDate,portfoilo_id,territory_id)
			}
		}
		
		def companyInformation
		def currency = "Money"
		if(CompanyInformation.list().size() > 0)
		{
			companyInformation = CompanyInformation.list().get(0)
			currency = companyInformation.baseCurrency
			
		}
		render (view: "/reports/productsSoldByService", model: [productsSoldByServiceMap: productsSoldByServiceMap, currency: currency])
	}
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	/**********************************Deal Status Chart********************************************************/
	def dealStatusChart =
	{
		Date endDate = null
		Map quoteTypesMap = [:]
				PricewellUtils.Println("In deal status Chart"+SecurityUtils.subject.principal)  
		def user = User.get(new Long(SecurityUtils.subject.principal))
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date startDate = dateFormat.parse(params.start);
		
		Geo territory = null
		if(params.end != null && params.end != "null")
		{
			endDate = dateFormat.parse(params.end);
		}
		
		if(params.territoryId)
		{
			territory = Geo.get(params.territoryId.toLong())
		}
		
		quoteTypesMap = chartService.buildSalesQuotesChartData(user, startDate, endDate, territory)
		
		render (template: "../reports/dealStatus", model: [quoteTypesMap: quoteTypesMap])
	}
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	/*******************************Quota Assigned Vs Quota Achievement Graph*********************************/
	def getQuotaAssignedVsQuotaAchivementChartData =
	{
		Map dateMap = dateService.getTimespanForQuota(params.range)
		def territoryInstance = null

		if(params.territoryId != null && params.territoryId != "")
		{
			territoryInstance = Geo.get(params.territoryId.toLong())
		}
		
		Map quotaData = [:]
		if(SecurityUtils.subject.hasRole("SALES PRESIDENT") || SecurityUtils.subject.hasRole("GENERAL MANAGER") || SecurityUtils.subject.hasRole("SALES MANAGER") || SecurityUtils.subject.hasRole("SALES PERSON"))
			{quotaData = opportunityService.getQuotaAssignedVsQuotaAchivement(dateMap, territoryInstance)}
			
		if(quotaData['Greater'] != "" && quotaData['Greater'] != null)
		{
			
			if(quotaData['Greater'] == 'assigned')
			{
				render(view: "/reports/quotaAssignedVsQuotaAchivementGraph", model: [quotaData: quotaData])
			}
			else if(quotaData['Greater'] == 'achieved')
			{
				render(view: "/reports/quotaAssignedVsQuotaAchivementGraph2", model: [quotaData: quotaData])
			}
		}
		//render(view: "/reports/quotaAssignedVsQuotaAchivementGraph", model: [quotaData: quotaData])
	}
	def getQuotaAssignedVsQuotaAchivementChartDataWithDate =
	{
			PricewellUtils.Println("Charts Controller", "AssignedVsQuotaAchivement")    
		Map dateMap = dateService.getTimespanForQuotaWithDate(params.start,params.end)
		def territoryInstance = null
  
		if(params.territoryId != null && params.territoryId != "")
		{
			PricewellUtils.Println("Charts Controller", "after")
			PricewellUtils.Println("Charts Controller", params.territoryId)
			territoryInstance = Geo.get(params.territoryId.toLong())
		}
		
		Map quotaData = [:]
		if(SecurityUtils.subject.hasRole("SALES PRESIDENT") || SecurityUtils.subject.hasRole("GENERAL MANAGER") || SecurityUtils.subject.hasRole("SALES MANAGER") || SecurityUtils.subject.hasRole("SALES PERSON"))
			{	quotaData = opportunityService.getQuotaAssignedVsQuotaAchivement(dateMap, territoryInstance)
				//PricewellUtils.Println("Charts Controller", "Lol"+quotaData['Percent']+"SAd"+ quotaData['Achieved'] + "Hello")
				
				}
			
		if(quotaData['Greater'] != "" && quotaData['Greater'] != null)
		{
			if(quotaData['Greater'] == 'assigned')
			{
				render(view: "/reports/quotaAssignedVsQuotaAchivementGraph", model: [quotaData: quotaData])
			}
			else if(quotaData['Greater'] == 'achieved')
			{
				render(view: "/reports/quotaAssignedVsQuotaAchivementGraph2", model: [quotaData: quotaData])
			}
		}
		//render(view: "/reports/quotaAssignedVsQuotaAchivementGraph", model: [quotaData: quotaData])
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	/*******************************************Quota Assigned Vs Quota Achievement Per Person Graph********/
	def getQuotaAssignedVsQuotaAchivementPerPersonChartData =
	{
		Map dateMap = dateService.getTimespanForQuota(params.range)
		def territoryInstance = null
		
		if(params.territoryId != null && params.territoryId != "")
		{
			territoryInstance = Geo.get(params.territoryId.toLong())
		}
				
		Map quotaPerPersons = [:]
			if(SecurityUtils.subject.hasRole("SALES PRESIDENT") || SecurityUtils.subject.hasRole("GENERAL MANAGER") || SecurityUtils.subject.hasRole("SALES MANAGER"))
				{quotaPerPersons = opportunityService.getQuotaAssignedVsQuotaAchivementPerPersons(dateMap, territoryInstance)}
			
		render(view: "/reports/quotaAssignedVsQuotaAchivementPerPerson", model: [quotaPerPersons: quotaPerPersons])
	}
	def getQuotaAssignedVsQuotaAchivementPerPersonChartDataWithDate =
	{
		PricewellUtils.Println("Charts Controller", "after")
		PricewellUtils.Println("Charts Controller", params.start)
		Map dateMap = dateService.getTimespanForQuotaWithDate(params.start,params.end)  
		def territoryInstance = null
		
		if(params.territoryId != null && params.territoryId != "")
		{
			territoryInstance = Geo.get(params.territoryId.toLong())
		}
				
		Map quotaPerPersons = [:]
			if(SecurityUtils.subject.hasRole("SALES PRESIDENT") || SecurityUtils.subject.hasRole("GENERAL MANAGER") || SecurityUtils.subject.hasRole("SALES MANAGER"))
				{quotaPerPersons = opportunityService.getQuotaAssignedVsQuotaAchivementPerPersons(dateMap, territoryInstance)}
			
		render(view: "/reports/quotaAssignedVsQuotaAchivementPerPerson", model: [quotaPerPersons: quotaPerPersons])
	}
	/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	/////////////////////////Admin Dash Board//////////////////////Recent User Activity/////////////////////
	def recentUserActivity=
	{
		Map dateMap=[:]
		if(params.end!=null && params.end!='null')
		{
		dateMap=dateService.getTimespanForQuotaWithDate(params.start,params.end)
		List recentLoginList=chartService.recentLoginRecord(dateMap['fromDate'],dateMap['toDate'])
		render(template:"/reports/recentActivity",model:[recentLoginList:recentLoginList])
		}
		}
	
	/////////////////Admin DashBoard////////////////Account Status by Role///////////////////
	def accountStatusbyRole=
	{
		Map dateMap=[:]
		if(params.end!=null && params.end!='null')
		{
		dateMap=dateService.getTimespanForQuotaWithDate(params.start,params.end)
		Map accountStatusByRoleData = chartService.buildChartDataForUserStatusByRoleWithDate(dateMap['fromDate'],dateMap['toDate'])
		render(view:"/reports/accountStatus",model:[accountStatusByRoleData: accountStatusByRoleData])
				}
		else
		{
			Map accountStatusByRoleData = chartService.buildChartDataForUserStatusByRole()
			render(view:"/reports/accountStatus",model:[accountStatusByRoleData: accountStatusByRoleData])
		}
	}
	/////////////Admin DashBoard/////////////////Service Variance////////////////////////
	def salesVarianceWithDate=
	{
		Map dateMap=[:]
		Map serviceVarianceMap = new HashMap()
		if(params.opportunityId!=null && params.opportunityId!='null' )
		{
			Opportunity opportunity = Opportunity.get(params.opportunityId?.toLong())
			if(opportunity)
		{
		if(params.end!=null && params.end!='null')
		{
		dateMap=dateService.getTimespanForQuotaWithDate(params.start,params.end)
		serviceVarianceMap= chartService.calculateServiceVarianceForOpportunityWithDate(opportunity,dateMap['fromDate'],dateMap['toDate'])//opportunity,
		}
		else
		{
			serviceVarianceMap = chartService.calculateServiceVarianceForOpportunity(opportunity)
		}
		}
		}
		render (template: "/reports/serviceVariance", model: [serviceVarianceMap: serviceVarianceMap])
	}
}
