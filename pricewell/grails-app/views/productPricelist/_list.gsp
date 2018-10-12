<%@ page import="com.valent.pricewell.ProductPricelist" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <body>
		<script>
		   	jQuery(function() 
		   	{
				jQuery('#productPricelistTable').dataTable({
					"sPaginationType": "full_numbers",
					"sDom": '<"H"f>t<"F"ip>',
			        "bFilter": true,
			        "fnDrawCallback": function() {
		                if (Math.ceil((this.fnSettings().fnRecordsDisplay()) / this.fnSettings()._iDisplayLength) > 1)  {
		                        jQuery('.dataTables_paginate').css("display", "block"); 
		                        jQuery('.dataTables_length').css("display", "block");                       
		                } else {
		                		jQuery('.dataTables_paginate').css("display", "none");
		                		jQuery('.dataTables_length').css("display", "none");
		                }
		            }
				});
				
				jQuery( "#pricelistDialog" ).dialog(
						{
							height: 240,
							width: 600,
							modal: true,
							autoOpen: false

						});
						
				
				jQuery( "#addPricelist" ).button();
				jQuery('#addPricelist').click(function(){
					jQuery( "#pricelistDialog" ).html("");
					jQuery( "#pricelistDialog" ).dialog( "option", "title", 'Add Product Pricelist' );
					jQuery( "#pricelistDialog" ).dialog( "open" );

					jQuery.ajax({type:'GET',data: {pid: <%=productInstance.id%>},
						 url:'${baseurl}/productPricelist/create',
						 success:function(data,textStatus){jQuery('#pricelistDialog').html(data);},
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});
					
					return false
				})
				
				jQuery('.editPricelist').button();
				jQuery('.editPricelist').attr("title", "Edit");
				jQuery('.editPricelist').click(function(){
					pos = this.id;
					jQuery( "#pricelistDialog" ).html("");
					jQuery( "#pricelistDialog" ).dialog( "option", "title", 'Edit Product Pricelist' );
					jQuery( "#pricelistDialog" ).dialog( "open" );
					
					jQuery.ajax({type:'GET',data: {id: pos},
						 url:'${baseurl}/productPricelist/edit',
						 success:function(data,textStatus){jQuery('#pricelistDialog').html(data);},
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});
					
					return false;
				});
				
				jQuery('.deletePricelist').button();
				jQuery('.deletePricelist').attr("title", "Delete");
				jQuery('.deletePricelist').click(function()
				{
					showLoadingBox();
					pos = this.id;
					
					jQuery.ajax({
							type:'POST',
							data: {id: pos},
						 	url:'${baseurl}/productPricelist/delete',
						 	success:function(data,textStatus)
						 	{
						 		hideLoadingBox();
								jQuery('#productPricelist').html(data);
						 		jQuery( "#pricelistDialog" ).dialog( "close" );
							},
						 	error:function(XMLHttpRequest,textStatus,errorThrown){}
						});
					
					return false;
				});
				
			});
	   	</script>
        <div class="nav">
            <button id="addPricelist" title="Add Price for Territory"> Add Price for Territory</button>
        </div>
        <div class="body">
            <div class="list">
                <table cellpadding="0" cellspacing="0" border="0" class="display"  id="productPricelistTable">
                    <thead>
                        <tr>
                        
                            <th><g:message code="productPricelist.geo.label" default="Territory" /></th>
                        	<th> Cur  </th>
							<th> ${message(code: 'productPricelist.unitPrice.label', default: 'Unit Price')} </th>
							

						<th> </th>
                        <th>  </th>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${productInstance?.productPricelists}" status="i" var="productPricelistInstance">
                        <tr>
                        
                            <td>${fieldValue(bean: productPricelistInstance, field: "geo")}</td>
							
							<td> ${productPricelistInstance.geo.currencySymbol} </td>
                        
                            <td>${fieldValue(bean: productPricelistInstance, field: "unitPrice")}</td>
                        	
							<td> <button class="editPricelist" title="Edit Price List" id="${productPricelistInstance?.id}"> <r:img dir="images" file="edit-24.png"/>  </button> </td>
							<td> <button class="deletePricelist" title="Delete Price List" id="${productPricelistInstance?.id}"> <r:img dir="images" file="delete-24.png"/> </button> </td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
			<div id="pricelistDialog"> </div>
        </div>
    </body>
</html>
