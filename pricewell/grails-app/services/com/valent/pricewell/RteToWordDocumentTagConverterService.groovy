package com.valent.pricewell

import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern
import org.jsoup.Jsoup
import grails.gsp.PageRenderer

class RteToWordDocumentTagConverterService {

	PageRenderer groovyPageRenderer
	
    public String serviceMethod() {
		
		String content =  groovyPageRenderer.render(template: '/quotation/helloTemplate')
		println content
		return content//"Hello World!"
    }
	
	public List convertRteToWordDocumentFormat(String str)
	{
		//println "main string : " + str
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
				stringList.add([convertedString, "paragraph", styleList.toList(), [:]])
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
	
	//<p><b>abhishek</b></p>
	
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
				
				Map tagStyleMap = getStyleInsideTag(rtfTagString)
				convertedString = convertStringStyleToArrayList(stringBetweenRTFtag, styleList)['finalString']
				
				stringList.add([convertedString, "paragraph", styleList.toList(), tagStyleMap])
				
				if(rtfTag == "h1" || rtfTag == "h2" || rtfTag == "h3" || rtfTag == "h4" || rtfTag == "h5" || rtfTag == "h6" )
				{
					styleList.removeLast()
				}
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
				Map tagStyleMap = getStyleInsideTag(rtfTagString)
				convertedString = convertStringStyleToArrayList(stringBetweenRTFtag, styleList)['finalString']
				
				stringList.add([convertedString, "list", styleList.toList(), tagStyleMap])
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
			
			if(stringLeft.length() > 2)
			{
				if(isStringContainsRtfTag(stringLeft))
				{
					println "String left with RTE tags now : " + stringLeft
					stringList.addAll(anotherString(stringLeft))
				}
				else
				{
					println "String left now : " + stringLeft
					convertedString = convertStringStyleToArrayList(stringLeft, styleList)['finalString']
					stringList.add([convertedString, "paragraph", styleList.toList(), [:]])
				}
			}
			
		}
		
		//println stringList
		return stringList
	}
	
	public Map getStyleInsideTag(String rtfTagString)
	{
		if(rtfTagString.contains(" "))
		{
			String tag = rtfTagString.split(" ")[0]
			String styleString = rtfTagString.substring(tag.length()+1)
			
			Map<String, String> styleMap = StyleToMapUtils.transformStyleToMap(styleString)
			return styleMap
		}
		else
		{
			return [:]
		}
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
	//<b>Abhi</b>
	
	public Map convertStringStyleToArrayList(String paragraphString, LinkedList styleList)
	{
		String finalString = ""
		String fileText = ""
		boolean hasLastSpace = false
		Map convertedMap = new HashMap()
		
		if(isStringContainsRtfTag(paragraphString))
		{
			/*if(paragraphString.charAt(0) == ' ')
			{
				fileText = g.render(template:"/quotation/sowTemplates/scopeOfWorkLanguageTemplate", model:[isSpace: true])
				finalString = finalString + fileText
				
				finalString = finalString + convertStringStyleToArrayList(paragraphString.substring(1), styleList)
			}
			else
			{*/
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
					fileText = groovyPageRenderer.render(template:"/quotation/sowTemplates/scopeOfWorkLanguageTemplate", model:[isFinal: true, paragraphContent: paragraphString, styleList: styleList])
					
					if(hasLastSpace)
					{
						fileText = fileText + groovyPageRenderer.render(template:"/quotation/sowTemplates/scopeOfWorkLanguageTemplate", model:[isFinal: true, paragraphContent: " ", styleList: styleList])
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
					fileText = groovyPageRenderer.render(template:"/quotation/sowTemplates/scopeOfWorkLanguageTemplate", model:[isFinal: true, paragraphContent: paragraphString, styleList: styleList])
				}
			}
			
			finalString = finalString + fileText
			
			/*if(paragraphString.charAt(0) == ' ' || paragraphString.charAt(paragraphString?.length()-1) == ' ')
			{
				styleList.removeLast()
			}*/
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

}
