package com.valent.pricewell

class LogoImage {
	byte[] image
	
    static constraints = {
		image(nullable: true, maxSize: 2048000)
    }
}
