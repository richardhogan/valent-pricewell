

<%@ page import="com.valent.pricewell.ProjectParameter" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'projectParameter.label', default: 'ProjectParameter')}" />
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
            <g:hasErrors bean="${projectParameterInstance}">
            <div class="errors">
                <g:renderErrors bean="${projectParameterInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="value"><g:message code="projectParameter.value.label" default="Value" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: projectParameterInstance, field: 'value', 'errors')}">
                                    <g:textArea name="value" cols="40" rows="5" value="${projectParameterInstance?.value}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="quotation"><g:message code="projectParameter.quotation.label" default="Quotation" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: projectParameterInstance, field: 'quotation', 'errors')}">
                                    <g:select name="quotation.id" from="${com.valent.pricewell.Quotation.list()}" optionKey="id" value="${projectParameterInstance?.quotation?.id}"  />
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
