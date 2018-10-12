<%@ page import="com.valent.pricewell.Opportunity" %>
<%
	def baseurl = request.siteUrl
%>
<script>

		 jQuery(document).ready(function()
		 {
		
				jQuery('a[tooltip]').each(function()
				{
				      jQuery(this).qtip({
				         content: jQuery(this).attr('tooltip'), // Use the tooltip attribute of the element for the content
				         style: 'dark',
				         position: {
				              corner: {
				                  target: 'bottomLeft' // ...and opposite corner
				              }
				         }
				      });
				
				});
		 });
</script>
			
			<g:if test="${opportunityInstance?.id != null}">
				<g:each in="${stagingInstanceList}" status="i" var="stage">
					<g:if test="${opportunityInstance?.stagingStatus?.id == stage.id}">
						<g:set var="csIndex" value="${i}"/>
					</g:if>
				</g:each>
			</g:if>
			<g:else>
				<g:set var="csIndex" value="${0}"/>
			</g:else>
			<div class="stage">
	        	<ul>
	        		
	        		<g:if test="${opportunityInstance?.stagingStatus?.name == 'closedWon' || opportunityInstance?.stagingStatus?.name == 'closedLost'}">
	        			<g:if test="${opportunityInstance?.stagingStatus?.name == 'closedWon'}">
	        				<li> <a class="current" href="#" title="${opportunityInstance.stagingStatus.description}"> ${opportunityInstance.stagingStatus.displayName} </a> </li>
	        			</g:if>
	        			<g:else>
	        				<li> <a class="endstage" href="#" title="${opportunityInstance.stagingStatus.description}"> ${opportunityInstance.stagingStatus.displayName} </a> </li>
	        			</g:else>
	        		</g:if>
	        		
	        		<g:else>
	        		
	        			<div style="float: left; ">
				        	<g:each in="${stagingInstanceList}" status="i" var="stage">
				        		
				        		<g:if test="${stage?.name != 'closedLost'}">
					        		
					        		<g:if test="${csIndex > i}">
					        			<li> <a href="#" class="done">  ${i+1}. ${stage.displayName} </a> </li>
					        		</g:if>
					        		
					        		<g:elseif test="${csIndex == i}">
					        			<li> <a class="current" href="#" title="${stage.description}">  ${i+1}. ${stage.displayName} </a> </li>
					        		</g:elseif>
					        		
					        		<g:else>
					        			<li> <a href="#" class="future" title="${stage.description}"> ${i+1}. ${stage.displayName} </a> </li>
					        		</g:else>
				        		
				        		</g:if>
				        		
				        	</g:each>
			        	</div>
			        	
				       	<div style="float: right;  margin-left: 10px;">
				       		<li> <a class="endstage" href="${baseurl}/opportunity/changeStage?id=${opportunityInstance.id}&source=closedLost" title="Closed Lost Stage."> Closed Lost </a> </li>
				       	</div>
				       	
			        </g:else>
			       	
		        </ul>
		        <br style="clear: left">
	    	</div>