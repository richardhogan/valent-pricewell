<%@ page import="com.valent.pricewell.SowSupportParameter" %>
<%@ page import="com.valent.pricewell.Geo" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
    	<style>
			.msg {
				color: red;
				}
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
		</style>
        <script>    	
         
			 jQuery(function() 
			 {			
				 var xdialogDiv = "#sowSupportParameterDialog";
				 	var toolbar = 	[{ name: 'basicstyles', groups: [ 'basicstyles'], 
					 	items: [ 'Bold', 'Italic', 'Underline']}, 
						            	{ name: 'paragraph', groups: [ 'list', 'indent', 'align'], 
			            	items: [ 'BulletedList', '-', 'Outdent', 'Indent', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock'] },
						            	{ name: 'styles', items: [ 'Styles', 'Format'] }
						            ];
		            
				 	var name = 'project_parameter_text'
					var editor = CKEDITOR.instances[name];
					
				    if (editor) { 
					    editor.destroy(true); 
				    }
					
				    CKEDITOR.replace(name, 
					{
				    	height: '70%',
				    	width: '900px',
				    	indentOffset: 30,
				    	toolbar: toolbar
				    });
					    	
					jQuery("#savesowSupportParameterSetup").click(function()
					{ 	
										
						if(loadValues() && jQuery("#sowSupportParameterUpdate").validate().form())
						{ 
							jQuery( "#createSowSupportParameterSetup" ).show();
							showLoadingBox();						
							jQuery.ajax(
							{
								type: "POST",
								url: "${baseurl}/sowSupportParameter/update",
								data:jQuery("#sowSupportParameterUpdate").serialize(),
								success: function(data)
								{
									hideLoadingBox();
									if(data == "SowSupportParameter_Available")
						      		{
						        		jQuery("#nameMsg").html('Error: This SowSupportParameter is already available.');
						       		}
									else if(data == "success")
									{								    		         
										jQuery( xdialogDiv ).dialog( "close" );
										jQuery("#resultDialog").show();
										jQuery("#resultDialog").html('SOW SupportParameter is edited successfully.');
										jQuery("#sowSupportParameterDialog").hide();
									}
									else{
										jQuery( xdialogDiv ).dialog( "close" );
										jQuery("#resultDialog").html('Failed to edit SOW SupportParameter.'); 
									}
									
								}, 
								error:function(XMLHttpRequest,textStatus,errorThrown){
									hideLoadingBox();
									alert("Error while saving");
									//hideLoadingBox();
								}
							});
						}
						return false;
					}); 	
									
					jQuery("#savesowSupportParameter").click(function()
					{
						
						if(loadValues() && jQuery("#sowSupportParameterUpdate").validate().form())
						{
							jQuery( "#createSowSupportParameterSetup" ).show();
							showLoadingBox();
							
							jQuery.ajax({
								type: "POST",
								url: "${baseurl}/sowSupportParameter/update",
								data:jQuery("#sowSupportParameterUpdate").serialize(),
								success: function(data)
								{
									alert(data);
									hideLoadingBox();
									if(data == "SowSupportParameter_Available")
						      		{
						        		jQuery("#nameMsg").html('Error: This SOW SupportParameter is already available.');
						       		}
									else if(data == "success"){
										jQuery( xdialogDiv ).dialog( "close" );
										jQuery("#resultDialog").html('SOW SupportParameter is edited successfully.');
									} else{
										jQuery('#sowSupportParameterErrors').html(data);
										jQuery('#sowSupportParameterErrors').show();
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
					
					jQuery("#cancelsowSupportParameter").click(function()
					{					
						jQuery( "#createSowSupportParameterSetup" ).show();	
						jQuery( xdialogDiv ).dialog( "close" );
						jQuery("#sowSupportParameterDialog").hide();
						return false;
					});					  
			 });
			 
			 function loadValues()
			 {
				var name = 'project_parameter_text'
	 			jQuery('#project_parameter_text').val(CKEDITOR.instances[name].getData());

	 			if(isEditorContentSupported(jQuery('#'+name).val()) == "fail")
    			{
    				return false;
    			}
    			return true;
	 		 } 
  		</script>
    </head>
    <body>
        
        <div class="body">
        
			<g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
			<div id="sowSupportParameterErrors" class="errors" style="display: none;">
            </div>
            
            <g:if test="${source=='firstsetup'}">
	            <div class="collapsibleContainer" >
					<div class="collapsibleContainerTitle ui-widget-header" >
						<div>Edit Sow SupportParameter</div>
					</div>
				</div></g:if>
					<div class="collapsibleContainerContent ui-widget-content" >
			
						
		            <g:form method="post" name="sowSupportParameterUpdate">
		                <g:hiddenField name="source" value="${source}"/>
		                <g:hiddenField name="type" value="${sowSupportParameterInstance?.type}" />
						<g:hiddenField name="id" value="${sowSupportParameterInstance?.id}" />
		                <g:hiddenField name="version" value="${sowSupportParameterInstance?.version}" />
		                <div class="dialog">
		                    <table>
		                        <tbody>
		                        
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                  <label for="name"><g:message code="sowSupportParameter.name.label" default="Name" /></label>
		                                	<em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: sowSupportParameterInstance, field: 'name', 'errors')}">
		                                	${sowSupportParameterInstance?.name}
		                                    <g:hiddenField name="name" value="${sowSupportParameterInstance?.name}" />
		                                    <g:hiddenField name="territoryId" value="${sowSupportParameterInstance?.geo?.id}" />
		                                    <br/><div id="nameMsg" class="msg"></div>
		                                </td>
		                            </tr>
		                        	<!--  
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                    <label for="selectTerritory"><g:message code="SowSupportParameter.label" default="Territory" /></label>
		                                </td>
		                                <td>			                                					
											<g:select name="territoryId" from="${Geo.list()}" value="${sowSupportParameterInstance?.geo?.id}" optionKey="id"  noSelection="['':'Select Any One']"/>
		                                </td>
		                            </tr>
		                            -->
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                  <label for="project_parameter_text"><g:message code="sowSupportParameter.project_parameter_text.label" default="Project Parameter Text" /></label>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: sowSupportParameterInstance, field: 'project_parameter_text', 'errors')}">
		                                    <g:textArea name="project_parameter_text" value="${sowSupportParameterInstance?.project_parameter_text}" rows="5" cols="40" />
		                                </td>
		                            </tr>		                         	
		                        </tbody>
		                    </table>
		                </div>
		                <div class="buttons">
		                	<g:if test="${source == 'firstsetup'}">
	                    		<span class="button"><button id="savesowSupportParameter" title="Update Sow SupportParameter" > Update </button></span>
	                    		<span class="button"><button id="cancelsowSupportParameter" title="Cancel"> Cancel </button></span>
	                    	</g:if>
	                    	<g:else>
		                    	<span class="button"><button title="Update Sow SupportParameter" id="savesowSupportParameterSetup"> Update </button></span>
		                    	<span class="button"><button id="cancelsowSupportParameter" title="Cancel"> Cancel </button></span>
	                    	</g:else>
		                </div>
		            </g:form></div>
				<g:if test="${source=='firstsetup'}">

				</g:if>
        </div>
        
    </body>
</html>