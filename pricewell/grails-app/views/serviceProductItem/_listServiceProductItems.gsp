<%@ page import="com.valent.pricewell.ServiceProductItem" %>
<%
	def baseurl = request.siteUrl
%>
<style type="text/css" title="currentStyle">
			@import "${baseurl}/js/dataTables/css/demo_page.css";
			@import "${baseurl}/js/dataTables/css/demo_table.css";
		</style>
<g:if test="${session['designPermit']}">
<script type="text/javascript" language="javascript" src="${baseurl }/js/dataTables/js/jquery.dataTables.js"></script>
<script type="text/javascript">
jQuery.noConflict();
		</script>

<g:setProvider library="prototype"/>
<script>

	jQuery(document).ready(function()
			{
				jQuery('#serviceProductItemList').dataTable({
					"sPaginationType": "full_numbers",
					"sDom": 't<"F"ip>',
			        "bFilter": false,
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

				jQuery(".btnDeleteProductItem").click(function()
				{
					var id = this.id.substring(21);
					jConfirm('Do you want to delete this product?', 'Please Confirm', function(r)
	   				{
					    if(r == true)
	    				{
					    	showLoadingBox();
					    	jQuery.ajax(
							{
								type: "POST",
								url: "${baseurl}/serviceProductItem/deleteFromService",
								data: {id: id},
								success: function(data)
								{
									hideLoadingBox();
									jQuery('#mainProductsRequiredTab').html(data);
									//hideUnhideActionBtn();
									
								}, 
								error:function(XMLHttpRequest,textStatus,errorThrown){
									alert("Error while saving");
								}
							});
	    				}
					});
						
					
					return false;
				}); 

				jQuery(".btnEditProductItem").click(function()
				{
					var id = this.id.substring(19);
					showLoadingBox();
			    	jQuery.ajax(
					{
						type: "POST",
						url: "${baseurl}/serviceProductItem/editFromService",
						data: {id: id},
						success: function(data)
						{
							hideLoadingBox();
							jQuery('#mainProductsRequiredTab').html(data);
							hideUnhideActionBtn();
							
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){
							alert("Error while saving");
						}
					});

	    			return false;
				}); 
			});


	function createNewServiceProductItem()
	{
		jQuery.ajax({
			type: "POST",
			url: "${baseurl}/serviceProductItem/createFromService",
			data: {'id': ${serviceProfileInstance.id}},
			success: function(data){jQuery("#mainProductsRequiredTab").html(data);}, 
			error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
		});
		
		return false;
	}
</script>

<div class="nav">
	<span>
		<!--<g:remoteLink class="buttons.button button" controller="serviceProductItem" title="Add Product Item" action="createFromService" id = "${serviceProfileInstance.id}" 
		 		update="[success:'mainProductsRequiredTab',failure:'mainProductsRequiredTab']">
		 			Add Product Item
		</g:remoteLink>-->
		 
		<a id="idCreateNewServiceProductItem" onclick="createNewServiceProductItem();" class="buttons.button button" title="Add Product Item">Add Product Item</a> 
	</span>
</div>
</g:if>

<div class="body">
            <g:if test="${flash.message}">
            	<!--div class="message">${flash.message}</div-->
        <!--     	<script>alert("${flash.message}");</script> --> 
        		<script>
			       	  
				</script>
            </g:if>
            <div class="list">
                <table class="list" id="serviceProductItemList">
                    <thead>
                        <tr> 	
                            <th>${message(code: 'serviceProductItem.productName.label', default: 'Product Name')}</th>
                        
                            <th>${message(code: 'serviceProductItem.productType.label', default: 'Product Type')}</th>
                        
                            <th>${message(code: 'serviceProductItem.unitsSoldRatePerAdditionalUnit.label', default: 'Products Sold per Service Unit')}</th>
                            <th></th>
                            <th></th>
                        
                        </tr>
                    </thead>
                    <tbody>
                    
                    <g:each in="${serviceProfileInstance?.productsRequired}" status="i" var="serviceProductItemInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                            
                            <td>${serviceProductItemInstance?.product?.productName}</td>
                        
                            <td>${serviceProductItemInstance?.product?.productType}</td>
						
							<td>${fieldValue(bean: serviceProductItemInstance, field: "unitsSoldRatePerAdditionalUnit")}</td>
                            
                            <td> 
                            	<g:if test="${session['designPermit'] && session['checkResponsiblity']}">
                					<button id="btnEditProductItem-${serviceProductItemInstance.id}" class="btnEditProductItem" title="Edit Product">Edit</button>
                				</g:if>
                			</td>
               
               				 <td> 
               				 	<g:if test="${session['designPermit'] && session['checkResponsiblity']}">
                					<button id="btnDeleteProductItem-${serviceProductItemInstance.id}" class="btnDeleteProductItem" title="Delete Product">Delete</button>
                				</g:if>                	
                			</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
   </div>