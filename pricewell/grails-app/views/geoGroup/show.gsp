
<%@ page import="com.valent.pricewell.GeoGroup" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'default.geoGroup.label', default: 'Geo')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span><g:link class="buttons.button button" title="List Of GEOs" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <g:if test="${createPermission}">
            	<span><g:link class="buttons.button button" title="Create GEO" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
           	</g:if>
        	<!-- <span><g:link class="buttons.button button" action="list" controller="deliveryRole">List of Delivery Roles</g:link></span>
            <span><g:link class="buttons.button button" action="list" controller="geo">List of Territories</g:link></span>-->
        </div>
        <div class="body">
        
        	<div class="collapsibleContainer">
				<div class="collapsibleContainerTitle ui-widget-header">
					<div><g:message code="default.show.label" args="[entityName]" /></div>
				</div>
			
				<div class="collapsibleContainerContent">
				
					<div class="dialog">
		                <table>
		                    <tbody>
		                    
		                        <tr class="prop">
		                            <td valign="top" class="name"><label><g:message code="geoGroup.id.label" default="Id" /></label></td>
		                            
		                            <td valign="top" class="value">${fieldValue(bean: geoGroupInstance, field: "id")}</td>
		                            
		                        </tr>
		                    
		                        <tr class="prop">
		                            <td valign="top" class="name"><label><g:message code="geoGroup.name.label" default="Name" /></label></td>
		                            
		                            <td valign="top" class="value">${fieldValue(bean: geoGroupInstance, field: "name")}</td>
		                            
		                        </tr>
		                    
		                        <tr class="prop">
		                            <td valign="top" class="name"><label><g:message code="geoGroup.description.label" default="Description" /></label></td>
		                            
		                            <td valign="top" class="value">${fieldValue(bean: geoGroupInstance, field: "description")}</td>
		                            
		                        </tr>
		                        
		                        <tr class="prop">
		                            <td valign="top" class="name"><label><g:message code="geoGroup.generalManager.label" default="Assigned General Manager" /></label></td>
		                            
		                            <td>
		                            	<g:each in="${geoGroupInstance.generalManagers}" var="g">
		                                    ${g?.encodeAsHTML()}
		                                </g:each>
		                            </td>
		                            
		                        </tr>
		                    
		                        <tr class="prop">
		                            <td valign="top" class="name"><label><g:message code="default.geo.list" default="Territories" /></label></td>
		                            
		                            <td valign="top" style="text-align: left;" class="value">
		                                <ul>
			                                <g:each in="${geoGroupInstance.geos}" var="g">
			                                    <li><g:link controller="geo" action="show" id="${g.id}">${g?.encodeAsHTML()}</g:link></li>
			                                </g:each>
		                                </ul>
		                            </td>
		                            
		                        </tr>
		                    
		                    </tbody>
		                </table>
		            </div>
		            <div class="buttons">
		                <g:if test="${createPermission}">
			                <g:form>
			                    <g:hiddenField name="id" value="${geoGroupInstance?.id}" />
			                    <span class="button"><g:actionSubmit title="Edit GEO" class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
			                    <span class="button"><g:actionSubmit title="Delete GEO" class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
			                </g:form>
		                </g:if>
		            </div>
				
				</div>
				
			</div>
        
            
        </div>
    </body>
</html>
