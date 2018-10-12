<%
	def baseurl = request.siteUrl
%>
	
	<script type="text/javascript">
   		
		function showList(type)
		{
			jQuery.ajax({
				type: "POST",
				url: "${baseurl}/objectType/listsetup",
				data: {type: type, source: 'firstSetup'},
				success: function(data){jQuery("#mainServicePropertiesTypesTab").html(data);}, 
				error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
			});
			
			return false;
		}

	</script>





<ul class="navigation" id="plain">
	<%--<li class="navigation_first">
		<a id="serviceDeliverableTypeList" onclick="showList('serviceDeliverable');" class="hyperlink" title="Service Deliverable Types">Service Deliverable Types</a>
	--%>
		<!--<g:remoteLink class="hyperlink" controller="objectType" action="listsetup" params="[type: 'serviceDeliverable', source: 'firstSetup']" title="Service Deliverable Types" update="mainServicePropertiesTypesTab">Service Deliverable Types</g:remoteLink>-->
	<%--</li>--%>
	
	<li class="navigation_first">
		<a id="deliverablePhaseList" onclick="showList('deliverablePhase');" class="hyperlink" title="Service Delivery Phases">Service Delivery Phases</a>
	</li>
	
	<%--<li>
		<a id="serviceActivityTypeList" onclick="showList('serviceActivity');" class="hyperlink" title="Service Activity Types">Service Activity Types</a>
		--%>
		<!--<g:remoteLink class="hyperlink" controller="objectType" action="listsetup" params="[type: 'serviceActivity', source: 'firstSetup']" title="Service Activity Types" update="mainServicePropertiesTypesTab">Service Activity Types</g:remoteLink>-->
	<%--</li>
	
	<li>
		
		<a id="serviceUnitOfSales" onclick="showList('serviceUnitOfSale');" class="hyperlink" title="Service Unit of Sales">Service Unit of Sales</a>
	--%>	
		<!--<g:remoteLink class="hyperlink" controller="objectType" action="listsetup" params="[type: 'serviceUnitOfSale', source: 'firstSetup']" title="Service Unit of Sales" update="mainServicePropertiesTypesTab">Service Unit of Sales</g:remoteLink>-->
	<%--</li>--%>
	
	<li>
		<a id="sowMilestoneList" onclick="showList('sowMilestone');" class="hyperlink" title="SOW Milestones">SOW Milestones</a>
		
		<!--<g:remoteLink class="hyperlink" controller="objectType" action="listsetup" params="[type: 'sowMilestone', source: 'firstSetup']" title="SOW Milestones" update="mainServicePropertiesTypesTab">SOW Milestones</g:remoteLink>-->
	</li>
	
	<li class="navigation_last"><g:remoteLink class="hyperlink" controller="objectType" action="createsetup" params="[source: 'firstSetup']" title="Create Default Entity" update="mainServicePropertiesTypesTab">Create Default Entity</g:remoteLink></li>
</ul>