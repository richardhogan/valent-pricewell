
<%@ page import="com.valent.pricewell.Staging" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <title>List of Service Stages</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><g:link class="edit" action="editServiceStages">Edit</g:link></span>
        </div>
        <div class="body">
            <h1>List of Service Stages</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                            <g:sortableColumn property="id" title="${message(code: 'staging.id.label', default: 'Id')}" />
                            
                            <g:sortableColumn property="name" title="${message(code: 'staging.name.label', default: 'Name')}" />
                            
                            <g:sortableColumn property="displayName" title="${message(code: 'staging.displayName.label', default: 'Display Name')}" />
                        
                            <g:sortableColumn property="entity" title="${message(code: 'staging.entity.label', default: 'Entity')}" />
                        
                            <g:sortableColumn property="sequenceOrder" title="${message(code: 'staging.sequenceOrder.label', default: 'Sequence Order')}" />
                        
                            <g:sortableColumn property="description" title="${message(code: 'staging.description.label', default: 'Description')}" />
                            
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${stagingInstanceList}" status="i" var="stagingInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${stagingInstance.id}">${fieldValue(bean: stagingInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: stagingInstance, field: "entity")}</td>
                        
                            <td>${fieldValue(bean: stagingInstance, field: "sequenceOrder")}</td>
                        
                            <td>${fieldValue(bean: stagingInstance, field: "description")}</td>
                        
                            <td>${fieldValue(bean: stagingInstance, field: "displayName")}</td>
                        
                            <td>${fieldValue(bean: stagingInstance, field: "name")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${stagingInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
