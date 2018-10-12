
<%@ page import="com.valent.pricewell.ProjectParameter" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'projectParameter.label', default: 'ProjectParameter')}" />
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
                        
                            <g:sortableColumn property="id" title="${message(code: 'projectParameter.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="value" title="${message(code: 'projectParameter.value.label', default: 'Value')}" />
                        
                            <th><g:message code="projectParameter.quotation.label" default="Quotation" /></th>
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${projectParameterInstanceList}" status="i" var="projectParameterInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${projectParameterInstance.id}">${fieldValue(bean: projectParameterInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: projectParameterInstance, field: "value")}</td>
                        
                            <td>${fieldValue(bean: projectParameterInstance, field: "quotation")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${projectParameterInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
