
<%@ page import="com.valent.pricewell.RelationDeliveryGeo" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'relationDeliveryGeo.label', default: 'RelationDeliveryGeo')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <g:if test="${createPermission}">
            	<span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
            </g:if>
        </div>
        <div class="body">
            <h1><g:message code="default.show.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            	<!--div class="message">${flash.message}</div-->
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="relationDeliveryGeo.id.label" default="Id" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: relationDeliveryGeoInstance, field: "id")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="relationDeliveryGeo.costPerDay.label" default="Cost Per Day" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: relationDeliveryGeoInstance, field: "costPerDay")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="relationDeliveryGeo.deliveryRole.label" default="Delivery Role" /></td>
                            
                            <td valign="top" class="value"><g:link controller="deliveryRole" action="show" id="${relationDeliveryGeoInstance?.deliveryRole?.id}">${relationDeliveryGeoInstance?.deliveryRole?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="relationDeliveryGeo.geo.label" default="Geo" /></td>
                            
                            <td valign="top" class="value"><g:link controller="geo" action="show" id="${relationDeliveryGeoInstance?.geo?.id}">${relationDeliveryGeoInstance?.geo?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="relationDeliveryGeo.ratePerDay.label" default="Rate Per Day" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: relationDeliveryGeoInstance, field: "ratePerDay")}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <g:hiddenField name="id" value="${relationDeliveryGeoInstance?.id}" />
                    <g:if test="${updatePermission}"><span class="button"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span></g:if>
                    <g:if test="${createPermission}"><span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span></g:if>
                </g:form>
            </div>
        </div>
    </body>
</html>
