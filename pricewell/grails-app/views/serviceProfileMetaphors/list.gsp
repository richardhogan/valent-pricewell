
<%@ page import="com.valent.pricewell.ServiceProfileMetaphors" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'serviceProfileMetaphors.label', default: 'ServiceProfileMetaphors')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                            <g:sortableColumn property="id" title="${message(code: 'serviceProfileMetaphors.id.label', default: 'Id')}" />
                        
                            <th><g:message code="serviceProfileMetaphors.definitionString.label" default="Definition String" /></th>
                        
                            <th><g:message code="serviceProfileMetaphors.serviceProfile.label" default="Service Profile" /></th>
                        
                            <g:sortableColumn property="sequenceOrder" title="${message(code: 'serviceProfileMetaphors.sequenceOrder.label', default: 'Sequence Order')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${serviceProfileMetaphorsInstanceList}" status="i" var="serviceProfileMetaphorsInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${serviceProfileMetaphorsInstance.id}">${fieldValue(bean: serviceProfileMetaphorsInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: serviceProfileMetaphorsInstance, field: "definitionString")}</td>
                        
                            <td>${fieldValue(bean: serviceProfileMetaphorsInstance, field: "serviceProfile")}</td>
                        
                            <td>${fieldValue(bean: serviceProfileMetaphorsInstance, field: "sequenceOrder")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${serviceProfileMetaphorsInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
