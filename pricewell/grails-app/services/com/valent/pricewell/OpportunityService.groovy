package com.valent.pricewell

import java.util.Collection;
import java.util.Map.Entry;
import java.util.Date;
import java.util.List;

import org.apache.shiro.SecurityUtils
import org.codehaus.groovy.grails.commons.ConfigurationHolder;

class OpportunityService {

    static transactional = true

	private static int ROUNDING_MODE = BigDecimal.ROUND_HALF_EVEN;
	
	def dateService, quotaService, salesCatalogService
	OpportunityExpireTimer newExpTimer
	
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
	
   public Collection<Opportunity> search(SalesSearchCriteria opportunitySearchCriteria)
   { 
	  def opportunityList  = new HashSet()
	  List opportunities = [], tmpList = []
	  Map<String, String> opportunityFilterProp = opportunitySearchCriteria.filterCriteria.getFilterProps()
	  def dateRang = ""
	  def query = ""
	  def opportunityTypeQuery = "op.stagingStatus.name != ''"
	  
	  if(opportunityFilterProp != null)
	  {
		  //println opportunityFilterProp
		  for (Map.Entry<String, String> prop : opportunityFilterProp.entrySet()) {
			  if(prop.getKey() == "type")
				{
					if(prop.getValue() == "closedWon")
					{
						opportunityTypeQuery = "op.stagingStatus.name = 'closedWon'"
					}
					else if(prop.getValue() == "closedLost")
					{
						opportunityTypeQuery = "op.stagingStatus.name = 'closedLost'"
					}
					else if(prop.getValue() == "pending")
					{
						opportunityTypeQuery = "op.stagingStatus.name != 'closedWon' AND op.stagingStatus.name != 'closedLost'"
					}
					else{
						opportunityTypeQuery = opportunityTypeQuery + ""
					}
				}
		  }
	  }
	  
	  if(opportunitySearchCriteria.filterCriteria.fromDate != null && opportunitySearchCriteria.filterCriteria.toDate != null)
	  {
		  dateRang = "op.dateCreated BETWEEN ? AND ? OR op.closeDate BETWEEN ? AND ?"
	  }
	  
	  if(opportunitySearchCriteria.type ==  SalesSearchCriteria.SalesSearchType.searchByOwners)
	  {
		  
		  for(User us in opportunitySearchCriteria?.owners)
		  {
			  if(dateRang == "")
			  {
				  query = "FROM Opportunity op WHERE " + opportunityTypeQuery + " AND (op.createdBy.id = ${us?.id} OR op.assignTo.id = ${us?.id}) ORDER BY dateModified DESC"
				  opportunities = Opportunity.executeQuery(query)
			  }
			  else
			  {
				  query = "FROM Opportunity op WHERE " + opportunityTypeQuery + " AND (op.createdBy.id = ${us?.id} OR op.assignTo.id = ${us?.id}) AND "+dateRang+" ORDER BY dateModified DESC"
				  opportunities = Opportunity.executeQuery(query,[opportunitySearchCriteria.filterCriteria.fromDate ,opportunitySearchCriteria.filterCriteria.toDate,opportunitySearchCriteria.filterCriteria.fromDate ,opportunitySearchCriteria.filterCriteria.toDate])
			  }
			  
			  for(Opportunity op in opportunities)
			  {
				  opportunityList.add(op)
			  }
		  }
	  }
	  else if(opportunitySearchCriteria.type ==  SalesSearchCriteria.SalesSearchType.searchByGeos)
	  {
		  for(Object geo in opportunitySearchCriteria?.geos)
		  {
			  if(dateRang == "")
			  {
				  query = "FROM Opportunity op WHERE " + opportunityTypeQuery + " AND op.geo.id = ${geo?.id} ORDER BY dateModified DESC"
				  opportunities = Opportunity.executeQuery(query)
			  }
			  else
			  {
				  query = "FROM Opportunity op WHERE " + opportunityTypeQuery + " AND op.geo.id = ${geo?.id} AND "+dateRang+" ORDER BY dateModified DESC"
				  opportunities = Opportunity.executeQuery(query,[opportunitySearchCriteria.filterCriteria.fromDate ,opportunitySearchCriteria.filterCriteria.toDate, opportunitySearchCriteria.filterCriteria.fromDate ,opportunitySearchCriteria.filterCriteria.toDate])
			  }
			  
			  for(Opportunity op in opportunities)
			  {
				  opportunityList.add(op)
			  }
		  }
	  }
	  else if(opportunitySearchCriteria.type ==  SalesSearchCriteria.SalesSearchType.searchAll)
	  {
		  if(dateRang == "")
		  {
			  query = "FROM Opportunity op WHERE " + opportunityTypeQuery + " ORDER BY dateModified DESC"
			  opportunities = Opportunity.executeQuery(query)
		  }
		  else
		  {
			  query = "FROM Opportunity op WHERE " + opportunityTypeQuery + " AND " + dateRang + " ORDER BY dateModified DESC"
			  opportunities = Opportunity.executeQuery(query,[opportunitySearchCriteria.filterCriteria.fromDate ,opportunitySearchCriteria.filterCriteria.toDate, opportunitySearchCriteria.filterCriteria.fromDate ,opportunitySearchCriteria.filterCriteria.toDate])
		  }
		  
		  for(Opportunity op in opportunities)
		  {
			  opportunityList.add(op)
		  }
		  
		  
	  }
	  
	  /*if(opportunitySearchCriteria.filterCriteria.fromDate != null && opportunitySearchCriteria.filterCriteria.toDate != null)
	  {
		  tmpList = opportunityList
		  opportunityList = []
		  for(Opportunity op in tmpList)
		  {
		  	  if(op.stagingStatus.sequenceOrder < 68)
			  {
				  opportunityList.add(op)
			  }
			  
		  }
	  }
	  else if(opportunitySearchCriteria.filterCriteria.fromDate != null )
	  {
	  	  tmpList = opportunityList
		  opportunityList = []
		  for(Opportunity op in tmpList)
		  {
		      
			  if(op.stagingStatus.sequenceOrder < 68)
			  {
				  opportunityList.add(op)
			  }
			 
		  }
	  }*/
	   
	  return opportunityList.toList()
   }
   
   public Collection<Opportunity> getUserOppoertunities(User user, FilterCriteria filterCriteria){
	   SalesUserType userType = SalesUserType.getUserType(user);
	   
	   Collection<Opportunity> searchOps = null;
	   //println "Map properties : " + filterCriteria.getFilterProps()
	   switch(userType){
			   case SalesUserType.SalesUser:
				   List<User> owners = new ArrayList<User>();
				 owners.add(user);
				 searchOps = search(SalesSearchCriteria.createSearchByOwners(owners, filterCriteria))
				   break;
			   case SalesUserType.SalesManager:
				   List<Geo> geos = new ArrayList<Geo>()
				   
				   for(Object territory in user?.territories)
				   {
					   geos.add(territory);
				   }
				 
				   searchOps = search(SalesSearchCriteria.createSearchByGeos(geos, filterCriteria));
				   break;
			   case SalesUserType.GeneralManager:
				   List<Geo> geos = new ArrayList<Geo>()
				   
				   for(Geo territory in user?.geoGroup?.geos)
				   {
					   geos.add(territory);
				   }
				   
				   searchOps = search(SalesSearchCriteria.createSearchByGeos(geos, filterCriteria));
				   break;
			   case SalesUserType.SalesPresident:
				   searchOps = search(SalesSearchCriteria.createSearchAll(filterCriteria));
				   break;
			   case SalesUserType.Administrator:
				   searchOps = search(SalesSearchCriteria.createSearchAll(filterCriteria));
				   break;
	   }
	   
	   return searchOps;
   }
   
   public Collection retrieveOpportunityList(def type, Map dateMap)
   {
	   def accountList = Account.findAll("FROM Account ac")
	   def opportunityList = [], tmpList=[]
	   User user = null
	   if(dateMap['user'] != "" && dateMap['user'] != null)
	   {
		   user = User.get(dateMap['user'].id)
	   }
	   else user = User.get(new Long(SecurityUtils.subject.principal))
	   
	   
	   FilterCriteria filterCriteria = new FilterCriteria()
	   filterCriteria.setFilterProps(["type": type.toString()])
	   if(dateMap.size()>0 && dateMap['fromDate'] != null && dateMap['toDate'] != null)
	   {
		   filterCriteria.setFromDate(dateMap['fromDate']); 
		   filterCriteria.setToDate(dateMap['toDate']);
	   }
	   opportunityList = getUserOppoertunities(user, filterCriteria)
	   
	   return opportunityList
	   //checkOpportunities(opportunityList)
	   
	   /*Set opportunitySet = new HashSet()
	   
	   for(Opportunity op : opportunityList)
	   {
		   if(type == "closedWon" && op.stagingStatus.name == "closedWon")
		   {
			   opportunitySet.add(op)
		   }
		   else if(type == "closedLost" && op.stagingStatus.name == "closedLost")
		   {
			   opportunitySet.add(op)
		   }
		   else if(type == "pending" && op.stagingStatus.name != "closedLost" && op.stagingStatus.name != "closedWon")
		   {
			   opportunitySet.add(op)
		   }
	   }
	   
	   return opportunitySet.toList()*/
   }
   
   public void checkThis(OpportunityExpireTimer expTimer)
   {
	   newExpTimer = new OpportunityExpireTimer(expTimer.opportunityService)
	   expTimer.push()
	   println "in opportunity service"
	   newExpTimer.resume()
   }
   
   public def checkOpportunities(OpportunityExpireTimer expTimer)
   {
	   newExpTimer = new OpportunityExpireTimer(expTimer.opportunityService)
	   expTimer.push()
	   
	   Date today = new Date()
	   for(Opportunity op : Opportunity.list())
	   {
		   if(op.stagingStatus.name != "closedWon" && op.stagingStatus.name != "closedLost")
		   {
			   
			   if(op.closeDate <= today)
			   {
				   for(Quotation quote : op.quotations)
				   {
					   if(quote.status.name != "rejected" && quote.status.name != "Accepted")
					   {
						   convertQuotationToRejectStage(quote)
						   println "Quote " +quote.id + " is expired because of opportunity is expired."
					   }
					   if(quote.contractStatus.name != 'rejected' && quote.contractStatus.name != 'Accepted')
					   {
						   convertQuotationContractToRejectStage(quote)
					   }
					  
				   }
				   
				   convertOpportunityToRejectStage(op)
			   }
			   else
			   {
				   for(Quotation quote : op.quotations)
				   {
					   if(quote.createdDate + quote.validityInDays <= today)
					   {
						   if(quote.status.name != "rejected" && quote.status.name != "Accepted")
						   {
							   convertQuotationToRejectStage(quote)
							   println "Quote " +quote.id + "is expired but opportunity is not expired yet."
						   }
						   if(quote.contractStatus.name != 'rejected' && quote.contractStatus.name != 'Accepted')
						   {
							   convertQuotationContractToRejectStage(quote)
						   }
					   }
				   }
			   }
		   }
		   
		   else
		   {
			   def countQuote = 0
			   if(op?.quotations?.size() == 0)
			   {
				   convertOpportunityToRejectStage(op)
			   }
			   else if(op.stagingStatus.name == "closedWon")
			   {
				   for(Quotation quote : op?.quotations)
				   {
					   if(quote?.status?.name != "rejected" && quote?.status?.name != "Accepted")
					   {
						   convertQuotationToRejectStage(quote)
						   countQuote++
					   }
					   else if(quote?.status?.name == "rejected")
					   {
						   countQuote++
					   }
					   else if(quote?.status?.name == "Accepted")
					   {
						   quote?.confidencePercentage = 100
						   quote.save()
					   }
				   }
				   if(countQuote == op?.quotations?.size())
				   {
					   convertOpportunityToRejectStage(op)
				   }
			   }
			   else if(op.stagingStatus.name == "closedLost")
			   {
				   for(Quotation quote : op?.quotations)
				   {
					   if(quote.status.name != "rejected" && quote.status.name != "Accepted")
					   {
						   convertQuotationToRejectStage(quote)
						   println "Quote " +quote.id + "is expired but opportunity is not expired yet."
					   }
					   if(quote.contractStatus.name != 'rejected' && quote.contractStatus.name != 'Accepted')
					   {
						   convertQuotationContractToRejectStage(quote)
					   }
				   }
			   }
		   }
	   }
	   
	   newExpTimer.resume()
   }
   
   public def convertQuotationToRejectStage(Quotation quote)
   {
	   Staging endStage =  Staging.findByName("rejected")
	   quote?.status = endStage
	   quote.contractStatus = endStage
	   quote.modifiedDate = new Date()
	   quote.confidencePercentage = 0
	   quote.save()
	   
   }
   
   public def convertQuotationContractToRejectStage(Quotation quote)
   {
	   Staging endStage =  Staging.findByName("rejected")
	   quote.contractStatus = endStage
	   quote.modifiedDate = new Date()
	   quote.confidencePercentage = 0
	   quote.save()
   }
   
   public def convertOpportunityToRejectStage(Opportunity op)
   {
	   Staging opportunityEndStage = Staging.findByName("closedLost")
	   op.stagingStatus = opportunityEndStage
	   op.dateModified = new Date()
	   op.save()
   }

   public Map getUserCurrencyMap()
   {
	   def currency = "", currencySymbol = ""
	   User user = User.get(new Long(SecurityUtils.subject.principal))
	   
	   if(SecurityUtils.subject.hasRole("SALES PERSON"))
	   {
		   currencySymbol = user?.territory?.currencySymbol
		   currency = user?.territory?.currency
	   }
	   else
	   {
		   CompanyInformation companyInformationInstance = CompanyInformation.list().get(0);
		   currencySymbol = companyInformationInstance?.baseCurrencySymbol//territoryInstance?.currencySymbol
		   currency = companyInformationInstance?.baseCurrency
	   }
	   return [currency: currency, currencySymbol: currencySymbol]
   }
   
   public List getUserPendingAndWonOpportunityList(User user)
   {
	   List opportunityList = new ArrayList()
	   List tmpList = retrieveOpportunityList("closedWon", [user: user]);
	   List tmpList2 = retrieveOpportunityList("pending", [user: user]);
	   
	   for(Opportunity op : tmpList)
	   {
		   opportunityList.add(op)
	   }
	   
	   for(Opportunity op : tmpList2)
	   {
		   opportunityList.add(op)
	   }
	   
	   return opportunityList
   }
   
   public List filterOpportunityListByDate(List opportunityList, Map dateMap)
   {
	   List filteredList = new ArrayList()
	   
	   for(Opportunity op : opportunityList)
	   {
		   if((op.dateCreated >= dateMap['fromDate'] && op.dateCreated <= dateMap['toDate']) || (op.closeDate >= dateMap['fromDate'] && op.closeDate <= dateMap['toDate']))
		   {
			   filteredList.add(op)
		   }
	   }
	   return filteredList
   }
   
   public Map getQuotaAssignedVsQuotaAchivement(Map dateMap, Geo territory)
   {	
	   User user = User.get(new Long(SecurityUtils.subject.principal))
	   BigDecimal totalAssignedValue = new BigDecimal(0), totalAchievedValue = new BigDecimal(0), percent = new BigDecimal(0)
	   List quotaList = new ArrayList(), opportunityList = new ArrayList(), personList = new ArrayList(), data = new ArrayList()
	   Set territoryList =  new HashSet()
	   def territoryInstance = null, currency = "", currencySymbol = ""
	   
	   Map currencyMap = getUserCurrencyMap()
	   currency = currencyMap['currency']
	   currencySymbol = currencyMap['currencySymbol']
	   
	   quotaList = quotaService.filterQuotaByDate(dateMap, quotaService.getUserQuotaList())
	   totalAssignedValue = quotaService.calculateQuotaAmount(quotaList, user)
	   personList = quotaService.getQuotasPersonList(quotaList)
	   
	   Date fromDate = dateMap['fromDate'], toDate = dateMap['toDate']
	   opportunityList = getUserPendingAndWonOpportunityList(user)
	   opportunityList = filterOpportunityListByDate(opportunityList, dateMap)
	   
	   /*for(User person : personList.toList())
	   {
		   if(SecurityUtils.subject.hasRole("SALES PERSON"))
		   {*/
			   BigDecimal achievedValue = new BigDecimal(0)
			   achievedValue = calculateTotalQuotaAchieved(opportunityList)//ByPerson(person, opportunityList)
			   totalAchievedValue = totalAchievedValue + achievedValue
		  /* }
	   }*/
	   
	   if(totalAssignedValue > 0 )
	   {
		   percent = ( totalAchievedValue / totalAssignedValue) * 100
	   }
	   percent = percent.setScale(0, BigDecimal.ROUND_HALF_EVEN);
	   if(totalAchievedValue > totalAssignedValue)
	   {
		   data = [['Exceed By', totalAchievedValue-totalAssignedValue], ['Assigned', totalAssignedValue]]
		   return ['data': data, 'Achieved': totalAchievedValue, 'Exceed By': totalAchievedValue-totalAssignedValue, 'Assigned': totalAssignedValue, 'Greater': 'achieved', 'Percent': percent, 'territory': territoryInstance, 'currency': currency, currencySymbol: currencySymbol]//'territoryList': territoriesQuota['territories'], 
	   }
	   else
	   {
		   data = [["Achieved", totalAchievedValue], ['Remains', totalAssignedValue-totalAchievedValue]]
		   return ['data': data, 'Achieved': totalAchievedValue, 'Remains': totalAssignedValue-totalAchievedValue, 'Assigned': totalAssignedValue, 'Greater': 'assigned', 'Percent': percent, 'territory': territoryInstance, 'currency': currency, currencySymbol: currencySymbol]//'territoryList': territoriesQuota['territories'], 
	   }
   }
   
   public BigDecimal calculateTotalQuotaAchieved(List opportunityList)//ByPerson(User person, List opportunityList)
   {
	   BigDecimal totalAchievedValue = new BigDecimal(0)
	   boolean calculateAchievedValue = false
	   
	   for(Opportunity op : opportunityList)
	   {
		   for(Quotation q : op?.latestQuotations())
		   {
			   if(q.forecastValue && q.confidencePercentage)
			   {
				   if(q.confidencePercentage >= 100 && q.contractStatus.name == "Accepted")
				   {
					   //println "QAsVQAc Op : "+op.name + " price : "+q.finalPrice
					   //println "quotation id : "+q.id+" price : "+q.finalPrice+ " opportunity : "+q.opportunity.name
					   
					   if(SecurityUtils.subject.hasRole("SALES PERSON"))
					   {
						   totalAchievedValue += q.finalPrice
					   }
					   else //if(SecurityUtils.subject.hasRole("SALES MANAGER"))
					   {
						   totalAchievedValue += q.finalPrice.divide(op?.geo?.convert_rate, ROUNDING_MODE)//convert to base currency
					   }
					   
				   }
			   }
		   }
		   calculateAchievedValue = false
	   }
	 
	  return totalAchievedValue
   }
   
   public Map getQuotaAssignedVsQuotaAchivementPerPersons(Map dateMap, Geo territory)
   {
	   def assigned = new BigDecimal(0)
	   def user = User.get(new Long(SecurityUtils.subject.principal))
	   
	   def territoryInstance = null, currency = "", currencySymbol = ""
	   
	   List quotaAchieved = new ArrayList(), quotaAssigned = new ArrayList()
	   List assignedPerson = new ArrayList(), achievedPerson = new ArrayList(), persons = new ArrayList(), personList = new ArrayList()
	   List opportunityList = new ArrayList(), tmpList = new ArrayList(), tmpList2 = new ArrayList(), quotaList = new ArrayList()
	   Set myList2 = new HashSet(), territoryList = new HashSet()
	   
	   Map currencyMap = getUserCurrencyMap()
	   currency = currencyMap['currency']
	   currencySymbol = currencyMap['currencySymbol']
	   
	   quotaList = quotaService.filterQuotaByDate(dateMap, quotaService.getUserQuotaList())
	   BigDecimal totalAssignedValue = quotaService.calculateQuotaAmount(quotaList, user)
	   personList = quotaService.getQuotasPersonList(quotaList)
	   
	   opportunityList = getUserPendingAndWonOpportunityList(user)
	   opportunityList = filterOpportunityListByDate(opportunityList, dateMap)
	   BigDecimal totalAchievedValue = calculateTotalQuotaAchieved(opportunityList)
	   
	   for(User person : personList)
	   {
		   List userOpportunityList = new ArrayList()
		   
		   BigDecimal assignedValue = new BigDecimal(0)
		   assignedValue = quotaService.calculateQuotaAmount(quotaList, person)
		   
		   userOpportunityList = getUserPendingAndWonOpportunityList(person)
		   userOpportunityList = filterOpportunityListByDate(userOpportunityList, dateMap)
		   
		   BigDecimal achievedValue = new BigDecimal(0)
		   achievedValue = calculateTotalQuotaAchieved(userOpportunityList)
		   
		   if(assignedValue > 0 || achievedValue > 0)
		   {
			   persons.add(person.profile.fullName)
			   def index = persons.indexOf(person.profile.fullName)
			   quotaAssigned.add(index, assignedValue)
			   quotaAchieved.add(index, achievedValue)
			   
			   totalAssignedValue = totalAssignedValue - assignedValue
			   totalAchievedValue = totalAchievedValue - achievedValue
		   }
		   
	   }
	   
	   if(totalAchievedValue > 0)
	   {
		   persons.add("My")
		   def index = persons.indexOf("My")
		   quotaAssigned.add(index, 0)
		   quotaAchieved.add(index, totalAchievedValue)
	   }
	   
	   def data = new ArrayList()
	   data.add('name': 'Achieved', 'data': quotaAchieved)
	   data.add('name': 'Assigned', 'data': quotaAssigned)
	   return ['catagories': persons, 'data': data, 'currency': currency, currencySymbol: currencySymbol]
	   //return ['assignedPerson': assignedPerson, 'remains': quotaRemains, 'achieved': quotaAchieved, 'achievedPerson': achievedPerson, 'exceed': quotaExceed, 'assigned': quotaAssigned]
   }
   
   /*
    * opportunityList = new ArrayList()
		   for(Opportunity op : tmpList)
		   {
			   if(op?.assignTo?.id ==  person?.id || op?.createdBy?.id ==  person?.id)
					   opportunityList.add(op)
		   }
		   //BigDecimal achievedValue = new BigDecimal(0)
		   achievedValue = totalQuotaAchived(opportunityList)
		   
		   for(Quota quota : quotaList)
		   {
			   if(quota?.person?.id == person?.id)
			   		assignedValue = assignedValue + quota.amount
		   }*/
   
   Map getTerritoryQuotas(Geo territory)
   {
	   def user = User.get(new Long(SecurityUtils.subject.principal))
	   def territoryInstance = null, currency = ""
	   def quotaList = []
	   Set territoryList = new HashSet()
	   
	   if(SecurityUtils.subject.hasRole("SALES MANAGER"))
	   {
		   quotaList = Quota.findAll("FROM Quota quota WHERE quota.createdBy.id=:uid", [uid: user.id])
	   }
	   else if(SecurityUtils.subject.hasRole("SALES PERSON"))
	   {
		   quotaList = Quota.findAll("FROM Quota quota WHERE quota.person.id=:uid", [uid: user.id])
	   }
	   
	   for(Quota qu : quotaList)
	   {
		   territoryList.add(qu.person?.territory)
	   }
	   
	   if(territory != null && territory != "")
	   {
		   territoryInstance = territory
		   println territory
		   currency = territory?.currencySymbol
	   }
	   else
	   {
		   territoryInstance = territoryList.toList()[0]
		   currency = territory?.currencySymbol
	   }
	   return ['quotaList': quotaList, 'territory': territoryInstance, 'territories': territoryList.toList()]
   }
   
   public def totalQuotaAchived(List opportunityList)
   {
	   BigDecimal totalAchievedValue = new BigDecimal(0)
	   
	   for(Opportunity op : opportunityList)
	   {
		   for(Quotation q : op?.latestQuotations())
		   {
			   if(q.forecastValue && q.confidencePercentage)
			   {
				   if(q.confidencePercentage >= 100 && q.contractStatus.name == "Accepted")
				   {
					   //println "QAsVQAc Op : "+op.name + " price : "+q.finalPrice
					   //println "quotation id : "+q.id+" price : "+q.finalPrice+ " opportunity : "+q.opportunity.name
					   if(SecurityUtils.subject.hasRole("SALES MANAGER"))
					   {
						   totalAchievedValue += q.finalPrice.divide(op?.geo?.convert_rate, ROUNDING_MODE)
					   }
					   else if(SecurityUtils.subject.hasRole("SALES PERSON"))
					   {
						   totalAchievedValue += q.finalPrice
					   }
					   
				   }
			   }
		   }
	   }
	 
	  return totalAchievedValue
   	}
   
   public def createNotes(String opportunityId, String comment)
   {
	   def user = User.get(new Long(SecurityUtils.subject.principal))
	   
	   def opportunityInstance = Opportunity.get(opportunityId)
	   
	   println opportunityInstance;
	  
	   Note noteInstance = new Note ();
	   noteInstance.createdBy = user;
	   noteInstance.modifiedBy = user;
	   
	   noteInstance.modifiedDate = new Date();
	   noteInstance.createdDate= new Date();
	   noteInstance.notes = comment;
	   
	   noteInstance.opportunity = opportunityInstance;
	   
	   noteInstance.save(flush : true);
	   
	   
	
	   
   }
   
   public def boolean deleteNote(String noteId)
   {
	   
	   
	  try{
		  
		  def noteInstance = Note.get(noteId)
		  
		  if(noteInstance != null)
		  {
			  noteInstance.delete();
			  return true
		  }
		  else
		  {
			  return false
		  }
	  }
	  catch(Exception e){
		  return false
	  }
	   
   }
   
   
   public def boolean editNote(String noteId, String note)
   {
	   
	   
	  try{
		  
		  def noteInstance = Note.get(noteId)
		  
		  if(noteInstance != null)
		  {
			  noteInstance.notes = note;
			  noteInstance.modifiedDate = new Date();
			  noteInstance.save(flush: true);
			  return true
		  }
		  else
		  {
			  return false
		  }
	  }
	  catch(Exception e){
		  return false
	  }
	   
   }
   
}
