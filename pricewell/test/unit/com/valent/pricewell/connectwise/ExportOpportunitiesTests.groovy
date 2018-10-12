package com.valent.pricewell.connectwise

import static org.junit.Assert.*

import cw15.ApiCredentials
import cw15.ArrayOfOpportunityItem
import cw15.ArrayOfOpportunityListItem
import cw15.Opportunity
import cw15.OpportunityApi
import cw15.OpportunityApiSoap
import cw15.OpportunityListItem
import grails.test.mixin.*
import grails.test.mixin.support.*
import javax.xml.ws.WebServiceException
import org.junit.*

/**
 * See the API for {@link grails.test.mixin.support.GrailsUnitTestMixin} for usage instructions
 */
@TestMixin(GrailsUnitTestMixin)
class ExportOpportunitiesTests {

    void setUp() {
        // Setup logic here
    }

    void tearDown() {
        // Tear down logic here
    }

    void testSomething() {
        
		String url = "https://staging.connectwisedev.com" + "/v4_6_release/apis/1.5/OpportunityApi.asmx?wsdl";
		
		try
		{
			OpportunityApi soapApi = new OpportunityApi(new URL(url));
			OpportunityApiSoap oppSoap = soapApi.getOpportunityApiSoap();
			
			ApiCredentials credentials = new ApiCredentials() 
			credentials.setCompanyId("valent_f");
			credentials.setIntegratorLoginId("int1");
			credentials.setIntegratorPassword("int1");
	
			StringBuffer conditionStr = new StringBuffer(), stageStr = new StringBuffer(), statusStr = new StringBuffer()
			
			conditionStr.append( "Closed = false")
			//int totalPage = 10
			int pageSize = 10;
			int count = 0;
			boolean reachLastUpdate = false, isOlder = false
			List<OpportunityListItem> opportunityItemList = new ArrayList<OpportunityListItem>();
			
			Map opportunityMap = new HashMap()
			ArrayOfOpportunityListItem opportunities = oppSoap.findOpportunities(credentials, conditionStr.toString(), "",pageSize, count);
			
			//while(opportunities != null && opportunities.getOpportunityListItem().size() > 0 && isOlder == false)
			//{
				//OpportunityListItem opLItem_1 = opportunities.getOpportunityListItem().last()
							
				for(OpportunityListItem opLItem : opportunities.getOpportunityListItem())
				{
					Opportunity opp = oppSoap.getOpportunity(credentials, opLItem.getId());
					
					if(opp != null)
					{
						opportunityItemList.add(opLItem)
						ArrayOfOpportunityItem oppItems = opp.getOpportunityItems()
						
						println opLItem?.opportunityName
						opportunityMap.put(opLItem.getId(), opp)
					}
								
				}
				
				println opportunityMap
				/*if(!isOlder)
				{
					count+=pageSize;
					opportunities = oppSoap.findOpportunities(credentials, conditionStr.toString(), "LastUpdate DESC", pageSize, count);
					//totalPage--
				}*/
			//}
	
		}
		catch(WebServiceException wse)
		{
			println wse.getMessage()
			println "Can not create Opportunity API Service due to wrong site URL."
		}
    }
}
