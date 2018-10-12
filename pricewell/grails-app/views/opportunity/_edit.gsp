<%@ page import="com.valent.pricewell.Opportunity" %>
<%@ page import="com.valent.pricewell.SalesController" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <g:set var="entityName" value="${message(code: 'opportunity.label', default: 'Opportunity')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
        
        
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
			  		
			    	jQuery("#opportunityEdit").validate({
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
					    	
				    //jQuery("#opportunityEdit").validate();
				    jQuery("#opportunityEdit input:text")[0].focus();
				    
				    jQuery("#territoryId").change(function() 
			    	{
					  	getCurrencySymbol(this.value);
			    		getDateFormat(this.value);

						return false;
					  
					});

				    jQuery("#assignToId").change(function() 
			    	{
					  	getUserTerritories(this.value);	 
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

				    var formatedDate = "";
				    jQuery.ajax(
					{
						type:'POST',data: {id: ${opportunityInstance?.id} },
						 url:'${baseurl}/opportunity/getFormatedDate',
						 success:function(data1,textStatus)
						 {
							 jQuery.ajax({type:'POST',data: {id: ${opportunityInstance?.geo?.id} },
								 url:'${baseurl}/geo/getDateFormat',
								 success:function(data,textStatus)
								 {
								 	if(data != '' && data != null)
								 		{
								 			jQuery( "#closeDate" ).datepicker( "option", "dateFormat", data );
								 			jQuery( "#closeDate" ).datepicker( "setDate", data1 );
								 		}
								 	else
								 		{
								 			jQuery( "#closeDate" ).datepicker( "option", "dateFormat", "mm/dd/yy" );
								 			jQuery( "#closeDate" ).datepicker( "setDate", data1 );
							 			}
							 	 },
								 error:function(XMLHttpRequest,textStatus,errorThrown){}});
							 
							 
					 	 },
						 error:function(XMLHttpRequest,textStatus,errorThrown){}
				    });

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
			  
			  function getUserTerritories(userId)
			  {
				  jQuery.ajax({type:'POST',data: {id: userId },
						 url:'${baseurl}/commonSales/getUserTerritories',
						 success:function(data,textStatus)
						 {
							 jQuery('#userTerritoryList').html(data);
						 },
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});
					 
			  }
			  
			  function getCurrencySymbol(territoryId)
			  {
				  jQuery.ajax({type:'POST',data: {id: territoryId },
						 url:'${baseurl}/geo/getCurrencySymbol',
						 success:function(data,textStatus){jQuery('#currencySymbol').html(data);},
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
			
  		</script>
        
        
    </head>
    <body>
        <div class="body">
            
            
            <g:form method="post" name="opportunityEdit" >
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
                                    <!--<g:select name="assignToId" from="${salesUsers?.sort {it.profile.fullName}}" value="${opportunityInstance?.assignTo?.id}" optionKey="id" noSelection="['': 'Select Any One']" class="required"/>-->
                                    <g:select name="assignToId" from="${new SalesController().generateAssignedToList(opportunityInstance?.assignTo?.id)}" value="${opportunityInstance?.assignTo?.id}" noSelection="['': 'Select Any One']" class="required"/>
                                </td>
                                
                                <td>&nbsp;&nbsp;</td>
                                
                                <td valign="top" class="name">
                                    <label for="geo"><g:message code="default.geo.label" default="Geo" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: opportunityInstance, field: 'geo', 'errors')}">
                                	<div id="userTerritoryList">
                                    	<g:select name="territoryId" from="${territoryList?.sort {it.name}}" optionKey="id" value="${opportunityInstance?.geo?.id}" noSelection="['': 'Select any one']" class="required "/>
                                   	</div>
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
                                    <label for="closeDate"><g:message code="opportunity.closeDate.label" default="Close Date" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: opportunityInstance, field: 'closeDate', 'errors')}">
                                    <g:textField name="closeDate"  value="" class="required"/>
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
                                			<td><div id="currencySymbol">${opportunityInstance?.geo?.currencySymbol}</div></td>
                                			<td><g:textField name="amount" value="${fieldValue(bean: opportunityInstance, field: 'amount')}" number="true" /></td>
                                		</tr>
                                	</table>
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
                    <span class="button"><g:actionSubmit class="save" title="Update Opportunity" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
