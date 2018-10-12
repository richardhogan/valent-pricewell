<%@ page import="com.valent.pricewell.Geo" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
    	<script> 
        	

        	function pageLoad() {
        		var id = ${territoryInstance?.id}

      		 	jQuery.ajax({type:'POST',data: {territoryId: id, source: 'setup'},
   					url:'${baseurl}/setting/getTerritorySetting',
   					success:function(data,textStatus)
   					{
	   					jQuery('#mainterritorySettingTab').html(data);
	   				},
   					error:function(XMLHttpRequest,textStatus,errorThrown){}});
   		 			return false;
          		
  		 	}
    	

        	jQuery(document).ready(function()
  		 	{
      		 	pageLoad();
   				
        		jQuery("#territorySettings").validate();
        		
        		jQuery('#definedTerritoryId').change(function() {
        			var territoryId = jQuery( "#definedTerritoryId" ).val();

        			jQuery.ajax({type:'POST',data: {territoryId: territoryId, source: 'firstsetup'},
	   					url:'${baseurl}/setting/getTerritorySetting',
	   					success:function(data,textStatus)
	   					{
		   					jQuery('#mainterritorySettingTab').html(data);
		   					
		   				},
	   					error:function(XMLHttpRequest,textStatus,errorThrown){}});
	   		 			return false;
        			  //alert('Territory Id : '+territoryId);
        		});

        		jQuery('#undefinedTerritoryId').change(function() {
        			var territoryId = jQuery( "#undefinedTerritoryId" ).val();

        			jQuery.ajax({type:'POST',data: {territoryId: territoryId, source: 'firstsetup'},
	   					url:'${baseurl}/setting/getTerritorySetting',
	   					success:function(data,textStatus)
	   					{
		   					jQuery('#mainterritorySettingTab').html(data);
		   					
		   				},
	   					error:function(XMLHttpRequest,textStatus,errorThrown){}});
	   		 			return false;
        			  
        		});

        	});

        	function refreshGeoGroupList(id){
        		jQuery( "#successDialog" ).data('id', id).dialog("open");
				refreshNavigation();
				return true;
			}
        	
		</script>  
    </head>
    <body>
    
    	
				<div><h1><b>SOW Settings</b></h1></div><hr />
			
			
				<div id="territorySettingsTab">
					<table>
						<tr>
							<td><b>Select Territory : </b></td><td>&nbsp;&nbsp;</td><td>&nbsp;&nbsp;</td>
							<g:if test="${definedTerritories.size() > 0 }">
								<td><b>Defined SOW Settings</b></td><td>&nbsp;&nbsp;</td><td>&nbsp;&nbsp;</td>
							</g:if>
							<g:if test="${undefinedTerritories.size() > 0 }">
								<td><b>Undefined SOW Settings</b></td>
							</g:if>
						</tr>
						<tr>
							<td></td><td>&nbsp;&nbsp;</td><td>&nbsp;&nbsp;</td>
							<g:if test="${definedTerritories.size() > 0 }">
								<td><g:select name="definedTerritoryId" from="${definedTerritories?.sort {it.name}}" value="${territoryInstance?.id }" optionKey="id" noSelection="['':'Select Any One']"/></td><td>&nbsp;&nbsp;</td><td>&nbsp;&nbsp;</td>
							</g:if>
							<g:if test="${undefinedTerritories.size() > 0 }">
								<td><g:select name="undefinedTerritoryId" from="${undefinedTerritories?.sort {it.name}}" value="" optionKey="id" noSelection="['':'Select Any One']"/></td>
							</g:if>
						</tr>
					</table>
					<hr>
					<div id="mainterritorySettingTab">
						
					</div>
				</div>
			
			
			
			
			
    </body>
    
</html>