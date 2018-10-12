<script>
			 
	jQuery(document).ready(function()
	{
		jQuery( "#addMember" )
					.click(function() 
					{
						jQuery( "#addMemberIntoRole" ).dialog( "open" );
						return false;
					});
					
		jQuery( "#addMemberIntoRole" ).dialog(
	 	{
			modal: true,
			height: 300,
			width: 350,
			autoOpen: false,
			buttons: 
			{
				"Assign": function() 
				{
					var dataString = 'id=' + jQuery( "#roleID" ).val() + '&userID=' + jQuery( "#userID" ).val();
					if(jQuery( "#territoryID" ).val())//here changes id of manager
					{
						//dataString = dataString + '&salesManagerId='+jQuery( "#salesManagerId" ).val();
						
						dataString = dataString + '&territoryID='+jQuery( "#territoryID" ).val();
					}
					if(jQuery( "#territories" ).val())//here changes id of president
					{
						//dataString = dataString + '&salesPresidentId='+jQuery( "#salesPresidentId" ).val();
						
						dataString = dataString + '&territories='+jQuery( "#territories" ).val();
					}
					if(jQuery( "#geoGroupId" ).val())//for general manager role
					{
						dataString = dataString + '&geoGroupId='+jQuery( "#geoGroupId" ).val();
					}
					jQuery.ajax({
						type: "POST",
						url: nimble.endpoints.member.add,
						data: dataString,
						success: function(res) {
						  nimble.growl("success", res);
						  nimble.listMembers(jQuery( "#roleID" ).val());
						  nimble.searchMembers(jQuery( "#roleID" ).val());
						},
						error: function (xhr) {
						  nimble.growl("error", xhr.responseText);
						}
					  });
					jQuery( "#addMemberIntoRole" ).dialog( "close" );
					//alert(dataString);
					return false;
				},
				Cancel: function() 
				{
					jQuery( "#addMemberIntoRole" ).dialog( "close" );
					return false;
				}
			}
		});
	});
</script>
  		
<div id="addMemberIntoRole" title="Add Member Into Role">
	<form name="addMemberForm">
		<g:hiddenField name="roleID"  value="${parent.id}" />
		<g:if test="${parent.name=='SALES MANAGER'}">
			<div>To Assign Sales Manager Role</div>
			<table>
				<!--<tr>
					<th>Select Sales President</th>
				</tr>
				<tr>
					<td> <g:select name="salesPresidentId" from="${salesPresidentList}" value="" optionKey="id"/></td>
				</tr>-->
				
				<tr>
					<th>Select Member To Add</th>
				</tr>
				<tr>
					<td> <g:select name="userID" from="${users}" value="" optionKey="id"/></td>
				</tr>
				
				<tr>
					<th>Select Multiple Territories</th>
				</tr>
				<tr>
					<td> <g:select name="territories" from="${com.valent.pricewell.Geo.list()}" value="" optionKey="id" multiple="multiple"/></td>
				</tr>
			</table>
		</g:if>
		<g:elseif test="${parent.name=='SALES PERSON'}">
			<div>To Assign Sales Person Role</div>
			<table>
				<!--<tr>
					<th>Select Sales Manager</th>
				</tr>
				<tr>
					<td> <g:select name="salesManagerId" from="${salesManagerList}" value="" optionKey="id"/></td>
				</tr>-->
				
				<tr>
					<th>Select Member To Add</th>
				</tr>
				<tr>
					<td> <g:select name="userID" from="${users}" value="" optionKey="id"/></td>
				</tr>
				
				<tr>
					<th>Select Territory</th>
				</tr>
				<tr>
					<td> <g:select name="territoryID" from="${com.valent.pricewell.Geo.list()}" value="" optionKey="id" noSelection="['': 'Select any one']"/></td>
				</tr>
			</table>
		</g:elseif>
		
		<g:elseif test="${parent.name=='GENERAL MANAGER'}">
			<div>To Assign General Manager Role</div>
			<table>
				<tr>
					<th>Select Member To Add</th>
				</tr>
				<tr>
					<td> <g:select name="userID" from="${users}" value="" optionKey="id"/></td>
				</tr>
				
				<tr>
					<th>Select Geo </th>
          	  	</tr>
          	  	<tr>
	          		<td><g:select name="geoGroupId" from="${com.valent.pricewell.GeoGroup.list()}" optionKey="id" value=""  class="required" noSelection="['': 'Select any one']"/></td>
		        </tr>
			</table>
		</g:elseif>
		
		<g:else>
			<table>
				<tr>
					<th>Select Member To Add</th>
				</tr>
				<tr>
					<td> <g:select name="userID" from="${users}" value="" optionKey="id"/></td>
				</tr>
			</table>
		</g:else>
	</form>
</div>



<g:if test="${users != null && users.size() > 0}">
  
  <button id="addMember" class="button icon icon_group_add">Add Member</button>
  
  <table class="details">
    <thead>
    <tr>
      <th class="first"><g:message code="nimble.label.username" /></th>
      <th class=""><g:message code="nimble.label.fullname" /></th>
      <th class="last"></th>
    </tr>
    </thead>
    <tbody>
    <g:each in="${users}" status="i" var="user">
      <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
        <g:if test="${user.username.length() > 30}">
        	<td>${user.username?.substring(0,30).encodeAsHTML()}...</td>
		</g:if>
		<g:else>
			<td>${user.username?.encodeAsHTML()}</td>
		</g:else>
        <td>${user?.profile?.fullName.encodeAsHTML()}</td>
        <td>
          <g:link controller="user" action="show" id="${user.id.encodeAsHTML()}" class="button icon icon_user_go"><g:message code="nimble.link.view" /></g:link>
          <!--a onClick="nimble.addMember('${parent.id.encodeAsHTML()}', '${user.id.encodeAsHTML()}', '${parent.name.encodeAsHTML()}');" class="button icon icon_add"><g:message code="nimble.link.grant" /></a-->
        </td>
      </tr>
    </g:each>
    </tbody>
  </table>
</g:if>
<g:else>
  <div class="info">
  <strong><g:message code="nimble.template.members.add.user.noresults" /></strong>
  </div>
</g:else>