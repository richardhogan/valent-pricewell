<%@ page import="com.valent.pricewell.User" %>
<html>
<head>
  <meta name="layout" content="main"/>
  <title>User Administration</title>
</head>

<body>

  <h2>Current Users</h2>

  <table class="userlist">
    <thead>
    <tr>
      <th>Username</th>
      <th>Full Name</th>
      <th>State</th>
      <th>Assigned Role/s</th>
      <th>&nbsp;</th>
    </tr>
    </thead>
    <tbody>
    <g:each in="${users}" status="i" var="user">
      <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

        <td>${user.username?.encodeAsHTML()}</td>

        <g:if test="${user.profile?.fullName}">
          <td>${user.profile?.fullName?.encodeAsHTML()}</td>
        </g:if>
        <g:else>
          <td>&nbsp;</td>
        </g:else>

        <td>
          <g:if test="${user.enabled}">
            Enabled
          </g:if>
          <g:else>
            Disabled
          </g:else>
        </td>
        <td>
          <g:each in="${userRolesMap[user.id]}" status="j" var="role">
            ${j+1}. ${role.description?.encodeAsHTML()}
          </g:each>
        </td>
        <td>
          <g:link action="show" id="${user.id}">View</g:link>
        </td>
      </tr>
    </g:each>
    </tbody>
  </table>

</body>
</html>
