
<%@ page import="com.valent.pricewell.Service" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <nav:resources/>
        <g:set var="entityName" value="${message(code: 'service.label', default: 'Service')}" />
        <title>${title}</title>
    </head>
    <body>
    	
    	<div class="nav">
	        		<g:if test="${createPermit}">
		            	<span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
		            </g:if>	
		           		<span class="menuButton"><g:link class="catalog" action="pricelist">Service Catalog</g:link></span>
	        	</div>
	        	
       <div class="leftNav">      		
    		<nav:render group="service" id="plain"/>
    	</div>
    		
        <div id="columnRight" class="body rightContent column">
        	
            <h1>${title}</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            
            <g:if test="${showSearch}">
            	<g:render template="searchToolBar" model="['searchFields': searchFields]"/>
            </g:if>
             
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                            <th> </th>
                        
                            <g:sortableColumn property="serviceName" title="${message(code: 'service.serviceName.label', default: 'Service Name')}" />
                        
                            <g:sortableColumn property="skuName" title="${message(code: 'service.skuName.label', default: 'Sku Name')}" />
                        
                            <g:sortableColumn property="description" title="${message(code: 'service.description.label', default: 'Description')}" />
                        
                            <th><g:message code="service.portfolio.label" default="Portfolio" /></th>
                        
                            <g:sortableColumn property="dateCreated" title="${message(code: 'service.dateCreated.label', default: 'Date Created')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${serviceInstanceList}" status="i" var="serviceInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${serviceInstance.id}">details </g:link></td>
                        
                            <td>${fieldValue(bean: serviceInstance, field: "serviceName")}</td>
                        
                            <td>${fieldValue(bean: serviceInstance, field: "skuName")}</td>
                        
                            <td>${fieldValue(bean: serviceInstance, field: "description")}</td>
                        
                            <td>${fieldValue(bean: serviceInstance, field: "portfolio")}</td>
                        
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
