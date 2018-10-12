package com.valent.pricewell

import grails.plugins.nimble.core.Role;


class Staging {
	StagingObjectType entity
	int sequenceOrder
	String name
	String displayName
	String description
	enum StagingType {NEW_STAGE, EDIT_STAGE, REMOVE_STAGE, BEGIN_NEW, BEGIN_EDIT, BEGIN_REMOVE, REVIEW_REQUEST, APPROVAL, END_REMOVE, END_NEW, END_EDIT, INACTIVE}
	enum StagingObjectType {SERVICE, LEAD, OPPORTUNITY, QUOTATION, PORTFOLIO, SETUP, SERVICEQUOTATION}
	enum AuthorizedScope { SERVICE, PORTFOLIO, LEGAL, ADMIN, NA }
	AuthorizedScope scopeOfAuthorizedRole = AuthorizedScope.NA
	
	Boolean isActive
	
	
    static constraints = {
		entity(nullable: false)
		sequenceOrder(nullable: false)
		types(nullable: true)
		description(nullable: true)
		authorizedRoles(nullable: true)
		isActive(nullable: true)
    }
	
	//Authorized roles are who can approve or reject request
	//Reviewer roles are who can review and add comment on it.
	static hasMany = [types: StagingType, authorizedRoles: Role, reviewerRoles: Role, subStages: SubStages]	
	
	String toString()
	{
		displayName
	}
	
	static List listServiceStages(String stageCategory)
	{
		def stagingList = Staging.findAll("from Staging st where st.entity = :entity and :stage in elements(st.types) order by sequenceOrder asc",
												[entity: Staging.StagingObjectType.SERVICE, stage: stageCategory])
	}
	
	static List listShortServiceStages(String stageCategory)
	{
		println "in shortcut workflow"
		def stagingList = Staging.findAll("from Staging st where st.entity = :entity and st.name NOT IN (:stageList) AND :stage in elements(st.types) order by sequenceOrder asc ",
										[entity: Staging.StagingObjectType.SERVICE, stageList: ["conceptreview", "conceptapproved", "designreview", "designapproved", "salesreview", "salesapproval", "requestforpublished"], stage: stageCategory])
		
	}

	static List listLeadStages(String stageCategory)
	{
		def stagingList = Staging.findAll("from Staging st where st.entity = :entity and :stage in elements(st.types) order by sequenceOrder asc",
												[entity: Staging.StagingObjectType.LEAD, stage: stageCategory])
	}
	
	static List listOpportunityStages(String stageCategory)
	{
		def stagingList = Staging.findAll("from Staging st where st.entity = :entity and :stage in elements(st.types) order by sequenceOrder asc",
												[entity: Staging.StagingObjectType.OPPORTUNITY, stage: stageCategory])
		List finalList = []
		for(Staging st : stagingList)
		{
			if(st?.isActive != 0 && st?.isActive != false && st?.isActive != 'false')
			{
				finalList.add(st)
			}
		}
		return finalList
	}
	
	static List listSetupStages(String stageCategory)
	{
		def stagingList = Staging.findAll("from Staging st where st.entity = :entity and :stage in elements(st.types) order by sequenceOrder asc",
			[entity: Staging.StagingObjectType.SETUP, stage: stageCategory])
	}
	
	static List listServiceQuotationStages(String stageCategory)
	{
		def stagingList = Staging.findAll("from Staging st where st.entity = :entity and :stage in elements(st.types) order by sequenceOrder asc",
			[entity: Staging.StagingObjectType.SERVICEQUOTATION, stage: stageCategory])
	}
	
	static List listAllServiceStages()
	{
		def stagingList = Staging.findAll("from Staging st where st.entity = :entity order by sequenceOrder asc")												
	}
	
	
	static Staging initialStage(StagingObjectType objectType, boolean edit)
	{
		String stgaeCategory = "BEGIN_NEW"
		if(edit)
		{
			stgaeCategory = "BEGIN_EDIT"
		}
		
		Collection stagingList = Staging.findAll("from Staging st where st.entity = :entity and :stage in elements(st.types) order by sequenceOrder asc",
			[entity: objectType, stage: stgaeCategory])
		
		return stagingList[0];
	}
	
	static Staging finalAcceptStage(StagingObjectType objectType, boolean edit)
	{
		String stgaeCategory = "END_EDIT"
		
		Collection stagingList = Staging.findAll("from Staging st where st.entity = :entity and :stage in elements(st.types) order by sequenceOrder asc",
			[entity: objectType, stage: stgaeCategory])
		
		return stagingList[0];
	}
	
	
	static Staging getNextServiceStage(String stageCategory, Staging currentStage)
	{
		
		def stagingList = listServiceStages(stageCategory)
		for(int i=0; i<stagingList.size(); i++)
		{
			if(currentStage.id == stagingList[i].id)
				if(stagingList.size() > (i + 1))
				{
					return stagingList.get(i + 1)
				}
				
		}
		
		return null	
		
		/*
		def stagingList = listServiceStages(stageCategory)
		def currentIndex = stagingList.indexOf(currentStage)
		if(stagingList.size() > (currentIndex + 1))
		{
			return stagingList.get(currentIndex + 1)
		}*/
	}
	
	static Staging getPreviousStage(String stageCategory, Staging currentStage)
	{
		def stagingList = listServiceStages(stageCategory)
		for(int i=0; i<stagingList.size(); i++)
		{
			if(currentStage.id == stagingList[i].id)
				if(i > 0)
				{
					return stagingList.get(i - 1)
				}
				else
				{
					return null;
				}
				
		}
		
		return null
		
	}
	
	static boolean isEndStage(String stageCategory, Staging currentStage)
	{
		def stagingList = listServiceStages(stageCategory)
		return (stagingList.size() == (stagingList.indexOf(currentStage) + 1))
	}
	
	static String getStageChangeActionString(Staging stage1, Staging stage2)
	{
		if(stage1.sequenceOrder == stage2.sequenceOrder)
		{
			return null;
		}
		else if(stage2.sequenceOrder > stage1.sequenceOrder)
		{
			return "Upgrade"
		}
		else if(stage2.sequenceOrder < stage1.sequenceOrder)
		{
			return "Downgrade"
		}
	}
	
	public boolean equal(Object o)
	{
		return o.id == this.id
	}
}
