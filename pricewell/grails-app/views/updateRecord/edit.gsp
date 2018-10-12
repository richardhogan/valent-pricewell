

<%@ page import="com.valent.pricewell.UpdateRecord" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'updateRecord.label', default: 'UpdateRecord')}" />
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
            <g:hasErrors bean="${updateRecordInstance}">
            <div class="errors">
                <g:renderErrors bean="${updateRecordInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <g:hiddenField name="id" value="${updateRecordInstance?.id}" />
                <g:hiddenField name="version" value="${updateRecordInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="recordType"><g:message code="updateRecord.recordType.label" default="Record Type" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: updateRecordInstance, field: 'recordType', 'errors')}">
                                    <g:textField name="recordType" value="${updateRecordInstance?.recordType}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="beginUpdateDate"><g:message code="updateRecord.beginUpdateDate.label" default="Begin Update Date" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: updateRecordInstance, field: 'beginUpdateDate', 'errors')}">
                                    <g:datePicker name="beginUpdateDate" precision="day" value="${updateRecordInstance?.beginUpdateDate}" default="none" noSelection="['': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="lastUpdateDate"><g:message code="updateRecord.lastUpdateDate.label" default="Last Update Date" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: updateRecordInstance, field: 'lastUpdateDate', 'errors')}">
                                    <g:datePicker name="lastUpdateDate" precision="day" value="${updateRecordInstance?.lastUpdateDate}" default="none" noSelection="['': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="comments"><g:message code="updateRecord.comments.label" default="Comments" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: updateRecordInstance, field: 'comments', 'errors')}">
                                    <g:textField name="comments" value="${updateRecordInstance?.comments}" />
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
