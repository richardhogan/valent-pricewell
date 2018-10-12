
<%@ page import="org.apache.shiro.SecurityUtils"%>
<%@ page import="com.valent.pricewell.Opportunity" %>
<%@ page import="com.valent.pricewell.Geo" %>
<%@ page import="com.valent.pricewell.User" %>
<%@ page import="com.valent.pricewell.SalesController" %>
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
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'opportunity.label', default: 'Opportunity')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
        
        <style type="text/css">
			.submit { margin-left: 12em; }
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
		</style>
		
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
			    	
			    	jQuery( "#dvNewContact" ).dialog(
					{
						height: 700, width: 960,
						modal: true,
						autoOpen: false,
						close: function( event, ui ) {
							jQuery(this).html('');
						}
						
					});
					
					jQuery( "#newContact" ).click(function() 
					{
						if(jQuery("#accountId").val())
						{	
							jQuery("#dvNewContact").dialog( "option", "title", 'Create Contact' );
							jQuery('#dvNewContact').html("Loading Data, Please Wait.....");
							jQuery("#dvNewContact").dialog( "open" );
							jQuery.ajax({type:'POST',
								 url:'${baseurl}/contact/addContactFromOpportunity',
								 data: {sourceFrom: "opportunity", accountId: jQuery("#accountId").val()},
								 success:function(data,textStatus)
								 {
									 jQuery('#dvNewContact').html(data);
									 
								},
								 error:function(XMLHttpRequest,textStatus,errorThrown){}});
						}
						else
						{
							jAlert('Select account first.', 'Alert Message');
						}
						return false;
					});
					
			    	jQuery( "#closeDate" ).datepicker({
			    		showOn: "button",
		    	        buttonImage: "${baseurl}/images/calendar.gif",
		    	        showWeek: true,
      					firstDay: 1,
		    	        minDate: 1,
		    	        buttonImageOnly: true
				    });

			    	jQuery( "#successDialog_1" ).dialog(
				 	{
						modal: true,
						autoOpen: false,
						resizable: false,
						buttons: 
						{
							OK: function() 
							{
								jQuery( "#successDialog_1" ).dialog( "close" );
								return false;
							}
						}
					});

			    	jQuery("#assignToId").change(function() 
			    	{
					  	getUserTerritories(this.value);
						return false;
					  
					});

			    	jQuery("#territoryId").change(function() 
			    	{
			    		getCurrencySymbol(this.value);
			    		getDateFormat(this.value);
						return false;
					  
					});

			    	jQuery("#accountId").change(function () 
			    	{
			    		getAccountContacts(this.value);
			    	});

			    	getDateFormat(${primaryTerritory?.id});
			    	
				    var zselect = document.getElementById('accountId');
					var zopt = zselect.options[zselect.selectedIndex];
					getAccountContacts(zopt.value);

					jQuery('#amount').keyup(function(){
					    this.value = numberWithCommas(this.value);
					});
			  });

			  function numberWithCommas(x) {
				  	x = x.split(",").join("");
			  		var parts = x.toString().split(".");
			    	parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
			    	return parts.join(".");
			  }
				
			  function getCurrencySymbol(territoryId)
			  {
				  jQuery.ajax({type:'POST',data: {id: territoryId },
						 url:'${baseurl}/geo/getCurrencySymbol',
						 success:function(data,textStatus){jQuery('#currencySymbol').html(data);},
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});
			  }

			  function getAccountContacts(accountId)
			  {
				  jQuery.ajax({type:'POST',data: {id: accountId},
						 url:'${baseurl}/opportunity/getAccountContacts',
						 success:function(data,textStatus){jQuery('#accountContactList').html(data);},
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});
			  }
			  
			  function getUserTerritories(userId)
			  {
				  jQuery.ajax({type:'POST',data: {id: userId },
						 url:'${baseurl}/commonSales/getUserTerritories',
						 success:function(data,textStatus){jQuery('#userTerritoryList').html(data);},
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});
			  }
			  
			  function getDateFormat(territoryId)
			  {
				  jQuery.ajax({type:'POST',data: {id: territoryId },
						 url:'${baseurl}/geo/getDateFormat',
						 success:function(data,textStatus)
						 {
						 	if(data != '' && data != null)
						 		{jQuery( "#closeDate" ).datepicker( "option", "dateFormat", data );}
						 	else
						 		{jQuery( "#closeDate" ).datepicker( "option", "dateFormat", "mm/dd/yy" );}
					 	 },
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});
			  }
			  
			  function updateContactList()
			  {
				  jQuery.ajax({type:'POST',data: {id: jQuery("#accountId").val() },
						 url:'${baseurl}/opportunity/getAccountContacts',
						 success:function(data,textStatus){jQuery('#accountContactList').html(data);},
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
			  }  
  		</script>
        
        
    </head>
    <body>
        <div class="nav">
            <!--<span><A HREF="javascript:history.go(-1)" class="buttons.button button">Back</A></span>-->
            <span><g:link class="buttons.button button" title="List Of Opportunities" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h2><g:message code="default.create.label" args="[entityName]" /></h2><hr>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            
            <div id="successDialog_1" title="Success">
				<p><g:message code="contact.create.message.success.dialog" default=""/></p>
			</div>
					
            <div id="dvNewContact"> </div>
            <g:form action="save" name="opportunityCreate">
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="name"><g:message code="opportunity.name.label" default="Opportunity Name" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: opportunityInstance, field: 'name', 'errors')}">
                                    <g:textField name="name" value="${opportunityInstance?.name}"  class="required"/>
                                </td>
                                
                                <td>&nbsp;&nbsp;</td>
                                
                                <td valign="top" class="name">
                                    <label for="assignTo"><g:message code="opportunity.assignTo.label" default="Assign To" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: opportunityInstance, field: 'assignTo', 'errors')}">
                                    <!--<g:select name="assignToId" from="${salesUsers?.sort {it.profile.fullName}}" value="${SecurityUtils.subject.principal}" optionKey="id" noSelection="['': 'Select Any One']" class="required" />-->
                                    <g:select name="assignToId" from="${new SalesController().generateAssignedToList(loginUser.id)}" value="" noSelection="['': 'Select Any One']" class="required"/>
                                </td>
                            </tr>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="account"><g:message code="opportunity.account.label" default="Select Account" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: opportunityInstance, field: 'account?.accountName', 'errors')}">
                                    <g:select name="accountId" from="${accountList?.sort {it.accountName}}" value="${opportunityInstance?.account?.id}" optionKey="id" optionValue="accountName" noSelection="['': 'Select Any One']" class="required"/>
                                </td>
                                
                                <td>&nbsp;&nbsp;</td>
                                
                                <td valign="top" class="name">
                                    <label for="geo"><g:message code="default.geo.label" default="Geo" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: opportunityInstance, field: 'geo', 'errors')}">
                                	<div id="userTerritoryList">
                                		<g:select name="territoryId" from="${territoryList?.sort {it.name}}" optionKey="id" value="${primaryTerritory?.id}" class="required" noSelection="['': 'Select Any One']" />
                                	</div>
                                </td>
                                
                          
                            </tr>
                            
                            <tr>
                            	<td valign="top" class="name">
                                    <label for="contact"><g:message code="opportunity.contact.label" default="Select Contact" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: opportunityInstance, field: 'primaryContact', 'errors')}">
                                    <div>
                                    	<div id="accountContactList" style="float: left;">
	                                    	<g:select name="contactId" id="contactId" from="" optionKey="id" class="required" noSelection="['': 'Select Any One']"/>
	                                	</div>
	                                	<div style="float: left;text-align: left; padding-left: 2px; padding-top: 5px;">
	                                		<button id="newContact" class="roundNewButton" title="Create New Contact">+</button>
	                                	</div>
                                    </div>
                                	
                                </td>
                            </tr>
                    </tbody>
                 </table><hr>
                 <table>
                 	<tbody>
                            <tr class="prop">    
                                <td valign="top" class="name">
                                    <label for="closeDate"><g:message code="opportunity.closeDate.label" default="Close Date" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: opportunityInstance, field: 'closeDate', 'errors')}">
                           			<g:textField name="closeDate"  class="required"/>
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
                <div class="buttons">
                    <span class="button"><g:submitButton name="create" title="Save Opportunity" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
