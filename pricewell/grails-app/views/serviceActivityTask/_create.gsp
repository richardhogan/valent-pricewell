<%@ page import="com.valent.pricewell.ServiceActivityTask" %>

<%
	def baseurl = request.siteUrl
%>

<html>
    <script>
    jQuery.noConflict();	
		jQuery(document).ready(function()
		{
			jQuery("#createActivityTask").validate();
			jQuery("#saveTask").click(function()
			{
				if(jQuery("#createActivityTask").validate().form())
				{
					showLoadingBox();
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/serviceActivityTask/save",
						data:jQuery("#createActivityTask").serialize(),
						success: function(data)
						{
							hideLoadingBox();
							if(data['result'] == "success")
				      		{
					      		if(data['taskId'] != "" && data['taskId'] != null)
						      	{
					      			jQuery('.dvAddActivityTask').data('taskId', data['taskId']);  	
						      	}
								 
								jQuery('.dvAddActivityTask').dialog("close");
								//addTaskToList(data['taskId']);
				       		}
							
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){
							hideLoadingBox();
							alert("Error while saving");
						}
					});
				}
				return false;
			});
			
		});
  	</script>
  	
    <body>
        <!-- <h1>Add Service Activity Task</h1> -->
        <div class="body">
            
            <g:form action="save" name="createActivityTask">
            
            	<g:hiddenField name="activityId" value="${serviceActivityInstance?.id }"/>
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="task"><g:message code="serviceActivityTask.task.label" default="Task" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceActivityTaskInstance, field: 'task', 'errors')}">
                                    <g:textArea name="task" cols="40" rows="5" value="${serviceActivityTaskInstance?.task}" class="required"/>
                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                	<span class="button"><button id="saveTask" title="Save Task"> Save </button></span>
                </div>
            </g:form>
        </div>
        
        </br>
    </body>
</html>