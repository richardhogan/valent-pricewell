/**
 * NimbleSecurityFilters — replaced by Spring Security Core interceptUrlMap.
 *
 * Access control rules previously defined here as Nimble/Shiro accessControl {}
 * blocks are now declared in Config.groovy under
 * grails.plugins.springsecurity.interceptUrlMap.
 *
 * This class is retained as an empty no-op to avoid a "filters class not found"
 * startup error in case any compiled artifact references it. It will be deleted
 * in the final cleanup phase.
 */
class NimbleSecurityFilters {
    def filters = {
        // All access control now handled by Spring Security interceptUrlMap (Config.groovy).
    }
}
