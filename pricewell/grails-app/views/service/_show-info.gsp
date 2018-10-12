<%@ page import="com.valent.pricewell.Service"%>
<%@ page import="com.valent.pricewell.ServiceProfile"%>
<div class="plain">
	<g:set var="calculatedEstimate"
				value="${serviceProfileInstance?.calculateTotalEstimatedTime()}" />
	<table>
		<tbody>
			<tr class="prop">

				<td valign="top" class="name"><g:message
						code="service.skuName.label" default="Sku Name" /></td>

				<td valign="top" class="value">
					${fieldValue(bean: serviceProfileInstance, field: "service.skuName")}
				</td>

				<td valign="top" class="name"><g:message code="portfolio.label"
						default="Portfolio" /></td>

				<td valign="top" class="value">
					${serviceProfileInstance.service.portfolio.portfolioName}
				</td>

				<td valign="top" class="name"><g:message
						code="serviceProfile.stagingStatus.label" default="Staging Status" />
				</td>
				<td>
					${fieldValue(bean: serviceProfileInstance, field: "stagingStatus")} 
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
						code="serviceProfile.baseUnits.label" default="Base Units" /></td>

				<td valign="top" class="value">
					${fieldValue(bean: serviceProfileInstance, field: "baseUnits")}
				</td>

				<td valign="top" class="name"><g:message
						code="serviceProfile.premiumPercent.label"
						default="Premium Percentage" />
				</td>

				<td valign="top" class="value">
					${fieldValue(bean: serviceProfileInstance, field: "premiumPercent")}%</td>

			</tr>

			<tr class="prop">

            <g:if test="${serviceProfileInstance?.stagingStatus?.sequenceOrder >= 20}">
                            
				<g:if test="${calculatedEstimate}">

					<td valign="top" class="name">Hrs per base units</td>

					<td valign="top" class="value">
						${calculatedEstimate["totalFlat"]}
					</td>


				</g:if>

				<g:if test="${calculatedEstimate}">

					<td valign="top" class="name">Additional Hrs Per Unit</td>

					<td valign="top" class="value">
						${calculatedEstimate["totalExtra"]}
					</td>

				</g:if>
			</g:if>
			<g:else>
					<td valign="top" class="name">
                                    <label for="totalEstimateInHoursFlat"><g:message code="serviceProfile.totalEstimateInHoursFlat.label" default="totalEstimateInHoursFlat" /></label>
                                </td>
                                <td valign="top" class="value">
                                   ${fieldValue(bean: serviceProfileInstance, field: 'totalEstimateInHoursFlat')}
                                </td>
                                
                        <td valign="top" class="name">
                                    <label for="totalEstimateInHoursPerBaseUnits"><g:message code="serviceProfile.totalEstimateInHoursPerBaseUnits.label" default="totalEstimateInHoursPerBaseUnits" /></label>
                                </td>
                                <td valign="top" class="value">
                                    ${fieldValue(bean: serviceProfileInstance, field: 'totalEstimateInHoursPerBaseUnits')}
                                </td>
			</g:else>

				<td colspan="2" class="reduced"><b> <g:message
							code="serviceProfile.dateCreated.label" default="Date Created" />
				
				</b> 
				
					<g:formatDate format="MMMMM d, yyyy" date="${serviceProfileInstance?.dateCreated}" /> <b>
						<g:message code="serviceProfile.dateModified.label"
							default="Date Modified" /> </b>
					 <g:formatDate format="MMMMM d, yyyy" date="${serviceProfileInstance?.dateModified}" />
				</td>
				
				

			</tr>

		</tbody>
	</table>

</div>