<%@ page import="com.valent.pricewell.User" %>
<html>
<head>
  <meta name="layout" content="main"/>
  <title>User: ${user.username?.encodeAsHTML()}</title>
</head>

<body>

  <h2>User: ${user.username?.encodeAsHTML()}</h2>

  <div class="details">
    <h3>Account Information</h3>
    <table class="datatable">
      <tbody>
      <tr>
        <th>Username</th>
        <td>${user.username?.encodeAsHTML()}</td>
      </tr>
      <tr>
        <th>Full Name</th>
        <td>${user.profile?.fullName?.encodeAsHTML()}</td>
      </tr>
      <tr>
        <th>Email</th>
        <td>${user.profile?.email?.encodeAsHTML()}</td>
      </tr>
      <tr>
        <th>Created</th>
        <td><g:formatDate format="MMMMM d, yyyy" date="${user.dateCreated}"/></td>
      </tr>
      <tr>
        <th>State</th>
        <td>
          <g:if test="${user.enabled}">Enabled</g:if>
          <g:else>Disabled</g:else>
        </td>
      </tr>
      </tbody>
    </table>
  </div>

  <div class="details">
    <h3>Assigned Roles</h3>
    <table class="datatable">
      <tbody>
      <g:each in="${roles}" var="role">
        <tr>
          <td>${role.description?.encodeAsHTML()}</td>
        </tr>
      </g:each>
      </tbody>
    </table>
  </div>

  <div class="buttons">
    <g:link action="list">Back to Users</g:link>
    <g:link action="changepassword" id="${user.id}">Change Password</g:link>
  </div>

</body>
</html>
