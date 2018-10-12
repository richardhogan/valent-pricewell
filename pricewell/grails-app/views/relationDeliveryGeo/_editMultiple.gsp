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
				
				jQuery("#saveDefineRelationBtn").click(function()
				{
					if(jQuery("#updateDefineRelationForGeoFrm").valid())
					{
						showLoadingBox();
						jQuery.ajax({
							type: "POST",
							url: "${baseurl}/relationDeliveryGeo/updateMultiple",
							data:jQuery("#updateDefineRelationForGeoFrm").serialize(),
							success: function(data)
							{
								hideLoadingBox();
								if(data == "success")
								{
									//refreshGeoGroupList();
									jQuery.ajax({
										type: "POST",
										url: "${baseurl}/deliveryRole/showsetup",
										data: {id: ${deliveryRoleInstance.id}, source: "${source}"},
										success: function(data){
												if("firstsetup" == "${source}")
												{jQuery('#contents').html('').html(data);}
											else
												{jQuery(xdialogDiv).html(data);jQuery(xdialogDiv).dialog( "open" );}
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
					}
					return false;
				}); 

				jQuery("#cancelDefineRelationBtn").click(function()
				{
					showLoadingBox();
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/deliveryRole/showsetup",
						data: {id: ${deliveryRoleInstance.id}, source: "${source}"},
						success: function(data){
							hideLoadingBox();
							if("firstsetup" == "${source}")
								{jQuery('#contents').html('').html(data);}
							else
								{jQuery(xdialogDiv).html(data);jQuery(xdialogDiv).dialog( "open" );}
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
					});
					
					return false;
				}); 
			});
	   	</script>	
    </head>
    <body>
        <div class="body">
            <h1>Modify Rates & Cost</h1>
            
            <g:hasErrors bean="${relationDeliveryGeoInstance}">
            <div class="errors">
                <g:renderErrors bean="${relationDeliveryGeoInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form name="updateDefineRelationForGeoFrm" >
            	<g:hiddenField name="source" value="${source}"/>
            	<g:hiddenField name="entries" value="${relationsList.size()}"/>
                <div class="dialog">
                    <table>
                    	<thead>
                    		<tr>
                    			<th> GEO </th>
	                    		<th> Currency </th>
	                    		<th>  Cost Per Day</th>
	                    		<th>  Rate Per Day </th>
                    		</tr>
                    	</thead>
                        <tbody>
                        	<g:each in="${relationsList}" status="i" var="rel">
	                        	<tr>
	                        		<td>		 
	                        			<g:textField name="geoName" value="${rel?.geo?.name}" readOnly="true"/>
	                        			<g:hiddenField name="relations.${i}.id" value="${rel?.id}"/>
	     							</td>
	     							<td>
	                        			<g:textField  name="geoCurrency" value="${rel?.geo?.currency}" readOnly="true"/> 
	     							</td>
	     								
	     							<td>
	     								 <g:textField name="relations.${i}.costPerDay" value="${rel?.costPerDay}" class="required number"/>
	     							</td>
	     							
	     							<td>
	     								<g:textField name="relations.${i}.ratePerDay" value="${rel?.ratePerDay}" class="required number"/>
	     							</td>
	                        	</tr>
	                        </g:each>
                        </tbody>
                       </table>	
                       
                <div class="buttons">
                	<span class="button"><button title="Save" id="saveDefineRelationBtn">Save</button></span>
                    <span class="button"><button title="Cancel" id="cancelDefineRelationBtn">Cancel</button></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
