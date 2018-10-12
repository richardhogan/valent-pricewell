<%@ page import="com.valent.pricewell.ServiceDeliverable" %>
    
<g:setProvider library="prototype"/>
<div>
    <span class="menuButton"><g:remoteLink class="list" action="list">Edit</g:remoteLink></span>
    <span class="menuButton"><g:remoteLink class="delete" action="list">Delete</g:remoteLink></span>
    <span class="menuButton"><g:remoteLink class="create" action="list">Add Activity</g:remoteLink></span>
</div>
<div/>
<div> 
    <g:if test="${flash.message}">
    	<div class="message">${flash.message}</div>
    </g:if>
    <g:hasErrors bean="${it}">
    <div class="errors">
        <g:renderErrors bean="${it}" as="list" />
    </div>
    </g:hasErrors>
        <div class="dialog">
            <table>
                <tbody>
                
                    <tr class="prop">
                        <td valign="top" class="name">
                            <label for="name"><g:message code="serviceDeliverable.name.label" default="Name" /> 
                            </label>
                        </td>
                        <td>${fieldValue(bean: it, field: "name")}</td>
                        
                    </tr>
                
                    <tr class="prop">
                        <td valign="top" class="name">
                            <label for="type"><g:message code="serviceDeliverable.type.label" default="Type" /></label>
                        </td>
                         <td>${fieldValue(bean: it, field: "type")}</td>
                    </tr>
                
                    <tr class="prop">
                        <td valign="top" class="name">
                            <label for="description"><g:message code="serviceDeliverable.description.label" default="Description" /></label>
                        </td>
                         <td>${it?.newDescription?.value}</td>
                    </tr>
                
                </tbody>
            </table>
        </div>
</div>
    
