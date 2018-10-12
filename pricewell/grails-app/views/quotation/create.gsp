<%@ page import="com.valent.pricewell.Quotation" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'quotation.label', default: 'Quotation')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
        
        <g:javascript library="jquery" plugin="jquery"/>
		 <script src="${baseurl}/js/jquery.validate.js"></script>
		  <script src="${baseurl}/js/tinytable.js"></script>
		<link rel="stylesheet" href="${resource(dir:'css',file:'tinytable.css')}" />
		<script>
		 (function($) {
			  $(document).ready(function()
			  {				 
			    $("#quotationCreate").validate();
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
            <g:hasErrors bean="${quotationInstance}">
            <div class="errors">
                <g:renderErrors bean="${quotationInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" name="quotationCreate">
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="account"><g:message code="quotation.account.label" default="Account" /></label>
                                	<em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: quotationInstance, field: 'account', 'errors')}">
                                	<g:select name="account.id" from="${accountsList}" optionKey="id" value="${quotationInstance?.account?.id}"  />
                                	<% def fields =  ["accountName":"Account Name", "website": "Website", "dateCreated": "Date Created"]; %>
									<g:popupSelect id="accounts" title="Select Account" list="${accountsList}" fields="${fields}" returnObject="account.id"></g:popupSelect>
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="customerType"><g:message code="quotation.customerType.label" default="Customer Type" /></label>
                                	<em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: quotationInstance, field: 'customerType', 'errors')}">
                                    <g:textField name="customerType" value="${quotationInstance?.customerType}" class="required"/>
                                </td>
                            </tr>
                        
                        
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="geo"><g:message code="quotation.geo.label" default="Geo" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: quotationInstance, field: 'geo', 'errors')}">
                                    <g:select name="geo.id" from="${com.valent.pricewell.Geo.list()}" optionKey="id" value="${quotationInstance?.geo?.id}" noSelection="['': 'Select any one']" class="required" />
                                </td>
                            </tr>
                        
                          
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="status"><g:message code="quotation.status.label" default="Status" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: quotationInstance, field: 'status', 'errors')}">
                                    <g:select name="status" from="${com.valent.pricewell.Quotation$Status?.values()}" keys="${com.valent.pricewell.Quotation$Status?.values()*.name()}" value="${quotationInstance?.status?.name()}"  />
                                </td>
                            </tr>
                        

                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
