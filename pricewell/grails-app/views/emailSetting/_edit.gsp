
<%@ page import="com.valent.pricewell.EncriptAndDecript" %>
<%@ page import="com.valent.pricewell.EmailSetting" %>
<%
	def baseurl = request.siteUrl
%>
    <body>
    	
    	<script>
		
			jQuery(document).ready(function()
		 	{
			 	
			 	jQuery( "#successEditDialog" ).dialog(
			 	{
					modal: true,
					autoOpen: false,
					resizable: false,
					buttons: 
					{
						OK: function() 
						{
							jQuery( "#successEditDialog" ).dialog( "close" );
							
							refreshEmailSetting();
							return false;
						}
					}
				});
				
				jQuery( "#failureEditDialog" ).dialog(
				{
					modal: true,
					autoOpen: false,
					resizable: false,
					buttons: {
						OK: function() {
							jQuery( "#failureEditDialog" ).dialog( "close" );
							return false;
						}
					}
				});
				
				
				
				jQuery( "#updateBtn" ).click(function() 
				{
					jQuery.post( '${baseurl}/emailSetting/update' , 
    				  jQuery("#editEmailSetting").serialize(),
				      function( data ) 
				      {
				      	  if(data == 'success')
				          {		            
				          		jQuery( "#emailSettingEdit" ).dialog( "close" );   
				          		jQuery( "#successEditDialog" ).dialog("open");
					      }
					      else
					      {
					      		jQuery( "#emailSettingEdit" ).dialog( "close" );
		                  		jQuery( "#failureEditDialog" ).dialog("open");
					      }
				          
				      });
					  return false;
				});
					
				
				  
			});
		
			function refreshEmailSetting()
			{
				jQuery.ajax({type:'POST',
					 url:'${baseurl}/emailSetting/emailSettings',
					 success:function(data,textStatus){jQuery('#mainEmailSettingTab').html(data);},
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});
				return false;
			}
		
			
		
		</script>
        
        <div class="body">
            
            <div id="successEditDialog" title="Success">
				<p>Successfully updated.</p>
			</div>
	
			<div id="failureEditDialog" title="Failure">
				<p>Update failed.</p>
			</div>
			
            <g:form method="post" name="editEmailSetting">
                <g:hiddenField name="id" value="${emailSettingInstance?.id}" />
                <g:hiddenField name="version" value="${emailSettingInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="name"><g:message code="emailSetting.name.label" default="Key" />*</label>
                                </td>
                                
                                <td valign="top" class="name">
                                    <label for="value"><g:message code="emailSetting.value.label" default="Value" />*</label>
                                </td>
                                
                            </tr>
                        
                        	<tr class="prop">
                                <td valign="top" class="value ${hasErrors(bean: emailSettingInstance, field: 'name', 'errors')}">
                                    <g:textField name="key" value="${emailSettingInstance?.name}" />
                                </td>
                                
                                <td valign="top" class="value ${hasErrors(bean: emailSettingInstance, field: 'value', 'errors')}">
                                	<g:if test="${emailSettingInstance?.secret=='true'}">
										<%
											def secretValue = EncriptAndDecript.decrypt(emailSettingInstance.value);
										%>
										
										<g:passwordField name="value" value="${secretValue}" />
										
									</g:if>
									<g:else>
										<g:textField name="value" value="${emailSettingInstance.value}" />
									</g:else>
									
                                    <!--<g:textField name="value" value="${emailSettingInstance?.value}" />-->
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <button id="updateBtn">Update</button>
                </div>
            </g:form>
        </div>
    </body>

