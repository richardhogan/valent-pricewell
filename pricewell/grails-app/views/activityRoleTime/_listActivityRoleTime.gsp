<%@ page import="com.valent.pricewell.ServiceDeliverable" %>
<%@ page import="com.valent.pricewell.ServiceActivity" %>
<%@ page import="com.valent.pricewell.ActivityRoleTime" %>
<%@ page import="com.valent.pricewell.DeliveryRole" %>
<%
	def baseurl = request.siteUrl
%>

<g:setProvider library="prototype"/>

<script type="text/javascript">
	jQuery(document).ready(function()
	{
		jQuery( "#addRole" ).click(function() 
		{
			jQuery.ajax(
			{
				type:'POST',
				data:{id: ${serviceActivityInstance.id}}, 
				url:'${baseurl}/activityRoleTime/create',
				success:function(data,textStatus)
				{
						jQuery('#dvAddRole').html(data);
						hideUnhideNextBtn();
				},
				error:function(XMLHttpRequest,textStatus,errorThrown){}});
				return false;
			
		}); 

		jQuery( ".editBtn" ).click(function() 
		{
			var id = this.id.substring(8);

			jQuery("#dvActivityRoleTimeDialog").html("Loading Data, Please Wait.....");
			jQuery("#dvActivityRoleTimeDialog").dialog( "open" );
			jQuery.ajax(
			{
				type: "POST",
				url: "${baseurl}/activityRoleTime/edit",
				data: {id: id},
				success: function(data)
				{
					jQuery('#dvActivityRoleTimeDialog').html(data);					
				}, 
				error:function(XMLHttpRequest,textStatus,errorThrown){
					alert("Error while saving");
				}
			});
				return false;
			
		}); 

		jQuery( ".deleteBtn" ).click(function() 
		{
			var id = this.id.substring(10);
			jQuery.ajax(
			{
				type: "POST",
				url: "${baseurl}/activityRoleTime/delete",
				data: {id: id},
				success: function(data)
				{
					jQuery('#dvRoleList').html(data);
					hideUnhideNextBtn();
					
				}, 
				error:function(XMLHttpRequest,textStatus,errorThrown){
					alert("Error while saving");
				}
			});
				return false;
			
		}); 

		jQuery( "#dvActivityRoleTimeDialog" ).dialog(
		{
			height: 250,
			width: 400,
			title: "Edit Activity Role Time",
			modal: true,
			autoOpen: false,
			buttons: 
			{
				'Update': function() 
				{
					if(jQuery('#activityRoleTimeEditFrm').validate().form())
					{
						jQuery.ajax({type:'POST',
							 url:'${baseurl}/activityRoleTime/update',
							 data: jQuery("#activityRoleTimeEditFrm").serialize(),
							 success:function(data,textStatus)
							 {
								 jQuery('#dvRoleList').html(data);
								 hideUnhideNextBtn();
							 },
							 error:function(XMLHttpRequest,textStatus,errorThrown){}});
						 
						jQuery(this).dialog( "close" );
					}
					return false;
				}
			},
			close: function( event, ui ) {
					jQuery(this).html('');
				}
			
		});
	});
		
</script>

<div class="body">
	<div id="dvActivityRoleTimeDialog"> </div>
	<g:if test="${serviceActivityInstance?.rolesEstimatedTime?.size() > 0 }">
	    <hr />
	    <div>
	    	<input id="addRole" title="Add Role" type="button" value="Add Role" class="button"/>
	    </div>
	    
	    <div id="dvAddRole"></div>
	    
	    <table style="border-style: solid;">
	    	<thead>
				<tr>
					<th>Delivery Role</th>
					
					<th>Est Hrs (Flat)</th>
					
					<th>Extra Hrs per Unit</th>
							
					<th></th>
					
					<th></th>					
				</tr>
			</thead>
			<tbody>
				
				<g:each in="${serviceActivityInstance.rolesEstimatedTime}" var="r">
					<tr>
						<td>${r.role?.name}</td>
		          		<td>${r.estimatedTimeInHoursFlat}</td>
		          		<td>${r.estimatedTimeInHoursPerBaseUnits}</td>
		          		<td><input id="editBtn-${r.id}" title="Edit" type="button" value="Edit" class="button editBtn"/></td>
		          		<td><input id="deleteBtn-${r.id}" title="Delete" type="button" value="Delete" class="button deleteBtn"/></td>
					</tr>
				</g:each>
			</tbody>
			
		</table>
		
	    
	</g:if>
	<g:else>
		<%
			def roleList = []
			for(DeliveryRole role : DeliveryRole.list())
			{
				if(!serviceActivityInstance?.rolesRequired?.contains(role))
				{
					roleList.add(role)
				}
			}
		 %>
		<g:render template="/activityRoleTime/create" model="['serviceActivityId': serviceActivityInstance?.id, 'roleList': roleList, 'serviceActivityInstance': serviceActivityInstance]"/>
	</g:else>
</div>