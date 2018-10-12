package pricewelldomain

import static org.junit.Assert.*

import grails.test.mixin.*
import grails.test.mixin.support.*
import org.junit.*

/**
 * See the API for {@link grails.test.mixin.support.GrailsUnitTestMixin} for usage instructions
 */
@TestMixin(GrailsUnitTestMixin)
class SampleServiceTests {

    void setUp() {
        // Setup logic here
    }

    void tearDown() {
        // Tear down logic here
    }

    void testSomething() {
        //fail "Implement me"
		
		String input = "man OF stEEL";
		StringTokenizer tokenizer = new StringTokenizer(input);
		StringBuffer sb = new StringBuffer();
		while (tokenizer.hasMoreTokens()) {
			String word = tokenizer.nextToken();
			sb.append(word.substring(0, 1).toUpperCase());
			sb.append(word.substring(1).toLowerCase());
			sb.append(' ');
		}
		String text = sb.toString();
		//System.out.println(text);
		(text == "Man Of Steel") ? {assert true} : {assert false}
    }
}
