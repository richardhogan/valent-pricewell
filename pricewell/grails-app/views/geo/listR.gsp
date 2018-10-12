
<%@ page import="com.valent.pricewell.Geo" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'geo.label', default: 'Geo')}" />
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
                        
                            <g:sortableColumn property="id" title="${message(code: 'geo.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="name" title="${message(code: 'geo.name.label', default: 'Name')}" />
                        
                            <g:sortableColumn property="description" title="${message(code: 'geo.description.label', default: 'Description')}" />
                        
                            <g:sortableColumn property="currency" title="${message(code: 'geo.currency.label', default: 'Currency')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${geoInstanceList}" status="i" var="geoInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${geoInstance.id}">${fieldValue(bean: geoInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: geoInstance, field: "name")}</td>
                        
                            <td>${fieldValue(bean: geoInstance, field: "description")}</td>
                        
                            <td>${fieldValue(bean: geoInstance, field: "currency")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${geoInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
