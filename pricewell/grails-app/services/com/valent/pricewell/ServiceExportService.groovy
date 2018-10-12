package com.valent.pricewell

import org.apache.shiro.SecurityUtils
class ServiceExportService {

    static transactional = true

	def fileUploadService
    def serviceMethod() {

    }
	
	public String exportService(ServiceProfile sProfile)
	{
		CommonFunctionsUtil generateExportXML = new CommonFunctionsUtil()
		def user = User.get(new Long(SecurityUtils.subject.principal))
		FilterCriteria filterCriteria = new FilterCriteria()
	 
		Service tmpService = sProfile.service
	 
	   	def xmlClosure =
		{
			services
			{
				service(id: tmpService?.id)
				{
					serviceName(tmpService?.serviceName)
					skuName(tmpService?.skuName)
					description(tmpService?.serviceDescription?.value)//tmpService?.description)
					tags(tmpService?.tags)
					
					portfolio(tmpService?.portfolio?.id)
					{
						portfolioName(tmpService?.portfolio?.portfolioName)
						description(tmpService?.portfolio?.description)
					}
					
					serviceProfile(id: sProfile?.id)
					{
						unitOfSale(sProfile.unitOfSale)
						baseUnits(sProfile.baseUnits)
						totalEstimateInHoursPerBaseUnits(sProfile.totalEstimateInHoursPerBaseUnits)
						totalEstimateInHoursFlat(sProfile.totalEstimateInHoursFlat)
						premiumPercent(sProfile.premiumPercent)
						definition(sProfile.definition)
						
						defs
						{
							for(ServiceProfileSOWDef sowDef : sProfile?.defs.sort{a, b -> a.id <=> b.id})
							{
								sowDefinition(id: sowDef.id)
								{
									part(sowDef?.part)
									name(sowDef?.definitionSetting?.name)
									value(sowDef?.definitionSetting?.value)
									
									if(sowDef?.geo?.id != null && sowDef?.geo?.id != "")
									{
										
										geoName(sowDef?.geo?.name)
										geoCurrency(sowDef?.geo?.currency)
										
									}
								}
							}
						}
						
						metaphors
						{
							for(ServiceProfileMetaphors metaphor : sProfile?.metaphors.sort{a, b -> a.id <=> b.id})
							{
								serviceProfileMetaphors(id: metaphor.id)
								{
									sequenceOrder(metaphor?.sequenceOrder)
									name(metaphor?.definitionString?.name)
									value(metaphor?.definitionString?.value)
									type(metaphor?.type)
								}
							}
						}
						
						extraUnits
						{
							for(ExtraUnit eu: sProfile?.extraUnits.sort{a, b-> a.id <=> b.id})	
							{
								extraUnit(id: eu.id)
								{
									unitOfSale(eu.unitOfSale)
									extraUnit(eu.extraUnit)
									shortName(eu.shortName)
								}
							}
						}
						
						customerDeliverables
						{							
							for(ServiceDeliverable deliverable : sProfile?.customerDeliverables.sort{a,b -> a.id <=> b.id})
							{
								serviceDeliverable(id: deliverable?.id)
								{
									name(deliverable?.name)
									type(deliverable?.type)
									description(deliverable?.description)
									phase(deliverable?.phase)
									newDescription
									{
										name(deliverable?.newDescription?.name)
										value(deliverable?.newDescription?.value)
									}
									
									serviceActivities
									{										
										for(ServiceActivity activity : deliverable?.serviceActivities.sort{a,b -> a.id <=> b.id})
										{
											serviceActivity(id: activity?.id)
											{
												name(activity?.name)
												description(activity?.description)
												estimatedTimeInHoursPerBaseUnits(activity?.estimatedTimeInHoursPerBaseUnits)
												estimatedTimeInHoursFlat(activity?.estimatedTimeInHoursFlat)
												category(activity?.category)
												results(activity?.results)
												
												rolesRequired
												{
													for(DeliveryRole dRole : activity?.rolesRequired.sort{a,b -> a.id <=> b.id})
													{
														deliveryRole(id: dRole?.id)
														{
															name(dRole?.name)
															description(dRole?.description)
														}														
													}
												}
												
												rolesEstimatedTime
												{
													for(ActivityRoleTime aRoleTime : activity?.rolesEstimatedTime.sort{a,b -> a.id <=> b.id})
													{
														activityRoleTime(id: aRoleTime?.id)
														{
															role(id: aRoleTime?.role?.id)
															{
																name(aRoleTime?.role?.name)
																description(aRoleTime?.role?.description)
															}
															
															estimatedTimeInHoursPerBaseUnits(aRoleTime?.estimatedTimeInHoursPerBaseUnits)
															estimatedTimeInHoursFlat(aRoleTime?.estimatedTimeInHoursFlat)
														}
													}
												}
												
												activityTasks
												{
													for(ServiceActivityTask saTask : activity?.activityTasks?.sort{it?.sequenceOrder})
													{
														serviceActivityTask(id: saTask?.id)
														{
															sequenceOrder(saTask?.sequenceOrder)
															task(saTask?.task)
														}
													}
												}
											}
										}
									}
								}
							}
						}
						
						productsRequired
						{
							for(ServiceProductItem sProductItem : sProfile?.productsRequired.sort{a,b -> a.id <=> b.id})
							{
								serviceProductItem(id: sProductItem?.id)
								{
									unitsSoldPerBaseUnits(sProductItem?.unitsSoldPerBaseUnits)
									unitsSoldRatePerAdditionalUnit(sProductItem?.unitsSoldRatePerAdditionalUnit)
									
									Product prod = sProductItem?.product
									product(id: prod?.id)
									{
										product_id(prod?.product_id)
										unitOfSale(prod?.unitOfSale)
										productName(prod?.productName)
										productType(prod?.productType)
									}
								}
							}
						}
					}
				}
			}
		}
		
		def storagePath = fileUploadService.getStoragePath("exportXml")
		def fileName = "service.xml"
	   	generateExportXML.writeFile(storagePath+"/"+fileName, xmlClosure)
	 
		return storagePath+"/"+fileName
	}
}
