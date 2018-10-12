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


import grails.plugins.nimble.InstanceGenerator

import grails.plugins.nimble.core.*

import com.valent.pricewell.RoleId;
import com.valent.pricewell.User

/*
 * Allows applications using Nimble to undertake process at BootStrap that are related to Nimbe provided objects
 * such as Users, Role, Groups, Permissions etc.
 *
 * Utilizing this BootStrap class ensures that the Nimble environment is populated in the backend data repository correctly
 * before the application attempts to make any extenstions.
 */
class NimbleBootStrap {

  def grailsApplication

  def nimbleService
  def userService
  def adminsService
  def roleService
  def permissionService

  def init = {servletContext ->

    // The following must be executed
    internalBootStap(servletContext)

    // Execute any custom Nimble related BootStrap for your application below

    if(!User.findByUsername("user"))
    {
        // Create example User account
	    def user = InstanceGenerator.user()
	    user.username = "user"
	    user.pass = 'useR123!'
	    user.passConfirm = 'useR123!'
	    user.enabled = true
	
	    def userProfile = InstanceGenerator.profile()
	    userProfile.fullName = "Test User"
	    userProfile.owner = user
	    user.profile = userProfile
	
	    def savedUser = userService.createUser(user)
	    if (savedUser.hasErrors()) {
	      savedUser.errors.each {
	        log.error(it)
	      }
	      throw new RuntimeException("Error creating example user")
	    }
    }
	
	if(!User.findByUsername("admin"))
	{
		// Create example Administrative account
	    def admins = Role.findByName(AdminsService.ADMIN_ROLE)
	    def admin = InstanceGenerator.user()
	    admin.username = "admin"
	    admin.pass = "admiN123!"
	    admin.passConfirm = "admiN123!"
	    admin.enabled = true
	
	    def adminProfile = InstanceGenerator.profile()
	    adminProfile.fullName = "Administrator"
		adminProfile.email = 'rlsar.valent2010@gmail.com'
	    adminProfile.owner = admin
	    admin.profile = adminProfile
	
	    def savedAdmin = userService.createUser(admin)
	    if (savedAdmin.hasErrors()) {
	      savedAdmin.errors.each {
	        log.error(it)
	      }
	      throw new RuntimeException("Error creating administrator")
	    }
		
	    adminsService.add(admin)
	}
	
	if(!User.findByUsername("superadmin"))
	{
		// Create example Administrative account
	    def admins = Role.findByName(AdminsService.ADMIN_ROLE)
	    def admin = InstanceGenerator.user()
	    admin.username = "superadmin"
	    admin.pass = "admiN123!"
	    admin.passConfirm = "admiN123!"
	    admin.enabled = true
	
	    def adminProfile = InstanceGenerator.profile()
	    adminProfile.fullName = "Super Administrator"
		//adminProfile.email = 'rlsar.valent2010@gmail.com'
	    adminProfile.owner = admin
	    admin.profile = adminProfile
	
	    def savedAdmin = userService.createUser(admin)
	    if (savedAdmin.hasErrors()) {
	      savedAdmin.errors.each {
	        log.error(it)
	      }
	      throw new RuntimeException("Error creating administrator")
	    }
		
	    adminsService.add(admin)
	}
	
	if(!User.findByUsername("nobody"))
	{
		// Create example Administrative account
		
		User tmp = InstanceGenerator.user()
		tmp.username = "nobody"
		tmp.pass = "admiN123!"
		tmp.passConfirm = "admiN123!"
		tmp.enabled = true
	
		def tmpProfile = InstanceGenerator.profile()
		tmpProfile.fullName = "No Body"
		//adminProfile.email = 'rlsar.valent2010@gmail.com'
		tmpProfile.owner = tmp
		tmp.profile = tmpProfile
	
		def savedtmp = userService.createUser(tmp)
		if (savedtmp.hasErrors()) {
		  savedtmp.errors.each {
			log.error(it)
		  }
		  throw new RuntimeException("Error creating administrator")
		}
		
		addAllRolesIntoUser(tmp)
	}
	
  }

  public void addAllRolesIntoUser(User user)
  {
	  def portfolioManager = Role.findByName("PORTFOLIO MANAGER");			user.addToRoles(portfolioManager)
	  def deliveryRoleManager = Role.findByName("DELIVERY ROLE MANAGER");	user.addToRoles(deliveryRoleManager)
	  def productManager = Role.findByName("PRODUCT MANAGER");				user.addToRoles(productManager)
	  def serviceDesigner = Role.findByName("SERVICE DESIGNER");			user.addToRoles(serviceDesigner)
	  def salesPerson = Role.findByName("SALES PERSON");					user.addToRoles(salesPerson)
	  def salesPresident = Role.findByName("SALES PRESIDENT");				user.addToRoles(salesPresident)
	  def salesManager = Role.findByName("SALES MANAGER");					user.addToRoles(salesManager)
	  def generalManager = Role.findByName("GENERAL MANAGER");				user.addToRoles(generalManager)
	  //def adminRole = Role.findByName("SYSTEM ADMINISTRATOR");			user.addToRoles(deliveryRoleManager)
	  
	  user.save(flush:true)
  }
  
  def destroy = {

  }

  private internalBootStap(def servletContext) {
    nimbleService.init()
  }
}

