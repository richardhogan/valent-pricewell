
<%@ page import="com.valent.pricewell.QuotationMilestone" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'quotationMilestone.label', default: 'QuotationMilestone')}" />
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
                        
                            <g:sortableColumn property="id" title="${message(code: 'quotationMilestone.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="milestone" title="${message(code: 'quotationMilestone.milestone.label', default: 'Milestone')}" />
                        
                            <g:sortableColumn property="amount" title="${message(code: 'quotationMilestone.amount.label', default: 'Amount')}" />
                        
                            <th><g:message code="quotationMilestone.quotation.label" default="Quotation" /></th>
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${quotationMilestoneInstanceList}" status="i" var="quotationMilestoneInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${quotationMilestoneInstance.id}">${fieldValue(bean: quotationMilestoneInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: quotationMilestoneInstance, field: "milestone")}</td>
                        
                            <td>${fieldValue(bean: quotationMilestoneInstance, field: "amount")}</td>
                        
                            <td>${fieldValue(bean: quotationMilestoneInstance, field: "quotation")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${quotationMilestoneInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
