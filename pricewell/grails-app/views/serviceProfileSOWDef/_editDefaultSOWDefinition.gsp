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
				var toolbar = 	[{ name: 'basicstyles', groups: [ 'basicstyles']/*, 'cleanup' ]*/, items: [ 'Bold', 'Italic', 'Underline']}, //, 'Strike', 'Subscript', 'Superscript', '-', 'RemoveFormat' ] },
					            	{ name: 'paragraph', groups: [ 'list', 'indent', /*'blocks',*/ 'align'/*, 'bidi'*/ ], items: [ /*'NumberedList',*/ 'BulletedList', '-', 'Outdent', 'Indent', '-', /*'Blockquote', '-',*/ 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock'/*, '-', 'BidiLtr', 'BidiRtl'*/ ] },
					            	/*{ name: 'insert', items: [ 'HorizontalRule', 'Smiley', 'SpecialChar', 'PageBreak' ] },
					            	'/',*/
					            	{ name: 'styles', items: [ 'Styles', 'Format'/*, 'Font', 'FontSize'*/ ] }/*,
					            	{ name: 'colors', items: [ 'TextColor', 'BGColor' ] },
					            	{ name: 'tools', items: [ 'Maximize', 'ShowBlocks' ] },
					            	{ name: 'about', items: [ 'About' ] }*/
					            ];

				jQuery("#SOWDefinitionEdit").validate();
					//jQuery("#comment").val(jQuery("#deliverableCreate").html());
			    //jQuery("#SOWDefinitionEdit input:text")[0].focus();
			    
				jQuery("#btnCancel").click(function()
				{
					
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/serviceProfileSOWDef/listServiceProfileSOWDefinition",
						data: {serviceProfileId: ${serviceProfileId}},
						success: function(data){jQuery("#mainSOWDefinitionTab").html(data);}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
					});
					
					return false;
				}); 

				jQuery( "#btnUpdate" ).click(function() 
				{
					if(loadValues())
					{
						if(jQuery('#SOWDefinitionEdit').validate().form())
		            	{
							showLoadingBox();
			            	jQuery.ajax({type:'POST',data: jQuery("#SOWDefinitionEdit").serialize(),
								 url:'${baseurl}/serviceProfileSOWDef/updateFromService',
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
	
	<g:if test="${definitionList && definitionList.size() > 0}">
		<div class="nav">
		    <span>
		    	<!--<g:remoteLink class="buttons.button button" controller="serviceProfileSOWDef" 
		    		params="['serviceProfileId': serviceProfileId]" title="List Of SOW Definition"
		    		action="listServiceProfileSOWDefinition" update="[success:'mainSOWDefinitionTab',failure:'mainSOWDefinitionTab']">
		    			List of SOW Definition
		    	</g:remoteLink>-->
		    	
		    	<a id="idServiceProfileSOWDefList" onclick="serviceProfileSOWDefList();" class="buttons.button button" title="List of SOW Definition">List of SOW Definition</a>
		    </span>
		</div>
	</g:if>
	<div class="body">
	    <h1>Edit SOW Definition : ${serviceProfileSOWDefInstance?.part}</h1>
	    
	    
	    <g:form action="save" name="SOWDefinitionEdit">
	    	<g:hiddenField name="serviceProfileId" value="${serviceProfileId}"/>
	    	<g:hiddenField name="id" value="${serviceProfileSOWDefInstance?.id}"/>
	    	<g:hiddenField name="type" value="default"/>
	    	
	        <div class="dialog">
	            <table style="width:100%">
	                <tbody>                
	                	<tr class="prop">
	                        <td valign="top" class="name" style="width:10%">
	                            <label for="definition"><g:message code="serviceProfileSOWDef.definition.label" default="SOW Definition" /></label>
	                            <em>*</em>
	                        </td>
	                        <td valign="top" class="value ${hasErrors(bean: serviceProfileSOWDefInstance, field: 'definition', 'errors')}" style="width:*">
	                            <g:textArea name="definition" value="${serviceProfileSOWDefInstance?.definitionSetting?.value}" rows="5" cols="60" class="required"/>
	                        </td>
	                    </tr>
	                	
	                </tbody>
	            </table> 
	        </div>
	        <div class="buttons">
	            
	            <span class="button"><button title="Update SOW Definition" id="btnUpdate"> ${message(code: 'default.button.update.label', default: 'Update')} </button></span>
	            
	            <g:if test="${definitionList && definitionList.size() > 0}">
	            	<span class="button"><button title="Cancel" id="btnCancel"> Cancel </button></span>
	            </g:if>
	        </div>
	    </g:form>
	</div>
	    
