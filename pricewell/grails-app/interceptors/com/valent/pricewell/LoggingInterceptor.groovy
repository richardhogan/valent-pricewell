package com.valent.pricewell

/**
 * Grails 7 interceptor that replaces the beforeInterceptor closure pattern
 * removed in Grails 3+. Logs every request with the current user's name,
 * controller, action, and params.
 *
 * Migration note: In Grails 2, each controller had:
 *   def beforeInterceptor = [action: this.&debug]
 *   def debug() { log.info(...) }
 * These have been removed from all controllers and replaced by this central interceptor.
 */
class LoggingInterceptor {

    LoggingInterceptor() {
        matchAll()
    }

    boolean before() {
        def user = PricewellSecurity.currentUser
        log.info("[User: ${user?.profile?.fullName}] - ${controllerName}/${actionName} params=${params}")
        true
    }

    boolean after() { true }

    void afterView() {}
}
