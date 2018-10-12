<%
	def baseurl = request.siteUrl
%>

<%@ page import="com.valent.pricewell.ObjectType" %>

		
		<g:set var="entityName" value="${message(code: 'staging.label', default: 'Service Properties Types')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
        
        <script type="text/javascript">
    		jQuery(function() 
			{
    			jQuery(".editTypeBtn").click(function()
 				{
 					jQuery.ajax({
 						type: "POST",
 						url: "${baseurl}/objectType/editsetup",
 						data: {id: this.id, source: 'firstSetup'},
 						success: function(data){jQuery("#mainServicePropertiesTypesTab").html(data);}, 
 						error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
 					});
 					
 					return false;
 				});

    			jQuery(".deleteTypeBtn").click(function()
 				{
 					jQuery.ajax({
 						type: "POST",
 						url: "${baseurl}/objectType/deletesetup",
 						data: {id: this.id, source: 'firstSetup'},
 						success: function(data){jQuery("#mainServicePropertiesTypesTab").html(data); refreshNavigation();}, 
 						error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
 					});
 					
 					return false;
 				});
    	        			
			});

    		function changeDeliverablePhaseOrder()
    		{
    			jQuery.ajax({
    				type: "POST",
    				url: "${baseurl}/objectType/changeOrders",
    				data: {type: '${type}', source: 'firstSetup'},
    				success: function(data){jQuery("#mainServicePropertiesTypesTab").html(data);}, 
    				error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
    			});
    			
    			return false;
    		}

    		function changeOrderUpDown(order)
    		{
				
    			if(jQuery("input[name='deliverablePhaseOrder']").is(':checked'))
        		{
            		var phaseId = jQuery("input[name='deliverablePhaseOrder']:checked").val(); 

            		jQuery.ajax({
        				type: "POST",
        				url: "${baseurl}/objectType/saveOrder",
        				data: {type: '${type}', source: 'firstSetup', id: phaseId, order: order},
        				success: function(data){jQuery("#mainServicePropertiesTypesTab").html(data);}, 
        				error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
        			});
           		}

    			return false;
    		}
		</script>
    
    <div class="body">
        
	        
	        <div class="leftNavSmall">      		
	    		<g:render template="../objectType/nevigationsetup"/>
	    	</div>
	        
	        <div class="body rightContent column">
	            
	            <h1>
	            	${title}
		            
		            <g:if test="${type == 'deliverablePhase' && objectTypes.size() > 1 }">
	   					<g:if test="${changeOrder == false }">
	   						<span><a id="idChangeDeliverablePhaseOrder" onclick="changeDeliverablePhaseOrder();" class="buttons.button button" title="Change Orders Of Deliverable Phase">Change Orders</a></span>
	   					</g:if>
	   					<g:else>	   					
		   					<span><a id="idUpOrder" onclick="changeOrderUpDown('upOrder');" class="buttons.button button" title="Change Orders Up">Up</a></span>
		   					<span><a id="idDownOrder" onclick="changeOrderUpDown('downOrder');" class="buttons.button button" title="Change Orders Down">Down</a></span>
		   					<span><a id="idDone" onclick="showList('deliverablePhase');" class="buttons.button button" title="Change Orders Done">Done</a></span>
	   					</g:else>
	   				</g:if>
	            </h1><hr />
	            
	            <div class="list">
	                <table cellpadding="0" cellspacing="0" border="0" class="display" id="objectTypesList">
	                    <thead>
	                        <tr>
	                        	<g:if test="${type == 'deliverablePhase' && objectTypes.size() > 1 }">
	   								<g:if test="${changeOrder == false }">
	   									<th>No.</th>
	   								</g:if>
	   								<g:else>
	   									<th>Order</th>
	   								</g:else>
   								</g:if>
   								<g:else>
   									<th>No.</th>
   								</g:else>
	                        	
	                            <th>Name</th>
	                            
	                            <g:if test="${changeOrder == false }">
   									<th></th>
	                            	<th></th>
   								</g:if>
   								<g:else>
   									<th>Description</th>
   								</g:else>
	   								
	                            
	                        </tr>
	                    </thead>
	                    <tbody>
		                    <g:each in="${objectTypes}" status="i" var="objectTypeInstance">
		                        <tr>
		                        	<g:if test="${type == 'deliverablePhase' && objectTypes.size() > 1 }">
		   								<g:if test="${changeOrder == false }">
		   									<td>${i+1}</td>
		   								</g:if>
		   								<g:else>
		   									<td> 
		   										<input type="radio" name="deliverablePhaseOrder" value="${objectTypeInstance.id}"></input>
	   										</td>
		   								</g:else>
	   								</g:if>
	   								<g:else>
	   									<td>${i+1}</td>
	   								</g:else>
		                        	
		                            <td>${fieldValue(bean: objectTypeInstance, field: "name")}</td>
		                            
		                            <g:if test="${changeOrder == false }">
	   									<td> <a id="${objectTypeInstance.id}" href="#" class="editTypeBtn hyperlink"> Edit </a></td>
										<td> <a id="${objectTypeInstance.id}" href="#" class="deleteTypeBtn hyperlink"> Delete </a></td>
	   								</g:if>
	   								<g:else>
	   									<td>${fieldValue(bean: objectTypeInstance, field: "description")}</td>
	   								</g:else>
   								
		                            
		                        </tr>
		                    </g:each>
	                    </tbody>
	                </table>
	            </div>
	            
	        </div>
	    
	    <div id="objectTypeDialog" title="">
			
		</div>
    </div>

