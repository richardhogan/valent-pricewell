package com.valent.pricewell

import java.util.List;

class Product {
	
		static searchable = true
		private static int ROUNDING_MODE = BigDecimal.ROUND_HALF_EVEN;
		private static int DECIMALS = 2;
		
		String product_id
		String unitOfSale 
		Date dateCreated;
		Date datePublished;
		Date dateModified;
		String productName;
		String productType;
		
		static constraints = {
			product_id(nullable: true)
			unitOfSale(nullable: true)
			dateCreated(nullable: true)
			datePublished(nullable: true)
			dateModified(nullable: true)
			productName(nullable: false)
			productType(nullable: true)
		}
		
	  static hasMany = [productPricelists: ProductPricelist, serviceProductItems: ServiceProductItem]
	  
	  List listUndefinedGeos()
	  {
		  List unDefinedList = []
		  
		  for(Geo geo: Geo.list())
		  {
			  boolean defined = false
			  for(ProductPricelist ppl: this?.productPricelists)
			  {
				  if(ppl.geo.id == geo.id)
				  {
					  defined = true
					  break
				  }
			  }
			  
			  if(!defined)
			  {
				  unDefinedList.add(geo)
			  }
		  }
		  
		  return unDefinedList
	  }
		
}