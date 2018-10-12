package com.valent.pricewell

class FieldMappingService {

    def serviceMethod() {

    }
	
	public boolean isMappingAvailable(String field, FieldMapping.MappingType type)
	{
		List fieldMappingList = FieldMapping.findAll("FROM FieldMapping fm WHERE fm.type = :type AND fm.name = :name", [type: type, name: field])
		if(fieldMappingList?.size() > 0)
			return true
		return false
	}
	
	public String getFieldMappingValue(String field, FieldMapping.MappingType type)
	{
		List fieldMappingList = FieldMapping.findAll("FROM FieldMapping fm WHERE fm.type = :type AND fm.name = :name", [type: type, name: field])
		String territoryValue = ""
		
		for(FieldMapping fm : fieldMappingList)
		{
			territoryValue = fm.value
			break
		}
		
		return territoryValue
	}
	
	public void addFieldMapping(String name, String value, FieldMapping.MappingType type)
	{
		FieldMapping fieldMappingInstance = new FieldMapping()//name: name, value: value, type: type).save()
		fieldMappingInstance.name = name
		fieldMappingInstance.value = value
		fieldMappingInstance.type = type
		fieldMappingInstance.save()
		
	}
}
