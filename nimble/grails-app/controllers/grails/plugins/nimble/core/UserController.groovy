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
 import org.apache.shiro.SecurityUtils;

import com.valent.pricewell.Geo
import com.valent.pricewell.GeoGroup
import com.valent.pricewell.Notification;
import com.valent.pricewell.Portfolio
import com.valent.pricewell.ServiceProfile
import com.valent.pricewell.User
import grails.converters.JSON
import grails.plugins.nimble.InstanceGenerator
 
 /**
  * Manages Nimble user accounts
  *
  * @author Bradley Beddoes
  */
 class UserController {
 
   static Map allowedMethods = [	save: 'POST', update: 'POST', enable: 'POST', disable: 'POST', enableapi: 'POST', disableapi: 'POST',
								   savepassword: 'POST', validusername: 'POST', searchgroups: 'POST', grantgroup: 'POST', removegroup: 'POST',
								  createpermission: 'POST', removepermisson: 'POST', searchroles: 'POST', grantrole: 'POST', removerole: 'POST']
 
   def userService
   def groupService
   def roleService
   def permissionService
 
   def index = {
	 redirect action: list, params: params
   }
 
   def list = {
	 if (!params.max) {
 //      params.max = 10
	 }
	 log.debug("Listing users")
	 if(!params?.sort){
		 params["sort"] = "username"
	 }
	 
	 def usersList = userService.filterUserList(UserBase.list().sort {it.profile.fullName})//UserBase.findAll("FROM UserBase user WHERE user.username!='superadmin' AND user.username!='user' ORDER BY profile.fullName ASC")//UserBase.list(params)
	 [users: usersList]
   }
 
   def show = {
	 def user = UserBase.get(params.id)
	 if (!user) {
	   log.warn("User identified by id '$params.id' was not located")
	   flash.type = "error"
	   flash.message = message(code: 'nimble.user.nonexistant', args: [params.id])
	   redirect action: list
	 }
	 else {
		 log.debug("Showing user [$user.id]$user.username")
		 List salesManagerList = findUsersByRole("SALES MANAGER")
		 List salesPresidentList = findUsersByRole("SALES PRESIDENT")
		 [user: user,salesManagerList: salesManagerList, salesPresidentList: salesPresidentList]
	 }
   }
 
   def edit = {
	 def user = UserBase.get(params.id)
	 if (!user) {
	   log.warn("User identified by id '$params.id' was not located")
 
	   flash.type = "error"
	   flash.message = message(code: 'nimble.user.nonexistant', args: [params.id])
	   redirect action: list
	 }
	 else {
		 log.debug("Editing user [$user.id]$user.username")
		 [user: user]
	 }
   }
 
   def update = {
	 def map = [:]
	 def user = UserBase.get(params.id)
	 if (!user) {
	   log.warn("User identified by id '$params.id' was not located")
	   //flash.type = "error"
	   //flash.message = message(code: 'nimble.user.nonexistant', args: [params.id])
	   //redirect action: edit, id: params.id
	   map['res'] = "fail"
	 }
	 else {
	   def fields = grailsApplication.config.nimble.fields.admin.user
	   def profileFields = grailsApplication.config.nimble.fields.enduser.profile
	   user.properties[fields] = params
	   user.profile.properties[profileFields] = params
	   user.profile.phone = params.phone
	   user.profile.country = params.phoneCountry
	   user.profile.lastUpdated = new Date()
	   user.lastUpdated = new Date()
	  /* if(params?.primaryGeo?.id != null)
	   {
		   def geo = Geo.get(params?.primaryGeo?.id)
		   user.primaryGeo = geo
 
	   }
	   
	   for(Object geoid in params?.geos?.id)
	   {
		   def geo = Geo.get(geoid)
		   user.addToGeos(geo)
	   }*/
	   
	   if (!user.validate()) {
			 log.debug("Updated details for user [$user.id]$user.username are invalid")
			 //render view: 'edit', model: [user: user]
			 map['res'] = "fail"
	   }
	   else {
			   def updatedUser = userService.updateUser(user)
			 log.info("Successfully updated details for user [$user.id]$user.username")
			 //flash.type = "success"
			 //flash.message = message(code: 'nimble.user.update.success', args: [user.username])
			 //redirect action: show, id: updatedUser.id
			 map['res'] = "success"
		 }
	 }
	 render map['res']
   }
 
   def create = {
	 def user = InstanceGenerator.user()
	 user.profile = InstanceGenerator.profile()
	 log.debug("Starting user creation process")
	 [user: user]
   }
 
   def save = 
   {
		 def map = [:]
		 
		 UserBase user = new UserBase(new ProfileBase())//InstanceGenerator.user()
		 def userFields = grailsApplication.config.nimble.fields.enduser.user
		 user.properties[userFields] = params
		 user.lastUpdated = new Date()
		 user.dateCreated = new Date()
		 user.enabled = true
		 user.external = false
		 
		 def profileFields = grailsApplication.config.nimble.fields.enduser.profile
		 user.profile = user.profile//InstanceGenerator.profile()
		 user.profile.properties[profileFields] = params
		 user.profile.phone = params.phone
		 user.profile.country = params.phoneCountry
		 user.profile.lastUpdated = new Date()
		 user.profile.dateCreated = new Date()
		 
		 /*if(params?.primaryGeo?.id != null)
		 {
			 def geo = Geo.get(params?.primaryGeo?.id)
			 user.primaryGeo = geo
	 
		 }
		 
		 for(Object geoid in params?.geos?.id)
		 {
			 def geo = Geo.get(geoid)
			 user.addToGeos(geo)
		 }*/
	 
		 def savedUser = userService.createUser(user)
		 if (savedUser.hasErrors()) {
		   log.info("Failed to save new user")
		   //render view: 'create', model: [roleList: Role.list(), user: user]
		   map['res'] = "fail"
		 }
		 else {
			 
			 log.info("Successfully created new user [$savedUser.id]$savedUser.username")
			 //redirect action: show, id: user.id*/
			 map["res"] = "success"
			 map['id'] = user.id
		 }
		 render map['res']
   }
 
   def changepassword = {
	 def user = UserBase.get(params.id)
	 if (!user) {
	   log.warn("User identified by id '$params.id' was not located")
	   flash.type = "error"
	   flash.message = message(code: 'nimble.user.nonexistant', args: [params.id])
	   redirect action: list
	 }
	 else {
		 if (user.external) {
		   log.warn("Attempt to change password on user [$user.id]$user.username that is externally managed denied")
		   flash.type = "error"
		   flash.message = message(code: 'nimble.user.password.external.nochange', args: [user.username])
		   redirect action: show, id: user.id
		 }
		 else {
			 log.debug("Starting password change for user [$user.id]$user.username")
			 [user: user]
		 }
	 }
   }
 
   def changelocalpassword = {
	 def user = UserBase.get(params.id)
	 if (!user) {
		   log.warn("User identified by id '$params.id' was not located")
		 flash.type = "error"
		 flash.message = message(code: 'nimble.user.nonexistant', args: [params.id])
		 redirect action: list
	 }
	 else {
		 if (!user.external) {
			 log.warn("Attempt to change password on user [$user.id]$user.username that is externally managed denied")
			 flash.type = "error"
			 flash.message = message(code: 'nimble.user.password.internal.nochange', args: [user.username])
			 redirect action: show, id: user.id
		 }
		 else {
			 log.debug("Starting local password change for user [$user.id]$user.username")
			 [user: user]
		 }
	 }
   }
 
   def savepassword = {
	 def user = UserBase.get(params.id)
	 if (!user) {
	   log.warn("User identified by id '$params.id' was not located")
	   flash.type = "error"
	   flash.message = message(code: 'nimble.user.nonexistant', args: [params.id])
	   redirect action: list
	 }
	 else {
		 user.properties['pass', 'passConfirm'] = params
		 Map userValidityMap = userService.validatePass(user, true)
		 if (!user.validate() || !userValidityMap["isValidPassword"])
		 {
			 log.debug("Password change for [$user.id]$user.username was invalid")
			 render view: 'changepassword', model: [user: user]
		 }
		 else {
			   def savedUser = userService.changePassword(user)
			 log.info("Successfully saved password change for user [$user.id]$user.username")
			 flash.type = "success"
			 flash.message = message(code: 'nimble.user.password.change.success', args: [params.id])
			 redirect action: show, id: user.id
		 }
	 }
   }
 
   // AJAX related actions
   def enable = {
	 def user = UserBase.get(params.id)
	 if (!user) {
	   log.warn("User identified by id '$params.id' was not located")
	   render message(code: 'nimble.user.nonexistant', args: [params.id])
	   response.status = 500
	 }
	 else {
		 def enabledUser = userService.enableUser(user)
		 log.info("Enabled user [$user.id]$user.username")
		 render message(code: 'nimble.user.enable.success', args: [user.username])
	 }
   }
 
   def disable = {
	 def user = UserBase.get(params.id)
	 //def nobody = "No Body"
	 def userNobody = UserBase.findByUsername("nobody")
	 println userNobody
	 if (!user) {
	   log.warn("User identified by id '$params.id' was not located")
	   render = message(code: 'nimble.user.nonexistant', args: [params.id])
	   response.status = 500
	 }
	 else {
		 def disabledUser = userService.disableUser(user)
		 
		 if(checkIfRoleAvailable(disabledUser, "PORTFOLIO MANAGER"))
		 {
			 def portfolios = Portfolio.findAll("from Portfolio p where p.portfolioManager.id = :uid",[uid: user.id])
			 
			 //def portfolios = Portfolio.findAll()
			 println portfolios
			 for (Portfolio pf in portfolios)
			 {
				 pf.portfolioManager = userNobody
				 pf.save()
			 }
		 }
		 else if(checkIfRoleAvailable(disabledUser, "PRODUCT MANAGER")){
			 def serviceProfileList = ServiceProfile.findAll("from ServiceProfile sf where sf.service.productManager.id = :uid",[uid: user.id])
			 
			 //def portfolios = Portfolio.findAll()
			 println serviceProfileList
			 for (ServiceProfile sf in serviceProfileList)
			 {
				 sf.service.productManager = userNobody
				 sf.save()
			 }
			 println "yes"
		 }else if(checkIfRoleAvailable(disabledUser, "SERVICE DESIGNER"))
		 {
		 
			 def serviceProfileList = ServiceProfile.findAll("from ServiceProfile sf where sf.serviceDesignerLead.id = :uid",[uid: user.id])
			 
			 //def portfolios = Portfolio.findAll()
			 println serviceProfileList
			 for (ServiceProfile sf in serviceProfileList)
			 {
				 sf.serviceDesignerLead = userNobody
				 sf.save()
			 }
		 }
		 
		 log.info("Disabled user [$user.id]$user.username")
		 render message(code: 'nimble.user.disable.success', args: [user.username])
	 }
   }
 
   public boolean checkIfRoleAvailable(UserBase user, String roleName)
   {
		 boolean isRoleAvailable = false
		 Role searchRole = Role.findByName(roleName)
		 
		 for(Role role : user?.roles)
		 {
			 if(role?.id == searchRole?.id){
				 isRoleAvailable = true
			 }
		 }
		 return isRoleAvailable
   }
   
   def enableapi = {
	 def user = UserBase.get(params.id)
	 if (!user) {
	   log.warn("User identified by id '$params.id' was not located")
	   message(code: 'nimble.user.nonexistant', args: [params.id])
	   response.status = 500
	 }
	 else {
		 def enabledUser = userService.enableRemoteApi(user)
		 log.info("Enabled remote api for user [$user.id]$user.username")
		 render message(code: 'nimble.user.enableapi.success', args: [user.username])
	 }
   }
 
   def disableapi = {
	 def user = UserBase.get(params.id)
	 if (!user) {
		   log.warn("User identified by id '$params.id' was not located")
		 message(code: 'nimble.user.nonexistant', args: [params.id])
		 response.status = 500
	 }
	 else {
		 def disabledUser = userService.disableRemoteApi(user)
		 log.info("Disabled remote api for user [$user.id]$user.username")
		 render message(code: 'nimble.user.disableapi.success', args: [user.username])
	 }
   }
 
   def validusername = {
	 if (params?.val == null || params?.val?.length() < 4) {
	   render message(code: 'nimble.user.username.invalid')
	   //response.status = 500
	 }
	 else {
		 def users = UserBase.findAllByUsername(params?.val)
		 if (users != null && users.size() > 0) {
		   render message(code: 'nimble.user.username.invalid')
		   //response.status = 500
		 }
		 else {
			 render message(code: 'nimble.user.username.valid')
		 }
	 }
   }
 
   def listlogins = {
	 def user = UserBase.get(params.id)
	 if (!user) {
	   log.warn("User identified by id '$params.id' was not located")
	   render message(code: 'nimble.user.nonexistant', args: [params.id])
	   response.status = 500
	 }
	 else {
		 log.debug("Listing login events for user [$user.id]$user.username")
		 def c = LoginRecord.createCriteria()
		 def logins = c.list {
			   eq("owner", user)
			 order("dateCreated")
			 maxResults(20)
		 }
		 render(template: '/templates/admin/logins_list', contextPath: pluginContextPath, model: [logins: logins, ownerID: user.id])
	 }
   }
 
   def listgroups = {
	 def user = UserBase.get(params.id)
	 if (!user) {
		   log.warn("User identified by id '$params.id' was not located")
		 render message(code: 'nimble.user.nonexistant', args: [params.id])
		 response.status = 500
	 }
	 else {
		 log.debug("Listing groups user [$user.id]$user.username is a member of")
		 render(template: '/templates/admin/groups_list', contextPath: pluginContextPath, model: [groups: user.groups, ownerID: user.id])
	 }
   }
 
   def searchgroups = {
	 def q = "%" + params.q + "%"
	 log.debug("Performing search for groups matching $q")
	 def user = UserBase.get(params.id)
	 if (!user) {
	   log.warn("User identified by id '$params.id' was not located")
	   render message(code: 'nimble.user.nonexistant', args: [params.id])
	   response.status = 500
	 }
	 else {
		 def groups = Group.findAllByNameIlike(q)
		 def nonMembers = []
		 groups.each {
		   if (!it.users.contains(user) && !it.protect) {
			 nonMembers.add(it)    // Eject groups user is already a part of
			 log.debug("Adding group identified as [$it.id]$it.name to search results")
		   }
		 }
		 log.info("Search for new groups user [$user.id]$user.username can join complete, returning $nonMembers.size records")
		 render(template: '/templates/admin/groups_search', contextPath: pluginContextPath, model: [groups: nonMembers, ownerID: user.id])
	 }
   }
 
   def grantgroup = {
	 def user = UserBase.get(params.id)
	 if (!user) {
	   log.warn("User identified by id '$params.id' was not located")
	   render message(code: 'nimble.user.nonexistant', args: [params.id])
	   response.status = 500
	 }
	 else {
		 def group = Group.get(params.groupID)
		 if (!group) {
		   log.warn("Group identified by id '$params.groupID' was not located")
		   render message(code: 'nimble.group.nonexistant', args: [params.groupID])
		   response.status = 500
		 }
		 else {
			 if (group.protect) {
				   log.warn("Can't add user [$user.id]$user.username to group [$group.id]$group.name as group is protected")
				   render message(code: 'nimble.group.protected.no.modification', args: [group.name, user.username])
				   response.status = 500
			 }
			 else {
				 groupService.addMember(user, group)
				 log.info("Added user [$user.id]$user.username to group [$group.id]$group.name")
				 render message(code: 'nimble.group.addmember.success', args: [group.name, user.username])
			 }
		 }
	 }
   }
 
   def removegroup = {
	 def user = UserBase.get(params.id)
	 if (!user) {
	   log.warn("User identified by id '$params.id' was not located")
	   render message(code: 'nimble.user.nonexistant', args: [params.id])
	   response.status = 500
	 }
	 else {
		 def group = Group.get(params.groupID)
		 if (!group) {
		   log.warn("Group identified by id '$params.groupID' was not located")
		   render message(code: 'nimble.group.nonexistant', args: [params.groupID])
		   response.status = 500
		 }
		 else {
			 if (group.protect) {
				   log.warn("Can't remove user [$user.id]$user.username from group [$group.id]$group.name as group is protected")
				 render message(code: 'nimble.group.protected.no.modification', args: [group.name, user.username])
				   response.status = 500
			 }
			 else {
				 groupService.deleteMember(user, group)
				 log.info("Removed user [$user.id]$user.username from group [$group.id]$group.name")
				 render message(code: 'nimble.group.removemember.success', args: [group.name, user.username])
			 }
		 }
	 }
   }
 
   def listpermissions = {
	 def user = UserBase.get(params.id)
	 if (!user) {
		   log.warn("User identified by id '$params.id' was not located")
		 render message(code: 'nimble.user.nonexistant', args: [params.id])
		 response.status = 500
	 }
	 else {
		 log.debug("Listing permissions user [$user.id]$user.username is granted")
		 render(template: '/templates/admin/permissions_list', contextPath: pluginContextPath, model: [permissions: user.permissions, parent: user])
	 }
   }
 
   def createpermission = {
	 def user = UserBase.get(params.id)
	 if (!user) {
		   log.warn("User identified by id '$params.id' was not located")
		   render message(code: 'nimble.user.nonexistant', args: [params.id])
		   response.status = 500
	 }
	 else {
		 LevelPermission permission = new LevelPermission()
		 permission.populate(params.first, params.second, params.third, params.fourth, params.fifth, params.sixth)
		 permission.managed = false
 
		 if (permission.hasErrors()) {
			   log.warn("Creating new permission for user [$user.id]$user.username failed, permission is invalid")
			   render(template: "/templates/errors", contextPath: pluginContextPath, model: [bean: permission])
			   response.status = 500
		 }
		 else {
			 def savedPermission = permissionService.createPermission(permission, user)
			 log.info("Creating new permission for user [$user.id]$user.username succeeded")
			 render message(code: 'nimble.permission.create.success', args: [user.username])
		 }
	 }
   }
 
   def removepermission = {
	 def user = UserBase.get(params.id)
	 if (!user) {
		   log.warn("User identified by id '$params.id' was not located")
		   render message(code: 'nimble.user.nonexistant', args: [params.id])
		   response.status = 500
	 }
	 else {
		 def permission = Permission.get(params.permID)
		 if (!permission) {
			   log.warn("Permission identified by id '$params.permID' was not located")
			   render message(code: 'nimble.permission.nonexistant', args: [params.permID])
			   response.status = 500
		 }
		 else {
			 permissionService.deletePermission(permission)
			 log.info("Removing permission [$permission.id] from user [$user.id]$user.username succeeded")
			 render message(code: 'nimble.permission.remove.success', args: [user.username])
		 }
	 }
   }
 
   def listroles = {
	 def user = UserBase.get(params.id)
	 if (!user) {
		   log.warn("User identified by id '$params.id' was not located")
		   render message(code: 'nimble.user.nonexistant', args: [params.id])
		   response.status = 500
	 }
	 else {
		 log.debug("Listing roles user [$user.id]$user.username is granted")
		 render(template: '/templates/admin/roles_list', contextPath: pluginContextPath, model: [roles: user.roles, ownerID: user.id])
	 }
   }
 
   def searchroles = {
	 def q = "%" + params.q + "%"
	 log.debug("Performing search for roles matching $q")
	 def user = UserBase.get(params.id)
	 if (!user) {
	   log.warn("User identified by id '$params.id' was not located")
	   render message(code: 'nimble.user.nonexistant', args: [params.id])
	   response.status = 500
	 }
	 else {
		 def roles = Role.findAllByNameIlikeOrDescriptionIlike(q, q, false)
		 def respRoles = []
		 roles.each {
		   if (!user.roles.contains(it) && !it.protect) {
			 respRoles.add(it)    // Eject already assigned roles for this user
			 log.debug("Adding role identified as [$it.id]$it.name to search results")
		   }
		 }
		 List salesPresidentList = findUsersByRole("SALES PRESIDENT")
		 List salesManagerList = findUsersByRole("SALES MANAGER")
		 //def userList = UserBase.findAll("FROM UserBase user")
		 log.info("Search for new roles user [$user.id]$user.username can be assigned complete, returning $respRoles.size records")
		 render(template: '/templates/admin/roles_search', contextPath: pluginContextPath, model: [roles: respRoles, ownerID: user.id, salesPresidentList: salesPresidentList, salesManagerList: salesManagerList])
	 }
   }
   
   private List findUsersByRole(roleName)
   {
	   List tmpList = new ArrayList()
	   for(UserBase user in Role.findByCode(roleName)?.users)
	   {
		   tmpList.add(UserBase.get(user.id))
	   }
	   
	   return tmpList
   }
   
   def changeSupervisor =
   {
	   def result = "fail"
	   def user = UserBase.get(params.id)
	   /*if(user.supervisor != null)
	   {
		   def supervisor = UserBase.get(user.supervisor.id)
		   
		   supervisor.removeFromMembers(user)
		   supervisor.save()
	   }
	   def newSupervisor = UserBase.get(params.supervisorId)
	   user.supervisor = newSupervisor*/
	   
	   if(params.territoryID != null)
	   {
		   user.territory = Geo.get(params.territoryID)
	   }
	   
	   if(params.territories != null)
	   {
		   def territories = params.territories.toList()
		   def territoriesList = []
		   for(Object i in territories)
		   {
			   if(i != ",")
			   {
					 territoriesList.add(i)
			   }
			 
		   }
		   
		   if(territoriesList.size() > 0)
		   {
			   user.territories = null
			   user.save()
			   for(Object i in territoriesList)
			   {
				   user.addToTerritories(Geo.get(i))
			   }
		   }
	   }
	   
	   if(params.geoGroupId != null)
	   {
		   def geoGroup =  GeoGroup.get(params?.geoGroupId)
		   if(geoGroup)
		   {
			   user.geoGroup = geoGroup
		   }
	   }
	   user.save()
	   //flash.message = "Supervisor is changed successfully....."
	   flash.message = "Successfully changed..."
	   //redirect action: show, id: user.id
	   result = "success"
	   render result
   }
 
   def grantrole = {
	 def user = UserBase.get(params.id)
	 //println "Sales Manager id "+params.salesManagerId
	 //println "Sales President id "+params.salesPresidentId
	 if (!user) {
		   log.warn("User identified by id '$params.id' was not located")
		 render message(code: 'nimble.user.nonexistant', args: [params.id])
		 response.status = 500
	 }
	 else {
		 def role = Role.get(params.roleID)
		 if (!role) {
		   log.warn("Role identified by id '$params.roleID' was not located")
		   render message(code: 'nimble.role.nonexistant', args: [params.roleID])
		   response.status = 500
		 }
		 else
		 {
			 //println role.name
			 if (role.protect) {
				   log.warn("Can't assign user [$user.id]$user.username role [$role.id]$role.name as role is protected")
				 render message(code: 'nimble.role.protected.no.modification', args: [role.name, user.username])
				 response.status = 500
			 }
			 else {
				 
				 roleService.addMember(user, role, params)
				 //roleService.addMember(user, role, params.territoryID, territoriesList)
				 log.info("Assigned user [$user.id]$user.username role [$role.id]$role.name")
				 render message(code: 'nimble.role.addmember.success', args: [role.name, user.username])
			 }
		 }
	 }
   }
 
   def removerole = {
	 def user = UserBase.get(params.id)
	 if (!user) {
	   log.warn("User identified by id '$params.id' was not located")
	   render message(code: 'nimble.user.nonexistant', args: [params.id])
	   response.status = 500
	 }
	 else {
		 def role = Role.get(params.roleID)
		 if (!role) {
		   log.warn("Role identified by id '$params.roleID' was not located")
		   render message(code: 'nimble.role.nonexistant', args: [params.roleID])
		   response.status = 500
		 }
		 else {
			 if (role.protect) {
				   log.warn("Can't assign user [$user.id]$user.username role [$role.id]$role.name as role is protected")
				 render message(code: 'nimble.role.protected.no.modification', args: [role.name, user.username])
				 response.status = 500
			 }
			 else {
				 
				 checkUserBeforeDeleteMember(user, role)
				 //roleService.deleteMember(user, role)
				 log.info("Removed user [$user.id]$user.username from role [$role.id]$role.name")
				 //render message(code: 'nimble.role.removemember.success', args: [role.name, user.username])
			 }
		 }
	 }
   }
 
   def checkUserBeforeDeleteMember(UserBase user, Role role)
   {
	   /*if(role.name=="SALES PERSON")
	   {
		   def salesManager = UserBase.get(user.supervisor.id)
		   salesManager.removeFromMembers(user)
		   salesManager.save()
		   roleService.deleteMember(user, role)
		   log.info("Removed user [$user.id]$user.username from role [$role.id]$role.name")
		   render message(code: 'nimble.role.removemember.success', args: [role.name, user.username])
	   }
	   else*/ if(role.name == "SALES MANAGER")
	   {
		   //if(user.members.size() == 0)
		   if(user.territories.size() > 0)
		   {
			   /*def salesPresident = UserBase.get(user.supervisor.id)
			   salesPresident.removeFromMembers(user)
			   salesPresident.save()*/
			   def currentTerritories = user.territories
			   
			   user.territories = null
			   user.save()
			   
			   roleService.deleteMember(user, role)
			   
			   User loggedInUser = User.get(new Long(SecurityUtils.subject.principal))
			   for(Geo geo :currentTerritories){
				   updateSalesManagerRemovalRequest(geo, user, loggedInUser);
			   }
			   
			   log.info("Removed user [$user.id]$user.username from role [$role.id]$role.name")
			   render message(code: 'nimble.role.removesalesmanager.success', args: [role.name, user.username, currentTerritories])
			   
		   }
		   else
		   {
			  render message(code: 'nimble.role.salesManager.remove.error')
		   }
	   }
	  /* else if(role.name == "SALES PRESIDENT")
	   {
		   if(user.members.size() == 0)
		   {
			   roleService.deleteMember(user, role)
			   log.info("Removed user [$user.id]$user.username from role [$role.id]$role.name")
			   render message(code: 'nimble.role.removemember.success', args: [role.name, user.username])
		   }
		   else
		   {
			   render message(code: 'nimble.role.salesPresident.remove.error')
		   }
	   }*/
	   else
	   {
		   roleService.deleteMember(user, role)
		   log.info("Removed user [$user.id]$user.username from role [$role.id]$role.name")
		   render message(code: 'nimble.role.removemember.success', args: [role.name, user.username])
	   }
	   
   }
   
   def updateSalesManagerRemovalRequest(Geo geo , User updatedUser, User receivedUser)
   {
	   def note = new Notification()
	   note.objectType = "Territory"
	   note.objectId = geo.id
	   note.dateCreated = new Date()
	   note.active = true
	   note.receiverUsers = [receivedUser]
	   note.receiverGroups = new ArrayList()
	   
	   note.message = message(code: "nimble.role.removesalesmanager.updateGeo", args: [updatedUser.username, geo.name]);
	   
	   note.save(flush:true)
	   return []
   }
 }
 
 