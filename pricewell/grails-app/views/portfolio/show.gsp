
<%@ page import="com.valent.pricewell.Portfolio" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'portfolio.label', default: 'Portfolio')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span><g:link class="list" action="list" title="List Of Portfolios" class="buttons.button button"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <g:if test="${createPermit}">
            	<span><g:link class="create" action="create" title="Create Portfolio" class="buttons.button button"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
            </g:if>
        </div>
        <div class="body">
            <!-- <h1><g:message code="default.show.label" args="[entityName]" /></h1>-->
            <g:if test="${flash.message}">
            	<!--div class="message">${flash.message}</div-->
            </g:if>
            
            <g:set var="title" value="${portfolioInstance?.id != null?portfolioInstance.toString(): 'New Portfolio'}"/>
			<div class="body">
				<div class="collapsibleContainer">
					<div class="collapsibleContainerTitle ui-widget-header">
						<div>Portfolio: ${title}</div>
					</div>
				
					<div class="collapsibleContainerContent">
					
						<g:render template="portfolioDetails" model="['portfolioInstance': portfolioInstance]"> </g:render>
					
					</div>
					
				</div>
			</div>	
        </div>
    </body>
</html>
