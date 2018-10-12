<%@ page import="com.valent.pricewell.ProductPricelist" %>
<%
	def baseurl = request.siteUrl
%>
<html>
		<script>
		   	jQuery(function() 
		   	{
		   		jQuery("#savePricelistForm input:text")[0].focus();
		   		
				jQuery( "#savePricelist" ).button();
				jQuery('#savePricelist').click(function(){
					if(jQuery('#savePricelistForm').validate().form())
		        	{
						showLoadingBox();
						jQuery.ajax({
								type:'POST',
								data: jQuery('#savePricelistForm').serialize(),
							 	url:'${baseurl}/productPricelist/update',
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
				jQuery('#unitPrice').focus();
			});
		</script>
       <div class="body">
            <g:hasErrors bean="${productPricelistInstance}">
            <div class="errors">
                <g:renderErrors bean="${productPricelistInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form name="savePricelistForm" action="save" >
                <div class="dialog">
					<g:hiddenField name="id" value="${productPricelistInstance.id}"/>
					<table><tr>
					<td>
					<label for="geo"><g:message code="productPricelist.geo.label" default="Geo" /></label>
					 <span> ${productPricelistInstance?.geo?.name} </span> 
					</td>
					</tr><tr>
					<td>
					<label for="unitPrice"><g:message code="productPricelist.unitPrice.label" default="Unit Price" /></label>
					${productPricelistInstance?.geo?.currencySymbol}
					 <g:textField name="unitPrice" class="required number" value="${fieldValue(bean: productPricelistInstance, field: 'unitPrice')}" />
					</td>
					</tr><tr><td>
					<button id="savePricelist" title="Update">Save</button></td>
					</tr>
				</table>
                </div>
            </g:form>
        </div>
    </body>
</html>
