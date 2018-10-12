grails.plugin.location.'pricewellDomain' = "../pricewellDomain"
grails.plugin.location.'nimble' = "../nimble"
grails.plugin.location.'calendar' = "../calendar"
grails.plugin.location.'connectwiseIntegration' = "../connectwiseIntegration"
grails.plugin.location.'console' = "../console"
grails.plugin.location.'salesforceIntegration' = "../salesforceIntegration"
//grails.plugin.location.'clarizenIntegration' = "../clarizenIntegration"

grails.project.class.dir = "target/classes"
grails.project.test.class.dir = "target/test-classes"
grails.project.test.reports.dir = "target/test-reports"
google.appengine.sdk = "/Users/smistry/Documents/GoogleAppEngineLauncher.app"
println "-----------------------------------------------------------------------------------------------------------------"
grails.war.resources = { stagingDir ->
	delete(file:"${stagingDir}/WEB-INF/lib/geronimo-javamail_1.4_spec-1.6.jar")
	}
println "------------------------------------------------------------------------------------------------------------------"
//grails.project.war.file = "target/${appName}-${appVersion}.war"
grails.project.dependency.resolution = {
    // inherit Grails' default dependencies
    inherits("global") {
        // uncomment to disable ehcache
        // excludes 'ehcache'
    }
    log "warn" // log level of Ivy resolver, either 'error', 'warn', 'info', 'debug' or 'verbose'
    repositories {
        grailsPlugins()
        grailsHome()
        grailsCentral()

       // uncomment the below to enable remote dependency resolution
        // from public Maven repositories
        mavenLocal()
        mavenCentral()
        mavenRepo "http://snapshots.repository.codehaus.org"
        mavenRepo "http://repository.codehaus.org"
        mavenRepo "http://download.java.net/maven/2/"
        mavenRepo "http://repository.jboss.com/maven2/"
    }
    dependencies {
        // specify dependencies here under either 'build', 'compile', 'runtime', 'test' or 'provided' scopes eg.
		
		runtime "hsqldb:hsqldb:1.8.0.10"
		
		compile ("ma.glasnost.orika:orika-core:1.4.0"){
			excludes "slf4j-api"
		}
		
		compile("org.tmatesoft.svnkit:svnkit:1.3.5") {
		            excludes "jna", "trilead-ssh2", "sqljet"
		 }

        // runtime 'mysql:mysql-connector-java:5.1.13'
		compile ("org.quartz-scheduler:quartz:1.8.4") {
			// grails wants slf4j-api 1.5.8, quartz wants 1.6.0 - let grails win
			excludes 'slf4j-api'
		}
		
		compile "org.jsoup:jsoup:1.8.1"
		compile 'commons-lang:commons-lang:2.2'
		
		test "org.mockito:mockito-all:1.8.4"
		compile "org.reflections:reflections:0.9.5-RC2"
		compile 'hr.ngs.templater:templater:2.1.4'
		test 'net.sourceforge.nekohtml:nekohtml:1.9.13'
    }
}

grails.war.resources = { stagingDir ->
	delete(file:"${stagingDir}/WEB-INF/lib/geronimo-javamail_1.4_spec-1.6.jar")
}

