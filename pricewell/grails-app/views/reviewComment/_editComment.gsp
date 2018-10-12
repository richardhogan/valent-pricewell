<%@ page import="com.valent.pricewell.ReviewComment" %>

 
  <div class="nav">
    <span class="menuButton"><g:remoteLink class="list" controller="reviewComment" title="List Of Comments"
    							action="listComments" id="${reviewCommentInstance?.reviewRequest?.id}"  
    							update="[success:'mainComment',failure:'mainComment']">
    								List Comments
    							</g:remoteLink></span>
</div>
   
        
        <div class="body">
                   
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${reviewCommentInstance}">
            <div class="errors">
                <g:renderErrors bean="${reviewCommentInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="updateComment" >
                
                <div class="dialog">
                    <table>
                        <tbody>
                        <g:hiddenField name="id" value="${reviewCommentInstance?.id}" />
                		<g:hiddenField name="version" value="${reviewCommentInstance?.version}" />
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
                    <span>
                    <g:submitToRemote name="create" class="save" controller="reviewComment" action="updateComment" 
                    	 	value="${message(code: 'default.button.create.label', default: 'Create')}" title="Update Comment"
                    			update="[success:'mainComment',failure:'mainComment']"/>
                    			</span>
                </div>
            </g:form>
        </div>
    