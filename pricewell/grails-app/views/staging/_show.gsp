
<%@ page import="com.valent.pricewell.Staging" %>
<%
	def baseurl = request.siteUrl
%>
        <g:set var="entityName" value="${message(code: 'staging.label', default: 'Staging')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
        
        <script>
		
			jQuery(document).ready(function()
		 	{
			 
						
				jQuery( "#btnEditStage" ).click(function() 
				{
					jQuery.ajax({type:'POST',data: {id: <%=stagingInstance.id %> },
						 url:'${baseurl}/staging/edit',
						 success:function(data,textStatus){jQuery('#mainWorkflowSettingTab').html(data);},
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});
					 
						return false;
				});
				
				jQuery( "#btnDeleteStageShow" ).click(function() 
				{
				
					jConfirm('Are you sure? You want to delete this? Press "Yes" if yes else press "No".', 'Confirmation Dialog', function(r)
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
        <div class="nav">
            <span><g:remoteLink class="buttons.button button" title="List Of Stages" action="stagingList" controller="staging" update="[success:'mainWorkflowSettingTab',failure:'mainWorkflowSettingTab']"><g:message code="default.list.label" args="[entityName]" /></g:remoteLink></span>
            <span><g:remoteLink class="buttons.button button" title="Create New Stage" action="create" controller="staging" update="[success:'mainWorkflowSettingTab',failure:'mainWorkflowSettingTab']"><g:message code="default.new.label" args="[entityName]" /></g:remoteLink></span>
        </div>
        <div>
        
        	<div class="collapsibleContainer">
				<div class="collapsibleContainerTitle ui-widget-header">
					<div><g:message code="default.show.label" args="[entityName]" /></div>
				</div>
			
				<div class="collapsibleContainerContent">
				
					<g:if test="${flash.message}">
		            <div class="message">${flash.message}</div>
		            </g:if>
		            <div class="dialog">
		                <table>
		                    <tbody>
		                    
		                        <tr class="prop">
		                            <td valign="top" class="name"><g:message code="staging.id.label" default="Id" /></td>
		                            
		                            <td valign="top" class="value">${fieldValue(bean: stagingInstance, field: "id")}</td>
		                            
		                        </tr>
		                    
		                        <tr class="prop">
		                            <td valign="top" class="name"><g:message code="staging.entity.label" default="Entity" /></td>
		                            
		                            <td valign="top" class="value">${stagingInstance?.entity?.encodeAsHTML()}</td>
		                            
		                        </tr>
		                    
		                        <tr class="prop">
		                            <td valign="top" class="name"><g:message code="staging.sequenceOrder.label" default="Sequence Order" /></td>
		                            
		                            <td valign="top" class="value">${fieldValue(bean: stagingInstance, field: "sequenceOrder")}</td>
		                            
		                        </tr>
		                    
		                        <tr class="prop">
		                            <td valign="top" class="name"><g:message code="staging.types.label" default="Types" /></td>
		                            
		                            <td valign="top" class="value">${fieldValue(bean: stagingInstance, field: "types")}</td>
		                            
		                        </tr>
		                    
		                        <tr class="prop">
		                            <td valign="top" class="name"><g:message code="staging.description.label" default="Description" /></td>
		                            
		                            <td valign="top" class="value">${fieldValue(bean: stagingInstance, field: "description")}</td>
		                            
		                        </tr>
		                    
		                        <tr class="prop">
		                            <td valign="top" class="name"><g:message code="staging.displayName.label" default="Display Name" /></td>
		                            
		                            <td valign="top" class="value">${fieldValue(bean: stagingInstance, field: "displayName")}</td>
		                            
		                        </tr>
		                    
		                        <tr class="prop">
		                            <td valign="top" class="name"><g:message code="staging.name.label" default="Name" /></td>
		                            
		                            <td valign="top" class="value">${fieldValue(bean: stagingInstance, field: "name")}</td>
		                            
		                        </tr>
		                    
		                    </tbody>
		                </table>
		            </div>
		            <div class="buttons">
		                <g:form>
		                    <g:hiddenField name="id" value="${stagingInstance?.id}" />
		                    <button id="btnEditStage" title="Edit Stage">Edit</button>
		                    <button id="btnDeleteStageShow" title="Delete Stage">Delete</button>
		                    <!--<span class="button"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
		                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>-->
		                </g:form>
		            </div>
				
				</div>
				
			</div>
        
            
            
        </div>
    </div>

