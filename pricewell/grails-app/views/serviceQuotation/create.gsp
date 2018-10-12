<%@ page import="com.valent.pricewell.ServiceQuotation" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'serviceQuotation.label', default: 'ServiceQuotation')}" />
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
            <g:hasErrors bean="${serviceQuotationInstance}">
            <div class="errors">
                <g:renderErrors bean="${serviceQuotationInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="service"><g:message code="serviceQuotation.service.label" default="Service" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceQuotationInstance, field: 'service', 'errors')}">
                                    <g:select name="service.id" from="${com.valent.pricewell.Service.list()}" optionKey="id" value="${serviceQuotationInstance?.service?.id}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="baseUnits"><g:message code="serviceQuotation.baseUnits.label" default="Base Units" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceQuotationInstance, field: 'baseUnits', 'errors')}">
                                    <g:textField name="baseUnits" value="${fieldValue(bean: serviceQuotationInstance, field: 'baseUnits')}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="additionalUnits"><g:message code="serviceQuotation.additionalUnits.label" default="Additional Units" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceQuotationInstance, field: 'additionalUnits', 'errors')}">
                                    <g:textField name="additionalUnits" value="${fieldValue(bean: serviceQuotationInstance, field: 'additionalUnits')}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="geo"><g:message code="serviceQuotation.geo.label" default="Geo" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceQuotationInstance, field: 'geo', 'errors')}">
                                    <g:select name="geo.id" from="${com.valent.pricewell.Geo.list()}" optionKey="id" value="${serviceQuotationInstance?.geo?.id}" noSelection="['null': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="price"><g:message code="serviceQuotation.price.label" default="Price" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceQuotationInstance, field: 'price', 'errors')}">
                                    <g:textField name="price" value="${fieldValue(bean: serviceQuotationInstance, field: 'price')}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="quotation"><g:message code="serviceQuotation.quotation.label" default="Quotation" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceQuotationInstance, field: 'quotation', 'errors')}">
                                    <g:select name="quotation.id" from="${com.valent.pricewell.Quotation.list()}" optionKey="id" value="${serviceQuotationInstance?.quotation?.id}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="profile"><g:message code="serviceQuotation.profile.label" default="Profile" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceQuotationInstance, field: 'profile', 'errors')}">
                                    <g:select name="profile.id" from="${com.valent.pricewell.ServiceProfile.list()}" optionKey="id" value="${serviceQuotationInstance?.profile?.id}"  />
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
