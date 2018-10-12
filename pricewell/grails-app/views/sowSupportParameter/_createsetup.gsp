<%@ page import="com.valent.pricewell.SowSupportParameter" %>
<%@ page import="com.valent.pricewell.Geo" %>
<g:set var="entityName" value="${message(code: 'sowSupportParameter.label', default: 'Sow SupportParameter')}" />
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <g:set var="entityName" value="${message(code: 'sowSupportParameter.label', default: 'Sow SupportParameter')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
    
    	<style>
			.msg {
				color: red;
			}
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
		</style>
		<script>
		
		jQuery('#TerritoryId').change(function() 
		{
			
			var sowSupportParameterId = jQuery( "#TerritoryId" ).val();
			jQuery.ajax({type:'POST',data: {source: 'firstsetup'},
					url:'${baseurl}/sowSupportParameter/getTerritory',
					success:function(data,textStatus)
					{   					
						return true;
   					},
					error:function(XMLHttpRequest,textStatus,errorThrown){}});
		 			return false;
			  
		});
		
		
		 jQuery(function() 
		 {			
			 	if("firstsetup" == "${source}")
					{var xdialogDiv = "#sowSupportParameterDialog";}
				else
					{var xdialogDiv = "#sowSupportParameterSetupDialog";}
			 	var toolbar = 	[{ name: 'basicstyles', groups: [ 'basicstyles'], items: [ 'Bold', 'Italic', 'Underline']}, 
					             { name: 'paragraph', groups: [ 'list', 'indent', 'align'], items: [ 'BulletedList', '-', 'Outdent', 'Indent', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock'] },
					             { name: 'styles', items: [ 'Styles', 'Format'] }];
	            
				var name = 'project_parameter_text'
				var editor = CKEDITOR.instances[name];
			    if (editor) { editor.destroy(true); }
			    
			    CKEDITOR.replace(name, 
				{
			    	height: '70%',
			    	width: '925px',
			    	indentOffset: 30,
			    	toolbar: toolbar
			    });
			    jQuery("#sowSupportParameterCreate").validate();
			    jQuery("#sowSupportParameterCreate input:text")[0].focus();
				 
			    jQuery("#savesowSupportParameterSetup").click(function()
			    {
					if(loadValues() && jQuery("#sowSupportParameterCreate").validate().form())
					{
						
						showLoadingBox();
						jQuery.ajax(
						{
							type: "POST",
							url: "${baseurl}/sowSupportParameter/save",
							data:jQuery("#sowSupportParameterCreate").serialize(),
							success: function(data)
							{
								hideLoadingBox();	
								if(data == "SowSupportParameter_Available")
					      		{
					        		jQuery("#nameMsg").html('Error: This Project Parameter is already available.');
					       		}
								else if(data == "success"){
									jQuery( xdialogDiv ).dialog( "close" );
									alert("Project Parameter is created successfully");
									
									refreshNavigation();
									
									jQuery( "#createSowSupportParameterSetup" ).show();
									jQuery("#sowSupportParameterDialog").hide();
									jQuery('#definedTerritoryId').val(jQuery('#definedTerritoryId').val());
									jQuery('#definedTerritoryId').trigger('change');
								} else{
									jQuery( xdialogDiv ).dialog( "close" );
									jQuery("#resultDialog").html('Loading .....');
									jQuery("#resultDialog").dialog( "open" ); jQuery(".resultDialog").dialog( "option", "title", "Failure" );
									jQuery("#resultDialog").html("Failed to create Project Parameter."); jQuery( ".resultDialog" ).dialog("open");
								}		
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){
								alert("Error while saving ");
								hideLoadingBox();
							}
						});
					}
					return false;
				}); 
			  
			    jQuery("#savesowSupportParameter").click(function()
				{
					
					if(loadValues() && jQuery("#sowSupportParameterCreate").validate().form())
					{
						jQuery( "#createSowSupportParameterSetup" ).show();
						showLoadingBox();
						
						jQuery.ajax({
							type: "POST",
							url: "${baseurl}/sowSupportParameter/save",
							data:jQuery("#sowSupportParameterCreate").serialize(),
							success: function(data)
							{
								alert(data);
								hideLoadingBox();
								if(data == "sowSupportParameter_Available")
					      		{
					        		jQuery("#nameMsg").html('Error: This Project Parameter is already available.');
					       		}
								else if(data == "success"){
									refreshGeoGroupList("${source}");
								} else{
									jQuery('#sowSupportParameterErrors').html(data);
									jQuery('#sowSupportParameterErrors').show();
								}
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){
								alert(textStatus);
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
		 	
			function loadValues(){
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
        
        	
				
					<!--<g:if test="${flash.message}">
		            <div class="message">${flash.message}</div>
		            </g:if>
					<div id="sowSupportParameterErrors" class="errors" style="display: none;">
		            </div>-->
		    <g:if test="${source=='firstsetup'}">
	            <div class="collapsibleContainer" >
					<div class="collapsibleContainerTitle ui-widget-header" >
						<div>Add New Project Parameter</div>
					</div>
				
					<div class="collapsibleContainerContent ui-widget-content" >
			</g:if>
		            <g:form action="save" name="sowSupportParameterCreate">
		            	<g:hiddenField name="source" value="${source}"/>
		                
		                <div class="dialog">
		                    <table>
		                        <tbody>		                        
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                    <label for="name"><g:message code="sowSupportParameter.name.label" default="Name"  /></label>
		                                	<em>*</em>
		                                </td>
		                                <td>
		                                <g:textField name="name" value="${sowSupportParameterInstance?.name}" class="required" size="35px" maxlength="25" />
		                                <g:hiddenField name="territoryId" value="${params.geoId}" />
		                                <g:hiddenField name="type" value="${params.type}" />
		                                    <br/><div id="nameMsg" class="msg"></div>
		                                    </td>
		                           	 </tr>
		                           	 
		                            <tr class="prop">
		                                <td valign="top" class="name" >
		                                    <label for="project_parameter_text"><g:message code="sowSupportParameter.project_parameter_text.label" default="Project Parameter Text" /></label>
		                                </td>
		                                
		                                <td valign="top" class="value ${hasErrors(bean: sowSupportParameterInstance, field: 'project_parameter_text', 'errors')}">
		                                    <g:textArea name="project_parameter_text" value="${sowSupportParameterInstance?.project_parameter_text}" rows="5" cols="0" />
		                                </td>
		                            </tr>
		                        
		                        </tbody>
		                    </table>
		                </div>
		                <div class="buttons">
		                	<g:if test="${source=='firstsetup'}">
		                		<span class="button"><button id="savesowSupportParameter" title="Save Sow SupportParameter"> Save </button></span>
		                		<span class="button"><button id="cancelsowSupportParameter" title="Cancel"> Cancel </button></span>
		                	</g:if>
		                	<g:else>
		                    	<span class="button"><button title="Save Sow SupportParameter" id="savesowSupportParameterSetup"> Save </button></span>
		                    	<span class="button"><button id="cancelsowSupportParameter" title="Cancel"> Cancel </button></span>
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