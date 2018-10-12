
<%@ page import="com.valent.pricewell.Geo" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <g:set var="entityName" value="${message(code: 'default.geo.label', default: 'Geo')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
        <script>
		 
			  jQuery(document).ready(function()
			  {				 
				  jQuery('td.expandp span1').expander({
					    slicePoint:       200,  // default is 100
					    expandPrefix:     ' ', // default is '... '
					    expandText:       '[...]', // default is 'read more'
					    collapseTimer:    100000, // re-collapses after 100 seconds; default is 0, so no re-collapsing
					    userCollapseText: '[^]'  // default is 'read less'
					  });

				  jQuery("#listGeo").click(function()
					{
						showLoadingBox();
						jQuery.post( '${baseurl}/geo/listsetup' , 
						  	{source: "firstsetup"},
					      	function( data ) 
					      	{
							  	hideLoadingBox();
					          	jQuery('#contents').html('').html(data);
					      	});
						return false;
					});	
			  });
			  
		 
		</script>
    </head>
    <body>
        <div class="body">
        
        	<g:if test="${source=='firstsetup'}">
	        	<div class="collapsibleContainer">
					<div class="collapsibleContainerTitle ui-widget-header">
						<div>Show Territory<span class="button"><button id="listGeo" title="TerritoryList"> Go To List </button></span></div>
					</div>
				
					<div class="collapsibleContainerContent ui-widget-content">
			</g:if>
				
					<div class="dialog">
		                <table>
		                    <tbody>
		                    
		                        <tr class="prop">
		                            <td valign="top" class="name"><label><g:message code="geo.name.label" default="Name : " /></label></td>
		                            
		                            <td valign="top" class="value"><b>${fieldValue(bean: geoInstance, field: "name")}</b></td>
		                            
		                        </tr>
		                    
		                        <tr class="prop">
		                            <td valign="top" class="name"><label><g:message code="geo.id.label" default="Id : " /></label></td>
		                            
		                            <td valign="top" class="value">${fieldValue(bean: geoInstance, field: "id")}</td>
		                            
		                            <td>&nbsp;&nbsp;</td>
		                            
		                            <td valign="top" class="name"><label><g:message code="geo.description.label" default="Description : " /></label></td>
		                            
		                            <td valign="top" class="value">${fieldValue(bean: geoInstance, field: "description")}</td>
		                            
		                        </tr>
		                    
		                    	<tr class="prop">
		                            <td valign="top" class="name"><label><g:message code="geo.salesManager.label" default="Assigned Sales Manager : " /></label></td>
		                            
		                            <td valign="top" class="value">${fieldValue(bean: geoInstance, field: "salesManager")}</td>
		                            
		                            <td>&nbsp;&nbsp;</td>
		                            
		                            <td valign="top" class="name"><label><g:message code="geo.salesPerson.label" default="Assigned Sales Persons : " /></label></td>
		                            
		                            <td valign="top" class="value">
		                            	<g:each in="${geoInstance.salesPersons}" var="g">
		                                    ${g?.encodeAsHTML()}</br>
		                                </g:each>
		                            </td>
		                            
		                        </tr>
		                        
		                        <tr class="prop">
		                    		<td valign="top" class="name"><label><g:message code="geo.dateFormat.label" default="Date Format : " /></label></td>
		                            
		                            <td valign="top" class="value">${fieldValue(bean: geoInstance, field: "dateFormat")}</td>
		                            
		                            <td>&nbsp;&nbsp;</td>
		                            
		                            <td valign="top" class="name"><label><g:message code="geo.country.label" default="Country : " /></label></td>
		                            
		                            <td valign="top" class="value">
		                            	<g:if test="${geoInstance?.country?.size() == 3 }">
                        					<g:country code="${geoInstance?.country}"/>
                        				</g:if>
                       				</td>
		                    	</tr>
		                        
		                        <tr class="prop">
		                            <td valign="top" class="name"><label><g:message code="geo.currency.label" default="Currency : " /></label></td>
		                            
		                            <td valign="top" class="value">${fieldValue(bean: geoInstance, field: "currency")}</td>
		                            
		                            <td>&nbsp;&nbsp;</td>
		                            
		                            <td valign="top" class="name"><label><g:message code="geo.currencySymbol.label" default="CurrencySymbol : " /></label></td>
		                            
		                            <td valign="top" class="value">${fieldValue(bean: geoInstance, field: "currencySymbol")}</td>
		                            
		                        </tr>
		                        
		                        <tr class="prop">
		                            <td valign="top" class="name"><label><g:message code="geo.taxPercent.label" default="Tax (%) : " /></label></td>
		                            
		                            <td valign="top" class="value">${fieldValue(bean: geoInstance, field: "taxPercent")}%</td>
		                            
		                            <td>&nbsp;&nbsp;</td>
		                            
		                            <g:if test="${baseCurrency}">
		                               	<td valign="top" class="name" >
		                               		<label>Convert rate: 1 ${baseCurrency} = </label>
		                               	</td>
		                               	<td valign="top" class="value">
		                               		${geoInstance?.convert_rate} ${geoInstance?.currencySymbol}
		                               	</td>
		                             </g:if>
		                            
		                        </tr>
		                    	
		                    	
		                    	
		                    </tbody>
		                </table>
		                
		            </div>
	            <g:if test="${source=='firstsetup'}">
			            </div>
		            </div>				
	            </g:if>
				
        </div>
    </body>
</html>
