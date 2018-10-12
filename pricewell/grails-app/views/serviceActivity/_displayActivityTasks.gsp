<%@ page import="com.valent.pricewell.ServiceActivity" %>
<%@ page import="com.valent.pricewell.ServiceActivityTask" %>
<%
	def baseurl = request.siteUrl
%>
<% 
	List<String> strList = new ArrayList<String>();

	for(ServiceActivityTask saTask : serviceActivityInstance?.activityTasks)
	{
		strList.add(saTask?.id);
	}
%>



    	<style type="text/css">
			.submit { margin-left: 12em; }
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
			
			
		</style>
		
		<g:setProvider library="prototype"/>
		<script>

		
			var activityTasks = [<% for (int i = 0; i < strList.size(); i++) { %>"<%= strList.get(i) %>"<%= i + 1 < strList.size() ? ",":"" %><% } %>];
	
			var sequenceOrder = ${serviceActivityInstance?.activityTasks?.size() + 1};

			jQuery(document).ready(function()
			{
				
				jQuery( ".dvAddActivityTask" ).dialog(
			 	{
					close: function( event, ui ) {
						if(jQuery(this).data('taskId') != "" && jQuery(this).data('taskId') != null)
						{
							addTaskToList(jQuery(this).data('taskId'));
							jQuery(this).data('taskId', "");
						}
						//myFunction();
						jQuery(this).html('');
						jQuery(this).empty();
					}
					
				});

				jQuery( ".dvEditActivityTask" ).dialog(
			 	{
					close: function( event, ui ) {
						jQuery(this).html('');
						jQuery(this).empty();
						updateActivityTaskList();
					}
					
				});

				jQuery( ".dvChangeOrderActivityTask" ).dialog(
			 	{
					close: function( event, ui ) {
						jQuery(this).html('');
						jQuery(this).empty();
						updateActivityTaskList();
					}
					
				});

				jQuery( ".dvDeleteActivityTask" ).dialog(
			 	{
					close: function( event, ui ) {

						if(jQuery(this).data('taskId') != "" && jQuery(this).data('taskId') != null)
						{
							deleteTaskToList(jQuery(this).data('taskId'));
							jQuery(this).data('taskId', "");
						}
						//jQuery(this).html('');
					}
					
				});

				jQuery(".changeTaskOrder").live( "click", function() 
				{
					jQuery( ".dvChangeOrderActivityTask" ).dialog( "open" );
					showLoadingBox();
					jQuery.ajax(
					{
						type:'POST',
					 	url:'${baseurl}/serviceActivityTask/changeOrders',
					 	data: {activityTasks: JSON.stringify(activityTasks)},
					 	success:function(data,textStatus)
					 	{
					 		hideLoadingBox();
					 		jQuery('.dvChangeOrderActivityTask').html(data);	
							
					 	},
					 	error:function(XMLHttpRequest,textStatus,errorThrown)
					 	{hideLoadingBox();}
					});
						
					return false;
				}); 

				jQuery(".mybtn").click(function()
				{
					alert(activityTasks);
					return false;
				});
		
			});	  	  
				
			function addSequenceOrderToThisTask(id, sequenceOrder)
			{
				showLoadingBox();
				jQuery.ajax({
					type: "POST",
					url: "${baseurl}/serviceActivityTask/updateSequenceOrder",
					data: {id: id, sequenceOrder: sequenceOrder},
					success: function(data)
					{
						hideLoadingBox();
					}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
				});
				
				return false;
			}
			
			function addTaskToList(id)
			{
				activityTasks.push(new Number(id));
				addSequenceOrderToThisTask(id, sequenceOrder);
				sequenceOrder++;
				updateActivityTaskList();
			}

			function deleteTaskToList(id)
			{
				//alert(activityTasks);
				activityTasks.splice(activityTasks.indexOf(id), 1);
				//alert(activityTasks);
				updateActivityTaskList();
			}

			function updateActivityTaskList()
			{
				showLoadingBox();
				jQuery.ajax({
					type: "POST",
					url: "${baseurl}/serviceActivityTask/listServiceActivityTasks",
					data: {taskList: JSON.stringify(activityTasks), activityId: '${serviceActivityInstance?.id}'},
					success: function(data)
					{
						jQuery("#dvServiceActivityTaskList").html(data);
						hideLoadingBox();
					}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
				});
				
				return false;
			}

			function thisFn()
			{
				alert(1);
			}
  		</script>


<div class="body">
    
    <br/>
    <div id="dvServiceActivityTaskList">
		<g:render template="/serviceActivityTask/activityTaskList" model="['serviceActivityTaskList':serviceActivityInstance?.activityTasks, 'activityId': serviceActivityInstance?.id]"/>
    </div> 
        
    
     <!--<g:render template='/serviceActivity/activityRoleTime' model="['activityRoleTimeInstance':null,'i':'_clone','hidden':true]"/>-->

</div>
   
