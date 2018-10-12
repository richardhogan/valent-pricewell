<g:setProvider library="prototype"/>

<div id="mainReviewBoardTab">
	<g:render template="showFromWizard"	
		model="['serviceProfileInstance': serviceProfileInstance, 'reviewRequestInstance': reviewRequestInstance, 'submitterLoggedIn': submitterLoggedIn, 'commentAllowed': commentAllowed, 'statusChangeAllowed': statusChangeAllowed]" />
</div>