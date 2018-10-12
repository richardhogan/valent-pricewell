<%@ page import="com.valent.pricewell.Service" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'service.label', default: 'Service')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
        <g:javascript library="jquery" plugin="jquery"/>
		 <script src="${baseurl}/js/jquery.validate.js"></script>
		<script>
		 	jQuery(document).ready(function()
			{				 
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

			    jQuery("#serviceEdit input:text")[0].focus();
			  
			  /*$(document).ready(function()
			  {
    			$("input:blank").css("background-color", "#bbbbff");
  			  });*/ 
		 });
  </script>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.edit.label" args="[entityName]" /></h1>
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
                                    <g:textArea name="description" value="${serviceProfileInstance?.service?.description}" rows="5" cols="40"/>
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
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileInstance, field: 'baseUnits', 'errors')}">
                                    <g:textField name="baseUnits" id="baseUnits" value="${fieldValue(bean: serviceProfileInstance, field: 'baseUnits')}" />
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
                            
                             <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="productManager"><g:message code="service.productManager.label" default="Product Manager" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceInstance, field: 'productManager', 'errors')}">
                                    <g:select name="productManager.id" from="${productManagerList}" optionKey="id" value="${serviceProfileInstance?.service?.productManager?.id}"  />
                                </td>
                            </tr>
                        
                        	<tr class="prop">
                                <td valign="top" class="name">
                                    <label for="otherProductManagers"><g:message code="service.otherProductManagers.label" default="Other Product Managers" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceInstance, field: 'otherProductManagers', 'errors')}">
                                    <g:select name="otherProductManagers.id" from="${productManagerList}" optionKey="id" value="${serviceProfileInstance?.service?.otherProductManagers?.id}" />
                                </td>
                            </tr>
                            
                        	<tr class="prop">
                                <td valign="top" class="name">
                                  <label for="serviceDesignerLead"><g:message code="serviceProfile.serviceDesignerLead.label" default="Service Designer Lead" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileInstance, field: 'serviceDesignerLead', 'errors')}">
                                    <g:select name="serviceDesignerLead.id" from="${designerList}" optionKey="id" value="${serviceProfileInstance?.serviceDesignerLead?.id}" />
                                </td>
                            </tr>
                            
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:submitButton title="Update Service" action="update" name="update"  params="[serviceProfileId: serviceProfileInstance.id]" class="update" value="${message(code: 'default.button.update.label', default: 'Update')}" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
