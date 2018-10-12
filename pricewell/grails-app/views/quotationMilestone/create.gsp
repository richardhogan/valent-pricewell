

<%@ page import="com.valent.pricewell.QuotationMilestone" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'quotationMilestone.label', default: 'QuotationMilestone')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.create.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${quotationMilestoneInstance}">
            <div class="errors">
                <g:renderErrors bean="${quotationMilestoneInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="milestone"><g:message code="quotationMilestone.milestone.label" default="Milestone" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: quotationMilestoneInstance, field: 'milestone', 'errors')}">
                                    <g:textField name="milestone" value="${quotationMilestoneInstance?.milestone}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="amount"><g:message code="quotationMilestone.amount.label" default="Amount" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: quotationMilestoneInstance, field: 'amount', 'errors')}">
                                    <g:textField name="amount" value="${fieldValue(bean: quotationMilestoneInstance, field: 'amount')}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="quotation"><g:message code="quotationMilestone.quotation.label" default="Quotation" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: quotationMilestoneInstance, field: 'quotation', 'errors')}">
                                    <g:select name="quotation.id" from="${com.valent.pricewell.Quotation.list()}" optionKey="id" value="${quotationMilestoneInstance?.quotation?.id}"  />
                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
