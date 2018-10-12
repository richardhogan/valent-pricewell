package pricewelldomain

import com.valent.pricewell.templater.*;
import com.valent.pricewell.Account
import com.valent.pricewell.Quotation
import com.valent.pricewell.Service
import com.valent.pricewell.ServiceActivity
import com.valent.pricewell.ServiceActivityTask
import com.valent.pricewell.ServiceDeliverable
import com.valent.pricewell.ServiceProfile
import com.valent.pricewell.ServiceProfileMetaphors
import com.valent.pricewell.ServiceQuotation
import com.valent.pricewell.Setting

import org.reflections.Reflections

import static org.junit.Assert.*

import grails.test.mixin.*
import grails.test.mixin.support.*
import org.junit.*
import static org.mockito.Mockito.*;
import static org.junit.Assert.*;

/**
 * See the API for {@link grails.test.mixin.support.GrailsUnitTestMixin} for usage instructions
 */
@TestMixin(GrailsUnitTestMixin)
class JsonConversionTests {

    void setUp() {
        // Setup logic here
    }

    void tearDown() {
        // Tear down logic here
    }

    void testSome(){
        Reflections reflections = new Reflections("com.valent.pricewell");
        Set<Class<? extends SowJsonConverterPlugin>> implementingTypes =
                reflections.getSubTypesOf(SowJsonConverterPlugin.class);
        println implementingTypes
    }


    void testEmptyPrereqs() {
        //ServiceProfile.metaClass.listServiceProfileMetaphors{ServiceProfileMetaphors.MetaphorsType type -> return []}
        //new ServiceProfileMetaphors(definitionString: new Setting(name: "name", value: "value"))
        Service service1 = new Service(serviceName: "s1")
        ServiceProfile profile1 = new ServiceProfile(service: service1)
        profile1.metaClass.listServiceProfileMetaphors{ServiceProfileMetaphors.MetaphorsType type -> return []}

        Service service2 = new Service(serviceName: "s2")
        ServiceProfile profile2 = new ServiceProfile(service: service2)
        profile2.metaClass.listServiceProfileMetaphors{ServiceProfileMetaphors.MetaphorsType type -> return []}

        ServiceQuotation sq1 = new ServiceQuotation(service: service1, profile: profile1)

        ServiceQuotation sq2 = new ServiceQuotation(service: service2, profile: profile2)

        Quotation quotation = new Quotation(serviceQuotations: [sq1, sq2])

        String str = SowJsonConverterUtil.convertSOWToJson(quotation).toString()

        assertTrue("Pre-requisites should be empty", str.contains("prerequisites"))
        assertTrue("outofscopes should be empty", str.contains("outofscopes"))
    }


    void testFullSMP_EUC_SOW(){
        Service service1 = new Service(serviceName: "EUC Assessment",
                description: 'The End User Computing, (EUC) Assessment provides an objective analysis of customers current desktop environment and offers a clear plan to proactively facilitate improvements to customer desktop practices and architecture.')
        ServiceProfile profile1 = new ServiceProfile(service: service1,
                                        customerDeliverables: [
                                                new ServiceDeliverable(name: "del1", description: "del1 desc",
                                                        serviceActivities: [
                                                                new ServiceActivity(name: "act 1", category: "Some", description: "desc",
                                                                        activityTasks: [
                                                                                new ServiceActivityTask(task: "task1"),
                                                                                new ServiceActivityTask(task: "task2"),
                                                                        ])
                                                        ])
                                        ]
                    )
        profile1.metaClass.listServiceProfileMetaphors{ServiceProfileMetaphors.MetaphorsType type -> return
                (type.equals(ServiceProfileMetaphors.MetaphorsType.POST_REQUISITE) ?
                        [
                                new ServiceProfileMetaphors(definitionString: new Setting(name: "name", value: "Customer representative is available for assessment workshop")),
                                new ServiceProfileMetaphors(definitionString: new Setting(name: "name", value: "Ability to deploy assessment tool for data gathering during the project work hours")),
                        ]:
                        []);
        }

        Service service2 = new Service(serviceName: "s2")
        ServiceProfile profile2 = new ServiceProfile(service: service2)
        profile2.metaClass.listServiceProfileMetaphors{ServiceProfileMetaphors.MetaphorsType type -> return
            (type.equals(ServiceProfileMetaphors.MetaphorsType.POST_REQUISITE) ?
                    [
                            new ServiceProfileMetaphors(definitionString: new Setting(name: "name", value: "Sample1")),
                            new ServiceProfileMetaphors(definitionString: new Setting(name: "name", value: "Sample2")),
                    ]:
                    [
                            new ServiceProfileMetaphors(definitionString: new Setting(name: "name", value: "OOS-Sample1")),
                            new ServiceProfileMetaphors(definitionString: new Setting(name: "name", value: "OOS-Sample2")),
                    ])
        }

        ServiceQuotation sq1 = new ServiceQuotation(service: service1, profile: profile1)

        ServiceQuotation sq2 = new ServiceQuotation(service: service2, profile: profile2)

        Quotation quotation = new Quotation(serviceQuotations: [sq1, sq2],
                account: new Account(accountName: "Joseph XXX"))

        SowJsonConverterPluginWithNoGroupingOfServices.metaClass.globalBindingProps = ["customer": quotation.account.accountName]
        //protected void fillGlobalProps(Quotation quotation){
        String str = SowJsonConverterUtil.convertSOWToJson(quotation).toString()
        //Verify if customer name is replaced
        //TODO: Fix tests so we can verify if customer name is converted back
        //assertTrue("Customer name is not replaced in description", str.contains("Joseph XXX"))
        println str
        //assertFalse("Pre-requisites shouldn't appear if empty", str.contains("prerequisites"))
        //assertFalse("outofscopes shouldn't appear if empty", str.contains("outofscopes"))
    }

}
