
<%@ page import="com.valent.pricewell.StagingLog" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'stagingLog.label', default: 'StagingLog')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
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
                        
                            <g:sortableColumn property="dateModified" title="${message(code: 'stagingLog.dateModified.label', default: 'Date Modified')}" />
                        
                            <g:sortableColumn property="action" title="${message(code: 'stagingLog.action.label', default: 'Action')}" />
                        
                            <g:sortableColumn property="fromStage" title="${message(code: 'stagingLog.fromStage.label', default: 'From Stage')}" />
                            
                            <g:sortableColumn property="toStage" title="${message(code: 'stagingLog.toStage.label', default: 'To Stage')}" />
                            
                            <g:sortableColumn property="modifiedBy" title="${message(code: 'stagingLog.modifiedBy.label', default: 'Modified By')}" />
                            
                            <g:sortableColumn property="comment" title="${message(code: 'stagingLog.comment.label', default: 'Comment')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${stagingLogInstanceList}" status="i" var="stagingLogInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:formatDate format="MMMMM d, yyyy" date="${stagingLogInstance.dateModified}" /></td>
                        
                            <td>${fieldValue(bean: stagingLogInstance, field: "action")}</td>
                        
                            <td>${fieldValue(bean: stagingLogInstance, field: "fromStage")}</td>
                            
                            <td>${fieldValue(bean: stagingLogInstance, field: "toStage")}</td>
                        
                            <td>${fieldValue(bean: stagingLogInstance, field: "modifiedBy")}</td>
                            
                            <td>${fieldValue(bean: stagingLogInstance, field: "comment")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${stagingLogInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
