
<%@ page import="com.valent.pricewell.User" %>
<%@ page import="com.valent.pricewell.RoleId" %>
<%@ page import="java.lang.String" %>
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
	
		function refreshUserGroupList(){
			refreshNavigation();
			jQuery.ajax({
				type: "GET",
				url: "/pricewell/user/listsetup?roleindex=${roleindex}",
				success: function(data){
					jQuery('#contents').html(data);
				}, 
				error:function(XMLHttpRequest,textStatus,errorThrown){}
			});
		}
		
		var ajaxList = new AjaxPricewellList("User", "User", "/pricewell", "setup", 600, 500, true, true, true, true);
		
		jQuery(document).ready(function()
		{
			ajaxList.init();

			jQuery(".userdelete").click(function(){
				var myid = this.id
				var btns = {};
				//var href = jQuery(this).attr('href');
                //alert(href);
				/*btns["Yes"] = function(){ 
				      jQuery.ajax({
						type: "POST",
						url: deleteActionUrl,
						data: {id: myid},
						success: function(data){
							refreshGeoGroupList();
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){}
					  });
				      jQuery(this).dialog("close");
				  };
				  btns["No"] = function(){ 
				      // Do nothing
				      jQuery(this).dialog("close");
				  };
				  jQuery(deleteMsg).dialog({
				    autoOpen: true,
				    title: deleteTitle,
				    modal:true,
				    buttons:btns
				  });*/
			});
		});
	</script>
    <body>
        <div class="body">
            
            <g:if test="${flash.message}">
            	<!--div class="message">${flash.message}</div-->
            </g:if>
            <div class="list childtab">
                <table cellpadding="0" cellspacing="0" border="0" class="display1" id="usersList">
                    <thead>
                        <tr>
                        	
                            <th> Username </th>
                        
                            <th> Full Name </th>
                        
                            <th> State </th>
                            
							<th> Other roles </th>
							<g:if test="${roleInstance.code == 'SALES PERSON' }">
								<th>Territory Assigned</th>
							</g:if>
							
							<g:if test="${roleInstance.code == 'SALES MANAGER' }">
								<th>Territories Assigned</th>
							</g:if>
							
							<g:if test="${roleInstance.code == 'GENERAL MANAGER' }">
								<th>GEO Assigned</th>
							</g:if>
							<th> </th>
							<th> </th>
                        	
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${users}" status="i" var="user">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><a id="${user.id}" href="#" class="showUser"> ${user.username?.encodeAsHTML()} </a></td>
                            
                            <td> ${user.profile?.fullName?.encodeAsHTML()} </td>
                            <td>
          						<g:if test="${user.enabled}">
            						<span class="icon icon_tick">&nbsp;</span><g:message code="nimble.label.enabled" />
          						</g:if>
          						<g:else>
            						<span class="icon icon_cross">&nbsp;</span><g:message code="nimble.label.disabled" />
          						</g:else>
        					</td>
        					
        					
        					<td>
        					
        						<g:each in="${user.roles}" var="role">
		                        	<g:if test="${role?.name != 'USER' && role?.name != usersByRoleList[roleindex]['role'] }">
		                        		<li>${role.name }</li>
		                        	</g:if>
		                    	</g:each>
							</td>
							<g:if test="${roleInstance.code == 'SALES PERSON' }">
								<td>${user?.territory?.name }</td>
							</g:if>
							<g:if test="${roleInstance.code == 'SALES MANAGER' }">
								<td>
									<g:each in="${user.territories}" var="mb">
			                        	<li>${mb}</li>
			                    	</g:each>
		                    	</td>
							</g:if>
							
							<g:if test="${roleInstance.code == 'GENERAL MANAGER' }">
								<td>${user?.geoGroup?.name }</td>
							</g:if>
							<td> <a id="${user.id}" href="#" class="editUser"> edit </a></td>
							<td> <a id="${user.id}" href="#" class="userdelete"> delete </a></td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
        </div>
		
    </body>
</html>
