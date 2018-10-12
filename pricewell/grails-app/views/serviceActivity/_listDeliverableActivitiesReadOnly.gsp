<div class="list">
		    <table>
		        <thead>
		            <tr>
		                <util:remoteSortableColumn controller="serviceActivity" action="listDeliverableActivities" property="sequenceOrder" title="${message(code: 'serviceActivity.sequenceOrder.label', default: 'Order')}" params="[serviceProfileId: serviceProfileInstance?.id]" update="[success:'delActivity',failure:'delActivity']" />
		
		                <util:remoteSortableColumn controller="serviceActivity" action="listDeliverableActivities" property="category" title="${message(code: 'serviceActivity.category.label', default: 'Category')}" params="[serviceProfileId: serviceProfileInstance?.id]" update="[success:'delActivity',failure:'delActivity']"/>
		
		                <util:remoteSortableColumn controller="serviceActivity" action="listDeliverableActivities" property="name" title="${message(code: 'serviceActivity.name.label', default: 'Name')}" params="[serviceProfileId: serviceProfileInstance?.id]" update="[success:'delActivity',failure:'delActivity']"/>
		
		                
		                <util:remoteSortableColumn controller="serviceActivity" action="listDeliverableActivities" property="estimatedTimeInHoursFlat" title="${message(code: 'serviceActivity.estimatedTimeInHoursFlat.label', default: 'Est Hrs(Flat)')}" params="[serviceProfileId: serviceProfileInstance?.id]" update="[success:'delActivity',failure:'delActivity']"/>
				
				 		<util:remoteSortableColumn controller="serviceActivity" action="listDeliverableActivities" property="estimatedTimeInHoursPerBaseUnits" title="${message(code: 'serviceActivity.estimatedTimeInHoursPerBaseUnits.label', default: 'Extra Hrs(per Unit)')}" params="[serviceProfileId: serviceProfileInstance?.id]" update="[success:'delActivity',failure:'delActivity']"/>
	
		                <th>Roles Required</th>
		
		                <util:remoteSortableColumn controller="serviceActivity" action="listDeliverableActivities" property="results" title="Results" params="[serviceProfileId: serviceProfileInstance?.id]" update="[success:'delActivity',failure:'delActivity']"/>
		               
		
		            </tr>
		        </thead>
		        <tbody>
		        <g:each in="${activitiesList}" status="i" var="serviceActivityInstance">
		            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
		                <td>${fieldValue(bean: serviceActivityInstance, field: "sequenceOrder")}</td>
		                <td>${fieldValue(bean: serviceActivityInstance, field: "category")}</td>
		                <td> ${fieldValue(bean: serviceActivityInstance, field: "name")}
		                    <!--div>  
		                      <g:remoteLink action="show" controller="serviceActivity" id="${serviceActivityInstance.id}" update="[success:'mainActivitiesTab',failure:'mainActivitiesTab']">${fieldValue(bean: serviceActivityInstance, field: "name")}</g:remoteLink>
		                    </div-->
		                    <!--div>
		                       ${fieldValue(bean: serviceActivityInstance, field: "description")}
		                    </div-->
		
		                </td>
				 
				 		<td>${fieldValue(bean: serviceActivityInstance, field: "estimatedTimeInHoursFlat")}</td>
	
		                <td>${fieldValue(bean: serviceActivityInstance, field: "estimatedTimeInHoursPerBaseUnits")}</td>
		               
		                <td>
		                     <ul>
		                     	<g:if test="${serviceActivityInstance.rolesEstimatedTime}">
		                     		<table>
		                     			
		                     			<tr>
		                     				<th>Role</th><th>Est Hrs (Flat)</th><th>Extra Hrs (Per Base Units)</th>
		                     			</tr>
		                     			
			                          <g:each in="${serviceActivityInstance.rolesEstimatedTime}" var="r">
			                            <!--li> Role: ${r.role?.name}</li>
			                          	<li> Est Hrs (Flat): ${r.estimatedTimeInHoursFlat}</li>
			                          	<li> Extra Hrs (Per Base Units): ${r.estimatedTimeInHoursPerBaseUnits}</li-->
			                          	<tr>
			                          		<td>${r.role?.name}</td>
			                          		<td>${r.estimatedTimeInHoursFlat}</td>
			                          		<td>${r.estimatedTimeInHoursPerBaseUnits}</td>
			                          	</tr>
			                          </g:each>
			                        </table>
		                        </g:if>  
		                     </ul>
		                </td>
		                
		                 <td>${fieldValue(bean: serviceActivityInstance, field: "results")}</td>
		               
		            </tr>
		        </g:each>
		        </tbody>
		    </table>
		</div>