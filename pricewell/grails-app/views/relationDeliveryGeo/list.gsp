
<%@ page import="com.valent.pricewell.RelationDeliveryGeo" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'relationDeliveryGeo.label', default: 'RelationDeliveryGeo')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div>
            	<g:submitButton name="Edit" value="Edit"></g:submitButton>
            	<g:submitButton name="Edit" value="Delete"></g:submitButton>
            	<label> Delivery Role </label>
            	<g:textField name="searchField"></g:textField>
            </div>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        	<th> </th>
                        
                            <!--g:sortableColumn property="id" title="${message(code: 'relationDeliveryGeo.id.label', default: 'Id')}" /-->
                        
                            <th><g:message code="relationDeliveryGeo.deliveryRole.label" default="Delivery Role" /></th>
                        
                            <th><g:message code="relationDeliveryGeo.geo.label" default="Geo" /></th>
                            
                            <g:sortableColumn property="costPerDay" title="${message(code: 'relationDeliveryGeo.costPerDay.label', default: 'Cost Per Day')}" />
                        
                            <g:sortableColumn property="ratePerDay" title="${message(code: 'relationDeliveryGeo.ratePerDay.label', default: 'Rate Per Day')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${relationDeliveryGeoInstanceList}" status="i" var="relationDeliveryGeoInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                        	<td> <g:checkBox name="check.${relationDeliveryGeoInstance.id}" value="${false}"/> </td>
                        	  
                        	<td>${fieldValue(bean: relationDeliveryGeoInstance, field: "deliveryRole")}</td>
                            
                            <td>${fieldValue(bean: relationDeliveryGeoInstance, field: "geo")}</td>
                        
                            <td>${fieldValue(bean: relationDeliveryGeoInstance, field: "costPerDay")}</td>
                        
                            <td>${fieldValue(bean: relationDeliveryGeoInstance, field: "ratePerDay")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
           
        </div>
    </body>
</html>
