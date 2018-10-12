<%@ page import="com.valent.pricewell.ServiceQuotation" %>

<g:setProvider library="prototype"/>

<g:form>

	<div class="body">
	
		<div class="list">
			<g:submitToRemote name="up" action="upOrder" title="Go Up" value="Up" controller="serviceQuotation" update="dvQutationServicesChangeOrder"/>
			<g:submitToRemote name="down" action="downOrder" title="Go Down" value="Down" controller="serviceQuotation" update="dvQutationServicesChangeOrder"/>
			
			<g:hiddenField name="quotationId" value="${quotationInstance?.id}"/>
		    <table>
		        <thead>
		            <tr>  
			            <th>  </th>         	
			            	
			            <th>Service Name</th>
		            </tr>
		        </thead>
		        <tbody>
		        
				<g:set var="tmpServiceQuotationList" value="${serviceQuotationList? serviceQuotationList: quotationInstance.serviceQuotations?.sort{it?.sequenceOrder}}"/>        
		         
		        <g:each in="${tmpServiceQuotationList}" status="i" var="serviceQuotationInstance">
		            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
		            	
		            	<td> <g:radio name="check" value="${serviceQuotationInstance.id}"/></td>
		            
		                <td>${serviceQuotationInstance?.service?.serviceName}</td>
		            
		                
		            </tr>          
		        </g:each>
		        </tbody>
		    </table>
		</div>
	</div>
</g:form>