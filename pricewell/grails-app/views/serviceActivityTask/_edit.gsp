<%@ page import="com.valent.pricewell.ServiceActivityTask" %>

<%
	def baseurl = request.siteUrl
%>

<html>
    <script>
    jQuery.noConflict();
		jQuery(document).ready(function()
		{
			jQuery("#editActivityTask").validate();
			jQuery("#updateTask").click(function()
			{
				if(jQuery("#editActivityTask").validate().form())
				{
					showLoadingBox();
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/serviceActivityTask/update",
						data:jQuery("#editActivityTask").serialize(),
						success: function(data)
						{
							hideLoadingBox();
							if(data['result'] == "success")
				      		{
					      		jQuery('.dvEditActivityTask').dialog("close");
								
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
            
            <g:form action="save" name="editActivityTask">
            	<g:hiddenField name="id" value="${serviceActivityTaskInstance?.id }"/>
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
                	<span class="button"><button id="updateTask" title="Update Task"> Update </button></span>
                </div>
            </g:form>
        </div>
        
        </br>
    </body>
</html>