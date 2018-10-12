
<%@ page import="com.valent.pricewell.UpdateRecord" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'updateRecord.label', default: 'UpdateRecord')}" />
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
                        
                            <g:sortableColumn property="id" title="${message(code: 'updateRecord.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="recordType" title="${message(code: 'updateRecord.recordType.label', default: 'Record Type')}" />
                        
                            <g:sortableColumn property="beginUpdateDate" title="${message(code: 'updateRecord.beginUpdateDate.label', default: 'Begin Update Date')}" />
                        
                            <g:sortableColumn property="lastUpdateDate" title="${message(code: 'updateRecord.lastUpdateDate.label', default: 'Last Update Date')}" />
                        
                            <g:sortableColumn property="comments" title="${message(code: 'updateRecord.comments.label', default: 'Comments')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${updateRecordInstanceList}" status="i" var="updateRecordInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${updateRecordInstance.id}">${fieldValue(bean: updateRecordInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: updateRecordInstance, field: "recordType")}</td>
                        
                            <td><g:formatDate date="${updateRecordInstance.beginUpdateDate}" /></td>
                        
                            <td><g:formatDate date="${updateRecordInstance.lastUpdateDate}" /></td>
                        
                            <td>${fieldValue(bean: updateRecordInstance, field: "comments")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${updateRecordInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
