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

/**
 * Represents generic details about users that are useful to many applications
 *
 * @author Bradley Beddoes
 */
class ProfileBase {

    String fullName
    String nickName
    String email
    String nonVerifiedEmail
    String emailHash
	String phone
	String country

    Date dateCreated
    Date lastUpdated

    def beforeInsert() {
        hashEmail()
    }

    def beforeUpdate() {
        hashEmail()
    }

    def hashEmail() {
        // MD5 email hashing (Gravatar) removed — Md5Hash was Apache Shiro, which is no longer a dependency.
        // emailHash field kept for DB schema compatibility only.
    }
    
    static belongsTo = [owner: com.valent.pricewell.User]

    static mapping = {
        cache usage: 'read-write', include: 'all'
        table 'profile_base'
    }

    static constraints = {
        fullName(nullable: true, blank: false)
        nickName(nullable: true, blank: false)
        email(nullable:true, blank:false, email: true, unique: true)
        nonVerifiedEmail(nullable:true, blank:false, email: true)
        emailHash(nullable: true, blank:true)
        dateCreated(nullable: true) // must be true to enable grails
        lastUpdated(nullable: true) // auto-inject to be useful which occurs post validation
		
		phone(nullable: true)
		country(nullable: true)
    }
}
