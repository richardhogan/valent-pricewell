

<%@ page import="com.valent.pricewell.ClarizenCredentials" %>
<%
	def baseurl = request.siteUrl
%>

<div  id="mainCreateClarizenCredentialsTab">
        <g:set var="entityName" value="${message(code: 'clarizenCredentials.label', default: 'Clarizen Credentials')}" />
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
				
				jQuery("#createClarizenCredentials").validate();
				jQuery("#createClarizenCredentials input:text")[0].focus();
				
				jQuery( "#btnSave" ).click(function() 
				{
					if(jQuery("#createClarizenCredentials").validate().form())
					{
						showLoadingBox();
						jQuery.post( '${baseurl}/clarizenCredentials/checkCredentials' , 
	    				  jQuery("#createClarizenCredentials").serialize(),
					      function( data ) 
					      {
							  hideLoadingBox();
					      	  if(data['result'] == 'success')
					          {		          
						      		showLoadingBox();
									jQuery.post( '${baseurl}/clarizenCredentials/save' , 
				    				  jQuery("#createClarizenCredentials").serialize(),
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
						 url:'${baseurl}/clarizenCredentials/showsetup',
						 data: {source: '${source}'}, 
						 success:function(data,textStatus)
						 {
							 hideLoadingBox();
							 jQuery("#mainCreateClarizenCredentialsTab").html(data);
						 },
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});
					 
					
					return false;
				});	
				
			});
		
		</script>
    	<%--<div id="helpDialog" class="helpBtn" title="Clarizen Configuration">
					<g:render template="/help"/>
				</div>
    	--%><div id="credentialsFailureDialog" title="Failure">
    	</div>
    	
    	<div id="successDialogInfo">
			<span>All Credentials are correct. Successfully created clarizen credentials.</span> <img src="${resource(dir: 'images', file: 'ok.png')}"/>
			<button id="btnShow" title="Show Clarizen Credentials">Show Credentials</button>
		</div>

		<div id="failureDialogInfo">
			<p>Failed to create clarizen credentials.</p>
		</div>
        
        <div id="createform" class="body">
        	<g:if test="${source=='firstsetup'}">
				<div class="collapsibleContainer" >
					<div class="collapsibleContainerTitle ui-widget-header" >
						<div>Add Clarizen Credentials</div>
					</div>
				
					<div class="collapsibleContainerContent ui-widget-content" >
			</g:if>
            <!-- <h1><g:message code="default.create.label" args="[entityName]" /></h1><hr> -->
            
            <g:form action="save" name="createClarizenCredentials">
            	<g:hiddenField name="source" value="${source}" />
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
                    <button id="btnSave" title="Save Clarizen Credentials">Save</button>
                   
                </div>
                
            </g:form>
            
            <g:if test="${source=='firstsetup'}">
					</div>
				</div>
			</g:if>
        </div>
    
</div>

