package com.valent.pricewell.cw15

import com.valent.pricewell.*
import cw.*;
import ma.glasnost.orika.MapperFactory;


class ContactMapperHelper {

	public void configure(MapperFactory mapperFactory)
	{
		mapperFactory.registerClassMap(mapperFactory.classMap(ContactFindResult.class, Contact.class)
				.field("firstName", "firstname")
				.field("lastName", "lastname")
				.field("phone", "phone")
				.field("email", "email")
				.field("lastUpdate", "dateModified")
				.field("lastUpdate", "dateCreated")
				.toClassMap());

	}
}
