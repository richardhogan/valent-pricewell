
<%@ page import="com.valent.pricewell.Notification" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'notification.label', default: 'Notification')}" />
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
                        
                            <g:sortableColumn property="id" title="${message(code: 'notification.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="message" title="${message(code: 'notification.message.label', default: 'Message')}" />
                        
                            <g:sortableColumn property="dateCreated" title="${message(code: 'notification.dateCreated.label', default: 'Date Created')}" />
                        
                            <th><g:message code="notification.reviewRequest.label" default="Review Request" /></th>
                        
                            <g:sortableColumn property="objectType" title="${message(code: 'notification.objectType.label', default: 'Object Type')}" />
                        
                            <g:sortableColumn property="active" title="${message(code: 'notification.active.label', default: 'Active')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${notificationInstanceList}" status="i" var="notificationInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${notificationInstance.id}">${fieldValue(bean: notificationInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: notificationInstance, field: "message")}</td>
                        
                            <td><g:formatDate format="MMMMM d, yyyy" date="${notificationInstance.dateCreated}" /></td>
                        
                            <td>${fieldValue(bean: notificationInstance, field: "reviewRequest")}</td>
                        
                            <td>${fieldValue(bean: notificationInstance, field: "objectType")}</td>
                        
                            <td><g:formatBoolean boolean="${notificationInstance.active}" /></td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${notificationInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
