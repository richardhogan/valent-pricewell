
<%@ page import="com.valent.pricewell.LogoImage" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'logoImage.label', default: 'LogoImage')}" />
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
                        
                            <g:sortableColumn property="id" title="${message(code: 'logoImage.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="image" title="${message(code: 'logoImage.image.label', default: 'Image')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${logoImageInstanceList}" status="i" var="logoImageInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${logoImageInstance.id}">${fieldValue(bean: logoImageInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: logoImageInstance, field: "image")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${logoImageInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
