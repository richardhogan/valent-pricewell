package com.valent.pricewell.cw15

import ma.glasnost.orika.CustomConverter
import ma.glasnost.orika.MapperFactory;

import com.valent.pricewell.*;
import cw15.OpportunityListItem;
import ma.glasnost.orika.metadata.Type
class OpportunityMapperHelper {

	private static def stageNameMapping = ["Prospect": "prospecting","Commitment": "negotiationReview", "Qualification": "qualification", "Evaluation": "needAnalysis", "Quote": "proposalPriceQuote" ]
	
		private static String defaultStagingName = "prospecting"
	
		private static long defaultStagingId = Staging.find("from Staging s where s.name=:name and entity=:entity",
		[name: defaultStagingName,  entity: Staging.StagingObjectType.OPPORTUNITY])?.id;
	
		
		public void configure(MapperFactory mapperFactory)
		{
			mapperFactory.getConverterFactory().registerConverter("stageNameToStagingConverter",
					new CustomConverter<String, Staging>(){
						public Staging convert(String source, Type<? extends Staging> destinationClass ) {
							return convertStagingNameToStage(source);
						}
					})
	
			//TODO: territory to geoId
			//Status: open/closed to ?
			//summary -> description
			//Serivce revenue -> Forcast
			//Cosct and Matgin is deriveed, so may be useful for cross-checking
			//Company to account
			//POssibly Inside Rep. to our sales rep (assigned To)
			//Company to account and their Contact Names -> contact and map conatct for opportunity
			//probability -> probability
			mapperFactory.registerClassMap(mapperFactory.classMap(OpportunityListItem.class, Opportunity.class)
					//.field("id", "externalId")
					.field("opportunityName", "name")
					.field("lastUpdate", "dateModified")
					.field("lastUpdate", "dateCreated")
					.field("expectedCloseDate", "closeDate")
					.field("closeProbability", "probability")
					.fieldMap("stageName", "stagingStatus").converter("stageNameToStagingConverter").add()
					.toClassMap());
	
		}
	
		private Staging convertStagingNameToStage(String stageName)
		{
			String correctedStageName = "";
			int index = stageName.indexOf(".");
			
			if(index >= 0){
				correctedStageName = stageName.substring(index+1);
			} else{
				correctedStageName = stageName;
			}
			
			if(!stageNameMapping.containsKey(correctedStageName)){
				println "Error: staging name " + correctedStageName + " is not found so taking it default staging"
				return Staging.get(defaultStagingId);
			}
			
			String mapStageName = stageNameMapping.get(correctedStageName)
			Staging staging = Staging.find("from Staging s where s.name=:name and entity=:entity",
					[name: mapStageName,  entity: Staging.StagingObjectType.OPPORTUNITY]);
				
			if(staging == null){
				println "Error: staging name " + correctedStageName + " is not found so taking it default staging"
				return Staging.get(defaultStagingId);
			}
			return staging
		}
	
	
}
