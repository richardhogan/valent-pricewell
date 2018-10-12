<%@ page import="com.valent.pricewell.Quotation" %>
<%
	def baseurl = request.siteUrl
%>
<%
	def quoteStagingList = Quotation.quoteStagingList(); 
%>

<script>
jQuery(document).ready(function()
		{
			jQuery('.stagesLink').click(function(){
				var stageId = this.id.replace("qstage-", "");
				jQuery.post( '${baseurl}/quotation/saveStatusChange', {id: <%=quotationInstance.id%>, stageId: stageId },
					      function( data ) {
					          //jQuery('#price').val(data);
					      });  
			});
		}
</script>

<table>
	 <g:each in="${quoteStagingList}" status="i" var="stage">
	 <%
		int onStarsCount = stage.sequenceOrder;
		int offStartsCount = 5 - onStarsCount
	%>
		<tr> 
			<td> 	
				<g:if test="${stage.sequenceOrder < 0}">
					<img src="${resource(dir:'images',file:'star-delete.png')}" border="0" />
				</g:if>
				<g:else>
					<g:while test="${onStarsCount > 0}">
	    				<%onStarsCount--%>
	    				<img src="${resource(dir:'images',file:'star-on.png')}" border="0" />
					</g:while>
		
		  			<g:while test="${onStarsCount > 0}">
	    				<%offStarsCount--%>
	    				<img src="${resource(dir:'images',file:'star-off.png')}" border="0" />
					</g:while>
				</g:else>
	 		</td>
			<td> <g:link class="stagesLink" title="${stage.displayName}" id="qstage-${stage.id}"> ${stage.displayName} </g:link> </td>
		
		</tr>
	</g:each>
</table>