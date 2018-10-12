<%@ page import="com.valent.pricewell.ServiceDeliverable" %>
<%@ page import="com.valent.pricewell.ServiceActivity" %>
<%
	def baseurl = request.siteUrl
%>
<!--  	<span style="font-size: 100%"> <b> Activities of ${serviceDeliverableInstance} </b> </span>-->
	<g:setProvider library="prototype"/>
	<script>
		jQuery(document).ready(function()
		{
			jQuery(".btnEditActivity").click(function()
			{
				var id = this.id.substring(16);
				jQuery.ajax(
				{
					type: "POST",
					url: "${baseurl}/serviceActivity/editFromDeliverable",
					data: {id: id},
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

			jQuery(".btnDeleteActivity").click(function()
			{
				var id = this.id.substring(18);
				jConfirm('Do you want to delete this activity?', 'Please Confirm', function(r)
   				{
				    if(r == true)
    				{
				    	showLoadingBox();
				    	jQuery.ajax(
						{
							type: "POST",
							url: "${baseurl}/serviceActivity/deleteFromDeliverable",
							data: {id: id},
							success: function(data)
							{
								hideLoadingBox();
								jQuery('#delActivity').html(data);
								hideUnhideNextBtn();
								askForNew();
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){
								alert("Error while saving");
							}
						});
    				}
				});
					
				
				return false;
			});
			
    		jQuery(".btnServiceActivityTasks").click(function()
			{
				var id = this.id.substring(24);

				showLoadingBox();
				jQuery.ajax(
				{
					type: "POST",
					url: "${baseurl}/serviceActivity/getActivityTaskList",
					data: {id: id},
					success: function(data)
					{
						hideLoadingBox();
						jQuery('#dvServiceActivityTaskList-'+id).html(data);
						
						
						
					}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){
						alert("Error while saving");
					}
				});
				
    			//jQuery("#dvServiceActivityTaskList").show();
			}); 
					
		});

		function newServiceActivity()
		{
			jQuery.ajax({
				type: "POST",
				url: "${baseurl}/serviceActivity/newActivityFromDeliverable",
				data: {'id': ${serviceDeliverableInstance.id}},
				success: function(data){jQuery("#delActivity").html(data);}, 
				error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
			});
			
			return false;
		}

		function changeServiceActivityOrder()
		{
			jQuery.ajax({
				type: "POST",
				url: "${baseurl}/serviceActivity/changeOrders",
				data: {'id': ${serviceDeliverableInstance.id}},
				success: function(data){jQuery("#delActivity").html(data);}, 
				error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
			});
			
			return false;
		}
	</script>
	
	<g:if test="${session['designPermit']}">
				
		<div class="nav">	  
        	<span>
			
				<g:if test="${session['checkResponsiblity'] }">
					<!--<g:remoteLink class="buttons.button button" controller="serviceActivity" 
			   			action="newActivityFromDeliverable" title="Create New Activity"
			   				id="${serviceDeliverableInstance.id}"
			   				update="[success:'delActivity',failure:'delActivity']">
			   				New Activity</g:remoteLink>-->
			   				
			   		<a id="idNewServiceActivity" onclick="newServiceActivity();" class="buttons.button button" title="New Activity">New Activity</a>
   				</g:if>
   				
   				<g:if test="${activitiesList.size() > 1 }">
   					<!--<g:remoteLink class="buttons.button button" id="${serviceDeliverableInstance.id}" 
						action="changeOrders" controller="serviceActivity" title="Change Orders Of Activity"
							update="delActivity">Change Orders</g:remoteLink>-->
							
					<a id="idChangeServiceActivityOrder" onclick="changeServiceActivityOrder();" class="buttons.button button" title="Change Orders Of Activity">Change Orders</a>
   				</g:if>
   				
			 </span>
					
		</div>
	</g:if>
	
	<g:if test="${flash.message}">
   	
   		
	</g:if>
	
	<div class="body">
	
		<div class="list">
		    <table>
		        <thead>
		            <tr>
		                <th>Order</th>
		
		                <th>Category</th>
		
		                <th>Name</th>
		
		                
		                <th>Est Hrs(Flat)</th>
				
				 		<th>Extra Hrs(per Unit)</th>
	
		                <th>Roles Required</th>
		
		                <th>Result</th>
		                
		                <th> </th>
		                
		                <th> </th>
		
		            </tr>
		        </thead>
		        <tbody>
			        <g:each in="${activitiesList}" status="i" var="serviceActivityInstance">
			            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
			                <td>${fieldValue(bean: serviceActivityInstance, field: "sequenceOrder")}</td>
			                <td>${fieldValue(bean: serviceActivityInstance, field: "category")}</td>
			                <td> ${fieldValue(bean: serviceActivityInstance, field: "name")}
			                    <!--div>  
			                      <g:remoteLink action="show" controller="serviceActivity" id="${serviceActivityInstance.id}" update="[success:'mainActivitiesTab',failure:'mainActivitiesTab']">${fieldValue(bean: serviceActivityInstance, field: "name")}</g:remoteLink>
			                    </div-->
			                    <!--div>
			                       ${fieldValue(bean: serviceActivityInstance, field: "description")}
			                    </div-->
			                    			
			                </td>
					 
					 		<td>${fieldValue(bean: serviceActivityInstance, field: "estimatedTimeInHoursFlat")}</td>
		
			                <td>${fieldValue(bean: serviceActivityInstance, field: "estimatedTimeInHoursPerBaseUnits")}</td>
			               
			                <td>
			                     <ul>
			                     	<g:if test="${serviceActivityInstance.rolesEstimatedTime}">
			                     		<table>
			                     			
			                     			<tr>
			                     				<th>Role</th><th>Est Hrs (Flat)</th><th>Extra Hrs (Per Base Units)</th>
			                     			</tr>
			                     			
				                          <g:each in="${serviceActivityInstance.rolesEstimatedTime}" var="r">
				                            <!--li> Role: ${r.role?.name}</li>
				                          	<li> Est Hrs (Flat): ${r.estimatedTimeInHoursFlat}</li>
				                          	<li> Extra Hrs (Per Base Units): ${r.estimatedTimeInHoursPerBaseUnits}</li-->
				                          	<tr>
				                          		<td>${r.role?.name}</td>
				                          		<td>${r.estimatedTimeInHoursFlat}</td>
				                          		<td>${r.estimatedTimeInHoursPerBaseUnits}</td>
				                          	</tr>
				                          </g:each>
				                        </table>
			                        </g:if>  
			                     </ul>
			                </td>
			                
			                <td>${fieldValue(bean: serviceActivityInstance, field: "results")}</td>
			               
			                <td>
			             		<g:if test="${session['designPermit'] && session['checkResponsiblity']}">
			             			<button id="btnEditActivity-${serviceActivityInstance.id}" class="btnEditActivity" title="Edit Activity">Edit</button>
				                  <!--<g:remoteLink class="buttons.button.edit button" action="editFromDeliverable" title="Edit Activity" controller="serviceActivity" id="${serviceActivityInstance.id}" update="[success:'delActivity',failure:'delActivity']">Edit</g:remoteLink>-->
				                </g:if>
				             </td>
				             <td>
				             	<g:if test="${session['designPermit'] && session['checkResponsiblity']}">
				             		<button id="btnDeleteActivity-${serviceActivityInstance.id}" class="btnDeleteActivity" title="Delete Activity">Delete</button>
				                  <!--<g:remoteLink class="buttons.button.delete button" action="deleteFromDeliverable" title="Delete Activity" controller="serviceActivity" id="${serviceActivityInstance.id}" update="[success:'delActivity',failure:'delActivity']" onComplete="hideUnhideNextBtn();">Delete</g:remoteLink>-->
			                	</g:if>
			                </td>
			                
			            </tr>
			            
			            <g:if test="${serviceActivityInstance?.activityTasks?.size() > 0 }">
			            	<tr  class="${(i % 2) == 0 ? 'odd' : 'even'}">
			            		<td>
			            			<button id="btnServiceActivityTasks-${serviceActivityInstance.id}" class="btnServiceActivityTasks" title="Activity Tasks">Tasks</button>
			            		</td>
			            		
			            		<td id="dvServiceActivityTaskList-${serviceActivityInstance?.id}" colspan="7">
			            			
			            		</td>
			            		<td></td>
			            	</tr>
			            	<!-- <tr id="dvServiceActivityTaskList-${serviceActivityInstance?.id}" class="${(i % 2) == 0 ? 'odd' : 'even'}"></tr> -->
			            	
	                   	</g:if>
	                    	
			        </g:each>
		        </tbody>
		    </table>
		</div>
		
		<div id="dvServiceActivityTaskList" class="dvServiceActivityTaskList">
		
		</div>
	</div>
