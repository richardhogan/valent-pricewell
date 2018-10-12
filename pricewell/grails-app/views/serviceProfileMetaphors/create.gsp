

<%@ page import="com.valent.pricewell.ServiceProfileMetaphors" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'serviceProfileMetaphors.label', default: 'ServiceProfileMetaphors')}" />
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
            <g:hasErrors bean="${serviceProfileMetaphorsInstance}">
            <div class="errors">
                <g:renderErrors bean="${serviceProfileMetaphorsInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="definitionString"><g:message code="serviceProfileMetaphors.definitionString.label" default="Definition String" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileMetaphorsInstance, field: 'definitionString', 'errors')}">
                                    <g:select name="definitionString.id" from="${com.valent.pricewell.Setting.list()}" optionKey="id" value="${serviceProfileMetaphorsInstance?.definitionString?.id}" noSelection="['null': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="serviceProfile"><g:message code="serviceProfileMetaphors.serviceProfile.label" default="Service Profile" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileMetaphorsInstance, field: 'serviceProfile', 'errors')}">
                                    <g:select name="serviceProfile.id" from="${com.valent.pricewell.ServiceProfile.list()}" optionKey="id" value="${serviceProfileMetaphorsInstance?.serviceProfile?.id}" noSelection="['null': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="sequenceOrder"><g:message code="serviceProfileMetaphors.sequenceOrder.label" default="Sequence Order" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileMetaphorsInstance, field: 'sequenceOrder', 'errors')}">
                                    <g:textField name="sequenceOrder" value="${fieldValue(bean: serviceProfileMetaphorsInstance, field: 'sequenceOrder')}" />
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
