package com.valent.pricewell

import grails.converters.JSON

import org.apache.shiro.SecurityUtils
import org.codehaus.groovy.grails.commons.ConfigurationHolder
import grails.plugins.nimble.core.*
import com.ibm.icu.text.SimpleDateFormat
import com.valent.pricewell.ObjectType.Type;
import com.valent.pricewell.ServiceProfile.ServiceProfileType
import com.valent.pricewell.ServiceProfileMetaphors.MetaphorsType
import org.springframework.web.multipart.MultipartFile;
import java.text.SimpleDateFormat
import java.util.List;
//import org.hibernate.collection.PersistentSet;

class ExtraUnitController {
	
	def saveExtraUnit = {
		println 'In saveExtraUnit Method'
		//println 'id' + params.serviceProfileId
		ExtraUnit extraUnitInstance = new ExtraUnit(params);
		extraUnitInstance.unitOfSale = params.additionalUnitOfSale
		
		def serviceProfileId = params.serviceProfileId
		
		ServiceProfile serviceProfile = ServiceProfile.get(params.serviceProfileId)
		extraUnitInstance.serviceProfile=serviceProfile
		extraUnitInstance.save(flush:true);
		
		def extraUnitInstanceList = ExtraUnit.findAll("From ExtraUnit eu Where eu.serviceProfile.id = :serviceProfileId",[serviceProfileId: serviceProfile?.id]);
		
		def lastRecordShortName = extraUnitInstanceList.last().getAt('shortName');
		println 'lastRecordShortName is: ' + lastRecordShortName
		 
		
		render extraUnitInstanceList as JSON
	}
	
	def list = {
		ExtraUnit extraUnitInstance = new ExtraUnit(params);
		def serviceProfileId = params.serviceProfileId
		Long test;
		test = serviceProfileId.toLong();
		println'Test is: ' + test 
		def extraUnitInstanceList = ExtraUnit.findAll("From ExtraUnit eu Where eu.serviceProfileId = :serviceProfileId",[serviceProfileId:test]);
		[extraUnitInstanceList:extraUnitInstanceList]
	}
	def getAll = {
		ExtraUnit extraUnitInstance = new ExtraUnit(params);
		def serviceProfileId = params.serviceProfileId
		Long test = extraUnitInstance.serviceProfileId.id
		test = serviceProfileId.toLong();
		println'Test is: ' + test 
		def extraUnitInstanceList = ExtraUnit.find("From ExtraUnit eu Where eu.serviceProfileId.id = :serviceProfileId",[serviceProfileId:test]);
		println 'Test List is: ' + extraUnitInstanceList
		return extraUnitInstanceList
	}
			

	def deleteExtraUnit = {
		println"In delete method";
		def extraUnitInstance = ExtraUnit.get(params.id);
		
		extraUnitInstance.delete(flush: true);
		render "success"
	}
	
	def loadExtraUnit = {
		println 'In loadExtraUnit Method'
		ExtraUnit extraUnitInstance = new ExtraUnit(params);
		def serviceProfileId = params.serviceId
		
		println "Sp is : " + serviceProfileId
			
		Long test;
		
		test = serviceProfileId.toLong();
		def serviceProfileInstance=ServiceProfile.get(test);
		def serviceProfile=new ServiceProfile();
		def serviceExtraUnitOfSaleList = ServiceProfile.executeQuery("SELECT DISTINCT UPPER(sp.unitOfSale) from ServiceProfile sp WHERE sp.unitOfSale != null ORDER BY sp.unitOfSale ASC" )
		def extraUnitInstanceList = ExtraUnit.findAll("From ExtraUnit eu Where eu.serviceProfile.id = :serviceProfileId",[serviceProfileId:test]);
		println 'Test List is: ' + extraUnitInstanceList
		//System.out.println("Last value is : " + extraUnitInstanceList.last())
		//def lastRecordShortName = extraUnitInstanceList.last().getAt('shortName');
		//def countervalue=lastRecordShortName.split(" ")
		
		//println 'lastRecordShortName is: ' + countervalue[2]   
		      
		render (template:"../service/stage/createExtraUnit",model:[serviceExtraUnitOfSaleList: serviceExtraUnitOfSaleList, extraUnitInstanceList:extraUnitInstanceList,serviceProfileInstance:serviceProfileInstance])
	}
}
