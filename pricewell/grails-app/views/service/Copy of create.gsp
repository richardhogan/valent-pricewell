<%@ page import="com.valent.pricewell.Service" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'service.label', default: 'Service')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
		<g:javascript library="jquery" plugin="jquery"/>
		 <script src="${baseurl}/js/jquery.validate.js"></script>
		<script>
		 (function($) {
			  $(document).ready(function(){
				
			    $("#service").validate();
			  });   
		 })(jQuery);
  </script>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.create.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${serviceInstance}">
            <div class="errors">
                <g:renderErrors bean="${serviceInstance}" as="list" />
            </div>
            </g:hasErrors>
 <form class="cmxform" id="service" action="${baseurl}/service/save/serviceCreate" method="post">
                <div class="dialog">
                    <table>
                        <tbody>
                        	<tr class="prop">
                                <td valign="top" class="name">
                                    <label for="portfolio"><g:message code="service.portfolio.label" default="Portfolio" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceInstance, field: 'portfolio', 'errors')}">
                                    <g:select name="portfolio.id" from="${com.valent.pricewell.Portfolio.list()}" optionKey="id" value="${serviceInstance?.portfolio?.id}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="serviceName"><g:message code="service.serviceName.label" default="Service Name" /></label>
                                    <em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceInstance, field: 'serviceName', 'errors')}">
                                    <g:textField name="serviceName" value="${serviceInstance?.serviceName}" class="required"/>
                                    
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="skuName"><g:message code="service.skuName.label" default="Sku Name" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceInstance, field: 'skuName', 'errors')}">
                                    <g:textField name="skuName" value="${serviceInstance?.skuName}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="description"><g:message code="service.description.label" default="Description" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceInstance, field: 'description', 'errors')}">
                                    <g:textArea name="description" value="${serviceInstance?.description}" rows="5" cols="40"/>
                                </td>
                            </tr>
                        	
                        	 <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="unitOfSale"><g:message code="serviceProfile.unitOfSale.label" default="Unit Of Sale" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileInstance, field: 'unitOfSale', 'errors')}">
                                    <g:textField name="unitOfSale" value="${serviceProfileInstance?.unitOfSale}" />
                                </td>
                            </tr>
                            
                             <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="baseUnits"><g:message code="serviceProfile.baseUnits.label" default="Base Units" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileInstance, field: 'baseUnits', 'errors')}">
                                    <g:textField name="baseUnits" value="${fieldValue(bean: serviceProfileInstance, field: 'baseUnits')}" />
                                </td>
                            </tr>
                           	  <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="totalEstimateInHoursFlat"><g:message code="serviceProfile.totalEstimateInHoursFlat.label" default="Total Estimate In Hours (Flat)" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileInstance, field: 'totalEstimateInHours', 'errors')}">
                                    <g:textField name="totalEstimateInHoursFlat" value="${fieldValue(bean: serviceProfileInstance, field: 'totalEstimateInHoursFlat')}" />
                                </td>
                           	 </tr>
                        
					<tr class="prop">
                                <td valign="top" class="name">
                                    <label for="totalEstimateInHoursPerBaseUnits"><g:message code="serviceProfile.totalEstimateInHoursPerBaseUnits.label" default="Additional Time In Hours (Per Unit)" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileInstance, field: 'totalEstimateInHours', 'errors')}">
                                    <g:textField name="totalEstimateInHoursPerBaseUnits" value="${fieldValue(bean: serviceProfileInstance, field: 'totalEstimateInHoursPerBaseUnits')}" />
                                </td>
                            </tr>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="tags">Search tags</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceInstance, field: 'tags', 'errors')}">
                                    <g:textField name="tags" value="${serviceInstance?.tags}" />
                                </td>
                            </tr>
                            
                             <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="productManager"><g:message code="service.productManager.label" default="Product Manager" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceInstance, field: 'productManager', 'errors')}">
                                    <g:select name="productManager.id" from="${productManagerList}" optionKey="id" value="${serviceInstance?.productManager?.id}"  />
                                </td>
                            </tr>
                        	
                        	<tr class="prop">
                                <td valign="top" class="name">
                                    <label for="otherProductManagers"><g:message code="service.otherProductManagers.label" default="Other Product Manager" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceInstance, field: 'otherProductManager', 'errors')}">
                                    <g:select name="otherProductManagers.id" from="${productManagerList}" optionKey="id" value="${serviceInstance?.otherProductManagers?.id}"  />
                                </td>
                            </tr>
                            
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                	
                    <span class="button"><g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" /></span>
                </div>
            </form>
        </div>
    </body>
</html>
