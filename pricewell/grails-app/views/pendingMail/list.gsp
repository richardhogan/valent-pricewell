
<%@ page import="com.valent.pricewell.PendingMail" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'pendingMail.label', default: 'PendingMail')}" />
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
                        
                            <g:sortableColumn property="id" title="${message(code: 'pendingMail.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="emailId" title="${message(code: 'pendingMail.emailId.label', default: 'Email Id')}" />
                        
                            <g:sortableColumn property="message" title="${message(code: 'pendingMail.message.label', default: 'Message')}" />
                        
                            <g:sortableColumn property="subject" title="${message(code: 'pendingMail.subject.label', default: 'Subject')}" />
                        
                            <g:sortableColumn property="createDate" title="${message(code: 'pendingMail.createDate.label', default: 'Create Date')}" />
                        
                            <g:sortableColumn property="active" title="${message(code: 'pendingMail.active.label', default: 'Active')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${pendingMailInstanceList}" status="i" var="pendingMailInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${pendingMailInstance.id}">${fieldValue(bean: pendingMailInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: pendingMailInstance, field: "emailId")}</td>
                        
                            <td>${fieldValue(bean: pendingMailInstance, field: "message")}</td>
                        
                            <td>${fieldValue(bean: pendingMailInstance, field: "subject")}</td>
                        
                            <td><g:formatDate date="${pendingMailInstance.createDate}" /></td>
                        
                            <td><g:formatBoolean boolean="${pendingMailInstance.active}" /></td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${pendingMailInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
