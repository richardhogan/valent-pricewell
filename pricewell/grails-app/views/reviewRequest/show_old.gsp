
<%@ page import="com.valent.pricewell.ReviewRequest" %>
<%@ page import="com.valent.pricewell.Service" %>
<%@ page import="com.valent.pricewell.ServiceProfile" %>
<%@ page import="com.valent.pricewell.*" %>
<g:javascript library="prototype" />
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'reviewRequest.label', default: 'ReviewRequest')}" />
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
                            <td valign="top" class="name"><g:message code="reviewRequest.subject.label" default="Subject" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: reviewRequestInstance, field: "subject")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="reviewRequest.description.label" default="Description" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: reviewRequestInstance, field: "description")}</td>
                            
                        </tr>
                                           
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="reviewRequest.submitter.label" default="Submitter" /></td>
                            
                            <td valign="top" class="value"><g:link controller="user" action="show" id="${reviewRequestInstance?.submitter?.id}">${reviewRequestInstance?.submitter?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="reviewRequest.assignees.label" default="Assignees" /></td>
                            
                            <td valign="top" style="text-align: left;" class="value">
                                <ul>
                                <g:each in="${reviewRequestInstance.assignees}" var="a">
                                    <li><g:link controller="user" action="show" id="${a.id}">${a?.encodeAsHTML()}</g:link></li>
                                </g:each>
                                </ul>
                            </td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="reviewRequest.open.label" default="Open" /></td>
                            
                            <td valign="top" class="value"><g:formatBoolean boolean="${reviewRequestInstance?.open}" /></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="reviewRequest.reviewComments.label" default="Review Comments" /></td>
                            
                            <td valign="top" style="text-align: left;" class="value">
                                <ul>
                                <g:each in="${reviewRequestInstance.reviewComments}" var="r">
                                    <li><g:link controller="reviewComment" action="show" id="${r.id}">${r?.encodeAsHTML()}</g:link></li>
                                </g:each>
                                </ul>
                            </td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="reviewRequest.serviceProfile.label" default="Service Profile" /></td>
                            
                            <td valign="top" class="value"><g:link controller="serviceProfile" action="show" id="${reviewRequestInstance?.serviceProfile?.id}">${reviewRequestInstance?.serviceProfile?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="reviewRequest.status.label" default="Status" /></td>
                            
                            <td valign="top" class="value">${reviewRequestInstance?.status?.encodeAsHTML()}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <g:textField name="id" value="${reviewRequestInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                
                </g:form>
                   <br>
             </div>
			 
			<div>
				
				<table> 
					<g:hiddenField name="reviewRequestId" value="${reviewRequestInstance?.id}"/>
					<tr>
						<td>
							<b>Add Comment </b>
						</td>
					</tr>
					<tr>
						<td>
							<g:textArea name="comment"/>
						</td>
					</tr>
					//todo:user session ma nakh vu submit karva mate via hidden field
					<tr> 
						<td>
							<span class="menuButton">
						<g:remoteLink class="create" controller="reviewComment" 
    							action="addComment" id="${reviewRequestInstance?.id}"  
    							update="[success:'mainComment',failure:'mainComment']">
    								Add Comment
    							</g:remoteLink></span>
						</td>
					</tr>
				</table>
				
    		</div>
			<div >
				//each review comment   show.gsp valu page redirect karvu
			</div>
        
    </body>
</html>

