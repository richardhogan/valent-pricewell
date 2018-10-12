<%@ page import="com.valent.pricewell.ProductPricelist" %>
<%
	def baseurl = request.siteUrl
%>
<html>
		<script>
		   	jQuery(function() 
		   	{
		   		jQuery("#savePricelistForm input:text")[0].focus();
		   		
				jQuery('#doneLoading').hide();
				jQuery.getJSON('${baseurl}/productPricelist/getgeostoaddjson/${productId}', function(data) {
					
					if(data.results.size() == 0){
						jQuery('#waiting').html('<p> Prices for all territories have been defined.. </p>');
					} else {
						jQuery('#doneLoading').show();
						jQuery('#waiting').hide();
						var box = jQuery('#geoSelect').flexbox(data,
						{autoCompleteFirstMatch: true, 
							watermark: 'Type Territory',
							paging: {pageSize: 5},
						    noResultsText: 'no results found',  
						    onSelect: function() {  
								jQuery('#geo\\.id').val(jQuery('input[name=geoSelect]').val());  
						    }});

							jQuery( "#savePricelist" ).button();
							jQuery('#savePricelist').click(function(){
								if(jQuery('#savePricelistForm').validate().form())
					        	{
									showLoadingBox();
									jQuery.ajax({
											type:'POST',
											data: jQuery('#savePricelistForm').serialize(),
										 	url:'${baseurl}/productPricelist/save',
										 	success:function(data,textStatus)
										 	{
										 		hideLoadingBox();
												jQuery('#productPricelist').html(data);
										 		jQuery( "#pricelistDialog" ).dialog( "close" );
											},
										 	error:function(XMLHttpRequest,textStatus,errorThrown){}
										});
								}

								return false;
							});
					}
					
				});
				
			});
		</script>
	<div id="waiting">
		<p> Loading ....</p>
	</div>
       <div id="doneLoading" class="body">
            <g:hasErrors bean="${productPricelistInstance}">
            <div class="errors">
                <g:renderErrors bean="${productPricelistInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form name="savePricelistForm" action="save" >
                <div class="dialog">
					<g:hiddenField name="product.id" value="${productId}"/>
					<table style="width: 100%"><tr>
					<td>
					<label for="geo"><g:message code="productPricelist.geo.label" default="Territory" /></label>
					</td>
					<td>
						<g:hiddenField name="geo.id" class="required"/>
						<div id="geoSelect"></div>  
					</td>
					</tr>
					<tr>
					<td>
					<label for="unitPrice"><g:message code="productPricelist.unitPrice.label" default="Unit Price" /></label>
					</td>
					<td>
					 <g:textField name="unitPrice" class="required number" value="${fieldValue(bean: productPricelistInstance, field: 'unitPrice')}" />
					</td>
					</tr>
					<tr>
					<td>
					<button id="savePricelist" title="Save">Save</button>
					</td>
					</tr>
					</table>
                </div>
            </g:form>
        </div>
    </body>
</html>
