<%@ page import="grails.plugins.nimble.core.UserBase" %>
<head>
  <meta name="layout" content="${grailsApplication.config.nimble.layout.administration}"/>
  <title><g:message code="nimble.view.user.list.title" /></title>
</head>

<body>

  <h2>Current Users</h2>

  <table class="userlist">
    <thead>
    <tr>
      <g:sortableColumn property="username" titleKey="nimble.label.username" class="first icon icon_arrow_refresh"/>
      <th><g:message code="nimble.label.fullname" /></th>
      <g:sortableColumn property="enabled" titleKey="nimble.label.state" class="icon icon_arrow_refresh"/>
      <th>Assigned Role/s</th>
      <th class="last">&nbsp;</th>
    </tr>
    </thead>
    <tbody>
	
	<!--h1> Hello this is my change </h1-->
	
	<!--h2> If u want this then Go out side </h2-->
    <g:each in="${users}" status="i" var="user">
      <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

        <g:if test="${user.username.length() > 50}">
        	<td>${user.username?.substring(0,50).encodeAsHTML()}...</td>
		</g:if>
		<g:else>
			<td>${user.username?.encodeAsHTML()}</td>
		</g:else>

        <g:if test="${user.profile?.fullName}">
          <td valign="top" class="value">${user.profile?.fullName?.encodeAsHTML()}</td>
        </g:if>
        <g:else>
          <td>&nbsp;</td>
        </g:else>

        <td>
          <g:if test="${user.enabled}">
            <span class="icon icon_tick">&nbsp;</span><g:message code="nimble.label.enabled" />
          </g:if>
          <g:else>
            <span class="icon icon_cross">&nbsp;</span><g:message code="nimble.label.disabled" />
          </g:else>
        </td>
        <td>
        	<g:each in="${user.roles}" status="j" var="role">
        		${j+1}. ${role.name?.encodeAsHTML()} 
        	</g:each>
		</td>
        <td class="actionButtons">
          <span class="actionButton">
            <g:link action="show" id="${user.id}" class="button icon icon_user_go"><g:message code="nimble.link.view" /></g:link>
          </span>
        </td>
      </tr>
    </g:each>
    </tbody>
  </table>
<!--
  <div class="paginateButtons">
   <center> <h3><b><g:paginate total="${UserBase.count()}" /></b></h3> <center>
  </div>
-->
</body>
