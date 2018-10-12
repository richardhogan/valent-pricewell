package com.valent.pricewell.util

import com.valent.pricewell.User
import org.apache.shiro.SecurityUtils;

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
		User user = User.get(new Long(SecurityUtils.subject.principal))
		
		if(user?.lastLoginRole != null && user?.lastLoginRole != "" && user?.lastLoginRole != "NULL")
		{
			return roles.get(user?.lastLoginRole);
		}
		
		RoleEnum[] s = RoleEnum.values() ;

		for(RoleEnum role : s ){
			if( SecurityUtils.getSubject().hasRole(role.value()) ){
				return roles.get(role.value());
			}
		}
		return null;
	}
	
	public static RoleEnum getFirstMatchingRoleEnum(String[] s){
		for(String role : s ){
			if( SecurityUtils.subject.hasRole(role) ){
				return roles.get(role);
			}
		}
		return null;
	}
}