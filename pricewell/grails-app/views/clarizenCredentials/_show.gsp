
<%@ page import="com.valent.pricewell.ClarizenCredentials" %>
<%
	def baseurl = request.siteUrl
%>		
	<div id="mainCredentialsTab">
		<style>
			h1, button, #successDialogInfo
			{
				font-family:Georgia, Times, serif; font-size:15px; font-weight: bold;
			}
		</style>
		<script>
		
			jQuery(document).ready(function()
		 	{			
				jQuery( "#dvResponseMessage" ).hide();
			 	
				jQuery( "#btnEdit" ).click(function() 
				{
					showLoadingBox();
					jQuery.ajax({type:'POST',
						 url:"${baseurl}/clarizenCredentials/edit",
						 data: {id: "${clarizenCredentialsInstance.id}", source: "${source}"},
						 success:function(data,textStatus)
						 {
								if("firstsetup" == "${source}")
								{
									jQuery("#mainCredentialsTab").html(data);
									hideLoadingBox();
								} 
						 },
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});
						 
					return false;
				});

				jQuery( "#btnCheckApisPermission" ).click(function() 
				{
					showLoadingBox();
					jQuery.ajax({type:'POST',
						 url:"${baseurl}/clarizenCredentials/checkApiPermissions",
						 success:function(data,textStatus)
						 {
							  hideLoadingBox();
							  //jQuery( "#editCredentialsFailureDialog" ).html(data['responseMessage']).dialog("open");
						      jQuery( "#dvResponseMessage" ).html(data['responseMessage']).show();
						      
						 },
						 error:function(XMLHttpRequest,textStatus,errorThrown){hideLoadingBox();}});
						 
					return false;
				});
				
			});
			
		
		</script>
		
        <div class="body">
        	<g:if test="${source == 'firstsetup'}">
        		<div class="collapsibleContainer" >
					<div class="collapsibleContainerTitle ui-widget-header" >
						<div>Clarizen Credentials</div>
					</div>
				
					<div class="collapsibleContainerContent ui-widget-content" >
            	
            </g:if>
        	
	        	<div class="dialog">
	                <table>
	                    <tbody>
	                    
	                    	<tr class="prop">
	                            <td valign="top" class="name"><b><g:message code="clarizenCredentials.instanceUri.label" default="Instance Uri : " /></b></td>
	                            
	                            <td valign="top" class="value">${clarizenCredentialsInstance?.instanceUri}</td>
	                            
	                            
	                        </tr>
	                        
	                        <tr class="prop">	
	                        
	                            <td valign="top" class="name"><b><g:message code="clarizenCredentials.username.label" default="Username : " /></b></td>
	                            
	                            <td valign="top" class="value">${clarizenCredentialsInstance?.username}</td>
	                            
	                        </tr>
	                        
	                        <!-- <tr class="prop">
	                            
	                             
	                        	<td>&nbsp;&nbsp;</td>
	                        
	                            <td valign="top" class="name"><b><g:message code="clarizenCredentials.password.label" default="Integrator Password : " /></b></td>
	                            
	                            <td valign="top" class="value"><input type="password" id="password" value="${clarizenCredentialsInstance?.password}" readonly="true" name="password" class="password required"/></td>
	                            
	                        </tr> -->
	                    	                       
	                	</tbody>
	                </table>
	            </div>
	            <div class="buttons">
	                    <span><button id="btnEdit" title="Edit Credentials">Edit</button></span>
	                    <!-- <span><button id="btnCheckApisPermission" title="Check Required Apis Permission">Check API Permissions</button></span> -->
	               		
	            </div>
	           
	            <div id="dvResponseMessage"></div>
            <g:if test="${source == 'firstsetup'}">
	        		</div>
        		</div>
            </g:if>
        </div>
    </div>
    