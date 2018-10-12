<%
	def baseurl = request.siteUrl
%> <script>

     jQuery(document).ready(function()
    		 	{
		    	 jQuery( "#dvQutationServices" ).dialog(
		 				{
		 					height: 340,
		 					width: 650,
		 					modal: true,
		 					autoOpen: false,
		 					
		 				});
			
   		 			jQuery('.sqEdit').click(function(){
    		 			
   		 				jQuery( "#dvQutationServices" ).dialog( "option", "title", 'Edit' );
   		 				jQuery( "#dvQutationServices" ).dialog( "option", "zIndex", index+1000 );
						index = index+1000;
   						jQuery( "#dvQutationServices" ).dialog( "open" );

   						
   						var pid = this.id;
   						pid = pid.replace("sqid-","");
   						
   						
   		 				jQuery.ajax({type:'POST',data: {sqid: pid},
  							 url:'${baseurl}/serviceQuotation/edit',
  							 success:function(data,textStatus){jQuery('#dvQutationServices').html(data);},
  							 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false
  							 
    		 			});

   		 			
   		 			jQuery('.sqDelete').click(function(){
   		 				var pid = this.id;
   						pid = pid.replace("sqid-","");;
   						
   		 				jQuery.ajax({type:'POST',data: {sqid: pid},
  							 url:'${baseurl}/serviceQuotation/delete',
  							 success:function(data,textStatus){jQuery('#dvQuotationMain').html(data);refreshForecastValue();},
  							 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false
    		 			}); 

    		 	});
     
     </script>   
        	<div id="dvQutationServices">
        		
        	</div>
            
          
			<table>		
				<thead>
					<tr>
						<th> Portfolio </th>
						
						
														
						<th><g:message code="serviceQuotation.service.label" default="Service" /></th>
					
						<g:sortableColumn property="totalUnits" title="${message(code: 'serviceQuotation.totalUnits.label', default: 'Units')}" />
																
						<g:sortableColumn property="price" title="${message(code: 'serviceQuotation.price.label', default: 'Price')}" />
						
						<g:if test="${canModifyServices}">
							<th> </th>
						</g:if>
													
					</tr>
				</thead>
				<tbody>
					
					<g:set var="previousPortfolioId" value=""/>
					
					<g:each in="${serviceQuotations.sort{it?.sequenceOrder}}" status="i" var="serviceQuotationInstance">
						
						<g:set var="portfolioInstance" value="${serviceQuotationInstance?.service?.portfolio}"/>
												
						<g:if test="${previousPortfolioId == '' || previousPortfolioId != portfolioInstance?.id}">
							<tr bgcolor="#b0c4de">
						 		<td colspan="7">
									<b> ${serviceQuotationInstance?.service?.portfolio?.portfolioName} </b>
								</td>
							</tr>
							
							<g:set var="previousPortfolioId" value="${portfolioInstance?.id}"/>
						</g:if>
												
						
						<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
							<td width="10%"> </td>
							
							<td><g:link controller="service" title="Show Service" action="show" params="[serviceProfileId: serviceQuotationInstance?.service?.id]">${fieldValue(bean: serviceQuotationInstance, field: "service")}</g:link></td>
						
							<td>${fieldValue(bean: serviceQuotationInstance, field: "totalUnits")}</td>
													
							<td>${fieldValue(bean: serviceQuotationInstance, field: "price")} ${fieldValue(bean: serviceQuotationInstance, field: "geo.currency")}</td>
							
							<g:if test="${canModifyServices}">
								<td> 
									<input id="sqid-${serviceQuotationInstance.id}" type="button" value="Edit" title="Edit" class="sqEdit button"/> 
									<input id="sqid-${serviceQuotationInstance.id}" type="button" value="Delete" title="Delete" class="sqDelete button"/>
								</td>
							</g:if>
							
						</tr>
							
						
					</g:each>
					
				</tbody>
				<tfoot>
					<tr>
						<td colspan="5">
							
						</td>
					</tr>
					<tr>
						<td colspan="5" align="right">
						<div style="float: right">
				       		<table id="summary" style="float: right;">
					        		<tbody>
					        			<tr> </tr>
					        			<tr class="prop">
					        				<td valign="top" id="totalPrice" class="name"> Subtotal Price: </td>
					                        <td valign="top" id="totalPriceValue" class="value">${quotationInstance?.geo?.currencySymbol}${fieldValue(bean: quotationInstance, field: "totalQuotedPrice")}</td>
					        			</tr>
					        			
					        			<tr class="prop">
					        				<td class="name"> Discount: </td>
					        				
					        				<td> ${quotationInstance?.geo?.currencySymbol}${fieldValue(bean: quotationInstance, field: "discountAmount")}
					        				 ${(!quotationInstance.flatDiscount ? '(' + quotationInstance.discountPercent + '%)': '')} </td>
					        			</tr>
					        			<tr class="prop">
					        				<td class="name"> Tax:   </td>
					        				
					        				<td> ${quotationInstance?.geo?.currencySymbol} ${fieldValue(bean: quotationInstance, field: "taxAmount")} 
					        				(${fieldValue(bean: quotationInstance, field: "taxPercent")}%) 
					        				</td>
					        			</tr>
					        			<tr class="prop">
					        				<td class="name"> Expenses:   </td>
					        				
					        				<td> ${quotationInstance?.geo?.currencySymbol} ${fieldValue(bean: quotationInstance, field: "expenseAmount")} </td>
					        			</tr>
					        			<tr class="prop">
					        				<td class="name"> Total Price:  </td>
					        				
					        				<td> ${quotationInstance?.geo?.currencySymbol} ${fieldValue(bean: quotationInstance, field: "finalPrice")}  </td>
					        				
					        			</tr>
					        		</tbody>
					        </table>
					       </div>
						</td>
					</tr>
				</tfoot>
			</table>