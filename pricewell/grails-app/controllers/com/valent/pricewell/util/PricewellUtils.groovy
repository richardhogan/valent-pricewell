package com.valent.pricewell.util
// MIGRATION (Nimble→Spring Security): removed Apache Shiro imports; using PricewellSecurity helper instead
import com.valent.pricewell.PricewellSecurity

import com.valent.pricewell.User

class PricewellUtils {
	private static Map<String, RoleEnum> roles = new HashMap<String, RoleEnum>();
	
	static void addRole(String role, RoleEnum roleEnum){
		roles.put(role, roleEnum);
	}
	
	public static RoleEnum getRoleEnum(def s){
		return roles.get(s);
	}
	public static void Println(def tag,def s)
	{
		boolean print=true
		if(print==false)
			println tag+":"+s
	}
	public static void Println(def s)
	{
		boolean print=true
		if(print==false)
			println s
	}
	public static RoleEnum getFirstMatchingRoleEnum()
	{
		User user = PricewellSecurity.currentUser  // was: User.get(new Long(SecurityUtils.subject.principal))
		
		if(user?.lastLoginRole != null && user?.lastLoginRole != "" && user?.lastLoginRole != "NULL")
		{
			return roles.get(user?.lastLoginRole);
		}
		
		RoleEnum[] s = RoleEnum.values() ;

		for(RoleEnum role : s ){
			if( PricewellSecurity.hasRole(role.value()) ){
				return roles.get(role.value());
			}
		}
		return null;
	}
	
	public static RoleEnum getFirstMatchingRoleEnum(String[] s){
		for(String role : s ){
			if( PricewellSecurity.hasRole(role) ){
				return roles.get(role);
			}
		}
		return null;
	}
}