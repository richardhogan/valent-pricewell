<%@ page import="com.valent.pricewell.StagingLog" %>
<html>
    
    <body>
       
        <div class="body">
            <g:form method="post" >
                <g:hiddenField name="id" value="${stagingLogInstance?.id}" />
                <g:hiddenField name="version" value="${stagingLogInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        	<tr class="prop">
                                <td valign="top" class="name">
                                  <label for="fromStage"><g:message code="stagingLog.fromStage.label" default="From Stage" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: stagingLogInstance, field: 'fromStage', 'errors')}">
                                    <g:textField name="fromStage" value="${stagingLogInstance?.fromStage}" />
                                </td>
                            </tr>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="toStage"><g:message code="stagingLog.toStage.label" default="To Stage" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: stagingLogInstance, field: 'toStage', 'errors')}">
                                    <g:textField name="toStage" value="${stagingLogInstance?.toStage}" />
                                </td>
                            </tr>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="action"><g:message code="stagingLog.action.label" default="Action" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: stagingLogInstance, field: 'action', 'errors')}">
                                    <g:textField name="action" value="${stagingLogInstance?.action}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="comment"><g:message code="stagingLog.comment.label" default="Comment" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: stagingLogInstance, field: 'comment', 'errors')}">
                                    <g:textField name="comment" value="${stagingLogInstance?.comment}" />
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
