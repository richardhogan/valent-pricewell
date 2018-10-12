<%@ page import="com.valent.pricewell.ServiceDeliverable"%>

<%
	def baseurl = request.siteUrl
%>
<g:setProvider library="prototype"/>
<script>

	jQuery(document).ready(function()
	{
		jQuery(".btnDeleteDeliverable").click(function()
		{
			var id = this.id.substring(21);
			jConfirm('Do you want to delete this deliverable?', 'Please Confirm', function(r)
  				{
			    if(r == true)
   				{
			    	showLoadingBox();
			    	jQuery.ajax(
					{
						type: "POST",
						url: "${baseurl}/serviceDeliverable/deleteFromService",
						data: {id: id},
						success: function(data)
						{
							hideUnhideNextBtn();
							hideLoadingBox();
							jQuery('#mainCustomerDeliverablesTab').html(data);
							
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){
							alert("Error while saving");
						}
					});
   				}
			});
				
			
			return false;
		}); 

		jQuery(".btnEditDeliverable").click(function()
		{
			var id = this.id.substring(19);
			showLoadingBox();
	    	jQuery.ajax(
			{
				type: "POST",
				url: "${baseurl}/serviceDeliverable/editFromService",
				data: {id: id},
				success: function(data)
				{
					hideLoadingBox();
					jQuery('#mainCustomerDeliverablesTab').html(data);
					
				}, 
				error:function(XMLHttpRequest,textStatus,errorThrown){
					alert("Error while saving");
				}
			});
   				
				
			
			return false;
		}); 
	});

	function createNewCustoerDeliverable()
	{
		jQuery.ajax({
			type: "POST",
			url: "${baseurl}/serviceDeliverable/createFromService",
			data: {'serviceProfileId': ${serviceProfileInstance?.id} },
			success: function(data){jQuery("#mainCustomerDeliverablesTab").html(data);}, 
			error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
		});
		
		return false;
	}

	function changeDeliverableOrder()
	{
		jQuery.ajax({
			type: "POST",
			url: "${baseurl}/serviceDeliverable/changeOrders",
			data: {'serviceProfileId': ${serviceProfileInstance?.id}},
			success: function(data){jQuery("#mainCustomerDeliverablesTab").html(data);}, 
			error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
		});
		
		return false;
	}

	function refreshDeliverableList()
	{
		jQuery.ajax({
			type: "POST",
			url: "${baseurl}/serviceDeliverable/listServiceDeliverables",
			data: {'serviceProfileId': ${serviceProfileInstance?.id}},
			success: function(data){jQuery("#mainCustomerDeliverablesTab").html(data);}, 
			error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
		});
		
		return false;
	}

	function newActivityFromDeliverable(id)
	{
		jQuery.ajax({
			type: "POST",
			url: "${baseurl}/serviceActivity/newActivityFromDeliverable",
			data: {'id': id},
			success: function(data){jQuery("#delActivity").html(data);}, 
			error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
		});
		
		return false;
	}

	function listSelectedDeliverableActivities(id)
	{
		jQuery.ajax({
			type: "POST",
			url: "${baseurl}/serviceActivity/listSelectedDeliverableActivities",
			data: {'selectCustomerDeliverableId': id},
			success: function(data){jQuery("#delActivity").html(data);}, 
			error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
		});
		
		return false;
	}
</script>


<g:if test="${session['designPermit']}">
	<div class="nav">
		<g:if test="${session['serviceUpdatePermit']}">
			<g:if test="${session['checkResponsiblity']}">
				<!-- <span> <g:remoteLink class="buttons.button button"
						controller="serviceDeliverable" action="createFromService"
						params="['serviceProfileId': serviceProfileInstance?.id ]" title="New Customer Deliverables"
						update="[success:'mainCustomerDeliverablesTab',failure:'mainCustomerDeliverablesTab']">
						 			New Customer Deliverable
						 </g:remoteLink> </span> -->
						 
				<span>
					<a id="idNewCustomerDeliverable" onclick="createNewCustoerDeliverable();" class="buttons.button button" title="New Customer Deliverable">New Customer Deliverable</a>
				</span>
			</g:if>
			 
			<g:if test="${serviceProfileInstance?.customerDeliverables?.size() > 1 }">
				<!-- <span> <g:remoteLink class="buttons.button button" controller="serviceDeliverable"
						action="changeOrders"
						params="['serviceProfileId': serviceProfileInstance?.id]" title="Change Orders Of Deliverables"
						update="[success:'mainCustomerDeliverablesTab',failure:'mainCustomerDeliverablesTab']">
						 			Change Orders
						 </g:remoteLink> </span> -->
						 
				<span>
					<a id="idChangeOrder" onclick="changeDeliverableOrder();" class="buttons.button button" title="Change Orders Of Deliverables">Change Orders</a>
				</span>
			</g:if>
			<span> 
				<!-- <g:remoteLink controller="serviceDeliverable" class="buttons.button button"
					params="['serviceProfileId': serviceProfileInstance?.id]"
					action="listServiceDeliverables" title="List Of Customer Deliverables"
					update="[success:'mainCustomerDeliverablesTab',failure:'mainCustomerDeliverablesTab']" >
			    			Refresh
		    		</g:remoteLink> -->
		    		
		    	<a id="idRefreshDeliverableList" onclick="refreshDeliverableList();" class="buttons.button button" title="List Of Customer Deliverables">Refresh</a>
		    </span>
    		
    		
		</g:if>

	</div>
</g:if>
<div class="body">
	<g:if test="${flash.message}">
		<!--div class="message">${flash.message}</div-->
	</g:if>
	<div class="list">
		<table>
			<thead>
				<tr>
					<th>Sequence Order</th>

					<th width="15%">Name</th>

					<th>Type</th>
					
					<th>Phase</th>

					<th width="50%">Description</th>
					
					<g:if test="${serviceProfileInstance?.stagingStatus?.sequenceOrder >= 20}">
							<th></th>
					</g:if>
					
					<g:if
						test="${session['serviceUpdatePermit'] && session['designPermit'] && session['checkResponsiblity']}">
						<th></th>
						<th></th>
					</g:if>
				</tr>
			</thead>
			<tbody>

				<g:set var="tmpDeliverablesList"
					value="${deliverablesList? deliverablesList: serviceProfileInstance?.listCustomerDeliverables()}" />

				<g:each in="${tmpDeliverablesList}" status="i"
					var="serviceDeliverableInstance">
					<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

						<td>
							${fieldValue(bean: serviceDeliverableInstance, field: "sequenceOrder")}
						</td>

						<td width="15%">
							${fieldValue(bean: serviceDeliverableInstance, field: "name")}
						</td>
						
						<td>
							${fieldValue(bean: serviceDeliverableInstance, field: "type")}
						</td>
						
						<td>
							${fieldValue(bean: serviceDeliverableInstance, field: "phase")}
						</td>

						<td width="50%">
							${serviceDeliverableInstance?.newDescription?.value}
						</td>

						<g:if test="${serviceProfileInstance?.stagingStatus?.sequenceOrder >= 20}">
							<td>
								<g:if test="${serviceDeliverableInstance?.serviceActivities}">
									<a id="idlistSelectedDeliverableActivities" onclick="listSelectedDeliverableActivities(${serviceDeliverableInstance?.id});" class="hyperlink" title="Show Activities">Show ${serviceDeliverableInstance?.serviceActivities?.size()} Activities</a>
								</g:if> 
								
								<g:elseif test="${session['checkResponsiblity'] }">
									<a id="idnewActivityFromDeliverable" onclick="newActivityFromDeliverable(${serviceDeliverableInstance?.id});" class="hyperlink" title="Create New Activity">Add Activity</a>
								</g:elseif>
							</td>
						</g:if>

						<g:if test="${session['serviceUpdatePermit'] && session['designPermit'] && session['checkResponsiblity']}">
							<td>
								<button id="btnEditDeliverable-${serviceDeliverableInstance.id}" class="btnEditDeliverable" title="Edit Deliverable">Edit</button>
							</td>

							<td>
								<button id="btnDeleteDeliverable-${serviceDeliverableInstance.id}" class="btnDeleteDeliverable" title="Delete Deliverable">Delete</button>
							</td>
						</g:if>
					</tr>

				</g:each>
			</tbody>
		</table>
	</div>
</div>
<div class="list" id="delActivity" style="border: 0.1em #CDCDCD solid;">
</div>
