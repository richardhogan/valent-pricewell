<%@ page import="com.valent.pricewell.Product" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'product.label', default: 'Product')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
        <calendar:resources lang="en" theme="tiger"/>
        <script>
	        jQuery(document).ready(function()
   			 {
  				 	jQuery("#productEdit").validate();
  				 	jQuery("#productEdit input:text")[0].focus();
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
            <span><g:link class="buttons.button button" title="Create Product" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
			<div class="collapsibleContainer">
				<div class="collapsibleContainerTitle ui-widget-header">
					<div>
						<b>Edit </b> ${entityName} ${productInstance?.productName}
					</div>
				</div>
			
				<div class="collapsibleContainerContent ui-widget-content">
				
					<g:form method="post" name="productEdit">
		                <g:hiddenField name="id" value="${productInstance?.id}" />
		                <g:hiddenField name="version" value="${productInstance?.version}" />
		                <div class="dialog">
		                    <table>
		                        <tbody>
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
		                                  <label for="product_id"><g:message code="product.product_id.label" default="Product Id" /></label>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: productInstance, field: 'product_id', 'errors')}">
		                                    <g:textField name="product_id" value="${productInstance?.product_id}" />
		                                </td>
		                            </tr>
		                        
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                  <label for="datePublished"><g:message code="product.datePublished.label" default="Date Published" /></label>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: productInstance, field: 'datePublished', 'errors')}">

		                                   <g:textField name="datePublished" value="${g.formatDate(format: 'MM/dd/yyyy', date: productInstance?.datePublished)}" />

		                                </td>
		                            </tr>
		                        
		                        </tbody>
		                    </table>
		                </div>
		                <div class="buttons">
		                    <span class="button"><g:actionSubmit title="Update Product" class="save" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}" /></span>
		                    <span class="button"><g:actionSubmit title="Delete Product" class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
		                </div>
		            </g:form>

			
				</div>
			</div>
		</div>
	
        <div class="body">
            
        </div>
    </body>
</html>
