package com.valent.pricewell

import org.jsoup.Jsoup
import org.apache.shiro.SecurityUtils

import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.regex.Pattern

import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONObject
import org.docx4j.*
import org.docx4j.wml.ObjectFactory;
import org.docx4j.dml.wordprocessingDrawing.Inline
import org.docx4j.openpackaging.packages.WordprocessingMLPackage;
import org.docx4j.wml.P
import org.docx4j.wml.R
import org.docx4j.wml.Text
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext
import org.springframework.context.ApplicationContextAware
import org.springframework.context.MessageSource


class WordSubstitutionMapGenerator implements SubstituionMapGenerator, ApplicationContextAware
{
	private ApplicationContext applicationContext
	private Quotation quotation
	private Object g
	private WordprocessingMLPackage wordMLPackage;
	private RteToWordDocumentTagConverter rteToWordTagConverter
	private GroovyPageRendererService groovyPageRendererService
	
	//In constructor, you can pass SOW or Quotation related details
	public WordSubstitutionMapGenerator(Quotation quotation, WordprocessingMLPackage wordMLPackage)
	{
		ApplicationContext appContext = getApplicationContext(quotation)
		RteToWordDocumentTagConverterService rteToWordDocumentTagConverterService = appContext.getBean(RteToWordDocumentTagConverterService.class);
		GroovyPageRendererService groovyPageRendererService = appContext.getBean(GroovyPageRendererService.class);
		
		this.quotation = quotation
		this.applicationContext = appContext
		this.wordMLPackage = wordMLPackage
		this.groovyPageRendererService = groovyPageRendererService
		this.rteToWordTagConverter = new RteToWordDocumentTagConverter(rteToWordDocumentTagConverterService)
	}
	
	public ApplicationContext getApplicationContext(Quotation quotation)
	{
		def grailsApplication = quotation.domainClass?.grailsApplication
		if(!grailsApplication){
			println "Error can't get application context, so all SOW global properties would be empty"
			return
		}
		
		ApplicationContext appContext = grailsApplication.mainContext
		return appContext
	}

	@Override
	public void setApplicationContext(ApplicationContext context)	throws BeansException
	{
		// TODO Auto-generated method stub		
	}
	
	//This is replacement for string values with single line value
	@Override
	public Map<String, String> generateStringSubstutionMap() {
		HashMap<String, String> map = new HashMap<String, String>();
		//map.put("normalKey", "normal val");
		
		Properties sowProperties = getSOWProperties()
				
		//println sowProperties
		for(String key: sowProperties.keySet())
		{
			if(key != "customer_logo" && key != "sow_introduction")
			{
				String value = sowProperties.get(key)
				if(value != null && value != "null" && value != "")
				{
					map.put(key, cleanString(Jsoup.parse(value).text()))
				}
			}
			
		}
		return map;
	}
	
	//Generate values for all different tag variables with tables or multi-lines
	@Override
	public Map<String, List<Object>> generateSubstutionMap() 
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))
		//println user
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		Map quotationServiceMap = getServicesOfQuotation()
		map.put('quotationOfferingServices', quotationServiceMap['quotationOfferingServices'])
		map.put('quotationOfferingServicesGrouping', quotationServiceMap['quotationOfferingServicesGrouping'])
		map.put('quotedServicesPrice', quotationServiceMap['quotedServicesPrice'])
		//map.put("scope_of_work", generateSOWDefinitionLanguage())
		
		
		if(quotation?.milestones?.size() > 0)
		{
			List quotationMilestones = getQuotationMilestones()
			map.put('billingMilestone', quotationMilestones)
		}
		
		if(quotation?.projectParameters?.size() > 0)
		{
			List projectParameters = getProjectParameters()
			map.put('sow_project_parameters', projectParameters)
		}
		
		Properties sowProperties = getSOWProperties()
		if(sowProperties.get('customer_logo') != null && sowProperties.get('customer_logo') != 'null' && sowProperties.get('customer_logo') != '')
		{
			if(isFileExist(sowProperties.get('customer_logo')))
			{
				AddingAnInlineImage addInlineImage = new AddingAnInlineImage(wordMLPackage);
				String filePath = sowProperties.get('customer_logo')
				P imageParagraph = addInlineImage.getImageParagraph(filePath)
				//Inline inlineImageObject = addInlineImage.getImageInline(filePath)
				map.put("customer_logo", [imageParagraph]);
			}
			
		}
		
		if(sowProperties.get('sow_introduction') != null && sowProperties.get('sow_introduction') != 'null' && sowProperties.get('sow_introduction') != '')
		{
			List sowIntroductionList = rteToWordTagConverter.convertRteToWordDocumentFormat(sowProperties.get('sow_introduction'))
			List sowIntroductionObjectList = []//new ArrayList()
			
			for(List strList : sowIntroductionList)
			{
				def sowIntroductionPara = groovyPageRendererService.convertScopeOfWorkToXMLWordDocument(strList, "sow_introduction")
				if(sowIntroductionPara != null)
					sowIntroductionObjectList.add(XmlUtils.unmarshalString(sowIntroductionPara))
				//sowIntroductionObjectList.add(XmlUtils.unmarshalString(heading1))
			}
			map.put("sow_introduction", sowIntroductionObjectList);
		}
		
		Properties serviceProps = new Properties();
		File sowServicesPropsFile = applicationContext.getResource("/props/sow-services.properties").getFile();
		serviceProps.load(new FileReader(sowServicesPropsFile));
		
		Map serviceSowDefinitionLanguageMap = getServiceSowLanguageTableContent(quotation.getActiveServiceQuotationList(), serviceProps)
		
		serviceSowDefinitionLanguageMap.each{ key, sDefLanList ->
			map.put(key, sDefLanList)
		}
		
		return map;
	}
	
	public List getSOWDefinitionList(ServiceQuotation sq)
	{
		def sowDefs = []
		ServiceProfileSOWDef defaultDefinition = null
		
		for(ServiceProfileSOWDef sowDef : sq.profile?.defs)
		{
			if(sowDef?.geo?.id == quotation?.geo?.id)
			{
				sowDefs.add(sowDef)
			}
			else
			{
				defaultDefinition = ServiceProfileSOWDef.get(sowDef.id)
			}
		}
		
		if(sowDefs.size() > 0)
		{
			return sowDefs
		}
		else if(defaultDefinition?.definitionSetting?.value != null && defaultDefinition?.definitionSetting?.value != "")
		{
			return [defaultDefinition]
		}
		else return []
	}
	
	public List getServiceProfilePrerequisiteMetaphors(ServiceQuotation sq)
	{
		ServiceProfile serviceProfile = ServiceProfile.get(sq?.profile?.id)
		List metaphorsList = serviceProfile.listServiceProfileMetaphors(ServiceProfileMetaphors.MetaphorsType.PRE_REQUISITE)
		return metaphorsList
	}
	
	public List getServiceProfileOutOfScopeMetaphors(ServiceQuotation sq)
	{
		ServiceProfile serviceProfile = ServiceProfile.get(sq?.profile?.id)
		List metaphorsList = serviceProfile.listServiceProfileMetaphors(ServiceProfileMetaphors.MetaphorsType.OUT_OF_SCOPE)
		return metaphorsList
	}
	
	public List getQuotationMilestones()
	{
		def milestoneTblObject = []
		def totalAmount = new BigDecimal(0)
		
		for(QuotationMilestone qm in quotation?.milestones)
		{
			totalAmount = totalAmount + qm.amount
		}
		
		String cleanedText = groovyPageRendererService.sowMilestonesContentToWordDocumentConverter(['quotation': quotation, 'totalAmount': totalAmount])
		milestoneTblObject.add(XmlUtils.unmarshalString(cleanedText))
		
		return milestoneTblObject
			
		
	}
	
	public List getProjectParameters()
	{
		List projectParameterObjectList = []//new ArrayList()
		
		for(ProjectParameter ppm : quotation?.projectParameters)
		{
			List sowProjectParameterList = rteToWordTagConverter.convertRteToWordDocumentFormat(ppm?.value)
			for(List strList : sowProjectParameterList)
			{
				def sowProjectParameterPara = groovyPageRendererService.convertScopeOfWorkToXMLWordDocument(strList, "sow_project_parameters")
				if(sowProjectParameterPara != null)
					projectParameterObjectList.add(XmlUtils.unmarshalString(sowProjectParameterPara))
			}
		}
		return projectParameterObjectList
		
	}
	
	public Map getServicesOfQuotation()
	{
		String displayType = "simpleFormat"
		def serquo = quotation.getActiveServiceQuotationList()
		List portfolioList = [], serviceTblObject = [], quotedServicesPriceObject = []
		Map quotationServiceMap = [:], portfolioServiceMap = [:]
		
		Properties serviceProps = new Properties();
		File sowServicesPropsFile = applicationContext.getResource("/props/sow-services.properties").getFile();
		serviceProps.load(new FileReader(sowServicesPropsFile));
		
		List serviceQuotations = []
		for(ServiceQuotation sq in serquo)
		{
			//if(sq?.stagingStatus?.name != "delete")
			//{
				def portfolioId = sq.service.portfolio.id;
				if(!portfolioServiceMap.containsKey(portfolioId))
				{
					portfolioServiceMap.put(portfolioId, new ArrayList());
					portfolioList.add(sq.service.portfolio)
				}
	
				portfolioServiceMap.get(sq.service.portfolio.id).add(sq);
				
				serviceQuotations.add(sq)
			//}
			
		}
		
		quotationServiceMap['quotedServicesPrice'] = getQuotedServicePriceTable(portfolioList, quotation)//quotedServicesPriceObject
		//Map quotationOfferingServiceMap = getQuotationOfferingServicesData(portfolioList, displayType, portfolioServiceMap, serviceProps)//serviceTblObject
		Map quotationOfferingServiceMap = getQuotationOfferingServicesData(serviceQuotations, displayType, serviceProps)//serviceTblObject
		quotationServiceMap['quotationOfferingServicesGrouping'] = quotationOfferingServiceMap["serviceTblObjectGrouping"]
		quotationServiceMap['quotationOfferingServices'] = quotationOfferingServiceMap["serviceTblObjectNonGrouping"]
		//return cleanedText
		
		return quotationServiceMap
	}
	
	public List getQuotedServicePriceTable(List portfolioList, Quotation quotation)
	{
		List quotedServicesPriceObject = new ArrayList()
		
		String cleanedText = groovyPageRendererService.sowQuotationServicePriceToWordDocumentConverter(['quotation': quotation, 'portfolioList': portfolioList])
		quotedServicesPriceObject.add(XmlUtils.unmarshalString(cleanedText))
		
		return quotedServicesPriceObject
	}
	
	public Map getQuotationOfferingServicesData(List portfolioList, String displayType, Map portfolioServiceMap, Properties serviceProps)
	{
		List serviceTblObjectGrouping = new ArrayList(), serviceTblObjectNonGrouping = new ArrayList() 
		
		int serviceSequenceOrder = 1
		for(Portfolio portfolio : portfolioList.sort{it?.portfolioName})
		{
			if(displayType == "simpleFormat")
			{
				Map quotationRelatedToServicesMap = getSimpleFormatServicesOfQuotation(portfolio, portfolioServiceMap, serviceProps, serviceSequenceOrder) 
				serviceTblObjectGrouping.addAll(quotationRelatedToServicesMap["serviceTblObjectGrouping"])
				serviceTblObjectNonGrouping.addAll(quotationRelatedToServicesMap["serviceTblObjectNonGrouping"])
				serviceSequenceOrder = quotationRelatedToServicesMap["serviceSequenceOrder"]
			}
			else if(displayType == "tabelFormat")
			{
				String cleanedText = getTableFormatServicesOfQuotation(portfolio, portfolioServiceMap, serviceProps)
				serviceTblObjectGrouping.add(XmlUtils.unmarshalString(cleanedText))
			}
			serviceTblObjectGrouping.add(XmlUtils.unmarshalString(newLine))
			if(displayType == "simpleFormat")
			{
				serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(newLine))
			}
		}
		
		return [serviceTblObjectGrouping: serviceTblObjectGrouping, serviceTblObjectNonGrouping: serviceTblObjectNonGrouping]  
	}
	
	public Map getQuotationOfferingServicesData(List serviceQuotationList, String displayType, Properties serviceProps)
	{
		List serviceTblObjectGrouping = new ArrayList(), serviceTblObjectNonGrouping = new ArrayList()
		
		int serviceSequenceOrder = 1
		for(ServiceQuotation serviceQuotation : serviceQuotationList.sort{it?.sequenceOrder})
		{
			if(displayType == "simpleFormat")
			{
				Map quotationRelatedToServicesMap = getSimpleFormatServicesOfQuotation(serviceQuotation, serviceProps, serviceSequenceOrder)
				serviceTblObjectGrouping.addAll(quotationRelatedToServicesMap["serviceTblObjectGrouping"])
				serviceTblObjectNonGrouping.addAll(quotationRelatedToServicesMap["serviceTblObjectNonGrouping"])
				serviceSequenceOrder = quotationRelatedToServicesMap["serviceSequenceOrder"]
			}
			else if(displayType == "tabelFormat")
			{
				String cleanedText = getTableFormatServicesOfQuotation(serviceQuotation, serviceProps)
				serviceTblObjectGrouping.add(XmlUtils.unmarshalString(cleanedText))
			}
			//serviceTblObjectGrouping.add(XmlUtils.unmarshalString(newLine))
			if(displayType == "simpleFormat")
			{
				//serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(newLine))
			}
		}
		
		return [serviceTblObjectGrouping: serviceTblObjectGrouping, serviceTblObjectNonGrouping: serviceTblObjectNonGrouping]
	}
	
	public void addExtraUnitOfSaleAndUnitInMap(Map servicePropertiesMap, ServiceQuotation serviceQuotation)
	{
		JSONArray additionalUnitOfSaleJSONArray = (serviceQuotation?.additionalUnitOfSaleJsonArray != null) ? new JSONArray(serviceQuotation?.additionalUnitOfSaleJsonArray) : new JSONArray()
		
		int exraUnitSequence = 1
		
		for(JSONObject extraUnitJsonObject : additionalUnitOfSaleJSONArray)
		{
			servicePropertiesMap.put('extra_unit_'+exraUnitSequence, extraUnitJsonObject.get("units"))//eu.extraUnit)
			exraUnitSequence++
		}
	}
	
	public String getTableFormatServicesOfQuotation(ServiceQuotation serviceQuotation, Properties serviceProps)
	{
		List serviceDefinitionLanguages = new ArrayList()
		ServiceQuotation sq = serviceQuotation
			
		def sowDefs = getSOWDefinitionList(sq)
		
		if(sowDefs.size() > 0)
		{
			Map map = [service: sq.service, units: sq.totalUnits, unitofsale: sq.service.serviceProfile.unitOfSale, customer: quotation.account.accountName]
			
			addExtraUnitOfSaleAndUnitInMap(map, sq)
			
			/*sq.profile.listExtraUnitsOfSaleAndUnits().each { eu ->
				map.put('extra_unit_'+exraUnitSequence, eu.extraUnit)
				exraUnitSequence++
			}*/
			
			def tmpDefs = []
			for(ServiceProfileSOWDef sowDef : sowDefs)
			{
				String definition = sowDef.definitionSetting?.value.replaceAll("\\<[^>]*>","").replaceAll("\\&.*?\\;", "")
				definition = evaluateValues(serviceProps, definition, map, "tableFormat");
				tmpDefs.add(definition)
				
			}
			serviceDefinitionLanguages.add(tmpDefs)
		}			
		
		String cleanedText = groovyPageRendererService.sowPortfolioRelatedServicesToWordDocumentConverter(['serviceQuotation': sq, 'serviceDefinitionLanguages': serviceDefinitionLanguages])
		return cleanedText
	}
	
	public String getTableFormatServicesOfQuotation(Portfolio portfolio, Map portfolioServiceMap, Properties serviceProps)
	{
		List serviceDefinitionLanguages = new ArrayList()
		for(ServiceQuotation sq : portfolioServiceMap[portfolio?.id].sort{it?.service?.serviceName})
		{
			def map = [service: sq.service, units: sq.totalUnits, unitofsale: sq.service.serviceProfile.unitOfSale, customer: quotation.account.accountName]
			addExtraUnitOfSaleAndUnitInMap(map, sq)
			
			/*int exraUnitSequence = 1
			sq.profile.listExtraUnitsOfSaleAndUnits().each { eu ->
				map.put('extra_unit_'+exraUnitSequence, eu.extraUnit)
				exraUnitSequence++
			}*/
			
			def sowDefs = getSOWDefinitionList(sq)
			if(sowDefs.size() > 0)
			{				
				def tmpDefs = []
				for(ServiceProfileSOWDef sowDef : sowDefs)
				{
					String definition = sowDef.definitionSetting?.value.replaceAll("\\<[^>]*>","").replaceAll("\\&.*?\\;", "")
					definition = evaluateValues(serviceProps, definition, map, "tableFormat");
					tmpDefs.add(definition)
					
				}
				serviceDefinitionLanguages.add(tmpDefs)
			}
			
		}
		
		/*def text = g.render(template:"/quotation/portfolioRelatedServices", model:[portfolioInstance: portfolio, serviceQuotationList: portfolioServiceMap[portfolio?.id], serviceDefinitionLanguages: serviceDefinitionLanguages])
		//def text = g.render(template:"/quotation/sowTemplates/portfolioRelatedServicesSimpleFormat", model:[portfolioInstance: portfolio, serviceQuotationList: portfolioServiceMap[portfolio?.id], serviceDefinitionLanguages: serviceDefinitionLanguages])
		text = '<w:tbl xmlns:w=\"http://schemas.openxmlformats.org/wordprocessingml/2006/main\">'+text+"</w:tbl>"
		String cleanedText = text.replaceAll( "(&(?!amp;))", "&amp;" )*/
		return ""//cleanedText
	}
	
	public boolean isInstance(String instanceName)
	{
		Setting instanceSetting = Setting.findByName("instanceName")
		if(instanceSetting?.value == instanceName)
		{
			return true
		}
		return false
	}
	
	public Map getServiceSowLanguageTableContent(List serviceQuotationList, Properties serviceProps)
	{
		Map sowDefinitionLanguageMap = new HashMap()
		for(ServiceQuotation sq : serviceQuotationList.sort{it?.sequenceOrder})
		{
			List sowDefinitionLanguageList = new ArrayList()
			
			//----------------------service scope of work----------------------------------------------------
			
				def sowDefs = getSOWDefinitionList(sq)
				if(sowDefs.size() > 0)
				{
					def map = [service: sq.service, units: sq.totalUnits, unitofsale: sq.service.serviceProfile.unitOfSale, customer: quotation.account.accountName]
					addExtraUnitOfSaleAndUnitInMap(map, sq)
					
					/*int exraUnitSequence = 1
					sq.profile.listExtraUnitsOfSaleAndUnits().each { eu ->
						map.put('extra_unit_'+exraUnitSequence, eu.extraUnit)
						exraUnitSequence++
					}*/
					
					def tmpDefs = []
					for(ServiceProfileSOWDef sowDef : sowDefs)
					{
						String definition = sowDef.definitionSetting?.value?.toString().replaceAll("<hr />", "<hr></hr>")//.replaceAll("\\<[^>]*>","").replaceAll("\\&.*?\\;", "")
						definition = evaluateValues(serviceProps, definition, map, "simpleFormat");
						tmpDefs.add(definition)
						
						List stringList = rteToWordTagConverter.convertRteToWordDocumentFormat(definition)
						
						for(List strList : stringList)
						{
							def languageDefinition = groovyPageRendererService.convertScopeOfWorkToXMLWordDocument(strList, "sow_language")
							if(languageDefinition != null)
							{
								sowDefinitionLanguageList.add(XmlUtils.unmarshalString(languageDefinition))
							}
						}
						
					}
				}

				sowDefinitionLanguageMap.put("service_sow_language_" + sq?.profile?.id, sowDefinitionLanguageList)
			//-----------------------------------------------------------------------------------------------
		}
		return sowDefinitionLanguageMap
	}
	
	public Map getSimpleFormatServicesOfQuotation(ServiceQuotation serviceQuotation, Properties serviceProps, int serviceSequenceOrder)
	{
		List serviceTblObjectGrouping = new ArrayList(), serviceTblObjectNonGrouping = new ArrayList()
		ServiceQuotation sq = serviceQuotation
		/*if(!isInstance("smp"))
		{
			def portfolioName = groovyPageRendererService.convertObjectToXMLWordDocument(portfolio, "", "portfolioName")
			serviceTblObjectGrouping.add(XmlUtils.unmarshalString(portfolioName))
			serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(portfolioName))
		}
		*/
		
			def serviceDefinitionLanguages = new ArrayList()
		
			//-------------------------------service definition part-----------------------------------------
				def serviceName = groovyPageRendererService.convertObjectToXMLWordDocument(sq, "${serviceSequenceOrder}.", "serviceName")
				serviceTblObjectGrouping.add(XmlUtils.unmarshalString(serviceName))
				serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(serviceName))
				
			//-----------------------------------------------------------------------------------------------
			//----------------------service scope of work----------------------------------------------------
			
				def sowDefs = getSOWDefinitionList(sq)
				if(sowDefs.size() > 0)
				{
					/*def languageTitle = groovyPageRendererService.convertObjectToXMLWordDocument(null, "", "languageTitle")
					serviceTblObjectGrouping.add(XmlUtils.unmarshalString(languageTitle))
					serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(languageTitle))*/
					
					def map = [service: sq.service, units: sq.totalUnits, unitofsale: sq.service.serviceProfile.unitOfSale, customer: quotation.account.accountName]
					addExtraUnitOfSaleAndUnitInMap(map, sq)
					
					/*int exraUnitSequence = 1
					sq.profile.listExtraUnitsOfSaleAndUnits().each { eu ->
						map.put('extra_unit_'+exraUnitSequence, eu.extraUnit)
						exraUnitSequence++
					}*/
					
					def tmpDefs = []
					for(ServiceProfileSOWDef sowDef : sowDefs)
					{
						String definition = sowDef.definitionSetting?.value?.toString().replaceAll("<hr />", "<hr></hr>")//.replaceAll("\\<[^>]*>","").replaceAll("\\&.*?\\;", "")
						definition = evaluateValues(serviceProps, definition, map, "simpleFormat");
						tmpDefs.add(definition)
						
						//println "scope definition for ${sowDef?.definitionSetting?.id} "+definition
						List stringList = rteToWordTagConverter.convertRteToWordDocumentFormat(definition)
						
						for(List strList : stringList)
						{
							def languageDefinition = groovyPageRendererService.convertScopeOfWorkToXMLWordDocument(strList, "sow_language")
							if(languageDefinition != null)
							{
								serviceTblObjectGrouping.add(XmlUtils.unmarshalString(languageDefinition))
								serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(languageDefinition))
							}
						}
						
						/*def languageDefinition = groovyPageRendererService.convertObjectToXMLWordDocument(definition, "", "languageDefinition")
						serviceTblObjectGrouping.add(XmlUtils.unmarshalString(languageDefinition))
						serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(languageDefinition))*/
					}
					serviceDefinitionLanguages.add(tmpDefs)
					
					serviceTblObjectGrouping.add(XmlUtils.unmarshalString(newLine))
					serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(newLine))
				}
			
			//-----------------------------------------------------------------------------------------------
			//---------------------Service prerequisites-----------------------------------------------------
			
				List prerequisiteMetaphors = getServiceProfilePrerequisiteMetaphors(sq)
				if(prerequisiteMetaphors.size() > 0)
				{
					def prerequisitesTitle = groovyPageRendererService.convertObjectToXMLWordDocument(null, "", "prerequisitesTitle")
					serviceTblObjectGrouping.add(XmlUtils.unmarshalString(prerequisitesTitle))
					serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(prerequisitesTitle))
									
					for(ServiceProfileMetaphors prerequisite : prerequisiteMetaphors)
					{
						/*String definition = prerequisite.definitionString?.value.replaceAll("\\<[^>]*>","").replaceAll("\\&.*?\\;", "")
						
						def prerequisiteDefinition = groovyPageRendererService.convertObjectToXMLWordDocument(definition, "", "prerequisiteDefinition")
						serviceTblObjectGrouping.add(XmlUtils.unmarshalString(prerequisiteDefinition))
						serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(prerequisiteDefinition))*/
						
						String definition = prerequisite.definitionString?.value.toString().replaceAll("<hr />", "<hr></hr>")
						List prerequisiteMetaphorsList = rteToWordTagConverter.convertRteToWordDocumentFormat(definition)
						for(List strList : prerequisiteMetaphorsList)
						{
							def prerequisiteMetaphorsPara = groovyPageRendererService.convertScopeOfWorkToXMLWordDocument(strList, "pre_requisite_metaphors")
							if(prerequisiteMetaphorsPara != null){
								serviceTblObjectGrouping.add(XmlUtils.unmarshalString(prerequisiteMetaphorsPara))
								serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(prerequisiteMetaphorsPara))
							}
						}
					}
					
					serviceTblObjectGrouping.add(XmlUtils.unmarshalString(newLine))
					serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(newLine))
					
				}
			//-----------------------------------------------------------------------------------------------
			//-------------------Service out of scope--------------------------------------------------------
			
				List outOfScopeMetaphors = getServiceProfileOutOfScopeMetaphors(sq)
				if(outOfScopeMetaphors.size() > 0)
				{
					def outOfScopeTitle = groovyPageRendererService.convertObjectToXMLWordDocument(null, "", "outOfScopeTitle")
					serviceTblObjectGrouping.add(XmlUtils.unmarshalString(outOfScopeTitle))
					serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(outOfScopeTitle))
									
					for(ServiceProfileMetaphors outOfScope : outOfScopeMetaphors)
					{
						/*String definition = outOfScope.definitionString?.value.replaceAll("\\<[^>]*>","").replaceAll("\\&.*?\\;", "")
						
						def outOfScopeDefinition = groovyPageRendererService.convertObjectToXMLWordDocument(definition, "", "outOfScopeDefinition")
						serviceTblObjectGrouping.add(XmlUtils.unmarshalString(outOfScopeDefinition))
						serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(outOfScopeDefinition))*/
						
						String definition = outOfScope.definitionString?.value.toString().replaceAll("<hr />", "<hr></hr>")
						List outOfScopeMetaphorsList = rteToWordTagConverter.convertRteToWordDocumentFormat(definition)
						for(List strList : outOfScopeMetaphorsList)
						{
							def outOfScopeMetaphorsPara = groovyPageRendererService.convertScopeOfWorkToXMLWordDocument(strList, "out_of_scope_metaphors")
							if(outOfScopeMetaphorsPara != null){
								serviceTblObjectGrouping.add(XmlUtils.unmarshalString(outOfScopeMetaphorsPara))
								serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(outOfScopeMetaphorsPara))
							}
						}
					}
					
					serviceTblObjectGrouping.add(XmlUtils.unmarshalString(newLine))
					serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(newLine))
					
				}
			//--------------------------------------------------------------------------------------------------
			
			boolean isDeliverablesTagAvailabe = isDeliverablesTagAvailableInScopeOfWork(sowDefs)
			
			if(isDeliverablesTagAvailabe)
			{
				List serviceDeliverableActivitiesTasksInGroupingList = getServiceDeliverablesActivitiesTasksInGrouping(sq, serviceSequenceOrder)//need activity/tasks with grouping inside deliverables
				List serviceDeliverableActivitiesTasksNonGroupingList = getServiceDeliverablesActivitiesTasksNonGrouping(sq, serviceSequenceOrder)//need activity/tasks without grouping inside deliverables
				
				if(serviceDeliverableActivitiesTasksInGroupingList?.size() > 0)
				{
					serviceTblObjectGrouping.addAll(serviceDeliverableActivitiesTasksInGroupingList)
					serviceTblObjectGrouping.add(XmlUtils.unmarshalString(newLine))
				}
				if(serviceDeliverableActivitiesTasksNonGroupingList?.size() > 0)
				{
					serviceTblObjectNonGrouping.addAll(serviceDeliverableActivitiesTasksNonGroupingList)
					serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(newLine))
				}
			}
			
			//serviceTblObjectGrouping.add(XmlUtils.unmarshalString(newLine))
			//serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(newLine))
			
			serviceSequenceOrder++
			
		
		return [serviceTblObjectGrouping: serviceTblObjectGrouping, serviceTblObjectNonGrouping: serviceTblObjectNonGrouping, serviceSequenceOrder: serviceSequenceOrder]
	}
	
	public Map getSimpleFormatServicesOfQuotation(Portfolio portfolio, Map portfolioServiceMap, Properties serviceProps, int serviceSequenceOrder)
	{
		List serviceTblObjectGrouping = new ArrayList(), serviceTblObjectNonGrouping = new ArrayList() 
		
		/*if(!isInstance("smp"))
		{
			def portfolioName = groovyPageRendererService.convertObjectToXMLWordDocument(portfolio, "", "portfolioName")
			serviceTblObjectGrouping.add(XmlUtils.unmarshalString(portfolioName))
			serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(portfolioName))
		}
		*/
		
		def serviceDefinitionLanguages = new ArrayList()
		for(ServiceQuotation sq : portfolioServiceMap[portfolio?.id].sort{it?.service?.serviceName})
		{
			//-------------------------------service definition part-----------------------------------------
				def serviceName = groovyPageRendererService.convertObjectToXMLWordDocument(sq, "${serviceSequenceOrder}.", "serviceName")
				serviceTblObjectGrouping.add(XmlUtils.unmarshalString(serviceName))
				serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(serviceName))
				
			//-----------------------------------------------------------------------------------------------
			//----------------------service scope of work----------------------------------------------------
			
				def sowDefs = getSOWDefinitionList(sq)
				if(sowDefs.size() > 0)
				{
					/*def languageTitle = groovyPageRendererService.convertObjectToXMLWordDocument(null, "", "languageTitle")
					serviceTblObjectGrouping.add(XmlUtils.unmarshalString(languageTitle))
					serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(languageTitle))*/
					
					def map = [service: sq.service, units: sq.totalUnits, unitofsale: sq.service.serviceProfile.unitOfSale, customer: quotation.account.accountName]
					addExtraUnitOfSaleAndUnitInMap(map, sq)
					
					/*int exraUnitSequence = 1
					sq.profile.listExtraUnitsOfSaleAndUnits().each { eu ->
						map.put('extra_unit_'+exraUnitSequence, eu.extraUnit)
						exraUnitSequence++
					}*/
					
					def tmpDefs = []
					for(ServiceProfileSOWDef sowDef : sowDefs)
					{
						String definition = sowDef.definitionSetting?.value?.toString().replaceAll("<hr />", "<hr></hr>")//.replaceAll("\\<[^>]*>","").replaceAll("\\&.*?\\;", "")
						definition = evaluateValues(serviceProps, definition, map, "simpleFormat");
						tmpDefs.add(definition)
						
						//println "scope definition for ${sowDef?.definitionSetting?.id} "+definition
						List stringList = rteToWordTagConverter.convertRteToWordDocumentFormat(definition)
						
						for(List strList : stringList)
						{
							def languageDefinition = groovyPageRendererService.convertScopeOfWorkToXMLWordDocument(strList, "sow_language")
							if(languageDefinition != null)
							{
								serviceTblObjectGrouping.add(XmlUtils.unmarshalString(languageDefinition))
								serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(languageDefinition))
							}
						}
						
						/*def languageDefinition = groovyPageRendererService.convertObjectToXMLWordDocument(definition, "", "languageDefinition")
						serviceTblObjectGrouping.add(XmlUtils.unmarshalString(languageDefinition))
						serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(languageDefinition))*/
					}
					serviceDefinitionLanguages.add(tmpDefs)
				}
			
			//-----------------------------------------------------------------------------------------------
			//---------------------Service prerequisites----------------------------------------------------- 
			
				List prerequisiteMetaphors = getServiceProfilePrerequisiteMetaphors(sq)			
				if(prerequisiteMetaphors.size() > 0)
				{
					def prerequisitesTitle = groovyPageRendererService.convertObjectToXMLWordDocument(null, "", "prerequisitesTitle")
					serviceTblObjectGrouping.add(XmlUtils.unmarshalString(prerequisitesTitle))
					serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(prerequisitesTitle))
									
					for(ServiceProfileMetaphors prerequisite : prerequisiteMetaphors)
					{
						/*String definition = prerequisite.definitionString?.value.replaceAll("\\<[^>]*>","").replaceAll("\\&.*?\\;", "")
						
						def prerequisiteDefinition = groovyPageRendererService.convertObjectToXMLWordDocument(definition, "", "prerequisiteDefinition")
						serviceTblObjectGrouping.add(XmlUtils.unmarshalString(prerequisiteDefinition))
						serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(prerequisiteDefinition))*/
						
						String definition = prerequisite.definitionString?.value.toString().replaceAll("<hr />", "<hr></hr>")
						List prerequisiteMetaphorsList = rteToWordTagConverter.convertRteToWordDocumentFormat(definition)
						for(List strList : prerequisiteMetaphorsList)
						{
							def prerequisiteMetaphorsPara = groovyPageRendererService.convertScopeOfWorkToXMLWordDocument(strList, "pre_requisite_metaphors")
							if(prerequisiteMetaphorsPara != null){
								serviceTblObjectGrouping.add(XmlUtils.unmarshalString(prerequisiteMetaphorsPara))
								serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(prerequisiteMetaphorsPara))
							}
						}
					}
					
				}
			//-----------------------------------------------------------------------------------------------
			//-------------------Service out of scope--------------------------------------------------------
			
				List outOfScopeMetaphors = getServiceProfileOutOfScopeMetaphors(sq)
				if(outOfScopeMetaphors.size() > 0)
				{
					def outOfScopeTitle = groovyPageRendererService.convertObjectToXMLWordDocument(null, "", "outOfScopeTitle")
					serviceTblObjectGrouping.add(XmlUtils.unmarshalString(outOfScopeTitle))
					serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(outOfScopeTitle))
									
					for(ServiceProfileMetaphors outOfScope : outOfScopeMetaphors)
					{
						/*String definition = outOfScope.definitionString?.value.replaceAll("\\<[^>]*>","").replaceAll("\\&.*?\\;", "")
						
						def outOfScopeDefinition = groovyPageRendererService.convertObjectToXMLWordDocument(definition, "", "outOfScopeDefinition")
						serviceTblObjectGrouping.add(XmlUtils.unmarshalString(outOfScopeDefinition))
						serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(outOfScopeDefinition))*/
						
						String definition = outOfScope.definitionString?.value.toString().replaceAll("<hr />", "<hr></hr>")
						List outOfScopeMetaphorsList = rteToWordTagConverter.convertRteToWordDocumentFormat(definition)
						for(List strList : outOfScopeMetaphorsList)
						{
							def outOfScopeMetaphorsPara = groovyPageRendererService.convertScopeOfWorkToXMLWordDocument(strList, "out_of_scope_metaphors")
							if(outOfScopeMetaphorsPara != null){
								serviceTblObjectGrouping.add(XmlUtils.unmarshalString(outOfScopeMetaphorsPara))
								serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(outOfScopeMetaphorsPara))
							}
						}
					}
					
				}
			//--------------------------------------------------------------------------------------------------
			
			boolean isDeliverablesTagAvailabe = isDeliverablesTagAvailableInScopeOfWork(sowDefs)
			
			if(isDeliverablesTagAvailabe)
			{
				List serviceDeliverableActivitiesTasksInGroupingList = getServiceDeliverablesActivitiesTasksInGrouping(sq, serviceSequenceOrder)//need activity/tasks with grouping inside deliverables
				List serviceDeliverableActivitiesTasksNonGroupingList = getServiceDeliverablesActivitiesTasksNonGrouping(sq, serviceSequenceOrder)//need activity/tasks without grouping inside deliverables
				
				if(serviceDeliverableActivitiesTasksInGroupingList?.size() > 0)
				{
					serviceTblObjectGrouping.addAll(serviceDeliverableActivitiesTasksInGroupingList)
				}
				if(serviceDeliverableActivitiesTasksNonGroupingList?.size() > 0)
				{
					serviceTblObjectNonGrouping.addAll(serviceDeliverableActivitiesTasksNonGroupingList)
				}
			}
			
			//serviceTblObjectGrouping.add(XmlUtils.unmarshalString(newLine))
			//serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(newLine))
			
			serviceSequenceOrder++
			
		}
		return [serviceTblObjectGrouping: serviceTblObjectGrouping, serviceTblObjectNonGrouping: serviceTblObjectNonGrouping, serviceSequenceOrder: serviceSequenceOrder]
	}
	
	public List getServiceDeliverablesActivitiesTasksNonGrouping(ServiceQuotation sq, int serviceSequenceOrder)
	{
		int activitySequenceOrder = 1
		List customerDeliverables = sq?.profile?.listCustomerDeliverables(), serviceTblObject = new ArrayList()
		if(customerDeliverables?.size() > 0)
		{
			List serviceDeliverableTblObject = new ArrayList(), serviceActivityTblObject = new ArrayList()
			boolean first = true
			
			serviceDeliverableTblObject.add(XmlUtils.unmarshalString(groovyPageRendererService.convertObjectToXMLWordDocument(null, "", "deliverableTitle")))
			int sdId = 1
			for(ServiceDeliverable sDeliverable : customerDeliverables.sort{it?.sequenceOrder})
			{
				int saId = 1
				for(ServiceActivity sActivity : sDeliverable?.serviceActivities.sort{it?.sequenceOrder})
				{
					if(first){serviceActivityTblObject.add(XmlUtils.unmarshalString(groovyPageRendererService.convertObjectToXMLWordDocument(null, "", "activitiyTitle"))); first = false}
					
					String activityObjectId = serviceSequenceOrder + "." + activitySequenceOrder + "."//sdId+"."+saId+"."
					serviceActivityTblObject.add(XmlUtils.unmarshalString(groovyPageRendererService.convertObjectToXMLWordDocument(sActivity, activityObjectId, "activityDefinition")))
					serviceActivityTblObject.addAll(getServiceActivitiesTasksInGrouping(sActivity, activityObjectId, false))
					saId++
					activitySequenceOrder++
				}
				serviceDeliverableTblObject.add(XmlUtils.unmarshalString(groovyPageRendererService.convertObjectToXMLWordDocument(sDeliverable, "", "deliverableDefinition")))
				sdId++
				
			}
			
			serviceTblObject.addAll(serviceActivityTblObject)
			serviceTblObject.addAll(XmlUtils.unmarshalString(newLine))			
			serviceTblObject.addAll(serviceDeliverableTblObject)
		}
		
		return serviceTblObject
	}
	
	public List getServiceDeliverablesActivitiesTasksInGrouping(ServiceQuotation sq, int serviceSequenceOrder)
	{
		List serviceDeliverableActivityGroup = new ArrayList()
		int activitySequenceOrder = 1
		List customerDeliverables = sq?.profile?.listCustomerDeliverables()
		if(customerDeliverables?.size() > 0)
		{
			List serviceDeliverableTblObject = new ArrayList(), serviceActivityTblObject = new ArrayList()
			boolean first = true
			
			serviceDeliverableActivityGroup.add(XmlUtils.unmarshalString(groovyPageRendererService.convertObjectToXMLWordDocument(null, "", "deliverableAndActivityTitle")))
			int sdId = 1
			for(ServiceDeliverable sDeliverable : customerDeliverables.sort{it?.sequenceOrder})
			{
				int saId = 1
				serviceDeliverableActivityGroup.add(XmlUtils.unmarshalString(groovyPageRendererService.convertObjectToXMLWordDocument(sDeliverable, "", "deliverableDefinition")))
				for(ServiceActivity sActivity : sDeliverable?.serviceActivities.sort{it?.sequenceOrder})
				{
					//if(first){serviceActivityTblObject.add(XmlUtils.unmarshalString(groovyPageRendererService.convertObjectToXMLWordDocument(null, "", "activitiyTitle"))); first = false}
					
					String activityObjectId = serviceSequenceOrder + "." + activitySequenceOrder + "."//sdId+"."+saId+"."
					serviceDeliverableActivityGroup.add(XmlUtils.unmarshalString(groovyPageRendererService.convertObjectToXMLWordDocument(sActivity, activityObjectId, "activityDefinitionGrouping")))
					serviceDeliverableActivityGroup.addAll(getServiceActivitiesTasksInGrouping(sActivity, activityObjectId, true))
					saId++
					activitySequenceOrder++
				}
				//serviceDeliverableTblObject.add(XmlUtils.unmarshalString(groovyPageRendererService.convertObjectToXMLWordDocument(sDeliverable, "", "deliverableDefinition")))
				sdId++
			}
			
		}
		
		return serviceDeliverableActivityGroup
	}
	
	public List getServiceActivitiesTasksInGrouping(ServiceActivity serviceActivity, String serviceActivitySequenceOrder, boolean isActivityInGroup)
	{
		int activityTaskSequenceOrder = 1
		List serviceActivityTasksTblObject = new ArrayList(), serviceActivityTblObject = new ArrayList()
		List activityTasks = serviceActivity?.activityTasks?.sort{it?.sequenceOrder}, serviceTblObject = new ArrayList()
		
		String objectType = isActivityInGroup ? "activityTaskDefinitionInGrouping" : "activityTaskDefinition"
		
		if(activityTasks?.size() > 0)
		{
			boolean first = true
			
			for(ServiceActivityTask saTask : activityTasks?.sort{it?.sequenceOrder})
			{
				String activityTaskObjectId = serviceActivitySequenceOrder + activityTaskSequenceOrder + "."//sdId+"."+saId+"."
				serviceActivityTasksTblObject.add(XmlUtils.unmarshalString(groovyPageRendererService.convertObjectToXMLWordDocument(saTask, activityTaskObjectId, objectType)))
				activityTaskSequenceOrder++
			}
		}
		
		return serviceActivityTasksTblObject
	}
	
		
	def sampleText = """\
		<w:wordDocument xmlns:w=\"http://schemas.microsoft.com/office/word/2003/wordml" xmlns:v=\"urn:schemas-microsoft-com:vml" xmlns:w10=\"urn:schemas-microsoft-com:office:word" xmlns:sl=\"http://schemas.microsoft.com/schemaLibrary/2003/core" xmlns:aml=\"http://schemas.microsoft.com/aml/2001/core" xmlns:wx=\"http://schemas.microsoft.com/office/word/2003/auxHint" xmlns:o=\"urn:schemas-microsoft-com:office:office" xmlns:dt=\"uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" w:macrosPresent="no" w:embeddedObjPresent="no" w:ocxPresent="no" xml:space="preserve">
	"""
	
	public String getParagraphObjectString(String type)
	{
		String text = '<w:p xmlns:w=\"http://schemas.openxmlformats.org/wordprocessingml/2006/main\" '
		
		switch(type)
		{
			case "portfolioName": text = text + 'w:rsidR="006C3FC0" w:rsidRDefault="00E943EC" w:rsidP="00E943EC"'
				break
				
			case "serviceName": text = text + 'w:rsidR="00E943EC" w:rsidRDefault="00E943EC" w:rsidP="00E943EC"'
				break
				
			case "prerequisitesTitle": text = text + 'w:rsidR="00E943EC" w:rsidRDefault="00E943EC" w:rsidP="00E943EC"'
				break
				
			case "prerequisiteDefinition": text = text + 'w:rsidR="003715FB" w:rsidRDefault="003715FB" w:rsidP="003715FB"'
				break
				
			case "outOfScopeTitle": text = text + 'w:rsidR="00E943EC" w:rsidRDefault="00E943EC" w:rsidP="00E943EC"'
				break
				
			case "outOfScopeDefinition": text = text + 'w:rsidR="003715FB" w:rsidRDefault="003715FB" w:rsidP="003715FB"'
				break
				
			case "languageTitle": text = text + 'w:rsidR="00E943EC" w:rsidRDefault="00E943EC" w:rsidP="00E943EC"'
				break
				
			case "languageDefinition": text = text + 'w:rsidR="003715FB" w:rsidRDefault="003715FB" w:rsidP="003715FB"'
				break
				
			case "deliverableAndActivityTitle": text = text + 'w:rsidR="00E943EC" w:rsidRDefault="00E943EC" w:rsidP="00E943EC"'
				break
				
			case "deliverableDefinition": text = text + 'w:rsidR="003715FB" w:rsidRDefault="003715FB" w:rsidP="003715FB"'
				break
				
			case "activityDefinitionGrouping": text = text + 'w:rsidR="003715FB" w:rsidRDefault="003715FB" w:rsidP="003715FB"'
				break
				
		}
		
		text = text + '>'
		return text
	}
	
	public Properties getSOWProperties()
	{
		Properties props = new Properties();
		File sowPropsFile = applicationContext.getResource("/props/sow.properties").getFile();
		props.load(new FileReader(sowPropsFile));
		
		def ciList = CompanyInformation.list()
		def companyInfo = null;
		if(ciList != null &&	 ciList.size() > 0){
			companyInfo = ciList.get(0)
		}
		def customer_country = (quotation.account?.billingAddress?.billCountry?.size() > 3)?quotation.account?.billingAddress?.billCountry:'<g:country code="${quotation.account?.billingAddress?.billCountry}"/>'
		def map = [ci: companyInfo, q: quotation, customer_country: customer_country]
		
		return evaluateProperties(props, map)
	}
	
	public boolean isFileExist(String filePath)
	{
		boolean isThere = false
		File f = new File(filePath);
		
		 if(f.exists())
		 {
			 isThere = true
		 }
		 
		 return isThere
	}
	
	public String cleanString(String str)
	{
		str = str.replaceAll( "(&(?!amp;))", "&amp;" );
		return str
	}
	
	private Properties evaluateProperties(Properties props, Map map)
	{
		for(String key: props.keySet())
		{
			try{
				
					String evaluation = props.get(key);
					String value = Eval.me("map", map, evaluation).toString();
					props.put(key, value)
				
			}catch(Exception e){

			}

		}

		return props;
	}
	
	private String evaluateValues(Properties props, String text, Map map, String formatType)
	{
		for(String key: props.keySet())
		{
			try{
				String tag = "[@@" + key + "@@]"
				if(text.contains(tag))
				{
					if(key != "deliverables")
					{
						String evaluation = props.get(key);
						String value = Eval.me("map", map, evaluation).toString();
						text = text.replace(tag, value);
					} else{
						if(formatType == "tableFormat")
							text = text.replace(tag, "[Note: All deliverables shown in next column.]")
						else if(formatType == "simpleFormat")
							text = text.replace(tag, "[Note: All deliverables shown below in Deliverables section.]")
					}
				}
			}catch(Exception e){
				println e
			}
		}

		return text;
	}
	
	private boolean isDeliverablesTagAvailableInScopeOfWork(List sowDefs)
	{
		for(ServiceProfileSOWDef sowDef : sowDefs)
		{
			String definition = sowDef.definitionSetting?.value?.toString()
			String deliverablesTag = "[@@deliverables@@]"
			
			if(definition.contains(deliverablesTag))
				return true
				break;			
		}
		
		return false
	}

	static String heading1 = """\
		<w:p xmlns:w=\"http://schemas.openxmlformats.org/wordprocessingml/2006/main\" w:rsidR="004A341D" w:rsidRDefault="002A3C5B" w:rsidP="002A3C5B">
			<w:pPr>
				<w:pStyle w:val="Heading1"/>
			</w:pPr>
			<w:r><w:t>Hello</w:t></w:r>
		</w:p>
	"""
	static String newLine = """\
		<w:p xmlns:w=\"http://schemas.openxmlformats.org/wordprocessingml/2006/main\">
			
		</w:p>
	""";

	static String sampleParagraphString1 = """\
	<w:p xmlns:w=\"http://schemas.openxmlformats.org/wordprocessingml/2006/main\">
		<w:r>
			<w:t>
				Here is sample paragraph line 1
			</w:t>
		</w:r>
	</w:p>
""";

	static String sampleParagraphString2 = """\
<w:p xmlns:w=\"http://schemas.openxmlformats.org/wordprocessingml/2006/main\">
		<w:r>
			<w:t>
				paragraph line 2
			</w:t>
		</w:r>
	</w:p>
""";

	static String sampleTableString1 = """\
<w:p xmlns:w=\"http://schemas.openxmlformats.org/wordprocessingml/2006/main\">
		<w:r>
			<w:t>
				Here is sample table
			</w:t>
		</w:r>
	</w:p>
"""

	static String sampleTableString2 = """\
<w:tbl xmlns:w=\"http://schemas.openxmlformats.org/wordprocessingml/2006/main\">
  <w:tblPr>
    <w:tblStyle w:val="TableGrid" />
    <w:tblW w:w="5000"
            w:type="pct" />
  </w:tblPr>
  <w:tblGrid>
    <w:gridCol />
    <w:gridCol />
    <w:gridCol />
  </w:tblGrid>
  <w:tr>
    <w:tc>
      <w:p>
        <w:r>
          <w:t>1</w:t>
        </w:r>
      </w:p>
    </w:tc>
    <w:tc>
      <w:p>
        <w:r>
          <w:t>2</w:t>
        </w:r>
      </w:p>
    </w:tc>
    <w:tc>
      <w:p>
        <w:r>
          <w:t>3</w:t>
        </w:r>
      </w:p>
    </w:tc>
  </w:tr>
</w:tbl>
   """

	
}
