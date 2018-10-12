

<%@ page import="com.valent.pricewell.ServiceDeliverable" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'serviceDeliverable.label', default: 'ServiceDeliverable')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.edit.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${serviceDeliverableInstance}">
            <div class="errors">
                <g:renderErrors bean="${serviceDeliverableInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <g:hiddenField name="id" value="${serviceDeliverableInstance?.id}" />
                <g:hiddenField name="version" value="${serviceDeliverableInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="name"><g:message code="serviceDeliverable.name.label" default="Name" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceDeliverableInstance, field: 'name', 'errors')}">
                                    <g:textField name="name" value="${serviceDeliverableInstance?.name}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="type"><g:message code="serviceDeliverable.type.label" default="Type" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceDeliverableInstance, field: 'type', 'errors')}">
                                    <g:textField name="type" value="${serviceDeliverableInstance?.type}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="description"><g:message code="serviceDeliverable.description.label" default="Description" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceDeliverableInstance, field: 'description', 'errors')}">
                                    <g:textField name="description" value="${serviceDeliverableInstance?.description}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="activitiesOrders"><g:message code="serviceDeliverable.activitiesOrders.label" default="Activities Orders" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceDeliverableInstance, field: 'activitiesOrders', 'errors')}">
                                    <g:select name="activitiesOrders" from="${com.valent.pricewell.DeliverableActivityOrder.list()}" multiple="yes" optionKey="id" size="5" value="${serviceDeliverableInstance?.activitiesOrders*.id}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="serviceActivities"><g:message code="serviceDeliverable.serviceActivities.label" default="Service Activities" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceDeliverableInstance, field: 'serviceActivities', 'errors')}">
                                    <g:select name="serviceActivities" from="${com.valent.pricewell.ServiceActivity.list()}" multiple="yes" optionKey="id" size="5" value="${serviceDeliverableInstance?.serviceActivities*.id}" />
                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit class="save" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
