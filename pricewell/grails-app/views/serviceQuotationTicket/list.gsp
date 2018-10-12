
<%@ page import="com.valent.pricewell.ServiceQuotationTicket" %>

<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'serviceQuotationTicket.label', default: 'Service Ticket')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
        <style type="text/css" title="currentStyle">
			@import "${baseurl}/js/dataTables/css/demo_page.css";
			@import "${baseurl}/js/dataTables/css/demo_table.css";
		</style>
			
		<script type="text/javascript" language="javascript" src="${baseurl}/js/dataTables/js/jquery.dataTables.js"></script>
        <script>
        	jQuery(document).ready(function()
   			{
   				jQuery('#serviceQuotationTicketList').dataTable({
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

   				jQuery( "#importBtn" ).click(function() 
				{
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/connectwiseCredentials/isCredentialsAvailable",
						success: function(data)
						{
							if(data['result'] == "yes")
							{
								showLoadingBox();
								jQuery.ajax({
									type: "POST",
									url: "${baseurl}/serviceQuotationTicket/importClosedTicket",
									success: function(data)
									{
										hideLoadingBox();
										if(data == "success")
										{
											window.location = "${baseurl}/serviceQuotationTicket/list";
										}
										
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
            <!-- <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link class="buttons.button button" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>-->
            <span><button id="importBtn" title="Import All Closed From Connectwise to Pricewell" class="buttons.button button">Import</button></span>
        </div>
        <div class="body">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1><hr />
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table cellpadding="0" cellspacing="0" border="0" class="display" id="serviceQuotationTicketList">
                    <thead>
                        <tr>
                        
                            <th></th>
                        
                            <th>${message(code: 'serviceQuotationTicket.summary.label', default: 'Summary')}</th>
                        	
                            <th>${message(code: 'serviceQuotationTicket.budgetHours.label', default: 'Budget Hours')}</th>
                        
                            <th>${message(code: 'serviceQuotationTicket.actualHours.label', default: 'Actual Hours')}</th>
                        
                            <th>Opportunity</th>
                            
                        	<th>Service</th>
                        	
                        	<th>Status</th>
                        	
                        	<th>TicketId</th>
                        	
                        	<th> Last Modified</th>
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${serviceQuotationTicketInstanceList}" status="i" var="serviceQuotationTicketInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${serviceQuotationTicketInstance.id}" class="hyperlink">View</g:link></td>
                        
                            <td>${fieldValue(bean: serviceQuotationTicketInstance, field: "summary")}</td>
                        
                            <td>${fieldValue(bean: serviceQuotationTicketInstance, field: "budgetHours")}</td>
                        
                            <td>${fieldValue(bean: serviceQuotationTicketInstance, field: "actualHours")}</td>
                        
                            <td>${fieldValue(bean: serviceQuotationTicketInstance, field: "serviceQuotation.quotation.opportunity.name")}</td>
                        
                        	<td>${fieldValue(bean: serviceQuotationTicketInstance, field: "serviceActivity.serviceDeliverable.serviceProfile.service.serviceName")}</td>
                        	
                        	<td>${fieldValue(bean: serviceQuotationTicketInstance, field: "status")}</td>
                        	
                        	<td>${fieldValue(bean: serviceQuotationTicketInstance, field: "ticketId")}</td>
                        	
                        	<td><g:formatDate format="MMMMM d, yyyy" date="${serviceQuotationTicketInstance.modifiedDate}" /></td>
                        
                            
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            
        </div>
    </body>
</html>
