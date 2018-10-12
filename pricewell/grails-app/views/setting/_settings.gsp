<g:form method="post" >
	    	<table>
	    		<tr>
	    			<td>
	    				<label>SOW Label</label>
	    			</td>
	    			<td>
	    				<g:textField name="sowLabel" value="${map['sowLabel']}" size='75' />
	    			</td>
	    		</tr>
	    		<tr> 
	    			<td> 
	    				<label> SOW Template </label>
	    			</td>
	    			
	    			<td> 
	    				<g:textArea name="sowTemplate" value="${map['sowTemplate']}" rows="5" cols="80" style="width: 90%"/>
	    				
    				</td>
	    		</tr>
	    	<!--</table>-->
	    		<tr>
	    			<td> <label>SOW Template Tags</label> </td>
	    			<td></td>
    			</tr>
	    	<!--<table>-->
	    		<tr>
	    			<td>
	    				<label>[@@services@@]</label>
    				</td>
    				<td>
    					<g:textArea name="services" value="${map['services']}" rows="2" cols="80" style="width: 90%"/>
    						
    					
    				</td>
	    		</tr>
	    		<tr>
	    			<td>
	    				<label>[@@terms@@]</label>
    				</td>
    				<td>
    					<g:textArea name="terms" value="${map['terms']}" rows="10" cols="80" style="width: 90%"/>
    				</td>
	    		</tr>
	    		<tr>
	    			<td>
	    				<label>[@@billing_terms@@]</label>
    				</td>
    				<td>
    					<g:textArea name="billing_terms" value="${map['billing_terms']}" rows="10" cols="80" style="width: 90%"/>
    				</td>
	    		</tr>
	    		<tr>
	    			<td>
	    				<label>[@@signature_block@@]</label>
    				</td>
    				<td>
    					<g:textArea name="signature_block" value="${map['signature_block']}" rows="5" cols="80" style="width: 90%"/>
    				</td>
	    		</tr>
	    		
	    	</table>
	    	<div><b>Note : </b>Expense Amount and Description will be added directly from SOW Properties.</div>
	    	 <div class="buttons">
	    		<span class="button"><g:actionSubmit class="save" title="Save Settings" action="saveSettings" value="Save Settings" /></span>
	    	</div>
	    </g:form>