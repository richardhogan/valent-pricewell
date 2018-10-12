package com.valent.pricewell

import java.util.Map;

class FilterCriteria {
	private Map<String, String> filterProps;
	private Date fromDate=null;
	private Date toDate=null;
	
	public Map<String, String> getFilterProps(){
		return this.filterProps;		
	}
	
	public void setFilterProps(Map<String, String> propsMap){
		this.filterProps = propsMap;
	}
	
	public Date getFromDate(){
		return this.fromDate;
	}
	
	public void setFromDate(Date fromDate){
		this.fromDate = fromDate;
	}
	
	public Date getToDate(){
		return this.toDate;
	}
	
	public void setToDate(Date toDate){
		this.toDate = toDate;
	}
}
