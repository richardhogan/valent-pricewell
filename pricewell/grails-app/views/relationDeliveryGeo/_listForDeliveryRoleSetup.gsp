<%@ page import="com.valent.pricewell.RelationDeliveryGeo" %>
<%
	def baseurl = request.siteUrl
%>
<html>
	<head>
	<script>
	   	jQuery(function() 
	   	{
	   		if("firstsetup" == "${source}")
				{var xdialogDiv = "#deliveryRoleDialog";}
			else
				{var xdialogDiv = "#deliveryRoleSetupDialog";}

			jQuery("#deleteDefinerelationBtn").click(function()
			{
				showLoadingBox();
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/relationDeliveryGeo/deleteMultiple",
						data:jQuery("#definedRelationDeliveryGeoFrm").serialize(),
						success: function(data)
						{
							hideLoadingBox();
							if(data == "no_selected")
							{
								jAlert('Select at least one rate card to delete.', 'Delete Rate Card Alert');
							}
							else if(data == "success")
							{
								jQuery.ajax({
									type: "POST",
									url: "${baseurl}/deliveryRole/showsetup",
									data: {id: ${deliveryRoleInstance.id}, source: "${source}"},
									success: function(data){
											if("firstsetup" == "${source}")
											{jQuery('#contents').html('').html(data);}
										else
											{jQuery(xdialogDiv).html(data);jQuery(xdialogDiv).dialog( "open" ); refreshGeoGroupList("${source}");}
									}, 
									error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
								});
							} else{
								jQuery('#deliveryRoleErrors').html(data);
								jQuery('#deliveryRoleErrors').show();
							}
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){
							hideLoadingBox();
							alert("Error while saving");
							
						}
					});
				
				
				return false;
			}); 

			jQuery("#editDefinerelationBtn").click(function()
			{
				showLoadingBox();
				jQuery.ajax({
					type: "POST",
					url: "${baseurl}/relationDeliveryGeo/editMultiple",
					data:jQuery("#definedRelationDeliveryGeoFrm").serialize(),
					success: function(data){
						hideLoadingBox();
						if(data != "no_selected")
							{jQuery("#dvRateCostsPerGeo").html(data);}
						else if(data == "no_selected")
							{jAlert('Select at least one rate card to edit.', 'Edit Rate Card Alert');}
					}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){
						hideLoadingBox();
						alert("Error while saving");
					}
				});
				
				
				return false;
			}); 
			
		});
   	</script>
   	</head>
    <body>
        
        <g:form name="definedRelationDeliveryGeoFrm">
        	<g:hiddenField name="source" value="${source}"/>
        	<g:hiddenField name="deliveryRoleId" value="${deliveryRoleInstance?.id}"/>
        	<g:set var="list" value="${relationDeliveryGeoList?.sort{it.geo.name}}"></g:set>
        	<g:set var="count" value="${list.size()}"></g:set>
        	<div class="buttons">
	           <!-- <span class="button"><g:submitToRemote controller="relationDeliveryGeo" action="editMultiple" 
	            		value="Edit" title="Edit"
	            		update="[success:'dvRateCostsPerGeo',failure:'dvRateCostsPerGeo']" disabled="${count==0}"/></span>-->
	            
	            <span class="button"><button id="editDefinerelationBtn" title="Edit">Edit</button></span>
	            
	            <span class="button"><button id="deleteDefinerelationBtn" title="Delete">Delete</button></span>
        	</div>
            
            <div class="list" style="height: 300px; overflow:auto;">
                <table>
                    <thead>
                        <tr>
                        	<th> </th>
                        
                        	<th><g:message code="default.geo.label" default="Geo" /></th>
                        	
                        	<th>Currency</th>
                        	
                            <th>Cost Per Day</th>
                      
                            <th>Rate Per Day</th>
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${list}" status="i" var="relationDeliveryGeoInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                        	<td> <g:checkBox name="check.${relationDeliveryGeoInstance.id}" value="${false}"/> </td>
                        	  
                            <td>${relationDeliveryGeoInstance?.geo?.name}</td>
                            
                            <td>${relationDeliveryGeoInstance?.geo?.currency}</td>
                        
                            <td>${fieldValue(bean: relationDeliveryGeoInstance, field: "costPerDay")}</td>
                        
                            <td>${fieldValue(bean: relationDeliveryGeoInstance, field: "ratePerDay")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
           </g:form>
        
    </body>
</html>
