

<%@ page import="com.valent.pricewell.GeneralStagingLog" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'generalStagingLog.label', default: 'GeneralStagingLog')}" />
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
            <g:hasErrors bean="${generalStagingLogInstance}">
            <div class="errors">
                <g:renderErrors bean="${generalStagingLogInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <g:hiddenField name="id" value="${generalStagingLogInstance?.id}" />
                <g:hiddenField name="version" value="${generalStagingLogInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="dateModified"><g:message code="generalStagingLog.dateModified.label" default="Date Modified" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: generalStagingLogInstance, field: 'dateModified', 'errors')}">
                                    <g:datePicker name="dateModified" precision="day" value="${generalStagingLogInstance?.dateModified}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="fromStage"><g:message code="generalStagingLog.fromStage.label" default="From Stage" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: generalStagingLogInstance, field: 'fromStage', 'errors')}">
                                    <g:select name="fromStage.id" from="${com.valent.pricewell.Staging.list()}" optionKey="id" value="${generalStagingLogInstance?.fromStage?.id}" noSelection="['null': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="toStage"><g:message code="generalStagingLog.toStage.label" default="To Stage" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: generalStagingLogInstance, field: 'toStage', 'errors')}">
                                    <g:select name="toStage.id" from="${com.valent.pricewell.Staging.list()}" optionKey="id" value="${generalStagingLogInstance?.toStage?.id}" noSelection="['null': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="action"><g:message code="generalStagingLog.action.label" default="Action" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: generalStagingLogInstance, field: 'action', 'errors')}">
                                    <g:textField name="action" value="${generalStagingLogInstance?.action}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="comment"><g:message code="generalStagingLog.comment.label" default="Comment" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: generalStagingLogInstance, field: 'comment', 'errors')}">
                                    <g:textField name="comment" value="${generalStagingLogInstance?.comment}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="modifiedBy"><g:message code="generalStagingLog.modifiedBy.label" default="Modified By" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: generalStagingLogInstance, field: 'modifiedBy', 'errors')}">
                                    <g:textField name="modifiedBy" value="${generalStagingLogInstance?.modifiedBy}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="revision"><g:message code="generalStagingLog.revision.label" default="Revision" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: generalStagingLogInstance, field: 'revision', 'errors')}">
                                    <g:textField name="revision" value="${fieldValue(bean: generalStagingLogInstance, field: 'revision')}" />
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
