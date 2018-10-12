
<div class="body">
	<div class="dialog">
    	<table>
          	<tbody>
           		<tr class="prop">
                	<td valign="top" class="name">
                    	<label for="quotedPrice">Total Quoted Price</label>
	                </td>
                    <td valign="top">
                    	<g:textField name="totalQuotedPrice" value="${quotationInstance?.finalPrice}" class="required" readOnly="true"/>
                    </td>		                                
				</tr>
          	</tbody>
     	</table>
	    
		<table>
	    	<tbody>
	        	<g:each in="${quotationInstance?.milestones?.sort{it?.id}}" status="i" var="milestoneInstance">
	                        		
					<tr class="prop">
						<td valign="top" class="name">
							<label for="milestone"><g:message code="milestoneInstance.milestone.label" default="Milestone" /></label><em> </em>
						</td>
						<td valign="top" >
							
							${milestoneInstance?.milestone }
														 
						</td>
						
						<td>&nbsp;</td>
						
						<td valign="top" class="name">
							<label for="amount"><g:message code="milestoneInstance.amount.label" default="Amount" /></label><em> </em>
						</td>
						<td valign="top" class="value ${hasErrors(bean: milestoneInstance, field: 'amount', 'errors')}">
							${quotatioInstance?.geo?.currency }
							${milestoneInstance?.amount }
							
							&nbsp;&nbsp;(${milestoneInstance?.percentage }%)
						</td>
										   
					</tr>
        		</g:each>
       		</tbody>
    	</table>
	</div>
</div>