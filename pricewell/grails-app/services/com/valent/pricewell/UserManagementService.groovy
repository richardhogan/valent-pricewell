package com.valent.pricewell

/**
 * User and role lifecycle operations — replaces the Nimble userService,
 * roleService, permissionService, and adminsService calls that existed in
 * BootStrap.groovy and UserAdminController.
 *
 * Passwords are BCrypt-encoded via springSecurityService.encodePassword(),
 * which respects the algorithm configured in Config.groovy
 * (grails.plugins.springsecurity.password.algorithm = 'bcrypt').
 */
class UserManagementService {

    def springSecurityService
    static transactional = true

    /**
     * Create a new user with a BCrypt-encoded password and a matching Profile.
     * Returns the saved User instance; call user.hasErrors() to check for failures.
     */
    User createUser(String username, String rawPassword, String fullName, String email = null) {
        User user = new User(
            username: username,
            password: springSecurityService.encodePassword(rawPassword),
            enabled : true
        )
        Profile profile = new Profile(
            fullName: fullName,
            email   : email,
            owner   : user
        )
        user.profile = profile
        user.save(flush: true)
        user
    }

    /**
     * Find or create a Role by its Spring Security authority string.
     * The authority must carry the ROLE_ prefix (e.g. "ROLE_SYSTEM_ADMINISTRATOR").
     * Idempotent — safe to call on every startup.
     */
    Role findOrCreateRole(String authority, String description = null, String code = null) {
        Role role = Role.findByAuthority(authority)
        if (!role) {
            role = new Role(
                authority  : authority,
                description: description ?: authority,
                code       : code
            )
            role.save(flush: true, failOnError: true)
        }
        role
    }

    /**
     * Assign a role to a user. Idempotent — does nothing if the user already holds
     * the role. Returns the existing or newly created UserRole instance.
     */
    UserRole assignRole(User user, Role role) {
        UserRole existing = UserRole.findByUserAndRole(user, role)
        if (existing) return existing
        UserRole.create(user, role, true)
    }

    /**
     * Remove a role from a user. Does nothing if the assignment does not exist.
     */
    void revokeRole(User user, Role role) {
        UserRole.remove(user, role, true)
    }

    /**
     * Re-encode a user's password with BCrypt and clear the passwordExpired flag.
     * Use this to migrate existing users from the legacy SHA-256 (Nimble) hash.
     */
    void resetPassword(User user, String rawPassword) {
        user.password        = springSecurityService.encodePassword(rawPassword)
        user.passwordExpired = false
        user.save(flush: true, failOnError: true)
    }
}
