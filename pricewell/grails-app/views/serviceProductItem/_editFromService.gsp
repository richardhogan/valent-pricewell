<%@ page import="com.valent.pricewell.ServiceProductItem" %>
<%
	def baseurl = request.siteUrl
%>
	<head>
    	<style type="text/css">
			.submit { margin-left: 12em; }
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
		</style>
		
		<g:setProvider library="prototype"/>
		<script>
			
			jQuery(document).ready(function()
			{
				jQuery("#productEdit").validate(
			    {
				});

				jQuery("#productEdit input:text")[0].focus();
				
				jQuery(".btnEditProductItem").click(function()
				{
					if(jQuery('#productEdit').validate().form())
					{
						showLoadingBox();
				    	jQuery.ajax(
						{
							type: "POST",
							url: "${baseurl}/serviceProductItem/updateFromService",
							data: jQuery("#productEdit").serialize(),
							success: function(data)
							{
								hideLoadingBox();
								jQuery('#mainProductsRequiredTab').html(data);
								
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){
								alert("Error while saving");
							}
						});
					}
					
					return false;
				}); 
				
				
			});

			function serviceProductItemList()
			{
				jQuery.ajax({
					type: "POST",
					url: "${baseurl}/serviceProductItem/listServiceProducts",
					data: {'serviceProfileId': ${serviceProductItemInstance?.serviceProfile?.id}},
					success: function(data){jQuery("#mainProductsRequiredTab").html(data);}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
				});
				
				return false;
			}
		</script>
	</head>  
    
	<div class="nav">
	    <span >
	    
	    	<!--<g:remoteLink class="buttons.button button" controller="serviceProductItem" title="List Of Products Required"
				action="listServiceProducts" params="['serviceProfileId': serviceProductItemInstance?.serviceProfile?.id]"  
				update="[success:'mainProductsRequiredTab',failure:'mainProductsRequiredTab']">
					List Of Products Required
				</g:remoteLink>-->
				
			<a id="idServiceProductItemList" onclick="serviceProductItemList();" class="buttons.button button" title="List Of Products Required">List of Products Required</a>
		</span>
	</div>

	<div class="body">
            
	          <g:if test="${flash.message}">
	          	<!--div class="message">${flash.message}</div-->
	          </g:if>
	          <g:hasErrors bean="${serviceProductItemInstance}">
	          <div class="errors">
	              <g:renderErrors bean="${serviceProductItemInstance}" as="list" />
	          </div>
	          </g:hasErrors>
	          <g:form action="updateFromService" name="productEdit">
	              <div class="dialog">
	                  <table>
	                      <tbody>
	                      	<g:hiddenField name="id" value="${serviceProductItemInstance?.id}" />
              				  <g:hiddenField name="version" value="${serviceProductItemInstance?.version}" />
	                          <tr class="prop">
	                              <td valign="top" class="name">
	                                  <label for="product"><g:message code="serviceProductItem.product.label" default="Product" /></label>
	                              	  
	                              </td>
	                              <td valign="top" class="value ${hasErrors(bean: serviceProductItemInstance, field: 'product', 'errors')}">
									<span> ${serviceProductItemInstance?.product.productName} </span>
	                              </td>
	                          </tr>

	                          <tr class="prop">
	                              <td valign="top" class="name">
	                                  <label for="unitsSoldRatePerAdditionalUnit"><g:message code="serviceProductItem.unitsSoldRatePerAdditionalUnit.label" default="Product Units sold per Unit" /></label>
	                              		
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
                    	<button id="btnEditProductItem" class="btnEditProductItem" title="Updare Product">Update</button>
                   	</span>
                </div>
          </g:form>
	</div>