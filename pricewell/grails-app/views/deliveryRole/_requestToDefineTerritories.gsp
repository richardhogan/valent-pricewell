
<%@ page import="com.valent.pricewell.DeliveryRole" %>
<%@ page import="com.valent.pricewell.Geo" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
    	<script>
		   	jQuery(function() 
		   	{
				jQuery( "#tabsDiv" ).tabs();

				jQuery("#requestToDefineRateCost").validate();
				
				jQuery("#saveRequestBtn").click(function()
				{
					if(jQuery("#requestToDefineRateCost").validate().form())
					{
						showLoadingBox();
						jQuery.ajax({
							type: "POST",
							url: "${baseurl}/deliveryRole/sendRequest",
							data:jQuery("#requestToDefineRateCost").serialize(),
							success: function(data)
							{
								hideLoadingBox();
								if(data == "success"){
									jQuery("#dvSelectTerritory").dialog("close");
									jQuery("#successRequestDialog").dialog("open");
								}
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){
								alert("Error while saving");
							}
						});
					}
					return false;
				});

				jQuery( "#successRequestDialog" ).dialog(
				{
					modal: true,
					autoOpen: false,
					resizable: false,
					buttons: {
						OK: function() {
							jQuery( "#successRequestDialog" ).dialog( "close" );
							return false;
						}
					},
					close: function( event, ui ) {
						jQuery(this).html('');
					}
				});
			});
	   	</script>	
   	
    </head>
    <body>
        
        <div class="body">
        	<div id="successRequestDialog" title="Success">
				<p><g:message code="defineRateCostRequestToAdministrator.message.success.dialog" default=""/></p>
			</div>
				
		            <div class="dialog">
		                <table>
		                    <tbody>
		                    
		                        <tr class="prop">
		                            <td valign="top" class="name"><b><g:message code="deliveryRole.name.label" default="Delivery Role" /></b></td>
		                            <td>&nbsp;&nbsp;</td>
		                            <td valign="top" class="value">${fieldValue(bean: deliveryRoleInstance, field: "name")}</td>
		                            
		                        </tr>
		                    
		                        <tr class="prop">
		                            <td valign="top" class="name"><b>Service</b></td>
		                            <td>&nbsp;&nbsp;</td>
		                            <td valign="top" class="value">${fieldValue(bean: serviceInstance, field: "serviceName")}</td>
		                            
		                        </tr>
		                    
		                    </tbody>
		                </table>
		            </div>
		            <div><b>Note : </b><g:message code="defineRateCostRequestToAdministrator.note.message" default=""/></div>
		            
		            <div id="defineratecost">
							
						<h2>Undefined Territories</h2>
						<div id ="dvGeoForDeliveryRole">
		            		<g:set var="undefinedGeoCount" value="${deliveryRoleInstance?.listUndefinedGeos()?.size()}"/>
		            		<g:set var="geosCount" value="${Geo.list()?.size()}"/>
		            		
		            		<g:form method="POST" name="requestToDefineRateCost">
		            			<g:hiddenField name="deliveryRoleId" value="${deliveryRoleInstance.id}"/>
		            			<g:hiddenField name="serviceId" value="${serviceInstance.id}"/>
		            			<g:if test="${geosCount > 0 &&  undefinedGeoCount>0 }">
		            				
				            		<table>
				            			<g:each in="${deliveryRoleInstance?.listUndefinedGeos()}" status="i" var="geo">
				            			<tr>
				            				<td> <g:checkBox name="check.${geo?.id}" value="${false}"/> </td>
				            				<td> ${geo.name} </td>
				            			</tr>
				            			</g:each>
				            		</table>
				            		
				            		<div class="buttons">
					                	<span class="button"><button id="saveRequestBtn" title="Send Request"> Send </button></span>
					   				</div>
				            	</g:if>
				            	<g:else>
					            	<g:if test="${geosCount == 0}">
					            		<br/>
					            		<br/>
					            		<h4> No Territories have been defined.</h4> 
					            			
					            	</g:if>
					            	<g:elseif test="${undefinedGeoCount == 0}">
					            		<br/>
					            		<br/>
					            		<h4> Rates/costs for all Territories are defined.</h4>
					            			
					            	</g:elseif>
				            	</g:else>
			            	</g:form>
			            </div>
					            
					</div>
					
        </div>
    </body>
</html>
