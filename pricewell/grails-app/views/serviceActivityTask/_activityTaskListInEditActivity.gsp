<%@ page import="com.valent.pricewell.ServiceActivityTask" %>
<%
	def baseurl = request.siteUrl
%>

<script>
	jQuery.noConflict();
	jQuery(document).ready(function()
	{
				
		jQuery(".addTask").click(function() 
		{
			
			jQuery( ".dvAddActivityTask" ).dialog( "open" );
			jQuery.ajax(
			{
				type:'POST',
			 	url:'${baseurl}/serviceActivityTask/createFromServiceActivity',
			 	data: {activityId: '${activityId}'},
				 	success:function(data,textStatus)
				 		{jQuery('.dvAddActivityTask').html(data);},
				 	error:function(XMLHttpRequest,textStatus,errorThrown)
				 		{}
				});
				return false;
		}); 

		jQuery(".editTask").click(function() 
		{
			if(jQuery("input:radio[name=activityTaskRadioGroup]").is(":checked")) 
			{

				var val = jQuery('input:radio[name=activityTaskRadioGroup]:checked').val();

				jQuery( ".dvEditActivityTask" ).dialog( "open" );
				jQuery.ajax(
				{
					type:'POST',
				 	url:'${baseurl}/serviceActivityTask/editFromServiceActivity',
				 	data: {id: val, activityId: '${activityId}'},
				 	success:function(data,textStatus)
				 		{jQuery('.dvEditActivityTask').html(data);},
				 	error:function(XMLHttpRequest,textStatus,errorThrown)
				 		{}
				});
			}
			
			return false;
		}); 

		jQuery(".deleteTask").click(function() 
		{
			if(jQuery("input:radio[name=activityTaskRadioGroup]").is(":checked")) 
			{

				var val = jQuery('input:radio[name=activityTaskRadioGroup]:checked').val();

				//alert(val);
				showLoadingBox();
				jQuery.ajax(
				{
					type:'POST',
				 	url:'${baseurl}/serviceActivityTask/deleteFromServiceActivity',
				 	data: {id: val},
				 	success:function(data,textStatus)
				 	{
				 		hideLoadingBox();
					 	if(data == "success")
						{
					 		jQuery('.dvDeleteActivityTask').dialog("open").data('taskId', val);	
						}
				 	},
				 	error:function(XMLHttpRequest,textStatus,errorThrown)
				 	{hideLoadingBox();}
				});
			}
			
			return false;
		}); 

	});
	
</script>

<div>

	

	
	
    <div>
	    
	    <div class="collapsibleContainer">
			<button title="Add Service Activity Task" id="addTask" class="addTask"> Add Task </button>
			
			<g:if test="${serviceActivityTaskList?.size() > 0}">
				<button title="Change Order of Service Activity Task" id="changeTaskOrder" class="changeTaskOrder"> Change Order </button>
				
				<button title="Edit Service Activity Task" id="editTask" class="editTask"> Edit </button>
				
				<button title="Delete Service Activity Task" id="deleteTask" class="deleteTask"> Delete </button>
			</g:if>
			
			<br/>
			<g:if test="${serviceActivityTaskList?.size() > 0}">
				
			    	
					<div class="collapsibleContainerContent ui-widget-content">
						
						<table>
		            
				            <tbody>
					            <g:each in="${serviceActivityTaskList?.sort{it.sequenceOrder}}" status="i" var="serviceActivityTaskInstance">
					                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
					                
					                    <!-- <td><g:link action="show" id="${serviceActivityTaskInstance.id}">${fieldValue(bean: serviceActivityTaskInstance, field: "id")}</g:link></td> -->
					                
					                	<td><g:radio name="activityTaskRadioGroup" value="${serviceActivityTaskInstance.id}" class="activityTaskRadioGroup"/></td>
					                	
					                    <td>${fieldValue(bean: serviceActivityTaskInstance, field: "task")}</td>
					                
					                </tr>
					            </g:each>
				            </tbody>
				        </table>
			
					</div>
					
				
			</g:if>
		
        </div>
        <br/>
    </div>
</div>