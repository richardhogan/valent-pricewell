<table>
	<tr>
		<td valign="top" class="name"><g:message
				code="service.name.label" default="Service Name" />
		</td>
		<td>
			${serviceProfileInstance.service.serviceName}
		</td>

		<td valign="top" class="name"><g:message
				code="serviceProfile.revision.label" default="Revision#" />
		</td>

		<td>
			${serviceProfileInstance.revision}
		</td>

	</tr>
	<tr class="prop">
		<td valign="top" class="name"><g:message
				code="service.skuName.label" default="Sku Name" />
		</td>
		<td valign="top" class="value">
			${fieldValue(bean: serviceProfileInstance, field: "service.skuName")}
		</td>

		<td valign="top" class="name"><g:message
				code="portfolio.label" default="Portfolio" />
		</td>
		<td valign="top" class="value">
			${serviceProfileInstance.service.portfolio.portfolioName}
		</td>
	</tr>


	<tr class="prop">

		<td valign="top" class="name"><g:message
				code="serviceProfile.unitOfSale.label" default="Unit Of Sale" />
		</td>

		<td valign="top" class="value">
			${fieldValue(bean: serviceProfileInstance, field: "unitOfSale")}
		</td>

		<td valign="top" class="name"><g:message
				code="serviceProfile.baseUnits.label" default="Base Units" />
		</td>

		<td valign="top" class="value">
			${fieldValue(bean: serviceProfileInstance, field: "baseUnits")}
		</td>

	</tr>

	<tr>

		<td valign="top" class="name"><g:message
				code="serviceProfile.premiumPercent.label"
				default="Premium Percentage" /></td>

		<td valign="top" class="value">
			${fieldValue(bean: serviceProfileInstance, field: "premiumPercent")}%</td>

		<td valign="top" class="name"><g:message
				code="serviceProfile.stagingStatus.label"
				default="Staging Status" /></td>
		<td>
			${fieldValue(bean: serviceProfileInstance, field: "stagingStatus")}
		</td>

	</tr>

	<tr class="prop">
		<td valign="top" class="name"><g:message
				code="serviceProfile.totalEstimateInHoursFlat.label"
				default="Total Estimate In Hours (Flat)" /></td>

		<td valign="top" class="value">
			${fieldValue(bean: serviceProfileInstance, field: "totalEstimateInHoursFlat")}
		</td>



		<g:if test="${calculatedEstimate}">

			<td valign="top" class="name">Actual Hours per base Units</td>

			<td valign="top" class="value">
				${calculatedEstimate["totalFlat"]}
			</td>


		</g:if>


	</tr>

	<tr class="prop">
		<td valign="top" class="name"><g:message
				code="serviceProfile.totalEstimateInHoursPerBaseUnits.label"
				default="Additional Time In Hours (Per Unit)" /></td>

		<td valign="top" class="value">
			${fieldValue(bean: serviceProfileInstance, field: "totalEstimateInHoursPerBaseUnits")}
		</td>



		<g:if test="${calculatedEstimate}">

			<td valign="top" class="name">Actual additional Hours Per
				Unit</td>

			<td valign="top" class="value">
				${calculatedEstimate["totalExtra"]}
			</td>

		</g:if>


	</tr>

	<tr>
		<td valign="top" class="name"><g:message
				code="serviceProfile.dateModified.label"
				default="Date Modified" /></td>

		<td><g:formatDate format="MMMMM d, yyyy" date="${serviceProfileInstance?.dateModified}" /></td>

		<td valign="top" class="name"><g:message
				code="serviceProfile.dateCreated.label" default="Date Created" />
		</td>

		<td valign="top" class="value"><g:formatDate format="MMMMM d, yyyy" date="${serviceProfileInstance?.dateCreated}" /></td>
	</tr>


	<tr class="prop">
		<td valign="top" class="name"><g:message
				code="serviceProfile.productManager.label"
				default="Product Manager" /></td>

		<td valign="top" class="value">
			${fieldValue(bean: serviceProfileInstance, field: "service.productManager")}
		</td>

		<td valign="top" class="name"><g:message
				code="serviceProfile.serviceDesignerLead.label"
				default="Service Designer Lead" /></td>

		<td valign="top" class="value">
			${fieldValue(bean: serviceProfileInstance, field: "serviceDesignerLead")}
		</td>

	</tr>

	<tr class="prop">
		<td valign="top" class="name">Search Tags</td>

		<td valign="top" class="value">
			${serviceProfileInstance.service?.tags}
		</td>
		<g:if test="${serviceProfileInstance.datePublished}">
			<td valign="top" class="name"><g:message
					code="serviceProfile.datePublished.label"
					default="Date Published" /></td>

			<td valign="top" class="value"><g:formatDate format="MMMMM d, yyyy" date="${serviceProfileInstance?.datePublished}" /></td>

		</g:if>
	</tr>
</table>

<table>
	<tr class="prop">

		<td valign="top" class="name"><g:message
				code="service.description.label" default="Description" />
		</td>
		<td valign="top" class="value">
			<g:textArea name="description" value="${serviceProfileInstance?.service?.serviceDescription?.value}" rows="4" cols="120" readonly="true"/>
		</td>

	</tr>
</table>