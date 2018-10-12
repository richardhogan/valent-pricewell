<%@ page import="com.valent.pricewell.Opportunity" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
       <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'opportunity.label', default: 'Opportunity')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
        
        <style type="text/css">
			.submit { margin-left: 12em; }
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
		</style>
		
		<r:script>
				  jQuery(document).ready(function()
				  {				 
				    jQuery("#opportunityEdit").validate();
				    
				    jQuery( "#closeDate" ).datepicker({
						dateFormat: "dd-mm-yy",
						changeMonth: true,
						changeYear: true,
						showOn: "button",
						buttonImage: "${baseurl}/images/calendar.gif",
						buttonImageOnly: true
					});
				  });
				  
  		</r:script>
        
        
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a HREF="javascript:history.go(-1)" title="Go Back">Back</a><span>
            <span class="menuButton"><g:link class="list" action="list" title="List Of Opportunities"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span class="menuButton"><g:link class="create" action="create" title="Create Opportunity"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h2><g:message code="default.edit.label" args="[entityName]" /></h2><hr>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
          <!--   <g:hasErrors bean="${opportunityInstance}">
            <div class="errors">
                <g:renderErrors bean="${opportunityInstance}" as="list" />
            </div>
            </g:hasErrors>-->
            <g:form method="post" name="" >
                <g:hiddenField name="id" value="${opportunityInstance?.id}" />
                <g:hiddenField name="version" value="${opportunityInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="name"><g:message code="opportunity.name.label" default="Opportunity Name" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: opportunityInstance, field: 'name', 'errors')}">
                                    <g:textField name="name" value="${opportunityInstance?.name}" class="required" />
                                </td>
                                
                                <td>&nbsp;&nbsp;</td>
                                
                                <td valign="top" class="name">
                                    <label for="assignTo"><g:message code="opportunity.assignTo.label" default="Assign To" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: opportunityInstance, field: 'assignTo', 'errors')}">
                                    <g:select name="assignToId" from="${salesUsers?.sort {it.profile.fullName}}" value="${opportunityInstance?.assignTo?.id}" optionKey="id" />
                                </td>
                                
                                <td>&nbsp;&nbsp;</td>
                                
                                <td valign="top" class="name">
                                    <label for="geo"><g:message code="opportunity.geo.label" default="Geo" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: opportunityInstance, field: 'geo', 'errors')}">
                                    <g:select name="geoId" from="${com.valent.pricewell.Geo.list()}" optionKey="id" value="${opportunityInstance?.geo?.id}" noSelection="['': 'Select any one']" class="required"/>
                                </td>
                            </tr>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="account"><g:message code="opportunity.account.label" default="Account" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: opportunityInstance, field: 'account?.accountName', 'errors')}">
                                    <g:textField name="accountName" value="${opportunityInstance?.account?.accountName}" readonly="true"/>
                                </td>
                            </tr>
					</tbody>
                 </table><hr>
                 <table>
                 	<tbody>
                            </tr class="prop">    
                                <td valign="top" class="name">
                                    <label for="closeDate"><g:message code="opportunity.closeDate.label" default="Close Date" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: opportunityInstance, field: 'closeDate', 'errors')}">
                                    <input type="text" id="closeDate" name="closeDate" value="${opportunityInstance?.closeDate}">
                                </td>
                                
                                <td>&nbsp;&nbsp;</td>
                                
                                <td valign="top" class="name">
                                    <label for="probability"><g:message code="opportunity.probability.label" default="Probability(%)" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: opportunityInstance, field: 'probability', 'errors')}">
                                    <g:textField name="probability" value="${opportunityInstance?.probability}" number="true" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="amount"><g:message code="opportunity.amount.label" default="Amount" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: opportunityInstance, field: 'amount', 'errors')}">
                                    <g:textField name="amount" value="${fieldValue(bean: opportunityInstance, field: 'amount')}" number="true" />
                                </td>
                                
                                <td>&nbsp;&nbsp;</td>
                                
                                <td valign="top" class="name">
                                    <label for="discount"><g:message code="opportunity.discount.label" default="Discount(%)" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: opportunityInstance, field: 'discount', 'errors')}">
                                    <g:textField name="discount" value="${fieldValue(bean: opportunityInstance, field: 'discount')}" number="true" />
                                </td>
                            </tr>
                        
                           
                            
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit title="Update Opportunity" class="save" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}" /></span>
                    <span class="button"><g:actionSubmit title="Delete Opportunity" class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
