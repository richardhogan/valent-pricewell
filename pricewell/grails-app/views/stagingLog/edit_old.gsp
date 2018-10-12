

<%@ page import="com.valent.pricewell.StagingLog" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'stagingLog.label', default: 'StagingLog')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.edit.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${stagingLogInstance}">
            <div class="errors">
                <g:renderErrors bean="${stagingLogInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <g:hiddenField name="id" value="${stagingLogInstance?.id}" />
                <g:hiddenField name="version" value="${stagingLogInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="dateModified"><g:message code="stagingLog.dateModified.label" default="Date Modified" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: stagingLogInstance, field: 'dateModified', 'errors')}">
                                    <g:datePicker name="dateModified" precision="day" value="${stagingLogInstance?.dateModified}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="action"><g:message code="stagingLog.action.label" default="Action" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: stagingLogInstance, field: 'action', 'errors')}">
                                    <g:textField name="action" value="${stagingLogInstance?.action}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="comment"><g:message code="stagingLog.comment.label" default="Comment" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: stagingLogInstance, field: 'comment', 'errors')}">
                                    <g:textField name="comment" value="${stagingLogInstance?.comment}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="fromStage"><g:message code="stagingLog.fromStage.label" default="From Stage" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: stagingLogInstance, field: 'fromStage', 'errors')}">
                                    <g:textField name="fromStage" value="${stagingLogInstance?.fromStage}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="modifiedBy"><g:message code="stagingLog.modifiedBy.label" default="Modified By" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: stagingLogInstance, field: 'modifiedBy', 'errors')}">
                                    <g:textField name="modifiedBy" value="${stagingLogInstance?.modifiedBy}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="serviceProfile"><g:message code="stagingLog.serviceProfile.label" default="Service Profile" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: stagingLogInstance, field: 'serviceProfile', 'errors')}">
                                    <g:select name="serviceProfile.id" from="${com.valent.pricewell.ServiceProfile.list()}" optionKey="id" value="${stagingLogInstance?.serviceProfile?.id}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="toStage"><g:message code="stagingLog.toStage.label" default="To Stage" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: stagingLogInstance, field: 'toStage', 'errors')}">
                                    <g:textField name="toStage" value="${stagingLogInstance?.toStage}" />
                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit class="save" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
