package com.valent.pricewell

class LeadService {

   static transactional = true
   def serviceCatalogService
   public Collection<Lead> search(SalesSearchCriteria leadSearchCriteria)
   {
	   def leadList = [], tmpList = [], leads = []
	   Set leadSet = new HashSet()
	   def dateRang = ""
	   def query = ""
	   
	   if(leadSearchCriteria.type ==  SalesSearchCriteria.SalesSearchType.searchByOwners)
	   {
		  for(User us in leadSearchCriteria?.owners)
		  {
			  
			  query = "FROM Lead ld  WHERE ld.createdBy.id = ${us?.id} OR ld.assignTo.id = ${us?.id} ORDER BY dateModified DESC"
			  leads = Lead.executeQuery(query)
			  	  
			  for(Lead ld in leads)
			  {
				  leadSet.add(ld)
			  }
		  }
		  leadList = leadSet.toList()
	   }
	   else if(leadSearchCriteria.type ==  SalesSearchCriteria.SalesSearchType.searchAll)
	   {
			  query = "FROM Lead ld ORDER BY dateModified DESC"
			  leadList = Lead.executeQuery(query)
		   
	   }
		
	   if(leadSearchCriteria.filterCriteria.fromDate != null && leadSearchCriteria.filterCriteria.toDate != null)
	   {
		   tmpList = leadList
		   leadList = []
		   for(Lead l1 in tmpList)
		   {
			   if(l1.dateCreated <= leadSearchCriteria.filterCriteria.fromDate && l1.dateCreated >= leadSearchCriteria.filterCriteria.toDate)
			   { 
				   //if(l1.stagingStatus.sequenceOrder < 53)
				   //{
					   leadList.add(l1)
				   //}
			   }
		   }
	   }
	   else if(leadSearchCriteria.filterCriteria.fromDate != null)
	   {
		   tmpList = leadList
		   leadList = []
		   for(Lead l1 in tmpList)
		   {
			   if(l1.dateCreated <= leadSearchCriteria.filterCriteria.fromDate)
			   {
				   //if(l1.stagingStatus.sequenceOrder < 53)
				   //{
					   leadList.add(l1)
				   //}
			   }
		   }
	   }
	   
	   return leadList
	   
   }
   
  public Collection<Lead> getUserLeads(User user, FilterCriteria filterCriteria){
	  SalesUserType userType = SalesUserType.getUserType(user);
	  Collection<Lead> searchLeads = null;
	  
	  switch(userType){
			  case SalesUserType.SalesUser:
			  	List<User> owners = new ArrayList<User>();
			    owners.add(user);
				searchLeads = search(SalesSearchCriteria.createSearchByOwners(owners, filterCriteria))
			  	break;
			  case SalesUserType.SalesManager:
			  	  List<Geo> geos = new ArrayList<Geo>()
				  List<User> owners = new ArrayList<User>();
				  Set users = new HashSet()
				  for(Geo territory in user?.territories)
				  {
					  if(territory?.salesPersons.size() > 0)
					  {
						  users.addAll(territory?.salesPersons)
					  }
					  
				  }
				  
				  users.add(user)
				  owners.addAll(users.toList())
				  
				
				searchLeads = search(SalesSearchCriteria.createSearchByOwners(owners, filterCriteria))
			  	break;
			  case SalesUserType.GeneralManager:
			  	List<Geo> geos = new ArrayList<Geo>();
				//TODO: Get Geos under Geogroup of general manager   
			  	List<User> owners = new ArrayList<User>();
				Set users = new HashSet()
				for(Geo territory in user?.geoGroup?.geos)
				{
					if(territory?.salesPersons.size() > 0)
					{
						users.addAll(territory?.salesPersons)
					}
					
					if(territory?.salesManager)
					{
						users.add(territory?.salesManager)
					}
					
    			}
				
				users.add(user)
				owners.addAll(users.toList())
				searchLeads = search(SalesSearchCriteria.createSearchByOwners(owners, filterCriteria))
			  	break;
			  case SalesUserType.SalesPresident:
			  	searchLeads = search(SalesSearchCriteria.createSearchAll(filterCriteria));
			    break;
			  case SalesUserType.Administrator:
				searchLeads = search(SalesSearchCriteria.createSearchAll(filterCriteria));
				break;
	  }
	  
	  return searchLeads;
  } 
  
  private Collection<User> findSalesUsersInGeo(Geo geo)
  { 
	  def users = serviceCatalogService.findUsersByRole("SALES PERSON")
	  def userList = []
	  for(User us in users)
	  {
		  if(us?.territory?.id == geo.id)
		  {
			  userList.add(us)
		  }
	  }
	  return userList
  }
  
}
