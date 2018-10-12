package com.valent.pricewell

import java.util.Map;

class DefaultEntityOperationService {

    static transactional = true

    def serviceMethod() {

    }
	
	public boolean isEntityTypeNameAvailable(Map params)
	{
		def objectTypeInstance = ObjectType.findByNameAndType(params.name, params.type)
		
		if(objectTypeInstance)
		{
			return true
		}
		return false
	}
}
