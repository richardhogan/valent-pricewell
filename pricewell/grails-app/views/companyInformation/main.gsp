<%@ page import="com.valent.pricewell.Staging"%>
<html>
	<head>
		<meta name="layout" content="mainSetup" />
			
		<g:set var="entityName"
			value="${message(code: 'setup.label', default: 'Setup')}" />
		<title><g:message code="default.show.label" args="[entityName]" />
		</title>
		
		
		<script src="https://cdn.ckeditor.com/4.22.1/standard/ckeditor.js"></script>
	
	</head>
	
	<body>
		<div class="body">
			<div id="mainInformationTab">
				
				<g:if test="${page == 'create' }">
					<g:render template="createInstanceInfo" model="['source': source]"> </g:render>	
				</g:if>
				<g:else>
					<g:render template="showInstanceInfo" model="['source': source, 'instanceInfo': instanceInfo]"> </g:render>
				</g:else>
			
				
			</div>
		</div>	
			
		<br />
		<br />
	</body>
</html>
