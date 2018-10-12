<%@ page import="com.valent.pricewell.Product" %>

<%
	def baseurl = request.siteUrl
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'product.label', default: 'Product')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>

		<style type="text/css" title="currentStyle">
			@import "${baseurl}/js/dataTables/css/demo_page.css";
			@import "${baseurl}/js/dataTables/css/demo_table.css";
		</style>
			
		<script type="text/javascript" language="javascript" src="${baseurl}/js/dataTables/js/jquery.dataTables.js"></script>
		
        <script>
			jQuery(document).ready(function()
			{
				jQuery('#productList').dataTable({
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
			});
		</script>
		
    </head>
    <body>
        <div class="nav">
            <span><g:link class="create" title="Create Product" action="create" class="buttons.button button"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table cellpadding="0" cellspacing="0" border="0" class="display" id="productList">
                    <thead>
                        <tr>
                        	
							<th>${message(code: 'product.productName.label', default: 'Product Name')}</th>
                        
                            <!-- <th>${message(code: 'product.product_id.label', default: 'Product Id')}</th> -->
                        
                            <th>${message(code: 'product.productType.label', default: 'Product Type')}</th>
                        
                            <!-- <th>${message(code: 'product.dateCreated.label', default: 'Date Created')}</th>
                        
                            <th>${message(code: 'product.datePublished.label', default: 'Date Published')}</th>
                        
                            <th>${message(code: 'product.dateModified.label', default: 'Date Modified')}</th> -->
                            
                            <th>Price Defined Territories</th>
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${productInstanceList?.sort {it.dateModified}}" status="i" var="productInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" title="Show Details" class="hyperlink" id="${productInstance.id}">${fieldValue(bean: productInstance, field: "productName")}</g:link></td>
                        
                            <!-- <td>${fieldValue(bean: productInstance, field: "product_id")}</td> -->
                        
                            <td>${fieldValue(bean: productInstance, field: "productType")}</td>
                        
                            <!-- <td><g:formatDate format="MMMMM d, yyyy" date="${productInstance.dateCreated}" /></td>
                        
                            <td><g:formatDate format="MMMMM d, yyyy" date="${productInstance.datePublished}" /></td>
                        
                            <td><g:formatDate format="MMMMM d, yyyy" date="${productInstance.dateModified}" /></td> -->
                            
                            <td>${productInstance?.productPricelists?.geo.join(", ") }</td>
                            
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            
        </div>
    </body>
</html>
