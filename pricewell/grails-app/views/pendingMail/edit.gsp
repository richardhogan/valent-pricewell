

<%@ page import="com.valent.pricewell.PendingMail" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'pendingMail.label', default: 'PendingMail')}" />
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
            <g:hasErrors bean="${pendingMailInstance}">
            <div class="errors">
                <g:renderErrors bean="${pendingMailInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <g:hiddenField name="id" value="${pendingMailInstance?.id}" />
                <g:hiddenField name="version" value="${pendingMailInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="emailId"><g:message code="pendingMail.emailId.label" default="Email Id" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: pendingMailInstance, field: 'emailId', 'errors')}">
                                    <g:textField name="emailId" value="${pendingMailInstance?.emailId}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="message"><g:message code="pendingMail.message.label" default="Message" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: pendingMailInstance, field: 'message', 'errors')}">
                                    <g:textField name="message" value="${pendingMailInstance?.message}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="subject"><g:message code="pendingMail.subject.label" default="Subject" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: pendingMailInstance, field: 'subject', 'errors')}">
                                    <g:textField name="subject" value="${pendingMailInstance?.subject}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="createDate"><g:message code="pendingMail.createDate.label" default="Create Date" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: pendingMailInstance, field: 'createDate', 'errors')}">
                                    <g:datePicker name="createDate" precision="day" value="${pendingMailInstance?.createDate}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="active"><g:message code="pendingMail.active.label" default="Active" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: pendingMailInstance, field: 'active', 'errors')}">
                                    <g:checkBox name="active" value="${pendingMailInstance?.active}" />
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
