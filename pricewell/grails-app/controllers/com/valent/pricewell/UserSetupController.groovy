package com.valent.pricewell
import java.lang.reflect.InvocationTargetException
import java.util.List;

import org.apache.shiro.SecurityUtils
import grails.converters.JSON;
import grails.plugins.nimble.core.*
import javax.management.relation.RoleInfo;
import grails.plugins.nimble.InstanceGenerator
import com.valent.pricewell.Staging.AuthorizedScope;
import org.apache.shiro.crypto.hash.Sha256Hash

class UserSetupController {

	def userService
	def roleService
	def sendMailService
	def serviceCatalogService
	def salesCatalogService, permissionService, phoneNumberService
	static allowedMethods = [save: "POST", update: "POST", delete: "POST"]
	
	static def randomPassword = null
	
	def beforeInterceptor = [action:this.&debug]
	
	def debug() {
		//def user = User.get(new Long(SecurityUtils.subject.principal))
		//[User: ${user.profile.fullName}] - 
		log.info("${actionUri} with params ${params}")
	}
	
	static List  roleIds = [RoleId.ADMINISTRATOR.code,
		RoleId.PORTFOLIO_MANAGER.code,
		RoleId.PRODUCT_MANAGER.code,
		RoleId.SERVICE_DESIGNER.code,
		RoleId.SALES_PRESIDENT.code,
		RoleId.GENERAL_MANAGER.code,
		RoleId.SALES_MANAGER.code,
		RoleId.SALES_PERSON.code,
		RoleId.DELIVERY_ROLE_MANAGER.code]

	static List isRoleDisplay = [roleIds.size()];
	
	static Map[] usersByRoleList = new Map[roleIds.size()];

	def index = {
		redirect(action: "list", params: params)
	}

	public boolean isSuperAdmin()
	{
		def cred = SecurityUtils.subject.principal
		
		if(cred != null)
		{
			def user = User.get(new Long(SecurityUtils.subject.principal))
			if(user.username == "superadmin")
			{
				return true
			}
		}
		return false
	}
	
	def list = {
		params.max = Math.min(params.max ? params.int('max') : 10, 100)
		[userInstanceList: User.list(params), userInstanceTotal: User.count()]
	}

	def isUserDefined = 
	{
		println "coming here user"
		String roleName = ServiceStageFlow.findUserRole("addUsers", params.stepNumber.toInteger());
		def roleInstance = Role.findByName(roleName)
		
		if(roleInstance?.users.size() > 0)
		{
			render "true"
		}
		else
		{
			render "false"
		}
	}
	
	def create = {
		def userInstance = new User()
		userInstance.properties = params
		return [userInstance: userInstance]
	}

	def createsetup = {
		def userInstance = new User()
		def territoriesList = new ArrayList(), geoGroupList = new ArrayList()
		userInstance.properties = params
		def roleInstance = null
		if(params.roleId != null && params.roleId != "")
		{
			roleInstance = Role.get(params.roleId)
		}
		else
		{
			int index = params.roleindex.toInteger();
			roleInstance = Role.findByName(usersByRoleList[index]["role"])
		}
		
		if(params.sourceFrom != "geoGroup" && params.sourceFrom != "geo")
		{
			if(roleInstance.name == "SALES PRESIDENT")
			{
				territoriesList = Geo.list()
			}
			
			if(roleInstance.name == "GENERAL MANAGER")
			{
				/*if(params.sourceFrom != "geoGroup")
				{*/
					def map = [:]
					map = salesCatalogService.findUnassignedGeosWithTerritoriesForGeneralManager()//.findUnassignedGeosForGeneralManager()
					geoGroupList = map['geoGroupList']
					territoriesList = map['territoriesList']
				//}
			}
			else if(roleInstance.name == "SALES MANAGER")
			{
				/*if(params.sourceFrom != "geo")
				{*/
					def map = [:]
					map = salesCatalogService.findUnassignedTerritoriesForSalesManager(null)
					geoGroupList = map['geoGroupList']
					territoriesList = map['territoriesList']
				//}
			}
			else if(roleInstance.name == "SALES PERSON")
			{
				/*if(params.sourceFrom != "geo")
				{*/
					geoGroupList = GeoGroup.list()
					territoriesList = salesCatalogService.findTerritoriesForSalesPerson(null)
				//}
			}
		}
		
		println geoGroupList
		def source = (params.source == "firstsetup")?"firstsetup":"setup"
		def sourceFrom = (params.sourceFrom == "geoGroup")?"geoGroup":((params.sourceFrom == "geo")?"geo": "")
		
		render(template: "createsetup", model: [sourceFrom: sourceFrom, user: userInstance, roleInstance: roleInstance, source: source, geoGroupList: geoGroupList?.sort {it.name}, territoriesList: territoriesList?.sort {it.name}])
	}

	def getGeosTerritories = {
		
		def territoriesList = new ArrayList()
		def roleInstance = Role.get(params.roleId.toInteger())
		def geoGroup = GeoGroup.get(params.id.toInteger())
		def data = [:]
		if(roleInstance.name == "GENERAL MANAGER")
		{
			for(Geo territory : geoGroup?.geos)
			{
				territoriesList.add(territory)
			}
		}
		else if(roleInstance.name == "SALES MANAGER")
		{
			def map = [:]
			map = salesCatalogService.findUnassignedTerritoriesForSalesManager(geoGroup)
			territoriesList = map['territoriesList']
		}
		else if(roleInstance.name == "SALES PERSON")
		{
			territoriesList = salesCatalogService.findTerritoriesForSalesPerson(geoGroup)
		}
		
		def primaryOptions = '<option value selected="selected">Select Any One</option>'
		def secondaryOptions = '<option value selected="selected">Select Multiple</option>'
		for(Geo territory : territoriesList)
		{
			primaryOptions = primaryOptions + '<option value="'+territory?.id+'">'+territory?.name+'</option>'
			secondaryOptions = secondaryOptions + '<option value="'+territory?.id+'">'+territory?.name+'</option>'
		}
		data["primary"] = primaryOptions
		data["secondary"] = secondaryOptions
		render data as JSON
		//render(template: "filteredTerritoryList", model: [roleInstance: roleInstance, territoriesList: territoriesList])
	}
	
	def getExistingUsers = {
		int index = params.roleindex.toInteger()
		def roleInstance = Role.findByName(usersByRoleList[index]["role"])
		
		def adminRole = Role.findByName("SYSTEM ADMINISTRATOR")
		def testUser = User.findByUsername("user")
		
		def existingUsers = []
		for(User user : User.list())
		{
			if(!user.roles.contains(roleInstance) && !user.roles.contains(adminRole))
			{
				existingUsers.add(user)
			}
		}
		existingUsers.remove(testUser)
		
		render(template: "addExistingUser", model: [existingUsers: existingUsers, roleInstance: roleInstance])
		
	}
	
	def addExistingUser = {
		def user = User.get(params?.userId.toInteger())
		def role = Role.get(params?.roleId.toInteger())
		
		if(role && user)
		{
			user.addToRoles(role)
			user.save()
			render "success"
			
		}
		else
		{
			render "fail"
		}
		return
	}
	
	def setlogouttime = {
		SecurityUtils.subject.getSession().setTimeout(10000);
		render 's'
	}

	def getlogouttime = {
		render SecurityUtils?.subject?.getSession()?.getTimeout();
	}

	def islogin = {
		
		if(SecurityUtils?.subject?.principal)
			render "true"
		else
			render "false"
	}

	public boolean isUsernameAvailable(def username)
	{
		
			def users = User.findAllByUsername(username)
			if (users != null && users.size() > 0) 
			{
			   return true
			  //response.status = 500
			}
			else {
				return false
			}
		
	  }
	
	public boolean isEmailAvailable(def email)
	{
		
			def users = User.findAll("FROM User user WHERE user.profile.email=:email", [email: email])
			if (users != null && users.size() > 0)
			{
			   return true
			  //response.status = 500
			}
			else {
				return false
			}
		
	}
	
	def addPrimaryTerritory = {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def territoryList = new ArrayList()
		territoryList = salesCatalogService.findUserTerritories(user)
		
		render(view: "addTerritory", model: [territoryList: territoryList, userInstance: user])
	}
	
	def savePrimaryTerritory = {
		def user = User.get(new Long(SecurityUtils.subject.principal))
		//user.country = params.country
		def territory = Geo.get(params.primaryTerritory.toLong())
		user.primaryTerritory = territory
		user.save()
		
		if(territory?.country == null || territory?.country == "NULL" || territory?.country == "")
		{
			territory.country = params.country
			territory.save()
		}
		render "success"
		//redirect(action: "create", controller: session['controller'])
	}
	
	def save = 
	{
		def map = [:]
		def phone = ""
		if(params.phone!="" && params.phoneCountry!="")
		{
			phone = phoneNumberService.getValidatedPhonenumber(params.phone, params.phoneCountry)
		}
		
		if(isUsernameAvailable(params.username))
		{
			render "username_Available"
		}
		else if(isEmailAvailable(params.email))
		{
			render "email_Available"
		}
		else
		{
			boolean proceed = true
			if(phone == "Invalid")
			{
				proceed = false
			}
			else
			{
				params.phone = phone
			}
			
			if(!proceed)
			{
				render "invalid_phone"
			}
			else
			{
				if(params.sourceOfCreate == "advanceAdministrator")
				{
					/*Map resultMap = [:]
						resultMap["result"] = "success"
						resultMap["phone"] = phone*/
						def result = "success"+phone
						render result//resultMap as JSON
				}
				else
				{
					
					CommonFunctionsUtil generateRandomPassword = new CommonFunctionsUtil()
					randomPassword = generateRandomPassword.generatePswd(8, 8, 1, 1, 1)
					println "random : "+randomPassword
					
					User user = new User(profile: new ProfileBase())//InstanceGenerator.user()
					def userFields = grailsApplication.config.nimble.fields.enduser.user
					
					user.properties[userFields] = params
					user.pass = "$randomPassword"
					user.passConfirm = "$randomPassword"
					user.lastUpdated = new Date()
					user.dateCreated = new Date()
					user.enabled = true
					user.external = false
					
					
					ProfileBase profile = user.profile//InstanceGenerator.profile()
					//user.profile = InstanceGenerator.profile()
					def profileFields = grailsApplication.config.nimble.fields.enduser.profile
					
					profile.properties[profileFields] = params
					profile.phone = params.phone
					profile.country = params.phoneCountry
					profile.lastUpdated = new Date()
					profile.dateCreated = new Date()
					
					if(params?.geoGroup != null && params?.geoGroup != "")
					{
						def geoGroup =  GeoGroup.get(params?.geoGroup.toInteger())
						geoGroup.save(flush:true)
					}
					
					Role role = Role.get(params.roleId)
					
					if(role) {
						user.addToRoles(role)
					}
					else
					{
						log.error("Unable to locate role, aborting user creation")
						throw new RuntimeException("Unable to locate role, aborting user creation")
					}
					
					Geo primaryTerritory = null
					def territoriesList = []
					//*****************Primary Territory for sales users****************************
						 /*Add primary country*/
						 //user.country = params.country
						 if(params.primaryTerritory != null && params.primaryTerritory != "")
						 {
							 primaryTerritory = Geo.get(params.primaryTerritory.toLong())
							 user.primaryTerritory = primaryTerritory
							 
							 if(primaryTerritory?.country == null || primaryTerritory?.country == "NULL" || primaryTerritory?.country == "")
							 {
								 primaryTerritory.country = params.country
								 primaryTerritory.save()
							 }
						 }
					 
				   //*****************************************************************************
					if(role?.name == "GENERAL MANAGER")
					{
						//********************** Assign GeoGroup(geo) for General Manager ****************
						 
							if(params?.geoGroupId)// != null && params.geoGroupId != "")
							{
								def geoGroupInstance =  GeoGroup.get(params?.geoGroupId.toInteger())
								if(geoGroupInstance)
								{
									user.geoGroup = geoGroupInstance
									//geoGroupInstance.addToGeneralManagers(user) //user is General Manager
									//geoGroupInstance.save()
									//user.save()
									
								}
							}
						 //******************************************************************************
					}
					
					else if(role?.name == "SALES MANAGER")
					{
						 //******************* Assign Territories to Sales Manager *************************
							
							 if(params?.territoriesList)// != null && params.territoriesList != "")
							 {
								 def territories = params.territoriesList.toList()
								 for(Object i in territories)
								 {
									 if(i != ",")
									 {
										 territoriesList.add(i)
									 }
								 }
								   
								 if(territoriesList.size() > 0)
								 {
									 for(Object i in territoriesList)
									 {
										 def geoInstance = Geo.get(i.toInteger())
										 //geoInstance.salesManager = user //user is Sales Manager
										 //geoInstance.save()
										 if(geoInstance)
										 {
											 user.addToTerritories(geoInstance)
										 }
									 }
								 }
							 }
							 
							 if(primaryTerritory != null)
							 {
								 user.addToTerritories(primaryTerritory)
							 }
						
					   //******************************************************************************
					}
					else if(role?.name == "SALES PERSON")
					{
						 //******************* Assign Territory to Sales Person *************************
						  /*if(params?.territoryId)// != null && params.territoryId != "")
						  {
							  def geoInstance = Geo.get(params.territoryId.toInteger())
							  //geoInstance.addToSalesPersons(user) //savedUser is Sales Person
							  //geoInstance.save()
							  if(geoInstance)
							  {
								  //println geoInstance?.name
								  user.territory = geoInstance
								 
							  }
						  }*/
						 
						if(primaryTerritory != null)
						{
							user.territory = primaryTerritory
						}
					   //******************************************************************************
					}
					
					if(role.code == RoleId.ADMINISTRATOR.code)
					{
						Permission adminPermission = new Permission(target:'*')
						adminPermission.managed = true
						adminPermission.type = Permission.adminPerm
			
						permissionService.createPermission(adminPermission, user)
					}
					
					//session.save(profile)
					def savedUser = userService.createUser(user)
					if (savedUser == "defalutRoleLocate" || savedUser == "defalutRoleAssign" || savedUser == "defalutPermissionsAssign")//.hasErrors())
					{
						  log.info("Failed to save new user")
						  if(params.source == "setup" || params.source == "firstsetup")
						  {
							  if(savedUser?.id != null)
							  {
								  deleteSavedUser(savedUser)
							  }
							  if(savedUser == "defalutRoleLocate")
							  {
								  render "Could not find default role 'USER' internally, please reload and try again."
							  }
							  else if(savedUser == "defalutRoleAssign")
							  {
								  render "Could not assing default role 'USER' to the creating user internally, please reload and try again."
							  }
							  else if(savedUser == "defalutPermissionsAssign")
							  {
								  render "Could not assign default permission to the creating user internally, please reload and try again."
							  }
							  //render "Failed to save new user."
						  }//view: 'create', model: [roleList: Role.list(), user: user]
					}
					else
					{
						if(params?.geoGroupId)// != null && params.geoGroupId != "")
						{
							def geoGroupInstance =  GeoGroup.get(params?.geoGroupId.toInteger())
							if(geoGroupInstance)
							{
								def map1 = new NotificationGenerator(g).sendAssignedToGeneralManagerNotification(geoGroupInstance);
								sendMailService.sendEmailNotification(map1["message"], map1["subject"], map1["receiverList"], request.siteUrl+"/geoGroup/show/"+geoGroupInstance.id)
							}
						}
						
						if(territoriesList.size() > 0)
						{
							for(Object i : territoriesList)
							{
								def geoInstance = Geo.get(i.toInteger())
								def map1 = new NotificationGenerator(g).sendAssignedToSalesManagerNotification(geoInstance)
								sendMailService.sendEmailNotification(map1["message"], map1["subject"], map1["receiverList"], request.siteUrl+"/geo/show/"+geoInstance.id)
								map1 = new HashMap()
							}
						}
						loadRoleUserCache();
						log.info("Successfully created new user [$savedUser.id]$savedUser.username")
						def message = message(code: "notification.newuser.create.message", args: ["${savedUser.username}", "${savedUser.pass}"]);
						sendMailService.sendEmailNotification(message, "Valent Software - Reset Password", [savedUser], request.siteUrl+"/userSetup/changepassword/"+savedUser.id)
						if(params.sourceFrom == "geoGroup" || params.sourceFrom == "geo")
						{
							Map resultMap = [:]
							resultMap["userName"] = savedUser?.profile?.fullName
							resultMap["userId"] = savedUser?.id
							resultMap["result"] = "success"
							
							render resultMap as JSON
						}
						else if(params.source == "setup" || params.source == "firstsetup")
						{
							Map resultMap = [:]
							resultMap["result"] = "success"
							render resultMap as JSON
						}
					}
				}
			}
		}

	}


	private void deleteSavedUser(User user)
	{
		def username =  user.username
		for(Role role : user?.roles)
		{
			user.removeFromRoles(role)
			role.removeFromUsers(user)
			role.save()
			
			if (role.hasErrors()) {
				log.error("Unable to remove role $role.name from user [$user.id]$user.username")
				role.errors.each {
					log.error(it)
				}

				throw new RuntimeException("Unable to remove role $role.name from user [$user.id]$user.username")
			}
		}	
		user.save()
		
		if(user.delete())
			log.info("Successfully deleted user $username")
		else
			log.info("User $username was not deleted")
		//flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'user.label', default: 'User'), params.id])}"
		
	}
	
	private void loadRoleUserCache(){
		def roles = Role.list();
		
		for(Role role: roles){
			if(roleIds.contains(role.getCode())){
				
				usersByRoleList[roleIds.indexOf(role.getCode())] = [role: role.getName(), users: []]
				isRoleDisplay[roleIds.indexOf(role.getCode())] = isRoleVisibleInList(role.getCode())
			}
		}
		//List users = User.list();
		def users = User.findAll("FROM User user WHERE user.username!='superadmin' AND user.username!='user' AND user.username!='nobody' ORDER BY user.profile.fullName ASC")
		for(User user: users)
		{
			if(user?.enabled == true)
			{
				def userRoles = user.getRoles();
				for(Role role : userRoles){
					if(roleIds.contains(role.getCode())){
						int index = roleIds.indexOf(role.getCode());
						usersByRoleList[index]["users"].add(user);
					}
				}
			}
		}
	}
	
	public boolean isRoleVisibleInList(def code)
	{
		if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR")){return true}
		else
		{
			switch(code)
			{
				case RoleId.ADMINISTRATOR.code :
						if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR")){return true}else {return false}
						break;
				case RoleId.PORTFOLIO_MANAGER.code :
						if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR")){return true}else {return false}
						break;
				case RoleId.PRODUCT_MANAGER.code :
						if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("PORTFOLIO MANAGER")){return true}else {return false}
						break;
				case RoleId.SERVICE_DESIGNER.code :
						if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("PRODUCT MANAGER") || SecurityUtils.subject.hasRole("PORTFOLIO MANAGER")){return true}else {return false}
						break;
				case RoleId.GENERAL_MANAGER.code :
						if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("SALES PRESIDENT")){return true}else {return false}
						break;
				case RoleId.SALES_PRESIDENT.code :
						if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR")){return true}else {return false}
						break;
				case RoleId.SALES_MANAGER.code :
						if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("SALES PRESIDENT") || SecurityUtils.subject.hasRole("GENERAL MANAGER")){return true}else {return false}
						break;
				case RoleId.SALES_PERSON.code :
						if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR") || SecurityUtils.subject.hasRole("SALES PRESIDENT") || SecurityUtils.subject.hasRole("GENERAL MANAGER") || SecurityUtils.subject.hasRole("SALES MANAGER")){return true}else {return false}
						break;
				case RoleId.DELIVERY_ROLE_MANAGER.code :
						if(SecurityUtils.subject.hasRole("SYSTEM ADMINISTRATOR")){return true}else {return false}
						break;
			}
		}
	}
	
	def listroles = {
		loadRoleUserCache();
		render(template: "listsetuproles", model: [usersByRoleList: usersByRoleList, isRoleDisplay: isRoleDisplay, source: params.source])
	}

	def listsetup = {
		/*int index = params.roleindex.toInteger(); 
		def users = usersByRoleList[index]["users"]
		def role = Role.findByName(usersByRoleList[index]["role"])
		/*println role.name
		for(User user in role.users)
		{
			
			println user.territory
		}*/
		def roleInstance = Role.get(params.roleId)
		
		List roleUsers = userService.filterUserList(roleInstance?.users.toList())
		/*for(User user : roleInstance?.users)
		{
			if(user.username != "superadmin" && user.username != "user")
			{
				roleUsers.add(user)
			}
		}*/
		
		render(template: "usersbyrole", model: [users: roleUsers, roleInstance: roleInstance, source: params.source])
		//render(template: "usersbyrole", model: ["users": role.users, "roleindex": index,usersByRoleList: usersByRoleList, roleInstance: role ])//
	}

	def listusersbyrole = {
		int index = params.roleindex.toInteger();
		def users = usersByRoleList[index]["users"]
		def role = Role.findByName(usersByRoleList[index]["role"])
		println role.name
		def source = (params.source == "firstsetup")?"firstsetup":"setup"
		List roleUsers = userService.filterUserList(role?.users.toList())
		/*for(User user : role?.users)
		{
			if(user.username != "superadmin" && user.username != "user")
			{
				roleUsers.add(user)
			}
		}*/
		render(template: "roleusers", model: ["users": roleUsers, "roleindex": index, usersByRoleList: usersByRoleList, roleInstance: role, source: source ])
	}
	
	def getRoleName =
	{
		int index = params.roleindex.toInteger()
		def roleName = usersByRoleList[index]["role"]
		println roleName
		render roleName	
	}

	def show = {
		def userInstance = User.get(params.id)
        if (!userInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), params.id])}"
            redirect(action: "list")
        }
        else {
			
            [userInstance: userInstance]
        }
	}

	def showsetup = {
		def userInstance = User.get(params.id)
		def roleInstance = Role.get(params.roleId.toLong())
		loadRoleUserCache();
        if (!userInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), params.id])}"
            redirect(action: "list")
        }
        else {
			render(template: "showsetup", model: [user: userInstance, roleInstance: roleInstance])
			
		}
	}

	def edit = {
		def userInstance = User.get(params.id)
        if (!userInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [userInstance: userInstance]
        }
	}

	def editsetup = {
		User userInstance = User.get(params.id)
		Role roleInstance = Role.get(params.roleId)
		Set secondaryTerritories = new HashSet()
        if (!userInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), params.id])}"
            redirect(action: "list")
        }
        else {
			
			Set territoriesList = new HashSet(), geoGroupList = new HashSet() 
			Set primaryTerritoriesList = new HashSet() //unassigned + primary
			
			if(roleInstance.name == "SALES PRESIDENT")
			{
				territoriesList = Geo.list()
			}
			else if(roleInstance.name == "GENERAL MANAGER")
			{
				/*if(params.sourceFrom != "geoGroup")
				 {*/
					 def map = [:]
					 map = salesCatalogService.findUnassignedGeosWithTerritoriesForGeneralManager()//.findUnassignedGeosForGeneralManager()
					 geoGroupList = map['geoGroupList']
					 territoriesList = map['territoriesList']
				 //}
				
					if(userInstance?.geoGroup != null)
					{
						geoGroupList.add(userInstance?.geoGroup)
						for(Geo territory : userInstance?.geoGroup?.geos)
						{
							territoriesList.add(territory)
						}
					}
				
			}
			else if(roleInstance.name == "SALES MANAGER")
			{
				def map = [:]
				map = salesCatalogService.findUnassignedTerritoriesForSalesManager(null)
				geoGroupList = map['geoGroupList']
				territoriesList = map['territoriesList']
				primaryTerritoriesList = map['territoriesList']
				println "primary : "+userInstance?.primaryTerritory
				for(Geo terri : userInstance?.territories)
				{
					if(userInstance?.primaryTerritory)
					{
						if(terri?.id != userInstance?.primaryTerritory?.id)
						{
							territoriesList.add(terri)//unassigned + secondary
							secondaryTerritories.add(terri)
						}
					}
					else
					{
						territoriesList.add(terri)//unassigned + secondary
						secondaryTerritories.add(terri)
					}
					primaryTerritoriesList.add(terri)
					
				}
				
			}
			else if(roleInstance.name == "SALES PERSON")
			{
				//geoGroupList = GeoGroup.list()
				territoriesList = salesCatalogService.findTerritoriesForSalesPerson(null)
				
				//if(!territoriesList.contains(userInstance?.territory))
				if(userInstance?.territory != null && !salesCatalogService.isListContainsTerritory(territoriesList?.toList(), userInstance?.territory))
				{
					territoriesList.add(userInstance?.territory)
				}
			}
			
			def source = (params.source == "firstsetup")?"firstsetup":"setup"
			render(template: "editsetup", model: [user: userInstance, source: source, roleInstance: roleInstance, geoGroupList: geoGroupList.toList().sort {it?.name}, primaryTerritoriesList: primaryTerritoriesList.toList().sort {it?.name}, territoriesList: territoriesList.toList()?.sort {it?.name}, secondaryTerritories: secondaryTerritories.toList()]);
		}
	}

	def update =
	{
		User user = User.get(params.id)
		boolean usernameAvailable = false
		boolean emailAvailable = false
		def phone = ""
		if(params.phone!="" && params.phoneCountry!="")
		{
			phone = phoneNumberService.getValidatedPhonenumber(params.phone, params.phoneCountry)
		}
		
		if (!user) {
			  log.warn("User identified by id '$params.id' was not located")
			  flash.type = "error"
			  flash.message = message(code: 'nimble.user.nonexistant', args: [params.id])
			  redirect action: edit, id: params.id
		}
		else 
		{
			if(user.username != params.username)
			{
				if(isUsernameAvailable(params.username))
				{
					usernameAvailable = true
				}
			}
			
			if(user.profile.email != params.email)
			{
				if(isEmailAvailable(params.email))
				{
					emailAvailable = true
				}
			}
			
			if(usernameAvailable == true)
			{
				render "username_Available"
			}
			else if(emailAvailable == true)
			{
				render "email_Available"
			}
			else
			{
				boolean proceed = true
				if(phone == "Invalid")
				{
					proceed = false
				}
				else
				{
					params.phone = phone
				}
				
				if(!proceed)
				{
					render "invalid_phone"
				}
				else
				{
					if(params.sourceOfUpdate == "advanceAdministrator")
					{
						/*Map resultMap = [:]
						resultMap["result"] = "success"
						resultMap["phone"] = phone*/
						def result = "success"+phone
						render result//resultMap as JSON
					}
					else
					{
					  def fields = grailsApplication.config.nimble.fields.admin.user
					  def profileFields = grailsApplication.config.nimble.fields.enduser.profile
					  user.properties[fields] = params
					  user.profile.properties[profileFields] = params
					  user.profile.phone = params.phone
					  user.profile.country = params.phoneCountry
					  
					  user.profile.lastUpdated = new Date()
					  user.lastUpdated = new Date()
					  
					  Role role = Role.get(params.roleId.toLong())
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
					  
					  if (!user.validate()) {
							log.debug("Updated details for user [$user.id]$user.username are invalid")
							render view: 'edit', model: [user: user]
					  }
					  else 
					  {
						  Geo primaryTerritory = null
						  def territoriesList = []
						  //*****************Primary Territory for sales users****************************
							   /*Add primary country*/
							   //user.country = params.country
							   if(params.primaryTerritory != null && params.primaryTerritory != "")
							   {
								   primaryTerritory = Geo.get(params.primaryTerritory.toLong())
								   user.primaryTerritory = primaryTerritory
								   
								   if(primaryTerritory?.country == null || primaryTerritory?.country == "NULL" || primaryTerritory?.country == "")
								   {
									   primaryTerritory.country = params.country
									   primaryTerritory.save()
								   }
							   }
						   
						 //*****************************************************************************
						  if(role?.name == "GENERAL MANAGER")
						  {
							  //********************** Assign GeoGroup(geo) for General Manager ****************
							   
								  if(params?.geoGroupId)// != null && params.geoGroupId != "")
								  {
									  def geoGroupInstance =  GeoGroup.get(params?.geoGroupId.toInteger())
									  if(geoGroupInstance)
									  {
										  user.geoGroup = geoGroupInstance
									  }
								  }
							   //******************************************************************************
						  }
						  
						  else if(role?.name == "SALES MANAGER")
						  {
							   //******************* Assign Territories to Sales Manager *************************
								  
								   	if(params?.territoriesList)// != null && params.territoriesList != "")
								   	{
									   	def oldTerritoriesIds = []
										for(Geo territory :  user?.territories)
										{
											oldTerritoriesIds.add(territory.id)
										}
										
										def territoryIdList = []
										List filteredList = generateTerritoryList(params.territoriesList?.toString())
										filteredList.add(primaryTerritory?.id)
										
										for(Object i in filteredList)
										{
											territoryIdList.add(i.toLong())//}
										}
										
										for(Long selectedId : territoryIdList)
										{
											if(oldTerritoriesIds.contains(selectedId)){
												oldTerritoriesIds.remove(selectedId)
											}
											else
											{
												user.addToTerritories(Geo.get(selectedId.toLong()))
											}
										}
										
										for(Long remainingId : oldTerritoriesIds)
										{
											user.removeFromTerritories(Geo.get(remainingId.toLong()))
										}
								   }
								   
								   if(primaryTerritory != null)
								   {
									   user.addToTerritories(primaryTerritory)
								   }
							  
							 //******************************************************************************
						  }
						  else if(role?.name == "SALES PERSON")
						  {
							  
							  if(primaryTerritory != null)
							  {
								  user.territory = primaryTerritory
							  }
							 //******************************************************************************
						  }
						  
						  
						  def updatedUser = userService.updateUser(user)
						  log.info("Successfully updated details for user [$user.id]$user.username")
						  flash.type = "success"
						  
						  if(params.source == "setup" || params.source == "firstsetup"){
							  render "success"
						  }
						  else
						  {
							  flash.message = message(code: 'nimble.user.update.success', args: [user.username])
							  redirect action: show, id: updatedUser.id
						  }
					  }
					}
				}
			}
		}
	}
	
	public List generateTerritoryList(String territoriesList)//geos = territories
	{
		List territoryIds = new ArrayList()
		
		if(territoriesList.size() == 0)
		{
			//allowedStatus.add(defaultStatus)
		}
		else
		{
			if(territoriesList.contains(","))
			{
				List territoryIdList = territoriesList.replace("[", "").replace("]", "").split("\\,")
				for(String Id : territoryIdList)
				{
					territoryIds.add(Id.replaceFirst(" ", ""))
				}
			}
			else
			{
				territoryIds.add(territoriesList)
			}
		}
		
		return territoryIds
	}

	def deletesetup = {
		def userInstance = User.get(params.id)
        if (userInstance) {
            try {
                userInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'user.label', default: 'User'), params.id])}"
				render "success"
			}
			catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'user.label', default: 'User'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), params.id])}"
            redirect(action: "list")
        }
	}

	def delete = {
		def userInstance = User.get(params.id)
        if (userInstance) {
            try {
                userInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'user.label', default: 'User'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'user.label', default: 'User'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), params.id])}"
            redirect(action: "list")
        }
	}

	def validusername = 
	{
		println "coming here"
		if (params?.val == null || params?.val?.length() < 4) {
		  render "fail"
		  //response.status = 500
		}
		else {
			def users = User.findAllByUsername(params?.val)
			if (users != null && users.size() > 0) {
			  render "fail"
			  //response.status = 500
			}
			else {
				render "success"
			}
		}
	  }
	
	def changeProperties =
	{
		def user = User.get(params.id)
		
		render(template: "change", model: [user: user, changeFor: params.userRole])

	}
	def changepassword = {
		def user = User.get(params.id)
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
	def resetPassword = {
		def user = User.get(params.id)
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
	
	def savepassword = 
	{
		def user = User.get(params.id)
		def pwEnc = new Sha256Hash(params.pass_old)
		def crypt = pwEnc.toHex()
		def oldPass = user.properties.passwordHash
		
		if(oldPass != crypt)
		{
			render "not_match"
		}
		else if(oldPass == crypt)
		{
			if (!user)
			{
			  log.warn("User identified by id '$params.id' was not located")
			  flash.type = "error"
			  flash.message = message(code: 'nimble.user.nonexistant', args: [params.id])
			  //redirect action: list
			  render "fail"
			}
			else 
			{
				user.properties['pass', 'passConfirm'] = params
				Map userValidityMap = userService.validatePass(user, true)
				if (!user.validate() || !userValidityMap["isValidPassword"])
				{
					log.debug("Password change for [$user.id]$user.username was invalid")
					//render view: 'changepassword', model: [user: user]
					render userValidityMap["error_message"]
				}
				else 
				{
					def savedUser = userService.changePassword(user)
					log.info("Successfully saved password change for user [$user.id]$user.username")
					flash.type = "success"
					flash.message = message(code: 'nimble.user.password.change.success', args: [params.id])
					//redirect(controller: "home", action: "index")
					//action: show, id: user.id
					render "success"
				}
				
			}
		}
	}
	def reset = 
	{
		try {
			
			render(template: "reset")
		} catch (InvocationTargetException e) {
		
			// Answer:
			e.getCause().printStackTrace();
		} catch (Exception e) {
		
			// generic exception handling
			e.printStackTrace();
		}
			
	}
	def resetPass =
	{
		if(isEmailAvailable(params.email))
		{
			def userProfile = ProfileBase.findByEmail(params.email)
			def user = User.get(userProfile?.owner?.id)
			//println user.username
			//println user
			def message = message(code: "notification.reset.password.message", args: ["${user}", "${user.username}"]);
			sendMailService.sendEmailNotification(message, "Valent Software - Reset Password", [user], request.siteUrl+"/userSetup/resetPassword/"+user.id)
			render "email_Available"
		}
		else
		{
			render "email_Not_Available"
		}
	}
	
	def saveResetPassword = 
	{
		def user = User.get(params.id)
		if (!user)
		{
		  log.warn("User identified by id '$params.id' was not located")
		  flash.type = "error"
		  flash.message = message(code: 'nimble.user.nonexistant', args: [params.id])
		  //redirect action: list
		  render "fail"
		}
		else
		{
			user.properties['pass', 'passConfirm'] = params
			Map userValidityMap = userService.validatePass(user, true)
			if (!user.validate() || !userValidityMap["isValidPassword"])
			{
				log.debug("Password change for [$user.id]$user.username was invalid")
				//render view: 'changepassword', model: [user: user]
				render userValidityMap["error_message"]//"password_available"
			}
			else
			{
				def savedUser = userService.changePassword(user)
				log.info("Successfully saved password change for user [$user.id]$user.username")
				flash.type = "success"
				flash.message = message(code: 'nimble.user.password.change.success', args: [params.id])
				//redirect(controller: "home", action: "index")
				//action: show, id: user.id
				render "success"
			}
			
		}
	}
	def updateTerritoryGeo =
	{
		def result = "fail"
		def user = User.get(params.id)
		
		
		/*if(params.territoryId != null)
		{
			user.territory = Geo.get(params.territoryId)
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
		}*/
		user.save()
		//println params
		loadRoleUserCache();
		//flash.message = "Successfully changed..."
		render "success"
	}

	List getTerritories(User user)//territories of sales manager
	{
		List territoryList = new ArrayList()
		for(Geo territory : user?.territories)
		{
			if(user?.primaryTerritory?.id != territory?.id)
			{
				territoryList.add(territory)
			}
		}
		return territoryList
	}
}
