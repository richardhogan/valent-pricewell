
<%@ page import="com.valent.pricewell.ServiceProductItem" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'serviceProductItem.label', default: 'ServiceProductItem')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
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
                        
                            <g:sortableColumn property="id" title="${message(code: 'serviceProductItem.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="productName" title="${message(code: 'serviceProductItem.productName.label', default: 'Product Name')}" />
                        
                            <g:sortableColumn property="productType" title="${message(code: 'serviceProductItem.productType.label', default: 'Product Type')}" />
                        
                            <g:sortableColumn property="quantity" title="${message(code: 'serviceProductItem.quantity.label', default: 'Quantity')}" />
                        
                            <th><g:message code="serviceProductItem.serviceProfile.label" default="Service Profile" /></th>
                        
                            <g:sortableColumn property="totalCost" title="${message(code: 'serviceProductItem.totalCost.label', default: 'Total Cost')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${serviceProductItemInstanceList}" status="i" var="serviceProductItemInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${serviceProductItemInstance.id}">${fieldValue(bean: serviceProductItemInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: serviceProductItemInstance, field: "productName")}</td>
                        
                            <td>${fieldValue(bean: serviceProductItemInstance, field: "productType")}</td>
                        
                            <td>${fieldValue(bean: serviceProductItemInstance, field: "quantity")}</td>
                        
                            <td>${fieldValue(bean: serviceProductItemInstance, field: "serviceProfile")}</td>
                        
                            <td>${fieldValue(bean: serviceProductItemInstance, field: "totalCost")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${serviceProductItemInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
