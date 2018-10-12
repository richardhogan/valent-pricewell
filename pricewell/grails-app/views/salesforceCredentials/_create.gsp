

<%@ page import="com.valent.pricewell.SalesforceCredentials" %>
<%
	def baseurl = request.siteUrl
%>

<div  id="mainCreateSalesforceCredentialsTab">
        <g:set var="entityName" value="${message(code: 'salesforceCredentials.label', default: 'Salesforce Credentials')}" />
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
				
				jQuery("#createSalesforceCredentials").validate();
				jQuery("#createSalesforceCredentials input:text")[0].focus();
				
				jQuery( "#btnSave" ).click(function() 
				{
					if(jQuery("#createSalesforceCredentials").validate().form())
					{
						showLoadingBox();
						jQuery.post( '${baseurl}/salesforceCredentials/checkCredentials' , 
	    				  jQuery("#createSalesforceCredentials").serialize(),
					      function( data ) 
					      {
							  hideLoadingBox();
					      	  if(data['result'] == 'success')
					          {		          
						      		showLoadingBox();
									jQuery.post( '${baseurl}/salesforceCredentials/save' , 
				    				  jQuery("#createSalesforceCredentials").serialize(),
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
						 url:'${baseurl}/salesforceCredentials/showsetup',
						 data: {source: '${source}'}, 
						 success:function(data,textStatus)
						 {
							 hideLoadingBox();
							 jQuery("#mainCreateSalesforceCredentialsTab").html(data);
						 },
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});
					 
					
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
    	<div id="helpDialog" class="helpBtn" title="Salesforce Configuration">
					<g:render template="/help"/>
				</div>
    	<div id="credentialsFailureDialog" title="Failure">
    	</div>
    	
    	<div id="successDialogInfo">
			<span>All Credentials are correct. Successfully created salesforce credentials.</span> <img src="${resource(dir: 'images', file: 'ok.png')}"/>
			<button id="btnShow" title="Show Salesforce Credentials">Show Credentials</button>
		</div>

		<div id="failureDialogInfo">
			<p>Failed to create salesforce credentials.</p>
		</div>
        
        <div id="createform" class="body">
        	<g:if test="${source=='firstsetup'}">
				<div class="collapsibleContainer" >
					<div class="collapsibleContainerTitle ui-widget-header" >
						<div>Add Salesforce Credentials</div>
					</div>
				
					<div class="collapsibleContainerContent ui-widget-content" >
			</g:if>
            <!-- <h1><g:message code="default.create.label" args="[entityName]" /></h1><hr> -->
            
            <g:form action="save" name="createSalesforceCredentials">
            	<g:hiddenField name="source" value="${source}" />
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
                    <button id="btnSave" title="Save Salesforce Credentials">Save</button>
                    <span><button id="helpBtn" title="Configuration About SalesForce">Help</button></span>
                </div>
                
            </g:form>
            
            <g:if test="${source=='firstsetup'}">
					</div>
				</div>
			</g:if>
        </div>
    
</div>

