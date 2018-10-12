<%@ page import="com.valent.pricewell.ClarizenCredentials" %>
<%
	def baseurl = request.siteUrl
%>

		<g:set var="entityName" value="${message(code: 'clarizenCredentials.label', default: 'Clarizen Credentials')}" />
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
				
				jQuery("#editClarizenCredentials").validate();
				jQuery("#editClarizenCredentials input:text")[0].focus();
				
				jQuery( "#btnUpdate" ).click(function() 
				{
					if(jQuery("#editClarizenCredentials").validate().form())
					{
						showLoadingBox();
						jQuery.post( '${baseurl}/clarizenCredentials/checkCredentials' , 
	    				  jQuery("#editClarizenCredentials").serialize(),
					      function( data ) 
					      {
							  hideLoadingBox();
							  //alert(data['responseMessage']);
					      	  if(data['result'] == 'success')
					          {		               
					      			showLoadingBox();
									jQuery.post( '${baseurl}/clarizenCredentials/update' , 
				    				  jQuery("#editClarizenCredentials").serialize(),
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
					jQuery.post( '${baseurl}/clarizenCredentials/showsetup' , 
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
					jQuery.post( '${baseurl}/clarizenCredentials/showsetup' , 
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
			<p>All Credentials are correct. Successfully updated Clarizen credentials. <img src="${resource(dir: 'images', file: 'ok.png')}"/></p>
			<button id="btnShow" title="Show Clarizen Credentials">Show Credentials</button>
		</div>

		<div id="failureDialogInfoEdit">
			<p>Failed to update credentials.</p>
		</div>
		
		
        <div id="editCredentialsMain" class="body" >
        	<g:if test="${source == 'firstsetup'}">
        		<div class="collapsibleContainer" >
					<div class="collapsibleContainerTitle ui-widget-header" >
						<div>Edit Clarizen Credentials</div>
					</div>
				
					<div class="collapsibleContainerContent ui-widget-content" >
            </g:if>
            
	            <g:form method="post" name="editClarizenCredentials">
					<g:hiddenField name="source" value="${source}" />
	                <g:hiddenField name="id" value="${clarizenCredentialsInstance?.id}" />
	                <g:hiddenField name="version" value="${clarizenCredentialsInstance?.version}" />
	                <div class="dialog">
	                    <table>
	                        <tbody>
	                        
		                        <tr class="prop">
	                                <td valign="top" class="name">
	                                    <label for="siteUrl"><g:message code="clarizenCredentials.instanceUri.label" default="Instance Uri" /></label><em>*</em>
	                                </td>
	                                <td valign="top" class="value ${hasErrors(bean: clarizenCredentialsInstance, field: 'instanceUri', 'errors')}">
	                                    <g:textField name="instanceUri" value="${clarizenCredentialsInstance?.instanceUri}" class="required"/>
	                                </td>
	                            </tr>
	                                       
	                            <tr class="prop">
	                                <td valign="top" class="name">
	                                    <label for="username"><g:message code="clarizenCredentials.username.label" default="Username" /></label><em>*</em>
	                                </td>
	                                <td valign="top" class="value ${hasErrors(bean: clarizenCredentialsInstance, field: 'username', 'errors')}">
	                                    <g:textField name="username" value="${clarizenCredentialsInstance?.username}" class="required"/>
	                                </td>
	                            </tr>
	                            
	                            <tr class="prop">
	                                <td valign="top" class="name">
	                                    <label for="password"><g:message code="clarizenCredentials.password.label" default="Password" /></label><em>*</em>
	                                </td>
	                                <td valign="top" class="value ${hasErrors(bean: clarizenCredentialsInstance, field: 'password', 'errors')}">
	                                    <input type="password" id="password" value="${clarizenCredentialsInstance?.password}" name="password" class="password required"/>
	                                </td>
	                            </tr>
	                        
	                        	<%--<tr class="prop">
	                                <td valign="top" class="name">
	                                    <label for="securityToken"><g:message code="clarizenCredentials.securityToken.label" default="Security Token" /></label><em>*</em>
	                                </td>
	                                <td valign="top" class="value ${hasErrors(bean: clarizenCredentialsInstance, field: 'securityToken', 'errors')}">
	                                    <g:textField name="securityToken" value="${clarizenCredentialsInstance?.securityToken}" class="required"/>
	                                </td>
	                            </tr>
	                            
	                        --%>
	                        </tbody>
	                    </table>
	                    
	                    <div id="failureMessageResponse"></div>
	                </div>
	              	
	                <div class="buttons">
	                    <button id="btnUpdate" title="Update Credentials">Update</button>
	                    <button id="cancelCredentials" title="Cancel"> Cancel </button><%--
	                    <span><button id="helpBtn" class="helpBtn" title="Configuration About Clarizen">Help</button></span>
	                --%>
	                </div>
	              
	            </g:form>
            
            <g:if test="${source == 'firstsetup'}">
        			</div>
       			</div>
            </g:if>
            
            
         </div>
    