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
								url: "${baseurl}/service/unassignedServiceDesigner",
								success: function(data)
								{
									hideLoadingBox();
									
									if(data == "noMoreServiceLeftToAssignToDesigner"){
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

				jQuery(".saveServiceDesigner").click(function()
				{
					var id = this.id.substring(20);
					
					var serviceDesignerId = jQuery("#serviceDesignerId-"+id).val();
					if(serviceDesignerId == "" || serviceDesignerId == null)
					{
						jAlert('Select service designer first.', 'Assign Service Designer Alert');
					}
					else
					{
						showLoadingBox();
						jQuery.ajax({
							type: "POST",
							url: "${baseurl}/service/saveServiceDesignerfromException",
							data:{id: id, serviceDesignerId: serviceDesignerId},
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
                    <th>Assign Service Designer</th>
                    <th></th>
	            	
	            </tr>
	        </thead>
	        <tbody>
	         	<g:each in="${serviceListNotAssignToServiceDesigner}" status="i" var="serviceProfileInstance">
					
					
		                	<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
						
								<td>${serviceProfileInstance.service.serviceName}</td>
						
						
								<td valign="top">
								
	                        		<g:select name="serviceDesignerId-${serviceProfileInstance?.id}"  noSelection="['': 'Select any one']"
	                        			from="${designerList?.sort()}" optionKey="id" value="${serviceProfileInstance?.serviceDesignerLead?.id}"  class="required"/>
	                    		</td>
                        		
                        		<td>
	                       			<span class="button"><button id="saveServiceDesigner-${serviceProfileInstance?.id}" class="saveServiceDesigner" title="Save Service Designer"> Save </button></span>
                        		</td>
							</tr>
					
				</g:each>
	        </tbody>
	    </table>
	</div>
</div>