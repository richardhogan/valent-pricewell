
  <%
	def baseurl = request.siteUrl
%>      
        <style>
			 .w-fixed {
			 	  display: inline-block;
					width: 15em;
			}
		</style>
		
		<script>
		
			jQuery(document).ready(function()
		 	{
			 
				
				jQuery( "#successDialogEmail" ).dialog(
			 	{
					modal: true,
					autoOpen: false,
					resizable: false,
					buttons: 
					{
						OK: function() 
						{
							jQuery( "#successDialogEmail" ).dialog( "close" );
							//window.location.href = '/pricewell/emailSetting/emailSettings';
							
							doRefresh();
							return false;
						}
					}
				});
				
				jQuery( "#emailSettingEdit" ).dialog(
			 	{
					modal: true,
					autoOpen: false,
					resizable:false,
                    width:350,
              		height:200 
				});
				
				jQuery( "#failureDialogEmail" ).dialog(
				{
					modal: true,
					autoOpen: false,
					resizable: false,
					buttons: {
						OK: function() {
							jQuery( "#failureDialogEmail" ).dialog( "close" );
							return false;
						}
					}
				});
						
				jQuery( "#newEmailSetting" ).dialog(
				{
					autoOpen: false,
					height: 220,
					width: 400,
					resizable:false,
					modal: true,
					buttons: 
					{
						"Create": function() 
						{
							var name = jQuery( "#key" ).val(),	value = jQuery( "#value" ).val();
							
							if(name.length == 0)
							{
								alert("Key required field..");
							}
							else if(value.length == 0)
							{
								alert("Value required field..");
							}
							
							else
	                		{
	                			jQuery.post( '${baseurl}/emailSetting/save' , 
	                				  jQuery("#createEmailSetting").serialize(),
								      function( data ) 
								      {
								          if(data == 'success')
								          {		               
								          		jQuery( "#newEmailSetting" ).dialog( "close" );    		                   		
						                   		jQuery( "#successDialogEmail" ).dialog("open");
									      }
									      else
									      {
						                  		jQuery( "#failureDialogEmail" ).dialog("open");
									      }
								          
								      });
	                		}
							
							return false;
						},
						Cancel: function() 
						{
							jQuery( "#newEmailSetting" ).dialog( "close" );
						}
					}
				});
		
				jQuery( "#btnSet" ).click(function() {
						jQuery( "#newEmailSetting" ).dialog( "open" );
						return false;
					});
					
				
			    
				  
			});
			
			function handleChange(cb) 
			{
				var val = document.getElementById('value').value;
				if(cb.checked == true)
				{
					document.getElementById('keyValue').innerHTML  = '<g:passwordField name="value" value="'+val+'" />';
				}
				else
				{
					document.getElementById('keyValue').innerHTML  = '<g:textField name="value" value="'+val+'" />';
				}
			    //alert("Changed, new value = " + cb.checked);
			}

			function doRefresh()
			{
				jQuery.ajax({type:'POST',
					 url:'${baseurl}/emailSetting/emailSettings',
					 success:function(data,textStatus){jQuery('#mainEmailSettingTab').html(data);},
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});
				return false;
			}
		
			function changeUrl()
			{
				window.location.href = '${baseurl}/emailSetting/emailSettings';
				return false;
			}
		
		</script>

    
    <body>
    	<div id="successDialogEmail" title="Success">
			<p>Setting is successfully created.</p>
		</div>

		<div id="failureDialogEmail" title="Failure">
			<p>Setting creation failed.</p>
		</div>
		
		<div id="emailSettingEdit" title="Edit Email Setting"></div>
		
		<div id="newEmailSetting" title="Create New Email Setting">
		
			<g:form name="createEmailSetting" id="createEmailSetting" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="name">Key*</label>
                                </td>
                                <td valign="top" class="name">
                                    <label for="name">Value*</label>
                                </td>
                                
                            </tr>
                            
                            <tr class="prop">
                                <td valign="top">
                                    <g:textField name="key" value="" />
                                </td>
                                <td>
                                	<div id="keyValue">
                                    	<g:textField name="value" value="" />
                                	</div>
                                </td>
                            </tr>
                            <tr class="prop">
                            	<td><g:checkBox name="secret" value="${false}" onchange="handleChange(this);"/>&nbsp;&nbsp; Keep Secret</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </g:form>
		</div>
		
			<div class="collapsibleContainer">
				<div class="collapsibleContainerTitle ui-widget-header">
					<div>Email Settings</div>
				</div>
			
				<div class="collapsibleContainerContent">
				
					<g:form method="post" action="saveSettings">
                    
			             <div id="childList" class="childList">
				             <table>
								<div <g:if test="${!emailSettings || emailSettings?.size() == 0}">style="display:none;"</g:if>>
									<tr>
										<td> <b>KEY</b> </td>
										<td>&nbsp;&nbsp;</td>
										<td> <b>VALUE</b> </td>
									</tr>
									
								</div>
							    <g:each var="emailSettingInstance" in="${emailSettings}" status="i">
							        <tr>
							        	<g:render template='/emailSetting/emailSetting' model="['emailSettingInstance':emailSettingInstance,'i':i,'hidden':false]"/>
							        </tr>
							    </g:each>
							</table>   
						</div>
						       
				    	 <div class="buttons">
				    		<!--<span class="button"><g:actionSubmit class="save" action="saveSettings" value="Save Settings" /></span>-->
				    		<button id="btnSet">Add New</button>
				    	</div>
				    </g:form>
				
				</div>
				
			</div>
	     
	    	
	    	
    </body>
