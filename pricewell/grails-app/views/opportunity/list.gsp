
<%@ page import="com.valent.pricewell.Opportunity" %>
<%@ page import="com.valent.pricewell.Quotation" %>
<%@ page import="org.apache.shiro.SecurityUtils"%>
<%@ page import="com.valent.pricewell.SalesController"%>

<%
	def baseurl = request.siteUrl
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'opportunity.label', default: 'Opportunity')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
        <style type="text/css" title="currentStyle">
			@import "${baseurl}/js/dataTables/css/demo_page.css";
			@import "${baseurl}/js/dataTables/css/demo_table.css";
		</style>
			
		<script type="text/javascript" language="javascript" src="${baseurl}/js/dataTables/js/jquery.dataTables.js"></script>
        <style>
			/* Left Div */
			.LeftDiv{
				  width: 50%;
				  padding: 0 0px;
				  float:left;
				  
				 }
			
			/* Right Div */
			.RightDiv{
				  width: 40%;
				  padding: 0 0px;
				  float: right;
				  
				 } 
		</style>
        <script>
			jQuery(document).ready(function()
			{
				jQuery('#opportunityList').dataTable({
					"sPaginationType": "full_numbers",
					"sDom": 't<"F"ip>',
			        "bFilter": false,
			        "fnDrawCallback": function() {
		                if (Math.ceil((this.fnSettings().fnRecordsDisplay()) / this.fnSettings()._iDisplayLength) > 1)  {
		                        jQuery('.dataTables_paginate').css("display", "block"); 
		                        jQuery('.dataTables_length').css("display", "block");                       
		                } else {
		                		jQuery('.dataTables_paginate').css("display", "none");
		                		jQuery('.dataTables_length').css("display", "none");
		                }
		            }
				});

				jQuery( ".progressbar" ).progressbar();

				jQuery( "#importDialoag" ).dialog(
				{
					modal: true,
					autoOpen: false,
					height: 200,
					width: 500,
					resizable: true
				});

				jQuery( "#importBtn" ).click(function() 
				{
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/connectwiseCredentials/isCredentialsAvailable",
						success: function(data)
						{
							if(data['result'] == "yes")
							{
								//var myWindow = window.open("${baseurl}/cw/importOpportunities", "import_opportunities", "width=1100, height=500");//for saperate window...

								jQuery('#importDialoag').html("Loading, Please wail...").dialog("open");
								jQuery("#importDialoag").dialog( "option", "title", "Import Opportunities from Connectwise to Pricewell" );
								jQuery.ajax({
									type: "POST",
									url: "${baseurl}/cw/importOpportunities",
									success: function(data){
										jQuery('#importDialoag').html(data);
									}, 
									error:function(XMLHttpRequest,textStatus,errorThrown){alert("Something goes wrong.");}
								});
							}
							else
							{
								alert(data['failureMessage']);
							}
							
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){alert("Something goes wrong.");}
					});

					
					
					return false;
				});

				jQuery( "#salesforceImportBtn" ).click(function() 
				{
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/salesforceCredentials/isCredentialsAvailable",
						success: function(data)
						{
							if(data['result'] == "yes")
							{
								
								jQuery('#importDialoag').html("Loading, Please wail...").dialog("open");
								jQuery("#importDialoag").dialog( "option", "title", "Import Opportunities from Salesforce to Pricewell" );
								jQuery.ajax({
									type: "POST",
									url: "${baseurl}/salesforce/importOpportunities",
									success: function(data){
										jQuery('#importDialoag').html(data);
									}, 
									error:function(XMLHttpRequest,textStatus,errorThrown){alert("Something goes wrong.");}
								});
							}
							else
							{
								alert(data['failureMessage']);
							}
							
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){alert("Something goes wrong.");}
					});

					
					
					return false;
				});
			});
		</script>
    </head>
    <body>
        <div class="nav">
            
            <span><g:link class="buttons.button button" title="Create Opportunity" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
            <g:if test="${new SalesController().isConnectwiseIncluded()}">
            	<g:if test="${SecurityUtils.subject.hasRole('SYSTEM ADMINISTRATOR') || SecurityUtils.subject.hasRole('SALES PRESIDENT')}">
            		<span><button id="importBtn" title="From Connectwise to Pricewell" class="buttons.button button">Import</button></span>
           		</g:if>
           	</g:if>
           	
           	<g:if test="${new SalesController().isSalesforceIncluded()}">
            	<g:if test="${SecurityUtils.subject.hasRole('SYSTEM ADMINISTRATOR') || SecurityUtils.subject.hasRole('SALES PRESIDENT')}">
            		<span><button id="salesforceImportBtn" title="From Salesforce to Pricewell" class="buttons.button button">Import</button></span>
           		</g:if>
           	</g:if>
        </div>
        <div class="body">
        	<h2>Search Opportunity</h2>
            <g:render template="/opportunity/searchOpportunityToolbar"/><hr>
            <h2><g:message code="default.list.label" args="[entityName]" /></h2>
            
			<div class="leftNav">      		
	    		<g:render template="nevigation"/>
	    	</div>	
    	
    		<div id="importDialoag">
				
			</div>
			
    		<div id="columnRight" class="body rightContent column">
    		
    			<h1>${title}</h1>
    			
	            <div class="list">
	                <table cellpadding="0" cellspacing="0" border="0" class="display" id="opportunityList">
	                    <thead>
	                        <tr>
	                        
	                        	<th><g:message property="name" code="opportunity.name.label" default="Name" /></th>
	                        	
	                        	<th><g:message property="account" code="opportunity.account.label" default="Account" /></th>
	                        	
	                        	<th><g:message property="amount" code="opportunity.amount.label" default="Amount" /></th>
	                        	
	                        	<th><g:message property="geo" code="opportunity.geo.label" default="Territory" /></th>
	                        	
	                        	<th><g:message property="closeDate" code="opportunity.closeDate.label" default="Close Date" /></th>
	                        	
	                        	<g:if test="${!SecurityUtils.subject.hasRole('SALES PERSON')}">
	                        	
	                        		<th><g:message property="assignTo" code="opportunity.assignTo.label" default="Assign To" /></th>
	                        		
	                            </g:if>
	                            <th>Opportunity Status</th>
	                            
	                        	<th style="width: 15%;">&nbsp;&nbsp; Actual vs Opportunity </th>
	                        	<th style="width: 15%;">&nbsp;&nbsp; Forecast vs Opportunity </th>
	                        	
	                        </tr>
	                    </thead>
	                    <tbody>
	                    <g:each in="${opportunityInstanceList}" status="i" var="opportunityInstance">
	                        <tr>
	                        
	                        <%
							 	def listQuotations = opportunityInstance.latestQuotations()
							 	BigDecimal totalforecastValue = new BigDecimal(0)
								BigDecimal totalActualValue = new BigDecimal(0)
								
								for(Quotation q : listQuotations){
									if(q.forecastValue && q.confidencePercentage){
										totalforecastValue += q.forecastValue
										if(q.confidencePercentage >= 100){
											totalActualValue += q.finalPrice
										}
									}
								}
								
								def fid =  'forecasttotal' + opportunityInstance.id;
								
								def aid = 'totalValue' + opportunityInstance.id;
	 
	 						 %>
	                            <td><g:link action="show" title="Show Details" class="hyperlink" id="${opportunityInstance.id}">${fieldValue(bean: opportunityInstance, field: "name")}</g:link></td>
	                        
	                            <td>${fieldValue(bean: opportunityInstance, field: "account.accountName")}</td>
	                        
	                            <td>${opportunityInstance?.geo?.currencySymbol}${fieldValue(bean: opportunityInstance, field: "amount")} &nbsp;</td>
	                        
	                        	<td>${fieldValue(bean: opportunityInstance, field: "geo.name")}</td>
	                        	
	                        	<td><g:formatDate format="MMMMM d, yyyy" date="${opportunityInstance.closeDate}" /></td>
	                        	
	                        	<g:if test="${!SecurityUtils.subject.hasRole('SALES PERSON')}">
	                            	<td>${fieldValue(bean: opportunityInstance, field: "assignTo")}</td>
	                            </g:if>
	                            <td>${fieldValue(bean: opportunityInstance, field: "stagingStatus.displayName")}</td>
	                        	<g:if test="${opportunityInstance.amount != 0}">
		                        	<td style="width: 15%;"> <g:render template="/quotation/forecastValue" model="['id': aid, 'value': totalActualValue, 'total': opportunityInstance.amount, 'currency': opportunityInstance.geo?.currency ]"/> </td>
		                        	
		                        	<td style="width: 15%;"> <g:render template="/quotation/forecastValue" model="['id': fid, 'value': totalforecastValue, 'total': opportunityInstance.amount, 'currency': opportunityInstance.geo?.currency ]"/> </td>
		                        </g:if>
	                            <g:else><td></td><td></td></g:else>
	                        	
	                        </tr>
	                    </g:each>
	                    </tbody>
	                </table>
	            </div>
            </div>
            
        </div>
    </body>
</html>
