
<%@ page import="com.valent.pricewell.Quota" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'quota.label', default: 'Quota')}" />
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
                        
                            <g:sortableColumn property="id" title="${message(code: 'quota.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="amount" title="${message(code: 'quota.amount.label', default: 'Amount')}" />
                        
                            <g:sortableColumn property="timespan" title="${message(code: 'quota.timespan.label', default: 'Timespan')}" />
                        
                            <g:sortableColumn property="currency" title="${message(code: 'quota.currency.label', default: 'Currency')}" />
                        
                            <th><g:message code="quota.person.label" default="Person" /></th>
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${quotaInstanceList}" status="i" var="quotaInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${quotaInstance.id}">${fieldValue(bean: quotaInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: quotaInstance, field: "amount")}</td>
                        
                            <td>${fieldValue(bean: quotaInstance, field: "timespan")}</td>
                        
                            <td>${fieldValue(bean: quotaInstance, field: "currency")}</td>
                        
                            <td>${fieldValue(bean: quotaInstance, field: "person")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${quotaInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
