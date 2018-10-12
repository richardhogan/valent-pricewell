<%@ page import="com.valent.pricewell.ServiceActivityTask" %>

<%
	def baseurl = request.siteUrl
%>

<script>
	jQuery(document).ready(function()
	{
				
		jQuery(".upTask").click(function() 
		{
			showLoadingBox();
			jQuery.ajax(
			{
				type:'POST',
			 	url:'${baseurl}/serviceActivityTask/upOrder',
			 	data: jQuery("#changeTaskOrderFrm").serialize(),
			 	success:function(data,textStatus)
			 	{
			 		hideLoadingBox();
			 		jQuery('.dvChangeOrderActivityTask').html(data);
			 	},
			 	error:function(XMLHttpRequest,textStatus,errorThrown)
			 	{
				 	hideLoadingBox();
				}
			});
			return false;
		}); 

		jQuery(".downTask").click(function() 
		{
			jQuery.ajax(
			{
				type:'POST',
			 	url:'${baseurl}/serviceActivityTask/downOrder',
			 	data: jQuery("#changeTaskOrderFrm").serialize(),
			 	success:function(data,textStatus)
			 	{
			 		hideLoadingBox();
			 		jQuery('.dvChangeOrderActivityTask').html(data);
			 	},
			 	error:function(XMLHttpRequest,textStatus,errorThrown)
			 	{
				 	hideLoadingBox();
				}
			});
			
			return false;
		});

	});
	
</script>

<g:form name="changeTaskOrderFrm">

	<div class="body">
	
		<div class="list">
			
			<button title="Up Service Activity Task" id="upTask" class="upTask"> Go Up </button>
							
			<button title="Down Service Activity Task" id="downTask" class="downTask"> Go Down </button>
			
			<g:hiddenField name="activityTasks" value="${activityTasks}"/>
		    <table>
		        
		        <tbody>
		        
					<g:set var="tmpServiceActivityTaskList" value="${activityTaskList?.sort{it?.sequenceOrder}}"/>        
			         
			        <g:each in="${tmpServiceActivityTaskList}" status="i" var="serviceActivityTaskInstance">
			            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
			            	
			            	<td> <g:radio name="check" value="${serviceActivityTaskInstance?.id}"/></td>
			            
			                <td>${serviceActivityTaskInstance?.task}</td>
			            
			                
			            </tr>          
			        </g:each>
		        </tbody>
		    </table>
		</div>
	</div>
</g:form>