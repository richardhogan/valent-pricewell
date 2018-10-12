<g:if test="${configType == 'serviceStatus' }">
	<g:select name="statusName" from="${serviceStatus}" value="" class="required"/>
</g:if>

<g:elseif test="${configType == 'serviceType' }">
	<g:select name="serviceType" from="${serviceType}" value="" class="required"/>
</g:elseif>
