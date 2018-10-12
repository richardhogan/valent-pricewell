package com.valent.pricewell
import grails.plugins.nimble.core.Role

import java.text.DateFormatSymbols
import java.util.Date
import java.util.TreeMap

import org.apache.shiro.SecurityUtils

class ReviewService {

	static transactional = true
	def serviceCatalogService
	def dateService
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

	public def quarterlyTotalSalesByUser()
	{
		def categories = [], data = []
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def opportunityList = new ArrayList(), quotationList = new ArrayList()
		def tmpList = opportunityService.retrieveOpportunityList("closedWon", [:]), tmpList2 = opportunityService.retrieveOpportunityList("pending", [:])
		opportunityList.addAll(tmpList); opportunityList.addAll(tmpList2)
		
		Date today = new Date()
		Integer year = today.year + 1900; Integer month = today.month + 1
		
		Date fromDate = null, toDate = null
		def quarter = dateService.getQuarter(month)
		Map dateMap = dateService.getDatesOfGivenQuarter(quarter,year)
		fromDate = dateService.getDate(dateMap['from']); toDate = dateService.getDate(dateMap['to'])
		
		for(Opportunity op: opportunityList)
		{
			for(Quotation qu : op.quotations)
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
				totalSales = totalSales + ((sq.price - deductDiscount) / convertRate)
			}
		}
		return totalSales
	}
	
	public List getQuotationsBetweenDates(List quotations, Date fromDate, Date toDate)
	{
		def quotationList = []
		
		for(Quotation qu : quotations)
		{
			if(qu.modifiedDate != null)
			{
				Date modifiedDate = dateService.removeTime(qu.modifiedDate)
				if(modifiedDate >= fromDate && modifiedDate <= toDate)
				{
					quotationList.add(qu)
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
	
	public def generateSalesTotalUnitsByServiceMap(Date fromDate, Date toDate) 
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))

		def serviceList = Service.listPublished(user)
		def tmpMap = [:]
		def quotationList = Quotation.findAll("FROM Quotation qu WHERE qu.contractStatus.name = 'Accepted' AND qu.opportunity.stagingStatus.name = 'closedWon'")
		
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
		def quotationList = Quotation.findAll("FROM Quotation qu WHERE qu.contractStatus.name = 'Accepted' AND qu.opportunity.stagingStatus.name = 'closedWon'")

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

		def quotationList = Quotation.findAll("FROM Quotation qu WHERE qu.contractStatus.name = 'Accepted' AND qu.opportunity.stagingStatus.name = 'closedWon'")

		if(quotationList != null)
		{
			for(Quotation qu in quotationList)
			{
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
					BigDecimal deductDiscount = qu.discountAmount/(qu?.serviceQuotations?.size())
	
					for(ServiceQuotation sq in qu.serviceQuotations)
					{
						if(tmpMap.containsKey(sq.service.serviceName))
						{
							BigDecimal convertRate = 1
							if(sq.geo.convert_rate != null && sq.geo.convert_rate > 0){
								convertRate = sq.geo.convert_rate
							}
							tmpMap[sq.service.serviceName] = tmpMap[sq.service.serviceName] + ((sq.price - deductDiscount) / convertRate)
						}
						else if(isThere(serviceList, sq.service))
						{
							tmpMap.put(sq.service.serviceName, 0)
							BigDecimal convertRate = 1
							if(sq.geo.convert_rate != null && sq.geo.convert_rate > 0){
								convertRate = sq.geo.convert_rate
							}
							tmpMap[sq.service.serviceName] = tmpMap[sq.service.serviceName] + ((sq.price - deductDiscount) / convertRate)
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

	public Map countVSOEDiscounting(Date startDate, Date endDate)
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def quotationList = []
		float greater15 = 0//for % greater then +15
		float less_15 = 0 // for % less then -15
		def discountArray = []

		def filterCriteria = new FilterCriteria()
		//filterCriteria.setFromDate(startDate)
		//filterCriteria.setToDate(endDate)

		def opportunityList = opportunityService.getUserOppoertunities(user, filterCriteria)
		opportunityList = listOpportunityBetweenDates(opportunityList, startDate, endDate, null)

		for(Object op in opportunityList)
		{
			if(op.stagingStatus.name == "closedWon")
			{
				for(Quotation qu in op?.quotations)
				{
					if(qu.status.name == "Accepted" && qu.contractStatus.name == "Accepted")
					{
						quotationList.add(qu)
					}
				}
			}
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

	public def buildChartDataForQuotesPendingDays()
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
				if(convertedDate <= fromDate && convertedDate >= toDate)
				{
					leadList.add(l1)
				}
			}
		
			else if(fromDate != null)
			{
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
	
	public Map buildSalesQuotesChartData(User salesUser, Date fromDate, Date toDate)
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

		return ["catagories": catagories, "data": data]
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
		for(Object userId in list1.toList())
		{
			def user = User.get(userId)
			//Only get services which has passed design review stage which should be applicable for calculating estimate
			def servicesList = ServiceProfile.findAll("FROM ServiceProfile sp WHERE sp.service.productManager.id = :lid AND sp.serviceDesignerLead.id = :uid AND sp.stagingStatus.sequenceOrder > 22", [uid: user.id, lid: loginUser.id])

			if(servicesList)
			{

				BigDecimal estiVeri = calculateAverageVariance(servicesList)

				retList.add('name': user.profile?.fullName,'data': estiVeri)

			}
		}
		return retList
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
		
		for(def Id in productManagerIdList.toList())
		{
			def user = User.get(Id.toLong())
			//Only get services which has passed design review stage which should be applicable for calculating estimate
			def servicesList = ServiceProfile.findAll("FROM ServiceProfile sp WHERE sp.service.portfolio.portfolioManager.id = :lid AND sp.service.productManager.id = :uid AND sp.stagingStatus.sequenceOrder > 22", [uid: user.id, lid: loginUser.id])
			if(servicesList)
			{

				BigDecimal estiVeri = calculateAverageVariance(servicesList)

				retList.add('name': user.profile?.fullName,'data': estiVeri)
			}
		}
		return retList
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
}
