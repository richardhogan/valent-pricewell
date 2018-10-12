<%@ page import="com.valent.pricewell.SowIntroduction" %>
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
				 var xdialogDiv = "#sowIntroductionDialog";

				 	var toolbar = 	[{ name: 'basicstyles', groups: [ 'basicstyles'], items: [ 'Bold', 'Italic', 'Underline']}, 
						             { name: 'paragraph', groups: [ 'list', 'indent', 'align'], items: [ 'BulletedList', '-', 'Outdent', 'Indent', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock'] },
						             { name: 'styles', items: [ 'Styles', 'Format'] }];
		            
				 	var name = 'sow_text'
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
					    	
					jQuery("#savesowIntroductionSetup").click(function()
					{ 					
						if(loadValues() && jQuery("#sowIntroductionUpdate").validate().form())
						{ 
							showLoadingBox();	
												
							jQuery.ajax(
							{
								type: "POST",
								url: "${baseurl}/sowIntroduction/update",
								data:jQuery("#sowIntroductionUpdate").serialize(),
								success: function(data)
								{
									hideLoadingBox();
									if(data == "SowIntroduction_Available")
						      		{
						        		jQuery("#nameMsg").html('Error: This SowIntroduction is already available.');
						       		}
									else if(data == "success")
									{								    		         
										jQuery( xdialogDiv ).dialog( "close" );
										jQuery("#resultDialog").show();
										jQuery("#resultDialog").html('SOW Introduction is edited successfully.');

										jQuery("#sowIntroductionDialog").hide();
									}
									else{
										jQuery( xdialogDiv ).dialog( "close" );
										jQuery("#resultDialog").html('Failed to edit SOW Introduction.'); 
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
					jQuery("#savesowIntroduction").click(function()
					{
						if(loadValues() && jQuery("#sowIntroductionUpdate").validate().form())
						{
							
							showLoadingBox();
							jQuery.ajax({
								type: "POST",
								url: "${baseurl}/sowIntroduction/update",
								data:jQuery("#sowIntroductionUpdate").serialize(),
								success: function(data)
								{
									alert(data);
									hideLoadingBox();
									if(data == "SowIntroduction_Available")
						      		{
						        		jQuery("#nameMsg").html('Error: This DelivryRole is already available.');
						       		}
									else if(data == "success"){
										jQuery( xdialogDiv ).dialog( "close" );
										jQuery("#resultDialog").html('SOW Introduction is edited successfully.');
									} else{
										jQuery('#sowIntroductionErrors').html(data);
										jQuery('#sowIntroductionErrors').show();
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
        
			<g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
			<div id="sowIntroductionErrors" class="errors" style="display: none;">
            </div>
            
            <g:if test="${source=='firstsetup'}">
	            <div class="collapsibleContainer" >
					<div class="collapsibleContainerTitle ui-widget-header" >
						<div>Edit Sow Introduction</div>
					</div>
				</div></g:if>
					<div class="collapsibleContainerContent ui-widget-content" >
			
						
		            <g:form method="post" name="sowIntroductionUpdate">
		                <g:hiddenField name="source" value="${source}"/>
						<g:hiddenField name="id" value="${sowIntroductionInstance?.id}" />
		                <g:hiddenField name="version" value="${sowIntroductionInstance?.version}" />
		                <div class="dialog">
		                    <table>
		                        <tbody>
		                        
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                  <label for="name"><g:message code="sowIntroduction.name.label" default="Name" /></label>
		                                	<em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: sowIntroductionInstance, field: 'name', 'errors')}">
		                                	${sowIntroductionInstance?.name}
		                                    <g:hiddenField name="name" value="${sowIntroductionInstance?.name}" />
		                                    <g:hiddenField name="territoryId" value="${sowIntroductionInstance?.geo?.id}" />
		                                    <br/><div id="nameMsg" class="msg"></div>
		                                </td>
		                            </tr>
		                        	<!--  
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                    <label for="selectTerritory"><g:message code="SowIntroduction.label" default="Territory" /></label>
		                                </td>
		                                <td>			                                					
											<g:select name="territoryId" from="${Geo.list()}" value="${sowIntroductionInstance?.geo?.id}" optionKey="id"  noSelection="['':'Select Any One']"/>
		                                </td>
		                            </tr>
		                            -->
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                  <label for="sow_text"><g:message code="sowIntroduction.sow_text.label" default="Sow Text" /></label>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: sowIntroductionInstance, field: 'sow_text', 'errors')}">
		                                    <g:textArea name="sow_text" value="${sowIntroductionInstance?.sow_text}" rows="5" cols="40" />
		                                </td>
		                            </tr>		                         	
		                        </tbody>
		                    </table>
		                </div>
		                <div class="buttons">
		                	<g:if test="${source == 'firstsetup'}">
	                    		<span class="button"><button id="savesowIntroduction" title="Update Sow Introduction" > Update </button></span>
	                    		<span class="button"><button id="cancelsowIntroduction" title="Cancel"> Cancel </button></span>
	                    	</g:if>
	                    	<g:else>
		                    	<span class="button"><button title="Update Sow Introduction" id="savesowIntroductionSetup"> Update </button></span>
		                    	<span class="button"><button id="cancelsowIntroduction" title="Cancel"> Cancel </button></span>
	                    	</g:else>
		                </div>
		            </g:form></div>
				<g:if test="${source=='firstsetup'}">

				</g:if>
        </div>
        
    </body>
</html>
