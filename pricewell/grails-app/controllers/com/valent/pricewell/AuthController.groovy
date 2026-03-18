package com.valent.pricewell

import grails.plugins.springsecurity.SpringSecurityUtils

/**
 * Authentication controller — login, logout, and access-denied handling.
 *
 * Replaces grails.plugins.nimble.core.AuthController from the Nimble plugin.
 * Spring Security Core handles the actual credential verification by intercepting
 * POST /j_spring_security_check internally; this controller only:
 *   - Renders the login form (GET /auth/login)
 *   - Handles the access-denied page (GET /auth/denied)
 *   - Provides a logout action stub (Spring Security intercepts the POST)
 */
class AuthController {

    def springSecurityService

    /**
     * Render the login page.
     * If the user is already authenticated, redirect to the application home page
     * to avoid showing the login form unnecessarily.
     */
    def login() {
        if (springSecurityService.isLoggedIn()) {
            // Already logged in — bounce to the configured post-login URL or home
            def targetUrl = SpringSecurityUtils.securityConfig
                                .successHandler?.defaultTargetUrl ?: '/'
            redirect uri: targetUrl
            return
        }
        // Pass a flag so the view can show an error message on failed login attempts.
        [loginError: (params.login_error == '1')]
    }

    /**
     * Logout stub — the real logout is handled by Spring Security's
     * LogoutFilter which intercepts POST /j_spring_security_logout.
     * This action is only reached if the filter is bypassed (e.g. a GET),
     * in which case we redirect to the login page.
     */
    def logout() {
        redirect action: 'login'
    }

    /**
     * Access-denied page shown when a user tries to access a resource
     * for which they lack the required role.
     * Configured via: grails.plugins.springsecurity.adh.errorPage = '/auth/denied'
     */
    def denied() { }
}
