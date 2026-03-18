/**
 * NimbleBootStrap — gutted as part of the Nimble → Spring Security Core migration.
 *
 * All user/role bootstrap logic has been moved to BootStrap.groovy using
 * UserManagementService. This file is retained as an empty shell because some
 * code paths may still reference it; it will be deleted in the final cleanup phase
 * once the codebase no longer depends on it.
 */
class NimbleBootStrap {

    def init = { servletContext ->
        // No-op: bootstrap handled by BootStrap.groovy / UserManagementService
    }

    def destroy = {}
}
