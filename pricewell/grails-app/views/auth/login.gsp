<%--
  Login page — replaces the Nimble plugin's login view.

  Spring Security Core intercepts POST /j_spring_security_check and handles
  credential verification. On success it redirects to the originally requested URL
  (or the configured defaultTargetUrl). On failure it redirects back here with
  the query parameter ?login_error=1, which the controller passes as loginError=true.
--%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="app"/>
    <title>Sign In — Pricewell</title>
</head>
<body>
<div class="body" id="loginPage">

    <h1>Sign In</h1>

    <g:if test="${loginError}">
        <div class="errors">
            <p>Invalid username or password. Please try again.</p>
        </div>
    </g:if>

    <%--
      Spring Security Core requires the form to POST to j_spring_security_check.
      The field names j_username and j_password are fixed by the Spring Security filter.
    --%>
    <form action="${request.contextPath}/j_spring_security_check" method="POST" id="loginForm">
        <input type="hidden" name="${_csrf?.parameterName}" value="${_csrf?.token}"/>

        <div class="dialog">
            <table>
                <tbody>
                    <tr>
                        <td class="name"><label for="j_username">Username</label></td>
                        <td class="value">
                            <input type="text"
                                   id="j_username"
                                   name="j_username"
                                   value=""
                                   autocomplete="off"
                                   autofocus="autofocus"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="name"><label for="j_password">Password</label></td>
                        <td class="value">
                            <input type="password"
                                   id="j_password"
                                   name="j_password"
                                   autocomplete="off"/>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <%-- _spring_security_remember_me enables persistent login cookies --%>
                            <input type="checkbox" id="remember_me" name="_spring_security_remember_me"/>
                            <label for="remember_me">Remember me</label>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="buttons">
            <span class="button">
                <input type="submit" value="Sign In" class="save"/>
            </span>
        </div>
    </form>

</div>
</body>
</html>
