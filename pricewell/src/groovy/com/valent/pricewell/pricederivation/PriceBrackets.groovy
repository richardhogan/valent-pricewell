package com.valent.pricewell.pricederivation

/**
 * Created by snehal.mistry on 10/25/15.
 */
class PriceBrackets {

    TreeMap priceVariablesTree = new TreeMap<>();
    List<Double> prices = new ArrayList<>()

    public static PriceBrackets parseParseBrackets(String str){
        PriceBrackets priceBrackets = new PriceBrackets()
        str.split("\n").each { String line ->
            String[] vs = line.split("=")
            Double price = vs[1].trim().toDouble()
            String valsTmp = vs[0].replaceAll("\\(", "").replaceAll("\\)", "")
            String[] vals = valsTmp.split(",")
            Double previousVal = vals[0].trim().toDouble()
            TreeMap previousLink = priceBrackets.priceVariablesTree
            for(int i=1; i < vals.length; i++){
                if(!previousLink.containsKey(previousVal)){
                    previousLink.put(previousVal, new TreeMap())
                }
                previousLink = previousLink.get(previousVal)
                previousVal = vals[i].trim().toDouble()
            }
            previousLink.put(previousVal,priceBrackets.prices.size())
            priceBrackets.prices.add(price)
        }
        return priceBrackets
    }


    public BigDecimal calculatePrice(Double[] params){
        TreeMap currentLink = priceVariablesTree
        Double totalPrice = 1
        Integer index = 0

        for(int i=0; i< params.length; i++){
            def val = currentLink.floorEntry(params[i])?.value
            //If val is null then it indicates that values are lower than specified base units
            if(val == null){
                //Should we throw error?? => specified units are less than base units
                val = currentLink.entrySet().iterator().next().value
            }
            if(val instanceof TreeMap){
                currentLink = val
            } else {
                index = val
            }
            totalPrice = totalPrice * params[i]
        }
        BigDecimal p = new BigDecimal(prices.get(index) * totalPrice);
        return p.setScale(2, BigDecimal.ROUND_HALF_EVEN)
    }
}
