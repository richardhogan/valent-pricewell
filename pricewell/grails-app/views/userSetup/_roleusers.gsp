
<%@ page import="com.valent.pricewell.User" %>
<%@ page import="com.valent.pricewell.RoleId" %>
<%@ page import="java.lang.String" %>
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
	
		function refreshUserGroupList(){
			refreshNavigation();
			jQuery.ajax({
				type: "POST",
				url: "${baseurl}/userSetup/listsetup?roleindex=${roleindex}",
				success: function(data){
					jQuery('#contents').html(data);
				}, 
				error:function(XMLHttpRequest,textStatus,errorThrown){}
			});
		}
		
		var ajaxList = new AjaxPricewellList("User", "UserSetup", "${baseurl}", "setup", 600, 500, true, true, true, true);
		
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

			jQuery(".userShow").click(function(){
				jQuery("#userDialog").html('Loading, please wait.....');
				jQuery("#userDialog").dialog( "open" );
				jQuery("#userDialog").dialog( "option", "title", "Show ${roleInstance.name}" );
				jQuery("#userDialog").dialog( "option", "zIndex", 1500 );
				jQuery("#userDialog").dialog( "option", "width", 'auto');
				jQuery("#userDialog").dialog( "option", "maxHeight", 600);
				jQuery.ajax({
					type: "POST",
					url: "${baseurl}/userSetup/showsetup",
					data: {id: this.id, roleId: ${roleInstance?.id}},
					success: function(data){
						jQuery("#userDialog").html(data);
					}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){}
				});
			});

			jQuery(".userEdit").click(function(){
				jQuery("#contents").html('Loading, please wait.....');
				//jQuery("#userDialog").dialog( "open" );
				//jQuery("#userDialog").dialog( "option", "title", "Edit ${roleInstance.name}" );
				/*jQuery("#userDialog").dialog( "option", "zIndex", 1500 );
				jQuery("#userDialog").dialog( "option", "width", 600);
				jQuery("#userDialog").dialog( "option", "maxHeight", 500);*/
				//jQuery( xdialogDiv ).dialog('option', 'position', 'center');
				jQuery.ajax({
					type: "POST",
					url: "${baseurl}/userSetup/editsetup",
					data: {id: this.id, source: "${source}", roleId: "${roleInstance?.id}"},
					success: function(data){
						jQuery("#contents").html(data);
					}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){}
				});
			});
			
			
		});
	</script>
    <body>
        <div class="body">
            
            <g:if test="${flash.message}">
            	<!--div class="message">${flash.message}</div-->
            </g:if>
            
            <div class="list childtab" style='width: 95%;'>
                <table cellpadding="0" cellspacing="0" border="0" class="display1" id="usersList">
                    <thead>
                        <tr>
                        	
                            <th> Username </th>
                        
                            <th> Full Name </th>
                        
                            <th> State </th>
                            
							<th> Other roles </th>
							
							<g:if test="${roleInstance.name == 'GENERAL MANAGER'}">
								<th>GEO</th>
								<th>Primary Territory</th>
							</g:if>
							<g:elseif test="${roleInstance.name == 'SALES MANAGER'}">
								<th>Primary Territory</th>
								<th>Secondary Territories</th>
							</g:elseif>
							<g:elseif test="${roleInstance.name == 'SALES PRESIDENT' || roleInstance.name == 'SALES PERSON' }">
								<th>Primary Territory</th>
							</g:elseif>
							
							<th> </th>
                        	
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${users?.sort {it.username}}" status="i" var="user">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><a id="${user.id}" href="#1" class="userShow hyperlink" title="Detail"> ${user.username?.encodeAsHTML()} </a></td>
                            
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
		                        	<g:if test="${role?.name != 'USER' && role?.name != roleInstance.name }">
		                        		<li>${role.name }</li>
		                        	</g:if>
		                    	</g:each>
							</td>
							
							<g:if test="${roleInstance.name == 'GENERAL MANAGER'}">
								<td>${user?.geoGroup}</td>
								<td>${user?.primaryTerritory}</td>
							</g:if>
							<g:elseif test="${roleInstance.name == 'SALES MANAGER'}">
								<td>${user?.primaryTerritory}</td>
								<td>
									<g:each in="${user?.territories}" status="t" var="territory">
										<g:if test="${territory?.id != user?.primaryTerritory?.id}">
												${territory?.name}
					        				<g:if test="${t+1 != user?.territories?.size() }">
					        					,
					        				</g:if>
					        				<g:if test="${t%2 == 1}">
					        					<br/>
					        				</g:if>
										</g:if>			        					
			        				</g:each>
								</td>
							</g:elseif>
							<g:elseif test="${roleInstance.name == 'SALES PRESIDENT' || roleInstance.name == 'SALES PERSON' }">
								<td>${user?.primaryTerritory}</td>
							</g:elseif>
							
							<td> <a id="${user.id}" href="#" title="Edit User" class="userEdit hyperlink "> Edit </a></td>
							<!-- <td> <a id="${user.id}" href="#" class="userdelete"> delete </a></td>-->
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
        </div>
		
    </body>
</html>
