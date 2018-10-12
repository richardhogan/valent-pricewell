

		<g:if test="${sPresidents?.size() > 0}">
			<option value="" class="disableClass" disabled>SALES PRESIDENTS</option>
			
			<g:each in="${sPresidents?.sort {it.profile.fullName}}" status="i" var="sPresident">
				<g:if test="${selectId!='' && selectId == sPresident.id }">
					<option value="${sPresident?.id }" class="realOptions" selected>${sPresident?.profile?.fullName }</option>
				</g:if>
				<g:else>
					<option value="${sPresident?.id }" class="realOptions">${sPresident?.profile?.fullName }</option>
				</g:else>
				
			</g:each>
		</g:if>
		
		<g:if test="${gManagers?.size() > 0}">
			<option value="" class="disableClass" disabled>GENERAL MANAGERS</option>
			
			<g:each in="${gManagers?.sort {it.profile.fullName}}" status="i" var="gManager">
				<g:if test="${selectId!='' && selectId == gManager.id }">
					<option value="${gManager?.id }" class="realOptions" selected>${gManager?.profile?.fullName }</option>
				</g:if>
				<g:else>
					<option value="${gManager?.id }" class="realOptions">${gManager?.profile?.fullName }</option>
				</g:else>
			</g:each>
		</g:if>
		
		<g:if test="${sManagers?.size() > 0}">
			<option value="" class="disableClass" disabled>SALES MANAGERS</option>
			
			<g:each in="${sManagers?.sort {it.profile.fullName}}" status="i" var="sManager">
				<g:if test="${selectId!='' && selectId == sManager.id }">
					<option value="${sManager?.id }" class="realOptions" selected>${sManager?.profile?.fullName }</option>
				</g:if>
				<g:else>
					<option value="${sManager?.id }" class="realOptions">${sManager?.profile?.fullName }</option>
				</g:else>
			</g:each>
		</g:if>
		
		<g:if test="${sPersons?.size() > 0}">
			<option value="" class="disableClass" disabled>SALES PERSONS</option>
			
			<g:each in="${sPersons?.sort {it.profile.fullName}}" status="i" var="sPerson">
				<g:if test="${selectId!='' && selectId == sPerson.id }">
					<option value="${sPerson?.id }" class="realOptions" selected>${sPerson?.profile?.fullName }</option>
				</g:if>
				<g:else>
					<option value="${sPerson?.id }" class="realOptions">${sPerson?.profile?.fullName }</option>
				</g:else>
			</g:each>
		</g:if>
	  
	