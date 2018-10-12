

<%@ page import="com.valent.pricewell.ShippingAddress" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'shippingAddress.label', default: 'ShippingAddress')}" />
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
            <g:hasErrors bean="${shippingAddressInstance}">
            <div class="errors">
                <g:renderErrors bean="${shippingAddressInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <g:hiddenField name="id" value="${shippingAddressInstance?.id}" />
                <g:hiddenField name="version" value="${shippingAddressInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="shipCountry"><g:message code="shippingAddress.shipCountry.label" default="Ship Country" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: shippingAddressInstance, field: 'shipCountry', 'errors')}">
                                    <g:textField name="shipCountry" value="${shippingAddressInstance?.shipCountry}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="shipAddress"><g:message code="shippingAddress.shipAddress.label" default="Ship Address" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: shippingAddressInstance, field: 'shipAddress', 'errors')}">
                                    <g:textField name="shipAddress" value="${shippingAddressInstance?.shipAddress}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="shipState"><g:message code="shippingAddress.shipState.label" default="Ship State" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: shippingAddressInstance, field: 'shipState', 'errors')}">
                                    <g:textField name="shipState" value="${shippingAddressInstance?.shipState}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="shipCity"><g:message code="shippingAddress.shipCity.label" default="Ship City" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: shippingAddressInstance, field: 'shipCity', 'errors')}">
                                    <g:textField name="shipCity" value="${shippingAddressInstance?.shipCity}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="shipPostalcode"><g:message code="shippingAddress.shipPostalcode.label" default="Ship Postalcode" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: shippingAddressInstance, field: 'shipPostalcode', 'errors')}">
                                    <g:textField name="shipPostalcode" value="${shippingAddressInstance?.shipPostalcode}" />
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
