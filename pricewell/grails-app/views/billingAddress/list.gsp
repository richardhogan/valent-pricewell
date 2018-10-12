
<%@ page import="com.valent.pricewell.BillingAddress" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'billingAddress.label', default: 'BillingAddress')}" />
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
                        
                            <g:sortableColumn property="id" title="${message(code: 'billingAddress.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="billCountry" title="${message(code: 'billingAddress.billCountry.label', default: 'Bill Country')}" />
                        
                            <g:sortableColumn property="billAddress" title="${message(code: 'billingAddress.billAdress.label', default: 'Bill Address Line1')}" />
                            
                            <g:sortableColumn property="billAddress" title="${message(code: 'billingAddress.billAdress.label', default: 'Bill Address Line2')}" />
                        
                            <g:sortableColumn property="billState" title="${message(code: 'billingAddress.billState.label', default: 'Bill State')}" />
                        
                            <g:sortableColumn property="billCity" title="${message(code: 'billingAddress.billCity.label', default: 'Bill City')}" />
                        
                            <g:sortableColumn property="billPostalcode" title="${message(code: 'billingAddress.billPostalcode.label', default: 'Bill Postalcode')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${billingAddressInstanceList}" status="i" var="billingAddressInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${billingAddressInstance.id}">${fieldValue(bean: billingAddressInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: billingAddressInstance, field: "billCountry")}</td>
                        
                            <td>${fieldValue(bean: billingAddressInstance, field: "billAddressLine1")}</td>
                            
                            <td>${fieldValue(bean: billingAddressInstance, field: "billAddressLine2")}</td>
                        
                            <td>${fieldValue(bean: billingAddressInstance, field: "billState")}</td>
                        
                            <td>${fieldValue(bean: billingAddressInstance, field: "billCity")}</td>
                        
                            <td>${fieldValue(bean: billingAddressInstance, field: "billPostalcode")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${billingAddressInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
