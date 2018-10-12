
<%@ page import="com.valent.pricewell.TextTemplate" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'textTemplate.label', default: 'TextTemplate')}" />
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
                        
                            <g:sortableColumn property="id" title="${message(code: 'textTemplate.id.label', default: 'Id')}" />
                        
                            <th><g:message code="textTemplate.geo.label" default="Geo" /></th>
                        
                            <g:sortableColumn property="dateCreated" title="${message(code: 'textTemplate.dateCreated.label', default: 'Date Created')}" />
                        
                            <g:sortableColumn property="dateModified" title="${message(code: 'textTemplate.dateModified.label', default: 'Date Modified')}" />
                        
                            <g:sortableColumn property="name" title="${message(code: 'textTemplate.name.label', default: 'Name')}" />
                        
                            <g:sortableColumn property="text" title="${message(code: 'textTemplate.text.label', default: 'Text')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${textTemplateInstanceList}" status="i" var="textTemplateInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${textTemplateInstance.id}">${fieldValue(bean: textTemplateInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: textTemplateInstance, field: "geo")}</td>
                        
                            <td><g:formatDate format="MMMMM d, yyyy" date="${textTemplateInstance.dateCreated}" /></td>
                        
                            <td><g:formatDate format="MMMMM d, yyyy" date="${textTemplateInstance.dateModified}" /></td>
                        
                            <td>${fieldValue(bean: textTemplateInstance, field: "name")}</td>
                        
                            <td>${fieldValue(bean: textTemplateInstance, field: "text")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${textTemplateInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
