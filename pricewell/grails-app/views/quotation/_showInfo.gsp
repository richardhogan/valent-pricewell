<%
	def baseurl = request.siteUrl
%>
<script>
	jQuery(document).ready(function()
	{
		
			var select = jQuery( "#confidence" );
			var slider = jQuery( "#slider").slider({
				min: 0,
				max: 100,
				range: "min",
				value: select[ 0 ].selectedIndex + 1,
				slide: function( event, ui ) {
					select[ 0 ].selectedIndex = ui.value - 1;
				}
			});
			jQuery( "#confidence" ).change(function() {
				slider.slider( "value", this.selectedIndex + 1 );
			});
			jQuery('#submitConfidence').click(function(){
				jQuery.ajax({type:'POST',
					 url: "${baseurl}/quotation/saveConfidence",
					 data: {id: <%=quotationInstance.id%>, confidence: jQuery( "#confidence" ).val() } ,
					 success:function(data,textStatus){jQuery('#lblForecastValue').text(data); refreshList(); },
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});
				});
		
		
	});
</script>
<style>
	td.quotename { font-weight: bold; font-size: 90%}
</style>

		<table style="width: 'auto';" id="serviceQuotions">
             <tbody>
             
             	<tr class="prop"> 
             		<g:if test="${!quotationInstance?.isLight && quotationInstance?.serviceQuotations.size() > 0}">
	             		<td valign="top" class="quotename"> Quotation Status: </td>
	             		<td> <g:render template="/quotation/stageProgress" model="['quotationInstance': quotationInstance, 'type': 'quotation', 'readOnly': readOnly]"/> </td>
	             		<td> &nbsp;&nbsp;&nbsp; </td>
	             	</g:if>	
	             	<g:elseif test="${quotationInstance?.isLight}">
	             		<td valign="top" class="quotename"> Light Version </td>
	             		<td></td>
	             		<td> &nbsp;&nbsp;&nbsp; </td>
	             	</g:elseif>
             		<td valign="top" class="quotename"><g:message code="quotation.createdBy.label" default="Created By:" /></td>
                     
                    <td valign="top" class="value">${quotationInstance?.createdBy?.encodeAsHTML()}</td>
             	</tr>
             	
             	<g:if test="${quotationInstance?.status?.sequenceOrder >= 2 && quotationInstance?.serviceQuotations?.size() > 0}">
	             	<tr class="prop"> 
	             		<td valign="top" class="quotename"> Contract Status: </td>
	             		<td> <g:render template="/quotation/stageProgress" model="['quotationInstance': quotationInstance, 'type': 'contract', 'readOnly': readOnly]"/> </td>
	             		<td> &nbsp;&nbsp;&nbsp; </td>
	             		<td valign="top" class="quotename"><g:message code="quotation.createdDate.label" default="Created Date:" /></td>
	                     
	                    <td valign="top" class="value"><g:formatDate format="MMMMM d, yyyy" date="${quotationInstance?.createdDate}" /></td>
	             	</tr>
             	</g:if>
             	
             	<tr class="prop">
             		<td valign="top" class="name"> Confidence %: </td>
					
	             		<td>
	             			<g:if test="${!readOnly}">
		             			<div id="makeChangesInConfidence">
		             				<table style="margin:0;padding:0;"> 
		             					<tr> 
		             						<td style="vertical-align:middle"> 
		             							<g:select name="confidence" from="${0..100}" value="${quotationInstance.confidencePercentage.toInteger()}" style=""/>
											</td>
											<td> &nbsp;&nbsp;&nbsp; </td>
		             				 		<td style="width: 10em; vertical-align:middle">
												<div id="slider"> </div> 
											</td>
											<td> &nbsp;&nbsp;&nbsp; </td>
											<g:if test="${quotationInstance?.status?.name != 'rejected' && quotationInstance?.contractStatus?.name != 'rejected'}">
												<td style="vertical-align:middle"> 
													
													<input type="button" value="Submit" title="Submit" id="submitConfidence"/>
												</td>
											</g:if>
										</tr>
									</table>
		             			</div>
		             		
		             		
		             			<div id="makeReadOnlyConfidence">${quotationInstance.confidencePercentage.toInteger()}%</div>
	             		         <script>
									if('${quotationInstance?.contractStatus?.name}' != "Accepted" && '${quotationInstance?.contractStatus?.name}' != "rejected")
									{
										jQuery("#makeChangesInConfidence").show();
										jQuery("#makeReadOnlyConfidence").hide();
									}
									else
									{
										jQuery("#makeReadOnlyConfidence").show();
										jQuery("#makeChangesInConfidence").hide();
									}
	             		         </script>
             		         </g:if>
             		         
             		         <g:else>
             		         	<div id="makeChangesInConfidence">
		             				<table style="margin:0;padding:0;"> 
		             					<tr> 
		             						<td style="vertical-align:middle"> 
		             							<g:select name="confidence" from="${0..100}" value="${quotationInstance.confidencePercentage.toInteger()}" disabled="true"/>
											</td>
										</tr>
									</table>
		             			</div>
             		         </g:else>								
		 				</td>
		 			
             		<td> &nbsp;&nbsp;&nbsp; </td>
             		<td valign="top" class="quotename"><g:message code="quotation.modifiedDate.label" default="Modified Date:" /></td>
                     
                     <td valign="top" class="value"><g:formatDate format="MMMMM d, yyyy" date="${quotationInstance?.modifiedDate}" /></td>
             	</tr>
             
             </tbody>
 </table>