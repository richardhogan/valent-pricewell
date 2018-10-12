<%
	def baseurl = request.siteUrl
%>
<%@ page import="org.apache.shiro.SecurityUtils"%>
<html>
<head>
       
   
<style>
		h1, button, #successDialogInfo
		{
			font-family:Georgia, Times, serif; font-size:15px; font-weight: bold;
		}
		button, a{
			cursor:pointer;
		}
		
		.headingText {
			font-family:Georgia, Times, serif; font-size:15px;
		}
		.headingBold {
			 font-weight: bold;
		}
		.dataTables_wrapper {
			position: relative;
			min-height: 0px;
			clear: both;
			_height: 0px;
			zoom: 1; /* Feeling sorry for IE */
		}
		
		.dataTables_filter {
			width: 50%;
			float: right;
			text-align: left;
		}
		
		.childtab {
			margin-left: 20px;
			border:1px solid;
			border-width: thin;
			border-color: #C0C0C0;
			width: 700px;
		}
		
		.linkclass {	
		color: #1874CD;
	 	text-decoration:underline;
	 	hover-color: #fff;
	 	}
		
	</style>
	<script>
		var expandImage = "${baseurl}/images/expand.png";
		var collapseImage = "${baseurl}/images/collapse.png";

		function listUsers(index){
			jQuery.ajax({
				type: "POST",
				url: "${baseurl}/userSetup/listusersbyrole",
				data: {roleindex: index, source: "${source}"},
				success: function(data){
					jQuery('.childUsersTR').html(data);
				}, 
				error:function(XMLHttpRequest,textStatus,errorThrown){}
			});	
		}

		function refreshGeoGroupList(){
			refreshNavigation();
			jQuery.ajax({
				type: "POST",
				url: "${baseurl}/userSetup/listroles",
				data: {source: "${source}"},
				success: function(data){
					jQuery('#contents').html(data);
				}, 
				error:function(XMLHttpRequest,textStatus,errorThrown){}
			});
		}
		
		var xdialogDiv = "#userDialog";
		
		jQuery(document).ready(function()
		{	
			jQuery(this).dropdown('reload', null);
			
			jQuery(xdialogDiv).dialog({
	            autoOpen: false,
	            position: [400,200],
	            modal: true,
				close: function( event, ui ) {
					jQuery(this).html('');
				}
	        });
	        		
			jQuery('.setuproles').html('<img class="roleImg" src="' + expandImage + '"/>');
			jQuery('.setuproles').unbind("click").click(function (){
					var id = this.id.substring(5);

					var imageName = jQuery(this).find('.roleImg').attr('src')
					//Expand only one Tr, close others
					jQuery('.setuproles').find('.roleImg').attr('src',expandImage);
					jQuery('.childUsersTR').remove();
					
					if(imageName == expandImage){
						jQuery(this).closest( "tr" ).after("<tr class='childUsersTR' style='width: 95%;'><td colspan='2'><div class='childtab' style='width: 95%;' id='users-'" + id + "'> Loading ... </div></td></tr>");
						jQuery(this).find('.roleImg').attr('src',collapseImage);
						listUsers(id);
					} 
					
					return false;
				});

			jQuery('.addnewuser').click(function () {
					 var id = this.id.substring(11);
					  
					jQuery("#contents").html('Loading, please wait...');
					/*jQuery( xdialogDiv ).dialog( "open" );
					jQuery( xdialogDiv ).dialog( "option", "title", "Add New User" );
					jQuery( xdialogDiv ).dialog( "option", "zIndex", 1500 );
					jQuery( xdialogDiv ).dialog( "option", "width", 550);
					jQuery( xdialogDiv ).dialog( "option", "maxHeight", "auto");*/
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/userSetup/createsetup",
						data: {roleindex: id, source: "${source}"},
						success: function(data){
							jQuery("#contents").html(data);
							
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){}
					});
						
				});

			jQuery('.addexistinguser').click(function () {
				 var id = this.id.substring(16);

				 var dialogWidth = 500;
				 var dialogHeight = 800;
				 var createTitle = "Add Existing User"
				 var createActionUrl = "${baseurl}/userSetup/getExistingUsers?roleindex="+id; 
				jQuery(xdialogDiv).html('Loading .....');
				jQuery( xdialogDiv ).dialog( "open" );
				jQuery( xdialogDiv ).dialog( "option", "title", createTitle );
				jQuery( xdialogDiv ).dialog( "option", "zIndex", 1500 );
				jQuery( xdialogDiv ).dialog( "option", "width", dialogWidth);
				jQuery( xdialogDiv ).dialog( "option", "maxHeight", dialogHeight);
				jQuery.ajax({
					type: "POST",
					url: createActionUrl,
					success: function(data){
						jQuery(xdialogDiv).html(data);
						
					}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){}
				});
			});

			jQuery( ".resultDialog" ).dialog(
		 	{
				modal: true,
				autoOpen: false,
				resizable: false,
				close: function( event, ui ) {
					jQuery(this).html('');
				},
				buttons: 
				{
					OK: function() 
					{
						jQuery( ".resultDialog" ).dialog( "close" );
						refreshGeoGroupList();
						return false;
					}
				}
			});
							
			
			
		});
		
	</script>
 </head>
 <body> 
        <div class="body" >
            <h1>List of Users defined</h1>  <hr />
        	
            <div class="list">
                <table id="mainuserrole" class="headingText">
                    <tbody>
                    <g:each in="${usersByRoleList}" status="i" var="map">
                    	<g:if test="${isRoleDisplay[i] == true}">
	                        <tr>
	                        
	                            <td>
	                            	<a href="#" id="role-${i}" class="setuproles">  </a>  ${map['role']} &nbsp;
	                            
	                            	(${map['users'].size()} users defined) &nbsp;
                            	
	            					<a href="#" class="hyperlink" data-dropdown="#adduser-${i}">Add User <img src='${resource(dir: 'images', file: 'arrow-down.gif')}'/></a>                		 
	                            </td>
	                                                    
	                        </tr>
                        </g:if>
                        
                    </g:each>
                    <g:if test="${SecurityUtils.subject.hasRole('SYSTEM ADMINISTRATOR')}"> 
						<tr>
							<td>
								<a class="hyperlink" href="${baseurl}/administration/users/list"> Advanced Administration </a>
							</td>
						</tr>
					</g:if>
                    </tbody>
                </table>
            </div>
        </div>    
        <div id="userDialog" title="">
			
		</div>
     <g:each in="${usersByRoleList}" status="i" var="map">
      <div id="adduser-${i}" class="dropdown-menu has-tip">
		    <ul>
		        <li><a id="addnewuser-${i}" class="addnewuser" href="#1">Add New User</a></li>
		        <li><a id="addexistinguser-${i}" class="addexistinguser"  href="#2">Add Existing user</a></li>
		        
		    </ul>
		</div>     
     </g:each> 

	<div id="resultDialog" class="resultDialog">
		
	</div>

	
</body>
 </html>       
