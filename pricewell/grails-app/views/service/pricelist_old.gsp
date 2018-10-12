
<%@ page import="com.valent.pricewell.Service" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <nav:resources/>
        <g:set var="entityName" value="${message(code: 'service.label', default: 'Service')}" />
        <title>Service Catalog </title>
    </head>
    <body>
    	
    	<div class="nav">
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
        </div>
        
       <div class="leftNav">      		
    		<nav:render group="service" id="plain"/>
    	</div>
    		
        <div id="columnRight" class="body rightContent column">
        	
            <h1> Service Catalog </h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            
            <g:render template="pricelistSearchBar" model="['searchFields':searchFields, 'geoInstance': geoInstance]"/>
             
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        	<th><g:message code="service.portfolio.label" default="Portfolio" /></th>
                        	
                            <g:sortableColumn property="serviceName" title="${message(code: 'service.serviceName.label', default: 'Service Name')}" />
                        
                            <g:sortableColumn property="skuName" title="${message(code: 'service.skuName.label', default: 'Sku Name')}" />
                            
                            <th> <g:message code="serviceProfile.unitOfSale.label" default="Unit of Sale" /> </th>
                            
                            <th> <g:message code="serviceProfile.baseUnits.label" default="Base Units" /> </th>
                            
                            <th> <g:message code="geo.currency.label" default="Currency" /> </th>
                            
                            <th> <g:message code="service.basePrice.label" default="Base Price" /> </th>
                           
                            <th> <g:message code="serviceProfile.baseHrs.label" default="Base Hrs" /> </th>
                             
                            <th> <g:message code="service.additionalPrice.label" default="Add. Unit Price" /> </th>
                            
                            <th> <g:message code="serviceProfile.additionalHrs.label" default="Add.Unit Hrs" /> </th>
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${serviceInstanceList}" status="i" var="serviceProfileInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                        	<g:set var="priceMap" value="${serviceProfileInstance.service.calculatePrices(geoInstance)}"/>
                        	<g:set var="estimateMap" value="${serviceProfileInstance.calculateTotalEstimatedTime()}"/>
                        	
                        	<td>${fieldValue(bean: serviceProfileInstance, field: "service.portfolio")}</td>
                        	
                            <td>${fieldValue(bean: serviceProfileInstance, field: "service.serviceName")}</td>
                        
                            <td>${fieldValue(bean: serviceProfileInstance, field: "service.skuName")}</td>
                            
                            <td> ${serviceProfileInstance?.unitOfSale} </td>
                            
                            <td> ${serviceProfileInstance?.baseUnits} </td>
                            
                            <td> ${geoInstance?.currency} </td>
                            
                            <td> ${priceMap["basePrice"]} </td>
                            
                            <td> ${estimateMap["totalFlat"]} </td>
                            
                            <td> ${priceMap["additionalPrice"]} </td>
                            
                            <td> ${estimateMap["totalExtra"]} </td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
           
        </div>
    </body>
</html>
