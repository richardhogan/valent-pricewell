package com.valent.pricewell

import grails.plugins.nimble.core.Role

/**
 * Manages user accounts for the /administration/users/* URLs.
 *
 * Ported from nimble/grails-app/controllers/.../UserController.groovy
 * to work with Spring Security Core 7.x and the migrated domain model.
 */
class UserController {

    static defaultAction = 'list'

    def userManagementService

    def list() {
        if (!params.sort) {
            params.sort = 'username'
        }
        def users = User.list(sort: 'username', order: 'asc')
        // Attach roles to each user for the view (avoids N+1 in GSP)
        def userRolesMap = [:]
        users.each { user ->
            userRolesMap[user.id] = UserRole.findAllByUser(user)*.role
        }
        [users: users, userRolesMap: userRolesMap]
    }

    def show() {
        def user = User.get(params.id)
        if (!user) {
            flash.message = "User not found with id ${params.id}"
            redirect action: 'list'
            return
        }
        def roles = UserRole.findAllByUser(user)*.role
        [user: user, roles: roles]
    }

    def create() {
        [user: new User()]
    }

    def save() {
        def result = 'fail'
        def user = new User()
        user.username = params.username
        user.password = params.pass ?: ''
        user.enabled = true
        user.profile = new Profile()
        user.profile.fullName = params.fullName
        user.profile.email = params.email
        user.profile.phone = params.phone
        user.profile.country = params.phoneCountry

        if (user.validate() && user.save(flush: true)) {
            result = 'success'
        }
        render result
    }

    def enable() {
        def user = User.get(params.id)
        if (!user) {
            render "User not found"
            response.status = 500
            return
        }
        user.enabled = true
        user.save(flush: true)
        render "User ${user.username} enabled"
    }

    def disable() {
        def user = User.get(params.id)
        if (!user) {
            render "User not found"
            response.status = 500
            return
        }
        user.enabled = false
        user.save(flush: true)
        render "User ${user.username} disabled"
    }

    def changepassword() {
        def user = User.get(params.id)
        if (!user) {
            flash.message = "User not found"
            redirect action: 'list'
            return
        }
        [user: user]
    }

    def savepassword() {
        def user = User.get(params.id)
        if (!user) {
            flash.message = "User not found"
            redirect action: 'list'
            return
        }
        if (params.pass && params.pass == params.passConfirm) {
            userManagementService.resetPassword(user, params.pass)
            flash.message = "Password changed for ${user.username}"
            redirect action: 'show', id: user.id
        } else {
            flash.message = "Passwords do not match"
            render view: 'changepassword', model: [user: user]
        }
    }
}
