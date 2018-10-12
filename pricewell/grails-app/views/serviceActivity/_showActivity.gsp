<%@ page import="com.valent.pricewell.ServiceDeliverable" %>
<%@ page import="com.valent.pricewell.ServiceActivity" %>
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
</script>

<div class="body">

	<div id="dvActivityInfo" class="dialog">
        <g:render template="/serviceActivity/showInfo" model="['serviceActivityInstance': serviceActivityInstance]"/>
    </div>
    
    <div id="dvRoleList">
    	<g:render template="/activityRoleTime/listActivityRoleTime" model="['serviceActivityInstance': serviceActivityInstance]"/>
	</div>
	
	<hr />
	
	<div>
    	<input id="doneBtn" title="Done To Add Role" type="button" value="Done" class="button"/>
    </div>
</div>