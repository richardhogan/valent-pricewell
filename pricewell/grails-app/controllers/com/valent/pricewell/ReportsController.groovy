package com.valent.pricewell
import org.apache.shiro.SecurityUtils
import com.ibm.icu.text.SimpleDateFormat
import grails.converters.JSON


class ReportsController {

	def reviewService
	
	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		log.info("[User: ${user.profile.fullName}] - ${actionUri} with params ${params}")
	}
	
    def index = { 
        redirect(action: "statusOfQuotes", params: params)
		}
	
	def statusOfQuotes = {
		 List quotesList = null
		 
		 Geo geoInstance = null
		 
		 if(params.geoId && params.geoId != "all")
		 {
			 quotesList = Quotation.findAll("from Quotation q where q.geo.id = :geoId", [geoId: params.geoId.toLong()])
			 geoInstance = Geo.get(params.geoId.toLong())
		 }
		 else
		 {
			 quotesList = Quotation.list()
		 }
		 
		 
		 int totalQuotes = 0
		 Map statsMap = [:]
		 
		 for(Quotation quote in quotesList)
		 {
			 String quoteStatus = quote.status.toString()
			 if(!statsMap[quoteStatus])
			 {
				 statsMap[quoteStatus] = 0
			 }
			 
			 statsMap[quoteStatus] += 1
			 totalQuotes += 1
		 }
		 
		 def qoutesColumns = [['string', 'Quote Status'], ['number', 'values']]
		 def quotesValues = []
		 for(String key in statsMap.keySet())
		 {
			 quotesValues.add([key, statsMap[key]]) 
		 }
		
		 [quotationInstanceList: quotesList,qoutesColumns: qoutesColumns,quotesValues: quotesValues, totalQuotes: totalQuotes, geoInstance: geoInstance]
	}
	
	def productManagerestimateveriance = {
		
		def productManagerEstimatedVeriance = []
		productManagerEstimatedVeriance = reviewService.findEstimateVarianceForPMs()
		[ productManagerEstimatedVeriance: productManagerEstimatedVeriance]
	}
	
	def pmVarianceData = {
		
		def productManagerEstimatedVeriance = []
		productManagerEstimatedVeriance = reviewService.findEstimateVarianceForPMs()
		
		render productManagerEstimatedVeriance as JSON
		
	}
	
	def designestimatesample = {
		
		def serviceDesignerEstimatedVeriance = []
		serviceDesignerEstimatedVeriance = [
	                
	                	[
	                		'name': 'John Lam',
	                		
	                		'data': [10]
	                	],
	                	[
	                		'name': 'Mary Elston',
	                		
	                		'data': [15]
	                	],
	                	[
	                		'name': 'Peter Duglas',
	                		
	                		'data': [15]
	                	],
	                	[
	                		'name': 'Andy Smith',
	                		
	                		'data': [4]
	                	],
	                	[
							'name': 'Vinit Chawla',
	                		
	                		'data': [8]
	                	]
	                ]
		
		
		[ serviceDesignerEstimatedVeriance: serviceDesignerEstimatedVeriance]
	}
	
	def totalUnitsSold = 
	{
		def seqList = ServiceQuotation.findAll("FROM ServiceQuotation sq WHERE sq.quotation.contractStatus.name = 'Accepted'")
		Set serviceSet = new HashSet()
		int totalUnits = 0
		def totalUnitSoldForService = []
		Map map = new HashMap()
		for(ServiceQuotation sq in seqList)
		{
			serviceSet.add(sq.service.serviceName)
		}
		for(Service s in serviceSet.toList())
		{
			map[s] = 0
		}
		
		for(ServiceQuotation sq in seqList)
		{
			map[sq.service.serviceName] = map[sq.service.serviceName] + sq.totalUnits
			totalUnits = totalUnits + sq.totalUnits
		}
		
		for (String key : map.keySet()) {
			totalUnitSoldForService.add([key, map.get(key)*100/totalUnits])
		}
		render(view: "totalunitssoldsample", model: [totalUnitSoldForService: totalUnitSoldForService])
	}
	
	def VSOEDiscount = {
		println params.fromDate
		println params.toDate
		Map totaldiscount = [:]
		totaldiscount = reviewService.countVSOEDiscounting()
		render (template: "VSOEDiscounting", model: [totaldiscount: totaldiscount])
	}
	
	def dealStatusChart =
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date startDate = dateFormat.parse(params.start);
		Date endDate = dateFormat.parse(params.end);
		println startDate
		println endDate
		
		Map quoteTypesMap = [:]
		quoteTypesMap = reviewService.buildSalesQuotesChartData(user, new Date(), new Date())
		render (template: "dealStatus", model: [quoteTypesMap: quoteTypesMap])
	}
	
}
