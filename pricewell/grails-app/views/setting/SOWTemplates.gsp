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
   					url:'${baseurl}/setting/getTerritorySOWTemplate',
   					success:function(data,textStatus)
   					{
	   					jQuery('#mainterritorySOWTemplateTab').html(data);
	   				},
   					error:function(XMLHttpRequest,textStatus,errorThrown){}});
   		 			return false;
          		
  		 	}
    	

        	jQuery(document).ready(function()
  		 	{
      		 	pageLoad();
   				
        		jQuery("#territorySettings").validate();
        		
        		jQuery('#definedTerritoryId').change(function() {
        			jQuery( "#undefinedTerritoryId" ).val('');
        			var territoryId = jQuery( "#definedTerritoryId" ).val();

        			jQuery.ajax({type:'POST',data: {territoryId: territoryId, source: 'firstsetup'},
	   					url:'${baseurl}/setting/getTerritorySOWTemplate',
	   					success:function(data,textStatus)
	   					{
		   					jQuery('#mainterritorySOWTemplateTab').html(data);
		   					
		   				},
	   					error:function(XMLHttpRequest,textStatus,errorThrown){}});
	   		 			return false;
        			  //alert('Territory Id : '+territoryId);
        		});

        		jQuery('#undefinedTerritoryId').change(function() {
        			jQuery( "#definedTerritoryId" ).val('') ;
        			var territoryId = jQuery( "#undefinedTerritoryId" ).val();

        			jQuery.ajax({type:'POST',data: {territoryId: territoryId, source: 'firstsetup'},
	   					url:'${baseurl}/setting/getTerritorySOWTemplate',
	   					success:function(data,textStatus)
	   					{
		   					jQuery('#mainterritorySOWTemplateTab').html(data);
		   					
		   				},
	   					error:function(XMLHttpRequest,textStatus,errorThrown){}});
	   		 			return false;
        			  
        		});

        	});

        	function refreshSideNevAndContentList(id){
        		jQuery( "#importSOWSuccessDialog" ).data('id', id).dialog("open");
				refreshNavigation();
				return true;
			}
        	
		</script>  
    </head>
    <body>
    
    	
				<div><h1><b>SOW Templates</b></h1></div><hr />
			
			
				<div id="territorySOWTemplatesTab">
					<table>
						<tr>
							<td><b>Select Territory : </b></td><td>&nbsp;&nbsp;</td><td>&nbsp;&nbsp;</td>
							<g:if test="${definedTerritories.size() > 0 }">
								<td><b>Defined SOW Templates</b></td><td>&nbsp;&nbsp;</td><td>&nbsp;&nbsp;</td>
							</g:if>
							<g:if test="${undefinedTerritories.size() > 0 }">
								<td><b>Undefined SOW Templates</b></td>
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
					<div id="mainterritorySOWTemplateTab">
						
					</div>
				</div>
			
			
    </body>
    
</html>