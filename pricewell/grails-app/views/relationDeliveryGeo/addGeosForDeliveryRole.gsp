

<%@ page import="com.valent.pricewell.RelationDeliveryGeo" %>
<html>
    <head>   
        
    </head>
    <body>
        <div class="body">
            <h1>Define Rates & Cost for ${deliveryRoleInstance.name}</h1>
            
            <g:hasErrors bean="${relationDeliveryGeoInstance}">
            <div class="errors">
                <g:renderErrors bean="${relationDeliveryGeoInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="saveMultiple" >
            	<g:hiddenField name="entries" value="${geosList.size()}"/>
                <div class="dialog">
                    <table>
                    	<thead>
                    		<tr>
	                    		<th> GEO </th>
	                    		<th> Currency </th>
	                    		<th>  Cost Per Day</th>
	                    		<th>  Rate Per Day </th>
                    		</tr>
                    	</thead>
                        <tbody>
                        	<g:each in="${geosList}" status="i" var="geo">
	                        	<tr>
	                        		<td>
	                        			<g:textField name="geoName" value="${geo?.name}" readOnly="true"/> 
	                        			<g:hiddenField name="relations.${i}.deliveryRole.id" value="${deliveryRoleInstance.id}"/>
	                        			<g:hiddenField name="relations.${i}.geo.id" value="${geo.id}"/>
	     							</td>
	     							<td>
	                        			<g:textField  name="geoCurrency" value="${geo?.currency}" readOnly="true"/> 
	     							</td>
	     								
	     							<td>
	     								 <g:textField name="relations.${i}.costPerDay" value="" />
	     							</td>
	     							
	     							<td>
	     								<g:textField name="relations.${i}.ratePerDay" value="" />
	     							</td>
	                        	</tr>
	                        </g:each>
                        </tbody>
                       </table>	
                <div class="buttons">
                    <span class="button"><g:submitButton name="create" class="save" title="Save" value="save" /></span>
                    <span class="button"><g:link name="cancel" class="cancel" title="Cancel" action="show" controller="deliveryRole" id="${deliveryRoleInstance?.id}">Cancel </g:link></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
