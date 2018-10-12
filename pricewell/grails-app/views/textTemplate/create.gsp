

<%@ page import="com.valent.pricewell.TextTemplate" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'textTemplate.label', default: 'TextTemplate')}" />
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
            <g:hasErrors bean="${textTemplateInstance}">
            <div class="errors">
                <g:renderErrors bean="${textTemplateInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                        	<tr class="prop">
                                <td valign="top" class="name">
                                    <label for="name"><g:message code="textTemplate.name.label" default="Name" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: textTemplateInstance, field: 'name', 'errors')}">
                                    <g:textField name="name" value="${textTemplateInstance?.name}" />
                                </td>
                            </tr>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="type"><g:message code="textTemplate.type.label" default="Type" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: textTemplateInstance, field: 'type', 'errors')}">
                                    <g:select name="type" from="${com.valent.pricewell.TextTemplate$TemplateType?.values()}" keys="${com.valent.pricewell.TextTemplate$TemplateType?.values()*.name()}" value="${textTemplateInstance?.type?.name()}"  />
                                </td>
                            </tr>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="geo"><g:message code="textTemplate.geo.label" default="Geo" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: textTemplateInstance, field: 'geo', 'errors')}">
                                    <g:select name="geo.id" from="${com.valent.pricewell.Geo.list()}" optionKey="id" value="${textTemplateInstance?.geo?.id}" noSelection="['null': '']" />
                                </td>
                            </tr>
                        
                        
                            <tr class="prop">
                         	       <td valign="top" class="name">
                                    <label for="text"><g:message code="textTemplate.text.label" default="Template Text" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: textTemplateInstance, field: 'text', 'errors')}">
                                    <g:textArea name="text" value="${textTemplateInstance?.text}" />
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
