<%@ page import="com.valent.pricewell.Quotation" %>
<%@ page import="com.valent.pricewell.QuotationService" %> 
<%@ page import="com.valent.pricewell.SalesController"%>
<%
	def baseurl = request.siteUrl
	def salesController = new SalesController()
%>
	<style>
		.editableIcon {
			   color: black;
			   font-size:20px;
			}
		.editableIcon:hover {
			   color: blue;
			   font-size:20px;
			}
	</style>
 <script>
 jQuery(document).ready(function()
	{
		
	jQuery('#addQuote').button();
	jQuery('#addQuote').click(function() {

		jQuery( "#dvNewQuote" ).dialog( "option", "title", 'New SOW' );
		jQuery( "#dvNewQuote" ).dialog( "option", "zIndex", index+1000 );
		index = index+1000;
		jQuery('#dvNewQuote').html("Loading Please Wait....");
		jQuery( "#dvNewQuote" ).dialog( "open" );

		jQuery.ajax({type:'POST',data: {opportunityId: ${opportunityInstance.id} },
					 url:'${baseurl}/quotation/create',
					 success:function(data,textStatus){jQuery('#dvNewQuote').html(data);},
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false
		});

	 jQuery('.convertToServiceTicket').click(function() {

		 var id = this.id.substring(23);

		 	jQuery.ajax({
				type: "POST",
				url: "${baseurl}/connectwiseCredentials/isCredentialsAvailable",
				success: function(data)
				{
					if(data['result'] == "yes")
					{
						jQuery( "#serviceTicketConfigurationDialog" ).html("Loading, Please wait...").dialog("open");
						
						jQuery.ajax({type:'POST',
							 url: "${baseurl}/quotation/getServiceTicketConfiguration",
							 data: {id: id} ,
							 success:function(data,textStatus)
							 {
								 jQuery( "#serviceTicketConfigurationDialog" ).html(data);
							 },
							 error:function(XMLHttpRequest,textStatus,errorThrown){}});
					}
					else
					{
						alert(data['failureMessage']);
					}
					
				}, 
				error:function(XMLHttpRequest,textStatus,errorThrown){alert("Something goes wrong.");}
			});
			
		 return false
	 });

	 jQuery( "#serviceTicketConfigurationDialog" ).dialog(
		{
			height: 400,
			width: 900,
			modal: true,
			autoOpen: false,
			close: function( event, ui ) {
					jQuery(this).html('');
				}
		}); 
		
	 jQuery('.quotebutton').button();
		jQuery('.quotebutton').click(function()
		{
			var id = this.id.substring(11);
			pos = id;
			source = "fromOpportunity";
			jQuery( "#dvQuote" ).html("");
			jQuery( "#dvQuote" ).dialog( "option", "title", 'SOW ' + pos );
			jQuery( "#dvQuote" ).dialog( "option", "zIndex", index+1000 );
			index = index+1000;
			
			var options = {
 			    buttons: {
 			    	'Save': function() 
 			        {
 			        	//refreshList();
 			        	saveQuote(pos);
						//jQuery( "#successdialog" ).html('<p>'+data['msg']+'</p>');
						var options_n1 =	{buttons: {}};
						jQuery("#dvQuote").dialog('option', options_n1);
						jQuery("#dvQuote").dialog("close");
						return false;
 			        },
 			    	'Cancel': function()
 			        {
 			    		//refreshList();
 			    		cancelQuote(pos);
 			        	var options_n2 =	{buttons: {}};
						jQuery("#dvQuote").dialog('option', options_n2);
						jQuery("#dvQuote").dialog("close");
					    return false;
	 			    }
 			    }
 			};
			
			jQuery("#dvQuote").dialog('option', options);
	 	    jQuery("#dvQuote").dialog( "open" );

			jQuery.ajax({type:'POST',data: {id: pos, source: source},
				 url:'${baseurl}/quotation/show',
				 success:function(data,textStatus)
				 {
					 jQuery('#dvQuote').html(data);
					 if("true" == '${quoteAvailable}')
				     {
					     window.location = "${baseurl}/downloadFile/downloadDocumentFile?filePath=${filePath}";
				     } 
				 },
				 error:function(XMLHttpRequest,textStatus,errorThrown){}});
			return false
		})

		if("true" == '${quoteAvailable}')
        {
    		jQuery("#quotebutton${quotationInstance?.id}").trigger("click");  
    		
        }
});
 </script>
 
 <%
 	def listQuotations = opportunityInstance.latestQuotations()
 	BigDecimal totalforecastValue = new BigDecimal(0)
	BigDecimal totalActualValue = new BigDecimal(0)
	
	for(Quotation q in listQuotations){
		if(q.forecastValue && q.confidencePercentage){
									totalforecastValue += q.forecastValue
									if(q.confidencePercentage >= 100){
										totalActualValue += q.finalPrice
									}
								}
	} 
 
  %>
  
  <div id="serviceTicketConfigurationDialog" title="Service Ticket Configuration">
			
  </div>
                <table>
                    <thead>
                    	<tr>
                    		<td colspan="2"> 
                    			<g:if test="${opportunityInstance?.stagingStatus?.name != 'closedWon' && opportunityInstance?.stagingStatus?.name != 'closedLost'}">
                    				<span class="menuButton">
                    					<input id="addQuote" type="button" title="Create New SOW" style="font-size:0.8em" value="New SOW" class="button button.darkbutton"/>
                   					</span>
                   				</g:if>
                			</td>
	                		<g:if test="${opportunityInstance.amount != 0}">
		                		<td colspan="2" style="text-align:right; vlaign: top"> <b> Actual vs Opportunity: </b> </td>
		                		<td style="text-align:right" colspan="2"> <g:render template="/quotation/forecastValue" model="['id': 'actualtotal', 'value': totalActualValue, 'total': opportunityInstance.amount, 'currency': opportunityInstance.geo?.currencySymbol ]"/> </td>
		                		<td colspan="2" style="text-align:right; vlaign: top"> <b> Forecast vs Opportunity: </b> </td>
		                		<td style="text-align:right" colspan="2"> <g:render template="/quotation/forecastValue" model="['id': 'forecasttotal', 'value': totalforecastValue, 'total': opportunityInstance.amount, 'currency': opportunityInstance.geo?.currencySymbol ]"/> </td>
                			</g:if>
                		</tr>
                        <tr>
                           <th > </th>
                           
                            <th style="text-align:right; width: 8em"> 
                           		Quotation ID 
                           		
                         	</th>
                            
                            <th style="text-align:right;"> ${message(code: 'quotation.status.label', default: 'Quotation Stage')} </th>
                            
                            <th style="text-align:right;"> ${message(code: 'quotation.contractStatus.label', default: 'Contract Stage')} </th>
                            
                            <th style="text-align:right;">${message(code: 'quotation.discountPercent.label', default: 'Discount %')}</th>
                            
                            <th style="text-align:right;">${message(code: 'quotation.totalQuotedPrice.label', default: 'Total Quoted Price')}</th>
                            
                            <th style="text-align:right;">${message(code: 'quotation.validity.label', default: 'Valid Until')}</th>
                                                        
                            <th style="text-align:right;"> ${message(code: 'quotation.confidencePercentage.label', default: 'Confidence %')}  </th>
                            
                            <th style="text-align:right;"> ${message(code: 'quotation.forecastValue.label', default: 'Forecast Value')}  </th>
                           
                    		<th style="text-align:right;"> ${message(code: 'quotation.modifiedDate.label', default: 'Modified Date')} </th>
                    		

					</tr>
                    </thead>
                    <tbody>
                    <g:each in="${listQuotations}" status="i" var="quotationInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                        	<td align="right">
                        		<input id="quotebutton${quotationInstance.id}" name="quotebutton${quotationInstance.id}" type="button"  value="Show" title="Show Details" class="button quotebutton"/> 
                        	
                        		<g:if test="${salesController.isConnectwiseIncluded()}">
	                        		<g:if test="${salesController.isQuoteForConnectwiseOpportunity(quotationInstance.id)}">
	                        			
	                            			| <input id="convertToServiceTicket-${quotationInstance.id }" type="button" title="Create Project Tickets" value="Create Tickets" class="button convertToServiceTicket"/>
	                            		
	                            	</g:if>
                            	</g:if>
                        	</td>
                        
                            <td style="text-align:left;width: 8em">
                            	${quotationInstance.id}
                            	
                            	<g:if test="${quotationInstance?.isCorrected == 'yes' }">
                           			<span class="editableIcon" title="Edited Quote (Edited ServiceQuotation)">&#x270D;</span>
                           		</g:if>
                           		
                           	</td>
                            
                            <td style="text-align:right;"> <g:render template="/quotation/starProgress" model="['stage': quotationInstance.status, 'type': 'quotation', 'id': quotationInstance.id]"></g:render> </td>
                            
                            <td style="text-align:right;"> <g:render template="/quotation/starProgress" model="['stage': quotationInstance.contractStatus, 'type': 'contract', 'id': quotationInstance.id]"></g:render> </td>
                            
                            <td style="text-align:right;">   ${fieldValue(bean: quotationInstance, field: "discountPercent")}% </td>
                        	
                        	<td style="text-align:right;"> ${quotationInstance.geo?.currencySymbol}${fieldValue(bean: quotationInstance, field: "finalPrice")} &nbsp;  </td>
                        	
                        	<td style="text-align:right;"><g:formatDate format="MMMMM d, yyyy" date="${quotationInstance.createdDate + quotationInstance.validityInDays}" /></td>
                        	
                        	<td style="text-align:right;width: 10em"> <g:render template="/quotation/confidencePercentage" model="['quotationInstance': quotationInstance]"/> </td>
                        	
                        	<td style="text-align:right;">  ${quotationInstance.geo?.currencySymbol} ${fieldValue(bean: quotationInstance, field: "forecastValue")} </td>
                        	    
                            <td style="text-align:right;"><g:formatDate format="MMMMM d, yyyy" date="${quotationInstance.modifiedDate}" /></td>
                            
                        </tr>
                    </g:each>
                    
                    <script>
                    	
                    </script>
				</tbody>
			</table>
 