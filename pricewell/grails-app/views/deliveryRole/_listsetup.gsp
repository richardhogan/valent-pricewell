
<%@ page import="com.valent.pricewell.DeliveryRole" %>
<%@ page import="com.valent.pricewell.Geo" %>
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
			if("firstsetup" == "${source}")
				{var xdialogDiv = "#deliveryRoleDialog";}
			else
				{var xdialogDiv = "#deliveryRoleSetupDialog";}
			
			function refreshGeoGroupList(source)
			{
				if(source == "firstsetup")
					{refreshNavigation();}
				jQuery.ajax({
					type: "POST",
					url: "${baseurl}/deliveryRole/listsetup",
					data: {source: "${source}"},
					success: function(data){
						if(source == "firstsetup")
						{jQuery('#contents').html(data);}
						else
						{jQuery('#dvdeliveryrole').html(data);}
					}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){}
				});
			}
			
			var ajaxList = new AjaxPricewellList("DeliveryRole", "DeliveryRole", "${baseurl}", "setup", 750, 600, true, true, true, true);
			
			jQuery(document).ready(function()
		 	{	
				ajaxList.init();
					
		 		var deleteSetupMsg = "<div>Are you sure you want to delete Delivery Role?</div>";
				jQuery('.createDeliveryRoleSetup').click(function () 
				{
					 var dialogWidth = 800; var dialogHeight = 600;
					
					jQuery( xdialogDiv ).html('Loading, please wait.....');
					jQuery( xdialogDiv ).dialog( "open" );
					jQuery( xdialogDiv ).dialog( "option", "title", "Create Delivery Role" );
					jQuery( xdialogDiv ).dialog( "option", "zIndex", 1500 );
					jQuery( xdialogDiv ).dialog( "option", "width", dialogWidth);
					jQuery( xdialogDiv ).dialog( "option", "maxHeight", dialogHeight);
					jQuery.ajax({
						type: "POST", 
						url: "${baseurl}/deliveryRole/createsetup",
						data: {source: 'setup'},
						success: function(data){
							jQuery(xdialogDiv).html(data);
							
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){}
					});
					return false;
						
				});
				
				jQuery(".editDeliveryRoleSetup").click(function(){
					jQuery( xdialogDiv ).html('Loading, please wait.....');
					jQuery( xdialogDiv ).dialog( "open" );
					jQuery( xdialogDiv ).dialog( "option", "title", "Edit Delivery Role" );
					jQuery( xdialogDiv ).dialog( "option", "zIndex", 1500 );
					jQuery( xdialogDiv ).dialog( "option", "width", 800); jQuery( xdialogDiv ).dialog( "option", "maxHeight", 600);
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/deliveryRole/editsetup",
						data: {id: this.id, source: 'setup'},
						success: function(data){
							jQuery( xdialogDiv ).html(data);
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){}
					});
				});
				
				jQuery(".showDeliveryRoleSetup").click(function(){
					jQuery(xdialogDiv).html('Loading, please wait.....');
					jQuery(xdialogDiv).dialog( "open" );
					jQuery(xdialogDiv).dialog( "option", "title", "Show Delivery Role" );
					jQuery(xdialogDiv).dialog( "option", "zIndex", 1500 ); jQuery(xdialogDiv).dialog( "option", "width", 800);
					jQuery(xdialogDiv).dialog( "option", "maxHeight", 600);
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/deliveryRole/showsetup",
						data: {id: this.id, source: 'setup'},
						success: function(data){
							jQuery(xdialogDiv).html(data);
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){}
					});
				});
				
				jQuery(".deleteDeliveryRoleSetup").click(function()
				{
					var myid = this.id;
					var btns = {};
					btns["Yes"] = function()
					{ 
						jQuery.ajax(
						{
							
							type: "POST",
							url: "${baseurl}/deliveryRole/deletesetup",
							data: {id: myid, source: 'setup'},
							success: function(data)
							{
								if(data == "can_not_delete_delivery_role")
								{
									jRAlert('Delivery Role is under use in service, so can not delete it.', 'Delete Message', function(r)
									{
										if(r == true)
										{
											jQuery.ajax({
												type: "POST",
												url: "${baseurl}/deliveryRole/reportsetup",
												data: {id: myid, source: "setup"},
												success: function(data){
													jQuery("#reportDv").dialog( "open" ).html(data);
												}, 
												error:function(XMLHttpRequest,textStatus,errorThrown){}
											});return false;
										}
										return false;
									});
								}
								else if(data == "success")
								{								    		         
									hideUnhideNextBtn();
									jQuery(".resultDialog").html('Loading, please wait.....'); 
									jQuery(".resultDialog").dialog( "open" ); jQuery(".resultDialog").dialog( "option", "title", "Success" );
									jQuery(".resultDialog").html('Delivery Role deleted successfully.'); 
									jQuery( xdialogDiv ).dialog( "close" );
								}
								else{
									jQuery(".resultDialog").html('Loading, please wait.....'); jQuery( ".resultDialog" ).dialog("open");
									jQuery(".resultDialog").dialog( "open" ); jQuery(".resultDialog").dialog( "option", "title", "Failure" );
									jQuery(".resultDialog").html("Failed to delete delivery role."); 
									jQuery( xdialogDiv ).dialog( "close" );
								}
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){}
						});
					    jQuery(this).dialog("close");
					};
					btns["No"] = function(){ 
						jQuery(this).dialog("close");
					};
					jQuery.ajax(
						{
							type: "POST",
							url: "${baseurl}/deliveryRole/getName",
							data: {id: myid, source: 'setup'},
							success: function(data){
								jQuery(deleteSetupMsg).dialog({
								    autoOpen: true,
								    title: "Delete Delivery Role : " + data,
								    modal:true,
								    buttons:btns
								});
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){}
						});
					
						  
				});
				
				jQuery( "#reportDv" ).dialog(
				{
					maxHeight: 600,
					width: 800,
					modal: true,
					autoOpen: false,
					close: function( event, ui ) {
							jQuery(this).html('');
						}
					
				});
			});
		
		</script>
    <body>
    	
    	<div class="reportDv" id="reportDv" title="Delete Report Of Delivery Role"></div>
        
        <div class="body">
        
        	<g:if test="${source == 'firstsetup'}">
        		<h1> ${deliveryRoleInstanceTotal} DeliveryRoles defined &nbsp; &nbsp;<span><button id="createDeliveryRole" title="Add New DeliveryRole"> Add Delivery Role </button></span></h1><hr />
	        
	            <div class="list">
	                <table cellpadding="0" cellspacing="0" border="0" class="display" id="deliveryRolesList">
        	</g:if>
        	<g:else>
	            <div class="nav">
		            <a id="createDeliveryRoleSetup" class="createDeliveryRoleSetup button" href="#" title="Add New DeliveryRole">Add DeliveryRole</a>
		        </div>
		        
	            <div class="list childtab">
	                <table cellpadding="0" cellspacing="0" border="0" class="display1" id="deliveryRolesSetupList">
            </g:else>
                    <thead>
                        <tr>
                        
                            <th>Name</th>
                        	
                        	<th>Description</th>
                        	
                        	<th>Rate/Cost Defined</th>
                        	<th></th>
                        	<th></th>
                            
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${deliveryRoleInstanceList?.sort{it?.name}}" status="i" var="deliveryRoleInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td>${fieldValue(bean: deliveryRoleInstance, field: "name")}</td>
                        
                            <td width="50%">${fieldValue(bean: deliveryRoleInstance, field: "description")}</td>
                        
                        	<g:if test="${source == 'firstsetup'}">
								<td><a id="${deliveryRoleInstance.id}" href="#" title="Show Details" class="showDeliveryRole hyperlink">(${deliveryRoleInstance?.relationDeliveryGeos.size()}/${Geo.list().size() }) Territor<g:if test="${deliveryRoleInstance?.relationDeliveryGeos.size()>1}">ies</g:if><g:else>y</g:else> Defined </a></td>
	                        	
	                        	<td> <a id="${deliveryRoleInstance.id}" href="#" class="editDeliveryRole hyperlink"> Edit </a></td>
								<td> <a id="${deliveryRoleInstance.id}" href="#" class="deleteDeliveryRole hyperlink"> Delete </a></td>
							</g:if>
							<g:else>
	                        	<td><a id="${deliveryRoleInstance.id}" href="#" title="Show Details" class="showDeliveryRoleSetup hyperlink">(${deliveryRoleInstance?.relationDeliveryGeos.size()}/${Geo.list().size() }) Territor<g:if test="${deliveryRoleInstance?.relationDeliveryGeos.size()>1}">ies</g:if><g:else>y</g:else> Defined </a></td>
	                        	
	                        	<td> <a id="${deliveryRoleInstance.id}" href="#" class="editDeliveryRoleSetup hyperlink"> Edit </a></td>
								<td> <a id="${deliveryRoleInstance.id}" href="#" class="deleteDeliveryRoleSetup hyperlink"> Delete </a></td>
							</g:else>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            
        </div>
        
        <div id="deliveryRoleDialog" title="">
			
		</div>
    </body>
</html>
