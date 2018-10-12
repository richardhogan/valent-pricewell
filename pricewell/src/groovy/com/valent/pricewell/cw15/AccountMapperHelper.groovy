package com.valent.pricewell.cw15
import com.valent.pricewell.*;
import cw15.*;
import ma.glasnost.orika.MapperFactory;

class AccountMapperHelper {

	public void configure(MapperFactory mapperFactory)
	{
		mapperFactory.registerClassMap(mapperFactory.classMap(CompanyFindResult.class, Account.class)
				//.field("companyID", "externalId")
				.field("companyName", "accountName")
				.field("website", "website")
				.field("phoneNumber", "phone")
				.field("type", "type")
				.toClassMap());

	}
}
