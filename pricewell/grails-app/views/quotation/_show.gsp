
<%@ page import="com.valent.pricewell.Quotation" %>
<%@ page import="com.valent.pricewell.Service" %>
<%@ page import="com.valent.pricewell.ServiceQuotation" %>
<%@ page import="com.valent.pricewell.Pricelist" %>
<%@ page import="org.apache.shiro.SecurityUtils"%>
<%
	def baseurl = request.siteUrl
%>
    	        
		<style>
			
			.discount{color: #0000FF;}
			
			table.gridtable 
			{
				 font-size:11px;
				 border-width: 1px;
				 border-color: white;
				 border-collapse: collapse;
			}
			table.gridtable th 
			{
				 border-width: 1px;
				 padding: 8px;
				 border-style: solid;
				 border-color: white;
			}
			table.gridtable td 
			{
				 border-width: 1px;
				 padding: 8px;
				 border-style: solid;
				 border-color: white;
			}
		</style>
        
    
<script>

    function refreshForecastValue(){
    	
			jQuery.ajax({type:'POST',
				 url: "${baseurl}/quotation/getForcastValue",
				 data: {id: <%=quotationInstance.id%> } ,
				 success:function(data,textStatus){jQuery('#lblForecastValue').text(data); },
				 error:function(XMLHttpRequest,textStatus,errorThrown){}});
		
     }
     
     function refreshStageInfo(){
    	
			jQuery.ajax({type:'POST',
				 url: "${baseurl}/quotation/refreshStages",
				 data: {id: <%=quotationInstance.id%> } ,
				 success:function(data,textStatus){jQuery('#dvQuotationInfo').text(data); },
				 error:function(XMLHttpRequest,textStatus,errorThrown){}});
		
     }

	function refreshShowInfo(id){
	   jQuery.ajax({type:'POST',
			 url: "${baseurl}/quotation/showInfo",
			 data: {id: id } ,
			 success:function(data,textStatus){jQuery('#dvQuotationInfo').html(data);},// refreshList(); },
			 error:function(XMLHttpRequest,textStatus,errorThrown){}});
	}

	function refreshQuotation(id)
	{
		showLoadingBox();
		jQuery.ajax({type:'POST',
			 url: "${baseurl}/quotation/show",
			 data: {id: ${quotationInstance.id}, source: 'fromOpportunity' } ,
			 success:function(data,textStatus){jQuery('#dvQuote').html(data); hideLoadingBox();},
			 error:function(XMLHttpRequest,textStatus,errorThrown){hideLoadingBox();}});
	}
    
	jQuery(document).ready(function()
	{
	
		jQuery("':radio'").click( function() {
				jQuery('#editService').show();
				jQuery('#deleteService').show();
			}
		);
				
	
			jQuery( "#addService" ).click(function(){
					jQuery('#toggleAddQuote').click();
				});

			jQuery('#toggleAddQuote').button().click(function()
			{
				
				if(this.value == '>>')
				{
					jQuery('#dvAddQuote').toggle("slide");
					jQuery('#toggleAddQuote').attr("value",'<<');	
					
					jQuery.ajax({type:'POST',
					data: {id: <%=quotationInstance?.id%> }, 
					url:'${baseurl}/serviceQuotation/addServiceToQuote',
					success:function(data,textStatus){
						jQuery('#dvAddQuote').html("");
						jQuery('#dvAddQuote').html(data);},
					error:function(XMLHttpRequest,textStatus,errorThrown){}});
				}
				else{

					jQuery('#dvAddQuote').toggle("slide");
					jQuery('#toggleAddQuote').attr("value",'>>');
					
				}

				
			});			

			jQuery('#dvAddQuote').hide();			
			
			jQuery('#editService').click(function() {

				jQuery( "#dvQutationServices" ).dialog( "option", "title", 'Edit' );
				jQuery( "#dvQutationServices" ).dialog( "option", "zIndex", index+1000 );
				index = index+1000;
				jQuery( "#dvQutationServices" ).dialog( "open" );

				jQuery.ajax({type:'POST',data:jQuery(this).parents('form:first').serialize(),
							 url:'${baseurl}/serviceQuotation/edit',
							 success:function(data,textStatus){jQuery('#dvQutationServices').html(data);refreshForecastValue();},
							 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false
				}); 
			
			jQuery('#addDiscount').click(function() {

				jQuery( "#dvQutationServices" ).dialog( "option", "title", 'Discount' );
				jQuery( "#dvQutationServices" ).dialog( "option", "zIndex", index+1000 );
				index = index+1000;
				jQuery( "#dvQutationServices" ).dialog( "open" );

				jQuery.ajax({type:'POST',data: {quotationId: ${quotationInstance.id}},//jQuery(this).parents('form:first').serialize(),
							 url:'${baseurl}/quotation/discount',
							 success:function(data,textStatus){jQuery('#dvQutationServices').html(data);refreshForecastValue();},
							 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false
				}); 


			jQuery('#changeOrder').click(function() {

				jQuery( "#dvQutationServicesChangeOrder" ).dialog( "option", "title", 'Change Sequence Order of Services' );
				jQuery( "#dvQutationServicesChangeOrder" ).dialog( "option", "zIndex", index+1000 );
				index = index+1000;
				jQuery( "#dvQutationServicesChangeOrder" ).dialog( "open" );

				jQuery.ajax({type:'POST',data:{quotationId: ${quotationInstance?.id}},
							 url:'${baseurl}/serviceQuotation/changeOrders',
							 success:function(data,textStatus){jQuery('#dvQutationServicesChangeOrder').html(data);},
							 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false
			});
			
			jQuery('#addExpense').click(function() {

				jQuery( "#dvQutationServices" ).dialog( "option", "title", 'Expenses' );
				jQuery( "#dvQutationServices" ).dialog( "option", "zIndex", index+1000 );
				index = index+1000;
				jQuery( "#dvQutationServices" ).dialog( "open" );

				jQuery.ajax({type:'POST',data:jQuery(this).parents('form:first').serialize(),
							 url:'${baseurl}/quotation/addExpense',
							 success:function(data,textStatus){jQuery('#dvQutationServices').html(data);refreshForecastValue();},
							 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false
			}); 

			jQuery('#showExpense').click(function() {

				jQuery( "#dvQutationServices" ).dialog( "option", "title", 'Expenses' );
				jQuery( "#dvQutationServices" ).dialog( "option", "zIndex", index+1000 );
				index = index+1000;
				jQuery( "#dvQutationServices" ).dialog( "open" );

				jQuery.ajax({type:'POST',data:jQuery(this).parents('form:first').serialize(),
							 url:'${baseurl}/quotation/showExpense',
							 success:function(data,textStatus){jQuery('#dvQutationServices').html(data);refreshForecastValue();},
							 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false
			}); 
			
			jQuery('#rejectDiscount').click(function() 
			{
				 jQuery( "#dvQuote" ).dialog( "close" );
							 
				 jQuery.post( '${baseurl}/quotation/rejectDiscount', jQuery(this).parents('form:first').serialize(),
					      function( data )
					      {
					          if(data == 'success')
					          {		        		                   		
			                   		jQuery( "#successDialog" ).dialog("open");
						      }
						      else
						      {
						      		jQuery( "#failureDialog" ).dialog("open");
						      }
					          
					          return false;
					      });
					
					
					//alert("hello");
					return false;
			}); 
			
			jQuery( "#successDialog" ).dialog(
		 	{
				modal: true,
				autoOpen: false,
				resizable: false,
				buttons: 
				{
					OK: function() 
					{
						jQuery( "#successDialog" ).dialog( "close" );
						return false;
					}
				}
			});
					
			jQuery( "#failureDialog" ).dialog(
			{
				modal: true,
				autoOpen: false,
				resizable: false,
				buttons: {
					OK: function() {
						jQuery( "#failureDialog" ).dialog( "close" );
						return false;
					}
				}
			});
			
	 	});

		jQuery( "#dvQutationServicesChangeOrder" ).dialog(
	 	{
	 		height: 300,
			width: 500,
			modal: true,
			autoOpen: false,
			resizable: false,
			buttons: 
			{
				OK: function() 
				{
					jQuery( "#dvQutationServicesChangeOrder" ).dialog( "close" );
					refreshQuotation(${quotationInstance?.id});
					return false;
				}
			}
		});

		

</script>
    
    <div class="body">
    		
    		<div id="dvQutationServicesChangeOrder" >
				
			</div>
			
    		<div id="successDialog" title="Success">
				<p><g:message code="quotation.discountRequest.reject.message.success.dialog" default=""/></p>
			</div>
	
			<div id="failureDialog" title="Failure">
				<p><g:message code="quotation.discountRequest.reject.message.failure.dialog" default=""/></p>
			</div>
        
            <div id="dvQuotationInfo" class="dialog">
                <g:render template="/quotation/showInfo" model="['quotationInstance': quotationInstance, 'serviceQuotations': serviceQuotations, 'readOnly': readOnly]"/>
            </div>
            
            <div>
	        	<g:hiddenField name="id" value="${quotationInstance?.id}" />
	        	
	        	<g:if test="${!readOnly}">
	        		<g:if test="${quotationInstance?.status?.name != 'rejected'}">
			        	<g:if test="${canModifyServices}">
							
							<input id="addService" title="Add Service" type="button" value="Add Service" class="button"/>
						         	
							<input id="addDiscount" type="button" title="Add Discount" value="Add Discount" class="button"/>
							
							<g:if test="${quotationInstance?.expenseAmount == 0 }">
								<input id="addExpense" title="Add Expense" type="button" value="Add Expense" class="button"/>
							</g:if>
							<g:else>
								<input id="showExpense" title="Modify Expense" type="button" value="Modify Expense" class="button"/>
							</g:else>
							
							<g:if test="${serviceQuotations?.size() > 0 }">
								<input id="changeOrder" title="Change Sequence Order" type="button" value="Change Order" class="button"/>
							</g:if>
							
							<g:if test="${!moreDiscountAllowed && !SecurityUtils.subject.hasRole('SYSTEM ADMINISTRATOR') && !SecurityUtils.subject.hasRole('SALES PRESIDENT')}">
								<span class="discount">Discount Request Sent </span>|
							</g:if>
							
							<input type="hidden" value="${serviceQuotations?.size()}" id="serviceQuoteSize" />
						</g:if>
					</g:if>
	        	</g:if>
	        	
				
				<b>
					<label> Forecast Value: </label>
					<label id="lblForecastValue"> ${quotationInstance.geo.currencySymbol} ${quotationInstance.forecastValue}</label>
					|
				</b>
				
				<b>
					<label> Valid For ${quotationInstance.validityInDays} Days </label>
					
				</b>
				
				<g:if test="${!readOnly}">
					<g:if test="${discountReject}">
						<input id="rejectDiscount" title="Cancel Discount Request" type="button" value="Cancel Discount Request" class="button"/>
						<!--span class="menuButton"><g:link class="edit" action="edit" id="${quotationInstance?.id}"> Cancel Discount Request </g:link> </span-->
					</g:if>
					
		            <g:if test="${false}">
		            	<span class="menuButton"><g:link class="edit" action="edit" id="${quotationInstance?.id}"> Edit </g:link> </span>
		            	<span class="menuButton"><g:link action="exportPDF" id="${quotationInstance?.id}"> Generate Quote[PDF] </g:link>  </span>
		            	<span class="menuButton"><g:link action="exportSOWInPDF" id="${quotationInstance?.id}"> Generate SOW[PDF] </g:link>  </span>
		            </g:if>
	            </g:if>
        	</div>
        	<hr>
        	
			<table style="border-style: solid;">
				<tr> 
					<g:if test="${!readOnly}">
						<td valign="top" style="vertical-align: top;"><div id="dvAddQuote" >Loading ... </div></td>
						<g:if test="${quotationInstance?.status?.name != 'rejected'}">
							<g:if test="${canModifyServices}">
								<td width="10px">
										<input id="toggleAddQuote" type="button" value="&gt;&gt;"/>
								</td>
							</g:if>
						</g:if>
					</g:if>
					
					<td width="100%">
			       		<div id="dvQuotationMain" class="list">
						     
						     <script>

						     	jQuery(document).ready(function()
						    	{
						    	 		jQuery( "#dvQutationServices" ).dialog(
						    				{
						    					height: 500,//'auto',
						    					width: 800,
						    					modal: true,
						    					autoOpen: false,
						    					close: function( event, ui ) {
													jQuery(this).html('');

													refreshQuotation(${quotationInstance?.id});
												}
						    					
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
					   							 
					   							 success:function(data,textStatus){jQuery('#dvQuote').html(data);refreshForecastValue();},
					   							 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false
						    		 		}); 

						    		 	});
						     
						     </script>   
						        	<div id="dvQutationServices">
						        		
						        	</div>
						            
						          
									<table class="gridtable">		
										<thead>
											<tr>
												<th> Portfolio </th>
																				
												<th><g:message code="serviceQuotation.service.label" default="Service" /></th>
												
												<th>Unit Of <br />Sale</th>
											
												<g:sortableColumn property="totalUnits" title="${message(code: 'serviceQuotation.totalUnits.label', default: 'Units')}" />
																						
												<g:sortableColumn property="price" title="${message(code: 'serviceQuotation.price.label', default: 'Price')}" />
												
												<g:if test="${canModifyServices}">
												<th> </th>
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
													
													<td>
														<g:link controller="service" class="hyperlink" action="show" title="Show Service" params="[serviceProfileId: serviceQuotationInstance?.profile?.id]">${fieldValue(bean: serviceQuotationInstance, field: "service")} [Version ${serviceQuotationInstance.profile.revision}]</g:link>
														
														<g:if test="${serviceQuotationInstance?.isCorrected == 'yes' }">
						                           			<span class="editableIcon" title="Edited ServiceQuotation">&#x270D;</span>
						                           		</g:if>
													</td>
												
													<td>${serviceQuotationInstance?.profile?.unitOfSale}</td>
													
													<td>${fieldValue(bean: serviceQuotationInstance, field: "totalUnits")}</td>
																			
													<td>${fieldValue(bean: serviceQuotationInstance, field: "geo.currencySymbol")}${fieldValue(bean: serviceQuotationInstance, field: "price")} </td>
													
													<g:if test="${!readOnly}">
													
														<g:if test="${canModifyServices}">
															<td> 
																<input id="sqid-${serviceQuotationInstance.id}" type="button" value="Edit" title="Edit" class="sqEdit button"/> 
															</td>
															<td>	
																<input id="sqid-${serviceQuotationInstance.id}" type="button" value="Delete" title="Delete" class="sqDelete button"/>
															</td>
														</g:if>
													</g:if>
													
												</tr>
													
											</g:each>
											
										</tbody>
										<tfoot>
											<tr>
												<td colspan="7">	
												</td>
											</tr>
											<tr>
												<td colspan="7" align="right">
												<div style="float: right">
										       		<table id="summary" style="float: right;">
											        		<tbody>
											        			<tr> </tr>
											        			<tr class="prop">
											        				<td valign="top" id="totalPrice" class="quotename"> Subtotal Price: </td>
											                        <td valign="top" id="totalPriceValue" class="value">${quotationInstance?.geo?.currencySymbol}${fieldValue(bean: quotationInstance, field: "totalQuotedPrice")}</td>
											        			</tr>
											        			
											        			<tr class="prop">
											        				<td class="quotename"> Discount: </td>
											        				
											        				<td> ${quotationInstance?.geo?.currencySymbol}${fieldValue(bean: quotationInstance, field: "discountAmount")}
											        				 ${(!quotationInstance.flatDiscount ? '(' + quotationInstance.discountPercent + '%)': '')} </td>
											        			</tr>
											        			<tr class="prop">
											        				<td class="quotename"> Tax:   </td>
											        				
											        				<td> ${quotationInstance?.geo?.currencySymbol} ${fieldValue(bean: quotationInstance, field: "taxAmount")} 
											        				(${fieldValue(bean: quotationInstance, field: "taxPercent")}%) 
											        				</td>
											        			</tr>
											        			<tr class="prop">
											        				<td class="quotename"> Expenses:   </td>
											        				
											        				<td> ${quotationInstance?.geo?.currencySymbol} ${fieldValue(bean: quotationInstance, field: "expenseAmount")} </td>
											        			</tr>
											        			<tr class="prop">
											        				<td class="quotename"> Total Price:  </td>
											        				
											        				<td> ${quotationInstance?.geo?.currencySymbol} ${fieldValue(bean: quotationInstance, field: "finalPrice")}  </td>
											        				
											        			</tr>
											        		</tbody>
											        </table>
											       </div>
												</td>
											</tr>
										</tfoot>
									</table>
							
			       		</div>
					</td>
				</tr>
			</table>
       
        <g:if test="${!requestDone}">
	        <div>
	        	<g:if test="${notificationList?.size()>0}">
	        		<h1>Notification Request</h1><hr>
	        		<table><tbody>
			        	<g:each in="${notificationList}" status="i" var="notification" >
			                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}" style="border-bottom-style:dotted;">
			                    <td class="bottom">
			                    	<p style="width:725px; font-size: 100%;">${notification.comment}</p>
			                    </td>    
			                    
			                    <td class="bottom">Submitted By:${notification.createdBy}
		                           <br>
		                            <g:formatDate  format="MMMMM d, yyyy" date="${notification.dateCreated}" />
		                        </td>                 
			                </tr>
			                
			            </g:each>
		            <table><tbody>
		        </g:if>
	        </div>
        </g:if>
    </div>
