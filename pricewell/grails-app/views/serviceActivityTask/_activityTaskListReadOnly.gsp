<%@ page import="com.valent.pricewell.ServiceActivityTask" %>
<%
	def baseurl = request.siteUrl
%>

<script>
	jQuery(document).ready(function()
	{
		jQuery("#btnServiceActivityTasks-${serviceActivityInstance.id}").hide();
				
		jQuery("#hideTaskList-${serviceActivityInstance?.id}").click(function() 
		{
			jQuery("#btnServiceActivityTasks-${serviceActivityInstance.id}").show();
			jQuery('#dvServiceActivityTaskList-${serviceActivityInstance?.id}').html("");
		}); 
	});
	
</script>

<div class="body">
	<div class="collapsibleContainer">
		<div class="collapsibleContainerTitle ui-widget-header">
			<div style="float: left; width: 90%">Task List</div> <!-- ${serviceActivityInstance?.name} -->
			
			<div>
				<!-- <button id="hideTaskList" class="roundNewButton" title="Hide List">Hide</button> -->
				<button id="hideTaskList-${serviceActivityInstance?.id}" class="btnServiceActivityHideTasks" title="Hide Tasks List">Hide</button>
			</div>
		</div>
	
		<div class="collapsibleContainerContent ui-widget-content">
		
			<table>
           
	            <g:each in="${serviceActivityTaskList}" status="j" var="serviceActivityTaskInstance">
	                <tr class="${(j % 2) == 0 ? 'odd' : 'even'}">
	                
	                    <td>${j+1}</td>
	                	
	                    <td>${serviceActivityTaskInstance?.task}</td>
	                
	                </tr>
	            </g:each>
            
        	</table>

		</div>
		
	</div>
</div>
	

        