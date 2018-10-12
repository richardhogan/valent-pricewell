
<%@ page import="com.valent.pricewell.Product" %>
<%@ page import="com.valent.pricewell.ServiceProfile" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'product.label', default: 'Product')}" />
			
        <title><g:message code="default.show.label" args="[entityName]" /></title>
			<script>
			   	jQuery(function() 
			   	{
					jQuery( "#tabs" ).tabs();

					jQuery('.editDelete').each(function()
				    {
					      jQuery(this).qtip({
					         content: jQuery(this).attr('tooltip'), // Use the tooltip attribute of the element for the content
					         style: 'dark', // Give it a crea mstyle to make it stand out
					        	 
					               position: {
					                  corner: {
					                      // Use the corner...
					                     target: 'bottomLeft' // ...and opposite corner
					                  }
					               }
					      });
					
					});

					jQuery('.edit').attr("title", "Edit");
					jQuery('.delete').attr("title", "Delete");
				});
		   	</script>
    </head>
    <body>
        <div class="nav">
            <span><g:link class="buttons.button button" title="List Of Products" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span><g:link class="buttons.button button" title="Create Product" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
			<div class="collapsibleContainer">
				<div class="collapsibleContainerTitle ui-widget-header">
					<div>
						<div class="buttons">
			                <g:form>
								${entityName} : ${productInstance?.productName}
								&nbsp;&nbsp;
			                    <g:hiddenField name="id" value="${productInstance?.id}" />
			                    <span class="button"><g:actionSubmitImage title="Edit Product" class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" src="${resource(dir: 'images', file: 'edit-24.png')}"/></span>
			                    &nbsp;&nbsp;
			                    <span class="button">
			                    	<g:actionSubmitImage class="delete" title="Delete Product" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" src="${resource(dir: 'images', file: 'delete-24.png')}"  onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
			                    </span>
			                </g:form>
			            </div>
					</div>
				</div>
			
				<div class="collapsibleContainerContent ui-widget-content">
				
					<div class="dialog">
		                <table>
		                    <tbody>
		                    
		                        <tr class="prop">
		                            <td valign="top" class="name"><label><g:message code="product.id.label" default="Id" /> : </label></td>
		                            
		                            <td valign="top" class="value">${fieldValue(bean: productInstance, field: "id")}</td>
		                            
		                            <td>&nbsp;&nbsp;</td>
		
									<td valign="top" class="name"><label><g:message code="product.product_id.label" default="Product Id" /> : </label></td>
		                            
		                            <td valign="top" class="value">${fieldValue(bean: productInstance, field: "product_id")}</td>
									<td colspan="2"/>
		                            
		                        </tr>
		                        
								<tr class="prop">
		                            <td valign="top" class="name"><label><g:message code="product.productName.label" default="Product Name" /> : </label></td>
		                            
		                            <td valign="top" class="value">${fieldValue(bean: productInstance, field: "productName")}</td>
		                            
		                            <td>&nbsp;&nbsp;</td>
									<td valign="top" class="name"><label><g:message code="product.productType.label" default="Product Type" /> : </label></td>
		                            
		                            <td valign="top" class="value">${fieldValue(bean: productInstance, field: "productType")}</td>
									<td colspan="2"/>
		                            
		                        </tr>
		                    
		                       
		                        <tr class="prop">
		                            <td valign="top" class="name"><label><g:message code="product.unitOfSale.label" default="Unit Of Sale" /> : </label></td>
		                            
		                            <td valign="top" class="value">${fieldValue(bean: productInstance, field: "unitOfSale")}</td>
		                            
		                            <td>&nbsp;&nbsp;</td>
		                       
									<td valign="top" class="name"><label><g:message code="product.dateCreated.label" default="Date Created" /> : </label></td>
		                            
		                            <td valign="top" class="value"><g:formatDate format="MMMMM d, yyyy" date="${productInstance?.dateCreated}" /></td>
		                            
		                            <td>&nbsp;&nbsp;</td>
		
		                            <td valign="top" class="name"><label><g:message code="product.datePublished.label" default="Date Published" /> : </label></td>
		                            
		                            <td valign="top" class="value"><g:formatDate format="MMMMM d, yyyy" date="${productInstance?.datePublished}" /></td>
		                            
		                        </tr>
		                    
		                    
		                    </tbody>
		                </table>
		            </div>
						
					<!-- Tabes start -->	
					<div id="tabs">
					    <ul>
					        <li><a href="#productPricelist">Product Pricelists</a></li>
					        <li><a href="#servicesItems">Services using product</a></li>
					    </ul>
					    <div id="productPricelist">
					        <g:render template="/productPricelist/list" model="['updatePermission': updatePermission, 'productInstance': productInstance]"/>
					    </div>
					    <div id="servicesItems">
							<g:if test="${productInstance.serviceProductItems}">
								<table width="500px">
									<tr>
										<th> Service Name </th>
										<th> Products units sold per unit </th>
									</tr>
									<g:each in="${productInstance.serviceProductItems}" var="s">
										<g:if test="${s?.serviceProfile?.type != ServiceProfile.ServiceProfileType.INACTIVE}">
											<tr>
												<td> ${s.serviceProfile.service.serviceName} </td>
												<td> ${s.unitsSoldRatePerAdditionalUnit}</td>
											</tr>
										</g:if>
									</g:each>
								</table>
							</g:if>
							<g:else>
								<p>No service is using product yet.</p>
							</g:else>
					    </div>
					 </div> 
					 
				</div>
			</div>
		</div>	

    </body>
</html>
