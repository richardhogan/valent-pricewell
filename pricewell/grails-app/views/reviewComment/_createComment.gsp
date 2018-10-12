<%@ page import="com.valent.pricewell.ReviewComment" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main1" />
        <g:set var="entityName" value="${message(code: 'reviewComment.label', default: 'ReviewComment')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
    	
    	<g:javascript library="jquery" plugin="jquery"/>
		 <script src="${baseurl}/js/jquery.validate.js"></script>
		<script>
		 (function($) {
			  $(document).ready(function()
			  {				 
			    $("#rewiewCommentCreate").validate();
			  });
			  
			  
		 })(jQuery);
  		</script>
    </head>
    <body>
        <div class="nav">          
    <span class="menuButton">
    <g:remoteLink class="list" controller="reviewComment" title="Review Comment"
    							action="listComments" id="${reviewRequestId}"  
    							update="[success:'mainComment',failure:'mainComment']">
    								< Back
    							</g:remoteLink></span>
           
        </div>
        <div class="body">
            
            <g:hasErrors bean="${reviewCommentInstance}">
            <div class="errors">
                <g:renderErrors bean="${reviewCommentInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" name="rewiewCommentCreate">
            	<g:hiddenField name="reviewRequestId" value="${reviewRequestId}"/>
            	<g:hiddenField name="source" value="reviewRequest"/>
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="comment"><g:message code="reviewComment.comment.label" default="Comment" /></label>
                                	<em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: reviewCommentInstance, field: 'comment', 'errors')}">
                                    <g:textArea readonly class="placeholder" style="resize: none; height: 88px;width:725px; overflow-x: hidden; overflow-y: hidden; " name="comment" value="${reviewCommentInstance?.comment}" class="required"/>
                                </td>
                            </tr>
				
							<g:if test="${false}">                        
                        	
                             <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="statusChanged"><g:message code="reviewComment.statusChanged.label" default="Change Status To" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: reviewCommentInstance, field: 'statusChanged', 'errors')}">
                                	<g:select name="status" from="${com.valent.pricewell.ReviewRequest$Status?.values()}" keys="${com.valent.pricewell.ReviewRequest$Status?.values()*.name()}" value="${reviewRequestInstance?.status?.name()}"  noSelection="['':'-No Change-']" size="5" disabled="${!statusChangeAllowed}"/>
                                </td>
                            </tr>
                            </g:if>
                            
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">                                
                 	<span class="button">
                 
                 		<g:if test="${commentAllowed}">
                 			<g:submitToRemote update="mainComment" name="Update" title="Save" class="save" controller="reviewComment" action="saveComment" value="Update" />
                 		</g:if>
                 	</span>   
                </div>
            </g:form>
        </div>
     </body>
</html>
    