
<%@ page import="com.valent.pricewell.ServiceProductItem" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'serviceProductItem.label', default: 'ServiceProductItem')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.show.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="serviceProductItem.id.label" default="Id" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: serviceProductItemInstance, field: "id")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="serviceProductItem.productName.label" default="Product Name" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: serviceProductItemInstance, field: "productName")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="serviceProductItem.productType.label" default="Product Type" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: serviceProductItemInstance, field: "productType")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="serviceProductItem.quantity.label" default="Quantity" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: serviceProductItemInstance, field: "quantity")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="serviceProductItem.serviceProfile.label" default="Service Profile" /></td>
                            
                            <td valign="top" class="value"><g:link controller="serviceProfile" action="show" id="${serviceProductItemInstance?.serviceProfile?.id}">${serviceProductItemInstance?.serviceProfile?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="serviceProductItem.serviceProfiles.label" default="Service Profiles" /></td>
                            
                            <td valign="top" style="text-align: left;" class="value">
                                <ul>
                                <g:each in="${serviceProductItemInstance.serviceProfiles}" var="s">
                                    <li><g:link controller="serviceProfile" action="show" id="${s.id}">${s?.encodeAsHTML()}</g:link></li>
                                </g:each>
                                </ul>
                            </td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="serviceProductItem.totalCost.label" default="Total Cost" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: serviceProductItemInstance, field: "totalCost")}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <g:hiddenField name="id" value="${serviceProductItemInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
