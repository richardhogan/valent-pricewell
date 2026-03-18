package grails.plugins.nimble.core

/**
 * Application role / authority domain class.
 *
 * MIGRATION NOTE (Nimble → Spring Security Core):
 *   The package name is intentionally kept as grails.plugins.nimble.core so that
 *   the many existing references throughout the codebase (controllers, services,
 *   BootStrap) do not need to be updated for this class alone.
 *   The Nimble plugin dependency and ConfigurationHolder have been removed.
 *
 *   Key change: field 'name' → 'authority'.
 *   Spring Security Core requires the authority field to hold a string with the
 *   ROLE_ prefix (e.g. "ROLE_SALES_PERSON"). PricewellSecurity.hasRole() and
 *   UserManagementService.createRole() handle the conversion from the legacy
 *   human-readable names (e.g. "SALES PERSON") stored in RoleId.code.
 *
 *   The following Nimble-specific associations have been removed as they are
 *   no longer needed: groups, permissions (Shiro WildcardPermissions).
 *   Role-to-user assignment is now managed via UserRole join domain.
 */
class Role {

    /**
     * Spring Security authority string. Must carry the ROLE_ prefix.
     * Examples: "ROLE_SYSTEM_ADMINISTRATOR", "ROLE_SALES_PERSON".
     * (Previously the 'name' field held the human-readable label e.g. "SALES PERSON".)
     */
    String authority

    /** Human-readable label retained for display in the admin UI. */
    String description

    /**
     * Short code that maps to RoleId enum values.
     * Retained so that BootStrap and UserManagementService can look roles up
     * by their legacy code without needing to know the ROLE_ prefix format.
     */
    String code

    /**
     * When true, this role cannot be deleted or renamed through the admin UI.
     * Used to protect the SYSTEM ADMINISTRATOR role from accidental removal.
     */
    boolean protect = false

    Date dateCreated
    Date lastUpdated

    static mapping = {
        cache usage: 'read-write', include: 'all'
        // Table name kept as the original Nimble table so no DB migration is needed
        // for the role table itself (only the user_role join table changes).
        table 'role'
    }

    static constraints = {
        authority    blank: false, unique: true
        description  nullable: true
        code         nullable: true
        dateCreated  nullable: true
        lastUpdated  nullable: true
    }

    String toString() { authority }
}
