<%@ page import="com.valent.pricewell.Service"%>
<%@ page import="com.valent.pricewell.ServiceProfile"%>

<%
	def baseurl = request.siteUrl
%>

<g:setProvider library="prototype"/>

<script>
	jQuery(function() {

	  	jQuery(".territoryId").change(function () 
    	{
	    	if(this.value != "" && this.value != null)
		    {
	    		jQuery.ajax({type:'POST',data: {territoryId: this.value, serviceProfileId: ${serviceProfileInstance?.id}, type: "readOnly"},
					 url:'${baseurl}/serviceProfileSOWDef/getTerritorySOWDefinition',
					 success:function(data,textStatus){jQuery('#territorySOWDefinitionListReadOnly').html(data);},
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
			}else{
	    		jQuery('#territorySOWDefinitionListReadOnly').html("");
			} 
    	});
	});

	function getDefaultSOWDefinition()
	{
		jQuery.ajax({
			type: "POST",
			url: "${baseurl}/serviceProfileSOWDef/getDefaultSOWDefinition",
			data: {'id': ${serviceProfileInstance?.id}, 'type': 'readOnly'},
			success: function(data)
			{
				jQuery('.territoryId').val('');
				jQuery("#territorySOWDefinitionListReadOnly").html(data);
			}, 
			error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
		});
		
		return false;
	}
</script>


<div class="plain">
	<g:set var="calculatedEstimate"
		value="${serviceProfileInstance?.calculateTotalEstimatedTime()}" />
	<table>
		<tbody>
			<tr class="prop">

				<td valign="top" class="name">
					<label><g:message
						code="service.serviceName.label" default="Service Name" /></label>
				</td>

				<td valign="top" class="value">
					${fieldValue(bean: serviceProfileInstance, field: "service.serviceName")}
				</td>


				<td valign="top" class="name">
					<label><g:message
						code="service.skuName.label" default="Sku Name" /></label>
				</td>

				<td valign="top" class="value">
					${fieldValue(bean: serviceProfileInstance, field: "service.skuName")}
				</td>

			</tr>
			<tr>
				<td valign="top" class="name">
					<label><g:message code="portfolio.label"
						default="Portfolio" /></label>
				</td>

				<td valign="top" class="value">
					${serviceProfileInstance.service.portfolio.portfolioName}
				</td>

				<td valign="top" class="name">
					<label><g:message
						code="serviceProfile.stagingStatus.label" default="Staging Status" />
						</label>
				</td>

				<td>
					${fieldValue(bean: serviceProfileInstance, field: "stagingStatus")}
				</td>
			</tr>

			<tr class="prop">

				<td valign="top" class="name">
					<label><g:message
						code="serviceProfile.unitOfSale.label" default="Unit Of Sale" /></label>
				</td>

				<td valign="top" class="value">
					${fieldValue(bean: serviceProfileInstance, field: "unitOfSale")}
				</td>

				<td valign="top" class="name">
					<label><g:message
						code="serviceProfile.baseUnits.label" default="Base Units" /></label>
				</td>

				<td valign="top" class="value">
					${fieldValue(bean: serviceProfileInstance, field: "baseUnits")}
				</td>

			</tr>
			
			<tr class="prop">
				<td valign="top" class="name"><label
					for="totalEstimateInHoursFlat"><g:message
							code="serviceProfile.totalEstimateInHoursFlat.label"
							default="totalEstimateInHoursFlat" />
				</label></td>
				<td valign="top" class="value">
					${fieldValue(bean: serviceProfileInstance, field: 'totalEstimateInHoursFlat')}
				</td>

				<td valign="top" class="name"><label
					for="totalEstimateInHoursPerBaseUnits"><g:message
							code="serviceProfile.totalEstimateInHoursPerBaseUnits.label"
							default="totalEstimateInHoursPerBaseUnits" />
				</label></td>
				<td valign="top" class="value">
					${fieldValue(bean: serviceProfileInstance, field: 'totalEstimateInHoursPerBaseUnits')}
				</td>
			</tr>

			<tr>

				<td class="reduced"><label> <g:message
							code="serviceProfile.dateCreated.label" default="Date Created" />
						</label>

					</td>
					<td>
						<g:formatDate format="MMMMM d, yyyy" date="${serviceProfileInstance?.dateCreated}" /> 
					</td>
					<td class="reduced"><label> <g:message
							code="serviceProfile.dateModified.label" default="Date Modified" />
						</label>
					</td>
					<td>		
					 <g:formatDate format="MMMMM d, yyyy" date="${serviceProfileInstance?.dateModified}" /></td>
				
			</tr>
			
			<tr>
				
				<td valign="top" class="name"><label><g:message
						code="serviceProfile.premiumPercent.label"
						default="Premium Percentage" /></label></td>

				<td valign="top" class="value">
					${fieldValue(bean: serviceProfileInstance, field: "premiumPercent")}%</td>

			</tr>

		</tbody>
	</table>
	
	<h2> Service Deliverables</h2>
	<div class="list" id="mainCustomerDeliverablesTab">
		
		<table>
			<thead>
				<tr><b>
					<th>SequenceOrder</th>
					<th>Name</th>
					<th>Type</th>
					<th>Description</th></b>
				<!--	<util:remoteSortableColumn controller="serviceDeliverable"
						action="listServiceDeliverables" property="sequenceOrder"
						defaultOrder="asc"
						title="${message(code: 'serviceDeliverable.sequenceOrder.label', default: 'SequenceOrder')}"
						titleKey="sequenceOrder"
						params="[serviceProfileId: serviceProfileInstance?.id]"
						update="[success:'mainCustomerDeliverablesTab',failure:'mainCustomerDeliverablesTab']" />

					<util:remoteSortableColumn controller="serviceDeliverable"
						action="listServiceDeliverables" property="name"
						defaultOrder="asc"
						title="${message(code: 'serviceDeliverable.name.label', default: 'Name')}"
						titleKey="name"
						params="[serviceProfileId: serviceProfileInstance?.id]"
						update="[success:'mainCustomerDeliverablesTab',failure:'mainCustomerDeliverablesTab']" />

					<util:remoteSortableColumn controller="serviceDeliverable"
						action="listServiceDeliverables" property="type"
						defaultOrder="asc"
						title="${message(code: 'serviceDeliverable.type.label', default: 'Type')}"
						titleKey="type"
						params="[serviceProfileId: serviceProfileInstance?.id]"
						update="[success:'mainCustomerDeliverablesTab',failure:'mainCustomerDeliverablesTab']" />

					<util:remoteSortableColumn controller="serviceDeliverable"
						action="listServiceDeliverables" property="description"
						defaultOrder="asc"
						title="${message(code: 'serviceDeliverable.description.label', default: 'Description')}"
						titleKey="description"
						params="[serviceProfileId: serviceProfileInstance?.id]"
						update="[success:'mainCustomerDeliverablesTab',failure:'mainCustomerDeliverablesTab']" />-->
					
				</tr>
			</thead>
			<tbody>

				<g:set var="tmpDeliverablesList"
					value="${deliverablesList? deliverablesList: serviceProfileInstance?.listCustomerDeliverables()}" />

				<g:each in="${tmpDeliverablesList}" status="i"
					var="serviceDeliverableInstance">
					<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

						<td>
							${fieldValue(bean: serviceDeliverableInstance, field: "sequenceOrder")}
						</td>

						<td>
							${fieldValue(bean: serviceDeliverableInstance, field: "name")}
						</td>
						
						<td>
							${fieldValue(bean: serviceDeliverableInstance, field: "type")}
						</td>

						<td>
							${fieldValue(bean: serviceDeliverableInstance, field: "description")}
						</td>

				</g:each>
			</tbody>
		</table>
	</div>
	
	<h2> <g:message code="serviceProfile.definition.label" default="Scope Definition Language:" /></h2>
	
	
	<div id="scope_definition">
		<div class="nav">
			
				<g:if test="${territoryList?.size() > 0}">
					<b>Select Territory </b>&nbsp;&nbsp; <g:select name="territoryId" class="territoryId" from="${territoryList?.sort {it.name}}" value="" optionKey="id" optionValue="name" noSelection="['': 'Select Any One']"/>
				</g:if>
				
				<g:if test="${hasDefaultSOWDefinition}">
					<span class="button">
				
						<a id="idgetDefaultSOWDefinition" onclick="getDefaultSOWDefinition();" class="buttons.button button" title="Show Default SOW Language">Default Language</a>
						
					</span>
				</g:if>
							
		</div>
		
		<div  id="territorySOWDefinitionListReadOnly">
			<g:if test="${hasDefaultSOWDefinition}">
				<g:render template="../service/showDefinition" model="['serviceProfileInstance': serviceProfileInstance, 'defaultSOWDefinition': defaultSowDef, 'readOnly': readOnly]"/>
			</g:if>
		</div>
	</div>

</div>