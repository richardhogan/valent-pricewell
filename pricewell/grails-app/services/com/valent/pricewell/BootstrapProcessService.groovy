package com.valent.pricewell

class BootstrapProcessService {

    static transactional = true
	def serviceCatalogService, fileUploadService, salesCatalogService

    def serviceMethod() {

    }
	
	public void correctOpportunityAssignedUser()
	{
		User admin = (User) User.findByUsername("admin")
		User superadmin = (User) User.findByUsername("superadmin")
		
		List<Opportunity> opportunityList = Opportunity.findAll("FROM Opportunity op WHERE op.externalSource = 'connectwiseImport' AND op.stagingStatus.name != 'closedWon' AND op.stagingStatus.name != 'closedLost' " + 
																" AND (op.assignTo.id = :adminId OR op.assignTo.id = :superAdminId)", [adminId: admin?.id, superAdminId: superadmin?.id])
		
		for(Opportunity opportunity: opportunityList)
		{
			if(opportunity?.geo != null)
			{
				opportunity.assignTo = salesCatalogService.getSalesUserOfGeo(opportunity?.geo)
				opportunity.save()
				
				log.info "[Log Time: ${new Date()}] - Found sales user of territory ${opportunity?.geo?.getName()} is ${opportunity.assignTo} assigned to opportunity : " + opportunity?.getName()
			}
		}
	}
	
	/*
	 * This method is for all that SOW which have already discount amount defined in past, will check that it has global discount or not.
	 * And if there are some global discount that do nothing 
	 * and if no any global discounts than copy the discount amount to local discount 
	 * and give description for local discount something like "Sales Vender's Discount".
	 */
	public void convertSowDiscountToLocalDiscount()
	{
		Quotation.list().each {quotationInstance ->
			if(quotationInstance?.sowDiscounts?.size() == 0 && quotationInstance?.discountAmount > 0)
			{
				quotationInstance.localDiscount = quotationInstance?.discountAmount
				quotationInstance.localDiscountDescription = "Discount given by Sales Vender's"
				quotationInstance.save()
			}
		}
	}
	
	public void convertSowFileToSowDocumentTemplate()
	{
		List territoryList = Geo.findAll("FROM Geo territory WHERE territory.sowFile != null")
		
		for(Geo territory : territoryList)
		{
			if(territory?.sowDocumentTemplates?.size() == 0 && territory.sowFile != null)
			{
				def documentName = "Default SOW Template"
				def destinationDirectory = "SOWFiles"
				def storagePath = fileUploadService.getStoragePath(destinationDirectory)
				
				boolean isFile = false
				if(territory.sowFile?.filePath != null && territory.sowFile ?.filePath != "")
				{
					def filePath = territory.sowFile?.filePath + "\\" + territory.sowFile?.name
					filePath = filePath.replaceAll('\\\\', '/')
					isFile = fileUploadService.isFileExist(filePath)
				}
				
				if(isFile)
				{
					def inputFileName = territory?.name.toString().toLowerCase().replaceAll(" ", "").replaceAll("[-+^,.!@#\$]*", "") + "SOW.docx"
					def outputFileName = (territory?.name + documentName).toString().toLowerCase().replaceAll(" ", "").replaceAll("[-+^,.!@#\$]*", "") + "SOW.docx"
					
					if(isFileContentCopied(storagePath+"/"+inputFileName, storagePath+"/"+outputFileName))
					{
						UploadFile sowFile = fileUploadService.uploadNewFile(outputFileName, storagePath)
						if(sowFile != null)
						{
							DocumentTemplate sowDocumentTemplate = new DocumentTemplate(documentName: documentName, documentFile: sowFile, isDefault: new Boolean(true)).save()
						
							territory.addToSowDocumentTemplates(sowDocumentTemplate)
							territory.save()
							
							println "file converted for territory ${territory.name}"
						}
					}
				}
				
			}
		}
	}
	
	public boolean isFileContentCopied(String inputFilePath, String outputFilePath)
	{
		InputStream inStream = null;
		OutputStream outStream = null;
		boolean isCopied = false
		try
		{
			
		   File inputFile =new File(inputFilePath);
		   File outputFile =new File(outputFilePath);

		   inStream = new FileInputStream(inputFile);
		   outStream = new FileOutputStream(outputFile); 

		   byte[] buffer = new byte[1024];

		   int length;
		   while ((length = inStream.read(buffer)) > 0){
			   outStream.write(buffer, 0, length);
		   }

		   if (inStream != null)inStream.close();
		   if (outStream != null)outStream.close();

		   System.out.println("File Copied..");
		   isCopied = true
	   }catch(IOException e){
		   e.printStackTrace();
	   }
	   
	   return isCopied
	}
	
	public void correctSequenceOrderOfDefaultPhases()
	{
		List defaultPhases = ObjectType.listObjectTypes(ObjectType.Type.DELIVERABLE_PHASE)
		boolean isSequenceOrderAssigned = true
		
		for(ObjectType delPhase : defaultPhases)
		{
			if(delPhase?.sequenceOrder == null || delPhase?.sequenceOrder == 0)
			{
				isSequenceOrderAssigned = false
				break
			}
		}
		
		int sequenceOrder = 1
		if(!isSequenceOrderAssigned)
		{
			defaultPhases.sort{it.id}.each {delPhase ->
				delPhase.sequenceOrder = sequenceOrder
				delPhase.save()
				sequenceOrder++
				
				println delPhase.name + " : " + delPhase.sequenceOrder 
			}
		}
	}
	
	public void removeSMPOpportunitiesWithZeroEstimateForecast()
	{
		List opportunityList = Opportunity.findAll("FROM Opportunity op WHERE op.externalId != null")
		for(Opportunity opportunityInstance : opportunityList)
		{
			/*Account account = Account.get(opportunityInstance?.account?.id)
			Contact primaryContact = Contact.get(opportunityInstance?.primaryContact?.id)*/
			
			if(opportunityInstance?.amount == 0 || opportunityInstance?.amount == null)
			{
				println "Opportunity " + opportunityInstance?.name + " is going to be deleted now." 
				opportunityInstance.primaryContact = null
				opportunityInstance.save()
				opportunityInstance.delete()//flush: true)
				
				/*if(!isContactHasAnyOpportunity(primaryContact))
				{
					primaryContact.delete()
				}*/
			}
		}
		
		/*List accountList = Account.findAll("FROM Account ac WHERE ac.externalId != null")
		for(Account account : accountList)
		{
			if(account?.opportunities?.size() == 0)
			{
				
				for(Contact contact : account.contacts)
				{
					println "Contact " + contact?.firstname + " " + contact?.lastname + " is going to be deleted now"
					contact.delete()
				}
				account.contacts = new ArrayList()
				account.save()
				println "Account " + account?.accountName + " is going to be deleted now"
				account.delete()
			}
		}*/
		
	}
	
	public boolean isContactHasAnyOpportunity(Contact contact)
	{
		List opportunityList = Opportunity.findAll("FROM Opportunity op WHERE op.primaryContact.id = :ctid", [ctid: contact?.id])
		if(opportunityList.size() > 0)
		{
			return true
		}
		return false
	}
	
	public void changeExternalSourceOfOpportunity()
	{
		for(Opportunity opportunity : Opportunity.list())
		{
			if(opportunity?.externalSource == "" || opportunity?.externalSource == null || opportunity?.externalSource == "NULL")
			{
				if(opportunity?.externalId != null && opportunity?.externalId != "NULL")
				{
					opportunity?.externalSource = "connectwiseImport"
					opportunity.save()
				}
			}
		}
	}
	
	public void convertAllDefaultEntityNameToUppercase()
	{
		for(ObjectType entity : ObjectType.list())
		{
			entity.name = entity.name.toUpperCase()
			entity.save()
		}
	}
	
	public void addDefaultDeliverableTypes()
	{
		List deliverableTypes = ObjectType.listObjectTypes(ObjectType.Type.SERVICE_DELIVERABLE)
		
		if(deliverableTypes.size() == 0)
		{
			createNewObjectType("Install", ObjectType.Type.SERVICE_DELIVERABLE)
			createNewObjectType("Training", ObjectType.Type.SERVICE_DELIVERABLE)
		}
	}
	
	public void addDefaultActivityTypes()
	{
		List activityTypes = ObjectType.listObjectTypes(ObjectType.Type.SERVICE_ACTIVITY)
		
		if(activityTypes.size() == 0)
		{
			createNewObjectType("Install", ObjectType.Type.SERVICE_ACTIVITY)
			createNewObjectType("Training", ObjectType.Type.SERVICE_ACTIVITY)
		}
	}
	
	public void addDefaultSOWMilestoneTypes()
	{
		List milestoneTypes = ObjectType.listObjectTypes(ObjectType.Type.SOW_MILESTONE)
		
		if(milestoneTypes.size() == 0)
		{
			createNewObjectType("INITIAL PAYMENT", ObjectType.Type.SOW_MILESTONE)
			createNewObjectType("SECOND MILESTONE", ObjectType.Type.SOW_MILESTONE)
			createNewObjectType("THIRD PAYMENT", ObjectType.Type.SOW_MILESTONE)
			createNewObjectType("NEXT PAYABLE AMOUNT", ObjectType.Type.SOW_MILESTONE)
			createNewObjectType("LAST PAYMENT AMOUNT", ObjectType.Type.SOW_MILESTONE)
			createNewObjectType("FINAL MILESTONE", ObjectType.Type.SOW_MILESTONE)
		}
	}
	
	public void addDefaultDeliverablePhase()
	{
		ObjectType defaultPhase = getDefaultDeliverablePhase()
		ServiceDeliverable.list().each {deliverable ->
			if(deliverable?.phase == null || deliverable?.phase == "")
			{
				deliverable.phase = defaultPhase.name
				deliverable.save()
			}
		}
	}
	
	public ObjectType getDefaultDeliverablePhase()
	{
		ObjectType defaultPhase = ObjectType.findByName("DEFAULT STARTUP PHASE")
		if(defaultPhase)
		{
			return defaultPhase
		}
		else
		{
			defaultPhase = new ObjectType(name: "DEFAULT STARTUP PHASE", type: ObjectType.Type.DELIVERABLE_PHASE, 
											sequenceOrder: 0, description: "This is default startup phase created for already existing published services to continue the process.").save()
			return defaultPhase
		}
	}
	
	public void createNewObjectType(String name, ObjectType.Type type)
	{
		ObjectType objectTypeInstance = new ObjectType()
		objectTypeInstance.name = name
		objectTypeInstance.type = type
		
		objectTypeInstance.save()
		
		println objectTypeInstance
	}
	
	public void convertingServiceDeliverableDescriptionToDescriptionClass()
	{
		for(ServiceDeliverable sDeliverable : ServiceDeliverable?.list())
		{
			if(sDeliverable?.newDescription == null || sDeliverable?.newDescription == "")
			{
				serviceCatalogService.createNewServiceDeliverableDescription(sDeliverable, sDeliverable?.description)
			}
		}
	}
	
	/*********************************************************************************************************************
	 * This method will check that sequence order of serviceQuotation is not null and if null than count the next sequence
	 * order for that service from quotation and correct it....
	 * *******************************************************************************************************************/
	public void checkAndCorrectServiceQuotationSequenceOrder()
	{
		for(Quotation quotation : Quotation?.list())
		{
			int sqCount = 1
			for(ServiceQuotation serviceQuotation : quotation?.serviceQuotations.sort{it?.id})
			{
				if(serviceQuotation?.sequenceOrder == null || serviceQuotation?.sequenceOrder == "NULL")
				{
					serviceQuotation.sequenceOrder = sqCount
					serviceQuotation.save()
					
					//println serviceQuotation?.id + " " + serviceQuotation?.sequenceOrder
				}
				sqCount++
			}
		}
	}
	
	/*********************************************************************************************************************
	 * The below method will check if service has new description definition or not and if not than add it....
	 * This is quick fix for those service that are already created and having very sort description previously
	 * and now changed to make it large.
	 * *******************************************************************************************************************/
	public void doServiceDescriptionQuickFix()
	{
		for(Service service : Service?.list())
		{
			if(service?.serviceDescription == null || service?.serviceDescription == "")
			{
				Description serviceDescription = new Description("name": "Service Description: ${service?.serviceName}", value: service?.description ).save()
				service.serviceDescription = serviceDescription
				service.save()
			}
		}
	}
		
	public void correctServiceQuotationSequenceOrderForMultipleEntries()
	{
		for(Quotation quotation : Quotation?.list())
		{
			if(isServiceQuotationContainDuplicateSequenceOrder(quotation))
			{
				int sqCount = 1
				for(ServiceQuotation serviceQuotation : quotation?.serviceQuotations.sort{it?.sequenceOrder})
				{
					serviceQuotation.sequenceOrder = sqCount
					serviceQuotation.save()
										
					sqCount++
				}
			}
		}
	}
	
	public boolean isServiceQuotationContainDuplicateSequenceOrder(Quotation quotation)
	{
		List sequenceList = new ArrayList()
		boolean haveMultiple = false
		for(ServiceQuotation serviceQuotation : quotation?.serviceQuotations.sort{it?.sequenceOrder})
		{
			if(!sequenceList.contains(serviceQuotation?.sequenceOrder))
			{
				sequenceList.add(serviceQuotation?.sequenceOrder)
			}
			else{
				haveMultiple = true
				break
			}
		}
		
		return haveMultiple
	}
}
