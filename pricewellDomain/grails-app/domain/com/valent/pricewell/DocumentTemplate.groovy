package com.valent.pricewell

class DocumentTemplate {
	
	String documentName
	UploadFile documentFile
	Boolean isDefault = false
	
    static constraints = {
		documentName(nullable:true)
		documentFile(nullable: true)
		isDefault(nullable: true)
		territory(nullable: true)
    }
	
	static belongsTo = [territory: Geo]
	
	static mappedBy = [territory: "sowDocumentTemplates"]
}
