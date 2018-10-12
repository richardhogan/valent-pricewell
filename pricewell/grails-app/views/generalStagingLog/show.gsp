
<%@ page import="com.valent.pricewell.GeneralStagingLog" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'generalStagingLog.label', default: 'GeneralStagingLog')}" />
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
                            <td valign="top" class="name"><g:message code="generalStagingLog.id.label" default="Id" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: generalStagingLogInstance, field: "id")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="generalStagingLog.dateModified.label" default="Date Modified" /></td>
                            
                            <td valign="top" class="value"><g:formatDate format="MMMMM d, yyyy" date="${generalStagingLogInstance?.dateModified}" /></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="generalStagingLog.fromStage.label" default="From Stage" /></td>
                            
                            <td valign="top" class="value"><g:link controller="staging" action="show" id="${generalStagingLogInstance?.fromStage?.id}">${generalStagingLogInstance?.fromStage?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="generalStagingLog.toStage.label" default="To Stage" /></td>
                            
                            <td valign="top" class="value"><g:link controller="staging" action="show" id="${generalStagingLogInstance?.toStage?.id}">${generalStagingLogInstance?.toStage?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="generalStagingLog.action.label" default="Action" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: generalStagingLogInstance, field: "action")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="generalStagingLog.comment.label" default="Comment" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: generalStagingLogInstance, field: "comment")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="generalStagingLog.modifiedBy.label" default="Modified By" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: generalStagingLogInstance, field: "modifiedBy")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="generalStagingLog.revision.label" default="Revision" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: generalStagingLogInstance, field: "revision")}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <g:hiddenField name="id" value="${generalStagingLogInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
