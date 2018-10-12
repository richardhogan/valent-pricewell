<%@ page import="com.valent.pricewell.Staging"%>
<html>
	<head>
		<meta name="layout" content="mainSetup" />
			
		<g:set var="entityName"
			value="${message(code: 'setup.label', default: 'Setup')}" />
		<title><g:message code="default.show.label" args="[entityName]" />
		</title>
		
		<modalbox:modalIncludes />
		<ckeditor:resources />
	
	</head>
	
	<body>
		<div class="body">
			<div class="collapsibleContainer">
				
			
				<div class="collapsibleContainerContent ui-widget-content">
					<g:render template="stageProgress" model="['currentStepSequenceOrder': currentStepSequenceOrder, 'stagingInstanceList': stagingInstanceList]"> </g:render>
					
					<g:if test="${currentStepNo != null}">
						<g:render template="stage/${currentStepName}" model="['currentStepNo': currentStepNo, 'currentStepSequenceOrder': currentStepSequenceOrder]"/>
						
					</g:if>
				</div>
			</div>
		</div>	
			
		<br />
		<br />
	</body>
</html>
