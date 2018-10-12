

			
			<g:if test="${currentStepSequenceOrder != null}">
				<g:each in="${stagingInstanceList}" status="i" var="stage">
					<g:if test="${stage.sequenceOrder == currentStepSequenceOrder}">
						<g:set var="csIndex" value="${i}"/>
					</g:if>
				</g:each>
			</g:if>
			<g:else>
				<g:set var="csIndex" value="${0}"/>
			</g:else>
			<div class="stage">
        		<ul>
        		
        			<div style="float: left; ">
			        	
			        	<g:each in="${stagingInstanceList}" status="i" var="stage">
			        		
			        		<g:if test="${csIndex > i}">
			        			<li> <a href="#" class="done">  ${i+1}. ${stage.displayName} </a> </li>
			        		</g:if>
			        		
			        		<g:elseif test="${csIndex == i}">
			        			
			        			<li> <a class="current" href="#" title="${stage.description}">  ${i+1}. ${stage.displayName} </a> </li>
			        			
			        		</g:elseif>
			        		
			        		<g:else>
			        			<li> <a href="#" class="future" title="${stage.description}"> ${i+1}. ${stage.displayName} </a> </li>
			        		</g:else>
			        		
			        	</g:each>
		        	
		        	</div>
		        
	        	</ul>
	        <br style="clear: left">
    	</div>