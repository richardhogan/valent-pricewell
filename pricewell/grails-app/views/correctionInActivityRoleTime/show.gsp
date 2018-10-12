
<%@ page import="com.valent.pricewell.CorrectionInActivityRoleTime" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'correctionInActivityRoleTime.label', default: 'CorrectionInActivityRoleTime')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
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
                            <td valign="top" class="name"><g:message code="correctionInActivityRoleTime.id.label" default="Id" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: correctionInActivityRoleTimeInstance, field: "id")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="correctionInActivityRoleTime.extraHours.label" default="Extra Hours" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: correctionInActivityRoleTimeInstance, field: "extraHours")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="correctionInActivityRoleTime.originalHours.label" default="Original Hours" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: correctionInActivityRoleTimeInstance, field: "originalHours")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="correctionInActivityRoleTime.serviceActivity.label" default="Service Activity" /></td>
                            
                            <td valign="top" class="value"><g:link controller="serviceActivity" action="show" id="${correctionInActivityRoleTimeInstance?.serviceActivity?.id}">${correctionInActivityRoleTimeInstance?.serviceActivity?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="correctionInActivityRoleTime.serviceQuotation.label" default="Service Quotation" /></td>
                            
                            <td valign="top" class="value"><g:link controller="serviceQuotation" action="show" id="${correctionInActivityRoleTimeInstance?.serviceQuotation?.id}">${correctionInActivityRoleTimeInstance?.serviceQuotation?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="correctionInActivityRoleTime.role.label" default="Role" /></td>
                            
                            <td valign="top" class="value"><g:link controller="deliveryRole" action="show" id="${correctionInActivityRoleTimeInstance?.role?.id}">${correctionInActivityRoleTimeInstance?.role?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <g:hiddenField name="id" value="${correctionInActivityRoleTimeInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
