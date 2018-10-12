<%@ page import="com.valent.pricewell.Product" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'product.label', default: 'Product')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
        <script>
	        jQuery(document).ready(function()
   			 {
	        	
  				 	jQuery("#productCreate").validate();
  				 	jQuery("#productCreate input:text")[0].focus();
  				 	jQuery( "#datePublished" ).datepicker({
	  				 		showOn: "button",
			    	        buttonImage: "${baseurl}/images/calendar.gif",
			    	        showWeek: true,
	      					firstDay: 1,
			    	        minDate: 1,
			    	        buttonImageOnly: true,
  				      		onClose: function() {jQuery(this).valid()}
  	  				 	});
  				 	
   			 });
        </script>
        
			    		
    </head>
    <body>
        <div class="nav">
            <span><g:link class="buttons.button button" title="List Of Products" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
        </div>
        
        <div class="body">
			<div class="collapsibleContainer">
				<div class="collapsibleContainerTitle ui-widget-header">
					<div>
						<b>Create</b> ${entityName}
					</div>
				</div>
			
				<div class="collapsibleContainerContent ui-widget-content">
				
					
		            <g:form action="save" name="productCreate">
		                <div class="dialog">
		                    <table>
		                        <tbody>
		                        	<tr class="prop">
		                                <td valign="top" class="name">
		                                    <label for="product_id"><g:message code="product.product_id.label" default="Product Id" /></label><em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: productInstance, field: 'product_id', 'errors')}">
		                                    <g:textField name="product_id" value="${productInstance?.product_id}" class="required" number="true" />
		                                </td>
		                            </tr>
		                        	
		                        	<tr class="prop">
		                                <td valign="top" class="name">
		                                    <label for="productName"><g:message code="product.productName.label" default="Product Name" /></label><em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: productInstance, field: 'productName', 'errors')}">
		                                    <g:textField name="productName" value="${productInstance?.productName}" class="required"/>
		                                </td>
		                            </tr>
									<tr class="prop">
		                                <td valign="top" class="name">
		                                    <label for="productType"><g:message code="product.productType.label" default="Product Type" /></label>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: productInstance, field: 'productType', 'errors')}">
		                                    <g:textField name="productType" value="${productInstance?.productType}" />
		                                </td>
		                            </tr>
		
		                            
		
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                    <label for="datePublished"><g:message code="product.datePublished.label" default="Date Published" /></label>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: productInstance, field: 'datePublished', 'errors')}">
		                                	<g:textField name="datePublished" value="${productInstance?.datePublished}"/>
		                                </td>
		                            </tr>
		                        
		                        </tbody>
		                    </table>
		                </div>
		                <div class="buttons">
		                    <span class="button"><g:submitButton title="Save Product" name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" /></span>
		                </div>
		            </g:form>
			
				</div>
			</div>
		</div>
        
    </body>
</html>
