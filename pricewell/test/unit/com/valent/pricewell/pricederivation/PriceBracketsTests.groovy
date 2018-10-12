package com.valent.pricewell.pricederivation

import grails.test.mixin.TestMixin
import grails.test.mixin.support.GrailsUnitTestMixin
import org.junit.Assert

/**
 * Created by snehal.mistry on 10/25/15.
 */
@TestMixin(GrailsUnitTestMixin)
class PriceBracketsTests {

    //(1, 20)=2.01
    void testSome(){
        String str = "(2,300)=2.01\n(2,1000)=2.42\n(3,2500)=1.90\n(3,300)=2.55\n" +
                "(3,1000)=2.10\n(2,2500)=2.19"

        PriceBrackets priceBrackets = PriceBrackets.parseParseBrackets(str)
        Assert.assertEquals(priceBrackets.prices.toString(), "[2.01, 2.42, 1.9, 2.55, 2.1, 2.19]")
        Assert.assertEquals(priceBrackets.priceVariablesTree.toString(),
                "[2.0:[300.0:0, 1000.0:1, 2500.0:5], 3.0:[300.0:3, 1000.0:4, 2500.0:2]]")
        println priceBrackets.priceVariablesTree
        println priceBrackets.prices
        Assert.assertEquals(priceBrackets.calculatePrice((Double[]) [2, 300]),
                new BigDecimal(2*300*2.01).setScale(2, BigDecimal.ROUND_HALF_EVEN))
        Assert.assertEquals(priceBrackets.calculatePrice((Double[]) [3, 2500]),
                new BigDecimal(3*2500*1.90).setScale(2, BigDecimal.ROUND_HALF_EVEN))
        Assert.assertEquals(priceBrackets.calculatePrice((Double[]) [2, 2500]),
                new BigDecimal(2*2500*2.19).setScale(2, BigDecimal.ROUND_HALF_EVEN))
        Assert.assertEquals(priceBrackets.calculatePrice((Double[]) [3, 4500]),
                new BigDecimal(3*4500*1.90).setScale(2, BigDecimal.ROUND_HALF_EVEN))
        Assert.assertEquals(priceBrackets.calculatePrice((Double[]) [2, 150]),
                new BigDecimal(2*150*2.01).setScale(2, BigDecimal.ROUND_HALF_EVEN))
        Assert.assertEquals(priceBrackets.calculatePrice((Double[]) [2.5, 150]),
                new BigDecimal(2.5*150*2.01).setScale(2, BigDecimal.ROUND_HALF_EVEN))
    }
}
