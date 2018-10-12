
<%@ page import="com.valent.pricewell.Description" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'description.label', default: 'Description')}" />
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
                        
                            <g:sortableColumn property="id" title="${message(code: 'description.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="value" title="${message(code: 'description.value.label', default: 'Value')}" />
                        
                            <g:sortableColumn property="name" title="${message(code: 'description.name.label', default: 'Name')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${descriptionInstanceList}" status="i" var="descriptionInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${descriptionInstance.id}">${fieldValue(bean: descriptionInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: descriptionInstance, field: "value")}</td>
                        
                            <td>${fieldValue(bean: descriptionInstance, field: "name")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${descriptionInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
