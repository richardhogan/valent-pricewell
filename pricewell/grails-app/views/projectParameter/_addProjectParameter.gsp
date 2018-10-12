
<%@ page import="com.valent.pricewell.ProjectParameter" %>
<%@ page import="com.valent.pricewell.SowSupportParameter" %>
<%@ page import="com.valent.pricewell.Quotation" %>

<%
	def baseurl = request.siteUrl
%>
	<g:setProvider library="prototype"/>
	
	<script>

	
		jQuery(document).ready(function()
		{
			var toolbar = 	[{ name: 'basicstyles', groups: [ 'basicstyles']/*, 'cleanup' ]*/, items: [ 'Bold', 'Italic', 'Underline']}, //, 'Strike', 'Subscript', 'Superscript', '-', 'RemoveFormat' ] },
				            	{ name: 'paragraph', groups: [ 'list', 'indent', /*'blocks',*/ 'align'/*, 'bidi'*/ ], items: [ /*'NumberedList',*/ 'BulletedList', '-', 'Outdent', 'Indent', '-',/* 'Blockquote', '-',*/ 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock'/*, '-', 'BidiLtr', 'BidiRtl'*/ ] },
				            	/*{ name: 'insert', items: [ 'HorizontalRule', 'Smiley', 'SpecialChar', 'PageBreak' ] },
				            	'/',*/
				            	{ name: 'styles', items: [ 'Styles', 'Format'/*, 'Font', 'FontSize'*/ ] }/*,
				            	{ name: 'colors', items: [ 'TextColor', 'BGColor' ] },
				            	{ name: 'tools', items: [ 'Maximize', 'ShowBlocks' ] },
				            	{ name: 'about', items: [ 'About' ] }*/
				            ];
            
			var name = 'value'
			var editor = CKEDITOR.instances[name];
		    if (editor) { editor.destroy(true); }
		    CKEDITOR.replace(name, {
		    	height: '70%',
		    	indentOffset: 30,
		    	width: ''+Math.round(jQuery(window).width()*2/3)+'px',
		    	toolbar: toolbar});
	    	
			jQuery("#createProjectParameterFrm").validate();
			
			jQuery("#sowSupportParameterSelection").change(function()
			{
				var selectedId = this.value;

				if(selectedId != "")
				{
					showThrobberBox();
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/sowSupportParameter/getParameterText",
						data:{id: selectedId},
						success: function(data)
						{
							hideThrobberBox();
							jQuery('#value').val(data.project_parameter_text);
							CKEDITOR.instances[name].setData(data.project_parameter_text);
							
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){
							hideThrobberBox();
							jQuery('#value').val("");
							CKEDITOR.instances[name].setData("");
						}
					});
				}
				else jQuery('#sowIntroduction').val("");
				
				return false;
			});

			jQuery("#createProjectParameterFrm").submit(function() 
			{
				showThrobberBox();
				
		    	jQuery.ajax(
				{
					type: "POST",
					url: "${baseurl}/quotation/saveGenerateSOWStages",
					data: jQuery("#createProjectParameterFrm").serialize(),
					success: function(data)
					{
						hideThrobberBox();
						//jQuery('#mainSOWProjectParametersTab').html(data);
						//hideUnhideNextBtn();
					}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){
						hideThrobberBox();
						alert("Error while saving");
					}
				});
				
				return false;
			});	
			
		});	  

		function loadProjectParameters()
		{			
			var name = 'value'
			jQuery('#value').val(CKEDITOR.instances[name].getData());

			//alert(isEditorContentSupported(jQuery('#value').val())); return false;
			
			if(isEditorContentSupported(jQuery('#value').val()) == "fail")
			{
				return false;
			}
			return true;
		}
			

	</script>

	<div class="body">
	    <h1>Add Project Parameter</h1>
	    
	     <g:form action="save" name="createProjectParameterFrm">
	    	<g:hiddenField name="id" value="${quotationInstance?.id}"/>
	    	<g:hiddenField name="version" value="${projectParameterInstance.version}"/>
	        <div class="dialog">
	            <table>
	                <tbody>                
	                	<tr class="prop">
                              <td valign="top">
                                  <label for="sowSupportParameterSelection">Project Parameter List</label>
                              </td>
                              <td valign="top" class="value">		
									<g:select style="width:400px" id="sowSupportParameterSelection" name="sowSupportParameterSelection" from="${sowSupportParameterList}" optionKey="id" optionValue="name" noSelection="['':'Select Any One']"/>
                              </td>
	                	</tr>

	                    <tr class="prop">
	                    	<td valign="top">
	                            <label>Project Parameter<em>*</em></label>
	                        </td>
	                        
	                        <td valign="top" class="value ${hasErrors(bean: projectParameterInstance, field: 'value', 'errors')}">
	                            <g:textArea name="value" id="value" value="${projectParameterInstance.value}" class="required"/>
	                        </td>
	                    </tr>
	                
	                </tbody>
	            </table>
	             
	        </div>
	    </g:form>
	    
	</div>