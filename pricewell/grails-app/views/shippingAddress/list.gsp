
<%@ page import="com.valent.pricewell.ShippingAddress" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'shippingAddress.label', default: 'ShippingAddress')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                            <g:sortableColumn property="id" title="${message(code: 'shippingAddress.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="shipCountry" title="${message(code: 'shippingAddress.shipCountry.label', default: 'Ship Country')}" />
                        
                            <g:sortableColumn property="shipAddress" title="${message(code: 'shippingAddress.shipAddress.label', default: 'Ship Address')}" />
                        
                            <g:sortableColumn property="shipState" title="${message(code: 'shippingAddress.shipState.label', default: 'Ship State')}" />
                        
                            <g:sortableColumn property="shipCity" title="${message(code: 'shippingAddress.shipCity.label', default: 'Ship City')}" />
                        
                            <g:sortableColumn property="shipPostalcode" title="${message(code: 'shippingAddress.shipPostalcode.label', default: 'Ship Postalcode')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${shippingAddressInstanceList}" status="i" var="shippingAddressInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${shippingAddressInstance.id}">${fieldValue(bean: shippingAddressInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: shippingAddressInstance, field: "shipCountry")}</td>
                        
                            <td>${fieldValue(bean: shippingAddressInstance, field: "shipAddress")}</td>
                        
                            <td>${fieldValue(bean: shippingAddressInstance, field: "shipState")}</td>
                        
                            <td>${fieldValue(bean: shippingAddressInstance, field: "shipCity")}</td>
                        
                            <td>${fieldValue(bean: shippingAddressInstance, field: "shipPostalcode")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${shippingAddressInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
