<%@ page import="com.valent.pricewell.Lead" %>
<%
	def baseurl = request.siteUrl
%>
<script>

		 jQuery(document).ready(function(){

				jQuery.getScript("${baseurl}/js/qtip/jquery.qtip-1.0.0-rc3.js", function() {	
		
					jQuery('a[tooltip]').each(function()
							   {
							      jQuery(this).qtip({
							         content: jQuery(this).attr('tooltip'), // Use the tooltip attribute of the element for the content
							         style: 'dark', // Give it a crea mstyle to make it stand out
							        	 
							               position: {
							                  corner: {
							                      // Use the corner...
							                     target: 'bottomLeft' // ...and opposite corner
							                  }
							               }
							      });
							   });
				});
		 });
</script>
			
			<g:if test="${leadInstance?.id != null}">
				<g:each in="${stagingInstanceList}" status="i" var="stage">
					<g:if test="${leadInstance?.stagingStatus?.id == stage.id}">
						<g:set var="csIndex" value="${i}"/>
					</g:if>
				</g:each>
			</g:if>
			<g:else>
				<g:set var="csIndex" value="${0}"/>
			</g:else>
			<div class="stage">
        	<ul>
        		<g:if test="${leadInstance?.stagingStatus?.name == 'converted' || leadInstance?.stagingStatus?.name == 'dead'}">
        			<g:if test="${leadInstance?.stagingStatus?.name == 'converted'}">
        				<li class="current"> <a class="current" href="#" title="${leadInstance.stagingStatus.description}"> ${leadInstance.stagingStatus.displayName} </a> </li>
        			</g:if>
        			<g:else>
        				<li> <a class="endstage" href="#" title="${leadInstance.stagingStatus.description}"> ${leadInstance.stagingStatus.displayName} </a> </li>
        			</g:else>
        		</g:if>
        		<g:else>
        		
        			<div style="float: left; ">
			        	
			        	<g:each in="${stagingInstanceList}" status="i" var="stage">
			        		
			        		<g:if test="${stage?.name != 'dead'}">
				        		
				        		<g:if test="${csIndex > i}">
				        			<li> <a href="#" class="done">  ${i+1}. ${stage.displayName} </a> </li>
				        		</g:if>
				        		
				        		<g:elseif test="${csIndex == i}">
				        			
				        			<li> <a class="current" href="#" title="${stage.description}">  ${i+1}. ${stage.displayName} </a> </li>
				        			
				        			<!--<g:if test="${leadInstance.stagingStatus.name != 'converttoopportunity'}">
				        				<li><a class="stageChange" href="${baseurl}/lead/changeStage?id=${leadInstance.id}&source=nextStage" tooltip="Go To Next Stage"><b>Next &gt;&gt;</b></a></li>
				        			</g:if>-->
				        	
				        		</g:elseif>
				        		
				        		<g:else>
				        			<li> <a href="#" class="future" title="${stage.description}"> ${i+1}. ${stage.displayName} </a> </li>
				        		</g:else>
			        		
			        		</g:if>
			        		
			        	</g:each>
		        	
		        	</div>
		        	
			       	<div style="float: right;  margin-left: 10px;">
			       		<li> 
			       			<g:if test="${updatePermission}">
			       				<a class="endstage" href="${baseurl}/lead/changeStage?id=${leadInstance.id}&source=dead" title="Lead is dead."> Dead </a> 
			       			</g:if>
			       			<g:else>
			       				<a class="endstage" href="#" title="Lead is dead.">  Dead </a>
			       			</g:else>
			       			
		       			</li>
			       	</div>
		        </g:else>
	        </ul>
	        <br style="clear: left">
    	</div>