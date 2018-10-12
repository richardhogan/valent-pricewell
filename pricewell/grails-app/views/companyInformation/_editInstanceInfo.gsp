
<%@ page import="com.valent.pricewell.CompanyInformation" %>
<%
	def baseurl = request.siteUrl
%>		
	<div id="mainInformationTab">
		<style>
			h1, button, #successDialogInfo
			{
				font-family:Georgia, Times, serif; font-size:15px; font-weight: bold;
			}
		</style>
		<script>
		
			jQuery(document).ready(function()
		 	{			
				jQuery("#editInstanceInformationFrm").validate();
				
				jQuery( "#btnUpdate" ).click(function() 
				{
					if(jQuery("#editInstanceInformationFrm").validate().form())
					{
						showLoadingBox();
						jQuery.ajax({type:'POST',
							 url:"${baseurl}/companyInformation/updateInstanceInfo",
							 data: jQuery("#editInstanceInformationFrm").serialize(),
							 success:function(data,textStatus)
							 {
									jQuery("#mainInformationTab").html(data);
									hideLoadingBox();
									
							 },
							 error:function(XMLHttpRequest,textStatus,errorThrown){}});
					}
						 
					return false;
				});
					
				
				  
			});
		
			function doRefreshInformation()
			{
				jQuery.ajax({type:'POST',
					 url:'${baeurl}/companyInformation/showsetup',
					 data: {source: 'firstsetup'},
					 success:function(data,textStatus){jQuery('#mainInformationTab').html(data);},
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});
				return false;
			}
		
			
		
		</script>
		
        <div class="body">
        	<div class="collapsibleContainer">
				<div class="collapsibleContainerTitle ui-widget-header">
					<div>Instance Information</div>
				</div>
			
				<div class="collapsibleContainerContent ui-widget-content">
			
					<g:form action="save" name="editInstanceInformationFrm">
            	 		<g:hiddenField name="source" value="${source}" />
            	 		<g:hiddenField name="instanceId" value="${instanceInfo?.id}" />
			        	<div class="dialog">
			                <table>
			                    <tbody>
			                    
			                    	<tr class="prop">
			                            <td valign="top" class="name"><b>Instance Name : </b></td>
			                            <td valign="top" class="value"><g:textField name="instanceName" value="${instanceInfo?.value }" class="required"/></td>
			                           
			                        </tr>
			                	</tbody>
			                </table>
			            </div>
			            
			            <div class="buttons">
			                <button id="btnUpdate" title="Update Instance Information">Update</button>
			            </div>
		            </g:form>
		        </div>
        
        	</div>
        </div>
    </div>
    