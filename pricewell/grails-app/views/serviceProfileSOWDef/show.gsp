
<%@ page import="com.valent.pricewell.ServiceProfileSOWDef" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'serviceProfileSOWDef.label', default: 'ServiceProfileSOWDef')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
        
        <g:setProvider library="prototype"/>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.show.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="serviceProfileSOWDef.id.label" default="Id" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: serviceProfileSOWDefInstance, field: "id")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="serviceProfileSOWDef.geo.label" default="Geo" /></td>
                            
                            <td valign="top" class="value"><g:link controller="geo" action="show" id="${serviceProfileSOWDefInstance?.geo?.id}">${serviceProfileSOWDefInstance?.geo?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="serviceProfileSOWDef.part.label" default="Part" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: serviceProfileSOWDefInstance, field: "part")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="serviceProfileSOWDef.definition.label" default="Definition" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: serviceProfileSOWDefInstance, field: "definition")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="serviceProfileSOWDef.sp.label" default="Sp" /></td>
                            
                            <td valign="top" class="value"><g:link controller="serviceProfile" action="show" id="${serviceProfileSOWDefInstance?.sp?.id}">${serviceProfileSOWDefInstance?.sp?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <g:hiddenField name="id" value="${serviceProfileSOWDefInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
