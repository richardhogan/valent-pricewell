

<div class="body list">
	<g:set var="roleTimeCorrections" value="${serviceQuotationInstance?.correctionsInRoleTime}" />

	<table>
		<thead>
			<th>Role</th>
			<th>Defined Total Hours</th>
			<th>Overridden Total Hours</th>
			<th></th>
		</thead>
	
		<tbody>
			<g:each in="${serviceActivityInstance?.rolesEstimatedTime?.sort {it.role.name}}" status="k" var="activityRoleTime">
			
				<g:set var="activityRoleTimeCorrection" value="" />
				
				<g:each in="${roleTimeCorrections}" status="l" var="roleTimeCorrection">
					<g:if test="${roleTimeCorrection?.serviceActivity?.id == serviceActivityInstance?.id}">
						<g:if test="${roleTimeCorrection?.role?.id == activityRoleTime?.role?.id}">
							<g:set var="activityRoleTimeCorrection" value="${roleTimeCorrection}" />
						</g:if>
					</g:if>
				</g:each>
				
				<g:if test="${activityRoleTimeCorrection != ''}">
					<tr class="prop">
						<td valign="top" class="value">${activityRoleTimeCorrection?.role?.name }</td>
						<td valign="top" class="value">${activityRoleTimeCorrection?.originalHours }</td>
						<td valign="top" class="value">${activityRoleTimeCorrection?.originalHours + activityRoleTimeCorrection?.extraHours }</td>
						<td valign="top" class="value">
							<input id="artcid-${activityRoleTimeCorrection.id}" type="button" value="Edit" title="Edit" class="artcEdit button"/>
						</td>
					</tr>
				</g:if>
				<g:else>
					<tr class="prop">
						<td valign="top" class="value">${activityRoleTime?.role?.name }</td>
						<td valign="top" class="value">${activityRoleTime.countTotalHoursForServiceQuotationUnits(serviceQuotationInstance.totalUnits) }</td>
						<td valign="top" class="value">N/A</td>
						<td valign="top" class="value">
							<input id="artid-${activityRoleTime.id}" type="button" value="Edit" title="Edit" class="artEdit button"/>
						</td>
					</tr>
				</g:else>
			</g:each>
		</tbody>
	</table>
</div>
