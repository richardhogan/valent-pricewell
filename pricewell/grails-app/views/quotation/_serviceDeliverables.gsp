<g:if test="${deliverables?.size() > 0}">
<ul class="indented-2">
	<g:each in="${deliverables}" status="j" var="del">
		<li> ${del?.name}, ${del?.type}, ${del?.description} </li>
	</g:each>
</ul>
</g:if>
	           