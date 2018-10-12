<div id="activityRoleTime${i}" class="activityRoleTime-div" <g:if test="${hidden}">style="display:none;"</g:if>>
    <g:hiddenField name='rolesEstimatedTimeList[${i}].id' value='${activityRoleTimeInstance?.id}'/>
    <g:hiddenField name='rolesEstimatedTimeList[${i}].deleted' value='false'/>
	<g:hiddenField name='rolesEstimatedTimeList[${i}].new' value="${activityRoleTimeInstance?.id == null?'true':'false'}"/>
    
    <span>
    <g:select name="rolesEstimatedTimeList[${i}].role.id" from="${com.valent.pricewell.DeliveryRole.list()}" optionKey="id" value="${activityRoleTimeInstance?.role?.id}"  class="required uniquerole special-error"/>
    </span>
    
    <span>
    <g:textField name="rolesEstimatedTimeList[${i}].estimatedTimeInHoursFlat" value="${fieldValue(bean: activityRoleTimeInstance, field: 'estimatedTimeInHoursFlat')}" class="required number special-error"/>
     </span>
    
    <span>
    <g:textField name="rolesEstimatedTimeList[${i}].estimatedTimeInHoursPerBaseUnits" value="${fieldValue(bean: activityRoleTimeInstance, field: 'estimatedTimeInHoursPerBaseUnits')}" class="required number special-error"/>
     </span>
    
      <span class="del-activityRoleTime">
        <img src="${resource(dir:'images/skin', file:'database_delete.png')}" 
            style="vertical-align:middle;"/>
      </span>

   
</div>
