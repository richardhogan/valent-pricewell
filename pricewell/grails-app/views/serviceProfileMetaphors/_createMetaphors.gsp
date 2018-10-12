<%@ page import="com.valent.pricewell.ServiceDeliverable" %>
<%@ page import="com.valent.pricewell.ServiceProfileMetaphors.MetaphorsType" %>
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
			
			jQuery(document).ready(function()
			{
				var toolbar = 	[{ name: 'basicstyles', groups: [ 'basicstyles'], items: [ 'Bold', 'Italic', 'Underline']}, 
				            	 { name: 'paragraph', groups: [ 'list', 'indent', 'align'], items: [ 'BulletedList', '-', 'Outdent', 'Indent', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock'] },
				            	 { name: 'styles', items: [ 'Styles', 'Format'] }
				            ];

				var name = 'description_${metaphorType}'
				
				var editor = CKEDITOR.instances[name];
						
			    if (editor) { 
				    editor.destroy(true); 
			    }
				
			    CKEDITOR.replace(name, 
				{
			    	height: '70%',
			    	width: '98%',
			    	indentOffset: 30,
			    	toolbar: toolbar
			    });

				jQuery("#createMetaphorsFrm_${metaphorType}").validate();
				
				jQuery("#btnCancel").click(function()
				{
					
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/serviceProfileMetaphors/listMetaphors",
						data: {serviceProfileId: ${serviceProfileId}, metaphorType: '${metaphorType}', entityName: '${entityName}'},
						success: function(data){jQuery("#mainServiceProfileMetaphorsTab-${metaphorType }").html(data);}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
					});
					
					return false;
				});

				jQuery(".btnCreateMetaphors_${metaphorType}").click(function()
				{
					if(loadValues())
					{
						if(jQuery('#createMetaphorsFrm_${metaphorType}').validate().form())
						{
							showLoadingBox();
					    	jQuery.ajax(
							{
								type: "POST",
								url: "${baseurl}/serviceProfileMetaphors/saveFromService",
								data: jQuery("#createMetaphorsFrm_${metaphorType}").serialize(),
								success: function(data)
								{
									//hideUnhideNextBtn();
									hideLoadingBox();
									jQuery('#mainServiceProfileMetaphorsTab-${metaphorType }').html(data);
									
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
    			var name = 'description_${metaphorType}'
    				jQuery("#"+name).val(CKEDITOR.instances[name].getData());
    				jQuery(".description").val(CKEDITOR.instances[name].getData());

    				if(isEditorContentSupported(jQuery('#'+name).val()) == "fail")
        			{
        				return false;
        			}
        			return true;
    		}  

			function serviceMetaphorList()
			{
				jQuery.ajax({
					type: "POST",
					url: "${baseurl}/serviceProfileMetaphors/listMetaphors",
					data: {'serviceProfileId': ${serviceProfileId}, 'metaphorType': '${metaphorType}', 'entityName': '${entityName}'},
					success: function(data){jQuery("#mainServiceProfileMetaphorsTab-${metaphorType}").html(data);}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
				});
				
				return false;
			}
		</script>
	</head>    
	
	<%--<div class="nav">
	    <span>
	    	<%--<g:remoteLink class="buttons.button button" controller="serviceProfileMetaphors" 
	    		params="['serviceProfileId': serviceProfileId, 'metaphorType': metaphorType, 'entityName': entityName]" title="List Of ${entityName }"
	    		action="listMetaphors" update="mainServiceProfileMetaphorsTab-${metaphorType }">
	    			List of ${entityName }
	    	</g:remoteLink>
	    	--%>
	    	
	    <%--	<a id="idServiceMetaphorList" onclick="serviceMetaphorList();" class="buttons.button button" title="List of ${entityName }">List of ${entityName }</a>
	    </span>
	</div>
	--%>
	
	<div class="body">
	    <h1>Add ${entityName }</h1>
	    
	     <g:form action="save" name="createMetaphorsFrm_${metaphorType}">
	    	<g:hiddenField name="serviceProfileId" value="${serviceProfileId}"/>
	    	<g:hiddenField name="metaphorType" value="${metaphorType}"/>
	    	<g:hiddenField name="entityName" value="${entityName }"/>
	    	<g:hiddenField name="description" value="" class="description" />

	        <div class="dialog">
	            <table style="width:100%">
	                <tbody>                
	                	
	                    <tr class="prop">
	                        <td valign="top">
	                            <g:textArea name="description_${metaphorType}" rows="10" cols="130" class="required"/>
	                        </td>
	                    </tr>
	                
	                </tbody>
	            </table>
	             
	        </div>
	        <div class="buttons">
	            
	            <span class="button">
                  	<button id="btnCreateMetaphors_${metaphorType}" class="btnCreateMetaphors_${metaphorType}" title="Save Pre-requisite">Save</button>
                </span>
                   	
	            <%-- <g:if test="${metaphorsList && metaphorsList.size() > 0}">
	            	<span class="button"><button title="Cancel" id="btnCancel"> Cancel </button></span>
	            </g:if>--%>
	        </div>
	    </g:form>
	</div>
	    
