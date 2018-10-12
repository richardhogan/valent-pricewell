<html>
<ul class="navigation" id="mainmenu">
	<nav:eachItem group="navigation" var="item">
		<li class="${(session.forwardURI?.contains(item.controller) && session.forwardURI?.contains(item.action))?'navigation_active':''}">
			<g:link controller="${item.controller}" action="${item.action}"
     						class="${item.class}">${item.title}</g:link>
		</li>

	</nav:eachItem>
</ul>
</html>