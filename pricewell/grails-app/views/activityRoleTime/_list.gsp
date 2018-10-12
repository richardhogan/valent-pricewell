<div class="nav">
    <span class="menuButton">
    		<g:remoteLink class="list" id="${serviceActivityInstance?.id}" 
    			action="create" controller="activityRoleTime" title="List"
    					update="[success:'dvEditRoles',failure:'dvEditRoles']">Add Role</g:remoteLink></span>
</div>
<g:if test="${flash.message}">
	
	<script>
       	 
		      
		</script>
</g:if>
<div class="list">
    <table>
        <thead>
            <tr>
            	<th><g:message code="activityRoleTime.role.label" default="Role" /></th>
            	
		 		<util:remoteSortableColumn controller="serviceActivity" action="editFromDeliverable" property="estimatedTimeInHoursFlat" title="${message(code: 'activityRoleTime.estimatedTimeInHours.label', default: 'Estimated Time In Hours (Flat)')}" params="[id: serviceActivityInstance?.id]" update="[success:'delActivity',failure:'delActivity']"/>

                <util:remoteSortableColumn controller="serviceActivity" action="editFromDeliverable" property="estimatedTimeInHoursPerBaseUnits" title="${message(code: 'activityRoleTime.estimatedTimeInHours.label', default: 'Additional Time In Hours (Per Unit)')}" params="[id: serviceActivityInstance?.id]" update="[success:'delActivity',failure:'delActivity']"/>
               
                <th></th>
                <th> </th>
            
            </tr>
        </thead>
        <tbody>
        <g:each in="${serviceActivityInstance?.rolesEstimatedTime}" status="i" var="activityRoleTimeInstance">
            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
            
            	<td>${fieldValue(bean: activityRoleTimeInstance, field: "role")}</td>
            	
				<td>${fieldValue(bean: activityRoleTimeInstance, field: "estimatedTimeInHoursFlat")}</td>    

                <td>${fieldValue(bean: activityRoleTimeInstance, field: "estimatedTimeInHoursPerBaseUnits")}</td>
                
                <td> 
                	<g:remoteLink controller="activityRoleTime" action="edit" title="Edit"
                			params="['id': activityRoleTimeInstance.id]"
                				update="[success:'dvEditRoles',failure:'dvEditRoles']"> Edit </g:remoteLink>
                </td>
                <td>
                	 <g:remoteLink controller="activityRoleTime" action="delete" title="Delete"
                	 		params="['activityRoleId': activityRoleTimeInstance.id]"
                	 			update="[success:'dvActivityRoleList',failure:'dvActivityRoleList']"> Delete </g:remoteLink> 
                </td>
            
            </tr>
        </g:each>
        </tbody>
    </table>
</div>
<div id="dvEditRoles">
	
</div>
