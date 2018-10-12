
<%@ page import="com.valent.pricewell.Service" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <title>Find Services</title>
        <g:javascript library="prototype" />
    </head>
    <body>
    		
        <div id="dvSearchServices" class="body" style="height: 1100">
            <h1>Find Services</h1>
            
            <g:if test="${showSearch}">
            	<g:render template="/quotation/searchToolBar" model="['searchFields',searchFields]"/>
            </g:if>
             
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        	 <th> </th>   
                            <g:sortableColumn property="serviceName" title="${message(code: 'service.serviceName.label', default: 'Service Name')}" />
                        
                            <g:sortableColumn property="skuName" title="${message(code: 'service.skuName.label', default: 'Sku Name')}" />
                            
                            <th><g:message code="service.portfolio.label" default="Portfolio" /></th>
                            
                            <th> Estimate Flat</th>
                            
                            <th> Estimate Extra</th>
                            
                            <th> Roles Required </th>
                        
                            <g:sortableColumn property="dateCreated" title="${message(code: 'service.dateCreated.label', default: 'Date Created')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${serviceInstanceList}" status="i" var="serviceInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        	<g:set var="calculatedEstimate" value="${serviceInstance?.serviceProfile?.calculateTotalEstimatedTime()}"/>
                        	
                        	<td><g:remoteLink class="button" controller="serviceQuotation" 
                        			action="addServiceToQuote" id="${serviceInstance?.id}" update="dvSearchServices"> Add </g:remoteLink> </td>
                        	
                            <td>${fieldValue(bean: serviceInstance, field: "serviceName")}</td>
                        
                            <td>${fieldValue(bean: serviceInstance, field: "skuName")}</td>
                            
                            <td>${fieldValue(bean: serviceInstance, field: "portfolio")}</td>
                        
                        	<td>${calculatedEstimate["totalFlat"]}</td>
                        	
                        	<td>${calculatedEstimate["totalExtra"]}</td>
                        	
                        	<td> ${serviceInstance?.serviceProfile?.requiredRolesStringList()} </td>
                            
                            <td><g:formatDate format="MMMMM d, yyyy" date="${serviceInstance.dateCreated}" /></td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${serviceInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
