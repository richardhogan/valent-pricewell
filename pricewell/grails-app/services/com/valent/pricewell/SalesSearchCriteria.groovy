package com.valent.pricewell

class SalesSearchCriteria {
	private List<User> owners;
	private List<Geo> geos;
	private FilterCriteria filterCriteria = null;
	private SalesSearchType type;
	Date fromDate;
	Date toDate; 
	
	public enum SalesSearchType {
		searchByOwners,
		searchByGeos,
		searchAll
	}  
	
	public static SalesSearchCriteria createSearchByOwners(List<User> owners, FilterCriteria filterCriteria){
		SalesSearchCriteria sc = new SalesSearchCriteria();
		sc.type =  SalesSearchType.searchByOwners;
		sc.owners = owners;
		sc.filterCriteria = filterCriteria;
		return sc;
	}
	
	public static SalesSearchCriteria createSearchByGeos(List<Geo> geos, FilterCriteria filterCriteria){
		SalesSearchCriteria sc = new SalesSearchCriteria();
		sc.type =  SalesSearchType.searchByGeos;
		sc.geos = geos;
		sc.filterCriteria = filterCriteria;
		return sc;
	}
	
	public static SalesSearchCriteria createSearchAll(FilterCriteria filterCriteria){
		SalesSearchCriteria sc = new SalesSearchCriteria();
		sc.type =  SalesSearchType.searchAll;
		sc.filterCriteria = filterCriteria;
		return sc;
	}
	
	public List<User> getOwnersList(){
		return owners;
	}
	
	public void setOwnersList(List<User> owners){
		this.owners = owners;
	}
	
	public List<Geo> getGeosList(){
		return this.geos;
	}
	
	public void setGeosList(List<Geo> geos){
		this.geos = geos;
	}
	
	public SalesSearchType getSearchType(){
		return type;
	}
	
}
