<g:if test="${logoImageInstance?.id != null}">
	<img src="<g:createLink controller='logoImage' action='renderImage' id='${logoImageInstance?.id}'/>" hight="80" width="100" />
</g:if>