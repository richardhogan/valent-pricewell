
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
				jQuery("#instanceInformationFrm").validate();
				
				jQuery( "#btnEdit" ).click(function() 
				{
					if(jQuery("#instanceInformationFrm").validate().form())
					{
						showLoadingBox();
						jQuery.ajax({type:'POST',
							 url:"${baseurl}/companyInformation/editInstanceInfo",
							 data: jQuery("#instanceInformationFrm").serialize(),
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
			
					<g:form action="save" name="instanceInformationFrm">
            	 		<g:hiddenField name="source" value="${source}" />
            	 		<g:hiddenField name="instanceId" value="${instanceInfo?.id}" />
			        	<div class="dialog">
			                <table>
			                    <tbody>
			                    
			                    	<tr class="prop">
			                            <td valign="top" class="name"><b>Instance Name : </b></td>
			                            <td valign="top" class="value">${instanceInfo?.value }</td>
			                           
			                        </tr>
			                	</tbody>
			                </table>
			            </div>
			            
			            <div class="buttons">
			                <button id="btnEdit" title="Edit Instance Information">Edit</button>
			            </div>
		            </g:form>
		        </div>
        
        	</div>
        </div>
    </div>
    