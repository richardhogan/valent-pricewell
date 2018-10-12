package com.valent.pricewell

import java.text.DateFormat
import java.text.ParseException
import java.text.SimpleDateFormat
import java.util.Collection;
import java.util.Map;

class QuotationService {

    static transactional = true
	private static int ROUNDING_MODE = BigDecimal.ROUND_HALF_EVEN;
	private static int DECIMALS = 2;
	
	private static BigDecimal DAY_HRS_STANDARD = new BigDecimal("8")
	
	public Collection<Quotation> search(SalesSearchCriteria quotationSearchCriteria){
	
	}

	public Collection<Quotation> getUserQuotations(User user, FilterCriteria filterCriteria){
	   SalesUserType userType = SalesUserType.getUserType(user);
	   
	   Collection<Quotation> searchQuotes = null;
	   
	   switch(userType){
			   case SalesUserType.SalesUser:
				   List<User> owners = new ArrayList<User>();
				 owners.add(user);
				 searchQuotes = search(SalesSearchCriteria.createSearchByOwners(owners, filterCriteria))
				   break;
			   case SalesUserType.SalesManager:
				   List<Geo> geos;
				 //TODO: Get Geos sales manager is assigned.
				   searchQuotes = search(SalesSearchCriteria.createSearchByGeos(geos, filterCriteria));
				   break;
			   case SalesUserType.GeneralManager:
				   List<Geo> geos;
				 //TODO: Get Geos under Geogroup of general manager
				   searchQuotes = search(SalesSearchCriteria.createSearchByGeos(geos, filterCriteria));
				   break;
			   case SalesUserType.SalesPresident:
				   searchQuotes = search(SalesSearchCriteria.createSearchAll(filterCriteria));
			   break;
	   }
	   
	   return searchQuotes;
	}
	
	List findUserQuote(User user)
	{
		List map = new ArrayList()
		def quotationList
		int counter = 0;
		for(Object r in user.roles)
		{
			map[counter++] = r.name
		}
		
		if(!map.contains("SYSTEM ADMINISTRATOR"))
		{
			quotationList = Quotation.findAll("from Quotation qu WHERE qu.createdBy.id=:uid", [uid: user.id])
			return quotationList
		}
		else
		{
			quotationList = Quotation.findAll("from Quotation qu")
			
		}
		return quotationList
	}
	
	List findPendingUserQuotes(User user)
	{
		List map = new ArrayList()
		def quotationList
		int counter = 0;
		for(Object r in user.roles)
		{
			map[counter++] = r.name
		}
		
		if(!map.contains("SYSTEM ADMINISTRATOR"))
		{
			//quotationList = Quotation.findAll("from Quotation qu WHERE qu.createdBy.id=:uid AND status != :status1 AND status != :status2", [uid: user.id, status1: Quotation.Status.CONTRACT , status2: Quotation.Status.REJECTED])
			quotationList = Quotation.findAll("from Quotation qu WHERE qu.createdBy.id=:uid", [uid: user.id])
			return quotationList
		}
		else
		{
			//quotationList = Quotation.findAll("from Quotation qu WHERE status != :status1 AND status != :status2", [status1: Quotation.Status.CONTRACT , status2: Quotation.Status.REJECTED])
			quotationList = Quotation.findAll("from Quotation qu")
		}
		return quotationList
	}
	
	Map calculteServicePrice(Service service, Geo geo)
	{
		int baseUnits = service?.serviceProfile.baseUnits
		calculteServicePrice(service, geo, baseUnits + 1)
	}
	
	public DocumentTemplate getTerritoryDefaultDocumentTemplate(Quotation quotation)
	{
		DocumentTemplate defaultTemplate = null
		
		for(DocumentTemplate template : quotation?.geo?.sowDocumentTemplates)
		{
			if(template.isDefault)
			{
				defaultTemplate = template
				break
			}
		}
		
		return defaultTemplate
	}
	
	boolean processAndSaveChanges(Quotation quotation)
	{
		BigDecimal totalPrice = new BigDecimal(0)
		
		for(ServiceQuotation sq : quotation?.serviceQuotations)
		{
			if(sq.stagingStatus.name != "delete")
			{
				totalPrice += sq.price
			}
		}
		//quotation?.serviceQuotations.each { totalPrice += it.price }
		quotation.totalQuotedPrice = totalPrice.setScale(DECIMALS, ROUNDING_MODE)
		BigDecimal finalPrice = new BigDecimal(0)
		BigDecimal discountAmount = new BigDecimal(0)
		BigDecimal taxAmount = new BigDecimal(0)
		BigDecimal expenseAmount = new BigDecimal(0)
		BigDecimal totalSowDiscount = new BigDecimal(0)
		
		quotation?.sowDiscounts.each {
			totalSowDiscount += it.amount
		}
		
		if(quotation.flatDiscount)
		{
			quotation.discountAmount = totalSowDiscount + quotation.localDiscount
			discountAmount = quotation.discountAmount
			finalPrice = totalPrice - quotation.discountAmount;
		}else{
			
			quotation.localDiscount = totalPrice * (quotation.discountPercent/100)
			quotation.discountAmount = totalSowDiscount + quotation.localDiscount
			discountAmount =  quotation.discountAmount
			finalPrice = totalPrice - discountAmount;
		}
		
		if(quotation.expenseAmount == null)
		{
			quotation.expenseAmount = 0
		}
		
		expenseAmount = quotation.expenseAmount
		
		taxAmount = finalPrice * (quotation.taxPercent/100)
		finalPrice = finalPrice + taxAmount
		
		finalPrice = finalPrice + expenseAmount
		
		quotation.discountAmount = discountAmount.setScale(DECIMALS, ROUNDING_MODE)
		quotation.taxAmount = taxAmount.setScale(DECIMALS, ROUNDING_MODE)
		quotation.finalPrice = finalPrice.setScale(DECIMALS, ROUNDING_MODE)
		quotation.forecastValue = (quotation.finalPrice *  (quotation.confidencePercentage/100));
		quotation.forecastValue = quotation.forecastValue.setScale(DECIMALS, ROUNDING_MODE)
		//quotation.modifiedDate = new Date()
		quotation?.save(flush:true)
	}
	
	Quotation saveConfidence(Quotation quotation, BigDecimal confidence){
		quotation.confidencePercentage = confidence
		quotation.forecastValue = (quotation.finalPrice *  (quotation.confidencePercentage/100));
		quotation.forecastValue = quotation.forecastValue.setScale(DECIMALS, ROUNDING_MODE)
		quotation.modifiedDate = new Date()
		quotation.save(flush: true);
		return quotation; 
	}
	
	Map calculteServicePrice(Service service, Geo geo, int totalUnits)
	{
		
		def pricelist = Pricelist.findByServiceProfileAndGeo(service.serviceProfile, geo)
		
		BigDecimal basePrice = pricelist.basePrice
		BigDecimal additionalPrice = pricelist.additionalPrice
		
		int additionalUnits = 0
		BigDecimal totalPrice = new BigDecimal(0)
		if(totalUnits > 0)
		{
			if(totalUnits > service.serviceProfile.baseUnits)
			{
				additionalUnits = totalUnits - service.serviceProfile.baseUnits
			}
			
			BigDecimal premiumPercent = (service.serviceProfile?.premiumPercent?:0)
			totalPrice = basePrice + (additionalPrice * additionalUnits)
			totalPrice = totalPrice + ((totalPrice * premiumPercent) / 100)
		}
		
		totalPrice = totalPrice.setScale(DECIMALS, ROUNDING_MODE)
		basePrice = basePrice.setScale(DECIMALS, ROUNDING_MODE)
		additionalPrice = additionalPrice.setScale(DECIMALS, ROUNDING_MODE)
		
		return ["basePrice": basePrice, "additionalPrice": additionalPrice, "totalPrice": totalPrice]
	}
	
	Map calculteServiceProfilePrice(ServiceProfile serviceProfile, Geo geo, int totalUnits, int addtionalExtraUnit)
	{
		
		Pricelist pricelist = Pricelist.findByServiceProfileAndGeo(serviceProfile, geo)
		
		BigDecimal basePrice = pricelist.basePrice
		BigDecimal additionalPrice = pricelist.additionalPrice
		//println basePrice + " " + additionalPrice
		int additionalUnits = 0
		BigDecimal totalPrice = new BigDecimal(0)
		if(totalUnits > 0)
		{
			if(totalUnits > serviceProfile.baseUnits)
			{
				additionalUnits = totalUnits - serviceProfile.baseUnits
				//println "add units : " + additionalUnits
			}
			
			BigDecimal premiumPercent = (serviceProfile?.premiumPercent?:0)
			totalPrice = basePrice + (additionalPrice * additionalUnits)
			totalPrice = totalPrice + ((totalPrice * premiumPercent) / 100)
			//totalPrice = totalPrice + (additionalPrice * addtionalExtraUnit);
			
			if(addtionalExtraUnit > 0)
			{
				totalPrice *= addtionalExtraUnit
			}
			
		}
		
		totalPrice = totalPrice.setScale(DECIMALS, ROUNDING_MODE)
		basePrice = basePrice.setScale(DECIMALS, ROUNDING_MODE)
		additionalPrice = additionalPrice.setScale(DECIMALS, ROUNDING_MODE)
		
		return ["basePrice": basePrice, "additionalPrice": additionalPrice, "totalPrice": totalPrice]
	}
	
	Map calculteServiceProfilePrice(ServiceProfile serviceProfile, Geo geo, int totalUnits)
	{
		
		Pricelist pricelist = Pricelist.findByServiceProfileAndGeo(serviceProfile, geo)
		
		BigDecimal basePrice = (pricelist?.basePrice != null && pricelist?.basePrice > 0) ? pricelist?.basePrice : 0
		BigDecimal additionalPrice = (pricelist?.additionalPrice != null && pricelist?.additionalPrice > 0) ? pricelist?.additionalPrice : 0
		println basePrice + " " + additionalPrice
		int additionalUnits = 0
		BigDecimal totalPrice = new BigDecimal(0)
		if(totalUnits > 0)
		{
			if(totalUnits > serviceProfile.baseUnits)
			{
				additionalUnits = totalUnits - ((serviceProfile?.baseUnits != null && serviceProfile?.baseUnits > 0) ? serviceProfile?.baseUnits : 0)
				println "add units : " + additionalUnits
			}
			
			BigDecimal premiumPercent = (serviceProfile?.premiumPercent?:0)
			totalPrice = basePrice + (additionalPrice * additionalUnits)
			totalPrice = totalPrice + ((totalPrice * premiumPercent) / 100)
		}
		
		totalPrice = totalPrice.setScale(DECIMALS, ROUNDING_MODE)
		basePrice = basePrice.setScale(DECIMALS, ROUNDING_MODE)
		additionalPrice = additionalPrice.setScale(DECIMALS, ROUNDING_MODE)
		
		return ["basePrice": basePrice, "additionalPrice": additionalPrice, "totalPrice": totalPrice]
	}
	
	Map calculteServiceProfilePrice(ServiceProfile serviceProfile, Geo geo, int totalUnits, Map roleHrsCorrection,int addtionalExtraUnit)
	{
		//println 'In calculate Hr. hrscorrections : '
		//println roleHrsCorrection   
		Map resultMap = calculteServiceProfilePrice(serviceProfile, geo, totalUnits, addtionalExtraUnit)
	
		BigDecimal extraTotalPrice = 0  
		Set<Map.Entry<Integer,BigDecimal>> roles=roleHrsCorrection.entrySet();
		
		for(Map.Entry<Integer,BigDecimal> entry:roles)
		{
			//println "Key:"+entry.getKey()+"Value: "+entry.getValue()
						BigDecimal extraHrs = entry.getValue();
			
						DeliveryRole deliveryRole = DeliveryRole.get(entry.getKey())
						RelationDeliveryGeo rateCard =	RelationDeliveryGeo.findByGeoAndDeliveryRole(geo, deliveryRole)
						BigDecimal ratePerHour = rateCard.ratePerDay.divide(DAY_HRS_STANDARD, ROUNDING_MODE)
						//println extraHrs+"roleID"+roleId+" Rae "+ratePerHour
						extraTotalPrice += ratePerHour * extraHrs;
		}
		//roleHrsCorrection.get
		/*for(Integer roleId: roleHrsCorrection.keySet())  
		{
    
			println "Value Of ExtraHrs  "+roleId+roles.contains(roleId)   
			BigDecimal extraHrs = roleHrsCorrection.get(roleId)   

			DeliveryRole deliveryRole = DeliveryRole.get(roleId)
			RelationDeliveryGeo rateCard =	RelationDeliveryGeo.findByGeoAndDeliveryRole(geo, deliveryRole)
			BigDecimal ratePerHour = rateCard.ratePerDay.divide(DAY_HRS_STANDARD, ROUNDING_MODE)
			println extraHrs+"roleID"+roleId+" Rae "+ratePerHour
			extraTotalPrice += ratePerHour * extraHrs;
		}*/
		
		extraTotalPrice = extraTotalPrice.setScale(DECIMALS, ROUNDING_MODE)
		resultMap["additionalPrice"]+= extraTotalPrice
		resultMap["totalPrice"]+= extraTotalPrice

		return resultMap
	}
	
	Map calculteServiceProfilePrice(ServiceProfile serviceProfile, Geo geo, int totalUnits, Map roleHrsCorrections)
	{
		Map resultMap = calculteServiceProfilePrice(serviceProfile, geo, totalUnits)
	
		BigDecimal extraTotalPrice = 0
		
		for (Map.Entry<Integer, BigDecimal> entry : roleHrsCorrections.entrySet()) 
		{

			def extrahrs = entry.getValue()//roleHrsCorrections[roleId]
			BigDecimal extraHrs = new BigDecimal(extrahrs)//roleHrsCorrections[roleId]

			DeliveryRole deliveryRole = DeliveryRole.get(entry.getKey())//roleId)
			RelationDeliveryGeo rateCard =	RelationDeliveryGeo.findByGeoAndDeliveryRole(geo, deliveryRole)
			BigDecimal ratePerHour = (rateCard?.ratePerDay > 0) ? rateCard?.ratePerDay?.divide(DAY_HRS_STANDARD, ROUNDING_MODE) : 0
			extraTotalPrice += ratePerHour * (extraHrs != null ? extraHrs : 0);
		}
		
		extraTotalPrice = extraTotalPrice.setScale(DECIMALS, ROUNDING_MODE)
		resultMap["additionalPrice"]+= extraTotalPrice
		resultMap["totalPrice"]+= extraTotalPrice

		return resultMap
	}
	
	Map createRoleHoursMap(ServiceQuotation serviceQuotation)
	{
		Map roleHrsCorrections = new HashMap()
		for(CorrectionInActivityRoleTime correction : serviceQuotation?.correctionsInRoleTime)
		{
			if(!roleHrsCorrections.containsKey(correction.role.id))
			{
				roleHrsCorrections.put(correction.role.id, new BigDecimal(0))
			}
			roleHrsCorrections[correction.role.id] += correction.extraHours
		}

		return roleHrsCorrections
	}
	
	List getActiveServiceOfQuotation(Quotation quotationInstance)
	{
		List<ServiceQuotation> serviceQuotations = ServiceQuotation.findAll("from ServiceQuotation sq WHERE sq.quotation.id = ${quotationInstance.id} AND sq.stagingStatus.name != 'delete' ORDER BY sq.sequenceOrder")
		return serviceQuotations
	}
	
	/*This will convert date string coming from date picker to real date with date format 
	 * specified in argument.
	 * created by Abhishek Bhandari 8/26/2015
	 */
	Date convertDateStringToDate(String dateFormat, String dateString)
	{
		Date requiredDate = null
		
		def newformat = (dateFormat != "" && dateFormat != null) ? dateFormat.replace("yy", "yyyy").replace("mm", "MM") : "MM/dd/yyyy"
		
		try {
			
			DateFormat df = new SimpleDateFormat(newformat);
			requiredDate =  df.parse(dateString);
			
		} catch (ParseException pe) {
			pe.printStackTrace();
		}
		
		return requiredDate
	}
	
	String convertDateToString(String dateFormat, Date date)
	{
		String dateString = ""
		def newformat = dateFormat.replace("yy", "yyyy").replace("mm", "MM")
		if(date != null)
		{
			try 
			{
				DateFormat df = new SimpleDateFormat(newformat);
				dateString = df.format(date)
				
			} catch (ParseException pe) {
				pe.printStackTrace();
			}
		}	
		return dateString
	}
	
	String getSOWFilenameToGenerateWordDocument(Quotation quotationInstance)
	{
		String fileName = "${quotationInstance?.account?.accountName}-${quotationInstance?.opportunity?.name}-SOW-${quotationInstance?.id}"//"SOWFor${quotationInstance?.account?.accountName}"
		fileName = fileName.replaceAll("[+^,.!@#/\\\$-]*", "")//.replaceAll(" ", "")//removed - from [] brecket
		return fileName
	}
}
