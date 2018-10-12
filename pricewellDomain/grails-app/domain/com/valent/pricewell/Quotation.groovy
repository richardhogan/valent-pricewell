package com.valent.pricewell

class Quotation {


	User createdBy
	Account account
	String customerType
	Date	createdDate
	Date 	modifiedDate
	Date	statusChangeDate
	Staging	status
	Staging contractStatus
	Geo geo
	BigDecimal totalQuotedPrice = 0
	//Discount percent < 0 indicates not defined, 0 or greater than means it is defined.
	Boolean requestLevel1 = false//this is for sales person
	Boolean requestLevel2 = false//this is for sales manager
	Boolean requestLevel3 = false//this is for general manager
	Boolean flatDiscount = false;
	BigDecimal forecastValue = 0;
	BigDecimal discountPercent = 0
	BigDecimal discountAmount = 0;
	BigDecimal taxPercent = 0;
	BigDecimal taxAmount = 0;
	BigDecimal finalPrice = 0;
	Integer validityInDays = 60;
	String templateText = "";
	String billingText = ""
	//added for getting discount range
	BigDecimal discountFrom = 0;
	BigDecimal discountTo = 0;
	ReviewRequest currentReviewRequest
	BigDecimal confidencePercentage = 0;

	//for local
	BigDecimal localDiscount = 0;
	String localDiscountDescription
	
	//for expenses
	BigDecimal expenseAmount = 0;
	String description
	Boolean isLight = false
	
	//for sow
	Setting sowIntroductionSetting
	Date sowStartDate
	Date sowEndDate
	DocumentTemplate sowDocumentTemplate
	
	//for serviceTicket
	String convertToTicket = ""
	
	//for correction in activityRoleTime of serviceQuotation
	String isCorrected = ""
	//DiscountAmount
	//tax Percent
	//taxAmount
	/*
	 enum Status
	 {
	 INITIAL(0, "In Development"),
	 GENERATED(10, "Generated"),
	 SENT(20, "Sent"), 
	 CUSTOMER_RECEIVED(5,"Customer Received"),
	 REJECTED(30,"Rejected"),
	 EDITED(40,"Closed And Created New One"),
	 ACCEPTED(50, "Accepted")
	 private statusString;
	 int weight;
	 Status(int weight, String statusString){
	 this.weight = weight;
	 this.statusString = statusString;
	 }
	 public String toString(){
	 this.statusString;
	 } 
	 public boolean isContract()
	 {
	 return this.weight >= ACCEPTED.weight;	
	 }
	 }
	 */

	static constraints = {
		customerType(nullable: true)
		createdDate(nullable: false)
		geo(nullable: true)
		totalQuotedPrice()
		modifiedDate(nullable: true)
		status()
		serviceQuotations(nullable: true)
		discountFrom(nullable: true)
		discountTo(nullable: true)
		reviewRequests(nullable: true)
		currentReviewRequest(nullable: true)
		opportunity(nullable: true)
		generalStagingLogs(nullable: true)
		expenseAmount(nullable: true)
		description(nullable: true)
		sowTags(nullable: true)
		milestones(nullable: true)
		sowIntroductionSetting(nullable: true)
		convertToTicket(nullable: true)
		
		projectParameters(nullable: true)
		
		isCorrected(nullable: true)
		isLight(nullable: true)
		
		sowStartDate(nullable: true)
		sowEndDate(nullable: true)
		sowDocumentTemplate(nullable: true)
		
		localDiscount(nullable: true)
		localDiscountDescription(nullable: true, maxSize: 2048000)
		
	}

	static mapping = {
		localDiscountDescription type: "text"
		serviceQuotations sort: 'sequenceOrder'
	}
	
	static hasMany = [projectParameters: ProjectParameter, 
						serviceQuotations: ServiceQuotation, 
						reviewRequests: ReviewRequest, 
						generalStagingLogs: GeneralStagingLog, 
						sowTags: SowTag, 
						milestones: QuotationMilestone, 
						sowDiscounts: SowDiscount]

	static mappedBy = [sowDiscounts: "quotations"]
	
	static belongsTo = [opportunity: Opportunity]

	public boolean checkIfContractAccepted(){
		return  (contractStatus.sequenceOrder == 5)
	}

	public boolean checkIfQuoteAccepted(){
		return  (status.sequenceOrder == 5)
	}

	def static quoteStagingList = {
		def stagesList = Staging.findAll("from Staging st where st.entity = :entity order by sequenceOrder",
				[entity: Staging.StagingObjectType.QUOTATION]);

		List newList = new ArrayList();
		for(Staging st: stagesList){
			if(!st.types.contains(Staging.StagingType.END_REMOVE)){
				newList.add(st);
			}
		}

		return newList;

	};

	public List<ServiceQuotation> getActiveServiceQuotationList()
	{
		List<ServiceQuotation> serviceQuotationList = new ArrayList<ServiceQuotation>()
		
		this?.serviceQuotations.each {
			
			if(it.stagingStatus.name != "delete")
			{
				serviceQuotationList.add(it)
			}
		}
		
		return serviceQuotationList
	}
}