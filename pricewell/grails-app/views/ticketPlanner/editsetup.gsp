<%@ page import="com.valent.pricewell.TicketPlanner" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <g:set var="entityName" value="${message(code: 'ticketPlanner.label', default: 'Ticket Planner')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
        
        <style>
			.msg {
				color: red;
			}
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
		</style>
		<script>

			jQuery(document).ready(function()
			{		 
			    jQuery("#updateTicketPlannerSetup").click(function()
			    {
			    	if(jQuery("#ticketPlannerUpdate").validate().form())
					{
						jQuery.ajax(
						{
							type: "POST",
							url: "${baseurl}/ticketPlanner/update",
							data:jQuery("#ticketPlannerUpdate").serialize(),
							success: function(data)
							{
								if(data == "success"){
									jQuery( xdialogDiv ).dialog( "close" );
		        					jQuery.ajax({
		        						type: "POST",
		        						url: "${baseurl}/ticketPlanner/list",
		        						data: {id:this.id, source: "firstsetup", portfolioId: ${portfolioInstance.id}},
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
									jQuery("#resultDialog").html('Loading .....');
									jQuery("#resultDialog").dialog( "open" ); 
									jQuery(".resultDialog").dialog( "option", "title", "Failure" );
									jQuery("#resultDialog").html("Failed to create Ticket Planner."); 
									jQuery( ".resultDialog" ).dialog("open");
								}		
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){
								alert("Error while saving ");
								hideLoadingBox();
							}
						});
						return false;
					}
				});
				 
			    jQuery("#cancelTicketPlannerSetup").click(function()
			    {
				    jQuery( xdialogDiv ).dialog( "close" );
			    	jQuery.ajax({
						type: "POST",
						url: "${baseurl}/ticketPlanner/list",
						data: {id: this.id, source: "firstsetup", portfolioId: ${portfolioInstance.id}},
						success: function(data){
							hideLoadingBox();
				          	jQuery('#contents').html('').html(data);
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){}
					});			
			    });
			});
			 function onCancel()
			 {
				 window.location.href = '${baseurl}/ticketPlanner';
				 return false;
		     }
			 
  		</script>
    </head>
    <body>
     <div class="body">
	     <g:form name="ticketPlannerUpdate" id="ticketPlannerUpdate">
	     <g:hiddenField name="id" value="${ticketPlannerInstance?.id}" />
	     <g:hiddenField name="portfolioId" value="${portfolioInstance.id}"/>
	         <div class="dialog">
	             <table>
	                 <tbody>
	                     <tr class="prop">
                              <td valign="top" class="name">
                                <label for="name"><g:message code="ticketPlanner.taskName.label" default="Task Name" /></label>
                              	<em>*</em>
                              </td>
                              <td valign="top" class="value ${hasErrors(bean: ticketPlannerInstance, field: 'taskName', 'errors')}">
                                  <g:textField name="taskName" maxlength="25" class="required" value="${ticketPlannerInstance?.taskName}" />
                                  <br/><div id="nameMsg" class="msg"></div>
                              </td>
                          </tr>
                          <tr class="prop">
	                         <td valign="top" class="name">
	                             <label for="name"><g:message code="ticketPlanner.taskDesc.label" default="Task Description" /></label>
	                         	<em>*</em>
	                         </td>
	                         <td>
	                         	<g:textArea name="taskDesc" value="${ticketPlannerInstance?.taskDesc}" class="required" maxlength="255" rows="5" cols="80"  />
	                         </td>
	                    	 </tr>
	                 </tbody>
	             </table>
	         </div>
	         <div class="buttons">
	            	<span class="button"><button type="button" id="updateTicketPlannerSetup" title="Update Task"> Update </button></span>
	            	<span class="button"><button type="button" id="cancelTicketPlannerSetup" title="Cancel"> Cancel </button></span>
	         </div>
	     </g:form>
        </div>
    </body>
</html>
