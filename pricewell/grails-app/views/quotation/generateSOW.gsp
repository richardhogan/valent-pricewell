<%@ page import="com.valent.pricewell.Quotation"%>

<%
	def baseurl = request.siteUrl
%>

<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<meta name="layout" content="main" />
		<r:require module="wizardui"/>
		<g:setProvider library="prototype"/>
		
		<g:set var="entityName"
			value="${message(code: 'quotation.label', default: 'Quotation Contract')}" />
			
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
		
		<ckeditor:resources />
	
	</head>
	
	<body>
		<div class="body">
			<div class="collapsibleContainer">
				<div class="collapsibleContainerTitle ui-widget-header">
					<div>Generate SOW For Quotation : #${quotationInstance?.id}</div>
				</div>
			
				<div class="collapsibleContainerContent ui-widget-content">
					<div><!-- details of opportunity the quotation belongs to --></div>
					
					<g:render template="generateSOW/generatesow" model="['quotationInstance': quotationInstance, 'currentStep': currentStep, 'isSampleSowOfTemplaterType': isSampleSowOfTemplaterType]"/>
					
				</div>
				
			</div>
		</div>	
		
	</body>
</html>
