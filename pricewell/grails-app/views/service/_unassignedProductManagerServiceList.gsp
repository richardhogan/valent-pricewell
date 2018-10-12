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
								url: "${baseurl}/service/unassignedServiceProductManager",
								success: function(data)
								{
									hideLoadingBox();
									
									if(data == "noMoreServiceLeftToAssignToProductManager"){
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

				jQuery(".saveProductManager").click(function()
				{
					var id = this.id.substring(19);
					
					var productManagerId = jQuery("#productManagerId-"+id).val();
					if(productManagerId == "" || productManagerId == null)
					{
						jAlert('Select product manager first.', 'Assign Product Manager Alert');
					}
					else
					{
						showLoadingBox();
						jQuery.ajax({
							type: "POST",
							url: "${baseurl}/service/saveProductManagerfromException",
							data:{id: id, productManagerId: productManagerId},
							success: function(data)
							{
								hideLoadingBox();
								
								if(data == "success"){
									jQuery(".resultDialog").dialog( "option", "title", "Success" )
									jQuery(".resultDialog").html("Productmanager successfully assigned.").dialog("open");
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
	            
	                <th><g:message code="service.serviceName.label" default="Service Name" /></th>
                        
                    <!--<th>${message(code: 'portfolio.dateModified.label', default: 'Date Modified')}</th>
                
                    <th>${message(code: 'portfolio.stagingStatus.label', default: 'Staging Status')}</th>-->
                    <th>Assign Product Manager</th>
                    <th></th>
	            	
	            </tr>
	        </thead>
	        <tbody>
	         	<g:each in="${serviceListNotAssignToProductManager}" status="i" var="serviceProfileInstance">
					
					
		                	<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
						
								<td>${serviceProfileInstance.service.serviceName}</td>
						
						
								<td valign="top">
								
	                        		<g:select name="productManagerId-${serviceProfileInstance?.id}"  noSelection="['': 'Select any one']"
	                        			from="${productManagerList?.sort()}" optionKey="id" value="${serviceProfileInstance?.service?.productManager?.id}"  class="required"/>
	                    		</td>
                        		
                        		<td>
	                       			<span class="button"><button id="saveProductManager-${serviceProfileInstance?.id}" class="saveProductManager" title="Save Product Manager"> Save </button></span>
                        		</td>
							</tr>
					
				</g:each>
	        </tbody>
	    </table>
	</div>
</div>