<%@ page import="com.valent.pricewell.Quotation" %>
<%@ page import="com.valent.pricewell.ProjectParameter" %>
<%@ page import="com.valent.pricewell.SowSupportParameter" %>
<%
	def baseurl = request.siteUrl
%>
    <head>
    	<g:setProvider library="prototype"/>
    	<style type="text/css">
			.submit { margin-left: 12em; }
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
		</style>
		<script>
			
			jQuery(function() 
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
				
				jQuery("#btnCancel").click(function()
				{
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/projectParameter/listProjectParameters",
						data: {quotationId: ${quotationId}},
						success: function(data){jQuery("#mainSOWProjectParametersTab").html(data);}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
					});
					
					return false;
				});

				jQuery("#sowSupportParameterSelection").change(function(){
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
					/*if( jQuery("#sowSupportParameterSelection").val() != '' ){
						jQuery("#value").val(jQuery("#sowSupportParameterSelection").val());
						CKEDITOR.instances[name].setData(jQuery("#sowSupportParameterSelection").val());
					}*/
				});
				
				jQuery(".btnCreateProjectParameter").click(function()
				{
					if(loadValues())
					{
						if(jQuery('#createProjectParameterFrm').validate().form())
						{
							//showLoadingBox();
							showThrobberBox();
							//loadValues();
					    	jQuery.ajax(
							{
								type: "POST",
								url: "${baseurl}/projectParameter/saveFromQuotationSow",
								data: jQuery("#createProjectParameterFrm").serialize(),
								success: function(data)
								{
									//hideLoadingBox();
									hideThrobberBox();
									jQuery('#mainSOWProjectParametersTab').html(data);
									hideUnhideNextBtn();
									//loadValues();
								}, 
								error:function(XMLHttpRequest,textStatus,errorThrown){
									alert("Error while saving");
								}
							});
						}
					}					
					return false;
				});  
			});	  

			function loadValues(){
    			var name = 'value'
    			jQuery('#value').val(CKEDITOR.instances[name].getData());

    			if(isEditorContentSupported(jQuery('#value').val()) == "fail")
    			{
    				return false;
    			}
    			return true;
    		}

			function listProjectParameters()
			{
				jQuery.ajax({
					type: "POST",
					url: "${baseurl}/projectParameter/listProjectParameters",
					data: {quotationId: ${quotationId} },
					success: function(data){jQuery("#mainSOWProjectParametersTab").html(data);}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
				});
				
				return false;
			}
		</script>
	</head>    
	
	<div class="nav">
	    <!-- <span>
	    	<g:remoteLink class="buttons.button button" controller="projectParameter" 
	    		params="['quotationId': quotationId]" title="List Of Project Parameters"
	    		action="listProjectParameters" update="mainSOWProjectParametersTab">
	    			List of Project Parameters
	    	</g:remoteLink>
	    </span> -->
	    
	    <span>
			<a id="idlistProjectParameters" onclick="listProjectParameters();" class="buttons.button button" title="List Of Project Parameters">List Of Project Parameters</a>
		</span>
	</div>
	<div class="body">
	    <h1>Add Project Parameter</h1>
	    
	     <g:form action="save" name="createProjectParameterFrm">
	    	<g:hiddenField name="quotationId" value="${quotationId}"/>
	    	
	        <div class="dialog">
	            <table>
	                <tbody>                
	                	<tr class="prop">
                              <td valign="top">
                                  <label for="sowSupportParameterSelection">Project Parameter List</label>
                              </td>
                              <td valign="top" class="value">		
									<g:select style="width:400px" id="sowSupportParameterSelection" name="sowSupportParameterSelection" from="${session.sowSupportParameterList}" optionKey="id" optionValue="name" noSelection="['':'Select Any One']"/>
                              </td>
	                	</tr>

	                    <tr class="prop">
	                    	<td valign="top">
	                            <label>Project Parameter<em>*</em></label>
	                        </td>
	                        
	                        <td valign="top" class="value ${hasErrors(bean: quotationInstance, field: 'value', 'errors')}">
	                            <!--<g:textArea name="value" value="${projectParameterInstance?.value}" class="required"/>-->
	                            <g:textArea name="value" id="value" value="" class="required"/>
	                        </td>
	                    </tr>
	                
	                </tbody>
	            </table>
	             
	        </div>
	        <div class="buttons">
	            
	            <span class="button">
                  	<button id="btnCreateProjectParameter" class="btnCreateProjectParameter" title="Save Project Parameter">Save</button>
                </span>
                   	
	            <g:if test="${projectParameters && projectParameters.size() > 0}">
	            	<span class="button"><button title="Cancel" id="btnCancel"> Cancel </button></span>
	            </g:if>
	        </div>
	    </g:form>
	</div>
	    
