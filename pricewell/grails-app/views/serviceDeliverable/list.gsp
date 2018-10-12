
<%@ page import="com.valent.pricewell.ServiceDeliverable" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'serviceDeliverable.label', default: 'ServiceDeliverable')}" />
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
                        
                            <g:sortableColumn property="id" title="${message(code: 'serviceDeliverable.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="name" title="${message(code: 'serviceDeliverable.name.label', default: 'Name')}" />
                        
                            <g:sortableColumn property="type" title="${message(code: 'serviceDeliverable.type.label', default: 'Type')}" />
                        
                            <g:sortableColumn property="description" title="${message(code: 'serviceDeliverable.description.label', default: 'Description')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${serviceDeliverableInstanceList}" status="i" var="serviceDeliverableInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${serviceDeliverableInstance.id}">${fieldValue(bean: serviceDeliverableInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: serviceDeliverableInstance, field: "name")}</td>
                        
                            <td>${fieldValue(bean: serviceDeliverableInstance, field: "type")}</td>
                        
                            <td>${fieldValue(bean: serviceDeliverableInstance, field: "description")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${serviceDeliverableInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
