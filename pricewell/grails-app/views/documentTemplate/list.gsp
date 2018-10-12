
<%@ page import="com.valent.pricewell.DocumentTemplate" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'documentTemplate.label', default: 'DocumentTemplate')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-documentTemplate" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-documentTemplate" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
				<thead>
					<tr>
					
						<g:sortableColumn property="templateName" title="${message(code: 'documentTemplate.templateName.label', default: 'Template Name')}" />
					
						<th><g:message code="documentTemplate.documentFile.label" default="Document File" /></th>
					
						<g:sortableColumn property="isDefault" title="${message(code: 'documentTemplate.isDefault.label', default: 'Is Default')}" />
					
						<th><g:message code="documentTemplate.territory.label" default="Territory" /></th>
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${documentTemplateInstanceList}" status="i" var="documentTemplateInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${documentTemplateInstance.id}">${fieldValue(bean: documentTemplateInstance, field: "templateName")}</g:link></td>
					
						<td>${fieldValue(bean: documentTemplateInstance, field: "documentFile")}</td>
					
						<td><g:formatBoolean boolean="${documentTemplateInstance.isDefault}" /></td>
					
						<td>${fieldValue(bean: documentTemplateInstance, field: "territory")}</td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${documentTemplateInstanceTotal}" />
			</div>
		</div>
	</body>
</html>
