

<%@ page import="com.valent.pricewell.DeliveryRole" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <g:set var="entityName" value="${message(code: 'deliveryRole.label', default: 'Delivery Role')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
    
    	<style>
			.msg {
				color: red;
			}
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
		</style>
		<script>
		 jQuery(function() 
		 {			
			 	if("firstsetup" == "${source}")
					{var xdialogDiv = "#deliveryRoleDialog";}
				else
					{var xdialogDiv = "#deliveryRoleSetupDialog";}
					 
			    jQuery("#deliveryRoleCreate").validate();
			    jQuery("#deliveryRoleCreate input:text")[0].focus();
				 
			    jQuery("#saveDeliveryRoleSetup").click(function()
			    {
					if(jQuery("#deliveryRoleCreate").validate().form())
					{
						showLoadingBox();
						jQuery.ajax(
						{
							type: "POST",
							url: "${baseurl}/deliveryRole/save",
							data:jQuery("#deliveryRoleCreate").serialize(),
							success: function(data)
							{
								if(data == "DeliveryRole_Available")
					      		{
					        		jQuery("#nameMsg").html('Error: This DelivryRole is already available.');
					       		}
								else if(data == "success"){
									jQuery( xdialogDiv ).dialog( "close" );
									jQuery(".resultDialog").html('Loading .....');
									jQuery(".resultDialog").dialog( "open" ); jQuery(".resultDialog").dialog( "option", "title", "Success" );
									jQuery(".resultDialog").html('Delivery role is created successfully.'); jQuery( ".resultDialog" ).dialog("open");
									//refreshGeoGroupList();
									hideUnhideNextBtn();
									
								} else{
									jQuery( xdialogDiv ).dialog( "close" );
									jQuery(".resultDialog").html('Loading .....');
									jQuery(".resultDialog").dialog( "open" ); jQuery(".resultDialog").dialog( "option", "title", "Failure" );
									jQuery(".resultDialog").html("Failed to create delivery role."); jQuery( ".resultDialog" ).dialog("open");
									//hideLoadingBox();
								}		
								hideLoadingBox();	
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){
								alert("Error while saving");
								hideLoadingBox();
							}
						});
					}
					return false;
				}); 
			  
			    jQuery("#saveDeliveryRole").click(function()
				{
					if(jQuery("#deliveryRoleCreate").validate().form())
					{
						showLoadingBox();
						jQuery.ajax({
							type: "POST",
							url: "${baseurl}/deliveryRole/save",
							data:jQuery("#deliveryRoleCreate").serialize(),
							success: function(data)
							{
								
								hideLoadingBox();
								if(data == "DeliveryRole_Available")
					      		{
					        		jQuery("#nameMsg").html('Error: This DelivryRole is already available.');
					       		}
								else if(data == "success"){
									refreshGeoGroupList("${source}");
								} else{
									jQuery('#deliveryRoleErrors').html(data);
									jQuery('#deliveryRoleErrors').show();
								}
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){
								hideLoadingBox();
								alert("Error while saving");
							}
						});
					}
					return false;
				});

			    jQuery("#cancelDeliveryRole").click(function()
				{
					showLoadingBox();
					jQuery.post( '${baseurl}/deliveryRole/listsetup' , 
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
    </head>
    <body>
        
        <div class="body">
        
        	
				
					<!--<g:if test="${flash.message}">
		            <div class="message">${flash.message}</div>
		            </g:if>
					<div id="deliveryRoleErrors" class="errors" style="display: none;">
		            </div>-->
		    <g:if test="${source=='firstsetup'}">        
	            <div class="collapsibleContainer" >
					<div class="collapsibleContainerTitle ui-widget-header" >
						<div>Add New Delivery Role</div>
					</div>
				
					<div class="collapsibleContainerContent ui-widget-content" >
			</g:if>
		            <g:form action="save" name="deliveryRoleCreate">
		            	<g:hiddenField name="source" value="${source}"/>
		                
		                <div class="dialog">
		                    <table>
		                        <tbody>
		                        
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                    <label for="name"><g:message code="deliveryRole.name.label" default="Name" /></label>
		                                	<em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: deliveryRoleInstance, field: 'name', 'errors')}">
		                                    <g:textField name="name" value="${deliveryRoleInstance?.name}" size="38" class="required"/>
		                                    <br/><div id="nameMsg" class="msg"></div>
		                                </td>
		                            </tr>
		                        
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                    <label for="description"><g:message code="deliveryRole.description.label" default="Description" /></label>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: deliveryRoleInstance, field: 'description', 'errors')}">
		                                    <g:textArea name="description" value="${deliveryRoleInstance?.description}" rows="5" cols="40" />
		                                </td>
		                            </tr>
		                        
		                        </tbody>
		                    </table>
		                </div>
		                <div class="buttons">
		                	<g:if test="${source=='firstsetup'}">
		                		<span class="button"><button id="saveDeliveryRole" title="Save Delivery Role"> Save </button></span>
		                		<span class="button"><button id="cancelDeliveryRole" title="Cancel"> Cancel </button></span>
		                	</g:if>
		                	<g:else>
		                    	<span class="button"><button title="Save Delivery Role" id="saveDeliveryRoleSetup"> Save </button></span>
	                    	</g:else>
		                </div>
		            </g:form>
		            
	            <g:if test="${source=='firstsetup'}">
						</div>
					</div>
				</g:if>
            
        </div>
    </body>
</html>
