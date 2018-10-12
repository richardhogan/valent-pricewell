package com.valent.pricewell

class SolutionBundle {
	
	String name;
	String description;
	Date createdDate;
	
	List<Service> solutionBundleServices
	
	static hasMany = [solutionBundleServices: Service]
	
	static constraints = {
		name(nullable: false)
		description(nullable: false)
		createdDate(nullable: false)
	}
	
	int getSolutionBundleServicesCount() {
		return solutionBundleServices.size();
	}
}
