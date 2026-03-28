<g:if test="${roleInstance.code=='SALES MANAGER'}"> 
	<g:select name="territoriesList" from="${territoriesList?.sort {it.name}}" value="" optionKey="id" multiple="multiple" noSelection="['': 'Select Multiple']"/>
</g:if>

<g:if test="${roleInstance.code=='SALES PERSON'}">
	<g:select name="primaryTerritory" from="${territoriesList?.sort {it.name}}" value="" optionKey="id" noSelection="['': 'Select Any One']" class="required"/>	
</g:if>