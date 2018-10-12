

<%@ page import="com.valent.pricewell.RelationDeliveryGeo" %>
<html>
    <head>   
        
    </head>
    <body>
        <div class="body">
            <h1>Modify Rates & Cost</h1>
            
            <g:hasErrors bean="${relationDeliveryGeoInstance}">
            <div class="errors">
                <g:renderErrors bean="${relationDeliveryGeoInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="updateMultiple" >
            	<g:hiddenField name="entries" value="${relationsList.size()}"/>
                <div class="dialog">
                    <table>
                    	<thead>
                    		<tr>
                    			<th> Delivery Role </th>
	                    		<th> GEO </th>
	                    		<th> Currency </th>
	                    		<th>  Cost Per Day</th>
	                    		<th>  Rate Per Day </th>
                    		</tr>
                    	</thead>
                        <tbody>
                        	<g:each in="${relationsList}" status="i" var="rel">
	                        	<tr>
	                        		<td>
	                        			<g:textField name="deliveryRoleName" value="${rel?.deliveryRole?.name}" readOnly="true"/>
	                        		</td>
	                        		<td>		 
	                        			<g:textField name="geoName" value="${rel?.geo?.name}" readOnly="true"/>
	                        			<g:hiddenField name="relations.${i}.id" value="${rel?.id}"/>
	     							</td>
	     							<td>
	                        			<g:textField  name="geoCurrency" value="${rel?.geo?.currency}" readOnly="true"/> 
	     							</td>
	     								
	     							<td>
	     								 <g:textField name="relations.${i}.costPerDay" value="${rel?.costPerDay}" />
	     							</td>
	     							
	     							<td>
	     								<g:textField name="relations.${i}.ratePerDay" value="${rel?.ratePerDay}" />
	     							</td>
	                        	</tr>
	                        </g:each>
                        </tbody>
                       </table>	
                       
                <div class="buttons">
                    <span class="button"><g:submitButton name="create" class="save" value="save" /></span>
                     <span class="button"><g:link name="cancel" class="cancel" action="show" controller="deliveryRole" id="${deliveryRoleInstance?.id}">Cancel </g:link></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
