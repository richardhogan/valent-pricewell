<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
  <title><g:message code="nimble.view.auth.openid.redirection" /></title>
</head>

<body onload="document.forms['openid-form-redirection'].submit();">

<form name="openid-form-redirection" action="${destination}" method="post" accept-charset="utf-8">
  <g:each in="${openidreqparams}">
    <input type="hidden" name="${it.key}" value="${it.value}"/>
  </g:each>

  <button type="submit"><g:message code="nimble.link.continue" /></button>
  
</form>

</body>

</html>
