

<%@ page import="com.valent.pricewell.ServiceProfileSOWDef" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'serviceProfileSOWDef.label', default: 'ServiceProfileSOWDef')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
        
        <g:setProvider library="prototype"/>
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
            <g:hasErrors bean="${serviceProfileSOWDefInstance}">
            <div class="errors">
                <g:renderErrors bean="${serviceProfileSOWDefInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <g:hiddenField name="id" value="${serviceProfileSOWDefInstance?.id}" />
                <g:hiddenField name="version" value="${serviceProfileSOWDefInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="geo"><g:message code="serviceProfileSOWDef.geo.label" default="Geo" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileSOWDefInstance, field: 'geo', 'errors')}">
                                    <g:select name="geo.id" from="${com.valent.pricewell.Geo.list()}" optionKey="id" value="${serviceProfileSOWDefInstance?.geo?.id}" noSelection="['null': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="part"><g:message code="serviceProfileSOWDef.part.label" default="Part" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileSOWDefInstance, field: 'part', 'errors')}">
                                    <g:textField name="part" value="${serviceProfileSOWDefInstance?.part}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="definition"><g:message code="serviceProfileSOWDef.definition.label" default="Definition" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileSOWDefInstance, field: 'definition', 'errors')}">
                                    <g:textField name="definition" value="${serviceProfileSOWDefInstance?.definition}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="sp"><g:message code="serviceProfileSOWDef.sp.label" default="Sp" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileSOWDefInstance, field: 'sp', 'errors')}">
                                    <g:select name="sp.id" from="${com.valent.pricewell.ServiceProfile.list()}" optionKey="id" value="${serviceProfileSOWDefInstance?.sp?.id}" noSelection="['null': '']" />
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
