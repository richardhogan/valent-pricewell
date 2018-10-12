
<%@ page import="com.valent.pricewell.SowDiscount" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'sowDiscount.label', default: 'SowDiscount')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-sowDiscount" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-sowDiscount" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
				<thead>
					<tr>
					
						<g:sortableColumn property="description" title="${message(code: 'sowDiscount.description.label', default: 'Description')}" />
					
						<g:sortableColumn property="amount" title="${message(code: 'sowDiscount.amount.label', default: 'Amount')}" />
					
						<g:sortableColumn property="amountPercentage" title="${message(code: 'sowDiscount.amountPercentage.label', default: 'Amount Percentage')}" />
					
						<g:sortableColumn property="isGlobal" title="${message(code: 'sowDiscount.isGlobal.label', default: 'Is Global')}" />
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${sowDiscountInstanceList}" status="i" var="sowDiscountInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${sowDiscountInstance.id}">${fieldValue(bean: sowDiscountInstance, field: "description")}</g:link></td>
					
						<td>${fieldValue(bean: sowDiscountInstance, field: "amount")}</td>
					
						<td>${fieldValue(bean: sowDiscountInstance, field: "amountPercentage")}</td>
					
						<td><g:formatBoolean boolean="${sowDiscountInstance.isGlobal}" /></td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${sowDiscountInstanceTotal}" />
			</div>
		</div>
	</body>
</html>
