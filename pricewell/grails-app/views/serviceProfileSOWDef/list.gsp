
<%@ page import="com.valent.pricewell.ServiceProfileSOWDef" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'serviceProfileSOWDef.label', default: 'ServiceProfileSOWDef')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
        
        <g:setProvider library="prototype"/>
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
                        
                            <g:sortableColumn property="id" title="${message(code: 'serviceProfileSOWDef.id.label', default: 'Id')}" />
                        
                            <th><g:message code="serviceProfileSOWDef.geo.label" default="Geo" /></th>
                        
                            <g:sortableColumn property="part" title="${message(code: 'serviceProfileSOWDef.part.label', default: 'Part')}" />
                        
                            <g:sortableColumn property="definition" title="${message(code: 'serviceProfileSOWDef.definition.label', default: 'Definition')}" />
                        
                            <th><g:message code="serviceProfileSOWDef.sp.label" default="Sp" /></th>
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${serviceProfileSOWDefInstanceList}" status="i" var="serviceProfileSOWDefInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${serviceProfileSOWDefInstance.id}">${fieldValue(bean: serviceProfileSOWDefInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: serviceProfileSOWDefInstance, field: "geo")}</td>
                        
                            <td>${fieldValue(bean: serviceProfileSOWDefInstance, field: "part")}</td>
                        
                            <td>${fieldValue(bean: serviceProfileSOWDefInstance, field: "definition")}</td>
                        
                            <td>${fieldValue(bean: serviceProfileSOWDefInstance, field: "sp")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${serviceProfileSOWDefInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
