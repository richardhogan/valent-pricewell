<%@ page import="com.valent.pricewell.ReviewComment" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'reviewComment.label', default: 'ReviewComment')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
           <span class="menuButton"><g:link class="create" action="addComment" controller="reviewComment"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                            <g:sortableColumn property="id" title="${message(code: 'reviewComment.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="comment" title="${message(code: 'reviewComment.comment.label', default: 'Comment')}" />
                        
                            <th><g:message code="reviewComment.submitter.label" default="Submitter" /></th>
                        
                            <g:sortableColumn property="dateCreated" title="${message(code: 'reviewComment.dateCreated.label', default: 'Date Created')}" />
                        
                            <g:sortableColumn property="dateModified" title="${message(code: 'reviewComment.dateModified.label', default: 'Date Modified')}" />
                        
                            <th><g:message code="reviewComment.reviewRequest.label" default="Review Request" /></th>
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${reviewCommentInstanceList}" status="i" var="reviewCommentInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${reviewCommentInstance.id}">${fieldValue(bean: reviewCommentInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: reviewCommentInstance, field: "comment")}</td>
                        
                            <td>${fieldValue(bean: reviewCommentInstance, field: "submitter")}</td>
                        
                            <td><g:formatDate format="MMMMM d, yyyy" date="${reviewCommentInstance.dateCreated}" /></td>
                        
                            <td><g:formatDate format="MMMMM d, yyyy" date="${reviewCommentInstance.dateModified}" /></td>
                        
                            <td>${fieldValue(bean: reviewCommentInstance, field: "reviewRequest")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
           
        </div>
    </body>
</html>

