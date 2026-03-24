package pricewell

import cw15.ApiCredentials
import com.valent.pricewell.*
import grails.testing.mixin.integration.Integration
import spock.lang.Specification
import spock.lang.Unroll

@Integration
class ConnectwiseIntegrationSpec extends Specification {

    def connectwiseExporterService

    @Unroll
    def "testValidURLs - #url"() {
        given:
        Properties props = new Properties()
        props.load(new FileInputStream('test/integration/resources/test.properties'))

        when:
        cw15.ApiCredentials credentials = new cw15.ApiCredentials()
        credentials.setCompanyId("SMP")
        credentials.setIntegratorLoginId("valent")
        credentials.setIntegratorPassword('V@lent!!!')
        Map map = connectwiseExporterService.checkConnectwiseCredentials(url, credentials)

        then:
        map.get("result") == "success"

        where:
        url << ["https://cw.smp-corp.com", "http://cw.smp-corp.com"]
    }
}
