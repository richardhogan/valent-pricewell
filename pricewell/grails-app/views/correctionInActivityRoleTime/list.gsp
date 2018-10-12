
<%@ page import="com.valent.pricewell.CorrectionInActivityRoleTime" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'correctionInActivityRoleTime.label', default: 'CorrectionInActivityRoleTime')}" />
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
                        
                            <g:sortableColumn property="id" title="${message(code: 'correctionInActivityRoleTime.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="extraHours" title="${message(code: 'correctionInActivityRoleTime.extraHours.label', default: 'Extra Hours')}" />
                        
                            <g:sortableColumn property="originalHours" title="${message(code: 'correctionInActivityRoleTime.originalHours.label', default: 'Original Hours')}" />
                        
                            <th><g:message code="correctionInActivityRoleTime.serviceActivity.label" default="Service Activity" /></th>
                        
                            <th><g:message code="correctionInActivityRoleTime.serviceQuotation.label" default="Service Quotation" /></th>
                        
                            <th><g:message code="correctionInActivityRoleTime.role.label" default="Role" /></th>
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${correctionInActivityRoleTimeInstanceList}" status="i" var="correctionInActivityRoleTimeInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${correctionInActivityRoleTimeInstance.id}">${fieldValue(bean: correctionInActivityRoleTimeInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: correctionInActivityRoleTimeInstance, field: "extraHours")}</td>
                        
                            <td>${fieldValue(bean: correctionInActivityRoleTimeInstance, field: "originalHours")}</td>
                        
                            <td>${fieldValue(bean: correctionInActivityRoleTimeInstance, field: "serviceActivity")}</td>
                        
                            <td>${fieldValue(bean: correctionInActivityRoleTimeInstance, field: "serviceQuotation")}</td>
                        
                            <td>${fieldValue(bean: correctionInActivityRoleTimeInstance, field: "role")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${correctionInActivityRoleTimeInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
