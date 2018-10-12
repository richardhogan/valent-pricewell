
<%@ page import="com.valent.pricewell.ReviewComment" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'reviewComment.label', default: 'ReviewComment')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
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
                            <td valign="top" class="name"><g:message code="reviewComment.id.label" default="Id" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: reviewCommentInstance, field: "id")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="reviewComment.comment.label" default="Comment" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: reviewCommentInstance, field: "comment")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="reviewComment.submitter.label" default="Submitter" /></td>
                            
                            <td valign="top" class="value"><g:link controller="user" action="show" id="${reviewCommentInstance?.submitter?.id}">${reviewCommentInstance?.submitter?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="reviewComment.dateCreated.label" default="Date Created" /></td>
                            
                            <td valign="top" class="value"><g:formatDate format="MMMMM d, yyyy" date="${reviewCommentInstance?.dateCreated}" /></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="reviewComment.dateModified.label" default="Date Modified" /></td>
                            
                            <td valign="top" class="value"><g:formatDate format="MMMMM d, yyyy" date="${reviewCommentInstance?.dateModified}" /></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="reviewComment.reviewRequest.label" default="Review Request" /></td>
                            
                            <td valign="top" class="value"><g:link controller="reviewRequest" action="show" id="${reviewCommentInstance?.reviewRequest?.id}">${reviewCommentInstance?.reviewRequest?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="reviewComment.statusChanged.label" default="Status Changed" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: reviewCommentInstance, field: "statusChanged")}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <g:hiddenField name="id" value="${reviewCommentInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
