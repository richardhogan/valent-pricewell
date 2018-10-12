
<%@ page import="com.valent.pricewell.FieldMapping" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'fieldMapping.label', default: 'FieldMapping')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-fieldMapping" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-fieldMapping" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
				<thead>
					<tr>
					
						<g:sortableColumn property="value" title="${message(code: 'fieldMapping.value.label', default: 'Value')}" />
					
						<g:sortableColumn property="type" title="${message(code: 'fieldMapping.type.label', default: 'Type')}" />
					
						<g:sortableColumn property="key" title="${message(code: 'fieldMapping.key.label', default: 'Key')}" />
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${fieldMappingInstanceList}" status="i" var="fieldMappingInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${fieldMappingInstance.id}">${fieldValue(bean: fieldMappingInstance, field: "value")}</g:link></td>
					
						<td>${fieldValue(bean: fieldMappingInstance, field: "type")}</td>
					
						<td>${fieldValue(bean: fieldMappingInstance, field: "key")}</td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${fieldMappingInstanceTotal}" />
			</div>
		</div>
	</body>
</html>
