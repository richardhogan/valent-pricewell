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
import com.valent.pricewell.GeoGroup
import com.valent.pricewell.Geo
import com.valent.pricewell.Quota

import org.codehaus.groovy.grails.commons.ConfigurationHolder

/**
 * Represents a user within a Nimble Application
 *
 * @author Bradley Beddoes
 */

@SuppressWarnings("deprecation")
class UserBase {

    String username
	String realm
    String passwordHash
    String actionHash

    boolean enabled
    boolean external
    boolean federated
    boolean remoteapi = false

    FederationProvider federationProvider
    ProfileBase profile

    Date expiration
    Date dateCreated
    Date lastUpdated
	
	//String country // for all sales users
	Geo primaryTerritory//for all sales users
	UserBase supervisor
	
	Geo territory //for sales person
	GeoGroup geoGroup //for general manager
	
	String lastLoginRole
	
    static belongsTo = [Role, Group]
		
    static hasMany = [
        passwdHistory: String,
        loginRecords: LoginRecord,
        follows: UserBase,
        followers: UserBase,
        roles: Role,
        groups: Group,
        permissions: Permission,
		salesManagers: UserBase,
		members: UserBase, 
		territories: Geo ,//for sales manager
		quotas: Quota
    ]

	static mappedBy = [members: "supervisor", territories: "salesManager", quotas: "person"]
		
	
    static fetchMode = [
        roles: 'eager',
        groups: 'eager'
    ]

    static mapping = {
        sort username:'desc'
    
        cache usage: 'read-write', include: 'all'
        table ConfigurationHolder.config.nimble.tablenames.user

		profile lazy: false, cascade: 'all'

		supervisor lazy:false
		members lazy:false
		quotas lazy:false
        roles cache: true, cascade: 'none'
        groups cache: true, cascade: 'none'
        permissions cache: true
    }

    static constraints = {
        username(blank: false, unique: true, minSize: 4, maxSize: 255)
        passwordHash(nullable: true, blank: false)
        actionHash(nullable: true, blank: false)
		realm(nullable: true, blank: false)
   
        federationProvider(nullable: true)
        profile(nullable:false)
        
        expiration(nullable: true)

        dateCreated(nullable: true) // must be true to enable grails
        lastUpdated(nullable: true) // auto-inject to be useful which occurs post validation

        permissions(nullable:true)
		
		supervisor(nullable: true)
		
		//country(nullable: true)
		primaryTerritory(nullable: true)
		salesManagers(nullable: true)
		members(nullable: true)
		
		territory(nullable: true)
		territories(nullable: true)
		geoGroup(nullable: true)
		quotas(nullable: true)
		
		lastLoginRole(nullable: true)
    }

    // Transients
    static transients = ['pass', 'passConfirm']
    String pass
    String passConfirm
	
	private boolean hasRole(def roleName)
	{
		this.roles.each {
			if (it.name.equals(roleName))
			{
				return true
			}
		}
		return false
	}

}
