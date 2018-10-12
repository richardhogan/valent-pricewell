package com.valent.pricewell

class ServiceStageFlow {
	
	
	public static def stageSteps = [concept: retriveSubStages("concept"),
										conceptreview: retriveSubStages("conceptreview"),
										conceptapproved: retriveSubStages("conceptapproved"),
										design: retriveSubStages("design"),
										designreview: retriveSubStages("designreview"),
										designapproved: retriveSubStages("designapproved"),
										salesreview: retriveSubStages("salesreview"),
										salesapproval: retriveSubStages("salesapproval"),
										requestforpublished: retriveSubStages("requestforpublished")
									];
	
	public static List<String> retriveSubStages(String stageName)
	{
		List<String> concept = new ArrayList<String>();
		//println stageName
		
		List desiredStage = Staging.executeQuery("select distinct st from Staging st where st.entity = ? and st.name = ?", [Staging.StagingObjectType.SERVICE, stageName]);
		
		Staging stag = desiredStage.getAt(0)
		
		if(stag != null)
		{
			def subStages = SubStages.findAll("from SubStages as st where st.staging = :stage order by sequenceNumber asc ",
				[stage: stag])
			
			for(SubStages st in subStages)
			{
				concept.add([st.name,st.displayName])
			}
		}
		
		return concept
	}
	
	public static List<String> retriveSubStages(String stageName,List<String> name)
	{
		List<String> concept = new ArrayList<String>();

		def desiredStage = Staging.executeQuery("SELECT DISTINCT st FROM Staging st WHERE st.entity = ? AND st.name = ?", [Staging.StagingObjectType.SERVICE, stageName]);

		Staging stag = desiredStage.getAt(0)

		if(stag != null)
		{

			for(String n in name)
			{

				def subStages = SubStages.findAll("FROM SubStages AS st WHERE st.staging = :stage AND st.name = :name ORDER BY sequenceNumber ASC ",
					[stage: stag, name: n])

				for(SubStages st in subStages)
				{
					concept.add([st.name,st.displayName])
				}
			}
		}


		return concept
	}
	
	public static void init()
	{
		
		
	}

	/*public static def stageSteps = [concept: [["edit", "Add requirement data"],["editDeliverables","Add Service Deliverables"],["editDefinition", "Add SOW Language"], ["showInfo","Preview"],["request","Request concept review"]],
									conceptreview: [["showInfo", "Review Requirements"],["approveRequest","Approve /Reject Concept"]],
									conceptapproved: [["assignDesigner", "Assign Designer"]],
									design: [["showInfo","Review requirements"],["addActivities","Add activities and roles"],["addProducts","Define products"],["showDetailedInfo","Preview"],["request","Request Design Review"]],
									designreview: [["showDetailedInfo", "Review Design"], ["editDefinition", "Edit SOW Language"], ["approveRequest","Approve /Reject Design"]],
									designapproved: [["request","Request Sales Review"]],
									salesreview: [["showDetailedInfo", "Review Service Info"],["approveRequest","Approve /Reject Sale"]],
									salesapproval: [["request","Request Publish"]],
									requestforpublished: [["showDetailedInfo", "Review Service Info"],["approveRequest","Approve publishing"]],
								];*/
							
	public static def importServiceStageSteps = [
								init: [['assignProductManager', 'Assign Product Manager']],
								concept: [["edit", "Review requirement data"],["editDeliverables","Review Service Deliverables"],["editDefinition", "Review SOW Language"]],
								design: [["assignDesigner", "Assign Designer"],["addActivities","Review activities and roles"],["addProducts","Review products"],["addPrerequisites","Add Pre-requisites"],["addOutOfScope","Add Out of Scope"],["showDetailedInfo","Preview"]],
								publish: [["editDefinition", "Edit SOW Language"],["showDetailedInfo", "Review Service Info"]]
							];
							
							
	public static def leadStageSteps = [uncontacted: [["show", "Uncontacted Lead"]],
										contactinprogress: [["show", "Contact Is In Progress"]], 
										converttoopportunity: [["addaccount", "Create/Select Account"], ["createopportunity", "Create Opportunity"]],
										converted: [["show", "Converted"]],
										dead: [["show", "Dead Lead"]]
									];
								
	public static def opportunityStageSteps = [prospecting: [["show", "Prospecting"]],
											   qualification: [["show", "Qualification"]],
											   needAnalysis: [["show", "Need Analysis"]],
											   valueProposition: [["show", "Value Proposition"]],
											   decisionMakers: [["show", "Decision Makers"]],
											   preceptionAnalysis: [["show", "Preception Analysis"]],
											   proposalPriceQuote: [["show", "Proposal/Price Quote"]],
											   negotiationReview: [["show", "Negotiation/Review"]],
											   closedWon: [["show", "Closed Won"]],
											   closedLost: [["show", "Closed Lost"]],
									       ];
	
	public static def sowGenerateStageSteps = [generatesow: [["introduction", "Add Introduction"], ["projectParameters", "Add Project Parameters"], ["milestone", "Add Milestones For Payment"], ["showReview", "Review Quotation"], ["reviewSowPhaseContent", "Review SOW Phase Contents"]]]//, ["serviceview", "Quotation Offering Services View"]]];
								   
	public static def stageFlowPermission = [init: "create", conceptapproved: "update", concept: "update", conceptreview: "create", design: "update,create", designreview: "update, create", designapproved: "update", salesreview: "create", salesapproval: "create", requestforpublished: "create"];
	
	public static def importServiceStageFlowPermission = [init: "create, update", concept: "update, create", design: "update,create", publish: "update, create"];
	
	public static String findSOWGenerateStepName(String stageName, int stepNumber){
		if(sowGenerateStageSteps[stageName])
		{
			return 	sowGenerateStageSteps[stageName][stepNumber-1][0]
		}
		
		return null;
	}
	
	public static String findStepName(String stageName, int stepNumber){
		if(stageSteps[stageName])
		{
			return 	stageSteps[stageName][stepNumber-1][0]
		}
		
		return null;
	}
	
	public static String findImportServiceStepName(String stageName, int stepNumber){
		if(importServiceStageSteps[stageName])
		{
			return 	importServiceStageSteps[stageName][stepNumber-1][0]
		}
		
		return null;
	}
	
	public static String findLeadStepName(String stageName, int stepNumber){
		if(leadStageSteps[stageName] && leadStageSteps[stageName].size() >=  stepNumber)
		{
			return 	leadStageSteps[stageName][stepNumber-1][0]
		}
		
		return null;
	}
	
	public static String findOpportunityStepName(String stageName, int stepNumber){
		if(opportunityStageSteps[stageName] && opportunityStageSteps[stageName].size() >=  stepNumber)
		{
			return 	opportunityStageSteps[stageName][stepNumber-1][0]
		}
		
		return null;
	}
	
	public static def stageParamNames = [
						concept: [edit: ["serviceProfileInstance"], showInfo: ["serviceProfileInstance"], 
									editDeliverables: ["serviceProfileInstance", "deliverablesList"],
									requestConcept: ["stagingInstanceList", "currentStage", "nextStage", 
														"staginLogInstance", "serviceProfileId", "nextStageDisabled",
														"nextReviewStage", "assigneesList"]
								]
							
			];
		public static def setupSteps = [welcome: [["welcome", "WELCOME TO VALENT SOFTWARE"]],
										companyInfo: [["addCompanyInfo", "DEFINE COMPANY INFORMATION"]],
										geos: [["createGeos", "DEFINE GEO-TERRITORY"]],
										addUsers: [["createUser", "SYSTEM ADMINISTRATOR"],["createUser","PORTFOLIO MANAGER"],["createUser","PRODUCT MANAGER"],["createUser","SERVICE DESIGNER"],["createUser","SALES PRESIDENT"],["createUser","GENERAL MANAGER"],["createUser","SALES MANAGER"],["createUser","SALES PERSON"],["createUser","DELIVERY ROLE MANAGER"]],
										deliveryRoles: [["createDeliveryRoles","DEFINE DELIVERY ROLES"]],
										portfolios: [["createPortfolios","DEFINE PORTFOLIOS"]],
			
										];
	
		public static String findSetupStepName(String stageName, int stepNumber){
			if(setupSteps[stageName] && setupSteps[stageName].size() >=  stepNumber)
			{
				return 	setupSteps[stageName][stepNumber-1][0]
			}
			
			return null;
		}
		
		public static String findUserRole(String stageName, int stepNumber){
			if(setupSteps[stageName] && setupSteps[stageName].size() >=  stepNumber)
			{
				return 	setupSteps[stageName][stepNumber-1][1]
			}
			
			return null;
		}
}
