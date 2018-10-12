hibernate {
    cache.use_second_level_cache = true
    cache.use_query_cache = true
    cache.provider_class = 'net.sf.ehcache.hibernate.EhCacheProvider'
}
// environment specific settings
environments {
    development {
        
		dataSource {
			pooled = true
			/*driverClassName = "org.h2.Driver"
			username = "sa"
			password = ""
			dbCreate = "update"
			url = "jdbc:h2:file:devDb"*/
			
			driverClassName = 'com.mysql.jdbc.Driver'
			dbCreate = "update"
			url = "jdbc:mysql://localhost:3306/smp_pricewell"//?autoReconnect=true"//pricewell_cloud_test"//sales_cloud" //pricewell_cloud_test"
			dialect = 'org.hibernate.dialect.MySQLDialect'
			username = "root"
			password = ""
			
			minEvictableIdleTimeMillis = (1000 * 60 * 30)
			timeBetweenEvictionRunsMillis = (1000 * 60 * 30)
			numTestsPerEvictionRun=3
	
			testOnBorrow=true
			testWhileIdle=true
			testOnReturn=true
			validationQuery="SELECT 1"
		}
    }
    test {
        dataSource {
			pooled = true
			driverClassName = "org.h2.Driver"
			username = "sa"
			password = ""
            dbCreate = "update"
            url = "jdbc:h2:mem:testDb"
			validationQuery = "select 1 as dbcp_connection_test"
			testOnBorrow = true
        }
    }
	
    production {
        dataSource {
			pooled = true	
            driverClassName = 'com.mysql.jdbc.Driver'
            dbCreate = "update"
            url =  "jdbc:mysql://${System.getProperty('dbHostName', 'localhost')}/${System.getProperty('dbName', 'pricewell')}"//?autoReconnect=true"
            dialect = 'org.hibernate.dialect.MySQLDialect'
            username = "usr"
            password = "sa"
			
			minEvictableIdleTimeMillis = (1000 * 60 * 30)
			timeBetweenEvictionRunsMillis = (1000 * 60 * 30)
			numTestsPerEvictionRun=3
	
			testOnBorrow=true
			testWhileIdle=true
			testOnReturn=true
			validationQuery="SELECT 1"
        }
    }
}