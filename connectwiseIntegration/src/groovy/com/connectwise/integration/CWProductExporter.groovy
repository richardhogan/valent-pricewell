package com.connectwise.integration

import java.net.MalformedURLException;
import java.net.URL;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import cw15.ApiCredentials;
import cw15.ArrayOfProductListItem;
import cw15.ProductApi;
import cw15.ProductApiSoap;
import cw15.ProductListItem;

class CWProductExporter {

	String baseUrl;
	
	public CWProductExporter(String url)
	{
		this.baseUrl = url//+"/v4_6_release/apis/1.5/ProductApi.asmx?wsdl"
	}
	
	public List<Integer> getOpportunityServiceIds(ApiCredentials credentials, List<String> productTypes)
	{
		String productUrl = baseUrl + "/v4_6_release/apis/1.5/ProductApi.asmx?wsdl"
		Set<Integer> includeIds = getServiceIds(credentials, productUrl, productTypes)//Arrays.asList("Service"))//, "Fixed", "Product"));
		
		return includeIds.toList()
	}
	
	public static Set<Integer> getServiceIds(ApiCredentials credentials, String productURL, List<String> keywords) throws MalformedURLException{
		ProductApi prodApi = new cw15.ProductApi(new URL(productURL));
		ProductApiSoap prodSoap = prodApi.getProductApiSoap();
		
		StringBuffer conditionStr = new StringBuffer();
		boolean isFirst = true;
		for(String keyword: keywords){
			if(!isFirst){
				conditionStr.append(" OR ");
			} else {
				isFirst = false;
			}
			conditionStr.append( " type LIKE '%" + keyword + "%' ");
		}

		HashSet<Integer> ids = new HashSet<Integer>();
		int pageSize = 10;
		int count = 0;
		ArrayOfProductListItem products = prodSoap.findProducts(credentials, conditionStr.toString(), "", pageSize, count);

		while(products != null && products.getProductListItem().size() > 0){
			for(ProductListItem product: products.getProductListItem()){
				//System.out.println("Description : " + product.getDescription() + " Type : " +product.getType() + " Id : " + product.getId() + " Item Id : "+ product.getItemId());
				ids.add(product.getId());
			}
			count+=pageSize;
			products = prodSoap.findProducts(credentials, conditionStr.toString(), "", pageSize, count);
		}
		
		//System.out.println("---------------------------------------------------------");
		return ids;

	}
	
	public String isProductApiPermissionAvailable(ApiCredentials credentials)
	{
		String url = baseUrl + "/v4_6_release/apis/1.5/ProductApi.asmx?wsdl";
		
		ProductApi prodApi = new cw15.ProductApi(new URL(url));
		ProductApiSoap prodSoap = prodApi.getProductApiSoap();
		
		try{
			ArrayOfProductListItem products = prodSoap.findProducts(credentials, "", "", 10, 0);
			
			return "success_product_api"
		}catch(Exception e)
		{
			//e.printStackTrace(System.out);
			String failureMessage = generateFailureMessage(e.getMessage())
			
			return failureMessage
		}
		
		
	}
	
	public String generateFailureMessage(String errorMessage)
	{
		if(errorMessage != null)
		{
			if(errorMessage.contains("You do not have access to the Product api on this server"))
			{
				return "failure_product_api"
			}
		}
	}

}
