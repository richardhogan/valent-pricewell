<%@ page import="com.valent.pricewell.Quotation" %>
<%@ page import="com.valent.pricewell.Service" %>

<g:each in="${portfolioServicesMap.keySet()}" status="j" var="portfolioName">
    	<p class="heading1"> ${portfolioName.encodeAsHTML()} Services</p>
    	<g:each in="${portfolioServicesMap.get(portfolioName)}" status="i" var="serviceInfoArray">
    		<p class="indented-1 heading2">${i+1}) ${serviceInfoArray[0].encodeAsHTML()} </p>
    		<div class="indented-1 definition">
    			${serviceInfoArray[1]}
    		</div>
    		
    	</g:each>
</g:each>
	           