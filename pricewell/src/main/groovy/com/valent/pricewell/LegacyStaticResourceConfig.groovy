package com.valent.pricewell

import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.Configuration
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer

/**
 * Maps legacy Grails 2 static asset paths to Grails 7 asset pipeline locations.
 *
 * In Grails 2, static files lived under web-app/images/, web-app/js/, web-app/css/.
 * In Grails 7 they are in grails-app/assets/ and served by the asset pipeline at /assets/.
 * Many GSP views still reference /images/, /js/, /css/ directly via ${baseurl}/... patterns.
 *
 * URL mappings added:
 *   /images/** -> assets/images/
 *   /js/**     -> assets/javascripts/
 *   /css/**    -> assets/stylesheets/
 *
 * In dev mode (bootRun) the Grails base.dir system property points at the grails-app directory
 * so files are served directly from source.  In production the compiled assets are on the
 * classpath under assets/ (put there by the asset-pipeline Gradle plugin).
 */
@Configuration
class LegacyStaticResourceConfig implements WebMvcConfigurer {

    /** Set by Grails bootRun to the subproject root, e.g. .../pricewell. Empty in WAR deployment. */
    @Value('${base.dir:}')
    String baseDir

    @Override
    void addResourceHandlers(ResourceHandlerRegistry registry) {
        addLegacyHandler(registry, '/images/**', 'images')
        addLegacyHandler(registry, '/js/**',     'javascripts')
        addLegacyHandler(registry, '/css/**',    'stylesheets')
    }

    private void addLegacyHandler(ResourceHandlerRegistry registry, String pattern, String assetSubdir) {
        List<String> locations = []
        if (baseDir) {
            // Dev: serve directly from source tree
            locations << "file:${baseDir}/grails-app/assets/${assetSubdir}/"
        }
        // Production: asset-pipeline compiles assets onto the classpath under assets/
        locations << "classpath:assets/${assetSubdir}/"
        registry.addResourceHandler(pattern)
                .addResourceLocations(locations as String[])
    }
}
