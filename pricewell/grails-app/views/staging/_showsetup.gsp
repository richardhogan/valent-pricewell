
<%@ page import="com.valent.pricewell.Staging" %>

    <g:set var="entityName" value="${message(code: 'staging.label', default: 'Staging')}" />
    <title><g:message code="default.show.label" args="[entityName]" /></title>
        
    <div class="body">
        
			<g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <label><td valign="top" class="name"><g:message code="staging.id.label" default="Id" /></td></label>
                            
                            <td valign="top" class="value">${fieldValue(bean: stagingInstance, field: "id")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <label><td valign="top" class="name"><g:message code="staging.entity.label" default="Entity" /></td></label>
                            
                            <td valign="top" class="value">${stagingInstance?.entity?.encodeAsHTML()}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <label><td valign="top" class="name"><g:message code="staging.sequenceOrder.label" default="Sequence Order" /></td></label>
                            
                            <td valign="top" class="value">${fieldValue(bean: stagingInstance, field: "sequenceOrder")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <label><td valign="top" class="name"><g:message code="staging.types.label" default="Types" /></td></label>
                            
                            <td valign="top" class="value">${fieldValue(bean: stagingInstance, field: "types")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <label><td valign="top" class="name"><g:message code="staging.description.label" default="Description" /></td></label>
                            
                            <td valign="top" class="value">${fieldValue(bean: stagingInstance, field: "description")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <label><td valign="top" class="name"><g:message code="staging.displayName.label" default="Display Name" /></td></label>
                            
                            <td valign="top" class="value">${fieldValue(bean: stagingInstance, field: "displayName")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <label><td valign="top" class="name"><g:message code="staging.name.label" default="Name" /></td></label>
                            
                            <td valign="top" class="value">${fieldValue(bean: stagingInstance, field: "name")}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
		           
    </div>

