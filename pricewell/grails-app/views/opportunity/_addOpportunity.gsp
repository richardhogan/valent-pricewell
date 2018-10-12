<%@ page import="com.valent.pricewell.Opportunity" %>
<%@ page import="com.valent.pricewell.SalesController" %>
<%@ page import="org.apache.shiro.SecurityUtils"%>
<%@ page import="com.valent.pricewell.Geo" %>
<%@ page import="com.valent.pricewell.User" %>
<%
	def baseurl = request.siteUrl
	def loginUser = User.get(new Long(SecurityUtils.subject.principal))
	def primaryTerritory = null
	if(loginUser?.primaryTerritory!=null && loginUser?.primaryTerritory!='null' && loginUser?.primaryTerritory!='NULL')
	{
		primaryTerritory = Geo.get(loginUser?.primaryTerritory?.id)
	}
%>
<html>
    <head>
    	
		 <g:set var="entityName" value="${message(code: 'opportunity.label', default: 'Opportunity')}" />
		 <style type="text/css">
			.submit { margin-left: 12em; }
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
		</style>
		
		<g:setProvider library="prototype"/>
		<script>
			 
				  jQuery(document).ready(function()
				  {				 
				  		jQuery.validator.addMethod("nameField",function(value,element)
						{
							return this.optional(element) || /^[A-Za-z0-9\s]{6,16}$/i.test(value); 
						},"Name is of 6-16 characters");
						
				    	jQuery("#opportunityCreate").validate({
				    	  rules: {
				    		  amount: {
					    		  number: true,
					    		  pattern: /^(\d+|\d+,\d{1,2})$/
				    		    }
				    		},
				    	    messages: {
				    	        amount: {
				    	            pattern: 'Please specify the correct number format'
				    	        }
				    	    }
				    	});
				    	
				    	jQuery("#opportunityCreate input:text")[0].focus();
				    	
				    	jQuery( "#closeDate" ).datepicker({
				    		showOn: "button",
			    	        buttonImage: "${baseurl}/images/calendar.gif",
			    	        showWeek: true,
	      					firstDay: 1,
			    	        minDate: 1,
			    	        buttonImageOnly: true,
			    	        zindex: 1000
					    });

				    	jQuery("#assignToId").change(function() 
				    	{
				    	 
						  	jQuery.ajax({type:'POST',data: {id: this.value },
								 url:'${baseurl}/commonSales/getUserTerritories',
								 success:function(data,textStatus){jQuery('#userTerritoryList').html(data);},
								 error:function(XMLHttpRequest,textStatus,errorThrown){}});
								 
							return false;
						  
						});
				    	
				    	jQuery("#territoryId").change(function() 
				    	{
				    	 
						  	jQuery.ajax({type:'POST',data: {id: this.value },
								 url:'${baseurl}/geo/getCurrencySymbol',
								 success:function(data,textStatus){jQuery('#currencySymbol').html(data);},
								 error:function(XMLHttpRequest,textStatus,errorThrown){}});

						  	jQuery.ajax({type:'POST',data: {id: this.value },
								 url:'${baseurl}/geo/getDateFormat',
								 success:function(data,textStatus)
								 {
								 	if(data != '' && data != null)
								 		{jQuery( "#closeDate" ).datepicker( "option", "dateFormat", data );}
								 	else
								 		{jQuery( "#closeDate" ).datepicker( "option", "dateFormat", "mm/dd/yy" );}
							 	 },
								 error:function(XMLHttpRequest,textStatus,errorThrown){}});
							 
							return false;
						  
						});
				    	
				    	
				  });
				  
				  
			
  		</script>
        
        
    </head>
    <body>
        
        <div class="body">
            <h2><g:message code="default.create.label" args="[entityName]" /></h2><hr>
            <g:if test="${flash.message}">
            	<div class="message">${flash.message}</div>
            </g:if>
         
            <g:form action="save" controller="opportunity" name="opportunityCreate">
                <div class="dialog">
                    <g:hiddenField name="accountId" value="${accountId}"></g:hiddenField>
                	<g:hiddenField name="createdFrom" value="${createdFrom}"></g:hiddenField>
                	<g:if test="${leadInstance?.id}">
                		<g:hiddenField name="leadId" value="${leadInstance?.id}"></g:hiddenField>
                	</g:if>
                    
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
                                	<g:select name="assignToId" from="${new SalesController().generateAssignedToListForNewObject()}" value="" noSelection="['': 'Select Any One']" class="required"/>
                                </td>
                                
                                <td>&nbsp;&nbsp;</td>
                                
                                <td valign="top" class="name">
                                    <label for="geo"><g:message code="default.geo.label" default="Geo" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: opportunityInstance, field: 'geo', 'errors')}">
                                	<div id="userTerritoryList">
                                    	<g:select name="territoryId" from="${territoryList?.sort {it.name}}" optionKey="id" value="${primaryTerritory?.id}" class="required" noSelection="['':'Select Any One']" />
                                   	</div>
                                </td>
                            
                            </tr>
	                            <g:if test="${leadInstance?.contact?.account?.id}">
		                            <tr>
		                            	<td valign="top" class="name">
		                                    <label for="name">Account Name</label><em>*</em>
		                                </td>
		                                <td valign="top">
		                                	<g:textField name="accountName" value="${leadInstance?.contact?.account?.accountName}" readonly="true"/>
		                                    <g:hiddenField name="accountIdFromLead" value="${leadInstance?.contact?.account?.id}"></g:hiddenField>
		                                </td>
		                            </tr>
	                            </g:if>
	                            
	                            <g:else>
	                            	<tr>
		                            	<td valign="top" class="name">
		                                    <label for="name">Select Contact</label><em>*</em>
		                                </td>
		                                <td valign="top">
		                                    <g:select name="contactId" from="${contactList}" optionKey="id" value=""  noSelection="['': 'Select Any One']" class="required"/>
		                                	
		                                </td>
		                            </tr>
	                            </g:else>
                    </tbody>
                 </table>
                 <hr>
                 <table>
                 	<tbody>
                        </tr class="prop">    
                            <td valign="top" class="name">
                                <label for="closeDate"><g:message code="opportunity.closeDate.label" default="Close Date" /></label><em>*</em>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: opportunityInstance, field: 'closeDate', 'errors')}">
                                 <g:textField name="closeDate" class="required" />
                            </td>
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name">
                                <label for="probability"><g:message code="opportunity.probability.label" default="Probability(%)" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: opportunityInstance, field: 'probability', 'errors')}">
                                <g:textField name="probability" value="0" number="true" />
                            </td>
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">
                                <label for="amount"><g:message code="opportunity.amount.label" default="Amount" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: opportunityInstance, field: 'amount', 'errors')}">
                                <table>
                               		<tr>
                               			<td><div id="currencySymbol"></div></td>
                               			<td><g:textField name="amount" value="0" number="true" /></td>
                               		</tr>
                               	</table>
                            </td>
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name">
                                <label for="discount"><g:message code="opportunity.discount.label" default="Discount(%)" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: opportunityInstance, field: 'discount', 'errors')}">
                                <g:textField name="discount" value="0" number="true" />
                            </td>
                        </tr>
                    
                       
                        
                    </tbody>
                </table>
                </div>
                <g:if test="${leadInstance?.id == null}">
	                <div class="buttons">
	                     <span class="button"><g:submitButton name="create" title="Save Opportunity" class="save" action="save" controller="opportunity" value="Add" /></span>
	                </div>
                </g:if>
            </g:form>
        </div>
    </body>
</html>
		 