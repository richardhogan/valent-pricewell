/*
 *  Nimble, an extensive application base for Grails
 *  Copyright (C) 2010 Bradley Beddoes
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package grails.plugins.nimble.core
import com.valent.pricewell.Geo
import com.valent.pricewell.GeoGroup
import java.util.List;

/**
 * Provides methods for interacting with Nimble roles.
 *
 * @author Bradley Beddoes
 */
class RoleService {

  boolean transactional = true

  /**
   * Creates a new role.
   *
   * @param name Name to assign to group
   * @param description Description to assign to group
   * @param protect Boolean indicating if this is a protected group (True disables modification in UI)
   *
   * @throws RuntimeException When internal state requires transaction rollback
   */
  def createRole(String name, String description, boolean protect, String code) {
    def role = new Role()
    role.authority = name
    role.description = description
    role.protect = protect
	role.code = code

    if(!role.validate()) {
      log.debug("Supplied values for new role are invalid")
      role.errors.each {
        log.debug it
      }
      return role
    }

    def savedRole = role.save()
    if (savedRole) {
      log.info("Created role [$role.id]$role.description")
      return savedRole
    }

    log.error("Error creating new group")
    role.errors.each {
      log.error it
    }

    throw new RuntimeException("Error creating new group, object persistance failed")
  }

  /**
   * Deletes an exisiting Role.
   *
   * @pre Passed role object must have been validated to ensure
   * that hibernate does not auto persist the objects to the repository prior to service invocation
   *
   * @param role The role instance to be deleted
   *
   * @throws RuntimeException When internal state requires transaction rollback
   */
  def deleteRole(Role role) {

    // Remove all users from this role
    def userRoles = com.valent.pricewell.UserRole.findAllByRole(role)
    userRoles.each { ur ->
      com.valent.pricewell.UserRole.remove(ur.user, role, true)
    }

    role.delete()
    log.info("Deleted role [$role.id]$role.description")
  }

  /**
   * Updates and existing role.
   *
   * @pre Passed role object must have been validated to ensure
   * that hibernate does not auto persist the objects to the repository prior to service invocation
   *
   * @param role The role to be updated.
   *
   * @throws RuntimeException When internal state requires transaction rollback
   */
  def updateRole(Role role) {

    def updatedRole = role.save()
    if (updatedRole) {
      log.info("Updated role [$role.id]$role.description")
      return updatedRole
    }

    log.error("Error updating role [$role.id]$role.description")
    role.errors.each {err ->
      log.error err
    }

    throw new RuntimeException("Error updating role [$role.id]$role.description")
  }

  /**
   * Assigns a role to a user.
   *
   * @pre Passed role and user object must have been validated to ensure
   * that hibernate does not auto persist the objects to the repository prior to service invocation
   *
   * @param user The user whole the referenced role should be assigned to
   * @param role The role to be assigned
   *
   * @throws RuntimeException When internal state requires transaction rollback
   */
  def addMember(UserBase user, Role role, Object params) {
  //def addMember(UserBase user, Role role, Object territoryID, List territories) {
    role.addToUsers(user)
    user.addToRoles(role)
	
	
	if(params.territoryID != null)
	{
		user.territory = Geo.get(params.territoryID)
	}
	
	if(params.territories != null)
	{
		def territories = params.territories.toList()
		for(Object i in territories)
		{
			if(i != ",")
			{
				user.addToTerritories(Geo.get(i))
			}
			
		}
	}
	
	if(role.code == "GENERAL MANAGER")
	{
		def geoGroup =  GeoGroup.get(params?.geoGroupId)
		if(geoGroup)
		{
			user.geoGroup = geoGroup
		}
		
	}
	
    def savedRole = role.save()
    if (!savedRole) {
      log.error("Error updating role [$role.id]$role.description to add user [$user.id]$user.username")

      role.errors.each {
        log.error(it)
      }

      throw new RuntimeException("Unable to persist role [$role.id]$role.description when adding user [$user.id]$user.username")
    }

    def savedUser = user.save()
    if (!savedUser) 
	{
	  log.error("Error updating user [$user.id]$user.username when adding role [$role.id]$role.description")

      user.errors.each {
        log.error(it)
      }

      throw new RuntimeException("Error updating user [$user.id]$user.username when adding role [$role.id]$role.description")
    }

    log.info("Successfully added role [$role.id]$role.description to user [$user.id]$user.username")
  }

  /**
   * Removes a role from a user.
   * 
   * @pre Passed role and user object must have been validated to ensure
   * that hibernate does not auto persist the objects to the repository prior to service invocation
   *
   * @param user The user whole the referenced role should be removed from
   * @param role The role to be assigned
   * 
   * @throws RuntimeException When internal state requires transaction rollback
   */
  
  
  def deleteMember(UserBase user, Role role) 
  {
	   
	    role.removeFromUsers(user)
	    user.removeFromRoles(role)
	
	    def savedRole = role.save()
	    if (!savedRole) {
	      log.error("Error updating role [$role.id]$role.description to add user [$user.id]$user.username")
	
	      role.errors.each {
	        log.error(it)
	      }
	
	     throw new RuntimeException("Unable to persist role [$role.id]$role.description when removing user [$user.id]$user.username")
	    }
	
	    def savedUser = user.save()
	    if (!savedUser) {
	      log.error("Error updating user [$user.id]$user.username when adding role [$role.id]$role.description")
	      user.errors.each {
	        log.error(it)
	      }
	
	      throw new RuntimeException("Error updating user [$user.id]$user.username when removing role [$role.id]$role.description")
	    }
	
	    log.info("Successfully removed role [$role.id]$role.description to user [$user.id]$user.username")
  }

  /**
   * Adds a role to a group.
   *
   * @pre Passed role and group object must have been validated to ensure
   * that hibernate does not auto persist the objects to the repository prior to service invocation
   *
   * @param group The group whole the referenced role should be assigned to
   * @param role The role to be assigned
   *
   * @throws RuntimeException When internal state requires transaction rollback
   */
  def addGroupMember(Group group, Role role) {
    role.addToGroups(group)
    group.addToRoles(role)

    def savedRole = role.save()
    if (!savedRole) {
      log.error("Error updating role [$role.id]$role.description to add group [$group.id]$group.name")
      role.errors.each {
        log.error(it)
      }

      throw new RuntimeException("Unable to persist role [$role.id]$role.description when adding group [$group.id]$group.name")
    }

    def savedGroup = group.save()
    if (!savedGroup) {
      log.error("Error updating group [$group.id]$group.name when adding role [$role.id]$role.description")
      group.errors.each {
        println it
      }

     throw new RuntimeException("Error updating group [$group.id]$group.name when adding role [$role.id]$role.description")
    }

    log.info("Successfully added role [$role.id]$role.description to group [$group.id]$group.name")
  }

  /**
   * Removes a role from a group.
   * 
   * @pre Passed role and user object must have been validated to ensure
   * that hibernate does not auto persist the objects to the repository prior to service invocation
   *
   * @param group The gruop whole the referenced role should be removed from
   * @param role The role to be assigned
   *
   * @throws RuntimeException When internal state requires transaction rollback
   */
  def deleteGroupMember(Group group, Role role) {
    role.removeFromGroups(group)
    group.removeFromRoles(role)

    def savedRole = role.save()
    if (!savedRole) {
      log.error("Error updating role [$role.id]$role.description to remove group [$group.id]$group.name")
      role.errors.each {
        log.error(it)
      }

      throw new RuntimeException("Unable to persist role [$role.id]$role.description when removing group [$group.id]$group.name")
    }

    def savedGroup = group.save()
    if (!savedGroup) {
       log.error("Error updating group [$group.id]$group.name when removing role [$role.id]$role.description")
      group.errors.each {
        log.error(it)
      }

      throw new RuntimeException("Error updating group [$group.id]$group.name when removing role [$role.id]$role.description")
    }

    log.info("Successfully removed role [$role.id]$role.description to group [$group.id]$group.name")
  }
  
  public List findUsersByRole(Object roleName)
  {
	  List tmpList = new ArrayList()
	  for(UserBase user in com.valent.pricewell.UserRole.findAllByRole(Role.findByCode(roleName))*.user)
	  {
		  tmpList.add(UserBase.get(user.id))
	  }
	  
	  return tmpList
  }
  
  public List searchMembersNotInRole(Role role)
  {
	  def userList = UserBase.findAll("FROM UserBase ub WHERE ub.username!='admin' AND ub.username!='user' ");
	  List list1 = new ArrayList()
	  def flag = 0;
	  for(Object user in userList)
	  {
		  if(!com.valent.pricewell.UserRole.findByUserAndRole(user, role))
		  {
			  
			  
				  for(Object r in com.valent.pricewell.UserRole.findAllByUser(user)*.role)
				  {
				  	  if(role.code == "SALES PRESIDENT" || role.code == "SALES MANAGER" || role.code == "SALES PERSON")
				  	  {
						  if(r.code == "SALES PRESIDENT" || r.code == "SALES MANAGER" || r.code == "SALES PERSON")
						  {
							  flag = 1;
						  }
					  }
					  else
					  {
				  		  if(r.code == role.code)
				  		  {
				  		  	flag = 1
				  		  }
					  }
				  }
				  if(flag==0)
				  {
					  list1.add(user);
				  }
				  flag=0;
			  
		  }  
	  }
	  return list1
  }
}
