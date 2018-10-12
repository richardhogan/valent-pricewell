<%@ page import="com.valent.pricewell.ServiceProfileSOWDef" %>
<%@ page import="com.valent.pricewell.Geo" %>
<%
	def baseurl = request.siteUrl
%>
    <head>
    	<style type="text/css">
			.submit { margin-left: 12em; }
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
		</style>
		
		<g:setProvider library="prototype"/>
		<script>
			
			jQuery(function() 
			{
				jQuery("#SOWDefinitionCreate").validate();
					//jQuery("#comment").val(jQuery("#deliverableCreate").html());
				//jQuery("#SOWDefinitionCreate input:text")[0].focus();
				
				jQuery( "#btnCreate" ).click(function() 
				{
					if(loadValues())
					{
						if(jQuery('#SOWDefinitionCreate').validate().form())
		            	{
							showLoadingBox();
			            	jQuery.ajax({type:'POST',data: jQuery("#SOWDefinitionCreate").serialize(),
								 url:'${baseurl}/serviceProfileSOWDef/saveFromService',
								 success:function(data,textStatus)
								 {
									 	jQuery('#mainSOWDefinitionTab').html(data);
									 	hideUnhideNextBtnForDefinition();
									 	hideLoadingBox();
							 	},
								 error:function(XMLHttpRequest,textStatus,errorThrown){hideLoadingBox();}});

							return false;
		            	}
					}
					
	            	return false;
				});

				var toolbar = 	[{ name: 'basicstyles', groups: [ 'basicstyles']/*, 'cleanup' ]*/, items: [ 'Bold', 'Italic', 'Underline']}, //, 'Strike', 'Subscript', 'Superscript', '-', 'RemoveFormat' ] },
					            	{ name: 'paragraph', groups: [ 'list', 'indent',/* 'blocks',*/ 'align'/*, 'bidi'*/ ], items: [ /*'NumberedList',*/ 'BulletedList', '-', 'Outdent', 'Indent', '-', /*'Blockquote', '-',*/ 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock'/*, '-', 'BidiLtr', 'BidiRtl'*/ ] },
					            	/*{ name: 'insert', items: [ 'HorizontalRule', 'Smiley', 'SpecialChar', 'PageBreak' ] },
					            	'/',*/
					            	{ name: 'styles', items: [ 'Styles', 'Format'/*, 'Font', 'FontSize'*/ ] }/*,
					            	{ name: 'colors', items: [ 'TextColor', 'BGColor' ] },
					            	{ name: 'tools', items: [ 'Maximize', 'ShowBlocks' ] },
					            	{ name: 'about', items: [ 'About' ] }*/
					            ];
	            
				var name = 'definition'
				var editor = CKEDITOR.instances[name];
			    if (editor) { editor.destroy(true); }
			    CKEDITOR.replace(name, {
			    	height: '90%',
			    	width: '98%',
			    	indentOffset: 30,
			    	toolbar: toolbar});
			});	

			function loadValues(){
    			var name = 'definition'
    			jQuery('#definition').val(CKEDITOR.instances[name].getData());

    			if(isEditorContentSupported(jQuery('#'+name).val()) == "fail")
    			{
    				return false;
    			}
    			return true;
    		}  
			
		</script>
	</head>    
	
	
	<div class="body">
	    <h1>Add SOW Definition</h1>
	    
	    
	    <g:form action="saveFromService" name="SOWDefinitionCreate">
	    	<g:hiddenField name="serviceProfileId" value="${serviceProfileId}"/>
	    	<g:hiddenField name="type" value="default"/>
	    	
	        <div class="dialog">
	            <table style="width: 100%">
	                <tbody>                
	                	
	                    <tr class="prop">
	                        <td valign="top" class="name" style="width:10%">
	                            <label for="definition"><g:message code="serviceProfileSOWDef.definition.label" default="SOW Definition" /></label>
	                            <em>*</em>
	                        </td>
	                        <td valign="top" class="value ${hasErrors(bean: serviceProfileSOWDefInstance, field: 'definition', 'errors')}" style="width:*">
	                            <g:textArea name="definition" value="${defaultSowLanguageTemplate}" rows="5" cols="60" class="required"/>
	                        </td>
	                    </tr>
	                
	                </tbody>
	            </table> 
	        </div>
	        <b>Note : </b>This is your default SOW Language...
	        <div class="buttons">
	            
	            <span class="button"><button title="Save SOW Definition" id="btnCreate"> ${message(code: 'default.button.create.label', default: 'Create')} </button></span>
	        </div>
	    </g:form>
	</div>
	    
