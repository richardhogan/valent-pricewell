
<%@ page import="com.valent.pricewell.ProductPricelist" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'productPricelist.label', default: 'ProductPricelist')}" />
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
                        
                            <g:sortableColumn property="id" title="${message(code: 'productPricelist.id.label', default: 'Id')}" />
                        
                            <th><g:message code="productPricelist.modifiedBy.label" default="Modified By" /></th>
                        
                            <g:sortableColumn property="dateModified" title="${message(code: 'productPricelist.dateModified.label', default: 'Date Modified')}" />
                        
                            <th><g:message code="productPricelist.geo.label" default="Geo" /></th>
                        
                            <th><g:message code="productPricelist.product.label" default="Product" /></th>
                        
                            <g:sortableColumn property="unitPrice" title="${message(code: 'productPricelist.unitPrice.label', default: 'Unit Price')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${productPricelistInstanceList}" status="i" var="productPricelistInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${productPricelistInstance.id}">${fieldValue(bean: productPricelistInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: productPricelistInstance, field: "modifiedBy")}</td>
                        
                            <td><g:formatDate date="${productPricelistInstance.dateModified}" /></td>
                        
                            <td>${fieldValue(bean: productPricelistInstance, field: "geo")}</td>
                        
                            <td>${fieldValue(bean: productPricelistInstance, field: "product")}</td>
                        
                            <td>${fieldValue(bean: productPricelistInstance, field: "unitPrice")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${productPricelistInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
