package com.valent.pricewell

import java.util.List;
import grails.plugins.nimble.core.UserBase;

class Geo {
	String name;
	String description;
	String dateFormat
	String currency;
	String currencySymbol;
	BigDecimal taxPercent = 0;
	String terms;
	String billing_terms;
	String signature_block;
	String sowTemplate;
	String sowLabel
	UserBase salesManager
	UploadFile sowFile
	String country
	
	String isExternal
	
	//This is currency rate between global currency 
	BigDecimal convert_rate = 1;
	
    static constraints = {
		name(nullable: false)
		dateFormat(nullable: true)
		description(nullable: true)
		currency(nullable: true)
		currencySymbol(nullable: true)
		relationDeliveryGeos(nullable: true)
		terms(nullable: true, maxSize: 2048000)
		billing_terms(nullable: true, maxSize: 2048000)
		signature_block(nullable: true, maxSize: 2048000)
		sowTemplate(nullable: true, maxSize: 2048000)
		sowLabel(nullable: true)
		geoGroup(nullable: true)
		salesManager(nullable: true)
		salesPersons(nullable:true)
		sowFile(nullable: true)
		country(nullable: true)
		isExternal(nullable: true)
		sowDiscounts(nullable: true)
		sowDocumentTemplates(nullable: true)
    }
	
	static hasMany = [relationDeliveryGeos:RelationDeliveryGeo, 
						salesPersons: UserBase, sowDiscounts: SowDiscount, 
						sowDocumentTemplates: DocumentTemplate]
	
	static mapping = {
		terms type: "text"
		billing_terms type: "text"
		country type: "text"
	}
	
	static mappedBy = [salesPersons: "territory", sowDiscounts: "territories", sowDocumentTemplates: "territory"]
	
	static belongsTo = [geoGroup: GeoGroup]
	
	List listForGeo()
	{
		def relList =  RelationDeliveryGeo.createCriteria().list(sort: params?.sort)
									{
										eq("geo.id", this.id)
									}
		return relList
	}
	
	public boolean hasAllRolesDefined(Geo geo, List roles)
	{		
		for(DeliveryRole del: roles)
		{
			boolean match = false
			for(RelationDeliveryGeo rel: this.relationDeliveryGeos)
			{
				if(rel.deliveryRole.id == del.id)
				{
					match = true
					break
				}
			}
			
			if(!match)
			{
				return false;
			}
		}
		
		return true
	}
	
	List undefinedDeliveryRoles()
	{
		List unDefinedList = []
		
		for(DeliveryRole del: DeliveryRole.list())
		{
			boolean defined = false
			for(RelationDeliveryGeo rel: this.relationDeliveryGeos)
			{
				if(rel.deliveryRole == del)
				{
					defined = true
					break
				}
			}
			
			if(!defined)
			{
				unDefinedList.add(del)
			}
		}
		
		return unDefinedList
	}
	
	String toString()
	{
		return name
	}
}
