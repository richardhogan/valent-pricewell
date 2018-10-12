<script>
	jQuery(function() {
		jQuery( "#accordion" ).accordion();
		

		jQuery( ".accordionContent" ).height(200)
	});
	</script>
	
<div id="accordion">
	<g:each in="${serviceProfileInstance?.listCustomerDeliverables(params)}" status="i" var="del">
		<h3><a href="#">Deliverable: ${del.name} [type: ${del.type}]</a></h3>
		<div class="accordionContent">
			<g:set var="tmpActivitiesList" value="${del.listServiceActivities(params)}" />
			
			<g:if test="${tmpActivityList && tmpActivityList.size() > 0}">			
				<g:render template="/serviceActivity/listDeliverableActivities" model="['serviceProfileInstance': serviceProfileInstance, 'serviceDeliverableInstance': del, 'activitiesList': tmpActivitiesList]"/>
			</g:if>
			<g:else>
				<g:render template="/serviceActivity/createDeliverableActivity" model="['serviceProfileInstance': serviceProfileInstance, 'serviceDeliverableId': serviceDeliverableInstance.id, 'deliverable': del, 'activitiesList': tmpActivitiesList]"/>
			</g:else>
		</div>
	</g:each>
</div>

<!--  
<div id="dvSelectCustomerDeliverables">
	Select Deliverable 
		<g:select name="selectCustomerDeliverableId" 
			from="${serviceProfileInstance?.listCustomerDeliverables(params)}" optionKey="id"
			value="{selectCustomerDeliverables}" style="width:200px"
			onchange="${remoteFunction(controller: 'serviceActivity', 
				action: 'listSelectedDeliverableActivities',
				update: 'delActivity',
				params: '\'selectCustomerDeliverableId=\' + this.value')}"
		/>	 
		
</div>

<div id="delActivity">
<g:set var="tmpActivityList" value="${serviceProfileInstance?.listCustomerDeliverables()?.toArray().getAt(0).listServiceActivities(params)}" />
	<g:if test="${tmpActivityList && tmpActivityList.size() > 0}">
		<g:render template="/serviceActivity/listDeliverableActivities" model="['serviceProfileInstance': serviceProfileInstance, 'serviceDeliverableInstance': serviceDeliverableInstance, 'activitiesList': activitiesList]"/>
		
	</g:if>
	<g:else>
		<g:render template="/serviceActivity/createDeliverableActivity" model="['serviceProfileInstance': serviceProfileInstance, 'serviceDeliverableId': serviceDeliverableInstance.id, 'deliverable': serviceDeliverableInstance, 'activitiesList': activitiesList]"/>
		
	</g:else>
	

</div>
-->