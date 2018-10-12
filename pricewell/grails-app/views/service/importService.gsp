<%@ page import="com.valent.pricewell.Service"%>
<%@ page import="com.valent.pricewell.ServiceProfile"%>
<%@ page import="com.valent.pricewell.Staging"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="layout" content="main" />
<r:require module="wizardui"/>
<g:set var="entityName"
	value="${message(code: 'service.label', default: 'ServiceProfile')}" />
	
<title><g:message code="default.show.label" args="[entityName]" />
</title>

<style>
p {
	font-size: 100%;
	margin: 0 0 0em;
}

td.name {
	font-weight: bold;
	font-size: 85%
}

td.Value {
	font-weight: bold;
	font-size: 95%
}

td.reduced {
	font-size: 90%
}

label.error 
	{
		margin-left: 10px;
		width: auto;
		display: inline;
	}
  	em { font-weight: bold; padding-right: 1em; vertical-align: top; }
  	
</style>

<r:require module="wizardui"/>

<ckeditor:resources />

</head>

<body>
	<g:set var="title" value="${serviceProfileInstance?.id != null?serviceProfileInstance.toString(): 'Import service'}"/>
	<div class="body">
		<div class="collapsibleContainer">
			<div class="collapsibleContainerTitle ui-widget-header">
				<div>Service: ${title}</div>
			</div>
		
			<div class="collapsibleContainerContent ui-widget-content">
				<g:render template="import/stageProgress" model="['serviceProfileInstance': serviceProfileInstance, 'importServiceStages': importServiceStages]"> </g:render>
				
				<g:if test="${serviceProfileInstance.id == null}">
					<g:render template="import/init" model="['serviceProfileInstance': serviceProfileInstance]"/>
				</g:if>
				<g:else>
					<g:render template="import/${serviceProfileInstance.importServiceStage }" model="['serviceProfileInstance': serviceProfileInstance, 'importServiceStageSteps': importServiceStageSteps]"/>
				</g:else>
			</div>
			
		</div>
	</div>	
	
</body>
</html>
