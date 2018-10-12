package grails.plugins.nimble.core

class GeoBase extends com.valent.pricewell.Geo{

    static constraints = {
    }
	
	String toString()
	{
		return this.name
	}
}
