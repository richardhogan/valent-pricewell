

<%@ page import="com.valent.pricewell.ServiceProductItem" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'serviceProductItem.label', default: 'ServiceProductItem')}" />
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
            <g:hasErrors bean="${serviceProductItemInstance}">
            <div class="errors">
                <g:renderErrors bean="${serviceProductItemInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <g:hiddenField name="id" value="${serviceProductItemInstance?.id}" />
                <g:hiddenField name="version" value="${serviceProductItemInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="productName"><g:message code="serviceProductItem.productName.label" default="Product Name" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProductItemInstance, field: 'productName', 'errors')}">
                                    <g:textField name="productName" value="${serviceProductItemInstance?.productName}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="productType"><g:message code="serviceProductItem.productType.label" default="Product Type" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProductItemInstance, field: 'productType', 'errors')}">
                                    <g:textField name="productType" value="${serviceProductItemInstance?.productType}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="quantity"><g:message code="serviceProductItem.quantity.label" default="Quantity" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProductItemInstance, field: 'quantity', 'errors')}">
                                    <g:textField name="quantity" value="${serviceProductItemInstance?.quantity}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="serviceProfile"><g:message code="serviceProductItem.serviceProfile.label" default="Service Profile" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProductItemInstance, field: 'serviceProfile', 'errors')}">
                                    <g:select name="serviceProfile.id" from="${com.valent.pricewell.ServiceProfile.list()}" optionKey="id" value="${serviceProductItemInstance?.serviceProfile?.id}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="serviceProfiles"><g:message code="serviceProductItem.serviceProfiles.label" default="Service Profiles" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProductItemInstance, field: 'serviceProfiles', 'errors')}">
                                    <g:select name="serviceProfiles" from="${com.valent.pricewell.ServiceProfile.list()}" multiple="yes" optionKey="id" size="5" value="${serviceProductItemInstance?.serviceProfiles*.id}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="totalCost"><g:message code="serviceProductItem.totalCost.label" default="Total Cost" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProductItemInstance, field: 'totalCost', 'errors')}">
                                    <g:textField name="totalCost" value="${fieldValue(bean: serviceProductItemInstance, field: 'totalCost')}" />
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
