<%@ page import="com.valent.pricewell.ServiceProductItem" %>
<%
	def baseurl = request.siteUrl
%>
    <head>
    	<style type="text/css">
			.submit { margin-left: 12em; }
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
			
			.select{
    			height:50px;
    			overflow:scroll;
}
		</style>
		
		<g:setProvider library="prototype"/>
		<script>
			jQuery(document).ready(function()
			{
				jQuery("#productCreate").validate();

				jQuery("#productCreate input:text")[0].focus();
				
				jQuery(".btnCreateProductItem").click(function()
				{
					if(jQuery('#productCreate').validate().form())
					{
						showLoadingBox();
				    	jQuery.ajax(
						{
							type: "POST",
							url: "${baseurl}/serviceProductItem/saveFromService",
							data: jQuery("#productCreate").serialize(),
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
					
					return false;
				}); 
				
				jQuery("#product").change(function() 
				{
					jQuery('#product\\.id').val(jQuery('#product option:selected').val());
					return false;			        
			    });
			});

			function serviceProductItemList()
			{
				jQuery.ajax({
					type: "POST",
					url: "${baseurl}/serviceProductItem/listServiceProducts",
					data: {'serviceProfileId': ${serviceProfileId}},
					success: function(data){jQuery("#mainProductsRequiredTab").html(data);}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
				});
				
				return false;
			}
		</script>
	</head>  
    
<div class="nav">
    <span >
    	<!--<g:remoteLink class="buttons.button button" controller="serviceProductItem"  title="List Of Products Required"
    							action="listServiceProducts" params="['serviceProfileId': serviceProfileId]"  
    							update="[success:'mainProductsRequiredTab',failure:'mainProductsRequiredTab']" >
    								List Of Products Required
    							</g:remoteLink>-->
    							
    	<a id="idServiceProductItemList" onclick="serviceProductItemList();" class="buttons.button button" title="List Of Products Required">List of Products Required</a>							
    </span>
</div>

<!--<div id="waiting">
	<p> Loading ....</p>
</div>-->

<div id="doneLoading" class="body">
            
	          <g:if test="${flash.message}">
	          	<!--div class="message">${flash.message}</div-->
	          </g:if>
	          <g:hasErrors bean="${serviceProductItemInstance}">
	          <div class="errors">
	              <g:renderErrors bean="${serviceProductItemInstance}" as="list" />
	          </div>
	          </g:hasErrors>
	          <g:form action="saveFromService" name="productCreate">        
	          <g:hiddenField name="serviceProfileId" value="${serviceProfileId}"></g:hiddenField>
	              <div class="dialog">
	                  <table>
	                      <tbody>
	                      
	                          <tr class="prop">
	                              <td valign="top" class="name">
	                                  <label for="product"><g:message code="serviceProductItem.product.label" default="Product" /></label>
	                              	  
	                              </td>
	                              <td valign="top" class="value ${hasErrors(bean: serviceProductItemInstance, field: 'product', 'errors')}">
									<g:select name="product" from="${productList}" value="" optionValue="productName" optionKey="id" class="required" noSelection="['':'-Select Any One-']"/>
									<g:hiddenField name="product.id" value="" class="required"/>
									<!--<div id="productSelect"></div>-->  
	                              </td>
	                          </tr>
	                      
	                                       
	                          <tr class="prop">
	                              <td valign="top" class="name">
	                                  <label for="unitsSoldRatePerAdditionalUnit"><g:message code="serviceProductItem.unitsSoldRatePerAdditionalUnit.label" default="Product Sold per Service Unit" /></label>
	                              		
	                              </td>
	                              <td valign="top" class="value ${hasErrors(bean: serviceProductItemInstance, field: 'unitsSoldRatePerAdditionalUnit', 'errors')}">
	                                  <g:textField name="unitsSoldRatePerAdditionalUnit" id="unitsSoldRatePerAdditionalUnit" value="${fieldValue(bean: serviceProductItemInstance, field: 'unitsSoldRatePerAdditionalUnit')}"  class="required" number="true"/>
	                              </td>
	                          </tr>
	                      
	                      </tbody>
	                  </table>
	                 
	              </div>
				<div class="buttons">
				
                    <span class="button">
                    	<button id="btnCreateProductItem" class="btnCreateProductItem" title="Save Product">Create</button>
                   	</span>
                    	
                </div>
          </g:form>
</div>
