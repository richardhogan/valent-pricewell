package com.valent.pricewell

import java.util.Date;

class Portfolio {

	static searchable = true
	
   String portfolioName;
	String description;
	Date dateModified;
	String stagingStatus; //InProgress, RequestForReview, NeedInfo, Approved, Published

    static constraints = {
		portfolioName(nullable: false)
		description(nullable: true, maxSize: 20480)
		dateModified()
		stagingStatus()
    }

	static belongsTo = [portfolioManager: User]

	static hasMany = [ services: Service, designers: User, otherPortfolioManagers: User]
	
	static mappedBy = [services: "portfolio"]
	
	static mapping = {  services sort:'serviceName'
						description type: 'text'}

	String toString() {
		portfolioName
    }
	
	List listPublishedServices()
	{
		Service.findAll("from Service s where s.portfolio.id = :pid AND s.serviceProfile.stagingStatus.name = :status order by serviceName", [pid: this.id, status: "published"])
	}
}

