<%@ page import="com.valent.pricewell.User" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <title>User List</title>
    </head>
    <body>
        <div class="body">
            <h1>Users</h1>
            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table cellpadding="0" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Username</th>
                            <th>Full Name</th>
                            <th>Email</th>
                            <th>Enabled</th>
                        </tr>
                    </thead>
                    <tbody>
                        <g:each in="${userInstanceList}" status="i" var="userInstance">
                            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                                <td>${userInstance.username?.encodeAsHTML()}</td>
                                <td>${userInstance.profile?.fullName?.encodeAsHTML()}</td>
                                <td>${userInstance.profile?.email?.encodeAsHTML()}</td>
                                <td>${userInstance.enabled}</td>
                            </tr>
                        </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${userInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
