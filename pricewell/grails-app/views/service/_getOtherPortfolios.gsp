<%
	def baseurl = request.siteUrl
%>
<html>
	<script>
		jQuery(document).ready(function()
	    {		   
			
			jQuery( "#successToMoveDialog" ).dialog(
			{
				modal: true,
				autoOpen: false,
				buttons: {
					OK: function() 
					{
						jQuery( "#successToMoveDialog" ).dialog( "close" );
						location.reload();
						return false;
					}
				}
			});

			jQuery( "#failureMoveDialog" ).dialog(
			{
				modal: true,
				autoOpen: false,
				buttons: {
					OK: function() {
						jQuery( "#failureMoveDialog" ).dialog( "close" );
						return false;
					}
				}
			});
			
			jQuery("#moveServiceToOtherPortfolio").validate();
			
			jQuery("#moveTo").click(function()
	  		{
				if(jQuery('#moveServiceToOtherPortfolio').validate().form())
				{					
					jQuery.post( '${baseurl}/service/saveOtherPortfolios', 
                				  jQuery("#moveServiceToOtherPortfolio").serialize(),
							      function( data ) 
							      {
							      	    if(data == "success"){
											jQuery( "#dvMove" ).dialog( "close" );    		                   		
					                   		jQuery( "#successToMoveDialog" ).dialog("open");
										} else{
											jQuery( "#dvMove" ).dialog( "close" );
									    	jQuery( "#failureMoveDialog" ).dialog("open");
										}
							          
							      });return false;
				}	 
	  		}); 
	    });
		    
  </script>


	<body>
	
		
		<div id="successToMoveDialog" title="Success">
			<p><g:message code="serviceMoveToOtherPortfolio.message.success.dialog" default=""/></p>
		</div>
	
		<div id="failureMoveDialog" title="Failure">
			<p><g:message code="serviceMoveToOtherPortfolio.message.failure.dialog" default=""/></p>
		</div>
		
		<g:form action="saveOtherPortfolios" name="moveServiceToOtherPortfolio">
			<g:hiddenField name="serviceId"  value="${serviceProfile?.service?.id}" />
			<table>
				<td><label>Move To Portfolio</label></td>
				
				<td>&nbsp;&nbsp;</td>
				
				<td> <g:select name="PortfolioId" from="${portfolioList}" value="" optionKey="id" noSelection="['': 'Select any one']" class="required"/></td>
				
			</table>
			
			<div>
		      <span class="buttons"><button id="moveTo" title="Move To Portfolio"> Move </button></span>
		    </div>
		</g:form>
		
		
	</body>

</html>