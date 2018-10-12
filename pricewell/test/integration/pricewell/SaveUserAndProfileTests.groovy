package pricewell

import static org.junit.Assert.*

import com.valent.pricewell.User
import grails.plugins.nimble.core.ProfileBase
import grails.plugins.nimble.core.Role
import grails.plugins.nimble.core.UserBase
import org.junit.*
import grails.plugins.nimble.InstanceGenerator

class SaveUserAndProfileTests {

	def userService
    @Before
    void setUp() {
        // Setup logic here
    }

    @After
    void tearDown() {
        // Tear down logic here
    }

    @Test
    void testSomething() {
        //fail "Implement me"
		
		Role userRole = Role.findByName("USER")
		Role pmanagerRole = Role.findByName("PORTFOLIO MANAGER")
		println "Role name is : " + userRole.name
		println "Role name is : " + pmanagerRole.name
		
		User user = new User(profile: new ProfileBase())
		user.username = "pmanager"
		user.pass = "admiN123!"
		user.passConfirm = "admiN123!"
		user.lastUpdated = new Date()
		user.dateCreated = new Date()
		user.enabled = true
		user.external = false
		
		/*if(!user.hasErrors())
		{
			user.save()
			println "user saved successfully"
			println user.username
		}
		else println "there is an error in user"*/
		
		
		ProfileBase profile = user.profile
		profile.fullName = "Portfolio Manager"
		profile.email = "pmanager@valent-software.com"
		profile.phone = "09638793021"
		profile.country = "ind"
		profile.lastUpdated = new Date()
		profile.dateCreated = new Date()
		//profile.owner = user
		
		/*if(!profile.hasErrors())
		{
			profile.save()
			println "profile saved successfully"
			println profile.fullName
			println profile.owner.username
		}
		else println "there is an error in profile"*/

		//user.profile = profile
		user.addToRoles(pmanagerRole)
		user.addToRoles(userRole)
		
		/*if(!user.hasErrors())
		{
			user.save()
			println "user saved successfully with profile and its roles"
			println user.username +" --> "+ user.profile.fullName + " with role --> " + user.roles.toList() 
		}
		else
		{
			for(def error : user.errors)
			{
				println error
			}
			//println "there is an error in user"
		} */
		
		def savedUser = userService.createUser(user)
		
		if (savedUser == "defalutRoleLocate" || savedUser == "defalutRoleAssign" || savedUser == "defalutPermissionsAssign")//.hasErrors())
		{
			  log.info("Failed to save new user")
			  
				  if(savedUser == "defalutRoleLocate")
				  {
					  println "Could not find default role 'USER' internally, please reload and try again."
				  }
				  else if(savedUser == "defalutRoleAssign")
				  {
					  println "Could not assing default role 'USER' to the creating user internally, please reload and try again."
				  }
				  else if(savedUser == "defalutPermissionsAssign")
				  {
					  println "Could not assign default permission to the creating user internally, please reload and try again."
				  }
				
		}
		else
		{
			println "user saved successfully"
			println savedUser.username
			
			println "profile saved successfully"
			println savedUser.profile.fullName
		}
		
		println "over"
    }
}
