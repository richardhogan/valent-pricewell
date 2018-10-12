package com.valent.pricewell

import org.jsoup.Jsoup
import org.apache.shiro.SecurityUtils

import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.regex.Pattern

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



class ServiceWordSubstitutionMapGenerator implements SubstituionMapGenerator, ApplicationContextAware
{
	private ApplicationContext applicationContext
	private ServiceProfile serviceProfile
	private Object g
	private WordprocessingMLPackage wordMLPackage;
	
	//In constructor, you can pass SOW or Quotation related details
	public ServiceWordSubstitutionMapGenerator(ServiceProfile serviceProfile, Object g, ApplicationContext context, WordprocessingMLPackage wordMLPackage)
	{
		this.serviceProfile = serviceProfile
		this.g = g
		this.applicationContext = context
		this.wordMLPackage = wordMLPackage;
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
		return map;
	}
	
	//Generate values for all different tag variables with tables or multi-lines
	@Override
	public Map<String, List<Object>> generateSubstutionMap() 
	{
		  
		def user = User.get(new Long(SecurityUtils.subject.principal))
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		Map quotationServiceMap = getServiceOfServiceProfile()
		map.put('quotationOfferingServices', quotationServiceMap['quotationOfferingServices'])
		map.put('quotationOfferingServicesGrouping', quotationServiceMap['quotationOfferingServicesGrouping'])
		//map.put('quotedServicesPrice', quotationServiceMap['quotedServicesPrice'])
		ServiceProfileSOWDef defaultSOWDefinition = null
		for(ServiceProfileSOWDef sowDefinition : this.serviceProfile?.defs)
		{
			if(sowDefinition?.geo == null || sowDefinition?.geo == "")
			{
				defaultSOWDefinition = sowDefinition
				break
			}
		}
		
		String unitOfSale = this.serviceProfile.unitOfSale
		
		String definitiionSetting = "";  
		if(defaultSOWDefinition != null ){
			definitiionSetting = defaultSOWDefinition.getDefinitionSetting().value
		}
		if(unitOfSale!=null || unitOfSale!='null')
		{
		definitiionSetting = definitiionSetting.replace("@@unitofsale@@", unitOfSale);
		}
		definitiionSetting = definitiionSetting.replace("@@units@@", ""+this.serviceProfile.baseUnits);
		
		List sowIntroductionList = checkString(definitiionSetting)
		List sowIntroductionObjectList = []//new ArrayList()
		
		for(List strList : sowIntroductionList)
		{
			
			def sowIntroductionPara = convertScopeOfWorkToXMLWordDocument(strList[0], strList[1], strList[2], "sow_introduction")
			
			if(sowIntroductionPara != null){
				sowIntroductionObjectList.add(XmlUtils.unmarshalString(sowIntroductionPara))
			}
		}
		map.put("sow_introduction", sowIntroductionObjectList);
		return map;
	}
	
	public List checkString(String str)
	{
		List stringList = new ArrayList()
		List styleList = new LinkedList()
		if(str.length() > 0)
		{
			String convertedString = ""
			
			String stringBeforeLessThanTag = ""
			int firstOccuranceOfLessThanChar = str.indexOf('<')
			if(firstOccuranceOfLessThanChar > 0)
			{
				stringBeforeLessThanTag = str.substring(0, firstOccuranceOfLessThanChar)
				convertedString = convertStringStyleToArrayList(stringBeforeLessThanTag, styleList)['finalString']
				stringList.add([convertedString, "paragraph", styleList.toList()])
			}
			
			String stringLeft = str.substring(stringBeforeLessThanTag.length())
			if(isStringContainsRtfTag(str))
			{
				stringList.addAll(anotherString(stringLeft))
			}
				
		}
		
		//println stringList
		return stringList
	}
	

	public Map convertStringStyleToArrayList(String paragraphString, LinkedList styleList)
	{
		String finalString = ""
		String fileText = ""
		boolean hasLastSpace = false
		Map convertedMap = new HashMap()
		
		if(isStringContainsRtfTag(paragraphString))
		{
				int indexOfRTFStartCharacter = paragraphString.indexOf('<')
				int indexOfRTFEndCharacter = paragraphString.indexOf('>')
				
				String contentBeforeTag = paragraphString.substring(0, indexOfRTFStartCharacter)
				if(contentBeforeTag.length() > 0)
				{
					convertedMap = convertStringStyleToArrayList(contentBeforeTag, styleList)
					finalString = finalString + convertedMap['finalString']
				}
				
				
				String rtfTagString = paragraphString.substring(indexOfRTFStartCharacter+1, indexOfRTFEndCharacter)
				String rtfTag = (rtfTagString.contains(" ")) ? rtfTagString.split(" ")[0] : rtfTagString
				
				String stringBetweenRTFtag =""
				String endTag = "</"+rtfTag+">"
				//println rtfTag
				if(isValidTag(rtfTag))
				{
					styleList.addLast(rtfTag)
					
					stringBetweenRTFtag = paragraphString.substring(indexOfRTFEndCharacter+1, paragraphString.indexOf("</"+rtfTag+">"))
					
					if(convertedMap['hasLastSpace'])
					{
						stringBetweenRTFtag = " " + stringBetweenRTFtag
					}
					
					convertedMap = convertStringStyleToArrayList(stringBetweenRTFtag, styleList)
					finalString = finalString + convertedMap['finalString']
					
					styleList.removeLast()
				}
				
				String contentAfterTag = paragraphString.substring(paragraphString.indexOf(endTag)+endTag.length())
				if(contentAfterTag.length() > 0)
				{
					if(convertedMap['hasLastSpace'])
					{
						contentAfterTag = " " + contentAfterTag
					}
					
					convertedMap = convertStringStyleToArrayList(contentAfterTag, styleList)
					finalString = finalString + convertedMap['finalString']
				}
			//}
		}
		else
		{
			if(!isContainsOnlySpace(paragraphString))
			{
				Pattern pattern = Pattern.compile("\\&.*?\\;")
				
				if(paragraphString.contains("&nbsp;") || paragraphString.charAt(0).toString().equals(" ") || paragraphString.charAt(paragraphString?.length()-1).toString().equals(" "))
				{
					boolean isSpace = false
					paragraphString = paragraphString.replaceAll("&nbsp;", " ")
					
					if(paragraphString.charAt(0).toString().equals(" "))
					{
						styleList.addLast("spaceThere")
						isSpace = true
					}
					
					while(paragraphString.charAt(paragraphString?.length()-1).toString().equals(" "))
					{
						paragraphString = paragraphString.substring(0, paragraphString?.length()-1)
						hasLastSpace = true
						//styleList.addLast("spaceThere")
						//isSpace = true
					}
					
					if(paragraphString.find(pattern))
					{
						paragraphString = Jsoup.parse(paragraphString).text()
					}
					fileText = g.render(template:"/quotation/sowTemplates/scopeOfWorkLanguageTemplate", model:[isFinal: true, paragraphContent: paragraphString, styleList: styleList])
					
					if(hasLastSpace)
					{
						fileText = fileText + g.render(template:"/quotation/sowTemplates/scopeOfWorkLanguageTemplate", model:[isFinal: true, paragraphContent: " ", styleList: styleList])
					}
					
					if(isSpace)
					{
						styleList.removeLast()
					}
				}
				else
				{
					if(paragraphString.find(pattern))
					{
						paragraphString = Jsoup.parse(paragraphString).text()
					}
					fileText = g.render(template:"/quotation/sowTemplates/scopeOfWorkLanguageTemplate", model:[isFinal: true, paragraphContent: paragraphString, styleList: styleList])
				}
			}
			
			finalString = finalString + fileText
			
		}
		
		//println finalString
		Map resultMap = new HashMap()
		resultMap['finalString'] = finalString
		resultMap['hasLastSpace'] = hasLastSpace
		return resultMap//finalString
	}
	
	public boolean isContainsOnlySpace(String paragraphString)
	{
		
		paragraphString = paragraphString.replaceAll("&nbsp;", " ").replaceAll(" ", "")
		
		if(paragraphString.length() == 0)
			return true
		return false
	}
	
	public boolean isStringContainsRtfTag(String paragraphString)
	{
		if(paragraphString.contains("<") && paragraphString.contains(">") && paragraphString.contains("</"))
		{
			return true
		}
		return false
	}
	
	public boolean isValidTag(String tag)
	{
		switch(tag)
		{
			case "p":
			case "div":
			
			case "h1":
			case "h2":
			case "h3":
			case "h4":
			case "h5":
			case "h6":
			
			case "ul":
			case "li":
			
			case "span":
			case "a":
			
			case "b":
			case "strong":
			
			case "i":
			case "em":
			
			case "u":
				return true
			default :
				return false
		}
	}

	
	public def convertObjectToXMLWordDocument(Object object, String objectId,  String type)
	{
		def text = g.render(template:"/quotation/sowTemplates/portfolioRelatedServicesSimpleFormat", model:[object: object, objectId: objectId, type: type])
		//text = getParagraphObjectString(type) + text + '</w:p>' //
		text = '<w:p xmlns:w=\"http://schemas.openxmlformats.org/wordprocessingml/2006/main\">'+text+'</w:p>'
		String cleanedText = text.replaceAll( "(&(?!amp;))", "&amp;" )
		
		return cleanedText
	}
	
	public def convertScopeOfWorkToXMLWordDocument(String definition, String tagType, List styleList, String contentType)
	{
		if(definition?.length() == 0)
		{
			return null
		}
//		def text = g.render(template:"/quotation/sowTemplates/scopeOfWorkLanguageTemplate", model:[object: definition?.replaceAll("&nbsp;", " "), tagType: tagType, contentType: contentType, styleList: styleList])
		def text = g.render(template:"/quotation/sowTemplates/scopeOfWorkLangauageTemplateServiceProfile", model:[profile: this.serviceProfile, object: definition?.replaceAll("&nbsp;", " "), tagType: tagType, contentType: contentType, styleList: styleList])
				if(styleList.contains("h1"))
		{
			text = '<w:p xmlns:w=\"http://schemas.openxmlformats.org/wordprocessingml/2006/main\" w:rsidR="004A341D" w:rsidRDefault="002A3C5B" w:rsidP="002A3C5B">'+text+'</w:p>'
		}
		else if(styleList.contains("h2") || styleList.contains("h3") || styleList.contains("h4") || styleList.contains("h5"))
		{
			text = '<w:p xmlns:w=\"http://schemas.openxmlformats.org/wordprocessingml/2006/main\" w:rsidR="002A3C5B" w:rsidRDefault="002A3C5B" w:rsidP="002A3C5B">'+text+'</w:p>'
		}
		else if(styleList.contains("h6"))
		{
			text = '<w:p xmlns:w=\"http://schemas.openxmlformats.org/wordprocessingml/2006/main\" w:rsidR="002A3C5B" w:rsidRPr="002A3C5B" w:rsidRDefault="002A3C5B" w:rsidP="002A3C5B">'+text+'</w:p>'
		}  
		else
		{
			text = '<w:p xmlns:w=\"http://schemas.openxmlformats.org/wordprocessingml/2006/main\">'+text+'</w:p>'
		}
		//text = '<w:p xmlns:w=\"http://schemas.openxmlformats.org/wordprocessingml/2006/main\">'+text+'</w:p>'
		//println "Generated Text : " + text
		String cleanedText = text.replaceAll( "(&(?!amp;))", "&amp;" )
		return cleanedText  
	}
	public def getSampleXmlFormat()
	{
		def text = g.render(template:"/quotation/sowTemplates/sampleFormat")
		//text = getParagraphObjectString(type) + text + '</w:p>' //
		text = sampleText + text + '</w:wordDocument>'
		String cleanedText = text.replaceAll( "(&(?!amp;))", "&amp;" )
		
		return cleanedText
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
	
	public List anotherString(String str)
	{
		//println str
		String convertedString = ""
		LinkedList styleList = new LinkedList<String>()
		List stringList = new ArrayList()
		
		int indexOfRTFStartCharacter = str.indexOf('<')
		int indexOfRTFEndCharacter = str.indexOf('>')
		
		String rtfTagString = str.substring(indexOfRTFStartCharacter+1, indexOfRTFEndCharacter)
		String rtfTag = (rtfTagString.contains(" ")) ? rtfTagString.split(" ")[0] : rtfTagString
		
		String stringBetweenRTFtag =""
		String endTag = "</"+rtfTag+">"
		
		if(rtfTag == "p" || rtfTag == "div" || rtfTag == "h1" || rtfTag == "h2" || rtfTag == "h3" || rtfTag == "h4" || rtfTag == "h5" || rtfTag == "h6" )
		{
			
			stringBetweenRTFtag = str.substring(indexOfRTFEndCharacter+1, str.indexOf("</"+rtfTag+">"))
			if(isStringHasCharacter(stringBetweenRTFtag))
			{
				if(rtfTag == "h1" || rtfTag == "h2" || rtfTag == "h3" || rtfTag == "h4" || rtfTag == "h5" || rtfTag == "h6" )
					{styleList.addLast(rtfTag)}
					
				convertedString = convertStringStyleToArrayList(stringBetweenRTFtag, styleList)['finalString']
					
				//println styleList
				stringList.add([convertedString, "paragraph", styleList.toList()])
				
				if(rtfTag == "h1" || rtfTag == "h2" || rtfTag == "h3" || rtfTag == "h4" || rtfTag == "h5" || rtfTag == "h6" )
				{
					//println g.render(template:"/quotation/sowTemplates/scopeOfWorkLanguageTemplate", model:[object: convertedString?.replaceAll("&nbsp;", " "), tagType: "paragraph", contentType: "", styleList: styleList])
					styleList.removeLast()
				}
				//println stringBetweenRTFtag
			}
		}
		else if(rtfTag == "ul")
		{
			stringBetweenRTFtag = str.substring(indexOfRTFEndCharacter+1, str.indexOf("</"+rtfTag+">"))
			if(isStringHasCharacter(stringBetweenRTFtag))
			{
				stringList.addAll(anotherString(stringBetweenRTFtag))
			}
		}
		else if(rtfTag == "li")
		{
			stringBetweenRTFtag = str.substring(indexOfRTFEndCharacter+1, str.indexOf("</"+rtfTag+">"))
			if(isStringHasCharacter(stringBetweenRTFtag))
			{
				convertedString = convertStringStyleToArrayList(stringBetweenRTFtag, styleList)['finalString']
				stringList.add([convertedString, "list", styleList.toList()])
				//println stringBetweenRTFtag
			}
		}
		/*else if(rtfTag == "hr")
		{
			//stringBetweenRTFtag = str.substring(indexOfRTFEndCharacter+1, str.indexOf("</"+rtfTag+">"))
			stringList.add(["", "line"])
			//println stringBetweenRTFtag
		}*/
		
		if(str.length() > (str.indexOf(endTag)+endTag.length()))
		{
			String stringLeft = str.substring(str.indexOf(endTag)+endTag.length())
			
			if(isStringContainsRtfTag(stringLeft))
			{
				stringList.addAll(anotherString(stringLeft))
			}
			else
			{
				convertedString = convertStringStyleToArrayList(stringLeft, styleList)['finalString']
				stringList.add([convertedString, "paragraph", styleList.toList()])
			}
			
		}
		
		return stringList
	}
	
	public boolean isStringHasCharacter(String paragraphString)
	{
		paragraphString = paragraphString.replaceAll("\\<[^>]*>", "")
		if(paragraphString.length() > 0)
		{
			return true
		}
		return false
	}
	public Map getServiceOfServiceProfile()
	{
		String displayType = "simpleFormat"
		//def serquo = quotation.serviceQuotations
		//List portfolioList = [], serviceTblObject = [], quotedServicesPriceObject = []
		Map quotationServiceMap = [:]//, portfolioServiceMap = [:]
		
		Properties serviceProps = new Properties();
		File sowServicesPropsFile = applicationContext.getResource("/props/sow-services.properties").getFile();
		serviceProps.load(new FileReader(sowServicesPropsFile));
		
//		List serviceQuotations = []
//		for(ServiceQuotation sq in serquo)
//		{
//			if(sq?.stagingStatus?.name != "delete")
//			{
//				def portfolioId = sq.service.portfolio.id;
//				if(!portfolioServiceMap.containsKey(portfolioId))
//				{
//					portfolioServiceMap.put(portfolioId, new ArrayList());
//					portfolioList.add(sq.service.portfolio)
//				}
//	
//				portfolioServiceMap.get(sq.service.portfolio.id).add(sq);
//				
//				serviceQuotations.add(sq)
//			}
//			
//		}
		
		//quotationServiceMap['quotedServicesPrice'] = getQuotedServicePriceTable(portfolioList, quotation)//quotedServicesPriceObject
		//Map quotationOfferingServiceMap = getQuotationOfferingServicesData(portfolioList, displayType, portfolioServiceMap, serviceProps)//serviceTblObject
		Map quotationOfferingServiceMap = getServiceProfileOfferingServicesData(serviceProfile, displayType, serviceProps)//serviceTblObject
		quotationServiceMap['quotationOfferingServicesGrouping'] = quotationOfferingServiceMap["serviceTblObjectGrouping"]
		quotationServiceMap['quotationOfferingServices'] = quotationOfferingServiceMap["serviceTblObjectNonGrouping"]
		//return cleanedText
		
		return quotationServiceMap
	}
	public Map getServiceProfileOfferingServicesData(ServiceProfile serviceProfile, String displayType, Properties serviceProps)
	{
		List serviceTblObjectGrouping = new ArrayList(), serviceTblObjectNonGrouping = new ArrayList()
		def serviceProfileData=serviceProfile
		int serviceSequenceOrder = 1
		
			if(displayType == "simpleFormat")
			{
				Map quotationRelatedToServicesMap = getSimpleFormatServicesOfSerivceProfile(serviceProfileData, serviceProps, serviceSequenceOrder)
				serviceTblObjectGrouping.addAll(quotationRelatedToServicesMap["serviceTblObjectGrouping"])
				serviceTblObjectNonGrouping.addAll(quotationRelatedToServicesMap["serviceTblObjectNonGrouping"])
				serviceSequenceOrder = quotationRelatedToServicesMap["serviceSequenceOrder"]
			}
			else if(displayType == "tabelFormat")
			{
				//String cleanedText = getTableFormatServicesOfQuotation(serviceProfileData, serviceProps)
				//serviceTblObjectGrouping.add(XmlUtils.unmarshalString(cleanedText))
			}
			//serviceTblObjectGrouping.add(XmlUtils.unmarshalString(newLine))
			if(displayType == "simpleFormat")
			{
				//serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(newLine))
			}
		
		
		return [serviceTblObjectGrouping: serviceTblObjectGrouping, serviceTblObjectNonGrouping: serviceTblObjectNonGrouping]
	}
	public List getServiceDeliverablesActivitiesTasksNonGrouping(ServiceProfile sp, int serviceSequenceOrder)
	{
		int activitySequenceOrder = 1
		List customerDeliverables = sp?.listCustomerDeliverables(), serviceTblObject = new ArrayList()
		if(customerDeliverables?.size() > 0)
		{
			List serviceDeliverableTblObject = new ArrayList(), serviceActivityTblObject = new ArrayList()
			boolean first = true
			
			serviceDeliverableTblObject.add(XmlUtils.unmarshalString(convertObjectToXMLWordDocument(null, "", "deliverableTitle")))
			int sdId = 1
			for(ServiceDeliverable sDeliverable : customerDeliverables.sort{it?.sequenceOrder})
			{
				int saId = 1
				for(ServiceActivity sActivity : sDeliverable?.serviceActivities.sort{it?.sequenceOrder})
				{
					if(first){serviceActivityTblObject.add(XmlUtils.unmarshalString(convertObjectToXMLWordDocument(null, "", "activitiyTitle"))); first = false}
					
					String activityObjectId = serviceSequenceOrder + "." + activitySequenceOrder + "."//sdId+"."+saId+"."
					serviceActivityTblObject.add(XmlUtils.unmarshalString(convertObjectToXMLWordDocument(sActivity, activityObjectId, "activityDefinition")))
					serviceActivityTblObject.addAll(getServiceActivitiesTasksInGrouping(sActivity, activityObjectId, false))
					saId++
					activitySequenceOrder++
				}
				serviceDeliverableTblObject.add(XmlUtils.unmarshalString(convertObjectToXMLWordDocument(sDeliverable, "", "deliverableDefinition")))
				sdId++
				
			}
			
			serviceTblObject.addAll(serviceActivityTblObject)
			serviceTblObject.addAll(XmlUtils.unmarshalString(newLine))
			serviceTblObject.addAll(serviceDeliverableTblObject)
		}
		
		return serviceTblObject
	}
	public List getServiceDeliverablesActivitiesTasksInGrouping(ServiceProfile sp, int serviceSequenceOrder)
	{
		List serviceDeliverableActivityGroup = new ArrayList()
		int activitySequenceOrder = 1
		List customerDeliverables = sp?.listCustomerDeliverables()
		if(customerDeliverables?.size() > 0)
		{
			List serviceDeliverableTblObject = new ArrayList(), serviceActivityTblObject = new ArrayList()
			boolean first = true
			
			serviceDeliverableActivityGroup.add(XmlUtils.unmarshalString(convertObjectToXMLWordDocument(null, "", "deliverableAndActivityTitle")))
			int sdId = 1
			for(ServiceDeliverable sDeliverable : customerDeliverables.sort{it?.sequenceOrder})
			{
				int saId = 1
				serviceDeliverableActivityGroup.add(XmlUtils.unmarshalString(convertObjectToXMLWordDocument(sDeliverable, "", "deliverableDefinition")))
				for(ServiceActivity sActivity : sDeliverable?.serviceActivities.sort{it?.sequenceOrder})
				{
					//if(first){serviceActivityTblObject.add(XmlUtils.unmarshalString(convertObjectToXMLWordDocument(null, "", "activitiyTitle"))); first = false}
					
					String activityObjectId = serviceSequenceOrder + "." + activitySequenceOrder + "."//sdId+"."+saId+"."
					serviceDeliverableActivityGroup.add(XmlUtils.unmarshalString(convertObjectToXMLWordDocument(sActivity, activityObjectId, "activityDefinitionGrouping")))
					serviceDeliverableActivityGroup.addAll(getServiceActivitiesTasksInGrouping(sActivity, activityObjectId, true))
					saId++
					activitySequenceOrder++
				}
				//serviceDeliverableTblObject.add(XmlUtils.unmarshalString(convertObjectToXMLWordDocument(sDeliverable, "", "deliverableDefinition")))
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
				serviceActivityTasksTblObject.add(XmlUtils.unmarshalString(convertObjectToXMLWordDocument(saTask, activityTaskObjectId, objectType)))
				activityTaskSequenceOrder++
			}
		}
		
		return serviceActivityTasksTblObject
	}
	public List getSOWDefinitionList(ServiceProfile sp)
	{
		def sowDefs = []
		ServiceProfileSOWDef defaultDefinition = null
		
		for(ServiceProfileSOWDef sowDef : sp?.defs)
		{
			/*if(sowDef?.geo?.id == quotation?.geo?.id)
			{
				sowDefs.add(sowDef)
			}*/
			/*else
			{*/
				defaultDefinition = ServiceProfileSOWDef.get(sowDef.id)
			/*}*/
		}
		
		/*if(sowDefs.size() > 0)
		{
			return sowDefs
		}*/
		//else if(defaultDefinition?.definitionSetting?.value != null && defaultDefinition?.definitionSetting?.value != "")
		if(defaultDefinition?.definitionSetting?.value != null && defaultDefinition?.definitionSetting?.value != "")
		{
			return [defaultDefinition]
		}
		else return []
	}
	public Map getSimpleFormatServicesOfSerivceProfile(ServiceProfile serviceProfile, Properties serviceProps, int serviceSequenceOrder)
	{
		List serviceTblObjectGrouping = new ArrayList(), serviceTblObjectNonGrouping = new ArrayList()
		ServiceProfile sp = serviceProfile
		/*if(!isInstance("smp"))
		{
			def portfolioName = convertObjectToXMLWordDocument(portfolio, "", "portfolioName")
			serviceTblObjectGrouping.add(XmlUtils.unmarshalString(portfolioName))
			serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(portfolioName))
		}
		*/
		
		def serviceDefinitionLanguages = new ArrayList()  
		
			//-------------------------------service definition part-----------------------------------------
				def serviceName = convertObjectToXMLWordDocument(sp, "${serviceSequenceOrder}.", "serviceName")
				serviceTblObjectGrouping.add(XmlUtils.unmarshalString(serviceName))
				serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(serviceName))
				
			//-----------------------------------------------------------------------------------------------
			//----------------------service scope of work----------------------------------------------------
			
				def sowDefs = getSOWDefinitionList(sp)
				if(sowDefs.size() > 0)
				{
					/*def languageTitle = convertObjectToXMLWordDocument(null, "", "languageTitle")
					serviceTblObjectGrouping.add(XmlUtils.unmarshalString(languageTitle))
					serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(languageTitle))*/
					
					def map = [service: sp.service,units: sp.baseUnits, unitofsale: sp.unitOfSale]
					def tmpDefs = []
					for(ServiceProfileSOWDef sowDef : sowDefs)
					{
						String definition = sowDef.definitionSetting?.value?.toString().replaceAll("<hr />", "<hr></hr>")//.replaceAll("\\<[^>]*>","").replaceAll("\\&.*?\\;", "")
						definition = evaluateValues(serviceProps, definition, map, "simpleFormat");
						tmpDefs.add(definition)
						
						//println "scope definition for ${sowDef?.definitionSetting?.id} "+definition
						List stringList = checkString(definition)//(definition?.length() > 0) ? checkString() : []
						
						for(List strList : stringList)
						{
							def languageDefinition = convertScopeOfWorkToXMLWordDocument(strList[0], strList[1], strList[2], "sow_language")
							if(languageDefinition != null)
							{
								serviceTblObjectGrouping.add(XmlUtils.unmarshalString(languageDefinition))
								serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(languageDefinition))
							}
						}
						  
						/*def languageDefinition = convertObjectToXMLWordDocument(definition, "", "languageDefinition")
						serviceTblObjectGrouping.add(XmlUtils.unmarshalString(languageDefinition))
						serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(languageDefinition))*/
					}
					serviceDefinitionLanguages.add(tmpDefs)
					
					serviceTblObjectGrouping.add(XmlUtils.unmarshalString(newLine))
					serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(newLine))
				}
			
			//-----------------------------------------------------------------------------------------------
			//---------------------Service prerequisites-----------------------------------------------------
			
				List prerequisiteMetaphors = getServiceProfilePrerequisiteMetaphors(sp)
				if(prerequisiteMetaphors.size() > 0)
				{
					def prerequisitesTitle = convertObjectToXMLWordDocument(null, "", "prerequisitesTitle")
					serviceTblObjectGrouping.add(XmlUtils.unmarshalString(prerequisitesTitle))
					serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(prerequisitesTitle))
									
					for(ServiceProfileMetaphors prerequisite : prerequisiteMetaphors)
					{
						/*String definition = prerequisite.definitionString?.value.replaceAll("\\<[^>]*>","").replaceAll("\\&.*?\\;", "")
						
						def prerequisiteDefinition = convertObjectToXMLWordDocument(definition, "", "prerequisiteDefinition")
						serviceTblObjectGrouping.add(XmlUtils.unmarshalString(prerequisiteDefinition))
						serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(prerequisiteDefinition))*/
						
						String definition = prerequisite.definitionString?.value.toString().replaceAll("<hr />", "<hr></hr>")
						List prerequisiteMetaphorsList = checkString(definition)
						for(List strList : prerequisiteMetaphorsList)
						{
							def prerequisiteMetaphorsPara = convertScopeOfWorkToXMLWordDocument(strList[0], strList[1], strList[2], "pre_requisite_metaphors")
							if(prerequisiteMetaphorsPara != null){
								serviceTblObjectGrouping.add(XmlUtils.unmarshalString(prerequisiteMetaphorsPara))
								serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(prerequisiteMetaphorsPara))
							}
						}
					}
					
					serviceTblObjectGrouping.add(XmlUtils.unmarshalString(newLine))
					serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(newLine))
					
				}
//			//-----------------------------------------------------------------------------------------------
//			//-------------------Service out of scope--------------------------------------------------------
//			
//				List outOfScopeMetaphors = getServiceProfileOutOfScopeMetaphors(sq)
//				if(outOfScopeMetaphors.size() > 0)
//				{
//					def outOfScopeTitle = convertObjectToXMLWordDocument(null, "", "outOfScopeTitle")
//					serviceTblObjectGrouping.add(XmlUtils.unmarshalString(outOfScopeTitle))
//					serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(outOfScopeTitle))
//									
//					for(ServiceProfileMetaphors outOfScope : outOfScopeMetaphors)
//					{
//						/*String definition = outOfScope.definitionString?.value.replaceAll("\\<[^>]*>","").replaceAll("\\&.*?\\;", "")
//						
//						def outOfScopeDefinition = convertObjectToXMLWordDocument(definition, "", "outOfScopeDefinition")
//						serviceTblObjectGrouping.add(XmlUtils.unmarshalString(outOfScopeDefinition))
//						serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(outOfScopeDefinition))*/
//						
//						String definition = outOfScope.definitionString?.value.toString().replaceAll("<hr />", "<hr></hr>")
//						List outOfScopeMetaphorsList = checkString(definition)
//						for(List strList : outOfScopeMetaphorsList)
//						{
//							def outOfScopeMetaphorsPara = convertScopeOfWorkToXMLWordDocument(strList[0], strList[1], strList[2], "out_of_scope_metaphors")
//							if(outOfScopeMetaphorsPara != null){
//								serviceTblObjectGrouping.add(XmlUtils.unmarshalString(outOfScopeMetaphorsPara))
//								serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(outOfScopeMetaphorsPara))
//							}
//						}
//					}
//					
//					serviceTblObjectGrouping.add(XmlUtils.unmarshalString(newLine))
//					serviceTblObjectNonGrouping.add(XmlUtils.unmarshalString(newLine))
//					
//				}
			//------------------------------get Deliverables--------------------------------------------------------------------
			
			boolean isDeliverablesTagAvailabe = isDeliverablesTagAvailableInScopeOfWork(sowDefs)
			
			if(isDeliverablesTagAvailabe)
			{
				List serviceDeliverableActivitiesTasksInGroupingList = getServiceDeliverablesActivitiesTasksInGrouping(sp, serviceSequenceOrder)//need activity/tasks with grouping inside deliverables
				List serviceDeliverableActivitiesTasksNonGroupingList = getServiceDeliverablesActivitiesTasksNonGrouping(sp, serviceSequenceOrder)//need activity/tasks without grouping inside deliverables
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
	public List getServiceProfilePrerequisiteMetaphors(ServiceProfile sp)
	{
		ServiceProfile serviceProfile = ServiceProfile.get(sp?.id)
		List metaphorsList = serviceProfile.listServiceProfileMetaphors(ServiceProfileMetaphors.MetaphorsType.PRE_REQUISITE)
		return metaphorsList
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
//	public String getTableFormatServicesOfServiceProfile(ServiceProfile serviceProfile, Properties serviceProps)
//	{
//		List serviceDefinitionLanguages = new ArrayList()
//		ServiceQuotation sp = serviceProfile
//			
//		def sowDefs = getSOWDefinitionList(sq)
//		
//		if(sowDefs.size() > 0)
//		{
//			def map = [service: sp.service, units: sq.totalUnits, unitofsale: sq.service.serviceProfile.unitOfSale, customer: quotation.account.accountName]
//			def tmpDefs = []
//			for(ServiceProfileSOWDef sowDef : sowDefs)
//			{
//				String definition = sowDef.definitionSetting?.value.replaceAll("\\<[^>]*>","").replaceAll("\\&.*?\\;", "")
//				definition = evaluateValues(serviceProps, definition, map, "tableFormat");
//				tmpDefs.add(definition)
//				
//			}
//			serviceDefinitionLanguages.add(tmpDefs)
//		}
			
		
//		def text = g.render(template:"/quotation/sowTemplates/portfolioRelatedServices", model:[portfolioInstance: sq?.service?.portfolio, serviceQuotationList: [sq], serviceDefinitionLanguages: serviceDefinitionLanguages])
//		//def text = g.render(template:"/quotation/sowTemplates/portfolioRelatedServicesSimpleFormat", model:[portfolioInstance: portfolio, serviceQuotationList: portfolioServiceMap[portfolio?.id], serviceDefinitionLanguages: serviceDefinitionLanguages])
//		text = '<w:tbl xmlns:w=\"http://schemas.openxmlformats.org/wordprocessingml/2006/main\">'+text+"</w:tbl>"
//		String cleanedText = text.replaceAll( "(&(?!amp;))", "&amp;" )
//		return cleanedText
//	}
	static String newLine = """\
		<w:p xmlns:w=\"http://schemas.openxmlformats.org/wordprocessingml/2006/main\">
			
		</w:p>
	""";
	}