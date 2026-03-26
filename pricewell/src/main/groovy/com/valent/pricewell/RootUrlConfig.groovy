package com.valent.pricewell

import org.springframework.context.annotation.Configuration
import org.springframework.core.Ordered
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer

/**
 * Registers a redirect from "/" to "/home/index" so that Spring Boot's
 * WelcomePageHandlerMapping (order=2) does not intercept the root URL before
 * Grails URL mappings can handle it.  A view controller redirect has order=1
 * by default, which wins over WelcomePageHandlerMapping.
 */
@Configuration
class RootUrlConfig implements WebMvcConfigurer {

    @Override
    void addViewControllers(ViewControllerRegistry registry) {
        registry.addRedirectViewController('/', '/home/index').setKeepQueryParams(true)
        registry.setOrder(Ordered.HIGHEST_PRECEDENCE)
    }
}
