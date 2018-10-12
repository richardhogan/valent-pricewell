
<%@ page import="com.valent.pricewell.SowDiscount" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'sowDiscount.label', default: 'SowDiscount')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-sowDiscount" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="show-sowDiscount" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list sowDiscount">
			
				<g:if test="${sowDiscountInstance?.description}">
				<li class="fieldcontain">
					<span id="description-label" class="property-label"><g:message code="sowDiscount.description.label" default="Description" /></span>
					
						<span class="property-value" aria-labelledby="description-label"><g:fieldValue bean="${sowDiscountInstance}" field="description"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${sowDiscountInstance?.amount}">
				<li class="fieldcontain">
					<span id="amount-label" class="property-label"><g:message code="sowDiscount.amount.label" default="Amount" /></span>
					
						<span class="property-value" aria-labelledby="amount-label"><g:fieldValue bean="${sowDiscountInstance}" field="amount"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${sowDiscountInstance?.amountPercentage}">
				<li class="fieldcontain">
					<span id="amountPercentage-label" class="property-label"><g:message code="sowDiscount.amountPercentage.label" default="Amount Percentage" /></span>
					
						<span class="property-value" aria-labelledby="amountPercentage-label"><g:fieldValue bean="${sowDiscountInstance}" field="amountPercentage"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${sowDiscountInstance?.isGlobal}">
				<li class="fieldcontain">
					<span id="isGlobal-label" class="property-label"><g:message code="sowDiscount.isGlobal.label" default="Is Global" /></span>
					
						<span class="property-value" aria-labelledby="isGlobal-label"><g:formatBoolean boolean="${sowDiscountInstance?.isGlobal}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${sowDiscountInstance?.quotations}">
				<li class="fieldcontain">
					<span id="quotations-label" class="property-label"><g:message code="sowDiscount.quotations.label" default="Quotations" /></span>
					
						<g:each in="${sowDiscountInstance.quotations}" var="q">
						<span class="property-value" aria-labelledby="quotations-label"><g:link controller="quotation" action="show" id="${q.id}">${q?.encodeAsHTML()}</g:link></span>
						</g:each>
					
				</li>
				</g:if>
			
			</ol>
			<g:form>
				<fieldset class="buttons">
					<g:hiddenField name="id" value="${sowDiscountInstance?.id}" />
					<g:link class="edit" action="edit" id="${sowDiscountInstance?.id}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
