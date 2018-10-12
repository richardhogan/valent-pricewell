<%@ page import="com.valent.pricewell.Service" %>
<%
	def baseurl = request.siteUrl
%>
  <head>
    		
		
    	<script language="JavaScript" type="text/javascript"> 

    		jQuery(document).ready(function()
    		{
			 	jQuery("#serviceEditDef").submit(function() 
		 		{
			 		loadValues();

					
						jQuery.ajax({
								type: 'POST',
								url: '${baseurl}/service/saveStage',
								data: jQuery("#serviceEditDef").serialize(),
								async: false,
								success:function(data,textStatus)
								{
									if(data)
									{
										jQuery('#scope_definition').html(data);
										if(${serviceProfileInstance.isImported == 'true' && serviceProfileInstance?.importServiceStage == 'concept'})
										{
											window.location.href = '${baseurl}/service/changeImportServiceStage?id='+${serviceProfileInstance?.id};
										}
									}
								},
								 error:function(XMLHttpRequest,textStatus,errorThrown){alert('Error while saving, error message:' + errorThrown)}
							});
		 				
						return false;
				});

			 	jQuery( "#saveBtn" ).button().click(function() 
					{
						loadValues();
						
						if(jQuery('#serviceEditDef').validate().form())
		            	{
			            	jQuery.ajax({type:'POST',data: jQuery("#serviceEditDef").serialize(),
								 url:'${baseurl}/service/saveDefinition',
								 success:function(data,textStatus){jQuery('#serviceDefinition').html(data);},
								 error:function(XMLHttpRequest,textStatus,errorThrown){}});
	
							jQuery('.swMain .buttonNext').removeClass("buttonDisabled").removeClass("buttonHide");
							return false;
		            	}
					});

			 		var name = 'definition'
					var editor = CKEDITOR.instances[name];
				    if (editor) { editor.destroy(true); }
				    CKEDITOR.replace(name, {
				    	height: '90%',
				    	width: '700px',
				    	toolbar: 'Basic'});
				
			});

    		function loadValues(){
    			var name = 'definition'
    			jQuery('#definition').val(CKEDITOR.instances[name].getData());
    		}
        	
		</script> 
    </head>
 	<body>
        <div id="serviceDefinition">
	        <div class="body">
	            <!--<g:if test="${flash.message}">
	            <div class="message">${flash.message}</div>
	            </g:if>
	            <g:hasErrors bean="${serviceInstance}">
	            <div class="errors">
	                <g:renderErrors bean="${serviceInstance}" as="list" />
	            </div>
	            </g:hasErrors>-->
	            <g:form action="saveDefinition" controller="service" name="serviceEditDef">
	            	<g:hiddenField name="id" value="${serviceProfileInstance?.id}" />
	                <g:hiddenField name="version" value="${serviceProfileInstance?.version}" />
	                <div class="dialog">
	                	 
	                    <table>
	                        <tbody>
	                        	
	                            <tr class="prop">
	                                <td valign="top" class="name">
	                                    <label for="definition"><g:message code="serviceProfile.definition.label" default="Scope Definition Language:" /></label>
	                                </td>
	                           </tr>
	                           <tr>
	                                <td valign="top" class="value ${hasErrors(bean: serviceProfileInstance, field: 'service.serviceName', 'errors')}">
										<g:textArea  name="definition" value="${serviceProfileInstance?.definition}" rows="15" cols="120" style="width: 90%"/>
	                                </td>
	                            </tr>
	                            
	                        </tbody>
	                    </table>
						
						<g:if test="${hideButtons}">  
							<!-- <span><button id="saveBtn">Save</button></span>-->
						</g:if>
						<g:else>                  
		                    <div class="buttons">
			                    <span class="button">	                    	
			                    <g:submitToRemote  title="Save Definition" controller="service" action="saveDefinition" update="[success:'tbDef',failure:'tbDef']"  params="[serviceProfileId: serviceProfileInstance?.id]" class="update" value="${message(code: 'default.button.update.label', default: 'Update')}"/></span>
			                    <input type="button" title="Cancel"  value="Cancel" onclick="location.href='${baseurl}/service/show/${serviceProfileInstance?.id}'"/>
		                	</div>
		                </g:else>
		                
	                	</div>
	                
	                
	            </g:form>
	        </div>
        </div>
    </body>
 