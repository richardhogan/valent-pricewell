
<%@ page import="com.valent.pricewell.GeoGroup" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'default.geoGroup.label', default: 'GeoGroup')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
        
        <style type="text/css" title="currentStyle">
			@import "${baseurl}/js/dataTables/css/demo_page.css";
			@import "${baseurl}/js/dataTables/css/demo_table.css";
		</style>
			
		<script type="text/javascript" language="javascript" src="${baseurl}/js/dataTables/js/jquery.dataTables.js"></script>
		
		<script>
			jQuery(document).ready(function()
			{
				jQuery('#geoGroupList').dataTable({
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
				<span><g:link class="buttons.button button" title="Create GEO" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
			</g:if>
            <!-- <span><g:link class="buttons.button button" action="list" controller="deliveryRole">List of Delivery Roles</g:link></span>
            <span><g:link class="buttons.button button" action="list" controller="geo">List of Territories</g:link></span>-->
        </div>
        <div class="body">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            
            <div class="list">
                <table cellpadding="0" cellspacing="0" border="0" class="display" id="geoGroupList">
                    <thead>
                        <tr>
                        
                            <th></th>
                        
                            <th>${message(code: 'geoGroup.name.label', default: 'Name')} </th>
                        
                            <th>${message(code: 'geoGroup.description.label', default: 'Description')}</th>
                            
                            <th>${message(code: 'geoGroup.generalManager.label', default: 'Assigned General Manager')}</th>
                            
                        	<th> List of Territories</th>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${geoGroupInstanceList}" status="i" var="geoGroupInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" title="Show Details" class="hyperlink" id="${geoGroupInstance.id}">Details</g:link></td>
                        
                            <td>${fieldValue(bean: geoGroupInstance, field: "name")}</td>
                        
                            <td>${fieldValue(bean: geoGroupInstance, field: "description")}</td>
                            
                            <td>
                            	<g:each in="${geoGroupInstance.generalManagers}" var="g">
                                    ${g?.encodeAsHTML()}
                                </g:each>
                            </td>
                            
                        	<td> ${geoGroupInstance.geos*.name.join('</br>')} </td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <!-- <div class="paginateButtons">
                <g:paginate total="${geoGroupInstanceTotal}" />
            </div>-->
        </div>
    </body>
</html>
