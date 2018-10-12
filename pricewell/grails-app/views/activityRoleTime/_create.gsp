<%@ page import="com.valent.pricewell.DeliveryRole" %>
<%
	def baseurl = request.siteUrl
%>
	
    	<style type="text/css">
			.submit { margin-left: 12em; }
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
		
			td.name {
				font-weight: bold;
				font-size: 100%
			}
			
			td.Value {
				font-weight: bold;
				font-size: 100%
			}
			
			td.reduced {
				font-size: 90%
			}
			
		</style>
		
		<g:setProvider library="prototype"/>
		
		<script>
			jQuery(document).ready(function()
			{
				
				jQuery("#createActivityRoleTime").validate(
			    {
  					rules: 
  					{
    					estimatedTimeInHoursFlat: 
    					{
      						number: true	
    					},
    					estimatedTimeInHoursPerBaseUnits:
    					{
    						number: true
    					}
  					}
				});

				if(${roleList.size()} > 0)
				{
					jQuery("#createActivityRoleTime input:text")[0].focus();
				}
					
				jQuery("#saveBtn").click(function()
				{
					if(jQuery('#createActivityRoleTime').validate().form())
					{
				    	jQuery.ajax(
						{
							type: "POST",
							url: "${baseurl}/activityRoleTime/save",
							data: jQuery("#createActivityRoleTime").serialize(),
							success: function(data)
							{
								jQuery('#dvRoleList').html(data);
								hideUnhideNextBtn();
								
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){
								alert("Error while saving");
							}
						});
    				}
					return false;
				}); 

				jQuery("#cancelBtn").click(function()
				{
					jQuery.ajax(
					{
						type: "POST",
						url: "${baseurl}/serviceActivity/editFromDeliverable",
						data: {id: ${serviceActivityId}},
						success: function(data)
						{
							jQuery('#delActivity').html(data);
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){
							alert("Error while saving");
						}
					});
    				
					return false;
				}); 
			});
		</script>
	  
<div class="body">
	<g:if test="${roleList.size() > 0}">
		<g:form method="post" id="createActivityRoleTime" name="createActivityRoleTime">
		    <g:hiddenField name="serviceActivityId" value="${serviceActivityId}" />
		    <div>
		        <table>
		            <tbody>
		            	
		            	<tr class="prop">
		                    <td valign="top" class="name">
		                      <label for="role"><g:message code="activityRoleTime.role.label" default="Role" /><em>*</em></label>
		                    </td>
		                    
		                    <td valign="top" class="name">
		                      <label for="estimatedTimeInHoursFlat"><g:message code="activityRoleTime.estimatedTimeInHoursFlat.label" default="Estimated Time In Hours (Flat)" /><em>*</em></label>
		                    	
		                    </td>
		                    
		                    <td valign="top" class="name">
		                      <label for="estimatedTimeInHoursPerBaseUnits"><g:message code="activityRoleTime.estimatedTimeInHoursPerBaseUnits.label" default="Additional Time In Hours (Per Unit)" /><em>*</em></label>
								
							</td>
		                    
		                    <td></td>
		                    
		                    <g:if test="${serviceActivityInstance?.rolesEstimatedTime?.size() > 0}"><td></td></g:if>
		                </tr>
		            	
		            	
		               <tr class="prop">
		                    <td valign="top" class="value ${hasErrors(bean: activityRoleTimeInstance, field: 'role', 'errors')}">
		                        <g:select name="role.id" from="${roleList}" optionKey="id" value="${activityRoleTimeInstance?.role?.id}" class="required" />
		                    </td>
		                    
		                    <td valign="top" class="value ${hasErrors(bean: activityRoleTimeInstance, field: 'estimatedTimeInHoursFlat', 'errors')}">
		                        <g:textField name="estimatedTimeInHoursFlat" id="estimatedTimeInHoursFlat" value="${fieldValue(bean: activityRoleTimeInstance, field: 'estimatedTimeInHoursFlat')}" class="required"/>
		                    </td>
		                 	
							<td valign="top" class="value ${hasErrors(bean: activityRoleTimeInstance, field: 'estimatedTimeInHours', 'errors')}">
		                        <g:textField name="estimatedTimeInHoursPerBaseUnits" id="estimatedTimeInHoursPerBaseUnits" value="${fieldValue(bean: activityRoleTimeInstance, field: 'estimatedTimeInHoursPerBaseUnits')}" class="required"/>
		                    </td>
		                    
		                    <td>
		                    	<input id="saveBtn" title="Save" type="button" value="Save" />
		                    </td>
		                    <g:if test="${serviceActivityInstance?.rolesEstimatedTime?.size() > 0}">
			                    <td>
			                    	<input id="cancelBtn" title="Cancel" type="button" value="Cancel" />
			                    </td>
		                    </g:if>
		                </tr>
		                            
		            </tbody>
		        </table>
		    </div>
		    
		</g:form>
		
	</g:if>
	
	<g:else>
		Activity Role Time is defined for all Roles......<input id="cancelBtn" title="Cancel" type="button" value="Cancel" />
	</g:else>
</div>
        
