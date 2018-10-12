package pricewell

import cw15.ApiCredentials
import grails.test.*
import com.valent.pricewell.*

class ConnectwiseIntegrationTests extends GroovyTestCase {
    def connectwiseExporterService
    protected Properties props

    protected void setUp() {
        super.setUp()
        props = new Properties();
        props.load(new FileInputStream('test/integration/resources/test.properties'))
    }

    protected void tearDown() {
        super.tearDown()
    }

    def cwDataProvider = [["https://cw.smp-corp.com", "SMP", "valent", "V@lent!!!"],
                          ["http://cw.smp-corp.com", "SMP", "valent", "V@lent!!!"]]

    void testValidURLs() {
        for(data in cwDataProvider) {
            String url = data[0]
            ApiCredentials apiCredentials = new ApiCredentials()
            cw15.ApiCredentials credentials = new cw15.ApiCredentials();
            credentials.setCompanyId(data[1])
            credentials.setIntegratorLoginId(data[2])
            credentials.setIntegratorPassword(data[3])
            Map map = connectwiseExporterService.checkConnectwiseCredentials(url, apiCredentials)
            assertEquals "success", map.get("result")
        }
    }
}