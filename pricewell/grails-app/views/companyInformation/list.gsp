
<%@ page import="com.valent.pricewell.CompanyInformation" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'companyInformation.label', default: 'CompanyInformation')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                            <g:sortableColumn property="id" title="${message(code: 'companyInformation.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="name" title="${message(code: 'companyInformation.name.label', default: 'Name')}" />
                        
                            <g:sortableColumn property="website" title="${message(code: 'companyInformation.website.label', default: 'Website')}" />
                        
                            <g:sortableColumn property="SMTPserver" title="${message(code: 'companyInformation.SMTPserver.label', default: 'SMTP server')}" />
                        
                            <g:sortableColumn property="fromEmail" title="${message(code: 'companyInformation.fromEmail.label', default: 'From Email')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${companyInformationInstanceList}" status="i" var="companyInformationInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${companyInformationInstance.id}">${fieldValue(bean: companyInformationInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: companyInformationInstance, field: "name")}</td>
                        
                            <td>${fieldValue(bean: companyInformationInstance, field: "website")}</td>
                        
                            <td>${fieldValue(bean: companyInformationInstance, field: "SMTPserver")}</td>
                        
                            <td>${fieldValue(bean: companyInformationInstance, field: "fromEmail")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${companyInformationInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
