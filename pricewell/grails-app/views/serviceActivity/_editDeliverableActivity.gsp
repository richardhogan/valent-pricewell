<%
	def baseurl = request.siteUrl
%>

<g:setProvider library="prototype"/>
<script type="text/javascript">
	jQuery(document).ready(function()
	{
		jQuery( "#doneBtn" ).click(function() 
		{
			jQuery.ajax(
			{
				type: "POST",
				url: "${baseurl}/serviceActivity/isRoleDefined",
				data: {id: ${serviceActivityInstance?.id}},
				success: function(data)
				{
					if(data == 'success')
					{
						jQuery.ajax(
						{
							type: "POST",
							url: "${baseurl}/serviceActivity/listDeliverableActivities",
							data: {id: ${serviceActivityInstance?.serviceDeliverable?.id}},
							success: function(data)
							{
								jQuery('#delActivity').html(data);
								hideUnhideNextBtn();
								askForNew();
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){
								alert("Error while saving");
							}
						});
					}
					else
					{
						jAlert('Please add role first...', 'Alert');
					}
				}, 
				error:function(XMLHttpRequest,textStatus,errorThrown){
					alert("Error while saving");
				}
			});
			return false;
			
		}); 
	});

	function serviceActivityList()
	{
		jQuery.ajax({
			type: "POST",
			url: "${baseurl}/serviceActivity/listDeliverableActivities",
			data: {'id': ${serviceActivityInstance?.serviceDeliverable?.id}},
			success: function(data){jQuery("#delActivity").html(data);}, 
			error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
		});
		
		return false;
	}

	function newServiceActivity()
	{
		jQuery.ajax({
			type: "POST",
			url: "${baseurl}/serviceActivity/newActivityFromDeliverable",
			data: {'id': ${serviceActivityInstance?.serviceDeliverable?.id}},
			success: function(data){jQuery("#delActivity").html(data);}, 
			error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
		});
		
		return false;
	}
</script>
<!--   <span style="font-size: 100%"> <b> Edit Activity of ${serviceActivityInstance.serviceDeliverable} </b> </span> -->
<div class="nav">

	<span><a id="idServiceActivityList" onclick="serviceActivityList();" class="buttons.button button" title="List Of Activity">List Activities</a></span>
			
	<span><a id="idNewServiceActivity" onclick="newServiceActivity();" class="buttons.button button" title="New Activity">New Activity</a></span>
			
    <!-- <span><g:remoteLink class="buttons.button button" title="List Of Activity" id="${serviceActivityInstance?.serviceDeliverable?.id}" action="listDeliverableActivities" controller="serviceActivity" update="[success:'delActivity',failure:'delActivity']">List Activities</g:remoteLink></span>
    <span><g:remoteLink class="buttons.button button" title="Create New Activity" id="${serviceActivityInstance?.serviceDeliverable?.id}" action="newActivityFromDeliverable" controller="serviceActivity" update="[success:'delActivity',failure:'delActivity']">New Activity</g:remoteLink></span>-->
</div>
<div class="body">
      
    <div id="dvactivity">
    	<g:render template="showInfo" model="['serviceActivityInstance': serviceActivityInstance, 'edit': edit]"/>
	</div>
  	
  	<div id="dvRoleList">
    	<g:render template="../activityRoleTime/listActivityRoleTime" model="['serviceActivityInstance': serviceActivityInstance]"/>
	</div>	   
	
	<hr />
	
	<div>
    	<input id="doneBtn" title="Done To Edit" type="button" value="Done" class="button"/>
    </div>
</div>
   
