
<%@ page import="com.valent.pricewell.ConnectwiseCredentials" %>
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
						 url:"${baseurl}/connectwiseCredentials/edit",
						 data: {id: "${connectwiseCredentialsInstance.id}", source: "${source}"},
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
						 url:"${baseurl}/connectwiseCredentials/checkApiPermissions",
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
						<div>Connectwise Credentials</div>
					</div>
				
					<div class="collapsibleContainerContent ui-widget-content" >
            	
            </g:if>
        	
	        	<div class="dialog">
	                <table>
	                    <tbody>
	                    
	                    	<tr class="prop">
	                            <td valign="top" class="name"><b><g:message code="connectwiseCredentials.siteUrl.label" default="Site Url : " /></b></td>
	                            
	                            <td valign="top" class="value">${connectwiseCredentialsInstance?.siteUrl}</td>
	                            
	                            
	                        </tr>
	                        
	                        <tr class="prop">	
	                        
	                            <td valign="top" class="name"><b><g:message code="connectwiseCredentials.companyId.label" default="Company Id : " /></b></td>
	                            
	                            <td valign="top" class="value">${connectwiseCredentialsInstance?.companyId}</td>
	                            
	                        </tr>
	                        
	                        <tr class="prop">
	                            <td valign="top" class="name"><b><g:message code="connectwiseCredentials.userId.label" default="Integrator Login Id : " /></b></td>
	                            
	                            <td valign="top" class="value">${connectwiseCredentialsInstance?.userId}</td>
	                            <!-- 
	                        	<td>&nbsp;&nbsp;</td>
	                        
	                            <td valign="top" class="name"><b><g:message code="connectwiseCredentials.password.label" default="Integrator Password : " /></b></td>
	                            
	                            <td valign="top" class="value"><input type="password" id="password" value="${connectwiseCredentialsInstance?.password}" readonly="true" name="password" class="password required"/></td>
	                            -->
	                        </tr>
	                    	                       
	                	</tbody>
	                </table>
	            </div>
	            <div class="buttons">
	                
	                    <span><button id="btnEdit" title="Edit Credentials">Edit</button></span>
	                    <span><button id="btnCheckApisPermission" title="Check Required Apis Permission">Check API Permissions</button></span>
	               
	            </div>
	            
	            <div id="dvResponseMessage"></div>
            <g:if test="${source == 'firstsetup'}">
	        		</div>
        		</div>
            </g:if>
        </div>
    </div>
    