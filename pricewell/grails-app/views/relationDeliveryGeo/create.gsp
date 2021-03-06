

<%@ page import="com.valent.pricewell.RelationDeliveryGeo" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'relationDeliveryGeo.label', default: 'RelationDeliveryGeo')}" />
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
            <g:hasErrors bean="${relationDeliveryGeoInstance}">
            <div class="errors">
                <g:renderErrors bean="${relationDeliveryGeoInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="costPerDay"><g:message code="relationDeliveryGeo.costPerDay.label" default="Cost Per Day" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: relationDeliveryGeoInstance, field: 'costPerDay', 'errors')}">
                                    <g:textField name="costPerDay" value="${fieldValue(bean: relationDeliveryGeoInstance, field: 'costPerDay')}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="deliveryRole"><g:message code="relationDeliveryGeo.deliveryRole.label" default="Delivery Role" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: relationDeliveryGeoInstance, field: 'deliveryRole', 'errors')}">
                                    <g:select name="deliveryRole.id" from="${com.valent.pricewell.DeliveryRole.list()}" optionKey="id" value="${relationDeliveryGeoInstance?.deliveryRole?.id}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="geo"><g:message code="relationDeliveryGeo.geo.label" default="Geo" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: relationDeliveryGeoInstance, field: 'geo', 'errors')}">
                                    <g:select name="geo.id" from="${com.valent.pricewell.Geo.list()}" optionKey="id" value="${relationDeliveryGeoInstance?.geo?.id}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="ratePerDay"><g:message code="relationDeliveryGeo.ratePerDay.label" default="Rate Per Day" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: relationDeliveryGeoInstance, field: 'ratePerDay', 'errors')}">
                                    <g:textField name="ratePerDay" value="${fieldValue(bean: relationDeliveryGeoInstance, field: 'ratePerDay')}" />
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
