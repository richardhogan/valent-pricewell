package com.valent.pricewell

import grails.plugin.springsecurity.SpringSecurityUtils
import grails.util.Holders

/**
 * Static security helper — replaces direct Apache Shiro / Nimble SecurityUtils
 * calls throughout the application.
 *
 * MIGRATION RATIONALE:
 *   The Nimble plugin exposed Apache Shiro's SecurityUtils.subject API which was
 *   called in 60+ controllers, 15+ services, and 29 GSP views with patterns like:
 *
 *     SecurityUtils.subject.hasRole("SALES PERSON")
 *     SecurityUtils.subject.isPermitted("service:create")
 *     User.get(new Long(SecurityUtils.subject.principal))
 *
 *   Rather than injecting springSecurityService into every one of those files,
 *   this class provides equivalent static methods that wrap the Spring Security
 *   Core API. The change to each file is then limited to:
 *
 *     1. Replace import org.apache.shiro.SecurityUtils
 *        →  import com.valent.pricewell.PricewellSecurity
 *
 *     2. Replace SecurityUtils.subject.hasRole("X")
 *        →  PricewellSecurity.hasRole("X")
 *
 *     3. Replace SecurityUtils.subject.isPermitted("x:y")
 *        →  PricewellSecurity.isPermitted("x:y")
 *
 *     4. Replace User.get(new Long(SecurityUtils.subject.principal))
 *        →  PricewellSecurity.currentUser
 *
 *     5. Replace SecurityUtils.subject.principal
 *        →  PricewellSecurity.principalId
 *
 * PERMISSION → ROLE MAPPING:
 *   Nimble used Apache Shiro's WildcardPermission model (e.g. "service:create").
 *   Spring Security Core uses role-based access only. The table below maps each
 *   permission string to the roles that were granted that permission in BootStrap.groovy
 *   (initializeRoles). isPermitted() uses this map to call SpringSecurityUtils.ifAnyGranted().
 */
class PricewellSecurity {

    /**
     * Maps the Nimble/Shiro permission strings (used by the old isPermitted() calls)
     * to the comma-separated Spring Security role authority strings that have those permissions.
     * Based on the role permission assignments in BootStrap.groovy::initializeRoles().
     */
    static final Map<String, String> PERMISSION_ROLE_MAP = [
        'service:create'        : 'ROLE_PORTFOLIO_MANAGER,ROLE_SYSTEM_ADMINISTRATOR',
        'portfolio:update'      : 'ROLE_PORTFOLIO_MANAGER,ROLE_SYSTEM_ADMINISTRATOR',
        'portfolio:create'      : 'ROLE_PORTFOLIO_MANAGER,ROLE_SYSTEM_ADMINISTRATOR',
        'deliveryRole:create'   : 'ROLE_DELIVERY_ROLE_MANAGER,ROLE_SYSTEM_ADMINISTRATOR',
        'geo:create'            : 'ROLE_DELIVERY_ROLE_MANAGER,ROLE_SYSTEM_ADMINISTRATOR,ROLE_GENERAL_MANAGER,ROLE_SALES_PRESIDENT',
        'geo:edit'              : 'ROLE_DELIVERY_ROLE_MANAGER,ROLE_SYSTEM_ADMINISTRATOR,ROLE_GENERAL_MANAGER,ROLE_SALES_PRESIDENT',
        'geo:show'              : 'ROLE_DELIVERY_ROLE_MANAGER,ROLE_SYSTEM_ADMINISTRATOR,ROLE_GENERAL_MANAGER,ROLE_SALES_PRESIDENT,ROLE_SALES_MANAGER,ROLE_PORTFOLIO_MANAGER',
        'geo:delete'            : 'ROLE_DELIVERY_ROLE_MANAGER,ROLE_SYSTEM_ADMINISTRATOR,ROLE_GENERAL_MANAGER,ROLE_SALES_PRESIDENT',
        'reports:show'          : 'ROLE_PORTFOLIO_MANAGER,ROLE_SYSTEM_ADMINISTRATOR',
        'quotation:create'      : 'ROLE_SALES_PERSON,ROLE_SALES_MANAGER,ROLE_SALES_PRESIDENT,ROLE_GENERAL_MANAGER,ROLE_SYSTEM_ADMINISTRATOR',
        'sowIntroduction:create': 'ROLE_SALES_PERSON,ROLE_SALES_MANAGER,ROLE_SYSTEM_ADMINISTRATOR',
    ].asImmutable()

    /**
     * Retrieve the springSecurityService bean from the Grails application context.
     * Uses ApplicationHolder so this class can be used without injecting the service
     * into every caller.
     */
    private static def getSpringSecurityService() {
        Holders.applicationContext?.getBean('springSecurityService')
    }

    /**
     * Returns the ID (Long) of the currently authenticated user, or null if not
     * authenticated. Replaces: SecurityUtils.subject.principal
     *
     * The GrailsUser principal returned by AppUserDetailsService carries the
     * domain object id in its constructor, so no DB query is needed here.
     */
    static Long getPrincipalId() {
        springSecurityService?.principal?.id as Long
    }

    /**
     * Returns the currently authenticated User domain object, or null if not
     * authenticated. Replaces: User.get(new Long(SecurityUtils.subject.principal))
     */
    static User getCurrentUser() {
        Long id = principalId
        id ? User.get(id) : null
    }

    /**
     * Returns true if the current user holds the given role.
     * Accepts the legacy human-readable role name format (e.g. "SALES PERSON")
     * OR the ROLE_-prefixed format (e.g. "ROLE_SALES_PERSON") — both work.
     * Replaces: SecurityUtils.subject.hasRole("SALES PERSON")
     *
     * Conversion: "SALES PERSON" → "ROLE_SALES_PERSON" (uppercase, spaces→underscores, ROLE_ prefix).
     */
    static boolean hasRole(String roleName) {
        if (!roleName) return false
        // Normalise to ROLE_ format if not already prefixed
        String authority = roleName.startsWith('ROLE_')
            ? roleName
            : 'ROLE_' + roleName.toUpperCase().replace(' ', '_')
        SpringSecurityUtils.ifAnyGranted(authority)
    }

    /**
     * Returns true if the current user has (at least) the roles that grant the
     * given Shiro-style permission string. Replaces: SecurityUtils.subject.isPermitted("x:y")
     *
     * The mapping from permission string to roles is defined in PERMISSION_ROLE_MAP above.
     * Returns false for any unrecognised permission string.
     */
    static boolean isPermitted(String permission) {
        String roles = PERMISSION_ROLE_MAP[permission]
        roles ? SpringSecurityUtils.ifAnyGranted(roles) : false
    }

    /**
     * Returns true if the current request has an authenticated (non-anonymous) session.
     * Replaces: SecurityUtils.subject.isAuthenticated()
     */
    static boolean isLoggedIn() {
        springSecurityService?.isLoggedIn() ?: false
    }
}
