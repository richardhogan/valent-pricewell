<%@ page import="com.valent.pricewell.TicketPlanner" %>
<%
	def baseurl = request.siteUrl
%>
<html>
        <style>
			h1, button, #successDialogInfo
			{
				font-family:Georgia, Times, serif; font-size:15px; font-weight: bold;
			}
			button{
				cursor:pointer;
			}
		</style>
		<script>
			var xdialogDiv = "#ticketPlannerDialog";
			jQuery( xdialogDiv ).dialog(
				{
					maxHeight: 800,
					width: 800,
					modal: true,
					autoOpen: false,
					close: function( event, ui ) {
						jQuery(this).html('');
					}
				});
		
			jQuery(document).ready(function()
			 	{
				var deleteSetupMsg = "<div>Are you sure you want to delete Sub Task?</div>";
				jQuery('#createSubTask').click(function () 
					{
					jQuery( xdialogDiv ).html('Loading, please wait.....');
					jQuery( xdialogDiv ).dialog( "open" ); 
					jQuery( xdialogDiv ).dialog( "option", "zIndex", 1500 );
					jQuery( xdialogDiv ).dialog( "option", "title", "Create Sub Task" );
					jQuery( xdialogDiv ).dialog( "option", "width", 900); 
					jQuery( xdialogDiv ).dialog( "option", "maxHeight", 600);
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/ticketPlanner/create",
						data: {source: "firstsetup", portfolioId: ${portfolioInstance.id}, parentTask: ${parentTaskId.id}},
						success: function(data){
							jQuery(xdialogDiv).html(data);
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){}
					});
					return false;
				});
				jQuery('.editTaskSetup').click(function () 
					{
					jQuery( xdialogDiv ).html('Loading, please wait.....');
					jQuery( xdialogDiv ).dialog( "open" ); 
					jQuery( xdialogDiv ).dialog( "option", "zIndex", 1500 );
					jQuery( xdialogDiv ).dialog( "option", "title", "Edit Sub Task" );
					jQuery( xdialogDiv ).dialog( "option", "width", 900); 
					jQuery( xdialogDiv ).dialog( "option", "maxHeight", 600);
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/ticketPlanner/edit",
						data: {id: this.id, source: "firstsetup", portfolioId: ${portfolioInstance.id}, parentTask: ${parentTaskId.id}},
						success: function(data){
							jQuery(xdialogDiv).html(data);
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){}
					});
					return false;
					});
				jQuery("#listPortfolio").click(function()
						{
							showLoadingBox();
							jQuery.post( '${baseurl}/portfolio/listsetup' , 
							  	{source: "firstsetup"},
						      	function( data ) 
						      	{
								  	hideLoadingBox();
						          	jQuery('#contents').html('').html(data);
						      	});
							return false;
						});
				jQuery("#listTicketPlanner").click(function()
       				{
       					showLoadingBox();
       					jQuery.ajax({
       						type: "POST",
       						url: "${baseurl}/ticketPlanner/list",
       						data: {source: "firstsetup", portfolioId: ${portfolioInstance.id}, parentTaskId: ${parentTaskId.id}},
       						success: function(data){
       							hideLoadingBox();
       				          	jQuery('#contents').html('').html(data);
       						}, 
       						error:function(XMLHttpRequest,textStatus,errorThrown){}
       					});
       					return false;
       				});	
				jQuery(".deleteTaskSetup").click(function()
       				{
						var myid = this.id;
						var btns = {};
						btns["Yes"] = function()
						{ 
							jQuery.ajax(
							{
								type: "POST",
								url: "${baseurl}/ticketPlanner/deletesetup",
								data: {id: myid, source: 'setup'},
								success: function(data)
								{
									if(data == "success")
									{
										jQuery( xdialogDiv ).dialog( "close" );
			        					jQuery.ajax({
			        						type: "POST",
			        						url: "${baseurl}/ticketPlanner/list",
			        						data: {id:this.id, source: "firstsetup", portfolioId: ${portfolioInstance.id},parentTask: ${parentTaskId.id}},
			        						success: function(data){
			        							hideLoadingBox();
			        				          	jQuery('#contents').html('').html(data);
			        						}, 
			        						error:function(XMLHttpRequest,textStatus,errorThrown){}
			        					});
			        					return false;
									}
									else{
										jQuery( xdialogDiv ).dialog( "close" );
									}
								}, 
								error:function(XMLHttpRequest,textStatus,errorThrown){
									alert ("Error while Deleting")
									}
							});
						    jQuery(this).dialog("close");
						};
						btns["No"] = function(){ 
							jQuery(this).dialog("close");
						};
						jQuery.ajax(
							{
								type: "POST",
								url: "${baseurl}/ticketPlanner/getTaskName",
								data: {id: myid, source: 'setup'},
								success: function(data){
									jQuery(deleteSetupMsg).dialog({
									    autoOpen: true,
									    title: "Delete Sub Task : " + data,
									    modal:true,
									    buttons:btns
									});
								}, 
								error:function(XMLHttpRequest,textStatus,errorThrown){}
							});
       				});	
			 	});
		</script>
    
    <body>
    <div class="collapsibleContainerTitle ui-widget-header">
		<div>Ticket Planner (${ticketPlannerInstanceList.size()})&nbsp;&nbsp;
			<button id="listTicketPlanner" title="Go To Task List" > Go To Task List </button>&nbsp;&nbsp;
			<button id="listPortfolio" title="Go To Portfolio List" > Go To Portfolio </button>
		</div>
	</div><br>
    <table>
    <tr>
    	<td><b>Portfolio Name : </b></td><td>${portfolioInstance}</td>
    	<td><a id="createSubTask" class="createTask button" href="#" title="Add New Task">Add Sub Task</a></td>
   </tr>
    <tr>
    	<td style="text-align: right;"><b>Task Name : </b></td><td>${parentTaskId.taskName} </td>
    </tr>
    </table></hr>
        <div class="body">
	            <div class="list">
	                <table cellpadding="0" cellspacing="0" border="0" class="display1" id="ticketPlannersSetupList">
                    <thead>
                        <tr> 
                            <th>Sub Task Name</th>
                            <th>Description</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
	                   <g:each in="${ticketPlannerInstanceList}" status="i" var="ticketPlannerInstance">
	                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
	                            <td>${ticketPlannerInstance.taskName }</td>
	                            <td>${ticketPlannerInstance.taskDesc}</td>
		                        <td><a id="${ticketPlannerInstance.id}" href="#" class="editTaskSetup hyperlink"> Edit </a>&nbsp;&nbsp;/&nbsp;&nbsp;
									<a id="${ticketPlannerInstance.id}" href="#" class="deleteTaskSetup hyperlink"> Delete </a>
								</td>
	                        </tr>
	                    </g:each>
	                    <g:if test="${ticketPlannerInstanceList == null || ticketPlannerInstanceList.isEmpty()}">
	                    	<tr>
	                    		<td colspan="4">No Records Available.</td>
	                    	</tr>
	                    </g:if>
                    </tbody>
                </table>
            </div>
        </div>
        
        <div id="ticketPlannerDialog" title="">
			
		</div>
    </body>
</html>
