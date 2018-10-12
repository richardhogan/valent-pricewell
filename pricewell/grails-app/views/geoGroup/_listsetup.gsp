
<%@ page import="com.valent.pricewell.GeoGroup" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <body>
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
			function refreshGeoGroupList(source){
				refreshNavigation();
				jQuery.ajax({
					type: "POST",
					url: "${baseurl}/geoGroup/listsetup",
					data: {source: "firstsetup"},
					success: function(data){
						jQuery('#contents').html(data);
					}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){}
				});
			}
			
			var ajaxList = new AjaxPricewellList("GEO", "GeoGroup", "${baseurl}", "setup", 750, 600, "${allowCreate}", "${allowEdit}", "${allowDelete}", "${allowShow}");
			
			jQuery(document).ready(function()
		 	{	
				ajaxList.init();
				
		 		var deleteMsgSetup = "<div>Are you sure you want to delete GEO?</div>";

				jQuery('.createGeoGroupSetup').click(function () 
				{
					jQuery( xdialogDiv ).html('Loading, please wait.....');
					jQuery( xdialogDiv ).dialog( "open" ); jQuery( xdialogDiv ).dialog( "option", "zIndex", 1500 );
					jQuery( xdialogDiv ).dialog( "option", "title", "Create GEO" );
					jQuery( xdialogDiv ).dialog( "option", "width", 'auto'); jQuery( xdialogDiv ).dialog( "option", "maxHeight", 600);
					jQuery.ajax({
						type: "POST", 
						url: "${baseurl}/geoGroup/createsetup",
						data: {source: "setup"},
						success: function(data){
							jQuery(xdialogDiv).html(data);
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){}
					});
					return false;
						
				});
				
				jQuery(".editGeoGroupSetup").click(function(){
					jQuery( xdialogDiv ).html('Loading, please wait.....');
					jQuery( xdialogDiv ).dialog( "open" ); jQuery( xdialogDiv ).dialog( "option", "zIndex", 1500 );
					jQuery( xdialogDiv ).dialog( "option", "title", "Edit GEO" ); 
					jQuery( xdialogDiv ).dialog( "option", "width", 'auto'); jQuery( xdialogDiv ).dialog( "option", "maxHeight", 600);
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/geoGroup/editsetup",
						data: {id: this.id, source: "setup"},
						success: function(data){
							jQuery( xdialogDiv ).html(data);
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){}
					});
				});
				
				jQuery(".deleteGeoGroupSetup").click(function()
				{
					var myid = this.id;
					var btns = {};
					btns["Yes"] = function()
					{ 
						jQuery.ajax(
						{
							type: "POST",
							url: "${baseurl}/geoGroup/deletesetup",
							data: {id: myid, source: 'setup'},
							success: function(data)
							{
								if(data == "success")
								{	
									hideUnhideNextBtn();       
									jQuery(".resultDialog").html('Loading, please wait.....'); 
									jQuery(".resultDialog").dialog( "open" ); jQuery(".resultDialog").dialog( "option", "title", "Success" );
									jQuery(".resultDialog").html('GEO deleted successfully.'); jQuery( xdialogDiv ).dialog( "close" );
								}
								else{
									jQuery(".resultDialog").html('Loading, please wait.....'); jQuery( ".resultDialog" ).dialog("open");
									jQuery(".resultDialog").dialog( "open" ); jQuery(".resultDialog").dialog( "option", "title", "Failure" );
									jQuery(".resultDialog").html("Failed to delete GEO."); jQuery( xdialogDiv ).dialog( "close" );
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
							url: "${baseurl}/geoGroup/getName",
							data: {id: myid},
							success: function(data){
								jQuery(deleteMsgSetup).dialog({
								    autoOpen: true,
								    title: "Delete GEO " + data,
								    modal:true,
								    position:[400,200],
								    buttons:btns
								});
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){}
						});
					
						  
				});
			});
			
		</script>
        <div class="body">
        	<g:if test="${source == 'firstsetup'}">
        		<h1> ${geoGroupInstanceTotal} GEOs defined &nbsp; &nbsp;
        			<g:if test="${allowCreate == true}">
        				<span><button id="createGeoGroup" title="Add New GEO"> Add GEO </button></span>
        			</g:if>
       			</h1><hr />
	        
	            <div class="list">
	                <table cellpadding="0" cellspacing="0" border="0" class="display" id="geoGroupsList">
        	</g:if>
        	<g:else>
	        	<div class="nav">
		            <a id="createGeoGroupSetup" class="createGeoGroupSetup button" href="#" title="Add New GEO">Add GEO</a>
		        </div>
		        
	            <div class="list childtab">
	                <table cellpadding="0" cellspacing="0" border="0" class="display1" id="geoGroupsSetupList">
            </g:else>
                    <thead>
                        <tr>                        
                            <th>${message(code: 'geoGroup.name.label', default: 'Name')} </th>
                        
                            <th style="width: 30%;">${message(code: 'geoGroup.description.label', default: 'Description')}</th>
                            
                            <th>${message(code: 'geoGroup.generalManager.label', default: 'Assigned General Manager')}</th>
                            
							<th> List of Territories</th>
							
							<g:if test="${source == 'firstsetup'}">
								<g:if test="${allowEdit == true}"><th></th></g:if>
                            
                            	<g:if test="${allowDelete == true}"><th></th></g:if>
                           	</g:if>
                           	<g:else><th></th><th></th></g:else>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${geoGroupInstanceList}" status="i" var="geoGroupInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td> ${fieldValue(bean: geoGroupInstance, field: "name")}</td>
                            <!--a id="${geoGroupInstance.id}" href="#" class="showGeoGroup" -->
                            
                        
                            <td style="width: 30%;">${fieldValue(bean: geoGroupInstance, field: "description")}</td>
                            
                            <td>
                            	<g:each in="${geoGroupInstance.generalManagers}" var="g">
                                    ${g?.encodeAsHTML()}
                                </g:each>
                            </td>
                        	
							<td> 
								<g:each in="${geoGroupInstance?.geos}" var="territory" status="g">
                                    <b>${g+1})</b> ${territory?.name?.encodeAsHTML()} &nbsp;
                                    <g:if test="${(g % 2) == 1 }"><br></g:if>
                                </g:each>
                            </td>
							
							<g:if test="${source == 'firstsetup'}">
								<g:if test="${allowEdit == true}">
									<td> <a id="${geoGroupInstance.id}" href="#" title="Edit GEO" class="editGeoGroup hyperlink"> Edit </a></td>
								</g:if>
								<g:if test="${allowDelete == true}">
									<td> <a id="${geoGroupInstance.id}" href="#" title="Delete GEO" class="deleteGeoGroup hyperlink"> Delete </a></td>
								</g:if>
							</g:if>
							<g:else>
								
								<td> <a id="${geoGroupInstance.id}" href="#" title="Edit GEO" class="editGeoGroupSetup hyperlink"> Edit </a></td>
								<td> <a id="${geoGroupInstance.id}" href="#" title="Delete GEO" class="deleteGeoGroupSetup hyperlink"> Delete </a></td>
								
							</g:else>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
        </div>
        
        <div id="geoGroupDialog" title="">
			
		</div>
    </body>
</html>
