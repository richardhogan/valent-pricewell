package com.valent.pricewell.templater

import java.util.List;
import java.util.Map;
import java.util.Properties;

import com.valent.pricewell.*

import grails.gsp.PageRenderer
import groovy.json.StringEscapeUtils

import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONException
import org.codehaus.groovy.grails.web.json.JSONObject
import org.cyberneko.html.parsers.SAXParser
import org.docx4j.*

/**
 * This class contains all abstract logic for converter plugin, so all common
 * logic goes here and customer specific logic would go in separate subclass of BasicJsonConverterPlugin.
 * Created by snehal.mistry on 8/25/15.
 */
abstract class BasicJsonConverterPlugin implements SowJsonConverterPlugin 
{
    protected  def saxParser = new SAXParser()
    protected  def xmlParser =  new XmlSlurper(saxParser)
	
	protected def groovyPageRenderer = null
	protected RteToWordDocumentTagConverter rteToWordTagConverter = null
	
    /**
     * This contains SOW global information which stays same for one SOW
     */
    protected def globalBindingProps = [:]
    /**
     * Values can be override in localbinding as context changes for object,
     * so be careful to choose key name like description or name,
     * but instead use more meaningful name like baseUnits, unitOfSale, etc.
     */
    protected def localbindingProps = [:]
	
	/**
	 * This contains service properties 
	 */
	protected Properties localServiceProps = null
    /**
     * Excludes all these properties from sow.properties
     */
    protected def globalPropsExcludesList = ["sow_introduction", "services"]

    @Override
    JSONObject convertToJson(Quotation quotation)//, Object g)
	{
		//groovyPageRenderer = g
		//rteToWordTagConverter = new RteToWordDocumentTagConverter(groovyPageRenderer)
		
        fillGlobalProps(quotation)
		//JSONArray sowIntroductionJson = fillGlobalPropsWithSowIntroduction(quotation)
        JSONArray servicesJson = new JSONArray()
		JSONArray quotationDiscountJson = new JSONArray()
        JSONArray quoteServicesJson = new JSONArray()
        JSONArray quotesServiceAmountsJson = new JSONArray()

		quotation.sowDiscounts.each {
			quotationDiscountJson.add(convert(it, quotation?.geo?.currencySymbol))
		}
		
		if(quotation?.localDiscount > 0)
		{
			quotationDiscountJson.add(new ResolvableJsonObject()
											.put("discountAmount", quotation?.geo?.currencySymbol + quotation?.localDiscount)
											.put("description", eval(quotation?.localDiscountDescription))
                                            .getJsonObject()
            )
			
		}
		
        quotation.getActiveServiceQuotationList().sort{it.sequenceOrder}.each {
            servicesJson.add(convert(it))
        }

        quotation.getActiveServiceQuotationList().sort{it.sequenceOrder}.each {
            quotesServiceAmountsJson.add(new ResolvableJsonObject()
                    .put("price", quotation.geo?.currencySymbol + it.price)
                    .put("name", it.service.serviceName)
                    .getJsonObject()
            );
            quoteServicesJson.add(new ResolvableJsonObject()
                    .put("name", it.service.serviceName)
                    .getJsonObject());
        }

        JSONObject sowObject = new ResolvableJsonObject()
                .put("services", servicesJson)
                .put("quote_services", quoteServicesJson)
                .put("quote_amount", quotesServiceAmountsJson)
				.put("quote_discount", quotationDiscountJson)
				//.put("sow_introduction", sowIntroductionJson)
                .getJsonObject()

        globalBindingProps.each {
            if(!globalPropsExcludesList.contains(it.key))
                sowObject.put(it.key, it.value)
        }

        return sowObject
    }

    @Override
    String convertToJsonString(Quotation quotation) {
        return convertToJson(quotation).toString()
    }

	protected JSONObject convert(SowDiscount sowDiscount, String symbol)
	{
		JSONObject sowDiscountJson = new ResolvableJsonObject()
                                        .put("discountAmount", symbol + sowDiscount?.amount)
                                        .put("description", eval(sowDiscount?.description))
                                        .getJsonObject()
		return sowDiscountJson
	}
	
    protected JSONObject convert(ServiceQuotation serviceQuotation)
	{
        JSONObject serviceJson = new ResolvableJsonObject()
                .put("name", serviceQuotation.service.serviceName)
                .put("price", serviceQuotation.geo?.currencySymbol + serviceQuotation.price)
                .put("description", eval(serviceQuotation.service.description))
                .getJsonObject()
		
        JSONArray actsJson = new JSONArray()
        JSONArray delsJson = new JSONArray()
		//JSONArray sowDefLanguageJson = convertSowDefinitionLanguage(serviceQuotation)
		
        serviceQuotation.profile.customerDeliverables.each { deliverable ->
            deliverable.serviceActivities.each { sa ->
                actsJson.add(convert(sa))
            }
			
            delsJson.add(new ResolvableJsonObject()
                    .put("name", deliverable.name)
                    .put("description", eval(deliverable.description))
                    .getJsonObject())
        }

        serviceJson.put("activities", actsJson)
        serviceJson.put("deliverables", delsJson)
		serviceJson.put("sowlanguage", "service_sow_language_" + serviceQuotation?.profile?.id)
		//serviceJson.put("sowLanguages", sowDefLanguageJson)


        //ServiceProfileMetaphors
        def metaphorsMap = ["prerequisites": serviceQuotation.profile.listServiceProfileMetaphors(ServiceProfileMetaphors.MetaphorsType.PRE_REQUISITE),
                            "outofscopes":  serviceQuotation.profile.listServiceProfileMetaphors(ServiceProfileMetaphors.MetaphorsType.OUT_OF_SCOPE)]
        //Even if pre-reqs or out-of-scopes is empty, we still need empty array
        metaphorsMap.each{ k, l ->
            JSONArray mJson = convert(l, k)
            serviceJson.put(k, mJson)
        }

        return serviceJson
    }

	protected JSONArray convertSowDefinitionLanguage(ServiceQuotation serviceQuotation)
	{
		JSONArray sowDefLanguageJsonArray = new JSONArray()
		def sowDefs = getSOWDefinitionList(serviceQuotation)
		if(sowDefs.size() > 0)
		{		
			def map = [service: serviceQuotation.service, units: serviceQuotation.totalUnits, unitofsale: serviceQuotation.service.serviceProfile.unitOfSale, customer: serviceQuotation.quotation.account.accountName]
			def tmpDefs = []
			for(ServiceProfileSOWDef sowDef : sowDefs)
			{
				String definition = sowDef.definitionSetting?.value?.toString().replaceAll("<hr />", "<hr></hr>")
				definition = evaluateServiceProperties(localServiceProps, definition, map, "simpleFormat");
				tmpDefs.add(definition)
				
				List stringList = rteToWordTagConverter.convertRteToWordDocumentFormat(definition)
				
				for(List strList : stringList)
				{
					def languageDefinition = convertScopeOfWorkToXMLWordDocument(strList, "sow_language")
					println languageDefinition
					if(languageDefinition != null && languageDefinition != "")
					{
						sowDefLanguageJsonArray.add(new ResolvableJsonObject().put("sowLanguage", XmlUtils.unmarshalString(languageDefinition)).getJsonObject())
					}
				}
								
			}
		}
		return sowDefLanguageJsonArray
	}
	
	public List getSOWDefinitionList(ServiceQuotation sq)
	{
		Quotation quotation = Quotation.get(sq?.quotation?.id)
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
	
    protected String eval(String str){
        if(str == null){
            return ""
        }
        try {
            Map newMap = (localbindingProps.size() > 0 ? globalBindingProps + localbindingProps : globalBindingProps)
            return evalString(str, newMap)
        }catch(Throwable e){
            println "Error while evaluating string:" + str + " Error:" + e.getMessage()
            return str
        }
    }

    protected JSONArray convert(List<ServiceProfileMetaphors> profileMetaphorses, String metaphoresType)
	{
        JSONArray mJson = new JSONArray()
		String metaType = (metaphoresType.equals("prerequisites")) ? "pre_requisite_metaphors" : "out_of_scope_metaphors" 
		
        profileMetaphorses.each {
            String val = eval(it.definitionString.value.toString().replaceAll("<hr />", "<hr></hr>"))
			
			
			if(val.contains("<li") && val.contains("</li>")){
                 parseHTMLLists(val).each { l->
					 println "value : " + l
					
					 /*List metaphorsList = rteToWordTagConverter.convertRteToWordDocumentFormat(l)
					 for(List strList : metaphorsList)
					 {
						 def metaphorsPara = convertScopeOfWorkToXMLWordDocument(strList, metaType)
						 println "paragraph : " + metaphorsPara
						 if(metaphorsPara != null){
							 mJson.add(new ResolvableJsonObject().put("name", XmlUtils.unmarshalString(metaphorsPara)).getJsonObject())
						 }
					 }*/
					
                    mJson.add(new ResolvableJsonObject()
                            .put("name",l)
                            .getJsonObject());
                }
            } else {
			
				
				
                mJson.add(new ResolvableJsonObject()
                        .put("name", val)
                        .getJsonObject())
            }
			
			
        }
        return mJson
    }

    protected JSONObject convert(ServiceActivity sa){
        JSONObject activityJson = new ResolvableJsonObject()
			                        .put("name", sa.name)
			                        .put("description", eval(sa.description))
			                        .put("category", sa.category)
									.put("sequenceOrder", sa.sequenceOrder.toString())
                                    .getJsonObject()

        JSONArray tasksJson = new JSONArray()
        sa.activityTasks.each { task ->
            tasksJson.add(new ResolvableJsonObject()
                    .put("name", task.task)
                    .getJsonObject())
        }
        activityJson.put("tasks", tasksJson)

        return activityJson;
    }

    public class ResolvableJsonObject {

        JSONObject jsonObject;

        public ResolvableJsonObject(){
            this.jsonObject = new JSONObject()
        }

        public JSONObject getJsonObject(){
            return this.jsonObject;
        }

        public ResolvableJsonObject put(String key, Object value) throws JSONException {
            if(value instanceof String)
			{
                String val = value.toString()
                if(value.toString().contains('${')){
                    val = eval(value.toString())
                }
                //val = org.apache.commons.lang.StringEscapeUtils.escapeXml(val)
                //println val
                jsonObject.put(key, val)
            }
            else{
                jsonObject.put(key, value)
            }
            return this
        }
    }

    /**
     * Retrieve properties from sow.properties file and resolve it's values and store it in globalProps
     * @param quotation
     */
    protected void fillGlobalProps(Quotation quotation)
	{
        println "globalBindingProps:" + globalBindingProps
		
        Properties props = new Properties();
        if(!quotation.hasProperty("domainClass")){
            println "Error can't get application context, so all SOW global properties would be empty"
            return
        }
		
        def grailsApplication = quotation.domainClass?.grailsApplication
        if(!grailsApplication){
            println "Error can't get application context, so all SOW global properties would be empty"
            return
        }
		
        def appContext = grailsApplication.mainContext
        File sowPropsFile = appContext.getResource("/props/sow.properties").getFile();
        props.load(new FileReader(sowPropsFile));

		localServiceProps = new Properties();
		File sowServicesPropsFile = appContext.getResource("/props/sow-services.properties").getFile();
		localServiceProps.load(new FileReader(sowServicesPropsFile));
		
        def ciList = CompanyInformation.list()
        def companyInfo = null;
        if(ciList != null &&	 ciList.size() > 0){
            companyInfo = ciList.get(0)
        }
        def customer_country = (quotation.account?.billingAddress?.billCountry?.size() > 3)?quotation.account?.billingAddress?.billCountry:'<g:country code="${quotation.account?.billingAddress?.billCountry}"/>'
        def map = [ci: companyInfo, q: quotation, customer_country: customer_country]

        globalBindingProps = evaluateProperties(props, map)
    }
	
	protected JSONArray fillGlobalPropsWithSowIntroduction(Quotation quotation)
	{
		JSONArray sowIntroductionObjectList = new JSONArray()
		
		if(quotation?.sowIntroductionSetting?.value != null && quotation?.sowIntroductionSetting?.value != 'null' && quotation?.sowIntroductionSetting?.value != '')
		{
			List sowIntroductionList = rteToWordTagConverter.convertRteToWordDocumentFormat(eval(quotation?.sowIntroductionSetting?.value))
			
			
			for(List strList : sowIntroductionList)
			{
				def sowIntroductionPara = convertScopeOfWorkToXMLWordDocument(strList, "sow_introduction")
				if(sowIntroductionPara != null && sowIntroductionPara != "")
					sowIntroductionObjectList.add(new ResolvableJsonObject().put("introduction", XmlUtils.unmarshalString(sowIntroductionPara)).getJsonObject())
				//sowIntroductionObjectList.add(XmlUtils.unmarshalString(heading1))
			}
			
		}
		return sowIntroductionObjectList
	}
	
	protected def convertScopeOfWorkToXMLWordDocument(List documentContentList, String contentType)
	{
		String definition = documentContentList[0]
		if(definition == "")
		{
			return ""
		}
		String tagType = documentContentList[1]
		List styleList = documentContentList[2]
		Map tagStyleMap = documentContentList[3]
		
		if(definition?.length() == 0)
		{
			return null
		}

		def text = groovyPageRenderer.render(template:"/quotation/sowTemplates/scopeOfWorkLanguageTemplate", model:[object: definition?.replaceAll("&nbsp;", " "), tagType: tagType, contentType: contentType, styleList: styleList, tagStyleMap: tagStyleMap])
		//text = getParagraphObjectString(type) + text + '</w:p>' //
		//println text
		
		println text
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

    private Map evaluateProperties(Properties props, Map map)
    {
        def propsMap = [:]
        for(String key: props.keySet())
        {
            try{
                String evaluation = props.get(key);
                String value = Eval.me("map", map, evaluation).toString();
                propsMap.put(key, value)
            }catch(Exception e){

            }
        }
        return propsMap;
    }

    /**
     * This can evaluate groovy expressions as well.
     * @param text
     * @param values
     * @return
     */
    public String evalString(String text, Map values){
        def template = new groovy.text.GStringTemplateEngine().createTemplate(text)
        return template.make(values)
    }

    protected List parseHTMLLists(String text){
        def page = xmlParser.parseText(text)
        def lis = page.breadthFirst().findAll() {
            it.name() == "LI"
        }
        return lis.collect {t ->
            t.toString().trim()
        }
    }
	
	private String evaluateServiceProperties(Properties props, String text, Map map, String formatType)
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
	
	protected static String capitalize(String str){
	    String lower = str.toLowerCase()
	    return lower.replaceFirst(lower[0], lower[0].toUpperCase()) 
	}
		
	protected static String capitalizeInitialLetter(String str)
	{
		StringTokenizer tokenizer = new StringTokenizer(str);
		StringBuffer sb = new StringBuffer();
		while (tokenizer.hasMoreTokens()) {
			String word = tokenizer.nextToken();
			sb.append(word.substring(0, 1).toUpperCase());
			sb.append(word.substring(1).toLowerCase());
			sb.append(' ');
		}
		String text = sb.toString();
		
		return text
	}
}
