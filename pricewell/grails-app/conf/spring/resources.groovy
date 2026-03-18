beans = {

    /*
     * Register AppUserDetailsService as the Spring Security userDetailsService bean.
     *
     * This overrides the default GormUserDetailsService provided by
     * spring-security-core so that authentication uses our custom
     * AppUserDetailsService, which loads User via the UserRole join domain
     * (rather than a direct 'roles' hasMany association).
     *
     * Spring Security Core picks up a bean named 'userDetailsService' automatically.
     */
    userDetailsService(com.valent.pricewell.AppUserDetailsService)
}
