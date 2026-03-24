package com.valent.pricewell

import grails.plugin.springsecurity.userdetails.GrailsUser
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.security.core.userdetails.UserDetailsService
import org.springframework.security.core.userdetails.UsernameNotFoundException

/**
 * Spring Security UserDetailsService implementation.
 *
 * Bridges the com.valent.pricewell.User domain class to the Spring Security
 * authentication pipeline. Called by Spring Security's DaoAuthenticationProvider
 * when a login attempt is made.
 *
 * Replaces the Apache Shiro LocalizedRealm from the Nimble plugin, which handled
 * credential verification via Shiro's authentication framework.
 *
 * Registered as the primary userDetailsService bean in resources.groovy so
 * Spring Security Core uses this implementation instead of its default
 * GormUserDetailsService (which uses a fixed 'roles' association rather than
 * our UserRole join domain).
 */
class AppUserDetailsService implements UserDetailsService {

    /**
     * Load a user by username for Spring Security to authenticate against.
     *
     * @param username the username submitted in the login form
     * @return a GrailsUser (UserDetails) with credentials and granted authorities
     * @throws UsernameNotFoundException if no matching User is found
     */
    @Override
    UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = User.findByUsername(username)
        if (!user) {
            // Throwing UsernameNotFoundException tells Spring Security to show
            // a generic "bad credentials" error (not a "user not found" message
            // which would be an account enumeration vulnerability).
            throw new UsernameNotFoundException("User '$username' not found")
        }

        // GrailsUser (from spring-security-core) extends Spring's User class and
        // carries the domain object's id so springSecurityService.currentUser can
        // look it up efficiently without a second DB query.
        new GrailsUser(
            user.username,
            user.password,
            user.enabled,
            !user.accountExpired,
            !user.passwordExpired,
            !user.accountLocked,
            user.authorities,  // calls User.getAuthorities() → UserRole join query
            user.id
        )
    }
}
