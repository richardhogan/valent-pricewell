package grails.plugins.nimble.core

import com.valent.pricewell.User

/**
 * Audit record of a user login event.
 *
 * MIGRATION NOTE (Nimble → Spring Security Core):
 *   Nimble used ConfigurationHolder.config.nimble.tablenames.loginrecord for the
 *   table name, which required the Nimble plugin context. That has been replaced
 *   with an explicit table name so this class compiles without the Nimble plugin.
 *   The belongsTo association is now against com.valent.pricewell.User directly
 *   (previously grails.plugins.nimble.core.UserBase).
 */
class LoginRecord {

    String remoteAddr
    String remoteHost
    String userAgent

    Date dateCreated
    Date lastUpdated

    static belongsTo = [owner: User]

    static mapping = {
        table 'login_record'
    }

    static constraints = {
        remoteAddr  blank: false
        remoteHost  blank: false
        userAgent   blank: false
        dateCreated nullable: true
        lastUpdated nullable: true
    }
}
