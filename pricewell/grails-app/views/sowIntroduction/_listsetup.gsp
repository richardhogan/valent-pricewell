<%@ page import="com.valent.pricewell.SowIntroduction" %>
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
				{var xdialogDiv = "#sowIntroductionDialog";}
			else
				{var xdialogDiv = "#sowIntroductionSetupDialog";}
			
			function refreshGeoGroupList(source)
			{
				if(source == "firstsetup")
					{refreshNavigation();}
				jQuery.ajax({
					type: "POST",
					url: "${baseurl}/sowIntroduction/listsetup",
					data: {source: "${source}"},
					success: function(data){
						if(source == "firstsetup")
						{jQuery('#contents').html(data);}
						else
						{jQuery('#dvsowIntroduction').html(data);}
					}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){}
				});
			}
			
			var ajaxList = new AjaxPricewellList("sowIntroduction", "sowIntroduction", "${baseurl}", "setup", 750, 600, true, true, true, true);
			
			jQuery(document).ready(function()
		 	{	
				ajaxList.init();
					
		 		var deleteSetupMsg = "<div>Are you sure you want to delete Sow Introduction?</div>";
				jQuery('.createsowIntroductionSetup').click(function () 
				{
					 var dialogWidth = 800; var dialogHeight = 600;
					
					jQuery( xdialogDiv ).html('Loading, please wait.....');
					jQuery( xdialogDiv ).dialog( "open" );
					jQuery( xdialogDiv ).dialog( "option", "title", "Create Sow Introduction" );
					jQuery( xdialogDiv ).dialog( "option", "zIndex", 1500 );
					jQuery( xdialogDiv ).dialog( "option", "width", dialogWidth);
					jQuery( xdialogDiv ).dialog( "option", "maxHeight", dialogHeight);
					jQuery.ajax({
						type: "POST", 
						url: "${baseurl}/sowIntroduction/createsetup",
						data: {source: 'setup'},
						success: function(data){
							jQuery(xdialogDiv).html(data);
							
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){}
					});
					return false;
						
				});
				
				jQuery(".editsowIntroductionSetup").click(function(){
					jQuery( xdialogDiv ).html('Loading, please wait.....');
					jQuery( xdialogDiv ).dialog( "open" );
					jQuery( xdialogDiv ).dialog( "option", "title", "Edit Sow Introduction" );
					jQuery( xdialogDiv ).dialog( "option", "zIndex", 1500 );
					jQuery( xdialogDiv ).dialog( "option", "width", 800); jQuery( xdialogDiv ).dialog( "option", "maxHeight", 600);
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/sowIntroduction/editsetup",
						data: {id: this.id, source: 'setup'},
						success: function(data){
							jQuery( xdialogDiv ).html(data);
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){}
					});
				});
				
				jQuery(".showsowIntroductionSetup").click(function(){
					jQuery(xdialogDiv).html('Loading, please wait.....');
					jQuery(xdialogDiv).dialog( "open" );
					jQuery(xdialogDiv).dialog( "option", "title", "Show Sow Introduction" );
					jQuery(xdialogDiv).dialog( "option", "zIndex", 1500 ); jQuery(xdialogDiv).dialog( "option", "width", 800);
					jQuery(xdialogDiv).dialog( "option", "maxHeight", 600);
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/sowIntroduction/showsetup",
						data: {id: this.id, source: 'setup'},
						success: function(data){
							jQuery(xdialogDiv).html(data);
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){}
					});
				});
				
				jQuery(".deletesowIntroductionSetup").click(function()
				{
					var myid = this.id;
					var btns = {};
					btns["Yes"] = function()
					{ 
						jQuery.ajax(
						{
							
							type: "POST",
							url: "${baseurl}/sowIntroduction/deletesetup",
							data: {id: myid, source: 'setup'},
							success: function(data)
							{
								if(data == "success")
								{								    		         
									hideUnhideNextBtn();
									jQuery(".resultDialog").html('Loading, please wait.....'); 
									jQuery(".resultDialog").dialog( "open" ); jQuery(".resultDialog").dialog( "option", "title", "Success" );
									jQuery(".resultDialog").html('Sow Introduction deleted successfully.'); 
									jQuery( xdialogDiv ).dialog( "close" );
								}
								else{
									jQuery(".resultDialog").html('Loading, please wait.....'); jQuery( ".resultDialog" ).dialog("open");
									jQuery(".resultDialog").dialog( "open" ); jQuery(".resultDialog").dialog( "option", "title", "Failure" );
									jQuery(".resultDialog").html("Failed to delete Sow Introduction."); 
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
							url: "${baseurl}/sowIntroduction/getName",
							data: {id: myid, source: 'setup'},
							success: function(data){
								jQuery(deleteSetupMsg).dialog({
								    autoOpen: true,
								    title: "Delete Sow Introduction : " + data,
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
    	
    	<div class="reportDv" id="reportDv" title="Delete Report Of Sow Introduction"></div>
        
        <div class="body">
        
        	<g:if test="${source == 'firstsetup'}">
        		<h1> ${sowIntroductionInstanceTotal} Sow Introductions defined &nbsp; &nbsp;<span><button id="createsowIntroduction" title="Add New Sow Introduction"> Add Sow Introduction </button></span></h1><hr />
	        
	            <div class="list">
	                <table cellpadding="0" cellspacing="0" border="0" class="display" id="sowIntroductionsList">
        	</g:if>
        	<g:else>
	            <div class="nav">
		            <a id="createsowIntroductionSetup" class="createsowIntroductionSetup button" href="#" title="Add New sowIntroduction">Add sowIntroduction</a>
		        </div>
		        
	            <div class="list childtab">
	                <table cellpadding="0" cellspacing="0" border="0" class="display1" id="sowIntroductionsSetupList">
            </g:else>
            
                    <thead>
                        <tr>                        
                            <th>Name</th>                        	
                        	<th>Sow Text</th>
                        	<th>Territory</th>                        	
                        	<th></th>
                        	<th></th>
                            
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${sowIntroductionInstanceList?.sort{it?.name}}" status="i" var="sowIntroductionInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td>${fieldValue(bean: sowIntroductionInstance, field: "name")}</td>
                        
                            <td width="50%">${fieldValue(bean: sowIntroductionInstance, field: "sow_text")}</td>
                        	<td width="50%">${fieldValue(bean: sowIntroductionInstance, field: "geo")}</td>
                        	<g:if test="${source == 'firstsetup'}">
								
	                        	<td> <a id="${sowIntroductionInstance.id}" href="#" class="editsowIntroduction hyperlink"> Edit </a></td>
								<td> <a id="${sowIntroductionInstance.id}" href="#" class="deletesowIntroduction hyperlink"> Delete </a></td>
							</g:if>
							<g:else>                       		                        	
	                        	<td> <a id="${sowIntroductionInstance.id}" href="#" class="editsowIntroductionSetup hyperlink"> Edit </a></td>
								<td> <a id="${sowIntroductionInstance.id}" href="#" class="deletesowIntroductionSetup hyperlink"> Delete </a></td>
							</g:else>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            
    
        
        <div id="sowIntroductionDialog" title="">
			
		</div>
		
    </body>
</html>
