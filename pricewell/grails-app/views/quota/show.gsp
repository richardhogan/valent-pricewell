<%@ page import="org.apache.shiro.SecurityUtils"%>
<%@ page import="com.valent.pricewell.Quota" %>
<%@ page import="com.valent.pricewell.User" %>
<%
def user = User.get(new Long(SecurityUtils.subject.principal))
 %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'quota.label', default: 'Quota')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <!-- <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>-->
        </div>
        <div class="body">            
	
			<div class="collapsibleContainer">
				<div class="collapsibleContainerTitle ui-widget-header">
					<div>
						<b>Quota from <g:formatDate format="MMMMM d, yyyy" date="${quotaInstance?.fromDate}" /> 
								  To <g:formatDate format="MMMMM d, yyyy" date="${quotaInstance?.toDate}" /> Months</b> 
						&nbsp;&nbsp;
					</div>
				</div>
			
				<div class="collapsibleContainerContent ui-widget-content">
				
					<table>
	                    <tbody>
	                    
	                        <!-- <tr class="prop">
	                            <td valign="top" class="name"><g:message code="quota.id.label" default="Id" /></td>
	                            
	                            <td valign="top" class="value">${fieldValue(bean: quotaInstance, field: "id")}</td>
	                            
	                        </tr>-->
	                    
	                    	<tr class="prop">
	                            <td valign="top" class="name"><label><g:message code="quota.timespan.label" default="Time Duration : " /></label></td>
	                            
	                            <td valign="top" class="value"><g:formatDate format="MMMMM d, yyyy" date="${quotaInstance?.fromDate}" /> To <g:formatDate format="MMMMM d, yyyy" date="${quotaInstance?.toDate}" /></td>
	                            
	                        </tr>
	                        
	                        <tr class="prop">
	                            <td valign="top" class="name"><label><g:message code="quota.amount.label" default="Quota Amount : " /></label></td>
	                            
	                            <td valign="top" class="value">${fieldValue(bean: quotaInstance, field: "currency")} ${fieldValue(bean: quotaInstance, field: "amount")}</td>
	                            
	                        </tr>
	                    
	                        <tr class="prop">
	                            <td valign="top" class="name"><label><g:message code="quota.createdBy.label" default="Assigned By : " /></label></td>
	                            <g:if test="${user?.id == quotaInstance?.createdBy?.id}">
	                            	<td>You</td>
	                            </g:if>
	                            <g:else>
	                            	<td valign="top" class="value">${quotaInstance?.createdBy?.encodeAsHTML()}</td>
	                            </g:else>
	                            
	                        </tr>
	                        
	                        <tr class="prop">
	                            <td valign="top" class="name"><label><g:message code="quota.createdBy.label" default="Assigned To : " /></label></td>
	                            <g:if test="${user?.id == quotaInstance?.person?.id}">
	                            	<td>You</td>
	                            </g:if>
	                            <g:else>
	                            	<td valign="top" class="value">${quotaInstance?.person?.encodeAsHTML()}</td>
	                            </g:else>
	                            
	                            
	                        </tr>
	                    
	                    </tbody>
	                </table>
			
				</div>
			</div>
	
            <!-- <div class="buttons">
                <g:form>
                    <g:hiddenField name="id" value="${quotaInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </g:form>
            </div>-->
        </div>
    </body>
</html>
