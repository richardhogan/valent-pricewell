<%@ page import="com.valent.pricewell.Service" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
		<script>

		 jQuery(document).ready(function(){
			 	jQuery.getScript("${baseurl}/js/jquery.validate.js", function() {

			 		jQuery("#serviceEdit").validate(
						    {
			  					rules: 
			  					{
			    					premiumPercent: 
			    					{
			      						number: true	
			    					},
			    					baseUnits:
			    					{
			    						number: true
			    					}
			  					}
							});
			 	});
			 	
			 });
		
		 
  </script>
    </head>
    <body>
        
        <div class="body">
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${serviceInstance}">
            <div class="errors">
                <g:renderErrors bean="${serviceInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="update" name="serviceEdit">
            	<g:hiddenField name="id" value="${serviceProfileInstance?.id}" />
                <g:hiddenField name="version" value="${serviceProfileInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        	
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="serviceName"><g:message code="service.serviceName.label" default="Service Name" /></label>
                                	<em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileInstance, field: 'service.serviceName', 'errors')}">
                                    <g:textField name="serviceName" value="${serviceProfileInstance?.service?.serviceName}" class="required" minlength="4" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="skuName"><g:message code="service.skuName.label" default="Sku Name" /></label>
                                	<em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileInstance, field: 'service.skuName', 'errors')}">
                                    <g:textField name="skuName" value="${serviceProfileInstance?.service?.skuName}" class="required" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="description"><g:message code="service.description.label" default="Description" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileInstance, field: 'service.description', 'errors')}">
                                    <g:textArea name="description" value="${serviceProfileInstance?.service?.serviceDescription?.value}" rows="5" cols="40"/>
                                </td>
                            </tr>
                        	
                        	 <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="unitOfSale"><g:message code="serviceProfile.unitOfSale.label" default="Unit Of Sale" /></label>
                               		<em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileInstance, field: 'unitOfSale', 'errors')}">
                                    <g:textField name="unitOfSale" value="${serviceProfileInstance?.unitOfSale}" class="required" />
                                </td>
                            </tr>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="baseUnits"><g:message code="serviceProfile.baseUnits.label" default="Base Units" /></label>
                                    <em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileInstance, field: 'baseUnits', 'errors')}">
                                    <g:textField name="baseUnits" id="baseUnits" value="${fieldValue(bean: serviceProfileInstance, field: 'baseUnits')}" class="required number"/>
                                </td>
                            </tr>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="totalEstimateInHoursFlat"><g:message code="serviceProfile.totalEstimateInHoursFlat.label" default="totalEstimateInHoursFlat" /></label>
                                    <em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileInstance, field: 'totalEstimateInHoursFlat', 'errors')}">
                                    <g:textField name="totalEstimateInHoursFlat" id="totalEstimateInHoursFlat" value="${fieldValue(bean: serviceProfileInstance, field: 'totalEstimateInHoursFlat')}" />
                                </td>
                            </tr>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="totalEstimateInHoursPerBaseUnits"><g:message code="serviceProfile.totalEstimateInHoursPerBaseUnits.label" default="totalEstimateInHoursPerBaseUnits" /></label>
                                    <em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileInstance, field: 'totalEstimateInHoursPerBaseUnits', 'errors')}">
                                    <g:textField name="totalEstimateInHoursPerBaseUnits" id="totalEstimateInHoursPerBaseUnits" value="${fieldValue(bean: serviceProfileInstance, field: 'totalEstimateInHoursPerBaseUnits')}" class="required number"/>
                                </td>
                            </tr>
                            
                            
                            
                                                   
	                        <tr class="prop">
	                        	<td valign="top" class="name">
                                    <label for="premiumPercent"><g:message code="serviceProfile.premiumPercent.label" default="Premium Percentage" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileInstance, field: 'totalEstimateInHours', 'errors')}">
                                    <g:textField name="premiumPercent" id="premiumPercent" value="${fieldValue(bean: serviceProfileInstance, field: 'premiumPercent')}" />
                                </td>
	                        </tr>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="tags">Search tags</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceInstance, field: 'tags', 'errors')}">
                                    <g:textField name="tags" value="${serviceProfileInstance?.service?.tags}" />
                                </td>
                            </tr>
                            
                            <g:if test="${createPermitted}">
	                             <tr class="prop">
	                                <td valign="top" class="name">
	                                    <label for="productManager"><g:message code="service.productManager.label" default="Product Manager" /></label>
	                                </td>
	                                <td valign="top" class="value ${hasErrors(bean: serviceInstance, field: 'productManager', 'errors')}">
	                                    <g:select name="productManager.id" from="${productManagerList}" optionKey="id" value="${serviceProfileInstance?.service?.productManager?.id}"  />
	                                </td>
	                            </tr>
                            </g:if>
                        	
                            <g:if
							test="${serviceProfileInstance?.stagingStatus?.sequenceOrder >= 20}">
	                        	<tr class="prop">
	                                <td valign="top" class="name">
	                                  <label for="serviceDesignerLead"><g:message code="serviceProfile.serviceDesignerLead.label" default="Service Designer Lead" /></label>
	                                </td>
	                                <td valign="top" class="value ${hasErrors(bean: serviceProfileInstance, field: 'serviceDesignerLead', 'errors')}">
	                                    <g:select name="serviceDesignerLead.id" from="${designerList}" optionKey="id" value="${serviceProfileInstance?.serviceDesignerLead?.id}" />
	                                </td>
	                            </tr>
	                          </g:if>
                            
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button">
                    	
                    <g:submitButton controller="service" title="Update Service" action="update" name="update"  params="['serviceProfileId': serviceProfileInstance.id]" class="update" value="${message(code: 'default.button.update.label', default: 'Update')}"/></span>
                    <input type="button"  value="Cancel" title="Cancel" onclick="location.href='${baseurl}/service/show?serviceProfileId=${serviceProfileInstance.id}'"/>
                </div>
            </g:form>
        </div>
    </body>
</html>
