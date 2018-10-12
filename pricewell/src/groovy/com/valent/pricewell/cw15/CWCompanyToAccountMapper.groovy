package com.valent.pricewell.cw15

import javax.xml.datatype.XMLGregorianCalendar
import ma.glasnost.orika.CustomConverter
import ma.glasnost.orika.MapperFactory;
import ma.glasnost.orika.impl.ConfigurableMapper;
import ma.glasnost.orika.impl.DefaultMapperFactory;
import ma.glasnost.orika.metadata.Type;

class CWCompanyToAccountMapper extends ConfigurableMapper {

	@Override
	public void configure(MapperFactory mapperFactory)
	{
		mapperFactory.getConverterFactory().registerConverter(
			new CustomConverter<XMLGregorianCalendar, Date>()
			{
				public Date convert(XMLGregorianCalendar source, Type<? extends Date> destinationClass )
				{
					return source.toGregorianCalendar().getTime();
				}
			});
		new AccountMapperHelper().configure(mapperFactory);
	}

	@Override
	public void configureFactoryBuilder(DefaultMapperFactory.Builder builder) {
		// configure properties of the factory, if needed

	}
}
