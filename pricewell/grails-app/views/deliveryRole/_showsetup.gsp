
<%@ page import="com.valent.pricewell.DeliveryRole" %>
<%@ page import="com.valent.pricewell.Geo" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
    	<g:setProvider library="prototype"/>
    	<script>
		   	jQuery(function() 
		   	{
				jQuery( "#tabsDiv" ).tabs();

				jQuery("#listDeliveryRole").click(function()
				{
					showLoadingBox();
					jQuery.post( '${baseurl}/deliveryRole/listsetup' , 
					  	{source: "firstsetup"},
				      	function( data ) 
				      	{
						  	hideLoadingBox();
				          	jQuery('#contents').html('').html(data);
				      	});
					return false;
				});	

				jQuery("#addTerritoryForDeliveryRole").click(function()
				{
					showLoadingBox();
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/relationDeliveryGeo/addGeosForDeliveryRoleSetup",
						data: jQuery("#territoryRateCardfrm").serialize(),
						success: function(data){
							hideLoadingBox();
							if(data != "no_selected")
								{jQuery('#dvGeoForDeliveryRole').html('').html(data);}
							else if(data == "no_selected")
								{jAlert('Select at least one territory to add.', 'Add Territory Alert');}
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
					});
					return false;
				});	
			});
	   	</script>	
   	
    </head>
    <body>
        
        <div class="body">
        	<g:if test="${source=='firstsetup'}">
	        	<div class="collapsibleContainer" >
					<div class="collapsibleContainerTitle ui-widget-header" >
						<div>Show Delivery Role<span class="button"><button id="listDeliveryRole" title="Delivery Role List"> Go To List </button></span></div>
					</div>
				
					<div class="collapsibleContainerContent ui-widget-content" >
			</g:if>
				
		            <div class="dialog">
		                <table>
		                    <tbody>
		                    
		                        <tr class="prop">
		                            <td valign="top" class="name"><b><g:message code="deliveryRole.name.label" default="Name" /></b></td>
		                            <td>&nbsp;&nbsp;</td>
		                            <td valign="top" class="value">${fieldValue(bean: deliveryRoleInstance, field: "name")}</td>
		                            
		                        </tr>
		                    
		                        <tr class="prop">
		                            <td valign="top" class="name"><b><g:message code="deliveryRole.description.label" default="Description" /></b></td>
		                            <td>&nbsp;&nbsp;</td>
		                            <td valign="top" class="value">${fieldValue(bean: deliveryRoleInstance, field: "description")}</td>
		                            
		                        </tr>
		                    
		                    </tbody>
		                </table>
		            </div>
		            
		            <div id="tabsDiv">
		            	<ul>
		            		<g:if test="${deliveryRoleInstance?.relationDeliveryGeos.size()}">
				 				<li><a href="#ratecostpergeo">Rates/Costs per Territory</a></li>
				 			</g:if>
							<g:if test="${updatePermission}">
								<li><a href="#defineratecost" >Define Rates/Costs for other Territories</a></li>
							</g:if>	
						</ul>
						
						<g:if test="${deliveryRoleInstance?.relationDeliveryGeos.size()}">
							<div id="ratecostpergeo">
							
								<div id="dvRateCostsPerGeo">
			            			<g:if test="${updatePermission}">
			            				<g:render template="/relationDeliveryGeo/listForDeliveryRoleSetup" model="['relationDeliveryGeoList': relationDeliveryGeoList, 'deliveryRoleInstance': deliveryRoleInstance, 'source': source]"> </g:render>
			            			</g:if>
			            			<g:else>
			   							<g:render template="/relationDeliveryGeo/listForDeliveryRoleReadOnly" model="['relationDeliveryGeoList': relationDeliveryGeoList, 'deliveryRoleInstance': deliveryRoleInstance]"> </g:render>         			
			            			</g:else>
			            		</div>
			            		
							</div>
						</g:if>
						
						<g:if test="${updatePermission}">
							<div id="defineratecost">
							
								<div id ="dvGeoForDeliveryRole"  style="height: 325px; overflow:auto;">
				            		<g:set var="undefinedGeoCount" value="${deliveryRoleInstance?.listUndefinedGeos()?.size()}"/>
				            		<g:set var="geosCount" value="${Geo.list()?.size()}"/>
				            		
				            		<g:form name="territoryRateCardfrm" method="POST" >
				            			<g:hiddenField name="deliveryRoleId" value="${deliveryRoleInstance.id}"/>
				            			<g:hiddenField name="source" value="${source}"/>
				            			<g:if test="${geosCount > 0 &&  undefinedGeoCount>0 }">
				            				
				            				<div class="buttons">
							                	<span class="button"><button id="addTerritoryForDeliveryRole" title="Add Territories"> Add Territories </button></span>
							                </div>
							                
							                <div class="list" style="height: 300px; overflow:auto;">
							            		<table>
							            			<g:each in="${deliveryRoleInstance?.listUndefinedGeos()?.sort{it.name}}" status="i" var="geo">
								            			<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
								            				<td> <g:checkBox name="check.${geo?.id}" value="${false}"/> </td>
								            				<td> ${geo.name} </td>
								            			</tr>
							            			</g:each>
							            		</table>
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
							            		<!-- <a class="button" title="Create Territory" href="${baseurl }/geo/create"> click here to add</a> </h4>-->
						            	</g:else>
					            	</g:form>
					            </div>
					            
							</div>
						</g:if>
						
		            </div>
				<g:if test="${source=='firstsetup'}">
						</div>
		            </div>
	            </g:if>
        </div>
    </body>
</html>
