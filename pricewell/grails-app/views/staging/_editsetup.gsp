

<%@ page import="com.valent.pricewell.Staging" %>
<%
	def baseurl = request.siteUrl
%>
        <g:set var="entityName" value="${message(code: 'staging.label', default: 'Staging')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
        
        <script>
		
			jQuery(document).ready(function()
		 	{
			 
						
				jQuery( "#btnUpdateStage" ).click(function() 
				{
					jQuery.post( '${baseurl}/staging/update' , 
    				  jQuery("#stagingEditFrm").serialize(),
				      function( data ) 
				      {
				      	  if(data == 'success')
				          {		               
				          		jQuery.ajax({type:'POST',
									 url:'${baseurl}/staging/show',data: {id: <%=stagingInstance.id %> },
									 success:function(data,textStatus){jQuery('#mainWorkflowSettingTab').html(data);},
									 error:function(XMLHttpRequest,textStatus,errorThrown){}});
					      }
					      
				          
				      });
				      
					
					 
						return false;
				});

				jQuery("#saveStaging").click(function(){
					if(jQuery("#stagingUpdate").valid()){
						jQuery.ajax({
							type: "POST",
							url: "${baseurl}/staging/update",
							data:jQuery("#stagingUpdate").serialize(),
							success: function(data){
								if(data == "success"){
									refreshGeoGroupList();
								} else{
									jQuery('#stagingErrors').html(data);
									jQuery('#stagingErrors').show();
								}
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){
								alert("Error while saving");
							}
						});
					}
					return false;
				}); 
				
				jQuery( "#btnDeleteStageEdit" ).click(function() 
				{
				
					jConfirm('Are you sure? You want to delete this? Press "Yes" if yes else press "No".', 'Please Confirm', function(r)
    				{
					    if(r == true)
	    				{
	    					jQuery.ajax({type:'POST',data: {id: <%=stagingInstance.id %> },
								 url:'${baseurl}/staging/delete',
								 success:function(data,textStatus){jQuery('#mainWorkflowSettingTab').html(data);},
								 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
	    				}
					});
					
						return false;
				});
					
				
				  
			});
		
			
		
		</script>
    
    <div class="body">
        
       		<g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
			<div id="stagingErrors" class="errors" style="display: none;">
            </div>
				
			<g:form method="post" name="stagingUpdate">
                <g:hiddenField name="source" value="setup"/>
				<g:hiddenField name="id" value="${stagingInstance?.id}" />
                <g:hiddenField name="version" value="${stagingInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="entity"><g:message code="staging.entity.label" default="Entity" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: stagingInstance, field: 'entity', 'errors')}">
                                    <g:select name="entity" from="${com.valent.pricewell.Staging$StagingObjectType?.values()}" keys="${com.valent.pricewell.Staging$StagingObjectType?.values()*.name()}" value="${stagingInstance?.entity?.name()}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="sequenceOrder"><g:message code="staging.sequenceOrder.label" default="Sequence Order" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: stagingInstance, field: 'sequenceOrder', 'errors')}">
                                    <g:textField name="sequenceOrder" value="${fieldValue(bean: stagingInstance, field: 'sequenceOrder')}" />
                                </td>
                            </tr>
                        
                            <!--<tr class="prop">
                                <td valign="top" class="name">
                                  <label for="types"><g:message code="staging.types.label" default="Types" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: stagingInstance, field: 'types', 'errors')}">
                                    
                                </td>
                            </tr>-->
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="description"><g:message code="staging.description.label" default="Description" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: stagingInstance, field: 'description', 'errors')}">
                                    <g:textField name="description" value="${stagingInstance?.description}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="displayName"><g:message code="staging.displayName.label" default="Display Name" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: stagingInstance, field: 'displayName', 'errors')}">
                                    <g:textField name="displayName" value="${stagingInstance?.displayName}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="name"><g:message code="staging.name.label" default="Name" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: stagingInstance, field: 'name', 'errors')}">
                                    <g:textField name="name" value="${stagingInstance?.name}" />
                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><button id="saveStaging" title="Update Stage"> Update </button></span>
                </div>
            </g:form>
			
    </div>

