
package com.valent.pricewell

class User extends grails.plugins.nimble.core.UserBase {

	// Extend UserBase with your custom values here

	String toString()
	{
		return this.profile?.fullName;
	}
}
