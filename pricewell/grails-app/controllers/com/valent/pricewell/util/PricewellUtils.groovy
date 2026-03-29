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

		// Always initialise the roles map first by referencing RoleEnum.values().
		// The roles map (populated by RoleEnum enum constructors) is empty until
		// RoleEnum is class-loaded. On first call after a server start the JVM may
		// not have loaded RoleEnum yet, so roles.get() would return null even for a
		// valid role.  Calling values() here guarantees the map is populated before
		// any lookup.
		RoleEnum[] s = RoleEnum.values()

		if(user?.lastLoginRole != null && user?.lastLoginRole != "" && user?.lastLoginRole != "NULL")
		{
			RoleEnum cached = roles.get(user?.lastLoginRole)
			if (cached != null) return cached
			// roles map was empty (RoleEnum not yet initialised when lastLoginRole was
			// stored) — fall through to the role-check loop below.
		}

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