package com.valent.pricewell

import org.springframework.beans.BeansException
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory
import org.springframework.beans.factory.support.BeanDefinitionRegistry
import org.springframework.beans.factory.support.BeanDefinitionRegistryPostProcessor
import org.springframework.beans.factory.support.GenericBeanDefinition
import org.springframework.context.annotation.Configuration
import org.springframework.security.crypto.factory.PasswordEncoderFactories

/**
 * Overrides the Spring Security Core plugin's default passwordEncoder bean.
 *
 * The Grails Spring Security Core plugin creates a DelegatingPasswordEncoder in
 * doWithSpring(), but in Grails 7 / Spring Boot 3.x the encoder map built by
 * idToPasswordEncoder() does not include 'bcrypt', causing password matches to fail
 * with "Given that there is no default password encoder configured...".
 *
 * Using BeanDefinitionRegistryPostProcessor here is intentional: it runs AFTER
 * Grails plugin doWithSpring() beans are registered (which happens during the
 * ApplicationContextInitializer phase), so our override wins.
 *
 * PasswordEncoderFactories.createDelegatingPasswordEncoder() registers all standard
 * encoders including {bcrypt}, {noop}, {SHA-256}, {pbkdf2}, {scrypt}, {argon2}.
 */
@Configuration
class SecurityBeansOverride implements BeanDefinitionRegistryPostProcessor {

    @Override
    void postProcessBeanDefinitionRegistry(BeanDefinitionRegistry registry) throws BeansException {
        def beanDef = new GenericBeanDefinition()
        beanDef.setBeanClass(PasswordEncoderFactories)
        beanDef.setFactoryMethodName('createDelegatingPasswordEncoder')
        beanDef.setPrimary(true)
        registry.registerBeanDefinition('passwordEncoder', beanDef)
    }

    @Override
    void postProcessBeanFactory(ConfigurableListableBeanFactory beanFactory) throws BeansException {}
}
