

<%@ page import="com.valent.pricewell.SalesforceCredentials" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'salesforceCredentials.label', default: 'SalesforceCredentials')}" />
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
            <g:hasErrors bean="${salesforceCredentialsInstance}">
            <div class="errors">
                <g:renderErrors bean="${salesforceCredentialsInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <g:hiddenField name="id" value="${salesforceCredentialsInstance?.id}" />
                <g:hiddenField name="version" value="${salesforceCredentialsInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="username"><g:message code="salesforceCredentials.username.label" default="Username" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: salesforceCredentialsInstance, field: 'username', 'errors')}">
                                    <g:textField name="username" value="${salesforceCredentialsInstance?.username}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="password"><g:message code="salesforceCredentials.password.label" default="Password" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: salesforceCredentialsInstance, field: 'password', 'errors')}">
                                    <g:textField name="password" value="${salesforceCredentialsInstance?.password}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="securityToken"><g:message code="salesforceCredentials.securityToken.label" default="Security Token" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: salesforceCredentialsInstance, field: 'securityToken', 'errors')}">
                                    <g:textField name="securityToken" value="${salesforceCredentialsInstance?.securityToken}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="instanceUri"><g:message code="salesforceCredentials.instanceUri.label" default="Instance Uri" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: salesforceCredentialsInstance, field: 'instanceUri', 'errors')}">
                                    <g:textField name="instanceUri" value="${salesforceCredentialsInstance?.instanceUri}" />
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
