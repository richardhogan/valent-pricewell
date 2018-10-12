package com.valent.pricewell.templater

import com.valent.pricewell.*
import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONObject

import com.valent.pricewell.templater.BasicJsonConverterPlugin.ResolvableJsonObject

import java.math.RoundingMode

/**
 * This will group all deliverables in by phases across all the services.
 * It will also group activities by categories as well.
 * Created by snehal.mistry on 8/31/15.
 */
class DeliverablesGroupingByPhasePlugin extends BasicJsonConverterPlugin {
    int version = 1;

    @Override
    String getName() {
        return "DeliverablesGroupingByPhasePlugin"
    }

    @Override
    String getType() {
        return "Show services by grouping deliverables by phases."
    }

    @Override
    int getVersion() {
        return this.version;
    }
	
	public void convertDeliverablesPhaseGroupDataToJson(Quotation quotation, JSONObject quotationJson)
	{
		//fillGlobalProps(quotation)
		def idMapper = [:]
		int index = 0
		JSONArray phasesJson = new JSONArray()
		ObjectType.getDeliverablePhaseObjects().each { ot ->
			
			if(ot?.name != null && ot?.name != "")
			{
				phasesJson.add(new ResolvableJsonObject()
					.put("phase", ot?.name)
					.put("phaseDescription", eval(ot.description?:""))//.replaceAll("(\\t|\\r?\\n)+", " "))//.replaceAll("\\", type)))
					//.put("phaseDescription", StringEscapeUtils.escapeJavaScript(eval(ot.description?:"")))//.replaceAll("(\\t|\\r?\\n)+", " "))//.replaceAll("\\", type)))
					.put("sequenceOrder", ot.sequenceOrder.toString())
					.put("deliverables", new JSONArray())
					.put("activities", new JSONArray())
					.put("roles", new JSONObject())
					.getJsonObject()
				)
				
				idMapper.put(ot.name, index)
				index = index + 1
			}	
			
		}

		quotation.getActiveServiceQuotationList().sort{it.sequenceOrder}.each {
			it.profile.customerDeliverables.each { deliverable ->
				if (deliverable.phase != null && idMapper.containsKey(deliverable.phase)){
					final int idx = idMapper.get(deliverable.phase)
					
					////if(phasesJson.size() > idx)
					//{
						final JSONObject phaseTmp = phasesJson.get(idx), rolesTmp = phaseTmp.get("roles")
						final JSONArray delsTmp = phaseTmp.get("deliverables"), actsTmp = phaseTmp.get("activities")
						
						deliverable.serviceActivities.each { sa ->
							sa.rolesEstimatedTime.each { role ->
								int flatUnits = it.totalUnits - it.profile.baseUnits
								BigDecimal initialHrs = new BigDecimal(0)
								if(rolesTmp.containsKey(role.role.name))
									initialHrs = rolesTmp.get(role.role.name)
								
								rolesTmp.put(role.role.name, initialHrs + role.estimatedTimeInHoursFlat * flatUnits + role.estimatedTimeInHoursPerBaseUnits)
							}
							actsTmp.add(convert(sa))
						}
						
						delsTmp.add(new ResolvableJsonObject().put("name", deliverable.name)
								.put("description", eval(deliverable.newDescription?.value ?: ""))
								.put("sequenceOrder", deliverable.sequenceOrder.toString())
								.getJsonObject()
						)
					//}
					
				} else {
					println "WARN: delivery phase is not specified for delivery:" + deliverable.name + " and service:" + deliverable.serviceProfile
				}
			}
		}

		JSONArray rolesByPhasesJson = new JSONArray()
		int ii = 1
		phasesJson.each { JSONObject obj ->
			
			obj.put("categories", groupActivitiesByCategory(obj.get("activities")))
						obj.put("phase", capitalizeInitialLetter(obj.get("phase")))
			if(obj.get("roles").size() > 0)
			{
				rolesByPhasesJson.add(new JSONObject()
					.put("phase", capitalizeInitialLetter(obj.get("phase")))
					.put("index", ii)
					.put("roles", convertRoleJson(obj.get("roles"))))
			}
			
			ii = ii + 1
			
		}

		quotationJson.put("phases", phasesJson)
		quotationJson.put("rolesByPhase", rolesByPhasesJson)
		
		//This is workaround if we want to loop over phases twice in two different
		//subsections in word template then word template doesn't work properly with
		//one copy
			quotationJson.put("phases2", phasesJson)
		
		//return quotationJson
	}

    @Override
    JSONObject convertToJson(Quotation quotation)//, Object groovyPageRenderer)
	{		
		fillGlobalProps(quotation)
        JSONObject quotationJson = super.convertToJson(quotation)//, groovyPageRenderer)
		convertDeliverablesPhaseGroupDataToJson(quotation, quotationJson)
		
        return quotationJson
    }

    private JSONArray convertRoleJson(JSONObject rolesJson){
        final JSONArray arr = new JSONArray()
        rolesJson.keySet().each {roleName ->
            BigDecimal hrs = rolesJson.get(roleName)
            //Convert to days
            BigDecimal days = Math.ceil((hrs/8).setScale(1, BigDecimal.ROUND_HALF_EVEN))
            if(hrs > 0) {
                arr.add(new JSONObject().put("role", roleName).put("days", days).put("hrs", hrs))
            }

        }
        Collections.sort(arr, new Comparator() {
            @Override
            int compare(Object o1, Object o2) {
                return o2.get("hrs").compareTo( o2.get("hrs"))
            }
        })
        return arr
    }

    private JSONArray groupActivitiesByCategory(JSONArray activitiesJson) {
        //It is necessary to preserve sequence of category
		int categorySequenceOrder = 1
        def sq = []
        def storeMap = [:]
		
        activitiesJson.each { JSONObject act ->
            String category = act.get("category")
            if (!storeMap.containsKey(category)) {
                sq.add(category)
                storeMap.put(category, new JSONArray())
            }
			int categoryActivitiesSize = ((JSONArray) storeMap.get(category)).size() + 1
			act.put("sequenceOrder", categoryActivitiesSize.toString())
			act.remove("category")
            ((JSONArray) storeMap.get(category)).add(act)
        }
		
        JSONArray categoriesJSON = new JSONArray()
        sq.each { String str ->
            categoriesJSON.add(new JSONObject().put("category", str)
					.put("sequenceOrder", categorySequenceOrder.toString())
                    .put("activities", storeMap.get(str)))
			categorySequenceOrder++
        }
        return categoriesJSON

    }

}
