<%@ page import="com.valent.pricewell.Service"%>
<%@ page import="com.valent.pricewell.ServiceProfile"%>
<%@ page import="com.valent.pricewell.Staging"%>
<%
	def baseurl = request.siteUrl
%>

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
			font-size: 100%
		}
		
		td.Value {
			font-weight: bold;
			font-size: 100%
		}
		
		td.reduced {
			font-size: 100%
		}
		
		label.error 
		{
			margin-left: 10px;
			width: auto;
			display: inline;
		}
	  	em { font-weight: bold; padding-right: 1em; vertical-align: top; }
	  	
	  	.ui-tabs-vertical { width: 55em; }
	  	.ui-tabs-vertical .ui-tabs-nav { padding: .2em .1em .2em .2em; float: left; }
	  	.ui-tabs-vertical .ui-tabs-nav li { clear: left; width: 100%; border-bottom-width: 1px !important; border-right-width: 0 !important; margin: 0 -1px .2em 0; }
	  	.ui-tabs-vertical .ui-tabs-nav li a { display:block; }
	  	.ui-tabs-vertical .ui-tabs-nav li.ui-tabs-active { padding-bottom: 0; padding-right: .1em; border-right-width: 1px; border-right-width: 1px; }
	  	.ui-tabs-vertical .ui-tabs-panel { padding: 1em; float: right; width: 40em;}
	</style>
	
	<r:require module="wizardui"/>
	
	<ckeditor:resources />

</head>

<body>
	<g:set var="title" value="${serviceProfileInstance?.id != null?serviceProfileInstance.toString(): 'New service'}"/>
	<div class="body">
		<div class="collapsibleContainer">
			<div class="collapsibleContainerTitle ui-widget-header">
				<div>Service: ${title}</div>
			</div>
		
			<div class="collapsibleContainerContent ui-widget-content">
			
				<g:render template="stageProgress" model="['serviceProfileInstance': serviceProfileInstance, 'stagingInstanceList': stagingInstanceList]"> </g:render>
				
				<g:if test="${serviceProfileInstance.id == null}">
					<g:render template="stage/init" model="['serviceProfileInstance':serviceProfileInstance]"/>
				</g:if>
				<g:else>
					<g:render template="stage/${serviceProfileInstance?.stagingStatus?.name}" />
				</g:else>
			</div>
			
		</div>
	</div>	
	
</body>
</html>
