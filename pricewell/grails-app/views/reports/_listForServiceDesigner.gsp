<%@ page import="grails.plugins.nimble.core.*" %>
<%@ page import="com.valent.pricewell.User" %>
<%@ page import="com.valent.pricewell.Service" %>
<%@ page import="com.valent.pricewell.ServiceStageFlow" %>
<html>
    
        
        <script>

        	jQuery(document).ready(function()
    		{
    			jQuery('#serviceList').dataTable({
    				"sPaginationType": "full_numbers",
    				"sDom": 't<"F"ip>',
			        "bFilter": true,
			        "fnDrawCallback": function() {
		                if (Math.ceil((this.fnSettings().fnRecordsDisplay()) / this.fnSettings()._iDisplayLength) > 1)  {
		                        jQuery('.dataTables_paginate').css("display", "block"); 
		                        jQuery('.dataTables_length').css("display", "block");                   
		                } else {
		                		jQuery('.dataTables_paginate').css("display", "none");
		                		jQuery('.dataTables_length').css("display", "none");
		                }
		            },
		            "aaSorting": [[ 7, "desc" ]]
    			});
    		});
        		        
        </script>
    
    	
    	<div class="body">
        	
            <h1>My Services In Development</h1>
            
             
            <div class="list">
                <table cellpadding="0" cellspacing="0" border="0" class="display" id="serviceList">
	                    <thead>
	                        <tr>
	                        	
	                            <th><g:message code="service.serviceName.label" default="Service Name" /></th>
	                        	
	                        	<th><g:message code="service.version.label" default="Version" /></th>
	                        	
	                        	<th><g:message code="service.skuName.label" default="Sku Name" /></th>
	                        	
	                        	<th><g:message code="service.tags.label" default="Tags" /></th>
	                        	
	                        	<th><g:message code="service.description.label" default="Description" /></th>
	                            
	                            <th><g:message code="service.portfolio.label" default="Portfolio" /></th>
	                            
	                            <th><g:message code="service.stagingStatus.label" default="Stage" /></th>
	                        
	                            <th><g:message code="service.dateModified.label" default="Date Modified" /></th>
	                            
	                        	<g:if test="${instage}"><th>Current Owner</th></g:if>
	                        	
	                        </tr>
	                    </thead>
	                    <g:if test="${listForServiceDesigner}">
	                    <tbody>
	                    <% 	def adminRole = Role.findByName('SYSTEM ADMINISTRATOR') %>
	                    <g:each in="${listForServiceDesigner}" status="i" var="serviceProfileInstance">
	                        <tr>
	                        
	                        	<td><g:link controller="service" action="show"  params="[serviceProfileId: serviceProfileInstance.id]" >${fieldValue(bean: serviceProfileInstance, field: "service.serviceName")}</g:link></td>
	                            
	                            <td>${fieldValue(bean: serviceProfileInstance, field: "revision")}</td>
	                        
	                            <td>${fieldValue(bean: serviceProfileInstance, field: "service.skuName")}</td>
	                            
	                            <td>${fieldValue(bean: serviceProfileInstance, field: "service.tags")}</td>
	                        
	                            <td>${fieldValue(bean: serviceProfileInstance, field: "service.description")}</td>
	                        
	                            <td>${fieldValue(bean: serviceProfileInstance, field: "service.portfolio")}</td>
	                            
	                            <td>${serviceProfileInstance.stagingStatus?.displayName}</td>
	                        
	                            <td><g:formatDate format="MMMMM d, yyyy" date="${serviceProfileInstance.dateModified}" /></td>
	                        	
	                        	<g:if test="${instage}">
	                        		
	                        		<td>
	                        			
	                        			<%
											def responsiblePerson = []

											
											for(User user : serviceProfileInstance.responsiblePerson())
											{
												
												
												if(!user?.roles?.contains(adminRole))
												{
													responsiblePerson.add(user)
												}
											} 
											
	                        			%>
	                        				
	                        			
				                        <g:if test="${responsiblePerson.size >0 }">
				                        	<g:each in="${responsiblePerson}" var="a" status="k">
				                        	
				                        		<g:if test="${k>0}">
				                        			;
				                        		</g:if>
				                            	<span> ${a?.encodeAsHTML()} </span>
				                            
				                        	</g:each>
				                        </g:if>
				                        <g:else>
				                        	<span> Admin </span>
				                        </g:else>
	                        		</td>
	                        	</g:if>
	                        </tr>
	                    </g:each>
	                    </tbody>
	                    </g:if>
	                </table>
	                
	                
            </div>
            
        </div>
   
</html>
