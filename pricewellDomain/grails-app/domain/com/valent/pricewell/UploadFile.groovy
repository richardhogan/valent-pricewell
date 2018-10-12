package com.valent.pricewell

class UploadFile {

	String name
	String filePath
    static constraints = {
		name(nullable: false)
		filePath(nullable: false)
    }
}
