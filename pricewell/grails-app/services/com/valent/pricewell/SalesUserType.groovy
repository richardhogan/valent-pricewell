package com.valent.pricewell
// MIGRATION (Nimble→Spring Security): removed Apache Shiro imports; using PricewellSecurity helper instead
import com.valent.pricewell.PricewellSecurity
import java.util.List;

public enum SalesUserType {
	SalesUser,
	SalesManager,
	GeneralManager,
	SalesPresident,
	Administrator;
	
	public static getUserType(User user)
	{
		if(checkUserRoleCode(user, RoleId.ADMINISTRATOR.code))
		{
			return SalesUserType.Administrator
		}
		else if(checkUserRoleCode(user, RoleId.SALES_PRESIDENT.code))
		{
			return SalesUserType.SalesPresident
		}
		else if(checkUserRoleCode(user, RoleId.GENERAL_MANAGER.code))
		{
			return SalesUserType.GeneralManager
		}
		else if(checkUserRoleCode(user, RoleId.SALES_MANAGER.code))
		{
			return SalesUserType.SalesManager
		}
		else if(checkUserRoleCode(user, RoleId.SALES_PERSON.code))//PricewellSecurity.hasRole("SALES PERSON"))
		{
			return SalesUserType.SalesUser
		}
	}
	
	public static boolean checkUserRoleCode(User user, String roleCode)
	{
		List roleCodes = getUserRolesCode(user)
		if(roleCodes.contains(roleCode))
			return true
		return false
	}
	
	public static List getUserRolesCode(User user)
	{
		List rolesCode = new ArrayList()
		for(Role role : UserRole.findAllByUser(user)*.role)
		{
			rolesCode.add(role.code)
		}
		return rolesCode
	}
	
}
