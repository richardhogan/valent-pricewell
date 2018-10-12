package com.valent.pricewell.templater
/**
 * This is basic class, but created separately to call out its name and type.
 * Created by snehal.mistry on 8/24/15.
 */
class SowJsonConverterPluginWithNoGroupingOfServices extends BasicJsonConverterPlugin {

    int version = 1;
    protected def globalPropsExcludesList = ["sow_introduction", "services"]

    @Override
    String getName() {
        return "BasicServices-NoGrouping"
    }

    @Override
    String getType() {
        return "Basic services with no grouping"
    }

    @Override
    int getVersion(){
        return version;
    }

}
