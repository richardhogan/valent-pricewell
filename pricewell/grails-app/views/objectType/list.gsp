
<%@ page import="com.valent.pricewell.ObjectType" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'objectType.label', default: 'ObjectType')}" />
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
                        
                            <g:sortableColumn property="id" title="${message(code: 'objectType.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="name" title="${message(code: 'objectType.name.label', default: 'Name')}" />
                        
                            <g:sortableColumn property="type" title="${message(code: 'objectType.type.label', default: 'Type')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${objectTypeInstanceList}" status="i" var="objectTypeInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${objectTypeInstance.id}">${fieldValue(bean: objectTypeInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: objectTypeInstance, field: "name")}</td>
                        
                            <td>${fieldValue(bean: objectTypeInstance, field: "type")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${objectTypeInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
