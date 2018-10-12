<%@ page import="com.valent.pricewell.SalesforceCredentials" %>
<%
	def baseurl = request.siteUrl
%>

		<g:set var="entityName" value="${message(code: 'salesforceCredentials.label', default: 'Salesforce Credentials')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
        <style>
			h1, button, #successDialogInfoEdit, #failureDialogInfoEdit
			{
				font-family:Georgia, Times, serif; font-size:15px; font-weight: bold;
			}
		</style>
        <script>
		
			jQuery(document).ready(function()
		 	{
			 	var index = 5000;
			 	jQuery( "#failureMessageResponse" ).hide();

			 	jQuery( "#successDialogInfoEdit" ).hide();
			 	
				jQuery( "#failureDialogInfoEdit" ).hide();
				
				jQuery( "#editCredentialsMain" ).show();

				jQuery( "#editCredentialsFailureDialog" ).dialog(
				{
					modal: true,
					autoOpen: false,
					resizable: false,
					buttons: {
						OK: function() {
							jQuery( "#editCredentialsFailureDialog" ).dialog( "close" );
							return false;
						}
					}
				});
				
				jQuery("#editSalesforceCredentials").validate();
				jQuery("#editSalesforceCredentials input:text")[0].focus();
				
				jQuery( "#btnUpdate" ).click(function() 
				{
					if(jQuery("#editSalesforceCredentials").validate().form())
					{
						showLoadingBox();
						jQuery.post( '${baseurl}/salesforceCredentials/checkCredentials' , 
	    				  jQuery("#editSalesforceCredentials").serialize(),
					      function( data ) 
					      {
							  hideLoadingBox();
							  //alert(data['responseMessage']);
					      	  if(data['result'] == 'success')
					          {		               
					      			showLoadingBox();
									jQuery.post( '${baseurl}/salesforceCredentials/update' , 
				    				  jQuery("#editSalesforceCredentials").serialize(),
								      function( data ) 
								      {
										  hideLoadingBox();
								      	  if(data == 'success')
								          {		               
									      		jQuery( "#successDialogInfoEdit" ).dialog( "option", "zIndex", index+1000 );
									    		index = index+1000;
								          		jQuery( "#successDialogInfoEdit" ).show();
												jQuery( "#failureDialogInfoEdit" ).hide();
												jQuery( "#editCredentialsMain" ).hide();
									      }
									      else
									      {
									    	  	jQuery( "#failureDialogInfoEdit" ).dialog( "option", "zIndex", index+1000 );
									  			index = index+1000;
						                  		jQuery( "#failureDialogInfoEdit" ).show();
												jQuery( "#editCredentialsMain" ).hide();
									      }
								          
								      });
						      }
						      else
						      {
						    	  //jQuery( "#editCredentialsFailureDialog" ).html(data['responseMessage']).dialog("open");
						    	  jQuery( "#failureMessageResponse" ).html(data['responseMessage']).show();
						      }
					          
					      });
					  }
					  return false;
				});
					
				jQuery( "#btnShow" ).click(function() 
				{
					showLoadingBox();
					jQuery.post( '${baseurl}/salesforceCredentials/showsetup' , 
						{source: "${source}"},
    				  function( data ) 
				      {
							hideLoadingBox();
						  	if("firstsetup" == "${source}")
						  	{
						  		jQuery("#mainCredentialsTab").html(data);
						  	}
						  					      
				      });
						return false;
				});

				jQuery("#cancelCredentials").click(function()
				{
					showLoadingBox();
					jQuery.post( '${baseurl}/salesforceCredentials/showsetup' , 
					  	{source: "firstsetup"},
				      	function( data ) 
				      	{
						  	hideLoadingBox();
				          	jQuery('#contents').html('').html(data);
				      	});
					return false;
				});	
				jQuery("#helpBtn").click(function() 
				{
					jQuery("#helpDialog").dialog("open");
					return false;
				});
				jQuery( "#helpDialog" ).dialog(
				{
					modal: true,
					autoOpen: false,
					height: 500,
					width: 1000
				});
			});
			
		
		</script>
		
		<div id="editCredentialsFailureDialog" title="Failure">
    	</div>
    	
		<div id="successDialogInfoEdit">
			<p>All Credentials are correct. Successfully updated Salesforce credentials. <img src="${resource(dir: 'images', file: 'ok.png')}"/></p>
			<button id="btnShow" title="Show Salesforce Credentials">Show Credentials</button>
		</div>

		<div id="failureDialogInfoEdit">
			<p>Failed to update credentials.</p>
		</div>
		
		
        <div id="editCredentialsMain" class="body" >
        	<g:if test="${source == 'firstsetup'}">
        		<div class="collapsibleContainer" >
					<div class="collapsibleContainerTitle ui-widget-header" >
						<div>Edit Salesforce Credentials</div>
					</div>
				
					<div class="collapsibleContainerContent ui-widget-content" >
            </g:if>
            
	            <g:form method="post" name="editSalesforceCredentials">
					<g:hiddenField name="source" value="${source}" />
	                <g:hiddenField name="id" value="${salesforceCredentialsInstance?.id}" />
	                <g:hiddenField name="version" value="${salesforceCredentialsInstance?.version}" />
	                <div class="dialog">
	                    <table>
	                        <tbody>
	                        
		                        <tr class="prop">
	                                <td valign="top" class="name">
	                                    <label for="siteUrl"><g:message code="salesforceCredentials.instanceUri.label" default="Instance Uri" /></label><em>*</em>
	                                </td>
	                                <td valign="top" class="value ${hasErrors(bean: salesforceCredentialsInstance, field: 'instanceUri', 'errors')}">
	                                    <g:textField name="instanceUri" value="${salesforceCredentialsInstance?.instanceUri}" class="required"/>
	                                </td>
	                            </tr>
	                                       
	                            <tr class="prop">
	                                <td valign="top" class="name">
	                                    <label for="username"><g:message code="salesforceCredentials.username.label" default="Username" /></label><em>*</em>
	                                </td>
	                                <td valign="top" class="value ${hasErrors(bean: salesforceCredentialsInstance, field: 'username', 'errors')}">
	                                    <g:textField name="username" value="${salesforceCredentialsInstance?.username}" class="required"/>
	                                </td>
	                            </tr>
	                            
	                            <tr class="prop">
	                                <td valign="top" class="name">
	                                    <label for="password"><g:message code="salesforceCredentials.password.label" default="Password" /></label><em>*</em>
	                                </td>
	                                <td valign="top" class="value ${hasErrors(bean: salesforceCredentialsInstance, field: 'password', 'errors')}">
	                                    <input type="password" id="password" value="${salesforceCredentialsInstance?.password}" name="password" class="password required"/>
	                                </td>
	                            </tr>
	                        
	                        	<tr class="prop">
	                                <td valign="top" class="name">
	                                    <label for="securityToken"><g:message code="salesforceCredentials.securityToken.label" default="Security Token" /></label><em>*</em>
	                                </td>
	                                <td valign="top" class="value ${hasErrors(bean: salesforceCredentialsInstance, field: 'securityToken', 'errors')}">
	                                    <g:textField name="securityToken" value="${salesforceCredentialsInstance?.securityToken}" class="required"/>
	                                </td>
	                            </tr>
	                            
	                        </tbody>
	                    </table>
	                    
	                    <div id="failureMessageResponse"></div>
	                </div>
	              	
	                <div class="buttons">
	                    <button id="btnUpdate" title="Update Credentials">Update</button>
	                    <button id="cancelCredentials" title="Cancel"> Cancel </button>
	                    <span><button id="helpBtn" class="helpBtn" title="Configuration About SalesForce">Help</button></span>
	                </div>
	                <div id="helpDialog" title="Salesforce Configuration">
						<g:render template="help"/>
					</div>
	            </g:form>
            
            <g:if test="${source == 'firstsetup'}">
        			</div>
       			</div>
            </g:if>
            
            
         </div>
    