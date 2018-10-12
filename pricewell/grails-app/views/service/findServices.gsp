<%@ page import="com.valent.pricewell.Service" %>
<%@ page import="com.valent.pricewell.Portfolio" %>
<%@ page import="grails.plugins.nimble.core.Role" %>
<%@ page import="org.apache.shiro.SecurityUtils"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <nav:resources/>
        <g:set var="entityName" value="${message(code: 'service.label', default: 'Service')}" />
        <g:if test="${title}">
            <title>${title}</title>
        </g:if>
        <g:else>
        	<title>Find My Services</title>
        </g:else>
        <!--title>Find Services</title-->
    </head>
    <body>
	    <div class="nav">
    		<g:if test="${createPermit}">
            	<span class="menuButton"><g:link class="create" action="create">New Service</g:link></span>
            </g:if>	
           		<span class="menuButton"><g:link class="catalog" action="pricelist">Service Catalog</g:link></span>
		</div>
		
		 <div class="leftNav">      		
    		<nav:render group="service" id="plain"/>
    	</div>
    		
        <div id="columnRight" class="body rightContent column">
			<h1>Find My Services</h1>
			<!--n:principalName /-->
			<g:form action="findServices" method="POST">
				<table>
					<!-- tr>
						<td>
							 <label>Role</label>
						</td>
						<td>
							<g:select name="findField.role.id" from="${Role.list()}" optionValue="name" optionKey="id" noSelection="${['all':'All']}" value="${findField?.role?.id}"  />
						</td>
						
						<td>
							 <label>Portfolio</label>
						</td>
						<td>
							<g:select name="findField.portfolio.id" from="${com.valent.pricewell.Portfolio.list()}" optionKey="id" noSelection="${['all':'All']}" value="${findField?.portfolio?.id}"  />
						</td>
						
						<td cospan="2">	 
			
						 	<span class="button"><g:submitButton name="find" class="search" controller="service" action="findService" 
						 				value="FindService"/></span>
						</td>					
					</tr-->
				</table>
	 		</g:form>
	 		
	 		<div class="list">
	                <table>
	                    <thead>
	                        <tr>
	                        
	                            <th> </th>
	                        
	                            <g:sortableColumn property="service.serviceName" title="${message(code: 'service.serviceName.label', default: 'Service Name')}" />
	                            
	                            <g:sortableColumn property="version" title="${message(code: 'serviceProfile.revision.label', default: 'Version')}" />
	                        
	                            <g:sortableColumn property="service.skuName" title="${message(code: 'service.skuName.label', default: 'Sku Name')}" />
	                        
	                            <g:sortableColumn property="service.description" title="${message(code: 'service.description.label', default: 'Description')}" />
	                        
	                            <th><g:message code="service.portfolio.label" default="Portfolio" /></th>
	                        
	                            <g:sortableColumn property="dateCreated" title="${message(code: 'service.dateCreated.label', default: 'Date Created')}" />
	                        
	                        </tr>
	                    </thead>
	                    <g:if test="${serviceInstanceList}">
	                    <tbody>
	                    <g:each in="${serviceInstanceList}" status="i" var="serviceProfileInstance">
	                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
	                        
	                            <td><g:link action="show"  params="[serviceProfileId: serviceProfileInstance.id]">details </g:link></td>
	                        
	                            <td>${fieldValue(bean: serviceProfileInstance, field: "service.serviceName")}</td>
	                            
	                            <td>${fieldValue(bean: serviceProfileInstance, field: "revision")}</td>
	                        
	                            <td>${fieldValue(bean: serviceProfileInstance, field: "service.skuName")}</td>
	                        
	                            <td>${fieldValue(bean: serviceProfileInstance, field: "service.description")}</td>
	                        
	                            <td>${fieldValue(bean: serviceProfileInstance, field: "service.portfolio")}</td>
	                        
	                            <td><g:formatDateformat="MMMMM d, yyyy" date="${serviceProfileInstance.dateCreated}" /></td>
	                        
	                        </tr>
	                    </g:each>
	                    </tbody>
	                    </g:if>
	                </table>
	            </div>
           </div>
    </body>
    
</html>