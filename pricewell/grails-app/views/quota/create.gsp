

<%@ page import="com.valent.pricewell.Quota" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'quota.label', default: 'Quota')}" />
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
            <g:hasErrors bean="${quotaInstance}">
            <div class="errors">
                <g:renderErrors bean="${quotaInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="amount"><g:message code="quota.amount.label" default="Amount" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: quotaInstance, field: 'amount', 'errors')}">
                                    <g:textField name="amount" value="${fieldValue(bean: quotaInstance, field: 'amount')}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="timespan"><g:message code="quota.timespan.label" default="Timespan" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: quotaInstance, field: 'timespan', 'errors')}">
                                    <g:textField name="timespan" value="${quotaInstance?.timespan}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="currency"><g:message code="quota.currency.label" default="Currency" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: quotaInstance, field: 'currency', 'errors')}">
                                    <g:textField name="currency" value="${quotaInstance?.currency}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="person"><g:message code="quota.person.label" default="Person" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: quotaInstance, field: 'person', 'errors')}">
                                    <g:select name="person.id" from="${com.valent.pricewell.User.list()}" optionKey="id" value="${quotaInstance?.person?.id}" noSelection="['null': '']" />
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
