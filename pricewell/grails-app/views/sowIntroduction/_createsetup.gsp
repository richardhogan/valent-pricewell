<%@ page import="com.valent.pricewell.SowIntroduction" %>
<%@ page import="com.valent.pricewell.Geo" %>
<g:set var="entityName" value="${message(code: 'sowIntroduction.label', default: 'Sow Introduction')}" />
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <g:set var="entityName" value="${message(code: 'sowIntroduction.label', default: 'Sow Introduction')}" />
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
			
			var sowIntroductionId = jQuery( "#TerritoryId" ).val();

			jQuery.ajax({type:'POST',data: {source: 'firstsetup'},
					url:'${baseurl}/sowIntroduction/getTerritory',
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
					{var xdialogDiv = "#sowIntroductionDialog";}
				else
					{var xdialogDiv = "#sowIntroductionSetupDialog";}

			 	var toolbar = 	[{ name: 'basicstyles', groups: [ 'basicstyles'], items: [ 'Bold', 'Italic', 'Underline']}, 
					             { name: 'paragraph', groups: [ 'list', 'indent', 'align'], items: [ 'BulletedList', '-', 'Outdent', 'Indent', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock'] },
					             { name: 'styles', items: [ 'Styles', 'Format'] }];
	            
				var name = 'sow_text'
				var editor = CKEDITOR.instances[name];
			    if (editor) { editor.destroy(true); }
			    
			    CKEDITOR.replace(name, 
				{
			    	height: '70%',
			    	width: '925px',
			    	indentOffset: 30,
			    	toolbar: toolbar
			    });

			    jQuery("#sowIntroductionCreate").validate();
			    jQuery("#sowIntroductionCreate input:text")[0].focus();
				 
			    jQuery("#savesowIntroductionSetup").click(function()
			    {
					if(loadValues() && jQuery("#sowIntroductionCreate").validate().form())
					{
						showLoadingBox();
						
						jQuery.ajax(
						{
							type: "POST",
							url: "${baseurl}/sowIntroduction/save",
							data:jQuery("#sowIntroductionCreate").serialize(),
							success: function(data)
							{
								hideLoadingBox();	
								if(data == "SowIntroduction_Available")
					      		{
					        		jQuery("#nameMsg").html('Error: This SowIntroduction is already available.');
					       		}
								else if(data == "success"){
									jQuery( xdialogDiv ).dialog( "close" );
									alert("SOW Introduction is created successfully");
									refreshNavigation();
									
									jQuery("#sowIntroductionDialog").hide();
									jQuery('#definedTerritoryId').val(jQuery('#definedTerritoryId').val());
									jQuery('#definedTerritoryId').trigger('change');
								} else{
									jQuery( xdialogDiv ).dialog( "close" );
									jQuery("#resultDialog").html('Loading .....');
									jQuery("#resultDialog").dialog( "open" ); jQuery(".resultDialog").dialog( "option", "title", "Failure" );
									jQuery("#resultDialog").html("Failed to create Sow Introduction."); jQuery( ".resultDialog" ).dialog("open");
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
			  
			    jQuery("#savesowIntroduction").click(function()
				{
					if(loadValues() && jQuery("#sowIntroductionCreate").validate().form())
					{
						
						showLoadingBox();
						jQuery.ajax({
							type: "POST",
							url: "${baseurl}/sowIntroduction/save",
							data:jQuery("#sowIntroductionCreate").serialize(),
							success: function(data)
							{
								alert(data);
								hideLoadingBox();
								if(data == "sowIntroduction_Available")
					      		{
					        		jQuery("#nameMsg").html('Error: This SowIntroduction is already available.');
					       		}
								else if(data == "success"){
									refreshGeoGroupList("${source}");
								} else{
									jQuery('#sowIntroductionErrors').html(data);
									jQuery('#sowIntroductionErrors').show();
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

			    jQuery("#cancelsowIntroduction").click(function()
				{						
					jQuery( xdialogDiv ).dialog( "close" );
					jQuery("#sowIntroductionDialog").hide();
					return false;
				});		
		 	});

		 function loadValues(){
 			var name = 'sow_text'
 			jQuery('#sow_text').val(CKEDITOR.instances[name].getData());

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
					<div id="sowIntroductionErrors" class="errors" style="display: none;">
		            </div>-->
		    <g:if test="${source=='firstsetup'}">        
	            <div class="collapsibleContainer" >
					<div class="collapsibleContainerTitle ui-widget-header" >
						<div>Add New Sow Introduction</div>
					</div>
				
					<div class="collapsibleContainerContent ui-widget-content" >
			</g:if>
		            <g:form action="save" name="sowIntroductionCreate">
		            	<g:hiddenField name="source" value="${source}"/>
		                
		                <div class="dialog">
		                    <table>
		                        <tbody>		                        
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                    <label for="name"><g:message code="sowIntroduction.name.label" default="Name" /></label>
		                                	<em>*</em>
		                                </td>
		                                <td>
		                                <g:textField name="name" value="${sowIntroductionInstance?.name}" class="required" size="35px" maxlength="25" />
		                                <g:hiddenField name="territoryId" value="${params.geoId}" />
		                                    <br/><div id="nameMsg" class="msg"></div>
		                                    </td>
		                           	 </tr>
		                           	 
		                            <tr class="prop">
		                                <td valign="top" class="name" >
		                                    <label for="sow_text"><g:message code="sowIntroduction.sow_text.label" default="Sow Text" /></label>
		                                </td>
		                                
		                                <td valign="top" class="value ${hasErrors(bean: sowIntroductionInstance, field: 'sow_text', 'errors')}">
		                                    <g:textArea name="sow_text" value="${sowIntroductionInstance?.sow_text}" rows="5" cols="0" />
		                                </td>
		                            </tr>
		                        
		                        </tbody>
		                    </table>
		                </div>
		                <div class="buttons">
		                	<g:if test="${source=='firstsetup'}">
		                		<span class="button"><button id="savesowIntroduction" title="Save Sow Introduction"> Save </button></span>
		                		<span class="button"><button id="cancelsowIntroduction" title="Cancel"> Cancel </button></span>
		                	</g:if>
		                	<g:else>
		                    	<span class="button"><button title="Save Sow Introduction" id="savesowIntroductionSetup"> Save </button></span>
		                    	<span class="button"><button id="cancelsowIntroduction" title="Cancel"> Cancel </button></span>
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
