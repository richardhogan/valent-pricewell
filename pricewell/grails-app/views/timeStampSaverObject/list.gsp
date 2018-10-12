
<%@ page import="com.valent.pricewell.TimeStampSaverObject" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'timeStampSaverObject.label', default: 'TimeStampSaverObject')}" />
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
                        
                            <g:sortableColumn property="id" title="${message(code: 'timeStampSaverObject.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="fromDate" title="${message(code: 'timeStampSaverObject.fromDate.label', default: 'From Date')}" />
                        
                            <g:sortableColumn property="toDate" title="${message(code: 'timeStampSaverObject.toDate.label', default: 'To Date')}" />
                        
                            <g:sortableColumn property="objectName" title="${message(code: 'timeStampSaverObject.objectName.label', default: 'Object Name')}" />
                        
                            <th><g:message code="timeStampSaverObject.modifiedBy.label" default="Modified By" /></th>
                        
                            <g:sortableColumn property="modifiedDate" title="${message(code: 'timeStampSaverObject.modifiedDate.label', default: 'Modified Date')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${timeStampSaverObjectInstanceList}" status="i" var="timeStampSaverObjectInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${timeStampSaverObjectInstance.id}">${fieldValue(bean: timeStampSaverObjectInstance, field: "id")}</g:link></td>
                        
                            <td><g:formatDate date="${timeStampSaverObjectInstance.fromDate}" /></td>
                        
                            <td><g:formatDate date="${timeStampSaverObjectInstance.toDate}" /></td>
                        
                            <td>${fieldValue(bean: timeStampSaverObjectInstance, field: "objectName")}</td>
                        
                            <td>${fieldValue(bean: timeStampSaverObjectInstance, field: "modifiedBy")}</td>
                        
                            <td><g:formatDate date="${timeStampSaverObjectInstance.modifiedDate}" /></td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${timeStampSaverObjectInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
