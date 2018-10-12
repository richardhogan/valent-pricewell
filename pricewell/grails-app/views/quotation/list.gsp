
<%@ page import="com.valent.pricewell.Quotation" %>
<html>
    <head>
    	<script type="text/javascript" src="http://www.google.com/jsapi"></script>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'quotation.label', default: 'Quotation')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
           <!-- <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>-->
        </div>
        <div class="body">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <!--div class="message">${flash.message}</div-->
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                           <th> </th>
                        
                            <g:sortableColumn property="account" title="${message(code: 'quotation.account.label', default: 'Account')}" />
                        
                            <g:sortableColumn property="customerType" title="${message(code: 'quotation.customerType.label', default: 'Customer Type')}" />
                        
                            <g:sortableColumn property="createdDate" title="${message(code: 'quotation.createdDate.label', default: 'Created Date')}" />
                        
                            <th><g:message code="quotation.geo.label" default="Geo" /></th>
                            
                            <th><g:message code="quotation.status" default="Quote Type" /></th>
                        
                            <g:sortableColumn property="totalQuotedPrice" title="${message(code: 'quotation.totalQuotedPrice.label', default: 'Total Quoted Price')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${quotationInstanceList}" status="i" var="quotationInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${quotationInstance.id}">details</g:link></td>
                        
                            <td>${fieldValue(bean: quotationInstance, field: "account.accountName")}</td>
                        
                            <td>${fieldValue(bean: quotationInstance, field: "customerType")}</td>
                        
                            <td><g:formatDate format="MMMMM d, yyyy" date="${quotationInstance.createdDate}" /></td>
                        
                            <td>${fieldValue(bean: quotationInstance, field: "geo")}</td>
                            
                            <td>${fieldValue(bean: quotationInstance, field: "status")}</td>
                        
                            <td>${fieldValue(bean: quotationInstance, field: "totalQuotedPrice")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${quotationInstanceTotal}" />
            </div>
        </div>
        
        
    </body>
</html>
