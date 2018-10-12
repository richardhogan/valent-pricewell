package com.valent.pricewell

import java.util.List;
import java.util.Map;

import com.sun.org.apache.bcel.internal.generic.NEW;

class PriceCalculationService {

     static transactional = true
	private static int ROUNDING_MODE = BigDecimal.ROUND_HALF_EVEN;
	private static int DECIMALS = 2;
	
	private static BigDecimal DAY_HRS_STANDARD = new BigDecimal("8")

   
	Map deriveServicePrice(ServiceProfile serviceProfile, Geo geo)
	{
		Map rolesMap = serviceProfile.listRolesRequiredTable()
		int baseUnits = serviceProfile.baseUnits
		int additionalUnits = 1
		
		BigDecimal basePrice = new BigDecimal(0)
		BigDecimal additionalPrice = new BigDecimal(0)
		BigDecimal totalHours = new BigDecimal(0)
		for(String key in rolesMap.keySet())
		{
			Map roleMap = rolesMap.get(key)
			DeliveryRole deliveryRole = DeliveryRole.get(roleMap["id"])
			RelationDeliveryGeo rateCard =	RelationDeliveryGeo.findByGeoAndDeliveryRole(geo, deliveryRole)
			
			if(!rateCard)
			{
				//TODO: Throw an error, returns back
			}
			
			BigDecimal baseHrs = roleMap["totalFlat"]
			BigDecimal extraHrs = roleMap["totalExtra"]
			
			totalHours = totalHours + baseHrs + extraHrs*additionalUnits
			BigDecimal ratePerHour = rateCard.ratePerDay.divide(DAY_HRS_STANDARD, ROUNDING_MODE)
			//basePrice += (ratePerDay/8) * baseHrs
			basePrice =  basePrice + (baseHrs * ratePerHour)
			//additionalPrice += (rateCard.ratePerDay/8) * (extraHrs * additionalUnits)
			additionalPrice = additionalPrice + (ratePerHour * extraHrs * additionalUnits)
			
		}
		
		//println "total hrs : "+totalHours
		basePrice = basePrice.setScale(DECIMALS, ROUNDING_MODE)
		additionalPrice = additionalPrice.setScale(DECIMALS, ROUNDING_MODE)
		
		return ["basePrice": basePrice, "additionalPrice": additionalPrice]
		
	}
	
	Map deriveServiceHours(ServiceProfile serviceProfile, Geo geo, BigDecimal totalUnits)
	{
		Map rolesMap = serviceProfile.listRolesRequiredTable()
		int baseUnits = serviceProfile.baseUnits
		int additionalUnits = totalUnits - baseUnits
		
		BigDecimal basePrice = new BigDecimal(0)
		BigDecimal additionalPrice = new BigDecimal(0)
		BigDecimal totalHours = new BigDecimal(0)
		for(String key in rolesMap.keySet())
		{
			Map roleMap = rolesMap.get(key)
			DeliveryRole deliveryRole = DeliveryRole.get(roleMap["id"])
			RelationDeliveryGeo rateCard =	RelationDeliveryGeo.findByGeoAndDeliveryRole(geo, deliveryRole)
			
			if(!rateCard)
			{
				//TODO: Throw an error, returns back
			}
			
			BigDecimal baseHrs = roleMap["totalFlat"]
			BigDecimal extraHrs = roleMap["totalExtra"]
			
			totalHours = totalHours + baseHrs + extraHrs*additionalUnits
			BigDecimal ratePerHour = rateCard.ratePerDay.divide(DAY_HRS_STANDARD, ROUNDING_MODE)
			//basePrice += (ratePerDay/8) * baseHrs
			basePrice =  basePrice + (baseHrs * ratePerHour)
			//additionalPrice += (rateCard.ratePerDay/8) * (extraHrs * additionalUnits)
			additionalPrice = additionalPrice + (ratePerHour * extraHrs * additionalUnits)
			
		}
		
		println "total hrs : "+totalHours
		basePrice = basePrice.setScale(DECIMALS, ROUNDING_MODE)
		additionalPrice = additionalPrice.setScale(DECIMALS, ROUNDING_MODE)
		
		return ["basePrice": basePrice, "additionalPrice": additionalPrice]
		
	}
	
	Map calculteServiceMargin(ServiceProfile serviceProfile, Geo geo, int totalUnits)
	{
		Map rolesMap = serviceProfile.listRolesRequiredTable()
		
		Map marginMap = [:]
		marginMap["roles"] = [:]
		
		int baseUnits = serviceProfile.baseUnits
		int additionalUnits = (totalUnits - baseUnits)
		additionalUnits = (additionalUnits >= 0? additionalUnits: 0)
		
		BigDecimal totalRate = new BigDecimal(0)
		BigDecimal totalCost = new BigDecimal(0)
		
		for(String key in rolesMap.keySet())
		{
			Map roleMap = rolesMap.get(key)
			DeliveryRole deliveryRole = DeliveryRole.get(roleMap["id"])
			RelationDeliveryGeo rateCard =	RelationDeliveryGeo.findByGeoAndDeliveryRole(geo, deliveryRole)
			
			if(!rateCard)
			{
				throw new IllegalArgumentException("No ratecard defined for Geo: ${geo} and Delivery Role: ${deliveryRole}")
				//Throw an error, returns back
				return null
			}
			
			BigDecimal ratePerDay = rateCard.ratePerDay
			BigDecimal costPerDay = rateCard.costPerDay
			BigDecimal baseHrs = roleMap["totalFlat"]
			BigDecimal extraHrs = roleMap["totalExtra"]
			BigDecimal ratePerHr = ratePerDay.divide(DAY_HRS_STANDARD, ROUNDING_MODE)
			BigDecimal costPerHr = costPerDay.divide(DAY_HRS_STANDARD, ROUNDING_MODE)
			
			roleMap["baseRate"] =   baseHrs.multiply(ratePerHr).setScale(DECIMALS, ROUNDING_MODE) //(ratePerDay/8) * baseHrs
			roleMap["additionalRate"] =  extraHrs.multiply(additionalUnits).multiply(ratePerHr).setScale(DECIMALS, ROUNDING_MODE)   //(ratePerDay/8) * (extraHrs * additionalUnits)
			roleMap["totalRate"] = roleMap["baseRate"] + roleMap["additionalRate"]  
			roleMap["baseCost"] =  baseHrs.multiply(costPerHr).setScale(DECIMALS, ROUNDING_MODE) //(costPerDay/8) * baseHrs
			roleMap["additionalCost"] =  extraHrs.multiply(additionalUnits).multiply(costPerHr).setScale(DECIMALS, ROUNDING_MODE) //(costPerDay/8) * (extraHrs * additionalUnits)
			roleMap["totalCost"] = roleMap["baseCost"].add(roleMap["additionalCost"]) //roleMap["baseCost"] + roleMap["additionalCost"]
			roleMap["uplift"] = roleMap["totalRate"].subtract(roleMap["totalCost"]) //roleMap["totalRate"] - roleMap["totalCost"]
			roleMap["margin"] = roleMap["uplift"].divide(roleMap["totalRate"], ROUNDING_MODE).multiply(100).setScale(DECIMALS, ROUNDING_MODE)   //(roleMap["uplift"] / roleMap["totalRate"]) * 100   
					
			totalRate += roleMap["totalRate"]
			totalCost += roleMap["totalCost"]
			marginMap["roles"][key] = roleMap
		}
		
		BigDecimal premiumPercent = (serviceProfile?.premiumPercent?:0)
		
		BigDecimal totalUplift = totalRate - totalCost
		BigDecimal totalMargin = totalUplift.divide(totalRate, ROUNDING_MODE).multiply(100) //((totalRate - totalCost) / totalRate) * 100
		BigDecimal finalPrice = totalRate + totalRate.multiply(premiumPercent).divide(100, ROUNDING_MODE)
		
		marginMap["totalRate"] = totalRate.setScale(DECIMALS, ROUNDING_MODE)
		marginMap["totalCost"] = totalCost.setScale(DECIMALS, ROUNDING_MODE)
		marginMap["totalUplift"] = totalUplift.setScale(DECIMALS, ROUNDING_MODE)
		
		//marginMap["totalMargin"] = ((totalRate - totalCost) / totalRate) * 100
		marginMap["totalMargin"] = totalMargin.setScale(DECIMALS, ROUNDING_MODE)
		marginMap["premiumPercent"] =  premiumPercent
		marginMap["currency"] =  geo.currency
		//marginMap["finalPrice"] = totalRate + ((totalRate * premiumPercent)/100)
		marginMap["finalPrice"] = finalPrice.setScale(DECIMALS, ROUNDING_MODE)
		
		return marginMap
	}
}
