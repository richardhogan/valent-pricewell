package com.valent.pricewell
import grails.converters.JSON
import grails.plugins.nimble.core.LoginRecord
import grails.plugins.nimble.core.Role
import grails.plugins.nimble.core.UserBase
import com.valent.pricewell.ServiceProfile.ServiceProfileType;
import com.valent.pricewell.util.PricewellUtils;

import java.text.DateFormatSymbols
import java.util.Date
import java.util.List;
import java.util.TreeMap

import org.apache.shiro.SecurityUtils

class ChartService {

	static transactional = true
	def serviceCatalogService
	def dateService
	def userService
	public static final List types  = [
		"LEAD",
		"OPPORTUNITY",
		"QUOTE",
		"SOW"
	]
	private static int ROUNDING_MODE = BigDecimal.ROUND_HALF_EVEN;
	private static int DECIMALS = 2;
	def quotationService
	def leadService, opportunityService

	def serviceMethod() {
	}

	public Map getUnassignedExceptionReport()
	{
		List unassignPortfolios = portfolioNotAssignToPortfolioManager()
		List unassignProductManagerOfServices = serviceNotAssignToProductManager()
		List unassignedServiceDesignerOfServices = unassignedServiceDesigner()
		List unassignGeos = geoNotAssignToGeneralManager()
		List unassignTerritories = territoriesNotAssignToGeo()
		Map unassignException = [unassignPortfolios: unassignPortfolios, unassignGeos: unassignGeos, unassignTerritories: unassignTerritories, unassignProductManagerServices: unassignProductManagerOfServices, unassignedServiceDesignerServices: unassignedServiceDesignerOfServices]
		
		return unassignException
	}
	
	public List territoriesNotAssignToGeo()
	{
		List territoryList = new ArrayList()
		for(Geo territory : Geo.list())
		{
			if(territory?.geoGroup == null || territory?.geoGroup == "")
				territoryList.add(territory)
		}
		
		return territoryList
	}
	
	public List geoNotAssignToGeneralManager()
	{
		List geoList = new ArrayList();
		
		for(GeoGroup geo : GeoGroup.list())
		{
			if(geo?.generalManagers?.size() == 0)
				geoList.add(geo)
		}
		return geoList
	}
	
	public List portfolioNotAssignToPortfolioManager()
	{
		List portfolioList = new ArrayList();
		def usenobody = User.findByUsername("nobody")
		for(Portfolio pf : Portfolio.list())
		{
			if(pf?.portfolioManager?.id == usenobody?.id)
			//if(pf?.portfolioManager == null || pf?.portfolioManager == "")
				portfolioList.add(pf)
		}
		return portfolioList
	}
	
	public unassignedServiceDesigner()
	{
		List serviceListNotAssignToServiceDesigner = new ArrayList();
		def usenobody = User.findByUsername("nobody")
		for(ServiceProfile sp : ServiceProfile.list())
		{
			if(sp?.serviceDesignerLead != null && sp?.serviceDesignerLead != "")
			{
				if(sp?.serviceDesignerLead?.id == usenobody?.id)
				{
					serviceListNotAssignToServiceDesigner.add(sp)
				}
			}
		}
		
		return serviceListNotAssignToServiceDesigner
	}
	
	public serviceNotAssignToProductManager()
	{
		List serviceListNotAssignToProductManager = new ArrayList();
		def usenobody = User.findByUsername("nobody")
		for(ServiceProfile sf : ServiceProfile.list())
		{
			if(sf?.service?.productManager?.id == usenobody?.id)
			//if(pf?.portfolioManager == null || pf?.portfolioManager == "")
				serviceListNotAssignToProductManager.add(sf)
		}
		return serviceListNotAssignToProductManager
	}
	
	public List filterOpportunityByTerritory(List opportunityList, Geo territory)
	{
		List finalList = new ArrayList()
		if(territory != null)
		{
			for(Opportunity op : opportunityList)
			{
				if(op?.geo?.id == territory?.id)
				{
					finalList.add(op)
				}
			}
		}
		
		return finalList
	}
	public List filterOpportunityByTerritoryWithDate(List opportunityList, Geo territory,Date fromDate,Date toDate)
	{
		
		List finalList = new ArrayList()
		if(territory != null)
		{
			for(Opportunity op : opportunityList)
			{
				if(op?.geo?.id == territory?.id)
				{
					if(op?.dateModified != null)
					{
						Date modifiedDate = dateService.removeTime(op?.dateModified)
						
						if(modifiedDate >= fromDate && modifiedDate <= toDate)
						{
							
							finalList.add(op)
						}
					}
					
				}
			}
		}
		
		return finalList
	}
	public Map getDefaultTerritory()
	{
		User user = User.get(new Long(SecurityUtils.subject.principal))
		Geo defaultTerritory = null
		Set territorySet = new HashSet()
		List territoryList = new ArrayList()
		boolean defaultAvailable = false
		
		if(user?.primaryTerritory != null)
		{
			if(!defaultAvailable)
			{
				defaultTerritory = user?.primaryTerritory
				defaultAvailable = true
			}
		}
		
		if(SecurityUtils.subject.hasRole("SALES PERSON"))
		{
			if(!defaultAvailable)
			{
				if(user?.territory != null)
				{
					defaultTerritory = user?.territory
					defaultAvailable = true
				}
			}
		}
		else if(SecurityUtils.subject.hasRole("SALES MANAGER"))
		{
			for(Geo territory : user?.territories?.sort{it?.name})
			{
				if(!defaultAvailable)
				{
					defaultTerritory = territory
					defaultAvailable = true
				}
				territorySet.add(territory)
			}
		}
		else if(SecurityUtils.subject.hasRole("GENERAL MANAGER"))
		{
			for(Geo territory : user?.geoGroup?.geos?.sort{it?.name})
			{
				if(!defaultAvailable)
				{
					defaultTerritory = territory
					defaultAvailable = true
				}
				territorySet.add(territory)
			}
		}
		else if(SecurityUtils.subject.hasRole("SALES PRESIDENT"))
		{
			for(GeoGroup geoGroup : GeoGroup.list()?.sort{it?.name})
			{
				for(Geo territory : geoGroup?.geos?.sort{it?.name})
				{
					if(!defaultAvailable)
					{
						defaultTerritory = territory
						defaultAvailable = true
					}
					territorySet.add(territory)
				}
			}
		}
		
		List opportunityList = opportunityService.getUserOppoertunities(user, new FilterCriteria())
		for(Opportunity op : opportunityList)
		{
			if(op?.geo != null)
			{
				territorySet.add(op?.geo)
			}
		}
		
		
		territoryList = sortTerritoryList(territorySet.toList())
		if(!defaultAvailable)
		{
			defaultTerritory = territoryList.get(0)
			defaultAvailable = true
		}
		
		return [defaultTerritory: defaultTerritory, territoryList: territoryList]
	}
	
	public List sortTerritoryList(List territoryList)
	{
		List sortedList = new ArrayList()
		Map<Integer,Geo> idMap = new HashMap<Integer, Geo>()
		
		for(Geo territory : territoryList?.sort{it?.name})
		{
			if( idMap.containsKey(territory.id) ){
				continue;
			}
			idMap.put(territory.id, territory);
			
			sortedList.add(territory)
		}
		
		return sortedList
	}
	
	public List getPlotColor(int totalPoint)
	{
		char[] chars = "0123456789ABCDEF".toCharArray();
		
		List colors = new ArrayList();
		while(colors.size() < 50)
		{
			StringBuilder sb = new StringBuilder();
			Random random = new Random();
			for (int i = 0; i < 6; i++) {
				char c = chars[random.nextInt(chars.length)];
				sb.append(c);
			}
			String color = "#" + sb.toString();
			
			if(!colors.contains(color))
			{
				colors.add(color);
			}
			
		}
		//println colors as JSON
		return colors;
	}
	
	public List getServiceTicketRelatedOpportunities()
	{
		def quotationList = Quotation.findAll("From Quotation qu WHERE qu.convertToTicket='yes' AND qu.contractStatus.name = 'Accepted'")
		Set opportunitySet = new HashSet()
		for(Quotation qu : quotationList?.sort{it?.opportunity?.name})
		{
			opportunitySet.add(qu.opportunity)
		}
		List opportunityList = opportunitySet.toList()
		
		return opportunityList
	}
	
	public Map calculateServiceVarianceForOpportunity(Opportunity opportunity)
	{
		def quotationList = Quotation.findAll("From Quotation qu WHERE qu.convertToTicket='yes'AND qu.opportunity.id = :opid AND qu.contractStatus.name = 'Accepted'", [opid: opportunity?.id])
		Map serviceMap = new HashMap()
		for(Quotation quotation : quotationList)
		{
			for(ServiceQuotation sQuotation : quotation?.serviceQuotations)
			{
				Map serviceHoursMap = getServiceQuotationHoursMap(sQuotation)
				
				BigDecimal serviceVariance = calculateVariance(serviceHoursMap['totalActualHours'], serviceHoursMap['totalEstimateHours'])
				
				if(!serviceMap.containsKey(sQuotation?.service?.serviceName)){
					List serviceDataList = new ArrayList()
					serviceDataList.add(new BigDecimal(0))//for saving veriance
					serviceDataList.add(new BigDecimal(0))//for saving quotation count
					serviceMap.put(sQuotation?.service?.serviceName, serviceDataList)
				}
				
				List dataValue = serviceMap[sQuotation?.service?.serviceName]
				dataValue[0] = dataValue[0] + serviceVariance
				dataValue[1] = dataValue[1] + 1
				serviceMap[sQuotation?.service?.serviceName] = dataValue
			}
		}
		
		List services = new ArrayList(), data = new ArrayList()
		
		for(String key in serviceMap.keySet())
		{
			services.add(key)
			List dataValue = serviceMap[key]
			
			data.add(dataValue[0]/dataValue[1])
		}
		
		return [categories: services, data: data]
	}
	
	public Map getServiceQuotationHoursMap(ServiceQuotation serviceQuotation)
	{
		BigDecimal totalEstimateHours = new BigDecimal(0)
		BigDecimal totalActualHours = new BigDecimal(0)
		
		for(ServiceQuotationTicket sqTicket : serviceQuotation?.serviceQuotationTickets)
		{
			totalEstimateHours = totalEstimateHours.add(sqTicket?.budgetHours)
			totalActualHours = totalActualHours.add(sqTicket?.actualHours)
		}
		Map hoursMap = new HashMap()
		hoursMap['totalEstimateHours'] = totalEstimateHours
		hoursMap['totalActualHours'] = totalActualHours
		return hoursMap
	}
	
	public Map drilldownServiceByOpportunity(Service service, Opportunity opportunity)
	{
		def quotationList = Quotation.findAll("From Quotation qu WHERE qu.convertToTicket='yes'AND qu.opportunity.id = :opid AND qu.contractStatus.name = 'Accepted'", [opid: opportunity?.id])
		Map activityRoleMap = new HashMap()
		for(Quotation quotation : quotationList?.sort{it?.id}.reverse())
		{
			for(ServiceQuotation sQuotation : quotation?.serviceQuotations?.sort{it?.id}.reverse())
			{
				if(sQuotation?.service?.id == service?.id)
				{
					for(ServiceQuotationTicket sqTicket : sQuotation?.serviceQuotationTickets?.sort{it?.id}.reverse())
					{
						def ticketName = /*"Quote #"+quotation?.id + "--" +*/sqTicket?.serviceActivity?.name + "--" + sqTicket?.role?.name
						if(!activityRoleMap.containsKey(ticketName)){
							Map hoursMap = new HashMap()
							hoursMap['budgetHours'] = new BigDecimal(0)
							hoursMap['actualHours'] = new BigDecimal(0)
							activityRoleMap.put(ticketName, hoursMap)
						}
						
						Map hoursMap = activityRoleMap[ticketName]
						hoursMap['budgetHours'] = hoursMap['budgetHours'] + sqTicket?.budgetHours
						hoursMap['actualHours'] = hoursMap['actualHours'] + sqTicket?.actualHours
						activityRoleMap[ticketName] = hoursMap
						
					}
				}
				
			}
		}
		
		List categories = new ArrayList(), budgetHours = new ArrayList(), actualHours = new ArrayList()
		for(String key in activityRoleMap.keySet())
		{
			categories.add(key)
			Map dataValue = activityRoleMap[key]
			
			budgetHours.add(dataValue['budgetHours'])
			actualHours.add(dataValue['actualHours'])
		}
		
		return [categories: categories, budgetHours: budgetHours, actualHours: actualHours, serviceName: service?.serviceName]
	}
	
	public Map drilldownServiceActivityRoleByOpportunity(Service service, Opportunity opportunity, String activityRoleString)
	{
		def quotationList = Quotation.findAll("From Quotation qu WHERE qu.convertToTicket='yes'AND qu.opportunity.id = :opid AND qu.contractStatus.name = 'Accepted'", [opid: opportunity?.id])
		Map activityRoleMap = new HashMap()
		for(Quotation quotation : quotationList?.sort{it?.id}.reverse())
		{
			for(ServiceQuotation sQuotation : quotation?.serviceQuotations?.sort{it?.id}.reverse())
			{
				if(sQuotation?.service?.id == service?.id)
				{
					for(ServiceQuotationTicket sqTicket : sQuotation?.serviceQuotationTickets?.sort{it?.id}.reverse())
					{
						def ticketName = sqTicket?.serviceActivity?.name + "--" + sqTicket?.role?.name
						if(ticketName == activityRoleString)
						{
							
							Map hoursMap = new HashMap()
							hoursMap['budgetHours'] = sqTicket?.budgetHours
							hoursMap['actualHours'] = sqTicket?.actualHours
							activityRoleMap.put("Quotation #"+quotation?.id, hoursMap)
							
						}
						
					}
				}
				
			}
		}
		
		List res = activityRoleString.split("--")
		String activityRoleName = "Activity : "+res[0]+", Role : "+res[1]
		
		List categories = new ArrayList(), budgetHours = new ArrayList(), actualHours = new ArrayList()
		for(String key in activityRoleMap.keySet())
		{
			categories.add(key)
			Map dataValue = activityRoleMap[key]
			
			budgetHours.add(dataValue['budgetHours'])
			actualHours.add(dataValue['actualHours'])
		}
		
		return [categories: categories, budgetHours: budgetHours, actualHours: actualHours, activityRoleName: activityRoleName, serviceName: service?.serviceName?.toString()]
	}
	
	public def getOpportunityFunnelGraphData(Date fromDate, Date toDate, Geo territory)
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))

		def filterCriteria = new FilterCriteria()
		def data = [:]
		def opportunityList = opportunityService.retrieveOpportunityList("pending", [:])
		opportunityList = listOpportunityBetweenDates(opportunityList, fromDate, toDate, null)
		opportunityList = filterOpportunityByTerritory(opportunityList, territory)
		
		def opportunityStagingList = Staging.findAll("FROM Staging st WHERE st.entity = :entity AND :stage IN elements(st.types) ORDER BY sequenceOrder ASC",
			[entity: Staging.StagingObjectType.OPPORTUNITY, stage: 'NEW_STAGE'])
		
		def finalData = new ArrayList(opportunityStagingList.size()); def i = 0
		for(Staging st : opportunityStagingList)
		{
			if(st.name != "closedWon" && st.name != "closedLost")
			{
				finalData[i] = new ArrayList()
				data.put(st.displayName, 0)
				i++
			}
		}
		
		for(Opportunity op : opportunityList)
		{
			data[op.stagingStatus.displayName] = data[op.stagingStatus.displayName] + 1
		}
		
		i = 0
		
		for(String key in data.keySet())
		{
			finalData[i].add(key)
			finalData[i].add(data[key])
			i++
			//services.add(key);
			//data.add(tmpMap[key])
		}
		return ["series": finalData]
	}
	
	public def getServiceFunnelGraphData(Date fromDate, Date toDate)
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))

		def filterCriteria = new FilterCriteria()
		def data = [:]
		def serviceProfileList = serviceCatalogService.findUserServicesByStaging(user, ServiceProfileType.DEVELOP)
		serviceProfileList = listServiceBetweenDates(serviceProfileList, fromDate, toDate)
		
		def serviceStagingList = Staging.findAll("FROM Staging st WHERE st.entity = :entity AND :stage IN elements(st.types) ORDER BY sequenceOrder ASC",
			[entity: Staging.StagingObjectType.SERVICE, stage: 'NEW_STAGE'])
		
		def finalData = new ArrayList(serviceStagingList.size()); def i = 0
		for(Staging st : serviceStagingList)
		{
			if(st.name != "published" && st.name != "requesttoremove" && st.name != "removed" && st.name != "inActive")
			{
				finalData[i] = new ArrayList()
				data.put(st.displayName, 0)
				i++
			}
		}
		
		
		for(ServiceProfile sp : serviceProfileList)
		{
			data[sp?.stagingStatus.displayName] = data[sp.stagingStatus.displayName] + 1
		}
		
		i = 0
		
		for(String key in data.keySet())
		{
			finalData[i].add(key)
			finalData[i].add(data[key])
			i++
			//services.add(key);
			//data.add(tmpMap[key])
		}
		return ["series": finalData]
	}
	
	public List listServiceBetweenDates(List tmpSerPro, Date fromDate, Date toDate)
	{
		def serviceProfileList = []
		for(ServiceProfile sp : tmpSerPro)
		{
			Date convertedDate = /*dateService.*/removeTime(sp.dateCreated)
			if(fromDate != null && toDate != null)
			{
				if(convertedDate <= fromDate && convertedDate >= toDate)
				{
					serviceProfileList.add(sp)
				}
			}
		
			else if(fromDate != null)
			{
				if(convertedDate <= fromDate)
				{
					serviceProfileList.add(sp)
				}
				/*else if(op.closeDate <= fromDate)
				{
					opportunityList.add(op)
				}*/
			}
		}		
		
		return serviceProfileList
	}
	
	public def getLeadFunnelGraphData(Date fromDate, Date toDate)
	{
		println SecurityUtils.subject.principal
		def user = User.get(new Long(SecurityUtils.subject.principal))

		def filterCriteria = new FilterCriteria()
		def data = [:]
		def leadList = [], tmpLeads = leadService.getUserLeads(user, filterCriteria)
		leadList = listLeadsBetweenDates(tmpLeads, fromDate, toDate, "pending")
		if(SecurityUtils.subject.hasRole("SALES PERSON"))
		{
			def tmpList = leadList
			leadList = []
			for(Lead ld : tmpList)
			{
				if(ld.assignTo.id == user?.id)
				{
					leadList.add(ld)
				}
			}
			
		}
		/*for(Lead ld : tmpLeads)
		{
			if(ld.stagingStatus.sequenceOrder < 53)
			{
				leadList.add(ld)
			}
		}*/
		
		def leadStagingList = Staging.findAll("FROM Staging st WHERE st.entity = :entity AND :stage IN elements(st.types) ORDER BY sequenceOrder ASC",
			[entity: Staging.StagingObjectType.LEAD, stage: 'NEW_STAGE'])
		
		def finalData = new ArrayList(leadStagingList.size()); def i = 0
		for(Staging st : leadStagingList)
		{
			if(st.name != "converted" && st.name != "dead")
			{
				finalData[i] = new ArrayList()	
				data.put(st.displayName, 0)
				i++
			}
		}
		
		
		for(Lead ld : leadList)
		{
			data[ld.stagingStatus.displayName] = data[ld.stagingStatus.displayName] + 1
		}
		
		i = 0
		
		for(String key in data.keySet())
		{
			finalData[i].add(key)
			finalData[i].add(data[key])
			i++
			//services.add(key);
			//data.add(tmpMap[key])
		}
		return ["series": finalData]
	}
	public def getLeadFunnelGraphDataWithTerritory(Date fromDate, Date toDate)
	{
		println SecurityUtils.subject.principal
		def user = User.get(new Long(SecurityUtils.subject.principal))

		def filterCriteria = new FilterCriteria()
		def data = [:]
		def leadList = [], tmpLeads = leadService.getUserLeads(user, filterCriteria)
		leadList = listLeadsBetweenDates(tmpLeads, fromDate, toDate, "pending")
		if(SecurityUtils.subject.hasRole("SALES PERSON"))
		{
			def tmpList = leadList
			leadList = []
			for(Lead ld : tmpList)
			{
				if(ld.assignTo.id == user?.id)
				{
					leadList.add(ld)
				}
			}
			
		}
		/*for(Lead ld : tmpLeads)
		{
			if(ld.stagingStatus.sequenceOrder < 53)
			{
				leadList.add(ld)
			}
		}*/
		
		def leadStagingList = Staging.findAll("FROM Staging st WHERE st.entity = :entity AND :stage IN elements(st.types) ORDER BY sequenceOrder ASC",
			[entity: Staging.StagingObjectType.LEAD, stage: 'NEW_STAGE'])
		
		def finalData = new ArrayList(leadStagingList.size()); def i = 0
		for(Staging st : leadStagingList)
		{
			if(st.name != "converted" && st.name != "dead")
			{
				finalData[i] = new ArrayList()
				data.put(st.displayName, 0)
				i++
			}
		}
		
		
		for(Lead ld : leadList)
		{
			data[ld.stagingStatus.displayName] = data[ld.stagingStatus.displayName] + 1
		}
		
		i = 0
		
		for(String key in data.keySet())
		{
			finalData[i].add(key)
			finalData[i].add(data[key])
			i++
			//services.add(key);
			//data.add(tmpMap[key])
		}
		return ["series": finalData]
	}
	public def quarterlyTotalSalesByUser(Geo territory)
	{
		def categories = [], data = []
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def opportunityList = new ArrayList(), quotationList = new ArrayList()
		def tmpList = opportunityService.retrieveOpportunityList("closedWon", [:]), tmpList2 = opportunityService.retrieveOpportunityList("pending", [:])
		opportunityList.addAll(tmpList); opportunityList.addAll(tmpList2)
		
		Date today = new Date()
		Integer year = today.year + 1900; Integer month = today.month + 1
		println 'today '+today
		Date fromDate = null, toDate = null
		def quarter = dateService.getQuarter(month)
		Map dateMap = dateService.getDatesOfGivenQuarter(quarter,year)
		fromDate = dateService.getDate(dateMap['from']); toDate = dateService.getDate(dateMap['to'])
		println "QTS : "+opportunityList
		opportunityList = filterOpportunityByTerritory(opportunityList, territory)
		for(Opportunity op: opportunityList)
		{
			for(Quotation qu : op?.quotations)
			{
				if(qu.contractStatus.name == "Accepted")
					quotationList.add(qu)
			}
		}
		quotationList = getQuotationsBetweenDates(quotationList, fromDate, toDate)
		Date from = fromDate, to = fromDate+6
		
		while(to <= toDate)
		{
			def quotes = getQuotationsBetweenDates(quotationList, from, to)
			def totalSales = countTotalSales(quotes)
			categories.add(to.getDate() + "-" + getMonthName(to.month))
			data.add(totalSales)
			//println "quotations : "+totalSales + " Date : " + to.getDate() + "-" + getMonthName(to.month)
			from = to + 1
			to = from + 6
		}
		if(from <= toDate)
		{
			def quotes = getQuotationsBetweenDates(quotationList, from, toDate)
			def totalSales = countTotalSales(quotes)
			categories.add(toDate.getDate() + "-" + getMonthName(toDate.month))
			data.add(totalSales)
			//println "quotations : "+totalSales + " Date : " + toDate.getDate() + "-" + getMonthName(toDate.month)
		}
		return ["categories": categories, "series": ['name': 'Sales', 'data': data]]
	}
	public def quarterlyTotalSalesByUserWithDate(Geo territory,String startDate,String endDate)
	{
		
		def addDays=0;
		def categories = [], data = []
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def opportunityList = new ArrayList(), quotationList = new ArrayList()
		def tmpList = opportunityService.retrieveOpportunityList("closedWon", [:]), tmpList2 = opportunityService.retrieveOpportunityList("pending", [:])
		opportunityList.addAll(tmpList); opportunityList.addAll(tmpList2)
		Date fromDate = null, toDate = null
		Date from=null,to=null
		if(endDate!=null || endDate !='null')
		{
			Map dateMapping=dateService.getTimespanForQuotaWithDate(startDate, endDate)
			int diffInDays=dateService.getDifferenceBetweenDays(dateMapping['toDate'],dateMapping['fromDate'])
			int diffMonth =dateService.getDifferenceBetweenMonths(dateMapping['toDate'],dateMapping['fromDate'])
			toDate=dateMapping['toDate']
			fromDate=dateMapping['fromDate']
			
			//println "QTS : "+opportunityList
			
			
			from = fromDate
			to = fromDate
			if(diffInDays<=7)
				{
					addDays=1
				}
				else
				{
					PricewellUtils.Println("Diff"+diffMonth)
					//Date from = fromDate, to = fromDate
					if(diffMonth<=3 && diffMonth>=0)
					{
						addDays=6
					}
					else if(diffMonth<=6 && diffMonth>3)
					{
						addDays=14
					}
					else
					{
						addDays=30
					}
					
				}
				
		}
//			else
//			{
//				Map dateMapping=dateService.getTimespanForQuotaWithDate(startDate, null)
//				toDate=dateMapping['toDate']
//				fromDate=null
//				from = fromDate
//				to = fromDate
//			}
		
			opportunityList = filterOpportunityByTerritory(opportunityList, territory)
			for(Opportunity op: opportunityList)
			{
				for(Quotation qu : op?.quotations)
				{
					if(qu.contractStatus.name == "Accepted")
						quotationList.add(qu)
				}
			}
			quotationList = getQuotationsBetweenDates(quotationList, fromDate, toDate)
			while(to <= toDate)
			{
				def quotes = getQuotationsBetweenDates(quotationList, from, to)
				def totalSales = countTotalSales(quotes)
				categories.add(to.getDate() + "-" + getMonthName(to.month))
				data.add(totalSales)
				//println "quotations : "+totalSales + " Date : " + to.getDate() + "-" + getMonthName(to.month)
				from = to + 1
				to = to + addDays
			}
			if(from <= toDate)
			{
				def quotes = getQuotationsBetweenDates(quotationList, from, toDate)
				def totalSales = countTotalSales(quotes)
				categories.add(toDate.getDate() + "-" + getMonthName(toDate.month))
				data.add(totalSales)
				//println "quotations : "+totalSales + " Date : " + toDate.getDate() + "-" + getMonthName(toDate.month)
			}
		return ["categories": categories, "series": ['name': 'Sales', 'data': data]]
	}
	public def countTotalSales(List quotations)
	{
		def totalSales = new BigDecimal(0)
		for(Quotation qu : quotations)
		{
			BigDecimal deductDiscount = qu.discountAmount/(qu?.serviceQuotations?.size())
			
			for(ServiceQuotation sq in qu.serviceQuotations)
			{
				BigDecimal convertRate = new BigDecimal(1)
				if(sq.geo.convert_rate != null && sq.geo.convert_rate > 0){
					convertRate = sq.geo.convert_rate
				}
				
				def discountAmount = (sq.price*qu.discountPercent)/100
				totalSales = totalSales + ((sq.price - discountAmount) / convertRate)
			}
		}
		return totalSales
	}
	
	public List getQuotationsBetweenDates(List quotations, Date fromDate, Date toDate)
	{
		def quotationList = []
		if(fromDate!=null)
		{
			
		
		for(Quotation qu : quotations)
		{
			if(qu?.modifiedDate != null)
			{
				Date modifiedDate = dateService.removeTime(qu?.modifiedDate)
				
				if(modifiedDate >= fromDate && modifiedDate <= toDate)
				{
					println qu.opportunity?.name
					quotationList.add(qu)
				}
			}
		}
		}
		else
		{
			for(Quotation qu : quotations)
			{
				if(qu?.modifiedDate != null)
				{
					Date modifiedDate = dateService.removeTime(qu?.modifiedDate)
					
					if(modifiedDate <= toDate)
					{
						println qu.opportunity?.name
						quotationList.add(qu)
					}
				}
			}
		}
		return quotationList
	}
	
	String getMonthName(int num) {
		String month = "wrong";
		DateFormatSymbols dfs = new DateFormatSymbols();
		String[] months = dfs.getMonths();
		if (num >= 0 && num <= 11 ) {
			month = months[num];
		}
		return month.substring(0, 3)
	}
	
	public Map generateItCostPerQuotationMap(Portfolio portfolio, Date fromDate, Date toDate,Long territory_id)
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))
		
		def serviceList = Service.listPublished(user)
		def tmpMap = [:], finalMap = [:]
		def quotationList = []
		Set quotationSet = new HashSet()
		def serviceQuotationList
		if(territory_id!=-1)
	{
		//PricewellUtils.Println("territoryId", territoryId);
		serviceQuotationList=Quotation.executeQuery("select sq FROM ServiceQuotation sq  WHERE sq.quotation.contractStatus.name = 'Accepted' AND sq.service.portfolio.id = :portfolio_id AND sq.geo.id= :territoryId",[portfolio_id:portfolio.id,territoryId:territory_id])
	}
	else
	{
		 serviceQuotationList = ServiceQuotation.findAll("FROM ServiceQuotation sq WHERE sq.quotation.contractStatus.name = 'Accepted' AND sq.service.portfolio.id = :pid",
			[pid : portfolio.id])
			
	}

			
		
		for(ServiceQuotation sq : serviceQuotationList)
		{
			quotationSet.add(sq.quotation)
		}
		
		quotationList = quotationSet.toList().sort{x,y -> x.id <=> y.id}
		List categories = []
		for(Quotation qu : quotationList)
		{
			categories.add("Quotation #"+qu.id)//+" Cost")
		}
		
		for(ServiceQuotation sq : serviceQuotationList)
		{
			Quotation qu = sq.quotation
			boolean check = false
			if(fromDate != null && toDate != null)
			{
				if(qu.opportunity.dateModified <= fromDate && qu.opportunity.dateModified >= toDate)
				{
					check = true
				}
			}
			else if(fromDate != null)
			{
				if(qu.opportunity.dateModified <= fromDate)
				{
					check = true
				}
			}
			if(check == true)
			{
				def itCost = countItCost(sq)
				int index = categories.indexOf("Q"+sq.quotation.id)//+" Cost")
				
				if(isThere(serviceList, sq.service))
				{
					if(!tmpMap.containsKey(sq.service.serviceName)){
						List initializedData = initializeMapData(quotationList.size())
						tmpMap.put(sq.service.serviceName, initializedData)
					}
					//println "Q"+sq.quotation.id+" Cost : " + itCost + " for " + sq.service.serviceName
					tmpMap[sq.service.serviceName][index] = itCost
				}

			}
			//println putCostAtIndex(index, itCost, tmpMap[sq.service.serviceName])
		}
		
		def series = []
		for(String key in tmpMap.keySet())
		{
			series.add(['name': key, 'data': tmpMap[key]])
		}
		
		finalMap.put("categories", categories)
		finalMap.put("series", series)
		
		return finalMap
	}
	
	public List putCostAtIndex(int index, BigDecimal itCost, List arrayList)
	{
		arrayList[index] = itCost
		
		return arrayList
	}
	
	def List initializeMapData(int length){
		
		def arrayList = new ArrayList()
		
		for(int i=0; i<length; i++)
		{
			arrayList.add(new BigDecimal(0))
		}
		
		return arrayList
	}
	
	public BigDecimal countItCost(ServiceQuotation sq)
	{
		def totalSales = new BigDecimal(0)
		
		BigDecimal deductDiscount = sq.quotation?.discountAmount/(sq.quotation?.serviceQuotations?.size())
		
		BigDecimal convertRate = new BigDecimal(1)
		
		if(sq.geo.convert_rate != null && sq.geo.convert_rate > 0){
			convertRate = sq.geo.convert_rate
		}
		
		def discountAmount = (sq.price*sq.quotation.discountPercent)/100
		totalSales = totalSales + ((sq.price - discountAmount) / convertRate)
		
		return totalSales
		
	}
		
	public def generateServiceSoldPerPortfolioMap(Portfolio portfolio, Date fromDate, Date toDate,Long territory_id)
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))
		
		def serviceList = Service.listPublished(user)
		def tmpMap = [:]
				def quotationList
			if(territory_id!=-1)
		{
			//PricewellUtils.Println("territoryId", territoryId);
			quotationList=Quotation.executeQuery("select qu FROM Quotation qu inner join qu.serviceQuotations sq  WHERE qu.contractStatus.name = 'Accepted' AND sq.service.portfolio.id = :portfolio_id AND qu.geo.id= :territoryId",[portfolio_id:portfolio.id,territoryId:territory_id])
		}
		else
		{
				
				quotationList=Quotation.executeQuery("select qu FROM Quotation qu inner join qu.serviceQuotations sq  WHERE qu.contractStatus.name = 'Accepted'")
		}		
		def total = 0		
		for(Quotation qu in quotationList)
		{
			boolean check = false
			if(fromDate != null && toDate != null)
			{
				if(qu.opportunity.dateModified <= fromDate && qu.opportunity.dateModified >= toDate)
				{
					check = true
				}
			}
			else if(fromDate != null)
			{
				if(qu.opportunity.dateModified <= fromDate)
				{
					check = true
				}
			}
			if(check == true)
			{
				for(ServiceQuotation sq in qu.serviceQuotations)
				{
					if(portfolio!=null)
					{
					if(sq.service.portfolio.id == portfolio.id)
					{
						if(tmpMap.containsKey(sq.service.serviceName)){
							tmpMap[sq.service.serviceName] = tmpMap[sq.service.serviceName] + 1
							total++
						}
						else if(isThere(serviceList, sq.service))
						{
							tmpMap.put(sq.service.serviceName, 0)
							tmpMap[sq.service.serviceName] = tmpMap[sq.service.serviceName] + 1
							total++
						}
					}
					}
					else
					{
						if(tmpMap.containsKey(sq.service.serviceName)){
							tmpMap[sq.service.serviceName] = tmpMap[sq.service.serviceName] + 1
							total++
						}
						else if(isThere(serviceList, sq.service))
						{
							tmpMap.put(sq.service.serviceName, 0)
							tmpMap[sq.service.serviceName] = tmpMap[sq.service.serviceName] + 1
							total++
						}
					}
					
				}
			}
		}
		
		def dataOfPiGraph = [], dataOfLineGraph = [], categories = []
		
		for(String key in tmpMap.keySet())
		{
			def percentage = (tmpMap[key]*100)/total
			dataOfPiGraph.add([key, percentage])
				
			categories.add(key)
			dataOfLineGraph.add(tmpMap[key])
		}
		
				
		return ['dataOfPiGraph': dataOfPiGraph, "categories": categories, "series": ['name': 'Service Sold', 'data': dataOfLineGraph]]
	}
	
	public def generateSalesTotalUnitsByServiceMap(Date fromDate, Date toDate) 
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))

		def serviceList = Service.listPublished(user)
		def tmpMap = [:]
		def quotationList = Quotation.findAll("FROM Quotation qu WHERE qu.contractStatus.name = 'Accepted'")// AND qu.opportunity.stagingStatus.name = 'closedWon'")
		
		for(Quotation qu in quotationList) 
		{
			boolean check = false
			if(fromDate != null && toDate != null)
			{
				if(qu.opportunity.dateModified <= fromDate && qu.opportunity.dateModified >= toDate)
				{
					check = true
				}
			}
			else if(fromDate != null)
			{
				if(qu.opportunity.dateModified <= fromDate)
				{
					check = true
				}
			}
			if(check == true)
			{
				for(ServiceQuotation sq in qu.serviceQuotations)
				{
					if(tmpMap.containsKey(sq.service.serviceName)){
						tmpMap[sq.service.serviceName] = tmpMap[sq.service.serviceName] + sq.totalUnits
					}
					else if(isThere(serviceList, sq.service))
					{
						tmpMap.put(sq.service.serviceName, 0)
						tmpMap[sq.service.serviceName] = tmpMap[sq.service.serviceName] + sq.totalUnits
					}
				}
			}			
		}
		
		def services = []
		def data = []
		for(String key in tmpMap.keySet()){
			services.add(key);
			data.add(tmpMap[key])
		}
		return ["categories": services, "data": data]
	}
	public def generateSalesTotalUnitsByServiceMapUsingPortfolio(Date fromDate, Date toDate,Long porftfolio_id,def territoryId)
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))

		def serviceList = Service.listPublished(user)
		def tmpMap = [:]
				def quotationList
			if(territoryId!=-1)
		{
			//PricewellUtils.Println("territoryId", territoryId);
			quotationList=Quotation.executeQuery("select qu FROM Quotation qu inner join qu.serviceQuotations sq  WHERE qu.contractStatus.name = 'Accepted' AND sq.service.portfolio.id = :portfolio_id AND qu.geo.id= :territoryId",[portfolio_id:porftfolio_id,territoryId:territoryId])
		}
		else
		{
				
				quotationList=Quotation.executeQuery("select qu FROM Quotation qu inner join qu.serviceQuotations sq  WHERE qu.contractStatus.name = 'Accepted' AND sq.service.portfolio.id = :portfolio_id",[portfolio_id:porftfolio_id])
		}
//println quotationList +"asds"    
		for(Quotation qu in quotationList)
		{
			boolean check = false
			if(fromDate != null && toDate != null)
			{
				if(qu.opportunity.dateModified <= fromDate && qu.opportunity.dateModified >= toDate)
				{
					check = true
				}
			}
			else if(fromDate != null)
			{
				if(qu.opportunity.dateModified <= fromDate)
				{
					check = true
				}
			}
			if(check == true)
			{
				for(ServiceQuotation sq in qu.serviceQuotations)
				{
					if(tmpMap.containsKey(sq.service.serviceName)){
						tmpMap[sq.service.serviceName] = tmpMap[sq.service.serviceName] + sq.totalUnits
					}
					else if(isThere(serviceList, sq.service))
					{
						tmpMap.put(sq.service.serviceName, 0)
						tmpMap[sq.service.serviceName] = tmpMap[sq.service.serviceName] + sq.totalUnits
					}
				}
			}
		}
		
		def services = []
		def data = []
		for(String key in tmpMap.keySet()){
			services.add(key);
			data.add(tmpMap[key])
		}
		return ["categories": services, "data": data]
	}
	public isThere(List objectList, def object)
	{
		boolean isthere = false
		for(def ob : objectList)
		{
			if(ob.id == object.id)
			{
				isthere = true
			}
		}
		return isthere
	}

	private def productPricelistCache = null;

	private void initProductPricelistCache(){
		productPricelistCache = [:]
		def productPriceLists = ProductPricelist.list()
		for(ProductPricelist pl: productPriceLists){
			productPricelistCache.put(keyForProductPriceListCache(pl.product,pl.geo), pl.unitPrice)
		}
	}

	private String keyForProductPriceListCache(Product product, Geo geo){
		return product.id + '-' + geo.id;
	}

	public def generateProductsSoldByServiceMap(Date fromDate, Date toDate) {
		def user = User.get(new Long(SecurityUtils.subject.principal))

		//Service[] services1 = Service.listPublished(user)
		
		Set serviceSet = new HashSet()
		List serviceQuotations = new ArrayList(), services = new ArrayList()
		def idToIndex = [:]
		def tmpMap = new TreeMap();
		def serviceNames = []
		

		//if(productPricelistCache == null){
		initProductPricelistCache();
		//}
		def quotationList = Quotation.findAll("FROM Quotation qu WHERE qu.contractStatus.name = 'Accepted'")// AND qu.opportunity.stagingStatus.name = 'closedWon'")

		if(quotationList != null)
		{
			for(Quotation qu in quotationList)
			{
				boolean check = false
				if(fromDate != null && toDate != null)
				{
					if(qu.opportunity.dateModified <= fromDate && qu.opportunity.dateModified >= toDate)
					{
						check = true
					}
				}
				else if(fromDate != null)
				{
					if(qu.opportunity.dateModified <= fromDate)
					{
						check = true
					}
				}
				if(check == true)
				{
					
					for(ServiceQuotation sq in qu?.serviceQuotations)
					{
						if(sq?.service?.portfolio?.portfolioManager?.id == user.id && sq?.service?.serviceProfile?.productsRequired.size() > 0)
						{
							serviceQuotations.add(sq)
							
							BigDecimal convertRate = 1
							if(sq.geo.convert_rate != null && sq.geo.convert_rate > 0){
								convertRate = sq.geo.convert_rate
							}
							
							for(ServiceProductItem pi: sq.service.serviceProfile.productsRequired)
							{
								if(!pi.product)
									continue;
								
								BigDecimal pricePerUnit = productPricelistCache[keyForProductPriceListCache(pi.product, sq.geo)]
				
								if(pricePerUnit && pricePerUnit > 0){
				
									if(((sq.totalUnits * pi.unitsSoldRatePerAdditionalUnit * pricePerUnit) / convertRate) > 0)
									{
										serviceSet.add(sq.service)
									}
				
								}
				
							}
						}
					}
				}
			}
		}
		
		
		services = serviceSet.toList()
		services?.sort{it?.serviceName}
		for(int i=0; i<services.size(); i++){
			idToIndex.put(services[i].id ,i)
			serviceNames.add(services[i].serviceName);
		}
		int len = services.size()
		
		for(ServiceQuotation sq : serviceQuotations)
		{
			int index = idToIndex[sq.service.id]
			if(index >= 0){
				int units = sq.totalUnits
				Geo geo = sq.geo
				BigDecimal convertRate = 1
				if(sq.geo.convert_rate != null && sq.geo.convert_rate > 0){
					convertRate = sq.geo.convert_rate
				}
				
				
				for(ServiceProductItem pi: sq.service.serviceProfile.productsRequired)
				{
					if(!pi.product)
						continue;
					String productName = pi.product.productName

					if(!tmpMap.containsKey(productName)){
						tmpMap.put(productName, initBigDecimalArray(len))
					}
					BigDecimal pricePerUnit = productPricelistCache[keyForProductPriceListCache(pi.product, geo)]

					if(pricePerUnit && pricePerUnit > 0){

						tmpMap.get(productName)[index] +=  ((units * pi.unitsSoldRatePerAdditionalUnit * pricePerUnit) / convertRate)

					}

				}
				
			}
		}

		def series = []
		for(String key in tmpMap.keySet()){
			series.add([name: key, data: tmpMap[key]])
		}
		return ["categories": serviceNames, "series": series]
	}
	public def generateProductsSoldByServiceMapUsingPortfolio(Date fromDate, Date toDate,Long portfolioId,def territoryId) {
		def user = User.get(new Long(SecurityUtils.subject.principal))

		//Service[] services1 = Service.listPublished(user)
		
		Set serviceSet = new HashSet()
		List serviceQuotations = new ArrayList(), services = new ArrayList()
		def idToIndex = [:]
		def tmpMap = new TreeMap();
		def serviceNames = []
		

		//if(productPricelistCache == null){
		initProductPricelistCache();
		//}
				def quotationList
			if(territoryId!=-1)
		{
			//PricewellUtils.Println("territoryId", territoryId);
			quotationList=Quotation.executeQuery("select qu FROM Quotation qu inner join qu.serviceQuotations sq  WHERE qu.contractStatus.name = 'Accepted' AND sq.service.portfolio.id = :portfolio_id AND qu.geo.id= :territoryId",[portfolio_id:portfolioId,territoryId:territoryId])
		}
		else
		{
				
				quotationList=Quotation.executeQuery("select qu FROM Quotation qu inner join qu.serviceQuotations sq  WHERE qu.contractStatus.name = 'Accepted' AND sq.service.portfolio.id = :portfolio_id",[portfolio_id:portfolioId])
		}

		if(quotationList != null)
		{
			for(Quotation qu in quotationList)
			{
				boolean check = false
				if(fromDate != null && toDate != null)
				{
					if(qu.opportunity.dateModified <= fromDate && qu.opportunity.dateModified >= toDate)
					{
						check = true
					}
				}
				else if(fromDate != null)
				{
					if(qu.opportunity.dateModified <= fromDate)
					{
						check = true
					}
				}
				if(check == true)
				{
					
					for(ServiceQuotation sq in qu?.serviceQuotations)
					{
						if(sq?.service?.portfolio?.portfolioManager?.id == user.id && sq?.service?.serviceProfile?.productsRequired.size() > 0)
						{
							serviceQuotations.add(sq)
							
							BigDecimal convertRate = 1
							if(sq.geo.convert_rate != null && sq.geo.convert_rate > 0){
								convertRate = sq.geo.convert_rate
							}
							
							for(ServiceProductItem pi: sq.service.serviceProfile.productsRequired)
							{
								if(!pi.product)
									continue;
								
								BigDecimal pricePerUnit = productPricelistCache[keyForProductPriceListCache(pi.product, sq.geo)]
				
								if(pricePerUnit && pricePerUnit > 0){
				
									if(((sq.totalUnits * pi.unitsSoldRatePerAdditionalUnit * pricePerUnit) / convertRate) > 0)
									{
										serviceSet.add(sq.service)
									}
				
								}
				
							}
						}
					}
				}
			}
		}
		
		
		services = serviceSet.toList()
		services?.sort{it?.serviceName}
		for(int i=0; i<services.size(); i++){
			idToIndex.put(services[i].id ,i)
			serviceNames.add(services[i].serviceName);
		}
		int len = services.size()
		
		for(ServiceQuotation sq : serviceQuotations)
		{
//			PricewellUtils.Println("Before")
//			PricewellUtils.Println("Service ID", sq.service.id)
//			PricewellUtils.Println("After")
			int index = idToIndex[sq.service.id]
			PricewellUtils.Println("Index",index)
			if(index >= 0){
				int units = sq.totalUnits
				Geo geo = sq.geo
				BigDecimal convertRate = 1
				if(sq.geo.convert_rate != null && sq.geo.convert_rate > 0){
					convertRate = sq.geo.convert_rate
				}
				
				
				for(ServiceProductItem pi: sq.service.serviceProfile.productsRequired)
				{
					if(!pi.product)
						continue;
					String productName = pi.product.productName

					if(!tmpMap.containsKey(productName)){
						tmpMap.put(productName, initBigDecimalArray(len))
					}
					BigDecimal pricePerUnit = productPricelistCache[keyForProductPriceListCache(pi.product, geo)]

					if(pricePerUnit && pricePerUnit > 0){

						tmpMap.get(productName)[index] +=  ((units * pi.unitsSoldRatePerAdditionalUnit * pricePerUnit) / convertRate)

					}

				}
				
			}
		}

		def series = []
		for(String key in tmpMap.keySet()){
			series.add([name: key, data: tmpMap[key]])
		}
		return ["categories": serviceNames, "series": series]
	}
	private BigDecimal[] initBigDecimalArray(int len){
		BigDecimal[] values = new BigDecimal[len];
		for(int i=0; i<len; i++){
			values[i] = new BigDecimal(0);
		}
		return values;
	}

	public def generateSalesSoldByServicesMap(Date fromDate, Date toDate)
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))

		def serviceList = Service.listPublished(user)
		def tmpMap = [:]
		/*for(Service ser in serviceList)
		{
			tmpMap.put(ser.serviceName, 0)
		}*/
      
		def quotationList = Quotation.findAll("FROM Quotation qu WHERE qu.contractStatus.name = 'Accepted' ")// AND qu.opportunity.stagingStatus.name = 'closedWon'")
		PricewellUtils.Println("QuotationList", quotationList.toString());	
		
		
		if(quotationList != null)
		{
			for(Quotation qu in quotationList)
			{
				
				//PricewellUtils.Println("Portfoloid", qu.serviceQuotations.service.portfolio.id.toString());
				//We always store discount amount, so using that.
				
				boolean check = false
				if(fromDate != null && toDate != null)
				{
					if(qu.opportunity.dateModified <= fromDate && qu.opportunity.dateModified >= toDate)
					{
						check = true
					}
				}
				else if(fromDate != null)
				{
					if(qu.opportunity.dateModified <= fromDate)
					{   
						check = true
					}
				}
				if(check == true)
				{
					
					//BigDecimal deductDiscount = qu.discountAmount/(qu?.serviceQuotations?.size())
	
					for(ServiceQuotation sq in qu.serviceQuotations)
					{
						BigDecimal convertRate = 1
						if(sq.geo.convert_rate != null && sq.geo.convert_rate > 0){
							convertRate = sq.geo.convert_rate
						}
						
						def discountAmount = (sq.price*qu.discountPercent)/100
						
						if(isThere(serviceList, sq.service))
						{
							if(!tmpMap.containsKey(sq.service.serviceName))
							{
								tmpMap.put(sq.service.serviceName, 0)
							}
							
							tmpMap[sq.service.serviceName] = tmpMap[sq.service.serviceName] + ((sq.price - discountAmount) / convertRate)//((sq.price - deductDiscount) / convertRate)
						}
					}
				
			}
			}
			
		}
		def services = []
		def data = []
		for(String key in tmpMap.keySet()){
			services.add(key);
			BigDecimal val = tmpMap[key]
			data.add(val.setScale(DECIMALS, ROUNDING_MODE))
		}
		return ["categories": services, "data": data]
	}
	public def generateSalesSoldByServicesMapUsingPortfolio(Date fromDate, Date toDate,def portfolioId,def territoryId)
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def serviceList = Service.listPublished(user)
		def tmpMap = [:]
		/*for(Service ser in serviceList)
		{
			tmpMap.put(ser.serviceName, 0)
		}*/
		//def findList = Quotation.findAll("FROM Quotation qu inner join qu.serviceQuotations sq  WHERE qu.contractStatus.name = 'Accepted' AND sq.service.portfolio.id = 2 ")// AND qu.opportunity.stagingStatus.name = 'closedWon'")
		//PricewellUtils.Println("QuotationList", findList.toString());
		  // def quotationList=findList.get(0)
	//	def quotationList = Quotation.findAll("FROM Quotation qu WHERE qu.contractStatus.name = 'Accepted' ")// AND qu.opportunity.stagingStatus.name = 'closedWon'")
		//PricewellUtils.Println("QuotationList", quotationList.toString());
		def quotationList
			if(territoryId!=-1)
		{
			//PricewellUtils.Println("territoryId", territoryId);
			quotationList=Quotation.executeQuery("select qu FROM Quotation qu inner join qu.serviceQuotations sq  WHERE qu.contractStatus.name = 'Accepted' AND sq.service.portfolio.id = :portfolio_id AND qu.geo.id= :territoryId",[portfolio_id:portfolioId,territoryId:territoryId])
		}
		else
		{
				
				quotationList=Quotation.executeQuery("select qu FROM Quotation qu inner join qu.serviceQuotations sq  WHERE qu.contractStatus.name = 'Accepted' AND sq.service.portfolio.id = :portfolio_id",[portfolio_id:portfolioId])
		}
		PricewellUtils.Println("QuotationList", quotationList.toString());   
		if(quotationList != null)
		{
			for(Quotation qu in quotationList)
			{
				
				
				//PricewellUtils.Println("Portfoloid", qu.serviceQuotations.service.portfolio.id.toString());
				//We always store discount amount, so using that.
				
				boolean check = false
				if(fromDate != null && toDate != null)
				{
					if(qu.opportunity.dateModified <= fromDate && qu.opportunity.dateModified >= toDate)
					{
						check = true
					}
				}
				else if(fromDate != null)
				{
					if(qu.opportunity.dateModified <= fromDate)
					{
						check = true
					}
				}
				if(check == true)
				{
					
					//BigDecimal deductDiscount = qu.discountAmount/(qu?.serviceQuotations?.size())
	
					for(ServiceQuotation sq in qu.serviceQuotations)
					{
						BigDecimal convertRate = 1
						if(sq.geo.convert_rate != null && sq.geo.convert_rate > 0){
							convertRate = sq.geo.convert_rate
						}
						
						def discountAmount = (sq.price*qu.discountPercent)/100
						
						if(isThere(serviceList, sq.service))
						{
							if(!tmpMap.containsKey(sq.service.serviceName))
							{
								tmpMap.put(sq.service.serviceName, 0)
							}
							
							tmpMap[sq.service.serviceName] = tmpMap[sq.service.serviceName] + ((sq.price - discountAmount) / convertRate)//((sq.price - deductDiscount) / convertRate)
						}
					}
				
			}
			}
			
		}
		def services = []
		def data = []
		for(String key in tmpMap.keySet()){
			services.add(key);
			BigDecimal val = tmpMap[key]
			data.add(val.setScale(DECIMALS, ROUNDING_MODE))
		}
		return ["categories": services, "data": data]
	}
	public Map countVSOEDiscounting(Date startDate, Date endDate, Geo territory)
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def quotationList = []
		float greater15 = 0//for % greater then +15
		float less_15 = 0 // for % less then -15
		def discountArray = []

		def filterCriteria = new FilterCriteria()
		filterCriteria.setFilterProps(["type": "all"])
		//filterCriteria.setFromDate(startDate)
		//filterCriteria.setToDate(endDate)

		def opportunityList = opportunityService.getUserOppoertunities(user, filterCriteria)
		opportunityList = listOpportunityBetweenDates(opportunityList, startDate, endDate, null)
		if(!SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR"))
		{
			opportunityList = filterOpportunityByTerritory(opportunityList, territory)
		}

		for(Object op in opportunityList)
		{
			//if(op.stagingStatus.name == "closedWon")
			//{
				for(Quotation qu in op?.quotations)
				{
					if(qu.status.name == "Accepted" && qu.contractStatus.name == "Accepted")
					{
						quotationList.add(qu)
					}
				}
			//}
		}
		discountArray = getAcceptedQuoteDiscount(quotationList)

		return ["data": discountArray]
	}

	public def getAcceptedQuoteDiscount(List quotationList)
	{
		def discountArray = []
		float greater15 = 0//for % greater then +15
		float less_15 = 0 // for % less then -15
		for(Quotation q in quotationList)
		{
			if(q.discountPercent > 15)
			{
				greater15++;
			}
			else if(q.discountPercent < -15)
			{
				less_15++;
			}

		}
		if(quotationList.size()>0)
		{
			discountArray = [
				[
					'> +15',
					(greater15*100)/quotationList.size()
				],
				[
					'-15 >',
					(less_15*100)/quotationList.size()
				],
				[
					'Compliant',
					((quotationList.size()-(greater15 + less_15))*100)/quotationList.size()
				]
			]
		}

		return discountArray
	}

	public Date removeTime(Date date) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		cal.set(Calendar.MILLISECOND, 0);
		return cal.getTime();
	}
	
	public int countAssignedPortfolios(User user)
	{
		def portfolioList = Portfolio.findAll("from Portfolio pf WHERE pf.portfolioManager.id = :uid",[uid: user.id])
		//println portfolioList
		return portfolioList.size()
	}

	public def findPortfoliosAssignedByPortfolioManager(List pmList)
	{
		def myList = []
		int portfolioCounter = 0
		for(User pm in pmList)
		{
			portfolioCounter = countAssignedPortfolios(pm)
			myList.add('name':pm.profile?.fullName,'data': [portfolioCounter])
			portfolioCounter = 0
		}
		//println myList
		return myList
	}

	public def buildChartDataForQuotesPendingDays(Geo territory,Date fromDate,Date toDate)
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def tmpTypes = [
			"LEAD",
			"OPPORTUNITY",
			"QUOTE",
			"SOW"
		]
		def dataArray = []
		def today = new Date()

		def quoteCount=0, sowCount=0
		def leadList = [], opportunityList = [], sowList = [], quoteList = [], opList = [], tmpLeads = []

		FilterCriteria filterCriteria = new FilterCriteria()
		FilterCriteria filterCriteria2 = new FilterCriteria()

		opList = opportunityService.getUserOppoertunities(user, filterCriteria)
		//opList = filterOpportunityByTerritory(opList, territory)
		if(toDate!=null && fromDate!=null)
		{
		opList = filterOpportunityByTerritoryWithDate(opList, territory, fromDate, toDate)
		}
		else
		{
			opList = filterOpportunityByTerritory(opList, territory)
		}
		tmpLeads = leadService.getUserLeads(user, filterCriteria)
		
		//for <10 days
		filterCriteria.setFromDate(today); filterCriteria.setToDate(today-9);
		leadList = listLeadsBetweenDates(tmpLeads, removeTime(today), removeTime(today-9), "pending")//leadService.getUserLeads(user, filterCriteria)
		opportunityList = listOpportunityBetweenDates(opList, removeTime(today), removeTime(today-9), "pending")//opportunityService.getUserOppoertunities(user, filterCriteria)
		quoteCount = pendingQuotationCount(opList, removeTime(today), removeTime(today-9))
		sowCount = pendingSOWCount(opList, removeTime(today), removeTime(today-9))
		dataArray.add([name: "<10", data:  [
				leadList.size(),
				opportunityList.size(),
				quoteCount,
				sowCount
			]]);
		
		
		//between <10 and <20
		filterCriteria.setFromDate(today-10); filterCriteria.setToDate(today-19);
		leadList = listLeadsBetweenDates(tmpLeads, removeTime(today-10), removeTime(today-19), "pending")//leadService.getUserLeads(user, filterCriteria)
		opportunityList = listOpportunityBetweenDates(opList, removeTime(today-10), removeTime(today-19), "pending")//opportunityService.getUserOppoertunities(user, filterCriteria)
		quoteCount = pendingQuotationCount(opList, removeTime(today-10), removeTime(today-19))
		sowCount = pendingSOWCount(opList, removeTime(today-10), removeTime(today-19))
		dataArray.add([name: "<20", data:  [
				leadList.size(),
				opportunityList.size(),
				quoteCount,
				sowCount
			]]);
		
		
		//netween 20 to 30
		filterCriteria.setFromDate(today-20); filterCriteria.setToDate(today-29);
		leadList = listLeadsBetweenDates(tmpLeads, removeTime(today-20), removeTime(today-29), "pending")//leadService.getUserLeads(user, filterCriteria)
		opportunityList = listOpportunityBetweenDates(opList, removeTime(today-20), removeTime(today-29), "pending")//opportunityService.getUserOppoertunities(user, filterCriteria)
		quoteCount = pendingQuotationCount(opList, removeTime(today-20), removeTime(today-29))
		sowCount = pendingSOWCount(opList, removeTime(today-20), removeTime(today-29))
		dataArray.add([name: "<30", data:  [
				leadList.size(),
				opportunityList.size(),
				quoteCount,
				sowCount
			]]);
		
		
		//between 30 to 40
		filterCriteria.setFromDate(today-30); filterCriteria.setToDate(today-39);
		leadList = listLeadsBetweenDates(tmpLeads, removeTime(today-30), removeTime(today-39), "pending")//leadService.getUserLeads(user, filterCriteria)
		opportunityList = listOpportunityBetweenDates(opList, removeTime(today-30), removeTime(today-39), "pending")//opportunityService.getUserOppoertunities(user, filterCriteria)
		quoteCount = pendingQuotationCount(opList, removeTime(today-30), removeTime(today-39))
		sowCount = pendingSOWCount(opList, removeTime(today-30), removeTime(today-39))
		dataArray.add([name: "<40", data:  [
				leadList.size(),
				opportunityList.size(),
				quoteCount,
				sowCount
			]]);
		
		
		//between 40 to 50
		filterCriteria.setFromDate(today-40); filterCriteria.setToDate(today-49);
		leadList = listLeadsBetweenDates(tmpLeads, removeTime(today-40), removeTime(today-49), "pending")//leadService.getUserLeads(user, filterCriteria)
		opportunityList = listOpportunityBetweenDates(opList, removeTime(today-40), removeTime(today-49), "pending")//opportunityService.getUserOppoertunities(user, filterCriteria)
		quoteCount = pendingQuotationCount(opList, removeTime(today-40), removeTime(today-49))
		sowCount = pendingSOWCount(opList, removeTime(today-40), removeTime(today-49))
		dataArray.add([name: "<50", data:  [
				leadList.size(),
				opportunityList.size(),
				quoteCount,
				sowCount
			]]);
		
		
		//between 50 to 60
		filterCriteria.setFromDate(today-50); filterCriteria.setToDate(null);
		filterCriteria2.setFromDate(today-50);
		leadList = listLeadsBetweenDates(tmpLeads, removeTime(today-50), null, "pending")//leadService.getUserLeads(user, filterCriteria2)
		opportunityList = listOpportunityBetweenDates(opList, removeTime(today-50), null, "pending")//opportunityService.getUserOppoertunities(user, filterCriteria2)
		quoteCount = pendingQuotationCount(opList, removeTime(today-50), null)
		sowCount = pendingSOWCount(opList, removeTime(today-50), null)
		dataArray.add([name: ">=50", data:  [
				leadList.size(),
				opportunityList.size(),
				quoteCount,
				sowCount
			]]);

		return ["categories": tmpTypes, "series": dataArray]

	}

	public List listOpportunityBetweenDates(List tmpOpp, Date fromDate, Date toDate, def type)
	{
		def opportunityList = []
		for(Opportunity op : tmpOpp)
		{
			Date convertedDate = /*dateService.*/removeTime(op.dateCreated)
			if(fromDate != null && toDate != null)
			{
				if(convertedDate <= fromDate && convertedDate >= toDate)
				{
					opportunityList.add(op)
				}
				/*else if(op.closeDate <= fromDate && op.closeDate >= toDate)
				{
					opportunityList.add(op)
				}*/
			}
		
			else if(fromDate != null)
			{
				if(convertedDate <= fromDate)
				{
					opportunityList.add(op)
				}
				/*else if(op.closeDate <= fromDate)
				{
					opportunityList.add(op)
				}*/
			}
		}
		if(type == "pending")
		{
			 tmpOpp = new ArrayList(); tmpOpp = opportunityList; opportunityList = []
			 for(Opportunity op : tmpOpp)
			 {
				 if(op.stagingStatus.sequenceOrder < 68)
				 {
					 opportunityList.add(op)
				 }
			 }
		}
		
		
		return opportunityList
	}
	
	public List listLeadsBetweenDates(List tmpLeads, Date fromDate, Date toDate, def type)
	{
		def leadList = []
		for(Lead l1 in tmpLeads)
		{
			Date convertedDate = /*dateService.*/removeTime(l1.dateCreated)
			if(fromDate != null && toDate != null)
			{
				fromDate = removeTime(fromDate)
				toDate = removeTime(toDate)
				if(convertedDate <= fromDate && convertedDate >= toDate)
				{
					leadList.add(l1)
				}
			}
		
			else if(fromDate != null)
			{
				fromDate = removeTime(fromDate)
				if(convertedDate <= fromDate)
				{
					leadList.add(l1)
				}
			}
		}
		
		if(type == "pending")
		{
			tmpLeads = []; tmpLeads = leadList; leadList = [] 
			for(Lead ld : tmpLeads)
			{
				if(ld.stagingStatus.sequenceOrder < 53)
				{
					leadList.add(ld)	
				}
			}
		}
		return leadList
	}

	public def pendingQuotationCount(List opportunityList, Date fromDate, Date toDate)
	{
		def quoteCount=0
		for(Opportunity op in opportunityList)
		{
			if(op.stagingStatus.sequenceOrder < 68)
			{
				for(Quotation qu in op?.quotations)
				{
					Date convertedDate = /*dateService.*/removeTime(qu.createdDate)
					if(fromDate != null && toDate != null)
					{
						if(convertedDate <= fromDate && convertedDate >= toDate)
						{
							if(qu.status.sequenceOrder > 0 && qu.status.sequenceOrder < 5)//qu.status.sequenceOrder != -1 && qu.status.sequenceOrder != 0 && qu.status.sequenceOrder != 5)
							{
								quoteCount = quoteCount + 1
							}
						}
					}
					else if(fromDate != null)
					{
						if(convertedDate <= fromDate )
						{
							if(qu.status.sequenceOrder > 0 && qu.status.sequenceOrder < 5)//qu.status.sequenceOrder != -1 && qu.status.sequenceOrder != 0 && qu.status.sequenceOrder != 5)
							{
								quoteCount = quoteCount + 1
							}
						}
					}
				}
			}
		}
		return quoteCount
	}

	public def pendingSOWCount(List opportunityList, Date fromDate, Date toDate)
	{
		def sowCount=0
		for(Opportunity op in opportunityList)
		{
			if(op.stagingStatus.sequenceOrder < 68)
			{
				for(Quotation qu in op?.quotations)
				{
					Date convertedDate = /*dateService.*/removeTime(qu.createdDate)
					if(fromDate != null && toDate != null)
					{
						if(convertedDate <= fromDate && convertedDate >= toDate)
						{
							if( qu.contractStatus.sequenceOrder > 0 &&  qu.contractStatus.sequenceOrder < 5)// && qu.contractStatus.sequenceOrder != 0 && qu.contractStatus.sequenceOrder != -1)
							{
								sowCount = sowCount + 1
							}
						}
					}
					else if(fromDate != null)
					{
						if(convertedDate <= fromDate)
						{
							if( qu.contractStatus.sequenceOrder > 0 &&  qu.contractStatus.sequenceOrder < 5)// && qu.contractStatus.sequenceOrder != 0 && qu.contractStatus.sequenceOrder != -1)
							{
								sowCount = sowCount + 1
							}
						}
					}
				}
			}
		}
		return sowCount
	}
	
	public Map buildSalesQuotesChartData(User salesUser, Date fromDate, Date toDate, Geo territory)
	{
		List typesdata  = [
			"LEAD",
			"OPPORTUNITY",
			"QUOTE",
			"SOW"
		]
		Map map = [:], servicesMap = [:]
		def leadList = [], opportunityList = [], tmpLeads = [], tmpOpp = []
		def leadTotal=0, leadLost=0, leadSuccess=0
		def quoteTotal=0, quoteLost=0, quoteSuccess=0, quotePending = 0
		def oppTotal=0, oppLost=0, oppSuccess=0
		def sowTotal=0, sowLost=0, sowSuccess=0, sowPending = 0

		FilterCriteria filterCriteria = new FilterCriteria()

		Map<String,String> aMap = Collections.singletonMap("source","dealStatusGraph"); // Not a HashMap

		filterCriteria.setFilterProps(aMap)
		
		//filterCriteria.setFromDate(fromDate); filterCriteria.setToDate(toDate);
		
		fromDate = removeTime(fromDate)
		if(toDate != null)
		{
			toDate = removeTime(toDate)
		}
		
		tmpLeads = leadService.getUserLeads(salesUser, filterCriteria);
		leadList = listLeadsBetweenDates(tmpLeads, fromDate, toDate, null)
		leadTotal = leadList.size()
		for(Lead ld in leadList)
		{
			if(ld.stagingStatus.sequenceOrder == 53)
			{
				leadSuccess++
			}
			else if(ld.stagingStatus.sequenceOrder == 54)
			{
				leadLost++
			}
		}
		
		tmpOpp = opportunityService.getUserOppoertunities(salesUser, filterCriteria);
		opportunityList = listOpportunityBetweenDates(tmpOpp, fromDate, toDate, null)
		opportunityList = filterOpportunityByTerritory(opportunityList, territory)
		oppTotal = opportunityList.size()
		for(Opportunity op in opportunityList)
		{
			if(op.stagingStatus.sequenceOrder == 68)
			{
				oppSuccess++
			}
			else if(op.stagingStatus.sequenceOrder == 69)
			{
				oppLost++
			}
		}
		
		opportunityList = []; opportunityList = opportunityService.getUserOppoertunities(salesUser, filterCriteria)
		opportunityList = filterOpportunityByTerritory(opportunityList, territory)
		
		for(Opportunity op : opportunityList)
		{
			for(Quotation qu in op?.quotations)
			{
				boolean check = false
				Date convertedDate = /*dateService.*/removeTime(qu.createdDate)
				if(fromDate != null && toDate != null)
				{
					if(convertedDate <= fromDate && convertedDate >= toDate)
					{
						check = true
					}
				}
				else if(fromDate != null)
				{
					if(convertedDate <= fromDate)
						check = true
				}
				if(check == true)
				{
					if(op.stagingStatus.sequenceOrder < 68 && qu.status.sequenceOrder != -1 && qu.status.sequenceOrder != 0 && qu.status.sequenceOrder != 5)
					{
						quotePending++
					}
					if(qu.status.sequenceOrder == 5)
					{
						quoteSuccess++
					}
					else if(qu.status.sequenceOrder == -1)
					{
						quoteLost++
					}
	
					if(op.stagingStatus.sequenceOrder < 68 && qu.contractStatus.sequenceOrder != -1 && qu.contractStatus.sequenceOrder != 0 &&  qu.contractStatus.sequenceOrder != 5)
					{
						sowPending++
					}
					if(qu.contractStatus.sequenceOrder == 5)
					{
						sowSuccess++
					}
					else if(qu.contractStatus.sequenceOrder == -1)
					{
						sowLost++
					}
				}
			}
		}

		map["categories"] = typesdata;
		int[] counts = new int[typesdata.size()]

		map["series"] = [
			[name: "Total", data: [
					Lead.list().size(),
					Opportunity.list().size(),
					Quotation.list().size(),
					0
				]]
		];

		map["series1"] = [
			[name: "Pending", data: [
					leadTotal-leadLost-leadSuccess,
					oppTotal-oppLost-oppSuccess,
					quotePending,
					sowPending
				]],
			[name: "Lost",  data: [
					leadLost,
					oppLost,
					quoteLost,
					sowLost
				]],
			[name: "Success", data: [
					leadSuccess,
					oppSuccess,
					quoteSuccess,
					sowSuccess
				]]
		];
		return map;

	}

	public def buildChartDataForUserStatusByRole()
	{
		int activeIndex = 0;
		int newIndex = 1;
		int closedIdex = 2;

		List catagories = ["Active", "New", "Closed"]

		List activeList = []//["Active"]
		List newList = []//["New"]
		List closedList = []//["Closed"]
		List roles = Role.list(sort:"name")
		List rolesCodes = roles.code
		List plotColors = getPlotColor(rolesCodes.size()-1)

		List columns = []//[['string', 'Account Status']]
		List columns1 = []
		//Initializing roles counter
		for(int i=0; i<rolesCodes.size(); i++)
		{
			if(rolesCodes[i] != "USER")
			{
				activeList.add(0)
				newList.add(0)
				closedList.add(0)
				columns.add(['number', roles[i].name])
				columns1.add(roles[i].name)
			}
		}

		def lastdate = new Date()-30

		for(User user in User.list())
		{
			def userRoles = user.roles.code

			for(roleCode in userRoles)
			{
				if(roleCode != "USER")
				{
					int index = rolesCodes.indexOf(roleCode)

					if(index >= 0)
					{
						if(user.enabled)
						{
							activeList[index]++;
						}
						else
						{
							closedList[index]++;
						}

						if(user.dateCreated >= lastdate)
						{
							newList[index]++;
						}

					}
				}
			}


		}

		List data = []
		for(int i = 0; i<columns1.size(); i++)
		{
			data.add('name':columns1[i],'data': [
				activeList[i],
				newList[i],
				closedList[i]
			])
		}

		//println data
		List values = [
			activeList,
			newList,
			closedList
		]

		return ["catagories": catagories, "data": data, "plotColors": plotColors]
	}
	public def buildChartDataForUserStatusByRoleWithDate(def fromDate,def toDate)
	{
		int activeIndex = 0;
		int newIndex = 1;
		int closedIdex = 2;

		List catagories = ["Active", "New", "Closed"]

		List activeList = []//["Active"]
		List newList = []//["New"]
		List closedList = []//["Closed"]
		List roles = Role.list(sort:"name")
		List rolesCodes = roles.code
		List plotColors = getPlotColor(rolesCodes.size()-1)

		List columns = []//[['string', 'Account Status']]
		List columns1 = []
		//Initializing roles counter
		for(int i=0; i<rolesCodes.size(); i++)
		{
			if(rolesCodes[i] != "USER")
			{
				activeList.add(0)
				newList.add(0)
				closedList.add(0)
				columns.add(['number', roles[i].name])
				columns1.add(roles[i].name)
			}
		}

		def lastdate = new Date()-30
			
		for(User user in User.list())
		{
			def userRoles = user.roles.code
			Date modifiedDate = dateService.removeTime(user?.dateCreated)
			for(roleCode in userRoles)
			{
				if(roleCode != "USER")
				{
					int index = rolesCodes.indexOf(roleCode)

					if(index >= 0)
					{
						if(user.enabled)
						{
							if(modifiedDate >= fromDate && modifiedDate <= toDate)
							{
								activeList[index]++;
								
							}
							
						}
						else
						{
							if(modifiedDate >= fromDate && modifiedDate <= toDate)
							{
								closedList[index]++;
								
							}
							
						}

						if(user.dateCreated >= lastdate)
						{
							newList[index]++;
						}

					}
				}
			}


		}

		List data = []
		for(int i = 0; i<columns1.size(); i++)
		{
			data.add('name':columns1[i],'data': [
				activeList[i],
				newList[i],
				closedList[i]
			])
		}

		//println data
		List values = [
			activeList,
			newList,
			closedList
		]

		return ["catagories": catagories, "data": data, "plotColors": plotColors]
	}

	public def findEstimateVarianceForSDs()
	{
		Set serviceDesignerList = new HashSet(), list1 = new HashSet()
		
		def loginUser = User.get(new Long(SecurityUtils.subject.principal))
		def serviceList = ServiceProfile.findAll("FROM ServiceProfile sp WHERE sp.service.productManager.id = :uid", [uid: loginUser.id])
		for(ServiceProfile sp : serviceList)
		{
			if(sp.serviceDesignerLead != null)
			{serviceDesignerList.add(sp.serviceDesignerLead)
			list1.add(sp.serviceDesignerLead?.id)
			}
		}
		
		
		def retList = []
		def serviceDesigner = []
		def serviceDesignerVariance = []
		for(Object userId in list1.toList())
		{
			def user = User.get(userId)
			//Only get services which has passed design review stage which should be applicable for calculating estimate
			def servicesList = ServiceProfile.findAll("FROM ServiceProfile sp WHERE sp.service.productManager.id = :lid AND sp.serviceDesignerLead.id = :uid AND sp.stagingStatus.sequenceOrder > 22", [uid: user.id, lid: loginUser.id])

			if(servicesList)
			{

				BigDecimal estiVeri = calculateAverageVariance(servicesList)
				serviceDesigner.add(user.profile?.fullName)
				def index = serviceDesigner.indexOf(user.profile?.fullName)
				serviceDesignerVariance.add(index,estiVeri)
				retList.add('name': user.profile?.fullName,'data': [estiVeri])

			}
		}
		println retList
		return [categories: serviceDesigner, data: serviceDesignerVariance]
	}

	public def findEstimateVarianceForPMs()
	{
		Set productManagerIdList = new HashSet()
		def loginUser = User.get(new Long(SecurityUtils.subject.principal))
		def serviceList = ServiceProfile.findAll("FROM ServiceProfile sp WHERE sp.service.portfolio.portfolioManager.id = :uid", [uid: loginUser.id])
		for(ServiceProfile sp : serviceList)
		{
			if(sp?.service?.productManager != null)
			{
					productManagerIdList.add(sp?.service?.productManager?.id)
			}
		}
		def retList = []
		def productManager = []
		def productManagerVariance = []
		
		for(def Id in productManagerIdList.toList())
		{
			def user = User.get(Id.toLong())
			//Only get services which has passed design review stage which should be applicable for calculating estimate
			def servicesList = ServiceProfile.findAll("FROM ServiceProfile sp WHERE sp.service.portfolio.portfolioManager.id = :lid AND sp.service.productManager.id = :uid AND sp.stagingStatus.sequenceOrder > 22", [uid: user.id, lid: loginUser.id])
			if(servicesList)
			{

				BigDecimal estiVeri = calculateAverageVariance(servicesList)
				productManager.add(user.profile?.fullName)
				def index = productManager.indexOf(user.profile?.fullName)
				productManagerVariance.add(index, estiVeri)
				retList.add('name': user.profile?.fullName,'data': [estiVeri])
			}
		}
		println retList
		return [categories: productManager, data: productManagerVariance]
	}

	/*
	 *  Algorithm used:
	 *		Inputs (Services)
	 *		
	 *		Find variance for each service and then take an average
	 *		To Calculate variance for each service, we will use following formula for totalTime for baseUnits and time for additional units
	 *		Formula: ABS((B1-A1)/ ABS(A1)) * 100, where A1 is actual value and 
	 */
	private BigDecimal calculateAverageVariance(List servicesList)
	{
		BigDecimal total = 0;

		for(ServiceProfile ser in servicesList)
		{
			def map = [:]
			map = ser.calculateTotalEstimatedTime()
			BigDecimal actualBaseHrs = map["totalFlat"]
			BigDecimal actualExtraHrs = map["totalExtra"]
			BigDecimal estimateBaseHrs = ser.totalEstimateInHoursFlat
			BigDecimal estimateExtraHrs = ser.totalEstimateInHoursPerBaseUnits

			total += calculateVariance(actualBaseHrs, estimateBaseHrs) +
					calculateVariance(actualExtraHrs, estimateExtraHrs);

		}

		//println "Total ${total}"

		return  total.divide(new BigDecimal(servicesList.size() * 2), DECIMALS, ROUNDING_MODE)
	}

	//Formula: ABS((B-A)/ ABS(A)) * 100, where A is actual value and
	private BigDecimal calculateVariance(BigDecimal actual, BigDecimal estimate){
		BigDecimal r = estimate - actual;
		//	println "Estimate:${estimate} Actual:${actual}"
		r = r * 100;
		if(actual != 0){
			r = r.divide(actual.abs(), DECIMALS, ROUNDING_MODE);
		}
		//	println "Variance ${r}"
		return r.abs()
	}

	public List findServiceQuoteList()
	{
		def sq = ServiceQuotation.findAll()
		def set = new HashSet()
		for(Object s in sq)
		{
			set.add(s.service)
		}
		def ser = set.toList()

		def serviceQuote = []
		for(Object s in ser)
		{
			serviceQuote.add(findQuoteByService(s))
		}

		return serviceQuote
	}

	public Map buildQuotesByServicesChartData()
	{

		Map map = [:]

		map = buildQuotesMap( map)
		def columns = [["string", "Service Name"]]
		List data = []

		for(def type in types)
		{
			columns.add(["number", type])
		}

		for(String key in map.keySet())
		{
			List tmpData = [key]
			int[] cs= map.get(key)
			tmpData.addAll(cs)
			data.add(tmpData)
		}

		return ["columns": columns, "data": data]

	}

	public Map buildQuotesMap( Map map)
	{
		def sq = ServiceQuotation.findAll()
		def set = new HashSet()
		for(Object s in sq)
		{
			set.add(s.service)
		}
		def ser = set.toList()

		def myList = []
		for(Object s in ser)
		{
			map.put(s?.serviceName, findQuoteCounts(s, null))
			myList.add('name': s?.serviceName, 'data': findQuoteCounts(s, null))
		}
		//	println myList
		return map
	}

	public def buildQuotesMap()
	{
		def sq = ServiceQuotation.findAll()
		def set = new HashSet()
		for(Object s in sq)
		{
			set.add(s.service)
		}
		def ser = set.toList()

		def myList = []
		for(Object s in ser)
		{
			myList.add('name': s?.serviceName, 'data': findQuoteCounts(s, null))
		}

		return ['dataList': myList, "categories": types]
	}

	

	public Map buildQuotesByTypesHighChartData(User createdBy, Portfolio portfolio, Date from, Date to)
	{
		Map map = [:]
		Map servicesMap = [:]

		map["categories"] = types;
		map["series"] = [];

		def qu = null;
		if(createdBy){
			qu = Quotation.findAll("FROM Quotation qu WHERE createdBy.id = uid",[ uid: createdBy.id])
		}
		else{
			qu = Quotation.findAll("FROM Quotation qu")
		}

		if(!qu)
			return map;

		for(Quotation q in qu){
			int typeIndex = types.indexOf(q.status.toString());

			for(ServiceQuotation sq in q.serviceQuotations){
				if(!portfolio || (sq.profile.service.portfolio.id == portfolio.id) )
				{
					String serviceName = sq.profile.service.serviceName;
					int c = (servicesMap[serviceName]?servicesMap[serviceName]++:1);
					servicesMap[serviceName] = c;
				}
			}
		}

	}

	public Map buildQuoetsByTypesChartData()
	{
		buildQuoetsByTypesChartData(null);
	}

	public Map buildQuoetsByTypesChartData(Portfolio portfolio)
	{

		Map map = [:];

		map = buildQuotesMap(map)

		def columns = [["string", "Quote Type"]]

		for(String serviceName in map.keySet())
		{
			columns.add(["number", serviceName])
		}

		List data = []

		for(def type in types)
		{
			List tmpData = [type]

			for(String serviceName in map.keySet())
			{
				tmpData.add(map.get(serviceName)[types.indexOf(type)])
			}

			data.add(tmpData)
		}



		for(String key in map.keySet())
		{
			List tmpData = [key]
			int[] cs= map.get(key)
			tmpData.addAll(cs)
		}

		return ["columns": columns, "data": data]
	}

	//ServiceList, types, counts

	public int[] findQuoteCounts(Service ser, User createdBy)
	{
		int total=0

		def counts = new int[types.size()]

		for(def type in types)
		{
			def qu = null;
			if(createdBy){
				qu = Quotation.findAll("FROM Quotation qu ")//WHERE :type in(qu.status) and createdBy.id = uid",[type: type, uid: createdBy.id])
			}
			else{
				qu = Quotation.findAll("FROM Quotation qu ")//WHERE :type in(qu.status)",[type: type])
			}

			for(Object q in qu)
			{
				if(ser in (q.serviceQuotations.service))
				{
					counts[types.indexOf(type)]++
				}
			}
		}

		return counts
	}

	public def findQuoteByService(Service ser)
	{
		int quote = 0,lead=0,sow=0,contract=0,reject=0,total=0

		List types = [
			"QUOTE",
			"LEAD",
			"SOW",
			"CONTRACT",
			"REJECT"
		]
		int[] counts = new int[types.size()]

		for(def type in types)
		{
			def qu = Quotation.findAll("FROM Quotation qu WHERE :type in(qu.status)",[type: type])
			for(Object q in qu)
			{
				if(ser in (q.serviceQuotations.service))
				{
					counts[types.indexOf(type)]++
				}
			}
		}


		for(def c in counts)
		{
			total+= c
		}
		return [
			ser,
			total,
			counts[types.indexOf("QUOTE")],
			counts[types.indexOf("LEAD")],
			counts[types.indexOf("SOW")],
			counts[types.indexOf("CONTRACT")],
			counts[types.indexOf("REJECT")]
		]
	}

	public def findSalesUsers()
	{
		def salesUsers = []
		salesUsers.addAll(serviceCatalogService.findUsersByRole("SALES PERSON"))
		salesUsers.addAll(serviceCatalogService.findUsersByRole("SALES MANAGER"))
		salesUsers.addAll(serviceCatalogService.findUsersByRole("SALES PRESIDENT"))
		salesUsers.addAll(serviceCatalogService.findUsersByRole("GENERAL MANAGER"))
		return salesUsers
	}

	public def findUserAccounts()
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def accountList = [], tempList = []
		def usersList = []
		Set users = new HashSet(); Set accounts = new HashSet()

		if(SecurityUtils.subject.hasRole("SALES PERSON"))
		{
			usersList.add(user)
		}
		else if(SecurityUtils.subject.hasRole("SALES MANAGER"))
		{
			for(Object territory in user?.territories)
			{
				users.addAll(leadService.findSalesUsersInGeo(territory))
			}
			usersList.addAll(users.toList())
			usersList.add(user)
		}
		else if(SecurityUtils.subject.hasRole("GENERAL MANAGER"))
		{
			for(Object territory in user?.geoGroup?.geos)
			{
				users.addAll(leadService.findSalesUsersInGeo(territory))
			}
			usersList.addAll(users.toList())
			usersList.add(user)
		}

		if(SecurityUtils.subject.hasRole("SALES PRESIDENT") || SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR"))
		{
			accountList = Account.findAll("FROM Account ac")
		}
		else
		{
			for(User us in usersList)
			{
				tempList = Account.findAll("FROM Account ac WHERE ac.assignTo.id = ${us.id} OR ac.createdBy.id = ${us.id}")
				accounts.addAll(tempList)
			}
			accountList.addAll(accounts.toList())
		}
		return accountList
	}
	//--------------------------Recent Login Activity---------------Admin DashBoard------------------------------
	public List recentLoginRecord(def startDate,def endDate)
	{
		List<LoginRecord> lastLoginList = new ArrayList<LoginRecord>()
		List tempList = new ArrayList();
		User user = User.get(new Long(SecurityUtils.subject.principal))
		
		if(user?.username != "superadmin")
		{
			tempList = LoginRecord.findAll("FROM LoginRecord lr WHERE lr.owner.username != 'superadmin' ORDER BY lr.dateCreated DESC")
		}
		else
		{
			tempList = LoginRecord.findAll("FROM LoginRecord lr ORDER BY lr.dateCreated DESC")
		}
		
		Set userIdSet = new HashSet()
		int i = 0;
		for(LoginRecord lr : tempList)
		{
			if(i<10 && !userIdSet.contains(lr?.owner?.id))
			{
				if(lr?.dateCreated != null)
				{
					Date modifiedDate = dateService.removeTime(lr?.dateCreated)
					//PricewellUtils.Println("Modified Date", modifiedDate)
					if(modifiedDate >= startDate && modifiedDate <= endDate)
					{
						//PricewellUtils.Println("Difference Between", startDate +" "+endDate)
						userIdSet.add(lr?.owner?.id)
						lastLoginList.add(lr)
						i++
					}
				}
			
				
				if(i==10)
				{
					break
				}
			}
		}
		
		
		return lastLoginList//.sort{it?.owner?.profile?.fullName}
	}
	
	//-----------Service Variance-------------Admin Dashboard---------------
//	public List getServiceTicketRelatedOpportunitiesWithDate(def startDate,def endDate)
//	{
//		def quotationList = Quotation.findAll("From Quotation qu WHERE qu.convertToTicket='yes' AND qu.contractStatus.name = 'Accepted'")
//		Set opportunitySet = new HashSet()
//		for(Quotation qu : quotationList?.sort{it?.opportunity?.name})
//		{
//			if(qu?.modifiedDate != null)
//			{
//				//PricewellUtils.Println("If role")
//				Date modifiedDate = dateService.removeTime(qu?.modifiedDate)
//				//PricewellUtils.Println("Modified Date", modifiedDate)
//				if(modifiedDate >= startDate && modifiedDate <= endDate)
//				{
//					//PricewellUtils.Println("In")
//					//PricewellUtils.Println("Difference Between", startDate +" "+endDate)
//					opportunitySet.add(qu.opportunity)
//				}
//			}
//			
//			
//		}
//		List opportunityList = opportunitySet.toList()
//		
//		return opportunityList
//	}
	public Map calculateServiceVarianceForOpportunityWithDate(Opportunity opportunity,def startDate,def endDate)//,
	{
		def quotationList = Quotation.findAll("From Quotation qu WHERE qu.convertToTicket='yes'AND qu.opportunity.id = :opid AND qu.contractStatus.name = 'Accepted'", [opid: opportunity?.id])
		//def quotationList = Quotation.findAll("From Quotation qu WHERE qu.convertToTicket='yes' AND qu.contractStatus.name = 'Accepted'")
		Map serviceMap = new HashMap()
		for(Quotation quotation : quotationList)
		{
			if(quotation?.modifiedDate != null)
			{
				
				PricewellUtils.Println(quotation?.modifiedDate)  
				Date modifiedDate = dateService.removeTime(quotation?.modifiedDate)
				//PricewellUtils.Println("Modified Date", modifiedDate)
				if(modifiedDate >= startDate && modifiedDate <= endDate)
				{
					for(ServiceQuotation sQuotation : quotation?.serviceQuotations)
					{
				Map serviceHoursMap = getServiceQuotationHoursMap(sQuotation)
				
				BigDecimal serviceVariance = calculateVariance(serviceHoursMap['totalActualHours'], serviceHoursMap['totalEstimateHours'])
				
				if(!serviceMap.containsKey(sQuotation?.service?.serviceName)){
					List serviceDataList = new ArrayList()
					serviceDataList.add(new BigDecimal(0))//for saving veriance
					serviceDataList.add(new BigDecimal(0))//for saving quotation count
					serviceMap.put(sQuotation?.service?.serviceName, serviceDataList)
				}
				
				List dataValue = serviceMap[sQuotation?.service?.serviceName]
				dataValue[0] = dataValue[0] + serviceVariance
				dataValue[1] = dataValue[1] + 1
				serviceMap[sQuotation?.service?.serviceName] = dataValue
			}
				}
		}
		}
		List services = new ArrayList(), data = new ArrayList()
		
		for(String key in serviceMap.keySet())
		{
			services.add(key)
			List dataValue = serviceMap[key]
			
			data.add(dataValue[0]/dataValue[1])
		}
		
		return [categories: services, data: data]
	
	}
}
