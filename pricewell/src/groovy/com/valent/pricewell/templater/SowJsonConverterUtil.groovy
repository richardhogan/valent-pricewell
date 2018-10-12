package com.valent.pricewell.templater

import com.valent.pricewell.*
import org.codehaus.groovy.grails.web.json.JSONObject
import org.reflections.Reflections

/**
 * This is warper util provides Quotation to Json conversion utility
 * BasicJsonConverterPlugin implements most of the abstraction of json conversion
 * But for each customer, we might need separate SowJsonConverterPlugin which will
 * only override a few conversion methods from BasicJsonConverterPlugin
 *
 * For example, BasicJsonConverterPlugin only shows activities by deliverables, but
 * if customer wants to group activities by categories then we need to create new plugin
 * which would only override serviceActivity conversion part.
 *
 * Created by snehal.mistry on 8/24/15.
 */
class SowJsonConverterUtil {

    private static String DEFAULT_CONVERTER = "DeliverablesGroupingByPhasePlugin"
    private static def jsonConverters = [:]
    //TODO: Should we update plugins periodically? So we don't need to restart
    // when we want to drop in new plugin
    static {
        Reflections reflections = new Reflections("com.valent.pricewell");
        Set<Class<? extends SowJsonConverterPlugin>> implementingTypes =
                reflections.getSubTypesOf(SowJsonConverterPlugin.class);

        println implementingTypes
        for(Class<SowJsonConverterPlugin> cls: implementingTypes){
            if(cls.equals(BasicJsonConverterPlugin.class))
                continue

            SowJsonConverterPlugin converter = cls.newInstance()
            if(jsonConverters.containsKey(converter.getName())){
                SowJsonConverterPlugin converter2 = jsonConverters.get(converter.getName()).newInstance()
                if(converter.getVersion() > converter2.getVersion()){
                    jsonConverters.put(converter.getName(), cls)
                    println "New version of JSON Converter with name:${converter.getName()} and version: ${converter.getVersion()} loaded"
                }
            } else {
                jsonConverters.put(converter.getName(), cls)
                println "JSON Converter is loaded with name:${converter.getName()} and version: ${converter.getVersion()}"
            }
        }
    }


    public static JSONObject convertSOWToJson(Quotation q){//, Object groovyPageRenderer){
        //return convertSOWToJson(q, groovyPageRenderer, DEFAULT_CONVERTER)
		return convertSOWToJson(q, DEFAULT_CONVERTER)
    }

    public static JSONObject convertSOWToJsonString(Quotation q){
        return convertSOWToJsonString(q, DEFAULT_CONVERTER)
    }

    //public static JSONObject convertSOWToJson(Quotation q, Object groovyPageRenderer, String tempateName){
	public static JSONObject convertSOWToJson(Quotation q, String tempateName){
        if(!jsonConverters.get(tempateName)){
            throw new IllegalArgumentException("Invalid template name of json SOW converter: " + tempateName)
        }
        Class<SowJsonConverterPlugin> cls = jsonConverters.get(tempateName)
        SowJsonConverterPlugin converter = cls.newInstance()
        //return converter.convertToJson(q, groovyPageRenderer)
		return converter.convertToJson(q)
    }

    public static String convertSOWToJsonString(Quotation q, String tempateName){
        if(!jsonConverters.get(tempateName)){
            throw new IllegalArgumentException("Invalid template name of json SOW converter: " + tempateName)
        }
        Class<SowJsonConverterPlugin> cls = jsonConverters.get(tempateName)
        SowJsonConverterPlugin converter = cls.newInstance()
        return converter.convertToJsonString(q)
    }

}
