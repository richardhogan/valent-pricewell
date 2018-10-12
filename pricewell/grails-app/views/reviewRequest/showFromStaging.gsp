<%@ page import="com.valent.pricewell.ReviewRequest" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'reviewRequest.label', default: 'ReviewRequest')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.create.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${reviewRequestInstance}">
            <div class="errors">
                <g:renderErrors bean="${reviewRequestInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" >
            
            <g:hiddenField name="serviceProfileId" value="${serviceProfileId}" />
            <g:hiddenField name="userId" value="${userId}" />
           
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="subject"><g:message code="reviewRequest.subject.label" default="Subject" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: reviewRequestInstance, field: 'subject', 'errors')}">
                                    <g:textField name="subject" value="${params.subject}" style="width:625px;"/>
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="description"><g:message code="reviewRequest.description.label" default="Description" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: reviewRequestInstance, field: 'description', 'errors')}">
                                    <g:textArea name="description" rows="4" cols="50" style="width:625px;" value="${params.description}" />
                                </td>
                            </tr>
                           
                         <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="assignees"><g:message code="reviewRequest.assignees.label" default="Assignees" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: reviewRequestInstance, field: 'assignees', 'errors')}">
                                    <g:select name="assignees" from="${com.valent.pricewell.User.list()}" multiple="yes" optionKey="id" size="5" value="${serviceProfileInstance?.reviewRequestInstance?.assignees*.id}" />
                                </td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="status"><g:message code="reviewRequest.status.label" default="Status" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: reviewRequestInstance, field: 'status', 'errors')}">
                                            REVIEW
                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
