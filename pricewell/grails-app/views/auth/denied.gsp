<%--
  Access-denied page.
  Shown when a logged-in user attempts to access a URL for which they lack
  the required role. Configured via:
    grails.plugins.springsecurity.adh.errorPage = '/auth/denied'
--%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>Access Denied — Pricewell</title>
</head>
<body>
<div class="body">
    <h1>Access Denied</h1>
    <p>You do not have permission to access that page.</p>
    <p><g:link uri="/">Return to home</g:link></p>
</div>
</body>
</html>
