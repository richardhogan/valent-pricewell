package com.valent.pricewell

/**
 * Join domain between User and Role for Spring Security Core.
 *
 * MIGRATION NOTE (Nimble → Spring Security Core):
 *   Nimble used a hasMany=[roles: Role] relationship on UserBase with a Hibernate
 *   join table managed by Shiro. Spring Security Core requires an explicit join
 *   domain class so it can efficiently load user authorities via UserRole.findAllByUser().
 *   This class replaces that implicit join table.
 */
class UserRole implements Serializable {

    User user
    Role role

    static constraints = {
        user nullable: false
        role nullable: false
        // Enforce uniqueness at the domain level (composite key also enforces it at DB level).
        role unique: 'user'
    }

    static mapping = {
        // Composite primary key on (user_id, role_id) — no surrogate id column.
        id    composite: ['user', 'role']
        // Disable optimistic locking version column — unnecessary on a pure join table.
        version false
    }

    /**
     * Convenience method: assign a role to a user and persist the relationship.
     * Idempotent — does nothing if the user already has the role.
     */
    static UserRole create(User user, Role role, boolean flush = false) {
        UserRole instance = new UserRole(user: user, role: role)
        instance.save(flush: flush, insert: true)
        instance
    }

    /**
     * Convenience method: remove a role from a user and delete the relationship.
     * Does nothing if the assignment does not exist.
     */
    static void remove(User user, Role role, boolean flush = false) {
        UserRole instance = UserRole.findByUserAndRole(user, role)
        instance?.delete(flush: flush)
    }

    String toString() { "UserRole(${user?.username}, ${role?.authority})" }
}
