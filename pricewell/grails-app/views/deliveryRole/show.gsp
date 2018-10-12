
<%@ page import="com.valent.pricewell.DeliveryRole" %>
<%@ page import="com.valent.pricewell.Geo" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
    	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'deliveryRole.label', default: 'Delivery Role')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
       
       	<script>
		   	jQuery(function() 
		   	{
				jQuery( "#tabsDiv" ).tabs();
				
			});
	   	</script>	
   	
    </head>
    <body>
        <div class="nav">
        	<g:form>
        		<g:hiddenField name="id" value="${deliveryRoleInstance?.id}" />
        		<g:if test="${updatePermission}">
        			<span><g:link class="buttons.button button" title="Edit Delivery Role" action="edit" controller="deliveryRole" id="${deliveryRoleInstance?.id}">Edit</g:link></span>
        		</g:if>
        		<g:if test="${createPermission}">
        			<span><g:link class="buttons.button button" title="Delete Delivery Role" action="delete" controller="deliveryRole" id="${deliveryRoleInstance?.id}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');">Delete</g:link></span>
        		</g:if>
        		<span><g:link action="list" title="List Of Delivery Roles" class="buttons.button button"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
	            <g:if test="${createPermission}">
	            	<span><g:link  action="create" title="Create New Delivery Role" class="buttons.button button"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
	            </g:if>
	            <!-- <span><g:link  action="list" controller="geo" class="buttons.button button">List of Territories</g:link></span>
            	<span><g:link class="buttons.button button" action="list" controller="geoGroup">List of Geos</g:link></span>-->
            </g:form>
        </div>
        <div class="body">
        	<div class="collapsibleContainer">
				<div class="collapsibleContainerTitle ui-widget-header">
					<div><g:message code="default.show.label" args="[entityName]" /></div>
				</div>
			
				<div class="collapsibleContainerContent">
				
					<g:if test="${flash.message}">
		            	<!--div class="message">${flash.message}</div-->
		            </g:if>
		          
		            <div class="dialog">
		                <table>
		                    <tbody>
		                    
		                        <tr class="prop">
		                            <td valign="top" class="name"><b><g:message code="deliveryRole.name.label" default="Name" /></b></td>
		                            
		                            <td valign="top" class="value">${fieldValue(bean: deliveryRoleInstance, field: "name")}</td>
		                            
		                        </tr>
		                    
		                        <tr class="prop">
		                            <td valign="top" class="name"><b><g:message code="deliveryRole.description.label" default="Description" /></b></td>
		                            
		                            <td valign="top" class="value">${fieldValue(bean: deliveryRoleInstance, field: "description")}</td>
		                            
		                        </tr>
		                    
		                    	<g:if test="${message != '' }">
			                    	<tr>
			                    		<td valign="top" class="name"><b>Message</b></td>
			                    		<td valign="top" class="value">${message }</td>
			                    	</tr>
		                    	</g:if>
		                    </tbody>
		                </table>
		            </div>
		            
		            <div id="tabsDiv">
		            	<ul>
		            		<g:if test="${deliveryRoleInstance?.relationDeliveryGeos.size() > 0}">
				 				<li><a href="#ratecostpergeo">Rates/Costs per Territory</a></li>
				 			</g:if>
							<g:if test="${updatePermission}">
								<li><a href="#defineratecost" >Define Rates/Costs for other Territories</a></li>
							</g:if>	
						</ul>
						
						<div id="ratecostpergeo">
							<g:if test="${deliveryRoleInstance?.relationDeliveryGeos.size() > 0}">
								<div id="dvRateCostsPerGeo" style="height: 325px; overflow:auto;">
			            			<g:if test="${updatePermission}">
			            				<g:render template="/relationDeliveryGeo/listForDeliveryRole" model="['relationDeliveryGeoList': relationDeliveryGeoList, 'deliveryRoleInstance': deliveryRoleInstance]"> </g:render>
			            			</g:if>
			            			<g:else>
			   							<g:render template="/relationDeliveryGeo/listForDeliveryRoleReadOnly" model="['relationDeliveryGeoList': relationDeliveryGeoList, 'deliveryRoleInstance': deliveryRoleInstance]"> </g:render>         			
			            			</g:else>
			            		</div>
		            		</g:if>
						</div>
						
						<div id="defineratecost">
							<g:if test="${updatePermission}">
								<div id ="dvGeoForDeliveryRole" style="height: 325px; overflow:auto;">
				            		<g:set var="undefinedGeoCount" value="${deliveryRoleInstance?.listUndefinedGeos()?.size()}"/>
				            		<g:set var="geosCount" value="${Geo.list()?.size()}"/>
				            		
				            		<g:form method="POST" >
				            			<g:hiddenField name="deliveryRoleId" value="${deliveryRoleInstance.id}"/>
				            			<g:if test="${geosCount > 0 &&  undefinedGeoCount>0 }">
				            				
						            		<g:submitToRemote controller="relationDeliveryGeo" 
						            				action="addGeosForDeliveryRole" value="Add Territories" title="Add Territories"
						            				update="dvGeoForDeliveryRole"/>
						            		
						            		<table>
						            			<g:each in="${deliveryRoleInstance?.listUndefinedGeos()}" status="i" var="geo">
						            			<tr>
						            				<td> <g:checkBox name="check.${geo?.id}" value="${false}"/> </td>
						            				<td> ${geo.name} </td>
						            			</tr>
						            			</g:each>
						            		</table>
						            	</g:if>
						            	<g:elseif test="${geosCount == 0}">
						            		<br/>
						            		<br/>
						            		<h4> No Territories have been defined,  
						            			<a class="button" title="Create Territory" href="${baseurl }/geo/create"> click here to add</a> </h4>
						            	</g:elseif>
						            	<g:elseif test="${undefinedGeoCount == 0}">
						            		<br/>
						            		<br/>
						            		<h4> Rates/costs for all Territories are defined, 
						            			<a class="button" title="Create Territory" href="${baseurl }/geo/create"> click here to add </a>  </h4>
						            	</g:elseif>
					            	</g:form>
					            </div>
					            
					         </g:if>
						</div>
						
		            </div>
				
				</div>
				
			</div>
			
            
            
            
            
        </div>
    </body>
</html>
