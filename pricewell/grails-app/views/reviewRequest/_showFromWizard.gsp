

	<h1>
		Request of ${reviewRequestInstance?.serviceProfile}
	</h1>
	
	<div class="dialog">
		<g:render template="show-info"
			model="['reviewRequestInstance': reviewRequestInstance]" />
	</div>
	<div class="buttons">
		<g:if test="${submitterLoggedIn}">
			<g:form action="edit" controller="reviewRequest">
				<g:hiddenField name="id" value="${reviewRequestInstance?.id}" />
				<g:hiddenField name="sourceFrom" value="serviceProfile" />
				<span class="button"><g:submitToRemote class="edit" url="[action: 'edit', controller: 'reviewRequest']"
						title="Edit Review Request" update="mainReviewBoardTab"
						value="${message(code: 'default.button.edit.label', default: 'Edit')}" />
				</span>
			
			</g:form>
			<br>
		</g:if>
	</div>
	
	<div id="mainComment">
		<table>
			<g:hiddenField name="reviewRequestId"
				value="${reviewRequestInstance?.id}" />
	
			<tr>
				<td><g:render template="/reviewComment/listComments" model="[
						'reviewRequestInstance' : reviewRequestInstance, 'commentAllowed':
						commentAllowed, 'statusChangeAllowed':
						statusChangeAllowed, 'source':source, 'serviceProfileInstance': serviceProfileInstance]"></g:render></td>
			</tr>
	
		</table>
	</div>

