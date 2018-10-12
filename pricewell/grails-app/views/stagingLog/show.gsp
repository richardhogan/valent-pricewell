
<%@ page import="com.valent.pricewell.StagingLog" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'stagingLog.label', default: 'StagingLog')}" />
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
                            <td valign="top" class="name"><g:message code="stagingLog.id.label" default="Id" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: stagingLogInstance, field: "id")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="stagingLog.dateModified.label" default="Date Modified" /></td>
                            
                            <td valign="top" class="value"><g:formatDate format="MMMMM d, yyyy" date="${stagingLogInstance?.dateModified}" /></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="stagingLog.action.label" default="Action" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: stagingLogInstance, field: "action")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="stagingLog.comment.label" default="Comment" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: stagingLogInstance, field: "comment")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="stagingLog.fromStage.label" default="From Stage" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: stagingLogInstance, field: "fromStage")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="stagingLog.modifiedBy.label" default="Modified By" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: stagingLogInstance, field: "modifiedBy")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="stagingLog.serviceProfile.label" default="Service Profile" /></td>
                            
                            <td valign="top" class="value"><g:link controller="serviceProfile" action="show" id="${stagingLogInstance?.serviceProfile?.id}">${stagingLogInstance?.serviceProfile?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="stagingLog.toStage.label" default="To Stage" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: stagingLogInstance, field: "toStage")}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <g:hiddenField name="id" value="${stagingLogInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
