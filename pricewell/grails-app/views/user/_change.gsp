<%@ page import="com.valent.pricewell.Geo" %>
<%@ page import="com.valent.pricewell.GeoGroup" %>
<%@ page import="grails.plugins.nimble.core.*" %>

<html>
	<script>
		jQuery(document).ready(function()
	    {		   
			jQuery( "#successDialog" ).dialog(
		 	{
				modal: true,
				autoOpen: false,
				buttons: 
				{
					OK: function() 
					{
						jQuery( "#successDialog" ).dialog( "close" );
						jQuery( "#dvUserServices" ).dialog( "close" );
						//jQuery( "#userDialog" ).dialog( "close" );
						//refreshGeoGroupList();
						jQuery("#userDialog").html('Loading .....');
						jQuery.ajax({
							type: "POST",
							url: "/pricewell/user/showsetup",
							data: {id: <%=user?.id%>},
							success: function(data){
								jQuery("#userDialog").html(data);
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){}
						});
						return false;
					}
				}
			});
			
			jQuery( "#failureDialog" ).dialog(
			{
				modal: true,
				autoOpen: false,
				buttons: {
					OK: function() {
						jQuery( "#failureDialog" ).dialog( "close" );
						return false;
					}
				}
			});
					 
	  		jQuery("#saveChanges").click(function(){

	  			var id = jQuery( "#id" ).val();
	  			
				var geoGroupId = jQuery( "#geoGroupId" ).val();
				var territoryId = jQuery( "#territoryId" ).val();
				var territories = jQuery( "#territoriesList" ).val();
				var string = "";
				if(geoGroupId != null && geoGroupId != "")
				{
					string = string + "&geoGroupId="+geoGroupId
				}
				if(territoryId != null && territoryId != "")
				{
					string = string + "&territoryId="+territoryId
				}
				if(territories != null && territories != "")
				{
					string = string + "&territories="+territories
				}
				
					jQuery.ajax({
						type: "POST",
						url: "/pricewell/user/updateTerritoryGeo?id="+id+string,
						
						success: function(data){
							if(data == "success"){
								jQuery( "#dvUserServices" ).dialog( "close" );    		                   		
		                   		jQuery( "#successDialog" ).dialog("open");
							} else{
								jQuery( "#dvUserServices" ).dialog( "close" );
						    	jQuery( "#failureDialog" ).dialog("open");
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
	<body>
		
		<div id="successDialog" title="Successfully Changed">
			<p>Changes done successfully.</p>
		</div>
	
		<div id="failureDialog" title="Changes Failed">
			<p>Changes are failed.</p>
		</div>
	
		<form name="changeTerritoryGeo">
			<g:hiddenField name="id"  value="${user?.id}" />
			<table>
				<g:if test="${changeFor == 'generalManager' }">
					<tr>
						<td><label>Select GEO</label></td>
					
						<td> <g:select name="geoGroupId" from="${GeoGroup.list()}" value="${user?.geoGroup?.id}" optionKey="id" noSelection="['': 'Select any one']"/></td>
					</tr>
				</g:if>
				
				<g:if test="${changeFor == 'salesPerson' }">
					<tr>
						<td><label>Select Territory</label></td>
					
						<td> <g:select name="territoryId" from="${Geo.list()}" value="${user?.territory?.id}" optionKey="id" noSelection="['': 'Select any one']"/></td>
					</tr>
				</g:if>
				
				<g:if test="${changeFor == 'salesManager' }">
					<tr>
						<td><label>Select Territories</label></td>
					
						<td> <g:select name="territoriesList" from="${Geo.list()}" value="${user?.territories*.id}" optionKey="id" multiple="multiple"/></td>
					</tr>
				</g:if>
			</table>
			
			<div>
		      <span class="button"><button id="saveChanges"> Save Changes </button></span>
		    </div>
		</form>
	</body>
</html>