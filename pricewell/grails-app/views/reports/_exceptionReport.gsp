<%@ page import="com.valent.pricewell.DeliveryRole" %>
<%@ page import="com.valent.pricewell.Service" %>
<%@ page import="com.valent.pricewell.Geo" %>
<%@ page import="org.apache.shiro.SecurityUtils"%>
<%
	def baseurl = request.siteUrl
%>
		<script>
	       jQuery(document).ready(function()
	       {
		   		
		   		jQuery( ".requestBtn" ).click(function() 
				{
					var id = this.id;
					var idArray = id.split("-");
		   			//alert("RoleId : "+idArray[1]+" ServiceId : "+idArray[2]);
		   			jQuery('#dvSelectTerritory').html("Loading, Please wait.........");
					jQuery("#dvSelectTerritory").dialog("open");
		   			jQuery.ajax(
				   	{
					   	type:'POST',
					   	data: {deliveryRoleId: idArray[1], serviceId: idArray[2]},
						url:'${baseurl}/deliveryRole/requestForUndefinedTerritories',
						success:function(data,textStatus)
						{
							jQuery('#dvSelectTerritory').html(data);
						},
						error:function(XMLHttpRequest,textStatus,errorThrown){}
					});return false;
		   			
				});

		   		jQuery( "#dvSelectTerritory" ).dialog(
			 	{
					autoOpen: false,
					height: 450,
					width: 800,
					close: function( event, ui ) {
							jQuery(this).html('');
						}
				});
		   	});
       </script>	


<div class="body">
	<div id="dvSelectTerritory" title="Select territories to send request"></div>
	<g:if test="${reportType == 'serviceException'}">
		<div class="list">       
			<table>		
				<thead>
					<tr>
						<th> Service </th>
														
						<th>Delivery Role</th>
					
						<th>Undefined Territories</th>
						<th>Request To<br />Administrator</th>							
					</tr>
				</thead>
				<tbody>
					<g:each in="${serviceList}" status="j" var="serviceInstance">
						
						<tr bgcolor="#b0c4de">
							 
							<td colspan="100%">
								<b> ${serviceInstance?.serviceName} </b>
							</td>
						</tr>
				
					
						<g:each in="${deliveryRoleList[j]}" status="i" var="deliveryRoleInstance">
							
								<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
									<td width="30%"> </td>
									
									<td width="20%">${deliveryRoleInstance?.name }</td>
								
									<td width="35%">
										<g:each in="${deliveryRoleInstance?.listUndefinedGeos() }" status="k" var="territoryInstance">
											${territoryInstance?.name }<g:if test="${k+1 < deliveryRoleInstance?.listUndefinedGeos().size()}">,</g:if>
											<!--<g:if test="${(k % 2) != 0}">
												<br />
											</g:if>-->
										</g:each>
									</td>
									
									<td><a href="#" class="hyperlink requestBtn" id="requestId-${deliveryRoleInstance.id}-${serviceInstance.id}">Send Request</a></td>																
								</tr>
								
						</g:each>
					</g:each>
				</tbody>
			</table>
		</div>
	</g:if>
	
	<g:if test="${reportType == 'productException'}">
		<div class="list">       
			<table>		
				<thead>
					<tr>
						<th> Product </th>
														
						<th>Services</th>
					
						<th>Undefined Territories</th>
						<!--  <th>Request To<br />Administrator</th>-->	
						
						<th></th>						
					</tr>
				</thead>
				<tbody>
					<g:each in="${productList}" status="j" var="productInstance">
						
						<tr bgcolor="#b0c4de">
							<td colspan="100%">
								<b> ${productInstance?.productName} </b>
							</td>
						</tr>
				
						<tr>
							<td width="30%"> </td>
							<td width="30%">
								<g:each in="${serviceList[j]}" status="i" var="serviceInstance">
									${i+1}) ${serviceInstance?.serviceName }<br />
								</g:each>
							</td>
							<td>
								<g:each in="${productInstance?.listUndefinedGeos() }" status="k" var="territoryInstance">
									${territoryInstance?.name }<g:if test="${k+1 < productInstance?.listUndefinedGeos().size()}">,</g:if>
									
								</g:each>
							</td>
							
							<td>
								<g:link action="show" controller="product" title="Show Details" class="hyperlink" id="${productInstance.id}">Define Territories</g:link>
							</td>
						</tr>
					
					</g:each>
				</tbody>
			</table>
		</div>
	</g:if>
										
</div>