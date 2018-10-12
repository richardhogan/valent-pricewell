<!-- <table>
			                    	
			                        	<tr>
							    			<td>
							    				<label>SOW Label</label><em>*</em>
							    			</td>
							    			<td>
							    				<g:textField name="sowLabel" value="${geoInstance?.sowLabel }" class="required" size='75'/>
							    			</td>
							    		</tr>
			                        	<tr> 
							    			<td> 
							    				<label> SOW Template </label>
							    			</td>
							    			
							    			<td> 
							    				<g:textArea name="sowTemplate" value="${geoInstance?.sowTemplate}" rows="5" cols="80" style="width: 90%">
							    					<p> Use following tags to put place holder for dynamically generated contents. </p>
									    			<ul>
									    				<li> [@@services@@] for print services details </li>
									    				<li> [@@terms@@] for terms and conditions for given GEO </li>
									    				<li> [@@billing_terms@@] for billing terms for given GEO </li>
									    				<li> [@@signature_block@@] </li>
									    			</ul>
							    				</g:textArea> 
						    				</td>
							    		</tr>
			                        
			                    	<tr>
			               				<td><label>SOW Template Tags</label></td>
			               				<td></td>
		               				</tr>
						    	
						    		<tr>
						    			<td>
						    				<label>[@@terms@@]</label>
					    				</td>
					    				<td>
					    					<g:textArea name="terms" value="${geoInstance?.terms}" rows="10" cols="80" style="width: 90%"/>
					    				</td>
						    		</tr>
						    		<tr>
						    			<td>
						    				<label>[@@billing_terms@@]</label>
					    				</td>
					    				<td>
					    					<g:textArea name="billing_terms" value="${geoInstance?.billing_terms}" rows="10" cols="80" style="width: 90%"/>
					    				</td>
						    		</tr>
						    		<tr>
						    			<td>
						    				<label>[@@signature_block@@]</label>
					    				</td>
					    				<td>
					    					<g:textArea name="signature_block" value="${geoInstance?.signature_block}" rows="5" cols="80" style="width: 90%"/>
					    				</td>
						    		</tr>
						    	</table>-->	 