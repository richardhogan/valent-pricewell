package com.valent.pricewell

class ObjectType {

	String name
	Type type
	String description
	int sequenceOrder
	
	public static final enum Type {SERVICE_DELIVERABLE, SERVICE_ACTIVITY, SERVICE_UNIT_OF_SALE, SOW_MILESTONE, DELIVERABLE_PHASE}
	
    static constraints = {
		name(nullable: false, maxSize: 2048000)
		type(nullable: false)
		description(nullable: true, maxSize: 2048000)
		sequenceOrder(nullable: true)
    }
	
	static mapping = {
		name type: "text"
		description type: "text"
	}
	
	public static List listObjectTypes(Type type)
	{
		List typeList = new ArrayList()
		
		for(ObjectType ot: ObjectType.list())
		{
			if(ot.type == type)
			{
				typeList.add(ot)
			}
		}
		
		return typeList
	}
	
	public static List getDeliverableTypes()
	{
		List types = listObjectTypes(Type.SERVICE_DELIVERABLE)
		List typeNameList = new ArrayList()
		
		for(ObjectType ot: types.sort{it.name})
		{
			typeNameList.add(ot.name)
		}
		
		return typeNameList
	}
	
	public static List getActivityTypes()
	{
		List types = listObjectTypes(Type.SERVICE_ACTIVITY)
		List typeNameList = new ArrayList()
		
		for(ObjectType ot: types.sort{it.name})
		{
			typeNameList.add(ot.name)
		}
		
		return typeNameList
	}
	
	public static List getUnitOfSaleTypes()
	{
		List types = listObjectTypes(Type.SERVICE_UNIT_OF_SALE)
		List typeNameList = new ArrayList()
		
		for(ObjectType ot: types.sort{it.name})
		{
			typeNameList.add(ot.name)
		}
		
		return typeNameList
	}
	
	public static List getMilestoneTypes()
	{
		List types = listObjectTypes(Type.SOW_MILESTONE)
		List typeNameList = new ArrayList()
		
		for(ObjectType ot: types)
		{
			typeNameList.add(ot.name)
		}
		
		return typeNameList
	}
	
	public static List<String> getDeliverablePhases()
	{
		List phases = listObjectTypes(Type.DELIVERABLE_PHASE)
		List deliverablePhaseList = new ArrayList()
		
		for(ObjectType ot: phases.sort{it.sequenceOrder})
		{
			deliverablePhaseList.add(ot.name)
		}
		
		return deliverablePhaseList
	}
	
	public static List<ObjectType> getDeliverablePhaseObjects()
	{
		List phases = listObjectTypes(Type.DELIVERABLE_PHASE)
		List deliverablePhaseList = new ArrayList()
		
		for(ObjectType ot: phases.sort{it.sequenceOrder})
		{
			deliverablePhaseList.add(ot)
		}
		deliverablePhaseList.add(null)
		
		return deliverablePhaseList
	}
	
	String toString()
	{
		return name.toString()
	}
}
