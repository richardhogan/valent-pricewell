<%
	def baseurl = request.siteUrl
%>
<script>

			jQuery(document).ready(function()
			{			 
				jQuery( ".resultDialog" ).dialog(
			 	{
					modal: true,
					autoOpen: false,
					resizable: false,
					close: function( event, ui ) {
						jQuery(".resultDialog").html('');
					},
					buttons: 
					{
						OK: function() 
						{
							jQuery(".resultDialog").dialog("close");
							showLoadingBox();
							jQuery.ajax({
								type: "POST",
								url: "${baseurl}/geo/unassignedTerritory",
								success: function(data)
								{
									hideLoadingBox();
									
									if(data == "noMoreTerritoryLeftToAssign"){
										jQuery("#dvExceptionReport").dialog("close");
									}
									else{
										jQuery("#dvExceptionReport").html("").html(data);
									}
								}, 
								error:function(XMLHttpRequest,textStatus,errorThrown){
									hideLoadingBox();
									alert("Error while saving");
								}
							});
							
												
							return false;
						}
					}
				 });

				jQuery(".saveGeo").click(function()
				{
					var id = this.id.substring(8);
					
					var geoId = jQuery("#geoId-"+id).val();
					//alert(geoId);
					if(geoId == "" || geoId == null)
					{
						jAlert('Select GEO first.', 'Assign GEO Alert');
					}
					else
					{
						showLoadingBox();
						jQuery.ajax({
							type: "POST",
							url: "${baseurl}/geo/saveGeo",
							data:{id: id, geoId: geoId},
							success: function(data)
							{
								hideLoadingBox();
								
								if(data == "success"){
									jQuery(".resultDialog").dialog( "option", "title", "Success" )
									jQuery(".resultDialog").html("GEO successfully assigned.").dialog("open");
									//jQuery("#dvExceptionReport").dialog("close");
								}
								else{
									jQuery('#portfolioErrors').html(data);
									jQuery('#portfolioErrors').show();
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

					
			});

			 
  		</script>
<div class="body">   
	<div class="resultDialog"></div>
	<div class="list">
	    <table class="display">
	        <thead>
	            <tr>
		            <th>${message(code: 'geo.name.label', default: 'Name')}</th>
                        
                    <!--<th>${message(code: 'geo.description.label', default: 'Description')}</th>
                
                	<th>${message(code: 'geo.country.label', default: 'Country')}</th>-->
                	<th> Assign GEO</th>
                	<th></th>
	            </tr>
	        </thead>
	        <tbody>
	         	<g:each in="${territoryList}" status="i" var="geoInstance">
	                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
	                	
	                	
	                	<td>${fieldValue(bean: geoInstance, field: "name")}</td>
	                
	                    <!--<td>${fieldValue(bean: geoInstance, field: "description")}</td>
	                
	                	<td>
	                		<g:if test="${geoInstance?.country?.size() == 3 }">
	                			<g:country code="${geoInstance?.country}"/>
	                		</g:if>
	               		</td>-->
	               		<td valign="top">
								
	                        		<g:select name="geoId-${geoInstance?.id}"  noSelection="['': 'Select any one']"
	                        			from="${geoList?.sort()}" optionKey="id" value="${geoInstance?.geoGroup?.id}"  class="required"/>
	                    		</td>
                        		
                        		<td>
	                       			<span class="button"><button id="saveGeo-${geoInstance?.id}" class="saveGeo" title="Save GEO"> Save </button></span>
                        		</td>
	                </tr>
            	</g:each>
	        </tbody>
	    </table>
	</div>
</div>