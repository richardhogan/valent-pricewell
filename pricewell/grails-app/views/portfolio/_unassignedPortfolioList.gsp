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
								url: "${baseurl}/portfolio/unassignedPortfolio",
								success: function(data)
								{
									hideLoadingBox();
									
									if(data == "noMorePortfolioLeftToAssign"){
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

				jQuery(".savePortfolioManager").click(function()
				{
					var id = this.id.substring(21);
					
					var portfolioManagerId = jQuery("#portfolioManagerId-"+id).val();
					if(portfolioManagerId == "" || portfolioManagerId == null)
					{
						jAlert('Select portfolio manager first.', 'Assign Portfolio Manager Alert');
					}
					else
					{
						showLoadingBox();
						jQuery.ajax({
							type: "POST",
							url: "${baseurl}/portfolio/savePortfolioManager",
							data:{id: id, portfolioManagerId: portfolioManagerId},
							success: function(data)
							{
								hideLoadingBox();
								
								if(data == "success"){
									jQuery(".resultDialog").dialog( "option", "title", "Success" )
									jQuery(".resultDialog").html("Portfolio Manager successfully assigned.").dialog("open");
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
	            
	                <th>${message(code: 'portfolio.portfolioName.label', default: 'Name')} </th>
                        
                    <!--<th>${message(code: 'portfolio.dateModified.label', default: 'Date Modified')}</th>
                
                    <th>${message(code: 'portfolio.stagingStatus.label', default: 'Staging Status')}</th>-->
                    <th>Assign Portfolio Manager</th>
                    <th></th>
	            	
	            </tr>
	        </thead>
	        <tbody>
	         	<g:each in="${portfolioList}" status="i" var="portfolioInstance">
					
					
		                	<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
						
								<td>${fieldValue(bean: portfolioInstance, field: "portfolioName")}</td>
						
						
								<td valign="top">
								
	                        		<g:select name="portfolioManagerId-${portfolioInstance?.id}"  noSelection="['': 'Select any one']"
	                        			from="${portfolioManagerList?.sort {it.profile.fullName}}" optionKey="id" value="${portfolioInstance?.portfolioManager?.id}"  class="required"/>
	                    		</td>
                        		
                        		<td>
	                       			<span class="button"><button id="savePortfolioManager-${portfolioInstance?.id}" class="savePortfolioManager" title="Save Portfolio"> Save </button></span>
                        		</td>
							</tr>	
					
				</g:each>
	        </tbody>
	    </table>
	</div>
</div>