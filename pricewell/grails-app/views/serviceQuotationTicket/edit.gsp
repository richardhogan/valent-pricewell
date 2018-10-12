

<%@ page import="com.valent.pricewell.ServiceQuotationTicket" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'serviceQuotationTicket.label', default: 'ServiceQuotationTicket')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.edit.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${serviceQuotationTicketInstance}">
            <div class="errors">
                <g:renderErrors bean="${serviceQuotationTicketInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <g:hiddenField name="id" value="${serviceQuotationTicketInstance?.id}" />
                <g:hiddenField name="version" value="${serviceQuotationTicketInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="summary"><g:message code="serviceQuotationTicket.summary.label" default="Summary" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceQuotationTicketInstance, field: 'summary', 'errors')}">
                                    <g:textField name="summary" value="${serviceQuotationTicketInstance?.summary}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="role"><g:message code="serviceQuotationTicket.role.label" default="Role" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceQuotationTicketInstance, field: 'role', 'errors')}">
                                    <g:select name="role.id" from="${com.valent.pricewell.DeliveryRole.list()}" optionKey="id" value="${serviceQuotationTicketInstance?.role?.id}" noSelection="['null': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="budgetHours"><g:message code="serviceQuotationTicket.budgetHours.label" default="Budget Hours" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceQuotationTicketInstance, field: 'budgetHours', 'errors')}">
                                    <g:textField name="budgetHours" value="${fieldValue(bean: serviceQuotationTicketInstance, field: 'budgetHours')}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="actualHours"><g:message code="serviceQuotationTicket.actualHours.label" default="Actual Hours" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceQuotationTicketInstance, field: 'actualHours', 'errors')}">
                                    <g:textField name="actualHours" value="${fieldValue(bean: serviceQuotationTicketInstance, field: 'actualHours')}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="serviceActivity"><g:message code="serviceQuotationTicket.serviceActivity.label" default="Service Activity" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceQuotationTicketInstance, field: 'serviceActivity', 'errors')}">
                                    <g:select name="serviceActivity.id" from="${com.valent.pricewell.ServiceActivity.list()}" optionKey="id" value="${serviceQuotationTicketInstance?.serviceActivity?.id}" noSelection="['null': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="serviceQuotation"><g:message code="serviceQuotationTicket.serviceQuotation.label" default="Service Quotation" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceQuotationTicketInstance, field: 'serviceQuotation', 'errors')}">
                                    <g:select name="serviceQuotation.id" from="${com.valent.pricewell.ServiceQuotation.list()}" optionKey="id" value="${serviceQuotationTicketInstance?.serviceQuotation?.id}" noSelection="['null': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="createdBy"><g:message code="serviceQuotationTicket.createdBy.label" default="Created By" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceQuotationTicketInstance, field: 'createdBy', 'errors')}">
                                    <g:select name="createdBy.id" from="${com.valent.pricewell.User.list()}" optionKey="id" value="${serviceQuotationTicketInstance?.createdBy?.id}" noSelection="['null': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="modifiedBy"><g:message code="serviceQuotationTicket.modifiedBy.label" default="Modified By" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceQuotationTicketInstance, field: 'modifiedBy', 'errors')}">
                                    <g:select name="modifiedBy.id" from="${com.valent.pricewell.User.list()}" optionKey="id" value="${serviceQuotationTicketInstance?.modifiedBy?.id}" noSelection="['null': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="createdDate"><g:message code="serviceQuotationTicket.createdDate.label" default="Created Date" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceQuotationTicketInstance, field: 'createdDate', 'errors')}">
                                    <g:datePicker name="createdDate" precision="day" value="${serviceQuotationTicketInstance?.createdDate}" default="none" noSelection="['': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="modifiedDate"><g:message code="serviceQuotationTicket.modifiedDate.label" default="Modified Date" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceQuotationTicketInstance, field: 'modifiedDate', 'errors')}">
                                    <g:datePicker name="modifiedDate" precision="day" value="${serviceQuotationTicketInstance?.modifiedDate}" default="none" noSelection="['': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="status"><g:message code="serviceQuotationTicket.status.label" default="Status" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceQuotationTicketInstance, field: 'status', 'errors')}">
                                    <g:select name="status" from="${com.valent.pricewell.ServiceQuotationTicket$TicketStatusTypes?.values()}" keys="${com.valent.pricewell.ServiceQuotationTicket$TicketStatusTypes?.values()*.name()}" value="${serviceQuotationTicketInstance?.status?.name()}"  />
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
