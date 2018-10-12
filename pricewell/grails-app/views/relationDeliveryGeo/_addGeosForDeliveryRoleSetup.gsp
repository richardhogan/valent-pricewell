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
					
				jQuery( "#tabsDiv" ).tabs();

				jQuery("#saveGeoForDeliveryRole").click(function(){
					if(jQuery("#createRelationDeliveryGeo").valid())
					{
						showLoadingBox();
						jQuery.ajax({
							type: "POST",
							url: "${baseurl}/relationDeliveryGeo/saveMultiple",
							data:jQuery("#createRelationDeliveryGeo").serialize(),
							success: function(data)
							{
								hideLoadingBox();
								if(data == "success")
								{
	
									jQuery.ajax({
										type: "POST",
										url: "${baseurl}/deliveryRole/showsetup",
										data: {id: ${deliveryRoleInstance.id}, source: "${source}"},
										success: function(data)
										{
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
					}
					
					return false;
				}); 

				jQuery("#cancelGeoDeliveryRole").click(function()
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
            <h1>Define Rates & Cost for ${deliveryRoleInstance.name}</h1>
            
            
            <g:form name="createRelationDeliveryGeo">
            	<g:hiddenField name="source" value="${source}"/>
            	<g:hiddenField name="entries" value="${geosList.size()}"/>
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
                        	<g:each in="${geosList}" status="i" var="geo">
	                        	<tr>
	                        		<td>
	                        			<g:textField name="geoName" value="${geo?.name}" readOnly="true"/> 
	                        			<g:hiddenField name="relations.${i}.deliveryRole.id" value="${deliveryRoleInstance.id}"/>
	                        			<g:hiddenField name="relations.${i}.geo.id" value="${geo.id}"/>
	     							</td>
	     							<td>
	                        			<g:textField  name="geoCurrency" value="${geo?.currency}" readOnly="true"/> 
	     							</td>
	     								
	     							<td>
	     								 <g:textField name="relations.${i}.costPerDay" value="" class="required number"/>
	     							</td>
	     							
	     							<td>
	     								<g:textField name="relations.${i}.ratePerDay" value="" class="required number"/>
	     							</td>
	                        	</tr>
	                        </g:each>
                        </tbody>
                       </table>	
                <div class="buttons">
                    <!-- <span class="button"><g:submitButton name="create" class="save" value="save" /></span>-->
                    <span class="button"><button title="Save" id="saveGeoForDeliveryRole"> Save </button></span>
                    <span class="button"><button title="Cancel" id="cancelGeoDeliveryRole">Cancel</button></span>
                    <!-- <span class="button"><g:link name="cancel" class="cancel" action="show" controller="deliveryRole" id="${deliveryRoleInstance?.id}">Cancel </g:link></span>-->
                </div>
            </g:form>
        </div>
    </body>
</html>
