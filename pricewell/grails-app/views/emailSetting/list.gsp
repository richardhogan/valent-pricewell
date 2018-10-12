
<%@ page import="com.valent.pricewell.EmailSetting" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'emailSetting.label', default: 'EmailSetting')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                            <g:sortableColumn property="id" title="${message(code: 'emailSetting.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="emailProps" title="${message(code: 'emailSetting.emailProps.label', default: 'Email Props')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${emailSettingInstanceList}" status="i" var="emailSettingInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${emailSettingInstance.id}">${fieldValue(bean: emailSettingInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: emailSettingInstance, field: "emailProps")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${emailSettingInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
