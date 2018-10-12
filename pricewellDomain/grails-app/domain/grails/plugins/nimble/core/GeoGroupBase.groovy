package grails.plugins.nimble.core

class GeoGroupBase extends com.valent.pricewell.GeoGroup{

    static constraints = {
    }
	
	String toString()
	{
		return this.name
	}
}
