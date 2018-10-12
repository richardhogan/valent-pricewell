package com.valent.pricewell
import org.apache.shiro.SecurityUtils
import java.util.Date;
import java.util.Map;

import org.grails.taggable.*


class Service{
	
	def quotationService
	
	String serviceName;
	String skuName;
	String description;
	ServiceProfile serviceProfile;
	Date dateCreated;
	User createdBy;
	Date dateModified;
	User modifiedBy;
	User productManager
	String tags
	Description serviceDescription
	Boolean active = true
	
    static constraints = {
		serviceName(nullable: false, blank: false, unique: true)
		skuName(nullable: true)
		description(nullable: true)
		portfolio(nullable: false, blank: false)
		dateCreated()
		dateModified()
		createdBy(nullable: false)
		modifiedBy(nullable: true)
		serviceProfile(nullable: true)
		profiles(nullable: true)
		productManager(nullable: true)
		otherProductManagers(nullable: true)
		tags(nullable: true)
		serviceDescription(nullable: true)
    }
	
	static hasMany = [profiles: ServiceProfile, otherProductManagers: User, otherPortfolios: Portfolio]
	
	static belongsTo = [portfolio: Portfolio]
	
	static mappedBy = [profiles: 'service', portfolio: "services"]
	
	/*static mapping = {
		description column: "description", sqlType: "varchar(8000)"
	}*/
	
	String toString() {
		"${serviceName}"
	}
	
	Map calculatePrices(Geo geo)
	{
		return quotationService.calculteServicePrice(this, geo)
	}
	
	static List listPublished(User user)
	{
		if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR"))
		{
			Service.findAll("FROM Service s WHERE s.serviceProfile.stagingStatus.name = :status order by serviceName", [status: "published"])
		}
		else if(SecurityUtils.subject.hasRole("PORTFOLIO MANAGER"))
		{
			Service.findAll("FROM Service s WHERE s.portfolio.portfolioManager = :user AND s.serviceProfile.stagingStatus.name = :status order by serviceName", [status: "published", user: user])
		}
		else if(SecurityUtils.subject.hasRole("PRODUCT MANAGER")){
			Service.findAll("FROM Service s WHERE s.productManager = :user AND s.serviceProfile.stagingStatus.name = :status order by serviceName", [status: "published", user: user])
		}
		else if(SecurityUtils.subject.hasRole("SERVICE DESIGNER")){
			Service.findAll("FROM Service s WHERE s.serviceProfile.serviceDesignerLead = :user AND s.serviceProfile.stagingStatus.name = :status order by serviceName", [status: "published", user: user])
		}
		else if(SecurityUtils.subject.hasRole("SALES PRESIDENT") || SecurityUtils.subject.hasRole("GENERAL MANAGER") || SecurityUtils.subject.hasRole("SALES MANAGER") || SecurityUtils.subject.hasRole("SALES PERSON"))
		{
			Service.findAll("FROM Service s WHERE s.serviceProfile.stagingStatus.name = :status order by serviceName", [status: "published"])
		}
		else
		{
			Service.findAll("FROM Service s WHERE s.portfolio.portfolioManager = :user AND s.serviceProfile.stagingStatus.name = :status order by serviceName", [status: "published", user: user])
		}
			
	}
	
	String printDefinition(int units)
	{
		String d = ""
		d = this?.serviceProfile?.definition
		if(d != null)
		{
			if(d.contains("[@@units@@]") )
			{
				d = d.replace("[@@units@@]", units.toString());
			}
		}
		return d;
	}
	
	Service createNewService(String serviceName,ServiceProfile serviceProfile) {
		Service newService = new Service();
		newService.portfolio = this.portfolio
		
		newService.serviceName = serviceName
		newService.dateCreated = new Date()
		newService.dateModified = new Date()
		
		newService.skuName = this.skuName
		newService.description = this.description
		newService.tags = this.tags
		newService.serviceProfile = serviceProfile
		newService.serviceDescription = this.serviceDescription
		
		def user = User.get(new Long(SecurityUtils.subject.principal))
		newService.createdBy = user
		newService.modifiedBy = user
		newService.active = true
		
		if (!newService.save(insert:true, flush:true, validate: false)) {
			newService.errors.each {
				println it
			}
		}
		
		return newService;
	}
}
