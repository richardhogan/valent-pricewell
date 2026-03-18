package com.valent.pricewell

import org.springframework.security.core.GrantedAuthority
import org.springframework.security.core.authority.GrantedAuthorityImpl

/**
 * Application user domain class.
 *
 * MIGRATION NOTE (Nimble → Spring Security Core):
 *   Previously extended grails.plugins.nimble.core.UserBase (Apache Shiro-based).
 *   Now self-contained, implementing the Spring Security UserDetails contract via
 *   getAuthorities(). All fields from UserBase have been inlined here.
 *   The field formerly named 'passwordHash' is now 'password' to match the
 *   Spring Security naming convention expected by AppUserDetailsService.
 *   Nimble-specific fields (federated, external, realm, federationProvider,
 *   passwdHistory, follows, followers, groups, permissions) have been removed —
 *   federation was disabled in NimbleConfig and permissions are now role-based only.
 */
class User {

    // --- Authentication fields (required by Spring Security Core 1.2.x) ---

    /** Login username. */
    String  username

    /**
     * BCrypt-encoded password.
     * Renamed from 'passwordHash' (Nimble/SHA-256) to 'password' (Spring Security).
     * BCrypt is now used for all passwords. Existing production users will have
     * passwordExpired=true set during migration, forcing a password reset on next login.
     */
    String  password

    boolean enabled         = true
    boolean accountExpired  = false
    boolean accountLocked   = false

    /**
     * When true, Spring Security redirects the user to the change-password page
     * on their next login. Set to true for all existing users during migration
     * from Nimble/SHA-256 so they obtain a new BCrypt hash.
     */
    boolean passwordExpired = false

    // --- Nimble fields retained for application use ---

    /** Token for password-reset and email-verification flows. */
    String  actionHash

    /** Account expiry date. Null = never expires. */
    Date    expiration

    /** Enables remote API access for this account. */
    boolean remoteapi       = false

    /** Last role the user chose when logging in (stored for UI preferences). */
    String  lastLoginRole

    // --- Pricewell business fields ---

    /** Primary sales territory (all sales roles). */
    Geo      primaryTerritory

    /** Active territory assignment (SALES_PERSON). */
    Geo      territory

    /** Geographic group scope (GENERAL_MANAGER). */
    GeoGroup geoGroup

    /** Direct manager / supervisor reference. */
    User     supervisor

    // --- Timestamps ---
    Date dateCreated
    Date dateModified

    // --- Associations ---

    static hasOne  = [profile: Profile]
    static hasMany = [
        loginRecords : LoginRecord,
        territories  : Geo,    // SALES_MANAGER multi-territory assignment
        quotas       : Quota
    ]

    static mappedBy = [
        territories : "salesManager",
        quotas      : "person"
    ]

    static mapping = {
        sort username: 'desc'
        cache usage: 'read-write', include: 'all'
        profile    lazy: false, cascade: 'all'
        supervisor lazy: false
        quotas     lazy: false
    }

    static constraints = {
        username         blank: false, unique: true, minSize: 4, maxSize: 255
        password         blank: false
        actionHash       nullable: true
        expiration       nullable: true
        lastLoginRole    nullable: true
        primaryTerritory nullable: true
        territory        nullable: true
        territories      nullable: true
        geoGroup         nullable: true
        supervisor       nullable: true
        quotas           nullable: true
        dateCreated      nullable: true
        dateModified     nullable: true
    }

    // Transient helpers used during user creation / password change — never persisted.
    static transients = ['pass', 'passConfirm']
    String pass
    String passConfirm

    /**
     * Returns the Spring Security GrantedAuthority set for this user.
     * Queries the UserRole join table so that role assignments are always current.
     * Authority strings use the ROLE_ prefix required by Spring Security
     * (e.g. "ROLE_SALES_PERSON"). PricewellSecurity.hasRole() handles conversion
     * from the legacy human-readable names used throughout the rest of the code.
     */
    Set<GrantedAuthority> getAuthorities() {
        UserRole.findAllByUser(this).collect { ur ->
            new GrantedAuthorityImpl(ur.role.authority)
        } as Set
    }

    String toString() {
        profile?.fullName ?: username
    }
}
