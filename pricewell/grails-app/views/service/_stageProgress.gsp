<%@ page import="com.valent.pricewell.ServiceProfile" %>
<script>

		 jQuery(document).ready(function()
		 {
				jQuery('a[tooltip]').each(function()
				{
				      jQuery(this).qtip(
				      {
				         content: jQuery(this).attr('tooltip'), 
				         style: 'dark', 
				         show: 'mouseover',
  						 hide: 'mouseout',
				         position: {
				             corner: {
				                  target: 'bottomLeft' // ...and opposite corner
				             }
				         }
				      });
				});
				
		 });
</script>
	
			<g:if test="${serviceProfileInstance?.id != null}">
				<g:each in="${stagingInstanceList}" status="i" var="stage">
					<g:if test="${serviceProfileInstance?.stagingStatus?.id == stage.id}">
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
	        			<li> <a class="current" href="#" > ${serviceProfileInstance.stagingStatus.displayName}</a> </li>
	        		</g:if>
	        		<g:elseif test="${serviceProfileInstance.type == ServiceProfile.ServiceProfileType.INACTIVE}">
	        			<li> <a class="endstage" href="#" > ${serviceProfileInstance.stagingStatus.displayName}<g:if test="${serviceProfileInstance.newProfile != null}"> - Converted To New Version</g:if></a> </li>
	        		</g:elseif>
	        		<g:else>
			        	<g:each in="${stagingInstanceList}" status="i" var="stage">
			        		<g:if test="${csIndex > i}">
			        			<li> <a href="#" class="done">  ${i+1}. ${stage.displayName} </a> </li>
			        		</g:if>
			        		<g:elseif test="${csIndex == i}">
			        			<li> <a class="current" href="#" tooltip="${stage.description}">  ${i+1}. ${stage.displayName} </a> </li>
			        		</g:elseif>
			        		<g:else>
			        			<li> <a href="#" class="future" tooltip="${stage.description}"> ${i+1}. ${stage.displayName} </a> </li>
			        		</g:else>
			        		
			        		
			        		
			        	</g:each>
			        </g:else>
		        </ul>
		        <br style="clear: left">
	    	</div>