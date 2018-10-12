

<%@ page import="com.valent.pricewell.ReviewComment" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'reviewComment.label', default: 'ReviewComment')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.edit.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${reviewCommentInstance}">
            <div class="errors">
                <g:renderErrors bean="${reviewCommentInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <g:hiddenField name="id" value="${reviewCommentInstance?.id}" />
                <g:hiddenField name="version" value="${reviewCommentInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="comment"><g:message code="reviewComment.comment.label" default="Comment" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: reviewCommentInstance, field: 'comment', 'errors')}">
                                    <g:textField name="comment" value="${reviewCommentInstance?.comment}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="submitter"><g:message code="reviewComment.submitter.label" default="Submitter" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: reviewCommentInstance, field: 'submitter', 'errors')}">
                                    <g:select name="submitter.id" from="${com.valent.pricewell.User.list()}" optionKey="id" value="${reviewCommentInstance?.submitter?.id}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="dateModified"><g:message code="reviewComment.dateModified.label" default="Date Modified" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: reviewCommentInstance, field: 'dateModified', 'errors')}">
                                    <g:datePicker name="dateModified" precision="day" value="${reviewCommentInstance?.dateModified}" default="none" noSelection="['': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="reviewRequest"><g:message code="reviewComment.reviewRequest.label" default="Review Request" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: reviewCommentInstance, field: 'reviewRequest', 'errors')}">
                                    <g:select name="reviewRequest.id" from="${com.valent.pricewell.ReviewRequest.list()}" optionKey="id" value="${reviewCommentInstance?.reviewRequest?.id}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="statusChanged"><g:message code="reviewComment.statusChanged.label" default="Status Changed" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: reviewCommentInstance, field: 'statusChanged', 'errors')}">
                                    <g:textField name="statusChanged" value="${reviewCommentInstance?.statusChanged}" />
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
