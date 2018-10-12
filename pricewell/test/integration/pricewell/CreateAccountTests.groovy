package pricewell

import static org.junit.Assert.*
import com.valent.pricewell.Account
import com.valent.pricewell.BillingAddress
import com.valent.pricewell.ShippingAddress
import org.junit.*

class CreateAccountTests {

    @Before
    void setUp() {
        // Setup logic here
    }

    @After
    void tearDown() {
        // Tear down logic here
    }

    @Test
    void testSomething() {
        //fail "Implement me"
		
		Account accountInstance = new Account(shippingAddress: new ShippingAddress().save())
		accountInstance.accountName = "Testing Purpose"
		accountInstance.dateCreated = new Date()
		accountInstance.dateModified = new Date()
		
		//BillingAddress billingAddress = new BillingAddress()
		ShippingAddress shippingAddress = accountInstance.shippingAddress
		
		//accountInstance.billingAddress = billingAddress
		accountInstance.shippingAddress = shippingAddress
		
		accountInstance.save()
    }
}
