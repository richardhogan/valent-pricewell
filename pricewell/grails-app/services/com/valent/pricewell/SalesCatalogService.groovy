package com.valent.pricewell

import java.util.Date
import java.util.Set;
import java.util.TreeMap

import java.util.List;
import org.apache.shiro.SecurityUtils
import grails.converters.JSON;
import grails.plugins.nimble.core.*
import javax.management.relation.RoleInfo;
import grails.plugins.nimble.InstanceGenerator
import com.valent.pricewell.Staging.AuthorizedScope;
import org.apache.shiro.crypto.hash.Sha256Hash
import org.codehaus.groovy.grails.commons.GrailsApplication

class SalesCatalogService {

    static transactional = true

	def serviceCatalogService
	def sendMailService, userService
    def serviceMethod() {

    }
	
	public List filterOpportunityAccountList(List opportunityList)
	{
		Set accountList = new HashSet()
		for(Opportunity opportunity : opportunityList)
		{
			accountList.add(opportunity?.account)
		}
		return accountList?.toList()
	}
	
	public boolean isClass(String className, GrailsApplication grailsApplication)
	{
		boolean exist = false;
		
		for (Class grailsClass in grailsApplication.allClasses)
		{
			if(grailsClass.name == className)
			{
				exist = true;
				//println grailsClass.name
			}
		}
		
		return exist;
	}
	
	Set addToSet(List quotaList, Set quotaSet){
		for(Quota quota : quotaList)
		{
			quotaSet.add(quota)
		}
		return quotaSet
	}
	
	public List getUserQuota(User user)
	{
		def quotaInstanceList = new ArrayList(), tmpList = new ArrayList()
		Set quotaSet = new HashSet()
		
		if(SecurityUtils.subject.hasRole('SYSTEM ADMINISTRATOR') || SecurityUtils.subject.hasRole('SALES PRESIDENT'))
		{
			tmpList = Quota.list()
		}
		else if(SecurityUtils.subject.hasRole('GENERAL MANAGER'))
		{
			def quotaList = Quota.findAll("FROM Quota quota WHERE quota.createdBy.id=:uid OR quota.person.id=:uid", [uid: user.id])
			quotaSet = addToSet(quotaList, quotaSet)
			if(user?.geoGroup != null)
			{
				for(Geo territory : user?.geoGroup?.geos)
				{
					if(territory?.salesManager != null)
					{
						quotaList = Quota.findAll("FROM Quota quota WHERE quota.createdBy.id=:uid OR quota.person.id=:uid", [uid: territory?.salesManager?.id])
						quotaSet = addToSet(quotaList, quotaSet)
					}
				}
			}
			tmpList = quotaSet.toList()
		}
		else if(SecurityUtils.subject.hasRole('SALES MANAGER'))
		{
			tmpList = Quota.findAll("FROM Quota quota WHERE quota.createdBy.id=:uid OR quota.person.id=:uid", [uid: user.id])
		}
		return tmpList
	}
	
	public boolean checkListContainsPrimaryTerritory(List territoryList, Geo primaryTerritory)
	{
		boolean check = false
		for(Geo territory : territoryList)
		{
			if(territory?.id == primaryTerritory?.id)
			{
				check = true
			}
		}
		return check
	}
	
	public boolean checkUserRoleCode(User user, String roleCode)
	{
		List roleCodes = getUserRolesCode(user)
		if(roleCodes.contains(roleCode))
			return true
		return false
	}
	
	public List getUserRolesCode(User user)
	{
		List rolesCode = new ArrayList()
		for(Role role : user.roles)
		{
			rolesCode.add(role.code)
		}
		return rolesCode
	}
	
	public List findUserTerritories(User user)
	{
		if(user == null)
		{
			user = User.get(new Long(SecurityUtils.subject.principal))
		}
		
		Set territoryList = new HashSet()
		List rolesCode = getUserRolesCode(user)
		//if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("SALES PRESIDENT") || SecurityUtils.subject.hasRole("PORTFOLIO MANAGER"))
		if(rolesCode.contains(RoleId.ADMINISTRATOR.code) || rolesCode.contains(RoleId.SALES_PRESIDENT.code) || rolesCode.contains(RoleId.PORTFOLIO_MANAGER.code))
		{
			if(Geo.list().size() > 0)
				territoryList.addAll(Geo.list())
		}
		//else if(SecurityUtils.subject.hasRole("GENERAL MANAGER"))
		else if(rolesCode.contains(RoleId.GENERAL_MANAGER.code))
		{
			if(user?.geoGroup != null && user?.geoGroup?.geos.size() > 0)
				territoryList.addAll(user?.geoGroup?.geos)
		}
		//else if(SecurityUtils.subject.hasRole("SALES MANAGER"))
		else if(rolesCode.contains(RoleId.SALES_MANAGER.code))
		{
			if(user?.territories.size() > 0)
				territoryList.addAll(user?.territories)
		}
		//else if(SecurityUtils.subject.hasRole("SALES PERSON"))
		else if(rolesCode.contains(RoleId.SALES_PERSON.code))
		{
			if(user?.territory != null)
				territoryList.addAll(user?.territory)
		}
		return territoryList.toList()
	}
	
	public List findSalesUsers()
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))
		Set territoryList = new HashSet()
		def salesUsers = []
		salesUsers.addAll(serviceCatalogService.findUsersByRole("SALES PRESIDENT"))
		
		if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("SALES PRESIDENT"))
		{
			
			salesUsers.addAll(serviceCatalogService.findUsersByRole("SALES PERSON"))
			salesUsers.addAll(serviceCatalogService.findUsersByRole("SALES MANAGER"))
			salesUsers.addAll(serviceCatalogService.findUsersByRole("GENERAL MANAGER"))
			//return salesUsers
		}
		else if(SecurityUtils.subject.hasRole("GENERAL MANAGER"))
		{
			salesUsers.add(user)
			if(user?.geoGroup != null && user?.geoGroup?.geos.size() > 0)
			{
				for(Geo territory : user?.geoGroup?.geos)
				{
					if(territory?.salesManager != null)
						{salesUsers.add(territory?.salesManager)}
					if(territory?.salesPersons != null && territory?.salesPersons.size() > 0)
						{salesUsers.addAll(territory?.salesPersons)}
				}	
			}
		}
		else if(SecurityUtils.subject.hasRole("SALES MANAGER"))
		{
			salesUsers.add(user)
			if(user?.territories.size() > 0)
			{
				for(Geo territory : user?.territories)
				{
					if(territory?.salesPersons.size() > 0 && territory?.salesPersons != null)
						{salesUsers.addAll(territory?.salesPersons)}
					if(territory?.geoGroup?.generalManagers != null && territory?.geoGroup?.generalManagers.size()>0)
						{salesUsers.addAll(territory?.geoGroup?.generalManagers)}
				}
			}
		}
		else if(SecurityUtils.subject.hasRole("SALES PERSON"))
		{
			salesUsers.add(user)
			if(user?.territory != null)
			{
				if(user?.territory?.geoGroup?.generalManagers != null && user?.territory?.geoGroup?.generalManagers.size() > 0)
					{salesUsers.addAll(user?.territory?.geoGroup?.generalManagers)}
				if(user?.territory?.salesManager != null)
					{salesUsers.add(user?.territory?.salesManager)}
			}
		}
		return userService.filterUserList(salesUsers)
	}
	
	public Map getMapOfAssignedToSalesUsers()
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))
		Set sPresidents = new HashSet(), gManagers = new HashSet(), sManagers = new HashSet(), sPersons = new HashSet()
		Set territoryList = new HashSet()
		def salesUsers = []
		
		sPresidents.addAll(serviceCatalogService.findUsersByRole("SALES PRESIDENT"))
		
		if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("SALES PRESIDENT"))
		{
			
			sPersons.addAll(serviceCatalogService.findUsersByRole("SALES PERSON"))
			sManagers.addAll(serviceCatalogService.findUsersByRole("SALES MANAGER"))
			gManagers.addAll(serviceCatalogService.findUsersByRole("GENERAL MANAGER"))
			//return salesUsers
		}
		else if(SecurityUtils.subject.hasRole("GENERAL MANAGER"))
		{
			gManagers.add(user)
			if(user?.geoGroup != null && user?.geoGroup?.geos.size() > 0)
			{
				for(Geo territory : user?.geoGroup?.geos)
				{
					if(territory?.salesManager != null)
						{sManagers.add(territory?.salesManager)}
					if(territory?.salesPersons != null && territory?.salesPersons.size() > 0)
						{sPersons.addAll(territory?.salesPersons)}
				}
			}
		}
		else if(SecurityUtils.subject.hasRole("SALES MANAGER"))
		{
			sManagers.add(user)
			if(user?.territories.size() > 0)
			{
				for(Geo territory : user?.territories)
				{
					if(territory?.salesPersons.size() > 0 && territory?.salesPersons != null)
						{sPersons.addAll(territory?.salesPersons)}
					if(territory?.geoGroup?.generalManagers != null && territory?.geoGroup?.generalManagers.size()>0)
						{gManagers.addAll(territory?.geoGroup?.generalManagers)}
				}
			}
		}
		else if(SecurityUtils.subject.hasRole("SALES PERSON"))
		{
			sPersons.add(user)
			if(user?.territory != null)
			{
				if(user?.territory?.geoGroup?.generalManagers != null && user?.territory?.geoGroup?.generalManagers.size() > 0)
					{gManagers.addAll(user?.territory?.geoGroup?.generalManagers)}
				if(user?.territory?.salesManager != null)
					{sManagers.add(user?.territory?.salesManager)}
			}
		}
		Map dataMap = [:]
		dataMap.put('sPresidents', userService.filterUserList(sPresidents.toList()))
		dataMap.put('gManagers', userService.filterUserList(gManagers.toList()))
		dataMap.put('sManagers', userService.filterUserList(sManagers.toList()))
		dataMap.put('sPersons', userService.filterUserList(sPersons.toList()))
		
		return dataMap
	}
	
	public Map getAssignedToSalesUserForQuota()
	{
		Map salesUsersMap = getMapOfAssignedToSalesUsers()
		salesUsersMap['gManagers'] = filterSalesUsersForTerritory(RoleId.GENERAL_MANAGER.code, salesUsersMap['gManagers'])
		salesUsersMap['sManagers'] = filterSalesUsersForTerritory(RoleId.SALES_MANAGER.code, salesUsersMap['sManagers'])
		salesUsersMap['sPersons'] = filterSalesUsersForTerritory(RoleId.SALES_PERSON.code, salesUsersMap['sPersons'])
		
		return salesUsersMap
	}
	
	public List filterSalesUsersForTerritory(String roleCode, List userList)
	{
		List filteredList = new ArrayList()
		if(roleCode == RoleId.GENERAL_MANAGER.code)
		{
			for(User user : userList)
			{
				if(user?.geoGroup?.geos?.size() > 0 || (user?.primaryTerritory != null && user?.primaryTerritory != ""))
				{
					filteredList.add(user)
				}
			}
		}
		else if(roleCode == RoleId.SALES_MANAGER.code)
		{
			for(User user : userList)
			{
				if(user?.territories?.size() > 0 || (user?.primaryTerritory != null && user?.primaryTerritory != ""))
				{
					filteredList.add(user)
				}
			}
		}
		else if(roleCode == RoleId.SALES_PERSON.code)
		{
			for(User user : userList)
			{
				if((user?.territory != null && user?.territory != "") || (user?.primaryTerritory != null && user?.primaryTerritory != ""))
				{
					filteredList.add(user)
				}
			}
		} 
		
		return userService.filterUserList(filteredList)
	}
	
	public List findUnassignedSalesPersonList()
	{
		def salesPersonList = new ArrayList()
		def tmpList = new ArrayList()
		tmpList = serviceCatalogService.findUsersByRole("SALES PERSON")
		for(User person in tmpList)
		{
			if(person?.territory == null)
			{
				salesPersonList.add(person)
			}
			
		}
		return userService.filterUserList(salesPersonList)
	}
	
	public List findUnassignedGeneralManagerList()
	{
		def generalManagerList = new ArrayList()
		def tmpList = new ArrayList()
		tmpList = serviceCatalogService.findUsersByRole("GENERAL MANAGER")
		for(User manager in tmpList)
		{
			if(manager?.geoGroup == null)
			{
				generalManagerList.add(manager)
			}
		}
		return userService.filterUserList(generalManagerList)
	}
	
	public List findUnassignedGeosForGeneralManager()
	{
		def geoList = new ArrayList()
		for(GeoGroup geo : GeoGroup.list())
		{
			if(geo.generalManagers.size() == 0)
			{
				geoList.add(geo)
			}
		}
		return geoList
	}
	
	public Map findUnassignedGeosWithTerritoriesForGeneralManager()
	{
		List geoList = new ArrayList()
		List territoryList = new ArrayList()
		for(GeoGroup geoGroup : GeoGroup.list())
		{
			if(geoGroup?.generalManagers?.size() == 0)
			{
				geoList.add(geoGroup)
				for(Geo territory : geoGroup?.geos)
				{
					territoryList.add(territory)
				}
			}
		}
		
		println "geos : "+geoList
		println "territories : "+territoryList
		return [geoGroupList: geoList, territoriesList: territoryList]
	}
	
	public Map findUnassignedTerritoriesForSalesManager(GeoGroup geoGroup)
	{
		Set geoList = new HashSet()
		def territoryList = new ArrayList()
		if(SecurityUtils.subject.hasRole("GENERAL MANAGER"))
		{
			def user = User.get(new Long(SecurityUtils.subject.principal))
			geoList.add(user?.geoGroup)
			for(Geo territory : user?.geoGroup?.geos)
			{
				if(territory?.salesManager == null)
				{
					territoryList.add(territory)
				}
			}
		}
		else
		{
			if(geoGroup == null)
			{
				for(Geo territory : Geo.list())
				{
					if(territory?.salesManager == null)
					{
						territoryList.add(territory)
						if(territory?.geoGroup != null)
						{
							geoList.add(territory.geoGroup)
						}
					}
				}
			}
			else
			{
				geoList.add(geoGroup)
				for(Geo territory : geoGroup?.geos)
				{
					if(territory?.salesManager == null)
					{
						territoryList.add(territory)
					}
				}
			}
		}
		
		return ['geoGroupList': geoList.toList(), 'territoriesList': territoryList]
	}
	
	public boolean isListContainsTerritory(List territoryList, Geo territory)
	{
		boolean hasTerritory = false
		for(Geo gTerritory : territoryList)
		{
			if(gTerritory?.id == territory?.id)
			{
				hasTerritory = true
			}
		}
		
		return hasTerritory
	}
	
	public List findTerritoriesForSalesPerson(GeoGroup geoGroup)
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def territoryList = new ArrayList()
		if(SecurityUtils.subject.hasRole("GENERAL MANAGER"))
		{
			for(Geo territory : user?.geoGroup?.geos)
			{
				territoryList.add(territory)
			}
		}
		else if(SecurityUtils.subject.hasRole("SALES MANAGER"))
		{
			for(Geo territory : user?.territories)
			{
				territoryList.add(territory)
			}
		}
		else
		{
			if(geoGroup == null)
			{
				for(Geo territory : Geo.list())
				{
					territoryList.add(territory)
				}
			}
			else
			{
				for(Geo territory : geoGroup?.geos)
				{
					territoryList.add(territory)
				}
			}
		}
		
		return territoryList
	}
	
	public List createQuaterList()
	{
		def quaterList = new ArrayList()
		def date = new Date()
		def month = date.getMonth()
		def year = date.getYear() + 1900
		println year
		int d = (month+1)/3
		int q = d
		
		for(int i=0; i<5; i++)
		{
			if(q>4)
			{
				q=1
				year++
			}
			
			quaterList.add("Q"+q+" - "+year)
			q++
		}
		
		/*def deci = d - (int)d
		
		if(deci > 0.80)
		{
			d = (int)d + 1
		}
		else
		{
			d = (int)d
		}*/
		//println d
		
		return quaterList
	}
	
	public User getSalesUserOfGeo(Geo geo)
	{
		if(geo?.salesManager?.id != null)
			return geo?.salesManager
		else if(geo?.geoGroup?.generalManagers?.size() > 0)
		{
			for(UserBase user : geo?.geoGroup?.generalManagers)
			{
				return user
				break
			}
		}
		else
		{
			def presidentUsers = serviceCatalogService.findUsersByRole("SALES PRESIDENT")
			for(UserBase user : presidentUsers)
			{
				return user
				break
			}
		}
		
		User user = User.findByUsername("admin")
		return user
	}
	
}
