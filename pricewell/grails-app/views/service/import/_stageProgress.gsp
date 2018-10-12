<%@ page import="com.valent.pricewell.ServiceProfile" %>
<script>

		 jQuery(document).ready(function()
		 {
		 });
</script>
	
			<g:if test="${serviceProfileInstance?.id != null}">
				<g:each in="${importServiceStages}" status="i" var="stage">
					<g:if test="${serviceProfileInstance?.importServiceStage == stage[0]}">
						<g:set var="csIndex" value="${i}"/>
					</g:if>
				</g:each>
			</g:if>
			<g:else>
				<g:set var="csIndex" value="${0}"/>
			</g:else>
			<div class="stage">
	        	<ul>
	        		<g:if test="${serviceProfileInstance.type == ServiceProfile.ServiceProfileType.PUBLISHED}">
	        			<li> <a class="current" href="#" > Published </a> </li>
	        		</g:if>
	        		<g:else>
			        	<g:each in="${importServiceStages}" status="i" var="stage">
			        		<g:if test="${csIndex > i}">
			        			<li> <a href="#" class="done">  ${i+1}. ${stage[1]} </a> </li>
			        		</g:if>
			        		<g:elseif test="${csIndex == i}">
			        			<li> <a class="current" href="#" title="${stage[1]}">  ${i+1}. ${stage[1]} </a> </li>
			        		</g:elseif>
			        		<g:else>
			        			<li> <a href="#" class="future" title="${stage[1]}"> ${i+1}. ${stage[1]} </a> </li>
			        		</g:else>
			        		
			        		
			        		
			        	</g:each>
			        </g:else>
		        </ul>
		        <br style="clear: left">
	    	</div>