<%@ page import="com.valent.pricewell.ConnectwiseCredentials" %>
<%
	def baseurl = request.siteUrl
%>

		<g:set var="entityName" value="${message(code: 'connectwiseCredentials.label', default: 'Connectwise Credentials')}" />
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
				
				jQuery("#editConnectwiseCredentials").validate();
				jQuery("#editConnectwiseCredentials input:text")[0].focus();
				
				jQuery( "#btnUpdate" ).click(function() 
				{
					if(jQuery("#editConnectwiseCredentials").validate().form())
					{
						showLoadingBox();
						jQuery.post( '${baseurl}/connectwiseCredentials/checkCredentials' , 
	    				  jQuery("#editConnectwiseCredentials").serialize(),
					      function( data ) 
					      {
							  hideLoadingBox();
							  //alert(data['responseMessage']);
					      	  if(data['result'] == 'success')
					          {		               
					      			showLoadingBox();
									jQuery.post( '${baseurl}/connectwiseCredentials/update' , 
				    				  jQuery("#editConnectwiseCredentials").serialize(),
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
					jQuery.post( '${baseurl}/connectwiseCredentials/showsetup' , 
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
					jQuery.post( '${baseurl}/connectwiseCredentials/showsetup' , 
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
		
		<div id="editCredentialsFailureDialog" title="Failure">
    	</div>
    	
		<div id="successDialogInfoEdit">
			<p>All Credentials are correct. Successfully updated Connectwise credentials. <img src="${resource(dir: 'images', file: 'ok.png')}"/></p>
			<button id="btnShow" title="Show Connectwise Credentials">Show Credentials</button>
		</div>

		<div id="failureDialogInfoEdit">
			<p>Failed to update credentials.</p>
		</div>
		
		
        <div id="editCredentialsMain" class="body" >
        	<g:if test="${source == 'firstsetup'}">
        		<div class="collapsibleContainer" >
					<div class="collapsibleContainerTitle ui-widget-header" >
						<div>Edit Connectwise Credentials</div>
					</div>
				
					<div class="collapsibleContainerContent ui-widget-content" >
            </g:if>
            
	            <g:form method="post" name="editConnectwiseCredentials">
					<g:hiddenField name="source" value="${source}" />
	                <g:hiddenField name="id" value="${connectwiseCredentialsInstance?.id}" />
	                <g:hiddenField name="version" value="${connectwiseCredentialsInstance?.version}" />
	                <div class="dialog">
	                    <table>
	                        <tbody>
	                        	<tr class="prop">
	                                <td valign="top" class="name">
	                                  <label for="siteUrl"><g:message code="connectwiseCredentials.siteUrl.label" default="Site Url" /></label><em>*</em>
	                                </td>
	                                <td valign="top" class="value ${hasErrors(bean: connectwiseCredentialsInstance, field: 'siteUrl', 'errors')}">
	                                    <g:textField name="siteUrl" value="${connectwiseCredentialsInstance?.siteUrl}" class=" required"/>
	                                </td>
	                            </tr>
	                        
	                            <tr class="prop">
	                                <td valign="top" class="name">
	                                  <label for="companyId"><g:message code="connectwiseCredentials.companyId.label" default="Company Id" /></label><em>*</em>
	                                </td>
	                                <td valign="top" class="value ${hasErrors(bean: connectwiseCredentialsInstance, field: 'companyId', 'errors')}">
	                                    <g:textField name="companyId" value="${connectwiseCredentialsInstance?.companyId}" class=" required"/>
	                                </td>
	                            </tr>
	                        
	                            <tr class="prop">
	                                <td valign="top" class="name">
	                                  <label for="userId"><g:message code="connectwiseCredentials.userId.label" default="Integrator Login Id" /></label><em>*</em>
	                                </td>
	                                <td valign="top" class="value ${hasErrors(bean: connectwiseCredentialsInstance, field: 'userId', 'errors')}">
	                                    <g:textField name="userId" value="${connectwiseCredentialsInstance?.userId}" class=" required"/>
	                                </td>
	                            </tr>
	                            
	                            <tr class="prop">
	                                <td valign="top" class="name">
	                                  <label for="password"><g:message code="connectwiseCredentials.password.label" default="Integrator Password" /></label><em>*</em>
	                                </td>
	                                <td valign="top" class="value ${hasErrors(bean: connectwiseCredentialsInstance, field: 'password', 'errors')}">
	                                    <input type="password" id="password" value="${connectwiseCredentialsInstance?.password}" name="password" class="password required"/>
	                                </td>
	                            </tr>
	                        
	                        </tbody>
	                    </table>
	                    
	                    <div id="failureMessageResponse"></div>
	                </div>
	              	
	                <div class="buttons">
	                    <button id="btnUpdate" title="Update Credentials">Update</button>
	                    <button id="cancelCredentials" title="Cancel"> Cancel </button>
	                </div>
	            </g:form>
            
            <g:if test="${source == 'firstsetup'}">
        			</div>
       			</div>
            </g:if>
            
            
         </div>
    