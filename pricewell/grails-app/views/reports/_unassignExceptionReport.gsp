<%
	def baseurl = request.siteUrl
%>
<g:set var="unassignPortfolios" value="${unassignException['unassignPortfolios']}" />
<g:set var="unassignGeos" value="${unassignException['unassignGeos']}" />
<g:set var="unassignTerritories" value="${unassignException['unassignTerritories']}" />
<g:set var="unassignProductManagerServices" value="${unassignException['unassignProductManagerServices']}" />
<g:set var="unassignedServiceDesignerServices" value="${unassignException['unassignedServiceDesignerServices']}" />

<script>
	jQuery(document).ready(function()
	{
		jQuery( "#dvExceptionReport" ).dialog(
	 	{
			autoOpen: false,
			maxHeight: 400,
			modal: true,
			minWidth: 800,
			close: function( event, ui ) {
					jQuery(this).html('');
					refreshExceptionReport();
					//window.location.href = '${baseurl}/home';
				}
		});

		jQuery( "#unassignPortfoliosBtn" ).click(function() 
		{
   			jQuery('#dvExceptionReport').html("Loading, Please wait.........");
   			jQuery('#dvExceptionReport').dialog( "option", "title", 'Unassigned Portfolio List' );
			jQuery("#dvExceptionReport").dialog("open");
   			jQuery.ajax({type:'POST',
				 url:'${baseurl}/portfolio/unassignedPortfolio',
				 success:function(data,textStatus)
				 {
					 jQuery('#dvExceptionReport').html(data);
				 },
				 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
		});

		jQuery( "#unassignGeosBtn" ).click(function() 
		{
   			jQuery('#dvExceptionReport').html("Loading, Please wait.........");
   			jQuery('#dvExceptionReport').dialog( "option", "title", 'Unassigned GEO List' );
			jQuery("#dvExceptionReport").dialog("open");
   			jQuery.ajax({type:'POST',
				 url:'${baseurl}/geoGroup/unassignedGeo',
				 success:function(data,textStatus)
				 {
					 jQuery('#dvExceptionReport').html(data);
				 },
				 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
		});
		
		jQuery( "#unassignProductManagerBtn" ).click(function() 
		{
   			jQuery('#dvExceptionReport').html("Loading, Please wait.........");
   			jQuery('#dvExceptionReport').dialog( "option", "title", 'Unassigned Service List' );
			jQuery("#dvExceptionReport").dialog("open");
   			jQuery.ajax({type:'POST',
				 url:'${baseurl}/service/unassignedServiceProductManager',
				 success:function(data,textStatus)
				 {
					 jQuery('#dvExceptionReport').html(data);
				 },
				 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
		});
		
		jQuery( "#unassignServiceDesignerBtn" ).click(function() 
		{
   			jQuery('#dvExceptionReport').html("Loading, Please wait.........");
   			jQuery('#dvExceptionReport').dialog( "option", "title", 'Unassigned Service List' );
			jQuery("#dvExceptionReport").dialog("open");
   			jQuery.ajax({type:'POST',
				 url:'${baseurl}/service/unassignedServiceDesigner',
				 success:function(data,textStatus)
				 {
					 jQuery('#dvExceptionReport').html(data);
				 },
				 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
		});

		jQuery( "#unassignTerritoriesBtn" ).click(function() 
		{
   			jQuery('#dvExceptionReport').html("Loading, Please wait.........");
   			jQuery('#dvExceptionReport').dialog( "option", "title", 'Unassigned Territory List' );
			jQuery("#dvExceptionReport").dialog("open");
   			jQuery.ajax({type:'POST',
				 url:'${baseurl}/geo/unassignedTerritory',
				 success:function(data,textStatus)
				 {
					 jQuery('#dvExceptionReport').html(data);
				 },
				 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
		});
	});
</script>
<div id="dvExceptionReport" ></div>
<div class="body">
	<div class="list" style="height: 290px; padding: 2px; border-color: #666986; margin: 15px 10px 20px 13px; border-radius: 5px; border-style: solid;	border-width: medium;">
		<table class="display">
			<tbody>
				<g:if test="${unassignPortfolios.size() > 0 }">
					<tr class="odd">
						There <g:if test="${unassignPortfolios.size() == 1}">is</g:if><g:else>are</g:else> ${unassignPortfolios.size()} <g:if test="${unassignPortfolios.size() == 1}">Portfolio</g:if><g:else>Portfolios</g:else> not assign to Portfolio Manager.
						<a href="#" id="unassignPortfoliosBtn" type="button" class="hyperlink">View</a>
						<br>
					</tr>
				</g:if>
				
				<g:if test="${unassignGeos.size() > 0 }">
					<tr class="even">
						There <g:if test="${unassignGeos.size() == 1}">is</g:if><g:else>are</g:else> ${unassignGeos.size()} <g:if test="${unassignGeos.size() == 1}">GEO</g:if><g:else>GEOs</g:else> not assign to General Manager.
						<a href="#" id="unassignGeosBtn" type="button" class="hyperlink">View</a>
						<br>
					</tr>
				</g:if>
				
				<g:if test="${unassignTerritories.size() > 0 }">
					<tr class="odd">
						There <g:if test="${unassignTerritories.size() == 1}">is</g:if><g:else>are</g:else> ${unassignTerritories.size()} <g:if test="${unassignTerritories.size() == 1}">Territory</g:if><g:else>Territories</g:else> not assign to GEOs.
						<a href="#" id="unassignTerritoriesBtn" type="button" class="hyperlink">View</a>
						<br>
					</tr>
				</g:if>
				<g:if test="${unassignProductManagerServices.size() > 0 }">
					<tr class="odd">
						There <g:if test="${unassignProductManagerServices.size() == 1}">is</g:if><g:else>are</g:else> ${unassignProductManagerServices.size()} <g:if test="${unassignProductManagerServices.size() == 1}">Service</g:if><g:else>Services</g:else> not assign ProductManager.
						<a href="#" id="unassignProductManagerBtn" type="button" class="hyperlink">View</a>
						<br>
					</tr>
				</g:if>
				<g:if test="${unassignedServiceDesignerServices.size() > 0 }">
					<tr class="odd">
						There <g:if test="${unassignedServiceDesignerServices.size() == 1}">is</g:if><g:else>are</g:else> ${unassignedServiceDesignerServices.size()} <g:if test="${unassignedServiceDesignerServices.size() == 1}">Service</g:if><g:else>Services</g:else> not assign ServiceDesigner.
						<a href="#" id="unassignServiceDesignerBtn" type="button" class="hyperlink">View</a>
						<br>
					</tr>
				</g:if>
			</tbody>
		</table>
		
	</div>
</div>
