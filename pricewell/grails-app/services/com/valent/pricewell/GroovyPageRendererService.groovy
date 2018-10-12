package com.valent.pricewell

import java.util.List;

import grails.gsp.PageRenderer;

class GroovyPageRendererService {

	PageRenderer groovyPageRenderer
	
    def serviceMethod() {

    }
	
	public String sowMilestonesContentToWordDocumentConverter(Map inputMap)
	{
		def text = groovyPageRenderer.render(template:"/quotation/sowTemplates/sowMilestone", model:[quotationInstance: inputMap['quotation'], totalAmount: inputMap['totalAmount']])
		text = '<w:tbl xmlns:w=\"http://schemas.openxmlformats.org/wordprocessingml/2006/main\">'+text+"</w:tbl>"
		String cleanedText = text.replaceAll( "(&(?!amp;))", "&amp;" )
		
		return cleanedText
	}
	
	public String sowQuotationServicePriceToWordDocumentConverter(Map inputMap)
	{
		def quotedServicesPriceString = groovyPageRenderer.render(template:"/quotation/sowTemplates/quotationServicePrice", model:[portfolioList: inputMap['portfolioList'], quotationInstance: inputMap['quotation']])
		quotedServicesPriceString = '<w:tbl xmlns:w=\"http://schemas.openxmlformats.org/wordprocessingml/2006/main\">'+quotedServicesPriceString+"</w:tbl>"
		
		String cleanedText = quotedServicesPriceString.replaceAll( "(&(?!amp;))", "&amp;" );
		
		return cleanedText
	}
	
	public String sowPortfolioRelatedServicesToWordDocumentConverter(Map inputMap)
	{
		ServiceQuotation sq = inputMap['serviceQuotation']
		def text = groovyPageRenderer.render(template:"/quotation/sowTemplates/portfolioRelatedServices", model:[portfolioInstance: sq?.service?.portfolio, serviceQuotationList: [sq], serviceDefinitionLanguages: inputMap['serviceDefinitionLanguages']])
		//def text = g.render(template:"/quotation/sowTemplates/portfolioRelatedServicesSimpleFormat", model:[portfolioInstance: portfolio, serviceQuotationList: portfolioServiceMap[portfolio?.id], serviceDefinitionLanguages: serviceDefinitionLanguages])
		text = '<w:tbl xmlns:w=\"http://schemas.openxmlformats.org/wordprocessingml/2006/main\">'+text+"</w:tbl>"
		String cleanedText = text.replaceAll( "(&(?!amp;))", "&amp;" )
	}
	
	public def convertObjectToXMLWordDocument(Object object, String objectId,  String type)
	{
		def text = groovyPageRenderer.render(template:"/quotation/sowTemplates/portfolioRelatedServicesSimpleFormat", model:[object: object, objectId: objectId, type: type])
		//text = getParagraphObjectString(type) + text + '</w:p>' //
		text = '<w:p xmlns:w=\"http://schemas.openxmlformats.org/wordprocessingml/2006/main\">'+text+'</w:p>'
		String cleanedText = text.replaceAll( "(&(?!amp;))", "&amp;" )
		
		return cleanedText
	}
	
	public def convertScopeOfWorkToXMLWordDocument(List documentContentList, String contentType)
	{
		String definition = documentContentList[0]
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
	
}
