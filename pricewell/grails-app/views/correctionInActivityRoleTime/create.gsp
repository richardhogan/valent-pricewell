

<%@ page import="com.valent.pricewell.CorrectionInActivityRoleTime" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'correctionInActivityRoleTime.label', default: 'CorrectionInActivityRoleTime')}" />
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
            <g:hasErrors bean="${correctionInActivityRoleTimeInstance}">
            <div class="errors">
                <g:renderErrors bean="${correctionInActivityRoleTimeInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="extraHours"><g:message code="correctionInActivityRoleTime.extraHours.label" default="Extra Hours" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: correctionInActivityRoleTimeInstance, field: 'extraHours', 'errors')}">
                                    <g:textField name="extraHours" value="${fieldValue(bean: correctionInActivityRoleTimeInstance, field: 'extraHours')}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="originalHours"><g:message code="correctionInActivityRoleTime.originalHours.label" default="Original Hours" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: correctionInActivityRoleTimeInstance, field: 'originalHours', 'errors')}">
                                    <g:textField name="originalHours" value="${fieldValue(bean: correctionInActivityRoleTimeInstance, field: 'originalHours')}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="serviceActivity"><g:message code="correctionInActivityRoleTime.serviceActivity.label" default="Service Activity" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: correctionInActivityRoleTimeInstance, field: 'serviceActivity', 'errors')}">
                                    <g:select name="serviceActivity.id" from="${com.valent.pricewell.ServiceActivity.list()}" optionKey="id" value="${correctionInActivityRoleTimeInstance?.serviceActivity?.id}" noSelection="['null': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="serviceQuotation"><g:message code="correctionInActivityRoleTime.serviceQuotation.label" default="Service Quotation" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: correctionInActivityRoleTimeInstance, field: 'serviceQuotation', 'errors')}">
                                    <g:select name="serviceQuotation.id" from="${com.valent.pricewell.ServiceQuotation.list()}" optionKey="id" value="${correctionInActivityRoleTimeInstance?.serviceQuotation?.id}" noSelection="['null': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="role"><g:message code="correctionInActivityRoleTime.role.label" default="Role" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: correctionInActivityRoleTimeInstance, field: 'role', 'errors')}">
                                    <g:select name="role.id" from="${com.valent.pricewell.DeliveryRole.list()}" optionKey="id" value="${correctionInActivityRoleTimeInstance?.role?.id}"  />
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
