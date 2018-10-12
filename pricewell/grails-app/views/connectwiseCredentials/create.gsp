

<%@ page import="com.valent.pricewell.ConnectwiseCredentials" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'connectwiseCredentials.label', default: 'ConnectwiseCredentials')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.create.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${connectwiseCredentialsInstance}">
            <div class="errors">
                <g:renderErrors bean="${connectwiseCredentialsInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="createdBy"><g:message code="connectwiseCredentials.createdBy.label" default="Created By" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: connectwiseCredentialsInstance, field: 'createdBy', 'errors')}">
                                    <g:select name="createdBy.id" from="${com.valent.pricewell.User.list()}" optionKey="id" value="${connectwiseCredentialsInstance?.createdBy?.id}" noSelection="['null': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="modifiedBy"><g:message code="connectwiseCredentials.modifiedBy.label" default="Modified By" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: connectwiseCredentialsInstance, field: 'modifiedBy', 'errors')}">
                                    <g:select name="modifiedBy.id" from="${com.valent.pricewell.User.list()}" optionKey="id" value="${connectwiseCredentialsInstance?.modifiedBy?.id}" noSelection="['null': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="modifiedDate"><g:message code="connectwiseCredentials.modifiedDate.label" default="Modified Date" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: connectwiseCredentialsInstance, field: 'modifiedDate', 'errors')}">
                                    <g:datePicker name="modifiedDate" precision="day" value="${connectwiseCredentialsInstance?.modifiedDate}" default="none" noSelection="['': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="createdDate"><g:message code="connectwiseCredentials.createdDate.label" default="Created Date" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: connectwiseCredentialsInstance, field: 'createdDate', 'errors')}">
                                    <g:datePicker name="createdDate" precision="day" value="${connectwiseCredentialsInstance?.createdDate}" default="none" noSelection="['': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="companyId"><g:message code="connectwiseCredentials.companyId.label" default="Company Id" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: connectwiseCredentialsInstance, field: 'companyId', 'errors')}">
                                    <g:textField name="companyId" value="${connectwiseCredentialsInstance?.companyId}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="password"><g:message code="connectwiseCredentials.password.label" default="Password" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: connectwiseCredentialsInstance, field: 'password', 'errors')}">
                                    <g:textField name="password" value="${connectwiseCredentialsInstance?.password}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="siteUrl"><g:message code="connectwiseCredentials.siteUrl.label" default="Site Url" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: connectwiseCredentialsInstance, field: 'siteUrl', 'errors')}">
                                    <g:textField name="siteUrl" value="${connectwiseCredentialsInstance?.siteUrl}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="userId"><g:message code="connectwiseCredentials.userId.label" default="User Id" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: connectwiseCredentialsInstance, field: 'userId', 'errors')}">
                                    <g:textField name="userId" value="${connectwiseCredentialsInstance?.userId}" />
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
