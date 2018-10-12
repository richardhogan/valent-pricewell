package com.valent.pricewell


import grails.converters.JSON
import grails.test.GrailsMock
import grails.test.mixin.TestFor
import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONObject
import org.junit.*


/**
 * Created by snehal.mistry on 8/23/15.
 */
@TestFor(Quotation)
class JsonConversionSpecification {

    def convertServiceProfile() {
        mockFor(Quotation.class)
        mockFor(Service.class)
        GrailsMock mProfile = mockFor(ServiceProfile.class, true)
        mProfile.metaClass.listServiceProfileMetaphors = {type -> []}
        //mProfile.demand.listServiceProfileMetaphors {true}
        //mProfile.demand.listServiceProfileMetaphors(1..100){ type -> return [] }

        mockFor(ServiceQuotation.class)
        //mockFor(ServiceProfileMetaphors.class)

        Service service1 = new Service(serviceName: "s1")
        ServiceProfile profile1 = new ServiceProfile(service: service1)

        Service service2 = new Service(serviceName: "s2")
        ServiceProfile profile2 = new ServiceProfile(service: service2)

        ServiceQuotation sq1 = new ServiceQuotation(service: service1, profile: profile1)

        ServiceQuotation sq2 = new ServiceQuotation(service: service2, profile: profile2)

        Quotation quotation = new Quotation(serviceQuotations: [sq1, sq2])

        println convert(quotation).toString()

    }

    protected JSONObject convert(Quotation quotation){
        JSONArray servicesJson = new JSONArray()
        quotation.serviceQuotations.each {
            servicesJson.add(convert(it))
        }
        JSONObject sowObject = new JSONObject()
                .put("services", servicesJson)
        return sowObject
    }

    protected JSONObject convert(ServiceQuotation serviceQuotation){
        JSONObject serviceJson = new JSONObject()
        serviceJson.put("name", serviceQuotation.service.serviceName)
        serviceJson.put("description", serviceQuotation.service.description)
        JSONArray actsJson = new JSONArray()
        JSONArray delsJson = new JSONArray()
        serviceQuotation.profile.customerDeliverables.each { deliverable ->
            deliverable.serviceActivities.each { sa ->
                actsJson.add(convert(sa))
            }
            delsJson.add(new JSONObject().put("name", deliverable.name)
                    .put("name", deliverable.description))
        }

        serviceJson.put("activities", actsJson)
        serviceJson.put("deliverables", delsJson)


        //ServiceProfileMetaphors
        def metaphorsMap = ["prerequisites": serviceQuotation.profile.listServiceProfileMetaphors(ServiceProfileMetaphors.MetaphorsType.PRE_REQUISITE),
                            "outofscopes":  serviceQuotation.profile.listServiceProfileMetaphors(ServiceProfileMetaphors.MetaphorsType.OUT_OF_SCOPE)]
        metaphorsMap.each{ k, l ->
            JSONArray mJson = new JSONArray()
            l.each { v -> mJson.add(new JSONObject().put("name",
                    ((ServiceProfileMetaphors)v).definitionString.value)) }
            serviceJson.put(k, mJson)
        }

        return serviceJson
    }


    protected JSONObject convert(ServiceActivity sa){
        JSONObject activityJson =
                new JSONObject()
                        .put("name", sa.name)
                        .put("description", sa.description)
                        .put("category", sa.category)
        if(sa.activityTasks) {
            JSONArray tasksJson = new JSONArray()
            sa.activityTasks.each { task ->
                tasksJson.add(new JSONObject().put("name", task.task))
            }
            activityJson.put("tasks", tasksJson)
        }
        return activityJson;
    }
}
