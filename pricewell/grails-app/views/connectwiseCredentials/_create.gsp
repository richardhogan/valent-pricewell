

<%@ page import="com.valent.pricewell.ConnectwiseCredentials" %>
<%
	def baseurl = request.siteUrl
%>

<div  id="mainCreateCredentialsTab">
        <g:set var="entityName" value="${message(code: 'connectwiseCredentials.label', default: 'Connectwise Credentials')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
        <style>
			h1, button, #successDialogInfo
			{
				font-family:Georgia, Times, serif; font-size:15px; font-weight: bold;
			}
		</style>
		
		<script>
		
			jQuery(document).ready(function()
		 	{
				jQuery( "#successDialogInfo" ).hide();
				jQuery( "#failureDialogInfo" ).hide();

				jQuery( "#failureMessageResponse" ).hide();
				
				jQuery( "#credentialsFailureDialog" ).dialog(
				{
					modal: true,
					autoOpen: false,
					resizable: false,
					buttons: {
						OK: function() {
							jQuery( "#credentialsFailureDialog" ).dialog( "close" );
							return false;
						}
					}
				});
				
				jQuery("#createConnectwiseCredentials").validate();
				jQuery("#createConnectwiseCredentials input:text")[0].focus();
				
				jQuery( "#btnSave" ).click(function() 
				{
					if(jQuery("#createConnectwiseCredentials").validate().form())
					{
						showLoadingBox();
						jQuery.post( '${baseurl}/connectwiseCredentials/checkCredentials' , 
	    				  jQuery("#createConnectwiseCredentials").serialize(),
					      function( data ) 
					      {
							  hideLoadingBox();
					      	  if(data['result'] == 'success')
					          {		          
						      		showLoadingBox();
									jQuery.post( '${baseurl}/connectwiseCredentials/save' , 
				    				  jQuery("#createConnectwiseCredentials").serialize(),
								      function( data ) 
								      {
										  hideLoadingBox();
								      	  if(data == 'success')
								          {		        
								          		      
								          		jQuery( "#successDialogInfo" ).show();
								          		jQuery( "#createform" ).hide();
												
												refreshNavigation();
									      }
									      else
									      {
									      		jQuery( "#failureDialogInfo" ).show();
									      }
									
								      });
						      }
						      else
						      {
						    	  //jQuery( "#credentialsFailureDialog" ).html(data['failureMessage']).dialog("open");
						    	  jQuery( "#failureMessageResponse" ).html(data['responseMessage']).show();
						      }
						
					      });
					      
						
				    }
				    
						return false;
				});
					
				jQuery( "#btnShow" ).click(function() 
				{
					showLoadingBox();
					jQuery.ajax({type:'POST',
						 url:'${baseurl}/connectwiseCredentials/showsetup',
						 data: {source: '${source}'}, 
						 success:function(data,textStatus)
						 {
							 hideLoadingBox();
							 jQuery("#mainCreateCredentialsTab").html(data);
						 },
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});
					 
					
					return false;
				});	
				  
			});
		
		</script>
    
    	<div id="credentialsFailureDialog" title="Failure">
    	</div>
    	
    	<div id="successDialogInfo">
			<span>All Credentials are correct. Successfully created Connectwise credentials.</span> <img src="${resource(dir: 'images', file: 'ok.png')}"/>
			<button id="btnShow" title="Show Connectwise Credentials">Show Credentials</button>
		</div>

		<div id="failureDialogInfo">
			<p>Failed to create connectwise credentials.</p>
		</div>
        
        <div id="createform" class="body">
        	<g:if test="${source=='firstsetup'}">
				<div class="collapsibleContainer" >
					<div class="collapsibleContainerTitle ui-widget-header" >
						<div>Add Connectwise Credentials</div>
					</div>
				
					<div class="collapsibleContainerContent ui-widget-content" >
			</g:if>
            <h1><g:message code="default.create.label" args="[entityName]" /></h1><hr>
            
            <g:form action="save" name="createConnectwiseCredentials">
            	<g:hiddenField name="source" value="${source}" />
                <div class="dialog">
                    <table>
                        <tbody>
                                
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="siteUrl"><g:message code="connectwiseCredentials.siteUrl.label" default="Site Url" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: connectwiseCredentialsInstance, field: 'siteUrl', 'errors')}">
                                    <g:textField name="siteUrl" value="${connectwiseCredentialsInstance?.siteUrl}" class="required"/>
                                </td>
                            </tr>
                                       
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="companyId"><g:message code="connectwiseCredentials.companyId.label" default="Company Id" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: connectwiseCredentialsInstance, field: 'companyId', 'errors')}">
                                    <g:textField name="companyId" value="${connectwiseCredentialsInstance?.companyId}" class="required"/>
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="userId"><g:message code="connectwiseCredentials.userId.label" default="Integrator Login Id" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: connectwiseCredentialsInstance, field: 'userId', 'errors')}">
                                    <g:textField name="userId" value="${connectwiseCredentialsInstance?.userId}" class="required"/>
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
                    <button id="btnSave" title="Save Connectwise Credentials">Save</button>
                </div>
            </g:form>
            
            <g:if test="${source=='firstsetup'}">
					</div>
				</div>
			</g:if>
        </div>
    
</div>

