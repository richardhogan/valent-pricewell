
<%@ page import="com.valent.pricewell.DeliveryRole" %>
<%@ page import="com.valent.pricewell.Geo" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
    	<script>
		   	jQuery(function() 
		   	{
					
			});
	   	</script>	
   	
    </head>
    <body>
        
        <div class="body">
        
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><b><g:message code="deliveryRole.name.label" default="Name" /></b></td>
                            <td>&nbsp;&nbsp;</td>
                            <td valign="top" class="value">${fieldValue(bean: deliveryRoleInstance, field: "name")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><b><g:message code="deliveryRole.description.label" default="Description" /></b></td>
                            <td>&nbsp;&nbsp;</td>
                            <td valign="top" class="value">${fieldValue(bean: deliveryRoleInstance, field: "description")}</td>
                            
                        </tr>
                        
                        <tr class="prop">
                            <td valign="top" class="name"><b>Note</b></td>
                            <td>&nbsp;&nbsp;</td>
                            <td valign="top" class="value">This delivery role should not be deleted because following service<g:if test="${serviceProfileList?.size() > 1}">s are</g:if><g:else> is</g:else> using it.</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
		            
			<div class="list" style="height: 300px; overflow:auto;">
                <table id="serviceProfileList">
                    <thead>
                        <tr>
                        	
                            <th><g:message code="service.serviceName.label" default="Service Name" /></th>
                        	
                        	<th><g:message code="service.version.label" default="Version" /></th>
                        	
                        	<th><g:message code="service.dateCreated.label" default="Date Created" /></th>
                        	
                        </tr>
                    </thead>
                    
                    <tbody>
                 
	                    <g:each in="${serviceProfileList?.sort{it?.service?.serviceName}}" status="i" var="serviceProfileInstance">
	                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
	                        
	                        	<td>
	                        		<g:link action="show" controller="service" class="hyperlink" params="[serviceProfileId: serviceProfileInstance.id]" >${fieldValue(bean: serviceProfileInstance, field: "service.serviceName")}</g:link>
                       			</td>
	                            
	                            <td>${fieldValue(bean: serviceProfileInstance, field: "revision")}</td>
	                        	
	                        	<td><g:formatDate format="MMMMM d, yyyy" date="${serviceProfileInstance.dateCreated}" /></td>
	                        </tr>
	                    </g:each>
                    </tbody>
                    
                </table>
	                
            </div>
        </div>
    </body>
</html>
