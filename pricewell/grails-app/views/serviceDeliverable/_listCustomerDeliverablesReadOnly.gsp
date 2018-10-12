<%
	def baseurl = request.siteUrl
%>
<g:setProvider library="prototype"/>
<script>
jQuery(function() {

	var icons = {
			header: "ui-icon-circle-arrow-e",
			headerSelected: "ui-icon-circle-arrow-s"
		};
	
	jQuery( "#accordion1" ).accordion({
		icons: icons,
		autoHeight: false,
		navigation: true
	});
	
	jQuery( ".accordionContent" ).height(160);
});
</script>
<style>
		
	#accordion1 {
		width: 100% auto;
		
	}

</style>
<div id="accordion1">
	<g:each in="${serviceProfileInstance?.listCustomerDeliverables(params)}" status="i" var="del">
		<h2><a id="${del.id}" href="${baseurl}/serviceActivity/listDeliverableActivities?id=${del.id}">Deliverable: ${del.name} [Type: ${del.type}]</a></h2>
		<div class="accordionContent">
			<g:render template="/serviceActivity/listDeliverableActivitiesReadOnly" model="['activitiesList': del.listServiceActivities(params)]"></g:render>
		</div>
	</g:each>
</div>