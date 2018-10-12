
<%@ page import="com.valent.pricewell.DocumentTemplate" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'documentTemplate.label', default: 'DocumentTemplate')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-documentTemplate" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="show-documentTemplate" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list documentTemplate">
			
				<g:if test="${documentTemplateInstance?.templateName}">
				<li class="fieldcontain">
					<span id="templateName-label" class="property-label"><g:message code="documentTemplate.templateName.label" default="Template Name" /></span>
					
						<span class="property-value" aria-labelledby="templateName-label"><g:fieldValue bean="${documentTemplateInstance}" field="templateName"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${documentTemplateInstance?.documentFile}">
				<li class="fieldcontain">
					<span id="documentFile-label" class="property-label"><g:message code="documentTemplate.documentFile.label" default="Document File" /></span>
					
						<span class="property-value" aria-labelledby="documentFile-label"><g:link controller="uploadFile" action="show" id="${documentTemplateInstance?.documentFile?.id}">${documentTemplateInstance?.documentFile?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
			
				<g:if test="${documentTemplateInstance?.isDefault}">
				<li class="fieldcontain">
					<span id="isDefault-label" class="property-label"><g:message code="documentTemplate.isDefault.label" default="Is Default" /></span>
					
						<span class="property-value" aria-labelledby="isDefault-label"><g:formatBoolean boolean="${documentTemplateInstance?.isDefault}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${documentTemplateInstance?.territory}">
				<li class="fieldcontain">
					<span id="territory-label" class="property-label"><g:message code="documentTemplate.territory.label" default="Territory" /></span>
					
						<span class="property-value" aria-labelledby="territory-label"><g:link controller="geo" action="show" id="${documentTemplateInstance?.territory?.id}">${documentTemplateInstance?.territory?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
			
			</ol>
			<g:form>
				<fieldset class="buttons">
					<g:hiddenField name="id" value="${documentTemplateInstance?.id}" />
					<g:link class="edit" action="edit" id="${documentTemplateInstance?.id}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
