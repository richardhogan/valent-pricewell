
<%@ page import="com.valent.pricewell.ServiceQuotation" %>
<%
	def baseurl = request.siteUrl
%>
<html>
<script>
jQuery(document).ready(function()
	 	{

		jQuery( "#dvQutationServices" ).dialog(
			{
				height: 340,
				width: 650,
				modal: true,
				autoOpen: false,
				
			});

		jQuery("':radio'").click( function() {
				jQuery('#editService').show();
				jQuery('#deleteService').show();
			}
		);
				
	
			jQuery( "#addService" )
			.click(function() {
				jQuery( "#dvQutationServices" ).dialog( "option", "title", 'Add Service to Quotation' );
				jQuery( "#dvQutationServices" ).dialog( "open" );
				
				jQuery.ajax({type:'POST',
								data:jQuery(this).parents('form:first').serialize(), 
								url:'${baseurl}/serviceQuotation/addServiceToQuote',
								success:function(data,textStatus){
									jQuery('#dvQutationServices').html(data);},
								error:function(XMLHttpRequest,textStatus,errorThrown){}});
				return false
				
			});

			jQuery('#editService').click(function() {

				jQuery( "#dvQutationServices" ).dialog( "option", "title", 'Edit' );
				jQuery( "#dvQutationServices" ).dialog( "open" );

				jQuery.ajax({type:'POST',data:jQuery(this).parents('form:first').serialize(),
							 url:'${baseurl}/serviceQuotation/edit',
							 success:function(data,textStatus){jQuery('#dvQutationServices').html(data);},
							 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false
				});

			jQuery('#addDiscount').click(function() {

				jQuery( "#dvQutationServices" ).dialog( "option", "title", 'Discount' );
				jQuery( "#dvQutationServices" ).dialog( "open" );

				jQuery.ajax({type:'POST',data:jQuery(this).parents('form:first').serialize(),
							 url:'${baseurl}/quotation/discount',
							 success:function(data,textStatus){jQuery('#dvQutationServices').html(data);},
							 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false
				});

			
				
			jQuery('#editService').hide();
			jQuery('#deleteService').hide();
	 	});

		

</script>
    <body>
    
    	
    	
    	<div>
        <g:form controller="serviceQuotation" action="delete">
        <div class="body">
        	<div id="dvQutationServices">
        		
        	</div>
            <div>
            	
            </div>
            <div class="list" >
            	
					<table>		
						<thead>
							<tr>
								<th> Portfolio </th>
								
								<th><g:message code="serviceQuotation.service.label" default="Service" /></th>
							
								<g:sortableColumn property="totalUnits" title="${message(code: 'serviceQuotation.totalUnits.label', default: 'Units')}" />
																		
								<g:sortableColumn property="price" title="${message(code: 'serviceQuotation.price.label', default: 'Price')}" />
								
															
							</tr>
						</thead>
						<tbody>
							<g:each in="${portfolioList}" status="j" var="portfolioInstance">
									<!--${portfolioInstance.portfolioName}-->
								<tr bgcolor="#b0c4de">
									 
									<td colspan="5">
										<b> ${portfolioInstance.portfolioName} </b>
									<!--  	<b>	<g:link controller="portfolio" action="show" id="${portfolioInstance?.id}">${portfolioInstance.portfolioName}</g:link> </b>
									-->
									</td>
								</tr>
						
							
								<g:each in="${quotationInstance.serviceQuotations}" status="i" var="serviceQuotationInstance">
									<g:if test="${portfolioInstance?.portfolioName == serviceQuotationInstance?.service?.portfolio?.portfolioName}">
										
										
											<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
												<td width="10%"> </td>
												
												<td><g:link controller="service" class="hyperlink" action="show" params="[serviceProfileId: serviceQuotationInstance?.service?.id]">${fieldValue(bean: serviceQuotationInstance, field: "service")}</g:link></td>
											
												<td>${fieldValue(bean: serviceQuotationInstance, field: "totalUnits")}</td>
																		
												<td>${fieldValue(bean: serviceQuotationInstance, field: "price")} ${fieldValue(bean: serviceQuotationInstance, field: "geo.currencySymbol")}</td>
												
											</tr>
										
									</g:if>
								</g:each>
							</g:each>
						</tbody>
						<tfoot>
							<tr>
								
							</tr>
						</tfoot>
					</table>
				
                
            </div>
            
        </div>
        </g:form>
        </div>
    </body>   
</html>
