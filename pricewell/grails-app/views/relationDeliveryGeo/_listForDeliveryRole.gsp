<%@ page import="com.valent.pricewell.RelationDeliveryGeo" %>
<html>
    <body>
        <div class="body">
        <g:form controller="relationDeliveryGeo" action="deleteMultiple" method="POST">
        	<g:hiddenField name="deliveryRoleId" value="${deliveryRoleInstance?.id}"/>
        	<g:set var="list" value="${relationDeliveryGeoList}"></g:set>
        	<g:set var="count" value="${list.size()}"></g:set>
        	<div class="buttons">
	            <span class="button"><g:submitToRemote controller="relationDeliveryGeo" action="editMultiple" 
	            		value="Edit" title="Edit"
	            		update="[success:'dvRateCostsPerGeo',failure:'dvRateCostsPerGeo']" disabled="${count==0}"/></span>
	            <span class="button">
	            	<g:submitButton title="Delete" name="delete" value="Delete"/>
	            </span>
        	</div>
            
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        	<th> </th>
                        
                        	<th><g:message code="default.geo.label" default="Geo" /></th>
                        	
                        	<th>Currency</th>
                        	
                            <g:sortableColumn property="costPerDay" title="${message(code: 'relationDeliveryGeo.costPerDay.label', default: 'Cost Per Day')}" />
                      
                            <g:sortableColumn property="ratePerDay" title="${message(code: 'relationDeliveryGeo.ratePerDay.label', default: 'Rate Per Day')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${list?.sort{it.geo.name}}" status="i" var="relationDeliveryGeoInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                        	<td> <g:checkBox name="check.${relationDeliveryGeoInstance.id}" value="${false}"/> </td>
                        	  
                            <td>${relationDeliveryGeoInstance?.geo?.name}</td>
                            
                            <td>${relationDeliveryGeoInstance?.geo?.currency}</td>
                        
                            <td>${fieldValue(bean: relationDeliveryGeoInstance, field: "costPerDay")}</td>
                        
                            <td>${fieldValue(bean: relationDeliveryGeoInstance, field: "ratePerDay")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
           </g:form>
        </div>
    </body>
</html>
