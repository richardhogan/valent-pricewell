

<%@ page import="com.valent.pricewell.Staging" %>
<%
	def baseurl = request.siteUrl
%>
        <g:set var="entityName" value="${message(code: 'staging.label', default: 'Staging')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
        
        <script>
		
			jQuery(document).ready(function()
		 	{
			 
						
				jQuery( "#btnSaveStage" ).click(function() 
				{
					jQuery.post( '${baseurl}/staging/save' , 
    				  jQuery("#stagingCreateFrm").serialize(),
				      function( data ) 
				      {
				      	  if(data == 'success')
				          {		               
				          		jQuery.ajax({type:'POST',
									 url:'${baseurl}/staging/stagingList',
									 success:function(data,textStatus){jQuery('#mainWorkflowSettingTab').html(data);},
									 error:function(XMLHttpRequest,textStatus,errorThrown){}});
					      }
					      
				          
				      });
				      
					
					 
						return false;
				});
				
				  
			});
		
			
		
		</script>
    
    <div class="body">
        <div class="nav">
            <span><g:remoteLink class="buttons.button button" action="stagingList" controller="staging" update="[success:'mainWorkflowSettingTab',failure:'mainWorkflowSettingTab']"><g:message code="default.list.label" args="[entityName]" /></g:remoteLink></span>
        </div>
        <div>
            <h1><g:message code="default.create.label" args="[entityName]" /></h1>
            
            <g:form name="stagingCreateFrm">
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
                	<button id="btnSaveStage">Save</button>
                </div>
            </g:form>
        </div>
    </div>

