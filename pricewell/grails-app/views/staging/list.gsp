
<%@ page import="com.valent.pricewell.Staging" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'staging.label', default: 'Staging')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
    	<div id="mainWorkflowSettingTab">
    	     <g:render template="../staging/list" model="['stagingInstanceList': stagingInstanceList, 'title': title]"/>
   	    </div> 
    </body>
</html>
