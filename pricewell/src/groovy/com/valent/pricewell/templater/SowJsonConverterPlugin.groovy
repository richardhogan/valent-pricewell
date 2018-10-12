package com.valent.pricewell.templater

import com.valent.pricewell.*
import org.codehaus.groovy.grails.web.json.JSONObject

/**
 * Created by snehal.mistry on 8/24/15.
 */
interface SowJsonConverterPlugin {
    String getName()
    String getType()
    int getVersion()
    JSONObject convertToJson(Quotation quotation)//, Object groovyPageRenderer)
    String convertToJsonString(Quotation quotation)
}