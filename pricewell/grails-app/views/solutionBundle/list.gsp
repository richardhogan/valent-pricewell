<%@page import="com.valent.pricewell.SolutionBundleController"%>

<%@page import="com.valent.pricewell.SolutionBundle" %>
<%
	def baseurl = request.siteUrl
%>
<html>
	<head>
		<meta name="layout" content="main" />
    	<export:resource />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <g:set var="entityName" value="${message(code: 'service.label', default: 'Service')}" />
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
			
			var xdialogDiv = "#solutionBundleDialog";
			
			function refreshSolutionBundleList()
			{
				jQuery.ajax({
					type: "POST",
					url: "${baseurl}/solutionBundle/listsetup",
					data: {source: "${source}"},
					success: function(data){
						jQuery('#dvsolutionBundle').html(data);
					}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){}
				});
			}
			
			jQuery(document).ready(function()
		 	{	
		 		var deleteSetupMsg = "<div>Are you sure you want to delete Solution Bundle?</div>";
				jQuery('#createsolutionBundleSetup').click(function () 
				{
					 var dialogWidth = 800; var dialogHeight = 600;
					
					jQuery( xdialogDiv ).html('Loading, please wait.....');
					jQuery( xdialogDiv ).dialog( "open" );
					jQuery( xdialogDiv ).dialog( "option", "title", "Create Solution Bundle" );
					jQuery( xdialogDiv ).dialog( "option", "zIndex", 1500 );
					jQuery( xdialogDiv ).dialog( "option", "width", dialogWidth);
					jQuery( xdialogDiv ).dialog( "option", "maxHeight", dialogHeight);
					jQuery.ajax({
						type: "POST", 
						url: "${baseurl}/solutionBundle/createsetup",
						data: {source: 'setup'},
						success: function(data){
							jQuery(xdialogDiv).html(data);
							
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){}
					});
					return false;
				});
				
				jQuery(".editsolutionBundleSetup").click(function(){
					jQuery( xdialogDiv ).html('Loading, please wait.....');
					jQuery( xdialogDiv ).dialog( "open" );
					jQuery( xdialogDiv ).dialog( "option", "title", "Edit Solution Bundle" );
					jQuery( xdialogDiv ).dialog( "option", "zIndex", 1500 );
					jQuery( xdialogDiv ).dialog( "option", "width", 800); jQuery( xdialogDiv ).dialog( "option", "maxHeight", 600);
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/solutionBundle/editsetup",
						data: {id: this.id, source: 'setup'},
						success: function(data){
							jQuery( xdialogDiv ).html(data);
						},
						error:function(XMLHttpRequest,textStatus,errorThrown){}
					});
				});

				jQuery(".manageservicesolutionBundleSetup").click(function(){
					jQuery( xdialogDiv ).html('Loading, please wait.....');
					jQuery( xdialogDiv ).dialog( "open" );
					jQuery( xdialogDiv ).dialog( "option", "title", "Manage Services for Solution Bundle" );
					jQuery( xdialogDiv ).dialog( "option", "zIndex", 1500 );
					jQuery( xdialogDiv ).dialog( "option", "width", 800); jQuery( xdialogDiv ).dialog( "option", "maxHeight", 600);
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/solutionBundle/manageservicesetup",
						data: {id: this.id, source: 'setup'},
						success: function(data){
							jQuery( xdialogDiv ).html(data);
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){}
					});
				});
				
				jQuery(".showsolutionBundleSetup").click(function(){
					jQuery(xdialogDiv).html('Loading, please wait.....');
					jQuery(xdialogDiv).dialog( "open" );
					jQuery(xdialogDiv).dialog( "option", "title", "Show Solution Bundle" );
					jQuery(xdialogDiv).dialog( "option", "zIndex", 1500 ); jQuery(xdialogDiv).dialog( "option", "width", 800);
					jQuery(xdialogDiv).dialog( "option", "maxHeight", 600);
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/solutionBundle/showsetup",
						data: {id: this.id, source: 'setup'},
						success: function(data){
							jQuery(xdialogDiv).html(data);
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){}
					});
				});
				
				jQuery(".deletesolutionBundleSetup").click(function()
						{
							var myid = this.id;
							var btns = {};
							btns["Yes"] = function()
							{ 
								jQuery.ajax(
								{
									type: "POST",
									url: "${baseurl}/solutionBundle/deletesetup",
									data: {id: myid, source: 'setup'},
									success: function(data)
									{
										if(data == "success")
										{								    		         
											jAlert("Solution Bundle deleted successfully.", 'Confirmation Dialog', function(r)
						    				{
												window.location.href = "${baseurl}/solutionBundle/list";
											});
										}
										else{
											jAlert("Failed to delete Solution Bundle", 'Confirmation Dialog', function(r)
						    				{
												window.location.href = "${baseurl}/solutionBundle/list";
											});
										}
									}, 
									error:function(XMLHttpRequest,textStatus,errorThrown){
										alert ("Error while Deleting")
										}
								});
							    jQuery(this).dialog("close");
							};
							btns["No"] = function(){ 
								jQuery(this).dialog("close");
							};
							jQuery.ajax(
								{
									type: "POST",
									url: "${baseurl}/solutionBundle/getName",
									data: {id: myid, source: 'setup'},
									success: function(data){
										jQuery(deleteSetupMsg).dialog({
										    autoOpen: true,
										    title: "Delete Solution Bundle : " + data,
										    modal:true,
										    buttons:btns
										});
									}, 
									error:function(XMLHttpRequest,textStatus,errorThrown){}
								});
							
								  
						});

						jQuery( xdialogDiv ).dialog(
						{
							maxHeight: 800,
							width: 800,
							modal: true,
							autoOpen: false,
							close: function( event, ui ) {
									jQuery(this).html('');
								}
							
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
		</head>
    <body>
        <div class="leftNav">				
    		<g:render template="../service/serviceNavigation"/>
    	</div>
        <div id="columnRight" class="body rightContent column">
        	<div class="reportDv" id="reportDv" title="Delete Report Of Solution Bundle">
    		</div>
        	<div style="width:100%">
       			<div style="float: left;width:15%">
       				<h1>Solution Bundle (${solutionBundleInstanceList.size()})</h1>
       			</div>
       			<div style="float: right; width: 85%; margin-top:10px">
       				<a id="createsolutionBundleSetup" class="createsolutionBundleSetup button" href="#" title="Add New Solution Bundle">Add Solution Bundle</a>
       			</div>
       		</div>
       		<br />
       		<br />
	        <div class="body">
		            <div class="nav" >
			        </div>
		            <div class="list childtab">
		                <table class="display1" id="solutionBundleSetupList">
		                    <thead>
		                        <tr>                        
					    			<th>Name</th>
					    			<th width="45%">Description</th>
					    			<th>Total Service</th>
					    			<th width="20%">Action</th>
		                        </tr>
		                    </thead>
		                    <tbody>
			                    <g:each in="${solutionBundleInstanceList}" status="i" var="solutionBundleInstance">
			                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
			                            <td>${solutionBundleInstance.name }</td>
			                            <td>${solutionBundleInstance.description}</td>
			                        	<td>${solutionBundleInstance.getSolutionBundleServicesCount()}</td>
				                        	<td> <a id="${solutionBundleInstance.id}" href="#" class="editsolutionBundleSetup hyperlink"> Edit </a>&nbsp;&nbsp;/&nbsp;&nbsp;
				                        		 <a id="${solutionBundleInstance.id}" href="#" class="manageservicesolutionBundleSetup hyperlink"> Manage Services </a>&nbsp;&nbsp;/&nbsp;&nbsp;
												 <a id="${solutionBundleInstance.id}" href="#" class="deletesolutionBundleSetup hyperlink"> Delete </a></td>
			                        </tr>
			                    </g:each>
			                    <g:if test="${solutionBundleInstanceList == null || solutionBundleInstanceList.isEmpty()}">
			                    		<tr><td colspan="4">No Records Available.</td></tr>
			                    </g:if>
		                    </tbody>
	                	</table>
		            </div>
			        <div id="solutionBundleDialog" title="">
						
					</div>
			</div>
		</div>
    </body>
</html>
