
<%@ page import="com.valent.pricewell.GeneralStagingLog" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'generalStagingLog.label', default: 'GeneralStagingLog')}" />
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
                        
                            <g:sortableColumn property="id" title="${message(code: 'generalStagingLog.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="dateModified" title="${message(code: 'generalStagingLog.dateModified.label', default: 'Date Modified')}" />
                        
                            <th><g:message code="generalStagingLog.fromStage.label" default="From Stage" /></th>
                        
                            <th><g:message code="generalStagingLog.toStage.label" default="To Stage" /></th>
                        
                            <g:sortableColumn property="action" title="${message(code: 'generalStagingLog.action.label', default: 'Action')}" />
                        
                            <g:sortableColumn property="comment" title="${message(code: 'generalStagingLog.comment.label', default: 'Comment')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${generalStagingLogInstanceList}" status="i" var="generalStagingLogInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${generalStagingLogInstance.id}">${fieldValue(bean: generalStagingLogInstance, field: "id")}</g:link></td>
                        
                            <td><g:formatDate format="MMMMM d, yyyy" date="${generalStagingLogInstance.dateModified}" /></td>
                        
                            <td>${fieldValue(bean: generalStagingLogInstance, field: "fromStage")}</td>
                        
                            <td>${fieldValue(bean: generalStagingLogInstance, field: "toStage")}</td>
                        
                            <td>${fieldValue(bean: generalStagingLogInstance, field: "action")}</td>
                        
                            <td>${fieldValue(bean: generalStagingLogInstance, field: "comment")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${generalStagingLogInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
