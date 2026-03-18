// locations to search for config files that get merged into the main config
// config files can either be Java properties files or ConfigSlurper scripts

// grails.config.locations = [ "classpath:${appName}-config.properties",
//                             "classpath:${appName}-config.groovy",
//                             "file:${userHome}/.grails/${appName}-config.properties",
//                             "file:${userHome}/.grails/${appName}-config.groovy"]

// if(System.properties["${appName}.config.location"]) {
//    grails.config.locations << "file:" + System.properties["${appName}.config.location"]
// }
grails.project.groupId = appName // change this to alter the default package name and Maven publishing destination
grails.mime.file.extensions = true // enables the parsing of file extensions from URLs into the request format
grails.mime.use.accept.header = false
grails.mime.types = [ html: ['text/html','application/xhtml+xml'],
                      xml: ['text/xml', 'application/xml'],
                      text: 'text/plain',
                      js: 'text/javascript',
                      rss: 'application/rss+xml',
                      atom: 'application/atom+xml',
                      css: 'text/css',
                      csv: 'text/csv',
                      all: '*/*',
                      json: ['application/json','text/json'],
                      form: 'application/x-www-form-urlencoded',
                      multipartForm: 'multipart/form-data'
                    ]

// URL Mapping Cache Max Size, defaults to 5000
//grails.urlmapping.cache.maxsize = 1000

// The default codec used to encode data with ${}
grails.views.default.codec = "none" // none, html, base64
grails.views.gsp.encoding = "UTF-8"
grails.converters.encoding = "UTF-8"
// enable Sitemesh preprocessing of GSP pages
grails.views.gsp.sitemesh.preprocess = true
// scaffolding templates configuration
grails.scaffolding.templates.domainSuffix = 'Instance'

// Set to false to use the new Grails 1.2 JSONBuilder in the render method
grails.json.legacy.builder = false
// enabled native2ascii conversion of i18n properties files
grails.enable.native2ascii = true
// whether to install the java.util.logging bridge for sl4j. Disable for AppEngine!
grails.logging.jul.usebridge = true
// packages to include in Spring bean scanning
grails.spring.bean.packages = ['com.valent.pricewell']

// request parameters to mask when logging exceptions
grails.exceptionresolver.params.exclude = ['password']

grails.plugin.cloudfoundry.username = 'snehal.mistry@yahoo.com'
grails.plugin.cloudfoundry.password = 'valent123'
grails.plugin.cloudfoundry.target = "api.cloudfoundry.com"

// set per-environment serverURL stem for creating absolute links
environments {
    production {
        grails.serverURL = ""//"http://www.changeme.com"
    }
    development {
        grails.serverURL = ""//http://localhost:8080/${appName}
    }
    test {
        grails.serverURL = "http://localhost:8080/${appName}"
    }

}

// ---------------------------------------------------------------------------
// Spring Security Core 1.2.7.3 configuration
// Replaces the former Nimble/Apache Shiro security setup.
// ---------------------------------------------------------------------------

// Domain class pointers
grails.plugins.springsecurity.userLookup.userDomainClassName    = 'com.valent.pricewell.User'
grails.plugins.springsecurity.userLookup.authorityJoinClassName = 'com.valent.pricewell.UserRole'
grails.plugins.springsecurity.authority.className               = 'grails.plugins.nimble.core.Role'
// The authority field on Role holds the ROLE_-prefixed authority string.
grails.plugins.springsecurity.authority.nameField               = 'authority'

// Password encoding: BCrypt for all new/reset passwords.
// Existing users will have passwordExpired=true so they are forced to reset
// on first login and their hash is re-encoded as BCrypt.
grails.plugins.springsecurity.password.algorithm                = 'bcrypt'

// Auth endpoints
grails.plugins.springsecurity.auth.loginFormUrl                 = '/auth/login'
grails.plugins.springsecurity.auth.ajaxLoginFormUrl             = '/auth/login'
grails.plugins.springsecurity.logout.afterLogoutUrl             = '/auth/login'
grails.plugins.springsecurity.failureHandler.defaultFailureUrl  = '/auth/login?login_error=1'
grails.plugins.springsecurity.adh.errorPage                     = '/auth/denied'

// URL access rules (replaces NimbleSecurityFilters.groovy).
// Rules are evaluated top-to-bottom; first match wins.
grails.plugins.springsecurity.interceptUrlMap = [
    // Auth and static assets are always public
    '/auth/**'             : ['IS_AUTHENTICATED_ANONYMOUSLY'],
    '/images/**'           : ['IS_AUTHENTICATED_ANONYMOUSLY'],
    '/js/**'               : ['IS_AUTHENTICATED_ANONYMOUSLY'],
    '/css/**'              : ['IS_AUTHENTICATED_ANONYMOUSLY'],
    '/static/**'           : ['IS_AUTHENTICATED_ANONYMOUSLY'],
    // Admin user-management UI requires SYSTEM ADMINISTRATOR
    '/userAdmin/**'        : ['ROLE_SYSTEM_ADMINISTRATOR'],
    // Service create/delete requires PORTFOLIO MANAGER or SYSTEM ADMINISTRATOR
    '/service/create'      : ['ROLE_PORTFOLIO_MANAGER', 'ROLE_SYSTEM_ADMINISTRATOR'],
    '/service/save'        : ['ROLE_PORTFOLIO_MANAGER', 'ROLE_SYSTEM_ADMINISTRATOR'],
    '/service/delete'      : ['ROLE_PORTFOLIO_MANAGER', 'ROLE_SYSTEM_ADMINISTRATOR'],
    // Portfolio create/delete requires PORTFOLIO MANAGER or SYSTEM ADMINISTRATOR
    '/portfolio/create'    : ['ROLE_PORTFOLIO_MANAGER', 'ROLE_SYSTEM_ADMINISTRATOR'],
    '/portfolio/save'      : ['ROLE_PORTFOLIO_MANAGER', 'ROLE_SYSTEM_ADMINISTRATOR'],
    '/portfolio/delete'    : ['ROLE_PORTFOLIO_MANAGER', 'ROLE_SYSTEM_ADMINISTRATOR'],
    // Delivery role, geo, and rate-card management require DELIVERY ROLE MANAGER
    '/deliveryRole/**'     : ['ROLE_DELIVERY_ROLE_MANAGER', 'ROLE_SYSTEM_ADMINISTRATOR'],
    '/geo/create'          : ['ROLE_DELIVERY_ROLE_MANAGER', 'ROLE_SYSTEM_ADMINISTRATOR'],
    '/geo/save'            : ['ROLE_DELIVERY_ROLE_MANAGER', 'ROLE_SYSTEM_ADMINISTRATOR'],
    '/geo/edit'            : ['ROLE_DELIVERY_ROLE_MANAGER', 'ROLE_SYSTEM_ADMINISTRATOR'],
    '/geo/update'          : ['ROLE_DELIVERY_ROLE_MANAGER', 'ROLE_SYSTEM_ADMINISTRATOR'],
    '/geo/delete'          : ['ROLE_DELIVERY_ROLE_MANAGER', 'ROLE_SYSTEM_ADMINISTRATOR'],
    '/relationDeliveryGeo/**': ['ROLE_DELIVERY_ROLE_MANAGER', 'ROLE_SYSTEM_ADMINISTRATOR'],
    // Reports require PORTFOLIO MANAGER or SYSTEM ADMINISTRATOR
    '/reports/**'          : ['ROLE_PORTFOLIO_MANAGER', 'ROLE_SYSTEM_ADMINISTRATOR'],
    // Quotation actions require any sales or management role
    '/quotation/**'        : ['ROLE_SALES_PERSON', 'ROLE_SALES_MANAGER', 'ROLE_SALES_PRESIDENT',
                               'ROLE_GENERAL_MANAGER', 'ROLE_SYSTEM_ADMINISTRATOR'],
    // All other URLs require an authenticated session
    '/**'                  : ['IS_AUTHENTICATED_REMEMBERED']
]

// ---------------------------------------------------------------------------
// log4j configuration
log4j = {
    // Example of changing the log pattern for the default console
    // appender:
    //
    //appenders {
    //    console name:'stdout', layout:pattern(conversionPattern: '%c{2} %m%n')
    //}
	
	appenders {
		file name:'file', file:'mylog.log'
	}
	root {
		info 'stdout', 'file'
		additivity = true
	}

    error  'org.codehaus.groovy.grails.web.servlet',  //  controllers
           'org.codehaus.groovy.grails.web.pages', //  GSP
           'org.codehaus.groovy.grails.web.sitemesh', //  layouts
           'org.codehaus.groovy.grails.web.mapping.filter', // URL mapping
           'org.codehaus.groovy.grails.web.mapping', // URL mapping
           'org.codehaus.groovy.grails.commons', // core / classloading
           'org.codehaus.groovy.grails.plugins', // plugins
           'org.codehaus.groovy.grails.orm.hibernate', // hibernate integration
           'org.springframework',
           'org.hibernate',
           'net.sf.ehcache.hibernate'

    warn   'org.mortbay.log'
}

// Added by the JQuery Validation plugin:
jqueryValidation.packed = true
jqueryValidation.cdn = false  // false or "microsoft"
jqueryValidation.additionalMethods = false

grails.resources.modules = {
	
	jquery {
		resource url:'/js/jquery-1.6.2.min.js', disposition: 'head'
	   }
	
	coreui {
		// 'nimbleui' removed — was loading JS/CSS from the Nimble plugin (now removed)
		dependsOn 'jquery', 'jqueryui', 'wizardui', 'expandgrid', 'navigation', 'highchart', 'jqueryalert', 'daterange', 'jquerygrid', 'jqueryblink', 'qtip', 'toastmessage', 'expandp','flexbox', 'datatable', 'menu', 'loaderbox'
		defaultBundle 'coreui'
		
		resource url:'/js/prototype/prototype.js', disposition: 'head'
		resource url:'/js/pricewell.js', disposition: 'head'
		resource url: '/css/my.css', disposition: 'head'
		
	}
	
	// REMOVED: nimbleui resource bundle (was loading JS/CSS from the Nimble plugin).
	// Nimble has been replaced by Spring Security Core — no equivalent resource bundle needed.
	
	jqueryui {		
		dependsOn 'jquery'
		defaultBundle 'coreui'
		
		resource url:'/css/redmond/jquery-ui-1.8.16.custom.css', disposition: 'head'
		resource url:'/js/jquery-ui-1.8.16.custom.min.js', disposition: 'head'
		resource url:'/js/jquery.validate.js', disposition: 'head'
	}
	
	jqueryalert {
		dependsOn 'jquery'
		defaultBundle 'coreui'
		
		resource url:'/js/jquery.alerts-1.1/jquery.alerts.js', disposition: 'head'
		resource url:'/js/jquery.alerts-1.1/jquery.alerts.css', disposition: 'head'
	}
	
	menu{
		dependsOn 'jquery'
		resource url:'/js/menu/dropmenu.js', disposition: 'head'
		resource url:'/js/menu/style.css', disposition: 'head'
	}
	
	loaderbox{
		dependsOn 'jquery'
		resource url:'/js/loaderbox.js', disposition: 'head'
		resource url:'/css/loaderbox.css', disposition: 'head'
	}
	
	tinymce {
		dependsOn 'jquery'
		resource url:'/js/tiny_mce/tiny_mce.js', disposition: 'head'
	}
	
	highchart {
		dependsOn 'jquery'
		defaultBundle 'coreui'
		
		resource url:'/js/new_highcharts/js/highcharts.src.js', disposition: 'head'
		resource url:'/js/new_highcharts/js/modules/exporting.src.js', disposition: 'head'
		resource url:'/js/new_highcharts/js/modules/funnel.src.js', disposition: 'head'
		resource url:'/js/new_highcharts/js/modules/export-csv.js', disposition: 'head'
		resource url:'/js/new_highcharts/js/modules/no-data-to-display.src.js', disposition: 'head'
	}
	
	wizardui {
		dependsOn 'jquery'
		defaultBundle 'coreui'
		
		resource url:'/css/smart_wizard.css', disposition: 'head'
		resource url:'/js/jquery.smartWizard-2.0.min.js', disposition: 'head'
	}
	
	expandgrid {
		dependsOn 'jquery'
		defaultBundle 'coreui'
		resource url:'/js/expand.js', disposition: 'head'
	}
	
	expandp {
		dependsOn 'jquery'
		defaultBundle 'coreui'
		resource url:'/js/jquery.expander.min.js', disposition: 'head'
	}
	
	flexbox {
		dependsOn 'jquery'
		defaultBundle 'coreui'
		resource url:'/js/jquery.flexbox.min.js', disposition: 'head'
		resource url:'/css/jquery.flexbox.css', disposition: 'head'
	}
	
	datatable {
		dependsOn 'jquery'
		defaultBundle 'coreui'
		resource url:'/js/dataTables/js/jquery.dataTables.js', disposition: 'head'
		resource url:'/js/dataTables/css/demo_table.css', disposition: 'head'
		resource url:'/js/dataTables/css/demo_page.css', disposition: 'head'
	}
	
	navigation {
		dependsOn 'jquery'
		defaultBundle 'navigation'
		resource url:'/css/navigation.css', disposition: 'head'
	}
	
	jqueryblink {
		dependsOn 'jquery'
		defaultBundle 'jqueryblink'
		
		resource url:'/js/jquery-blink/jquery-blink.js', disposition: 'head'
	}
	
	daterange {
		dependsOn 'jquery'
		defaultBundle 'coreui'
		
		resource url:'/js/date.js', disposition: 'head'
		resource url:'/js/dateRange.js', disposition: 'head'
	}
	
	toastmessage {
		dependsOn 'jquery'
		defaultBundle 'coreui'
		
		resource url:'/js/toastmessage/js/jquery.toastmessage.js', disposition: 'head'
		resource url:'/js/toastmessage/resources/css/jquery.toastmessage.css', disposition: 'head'
	}
	
	jquerygrid {
		dependsOn 'jquery'
		defaultBundle 'coreui'
		
		resource url:'/css/jqgrid/ui.jqgrid.css', disposition: 'head'
		resource url:'/css/jqgrid/jqgrid.css', disposition: 'head'
		resource url:'/js/jqgrid/i18n/grid.locale-en.js', disposition: 'head'
		resource url:'/js/jqgrid/jquery.jqGrid.min.js', disposition: 'head'
		resource url:'/js/jqgrid/jquery.jqGrid.fluid.js', disposition: 'head'
	}
	
	qtip {
		dependsOn 'jquery'
		defaultBundle 'coreui'
		
		resource url:'/js/qtip/jquery.qtip-1.0.0-rc3.js', disposition: 'head'
	}
		
}

