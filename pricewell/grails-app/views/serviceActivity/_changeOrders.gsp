<%@ page import="com.valent.pricewell.ServiceDeliverable" %>
<%@ page import="com.valent.pricewell.ServiceActivity" %>

<%
	def baseurl = request.siteUrl
%>

<g:setProvider library="prototype"/>
<script>
	function serviceActivityList()
	{
		jQuery.ajax({
			type: "POST",
			url: "${baseurl}/serviceActivity/listDeliverableActivities",
			data: {'id': ${serviceDeliverableInstance.id}},
			success: function(data){jQuery("#delActivity").html(data);}, 
			error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
		});
		
		return false;
	}

	function newServiceActivity()
	{
		jQuery.ajax({
			type: "POST",
			url: "${baseurl}/serviceActivity/newActivityFromDeliverable",
			data: {'id': ${serviceDeliverableInstance.id}},
			success: function(data){jQuery("#delActivity").html(data);}, 
			error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
		});
		
		return false;
	}
</script>
<g:form>
	<span style="font-size: 105%"> <b> Activities of ${serviceDeliverableInstance} </b> </span>
	
	<div class="nav">		
		<span >
			<a id="idServiceActivityList" onclick="serviceActivityList();" class="buttons.button button" title="List Of Activity">List Activities</a>
			
			<a id="idNewServiceActivity" onclick="newServiceActivity();" class="buttons.button button" title="New Activity">New Activity</a>
			
			
			<!--<g:remoteLink class="buttons.button button" id="${serviceDeliverableInstance.id}" title="List Of Activity" action="listDeliverableActivities" controller="serviceActivity" update="[success:'delActivity',failure:'delActivity']">List Activities</g:remoteLink>
			<g:remoteLink class="buttons.button button" controller="serviceActivity" 
		   		action="newActivityFromDeliverable" 
		   			id="${serviceDeliverableInstance.id}" title="Create New Activity"
		   			update="[success:'delActivity',failure:'delActivity']">
		   			New Activity
		   	</g:remoteLink>-->
		   	
		 </span>
	</div>
	<div class="body">
		<g:submitToRemote name="up" action="upOrder" value="Up" controller="serviceActivity" update="delActivity"/>
		<g:submitToRemote name="down" action="downOrder" value="Down" controller="serviceActivity" update="delActivity"/>
		<g:hiddenField name="id" value="${serviceDeliverableInstance.id}"/>
		<div class="list">
		    <table>
		        <thead>
		            <tr>
		                <th> </th>
		
		                
			
		                <util:remoteSortableColumn controller="serviceActivity" action="changeOrders" property="category" title="${message(code: 'serviceActivity.category.label', default: 'Category')}" params="[serviceProfileId: serviceProfileInstance?.id]" update="[success:'delActivity',failure:'delActivity']"/>
		
		                <util:remoteSortableColumn controller="serviceActivity" action="changeOrders" property="name" title="${message(code: 'serviceActivity.name.label', default: 'Name')}" params="[serviceProfileId: serviceProfileInstance?.id]" update="[success:'delActivity',failure:'delActivity']"/>
		
		                
		                <util:remoteSortableColumn controller="serviceActivity" action="changeOrders" property="estimatedTimeInHoursFlat" title="${message(code: 'serviceActivity.estimatedTimeInHoursFlat.label', default: 'Est Hrs(Flat)')}" params="[serviceProfileId: serviceProfileInstance?.id]" update="[success:'delActivity',failure:'delActivity']"/>
				
				 		<util:remoteSortableColumn controller="serviceActivity" action="changeOrders" property="estimatedTimeInHoursPerBaseUnits" title="${message(code: 'serviceActivity.estimatedTimeInHoursPerBaseUnits.label', default: 'Extra Hrs(per Unit)')}" params="[serviceProfileId: serviceProfileInstance?.id]" update="[success:'delActivity',failure:'delActivity']"/>
	
		                <th>Roles Required</th>
		
		                <util:remoteSortableColumn controller="serviceActivity" action="changeOrders" property="results" title="Results" params="[serviceProfileId: serviceProfileInstance?.id]" update="[success:'delActivity',failure:'delActivity']"/>
		                                
		                <th> </th>
		
		            </tr>
		        </thead>
		        <tbody>
		        <g:each in="${activitiesList}" status="i" var="serviceActivityInstance">
		            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
		                <td> <g:radio name="check" value="${serviceActivityInstance.id}"/> </td>
		                <td>${fieldValue(bean: serviceActivityInstance, field: "category")}</td>
		                <td> 
		                	${fieldValue(bean: serviceActivityInstance, field: "name")}
		                    <!--div>  
		                      <g:remoteLink action="show" controller="serviceActivity" id="${serviceActivityInstance.id}" update="[success:'delActivity',failure:'delActivity']">${fieldValue(bean: serviceActivityInstance, field: "name")}</g:remoteLink>
		                    </div>
		                    <div>
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
	</div>
</g:form>