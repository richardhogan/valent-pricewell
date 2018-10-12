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
		dependsOn 'jquery', 'jqueryui', 'nimbleui', 'wizardui', 'expandgrid', 'navigation', 'highchart', 'jqueryalert', 'daterange', 'jquerygrid', 'jqueryblink', 'qtip', 'toastmessage', 'expandp','flexbox', 'datatable', 'menu', 'loaderbox'
		defaultBundle 'coreui'
		
		resource url:'/js/prototype/prototype.js', disposition: 'head'
		resource url:'/js/pricewell.js', disposition: 'head'
		resource url: '/css/my.css', disposition: 'head'
		
	}
	
	nimbleui {
		dependsOn 'jquery'
		defaultBundle 'nimble'
		
		resource url:'/plugins/nimble-0.4-SNAPSHOT/dev/js/jquery/jquery.url.js', disposition: 'head'
		resource url:'/plugins/nimble-0.4-SNAPSHOT/dev/js/jquery/jquery.bt.custom.js', disposition: 'head'
		resource url:'/plugins/nimble-0.4-SNAPSHOT/dev/js/jquery/jquery.jgrowl.js', disposition: 'head'
		
		resource url:'/plugins/nimble-0.4-SNAPSHOT/dev/css/jquery/jgrowl.css', disposition: 'head'
		resource url:'/plugins/nimble-0.4-SNAPSHOT/dev/js/jquery/nimbleui.growl.js', disposition: 'head'
		resource url:'/plugins/nimble-0.4-SNAPSHOT/dev/css/famfamfam.css', disposition: 'head'
		
	}
	
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

