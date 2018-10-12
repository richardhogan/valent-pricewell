
<%@ page import="com.valent.pricewell.SowIntroduction" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'SowIntroduction.label', default: 'Sow Introduction')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
        
        <style type="text/css" title="currentStyle">
			@import "${baseurl}/js/dataTables/css/demo_page.css";
			@import "${baseurl}/js/dataTables/css/demo_table.css";
		</style>
			
		<script type="text/javascript" language="javascript" src="${baseurl}/js/dataTables/js/jquery.dataTables.js"></script>
		
		<script>
			jQuery(document).ready(function()
			{
				jQuery('#SowIntroductionList').dataTable({
					"sPaginationType": "full_numbers",
					"sDom": 't<"F"ip>',
			        "bFilter": false,
			        "fnDrawCallback": function() {
		                if (Math.ceil((this.fnSettings().fnRecordsDisplay()) / this.fnSettings()._iDisplayLength) > 1)  {
		                        jQuery('.dataTables_paginate').css("display", "block"); 
		                        jQuery('.dataTables_length').css("display", "block");                 
		                } else {
		                		jQuery('.dataTables_paginate').css("display", "none");
		                		jQuery('.dataTables_length').css("display", "none");
		                }
		            }
				});
			});
		</script>
    </head>
    <body>
        <div class="nav">
        	<g:if test="${createPermission}">
            	<span><g:link class="create" title="Create Sow Introduction" action="create" class="buttons.button button"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
            </g:if>
            
            <!-- <span><g:link class="buttons.button button" action="list" controller="geo">List of Territories</g:link></span>
            <span><g:link class="buttons.button button" action="list" controller="geoGroup">List of Geos</g:link></span>-->
        </div>
        <div class="body">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            	<!--div class="message">${flash.message}</div-->
            </g:if>
            <div class="list">
                <table cellpadding="0" cellspacing="0" border="0" class="display" id="SowIntroductionList">
                    <thead>
                        <tr>
                        
                            <th> </th>
                        
                            <th>${message(code: 'SowIntroduction.name.label', default: 'Name')}</th>
                        
                            <th>${message(code: 'SowIntroduction.sow_text.label', default: 'Sow Text')}</th>
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${SowIntroductionInstanceList}" status="i" var="SowIntroductionInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" title="Show Details" class="hyperlink" id="${SowIntroductionInstance.id}">Details</g:link></td>
                        
                            <td>${fieldValue(bean: SowIntroductionInstance, field: "name")}</td>
                        
                            <td>${fieldValue(bean: SowIntroductionInstance, field: "sow_text")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            
        </div>
    </body>
</html>
