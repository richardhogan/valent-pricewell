package com.valent.pricewell

import grails.boot.GrailsApp
import grails.boot.config.GrailsAutoConfiguration

class Application extends GrailsAutoConfiguration {

    // Domain classes live in pricewellDomain.jar (not the app jar itself),
    // so we must scan all JARs on the classpath, not just the app's own jar.
    @Override
    protected boolean limitScanningToApplication() { false }

    // Declare all packages that contain Grails artefacts (domain, services, etc.)
    // across all subproject JARs.
    @Override
    Collection<Package> packages() {
        [
            Application.package,                         // com.valent.pricewell
            Package.getPackage('grails.plugins.nimble.core')  // Nimble domain classes in pricewellDomain
        ].grep()   // grep() removes nulls (if a package isn't loaded yet)
    }

    // BootStrap.groovy lives in the default (unnamed) package and is missed by the
    // package-based ClassPathScanner.  Load it explicitly so Grails can run it.
    @Override
    Collection<Class> classes() {
        def allClasses = super.classes()
        try { allClasses << Class.forName('BootStrap') } catch (ClassNotFoundException ignored) { }
        return allClasses
    }

    static void main(String[] args) {
        GrailsApp.run(Application, args)
    }
}
