
<%@ page import="com.valent.pricewell.Geo" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'default.geo.label', default: 'Geo')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
        
        <style type="text/css" title="currentStyle">
			@import "${baseurl}/js/dataTables/css/demo_page.css";
			@import "${baseurl}/js/dataTables/css/demo_table.css";
		</style>
			
		<script type="text/javascript" language="javascript" src="${baseurl}/js/dataTables/js/jquery.dataTables.js"></script>
		
		<script>
			jQuery(document).ready(function()
			{
				jQuery('#geoList').dataTable({
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

			function myfun()
			{
				alert("Hi");return false;
			}
		</script>
    </head>
    <body>
        <div class="nav">
            <!-- <span><g:link class="buttons.button button" action="list" controller="deliveryRole">List of Delivery Roles</g:link></span>-->
            <g:if test="${createPermission}">
            	<span><g:link class="buttons.button button" title="Create Territory" action="create" onclick="if(${countGeos==0}){jAlert('There is no any GEO assigned to you, so you can not create territory.', 'Create New Territory Alert');return false;}"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
            </g:if>
            
            <!-- <span><g:link class="buttons.button button" action="list" controller="geoGroup">List of Geos</g:link></span>-->
        </div>
        <div class="body">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            	<!--div class="message">${flash.message}</div-->
            </g:if>
            <div class="list">
                <table cellpadding="0" cellspacing="0" border="0" class="display" id="geoList">
                    <thead>
                        <tr>
                        
                            <th> </th>
                        
                            <th>${message(code: 'geo.name.label', default: 'Name')}</th>
                        
                            <th>${message(code: 'geo.description.label', default: 'Description')}</th>
                            
                            <th>${message(code: 'geo.country.label', default: 'Country')}</th>
                        
                            <th>${message(code: 'geo.currency.label', default: 'Currency')}</th>
                            
                        	<th>${message(code: 'geo.currencySymbol.label', default: 'CurrencySymbol')}</th>
                        	
                        	<th>Sales Manager</th>
                        	
                        	<th>Sales Persons</th>
                        	
                        	<th> GEO </th>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${geoInstanceList}" status="i" var="geoInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" title="Show Details" class="hyperlink" id="${geoInstance.id}">Details</g:link></td>
                        
                            <td>${fieldValue(bean: geoInstance, field: "name")}</td>
                        
                            <td>${fieldValue(bean: geoInstance, field: "description")}</td>
                        
                        	<td>
                        		<g:if test="${geoInstance?.country?.size() == 3 }">
                        			<g:country code="${geoInstance?.country}"/>
                        		</g:if>
                       		</td>
                       		
                            <td>${fieldValue(bean: geoInstance, field: "currency")}</td>
                            
                            <td>${fieldValue(bean: geoInstance, field: "currencySymbol")}</td>
                        
                        	<td>${fieldValue(bean: geoInstance, field: "salesManager")}</td>
							
							<td>
								${geoInstance.salesPersons.join('</br>')}
							</td>
							<td> ${fieldValue(bean: geoInstance, field: "geoGroup")} </td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
        </div>
    </body>
</html>
