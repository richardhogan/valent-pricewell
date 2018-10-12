<%@ page import="com.valent.pricewell.ServiceDeliverable" %>
<%
	def baseurl = request.siteUrl
%>  
<g:setProvider library="prototype"/>

<script>
	function customerDeliverableList()
	{
		jQuery.ajax({
			type: "POST",
			url: "${baseurl}/serviceDeliverable/listServiceDeliverables",
			data: {'serviceProfileId': ${serviceProfileInstance?.id}},
			success: function(data){jQuery("#mainCustomerDeliverablesTab").html(data);}, 
			error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
		});
		
		return false;
	}
</script>

<g:form>
	<div class="nav">
		<span>				
			<!--<g:remoteLink class="buttons.button button" controller="serviceDeliverable" 
		    		params="['serviceProfileId': serviceProfileInstance?.id]" title="List Of Customer Deliverables" 
		    		action="listServiceDeliverables" update="[success:'mainCustomerDeliverablesTab',failure:'mainCustomerDeliverablesTab']">
		    			List Of Customer Deliverables
	    	</g:remoteLink>-->
	    	
	    	<a id="idCustomerDeliverableList" onclick="customerDeliverableList();" class="buttons.button button" title="List Of Customer Deliverables">List of Customer Deliverables</a>
		</span>
	</div>
	<div class="body">
	
		<div class="list">
			<g:submitToRemote name="up" action="upOrder" title="Go Up" value="Up" controller="serviceDeliverable" update="mainCustomerDeliverablesTab"/>
			<g:submitToRemote name="down" action="downOrder" title="Go Down" value="Down" controller="serviceDeliverable" update="mainCustomerDeliverablesTab"/>
			
			<g:hiddenField name="serviceProfileId" value="${serviceProfileInstance?.id}"/>
		    <table>
		        <thead>
		            <tr>  
			            <th>  </th>         	
			            	
			            <util:remoteSortableColumn controller="serviceDeliverable" action="listServiceDeliverables" property="name" defaultOrder="asc" title="${message(code: 'serviceDeliverable.name.label', default: 'Name')}" 
			                                    titleKey="name" params="['serviceProfileId': serviceProfileInstance?.id]" update="[success:'mainCustomerDeliverablesTab',failure:'mainCustomerDeliverablesTab']"/>
			                                    
			            <util:remoteSortableColumn controller="serviceDeliverable" action="listServiceDeliverables" property="type" defaultOrder="asc" title="${message(code: 'serviceDeliverable.type.label', default: 'Type')}" 
			                                    titleKey="type" params="['serviceProfileId': serviceProfileInstance?.id]" update="[success:'mainCustomerDeliverablesTab',failure:'mainCustomerDeliverablesTab']"/>
			                                    
			            <util:remoteSortableColumn controller="serviceDeliverable" action="listServiceDeliverables" property="description" defaultOrder="asc" title="${message(code: 'serviceDeliverable.description.label', default: 'Description')}" 
			                                    titleKey="description" params="['serviceProfileId': serviceProfileInstance?.id]" update="[success:'mainCustomerDeliverablesTab',failure:'mainCustomerDeliverablesTab']"/>
			            
		            </tr>
		        </thead>
		        <tbody>
		        
				<g:set var="tmpDeliverablesList" value="${deliverablesList? deliverablesList: serviceProfileInstance.listCustomerDeliverables()}"/>        
		         
		        <g:each in="${tmpDeliverablesList}" status="i" var="serviceDeliverableInstance">
		            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
		            	
		            	<td> <g:radio name="check" value="${serviceDeliverableInstance.id}"/></td>
		            
		                <td>${fieldValue(bean: serviceDeliverableInstance, field: "name")}</td>
		            
		                <td>${fieldValue(bean: serviceDeliverableInstance, field: "type")}</td>
		            
		                <td>${fieldValue(bean: serviceDeliverableInstance, field: "description")}</td>
		                
		            </tr>          
		        </g:each>
		        </tbody>
		    </table>
		</div>
	</div>
</g:form>