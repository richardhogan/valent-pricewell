package com.valent.pricewell

import javax.xml.parsers.DocumentBuilder
import javax.xml.parsers.DocumentBuilderFactory
import org.w3c.dom.Document
import org.w3c.dom.NamedNodeMap
import org.w3c.dom.NodeList;
import org.w3c.dom.Node;
import org.w3c.dom.Element;
import java.io.File;

class FileSystemService {

    static transactional = true

    def serviceMethod() {

    }
	
	public List readImportedLeadFile(String file)//file = full path of file
	{
		
		def leads = []
		try {
			
			   File fXmlFile = new File("web-app/xml/test.xml");
			   Document doc = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(fXmlFile);
			   
			   doc.getDocumentElement().normalize();
			
			   System.out.println("Root element :" + doc.getDocumentElement().getNodeName());
			
			   NodeList leadList = doc.getElementsByTagName("lead");
			
			   System.out.println("----------------------------");
			
			   for (int temp = 0; temp < leadList.getLength(); temp++) 
			   {
			
				   Node leadNode = leadList.item(temp);
			
				   System.out.println("\nCurrent Element :" + leadNode.getNodeName());
			
				   if (leadNode.getNodeType() == Node.ELEMENT_NODE) 
				   {
					   NodeList leadPropList = leadNode.getChildNodes()
					   
					   for(int j =0; j < leadPropList.getLength(); j++)
					   {
						   def leadProperties = [:]
						   Node leadProp = leadPropList.item(j)
						   
						   if(leadProp.getNodeType() == Node.ELEMENT_NODE)
						   {
							   if(leadProp.getNodeName() == "billingAddress")
							   {
								   NodeList addressProperties = leadProp.getChildNodes()
								   def billingAddress = [:]
							   		
								   for(int k=0; k < addressProperties.getLength(); k++)
								   {
									   Node prop = addressProperties.item(k)
									   if(prop.getNodeType() == Node.ELEMENT_NODE)
									   {
										   String checkedAttr = checkAddressAttributes(prop.getNodeName().toString())
										   if(checkedAttr != "")
										   {
											   billingAddress[checkedAttr] = prop.getTextContent()
										   }
									   }
								   }
								   leadProperties['billingAddress'] = billingAddress
							   }
							   else
							   {
								   String checkedAttr = checkSalesAttributes(leadProp.getNodeName().toString())
								   if(checkedAttr != "")
								   {
									   leadProperties[checkedAttr] = leadProp.getTextContent()
								   }
							   }
							   
							   leads.add(leadProperties)
						   }
						   
					   }
			
					  
				   }
			   }
		   } catch (Exception e) {
		   		e.printStackTrace();
		   }
		   
		   return leads
		
	}
	
	
	public static def checkAddressAttributes(String attr)
	{
		def attrName = ""
		switch(attr.toString().toUpperCase())
		{
			case "BILLADDRESSLINE1": return "billAddressLine1"
										break;
			case "BILLADDRESSLINE2": return "billAddressLine2"
										break;
			case "BILLCITY": 		return "billCity"
										break;
			case "BILLPOSTCODE": 	return "billPostalCode"
										break;
			case "BILLSTATE": 		return "billState"
										break;
			case "BILLCOUNTRY": 	return "billCountry"
										break;
			case "SHIPADDRESSLINE1": return "shipAddressLine1"
										break;
			case "SHIPADDRESSLINE2": return "shipAddressLine2"
										break;
			case "SHIPCITY": 		return "shipCity"
										break;
			case "SHIPPOSTCODE": 	return "shipPostalCode"
										break;
			case "SHIPSTATE": 		return "shipState"
										break;
			case "SHIPCOUNTRY": 	return "shipCountry"
										break;
			default :				return attrName
										break
		}
	}
	
	public static def checkSalesAttributes(String attr)
	{
		def attrName = ""
		switch(attr.toString().toUpperCase())
		{
			case "FIRSTNAME" : 
							return "firstname"
							break
			case "FIRST_NAME" :
							return "firstname"
							break
			case "FIRST-NAME" :
							return "firstname"
							break
			case "LASTNAME" :
							return "lastname"
							break
			case "LAST_NAME" :
							return "lastname"
							break
			case "LAST-NAME" :
							return "lastname"
							break
			case "PHONE" :
							return "phone"
							break
			case "MOBILE" :
							return "mobile"
							break
			case "EMAIL" :
							return "email"
							break
			case "E-MAIL" :
							return "email"
							break
			case "ALTEMAIL" :
							return "altEmail"
							break
			case "ALTE-MAIL" :
							return "altEmail"
							break
			case "TITLE" :
							return "title"
							break
			case "COMPANY" :
							return "company"
							break
			case "FAX" :
							return "fax"
							break
			case "ISO" :
							return "iso"
							break
			case "FORMAT" :
							return "format"
							break
			case "DEPARTMENT" :
							return "department"
							break
			case "WEBSITE" :
							return "website"
							break
			case "TYPE" :
							return "type"
							break
			case "ACCOUNTNAME" :
							return "accountName"
							break
			case "ACCOUNT_NAME" :
							return "accountName"
							break
			case "ACCOUNT-NAME" :
							return "accountName"
							break
			default : 
						    return attrName
							break
		}
	}
}
