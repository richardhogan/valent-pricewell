package com.valent.pricewell

/**
 * User profile domain class — personal and contact details.
 *
 * MIGRATION NOTE (Nimble → Spring Security Core):
 *   Previously extended grails.plugins.nimble.core.ProfileBase (Nimble/Shiro-based).
 *   Now self-contained. All fields from ProfileBase have been inlined.
 *   Removed: emailHash (was an MD5 Gravatar hash — unused in this application),
 *   nonVerifiedEmail (Nimble email-verification flow — not used here),
 *   and the beforeInsert/beforeUpdate Md5Hash hooks that depended on Apache Shiro.
 */
class Profile {

    String fullName
    String nickName
    String email
    String phone
    String country

    Date dateCreated
    Date lastUpdated

    // Profile belongs to one User; cascade ensures it is deleted with the user.
    static belongsTo = [owner: User]

    static mapping = {
        cache usage: 'read-write', include: 'all'
        table 'profile'
    }

    static constraints = {
        fullName   nullable: true
        nickName   nullable: true
        email      nullable: true, email: true, unique: true
        phone      nullable: true
        country    nullable: true
        dateCreated nullable: true
        lastUpdated nullable: true
    }

    String toString() { fullName ?: owner?.username }
}
