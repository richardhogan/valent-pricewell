
<%@ page import="com.valent.pricewell.Quotation" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <title>Report of Quotes</title>
        <script type="text/javascript" src="http://www.google.com/jsapi"></script>
		
		<gui:resources components="tabView" mode="debug"/>
		
		<style type="text/css" title="currentStyle">
			@import "../js/dataTables/css/demo_page.css";
			@import "../js/dataTables/css/demo_table.css";
		</style>
			
		<script type="text/javascript" language="javascript" src="../js/dataTables/js/jquery.dataTables.js"></script>
		
		<script>
			jQuery(document).ready(function()
			{
				jQuery('#quoteList').dataTable({
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
			});
		</script>
    </head>
    <body>
        <div class="body yui-skin-sam">
        	<g:render template="samplenavigation"  model="['productManagerEstimatedVeriance': productManagerEstimatedVeriance]" />
        	                               
            <center><h2>Report of Quotes</h2></center>
            
            
           <div class="list yui-skin-sam"> 
           <gui:tabView>
           		<gui:tab label="Charts" active="${true}">
           		
           			<div>
		        		<g:form controller="reports" action="statusOfQuotes">
		                  	<label>GEO</label>
		                   	<g:select name="geoId" from="${com.valent.pricewell.Geo.list()}" optionKey="id" value="${geoInstance?.id}" noSelection="['all':'All']"  />
		   					<g:submitButton name="searchButton" value="Show"></g:submitButton>                
						</g:form>                   
		            </div>
           			<h3> Total Quotes ${totalQuotes} for GEO ${geoInstance?.name}</h3>
           			
           		  	<gvisualization:pieCoreChart elementId="piechart" title="Summary of Quotes status" width="${450}" height="${300}" 
					 columns="${qoutesColumns}" data="${quotesValues}" />
					 
					<gvisualization:barCoreChart elementId="barChart" title="Summary of Quotes status" width="${450}" height="${300}" 
					 columns="${qoutesColumns}" data="${quotesValues}"/>
					
										 
					 <div>
					 	<table>
					 		<tr>
					 			<td><div id="piechart"></div></td>
					 			<td><div id="barChart"></div></td>
					 		</tr>
					 	</table>
					 </div>
					 
	            </gui:tab>
				<gui:tab label="List">
           			<table cellpadding="0" cellspacing="0" border="0" class="display" id="quoteList">
	                    <thead>
	                        <tr>
	                        
	                            <th><g:message code="quotation.id.label" default="Id" /></th>
	                            
	                            <th><g:message code="quotation.account.label" default="Account" /></th>
	                            
	                            <th><g:message code="quotation.customerType.label" default="Customer Type" /></th>
	                            
	                            <th><g:message code="quotation.createdDate.label" default="Created Date" /></th>
	                        
	                            <th><g:message code="quotation.geo.label" default="Geo" /></th>
	                            
	                            <th><g:message code="quotation.totalQuotedPrice.label" default="Total Quoted Price" /></th>
	                            
	                            <th><g:message code="quotation.status.label" default="Status" /></th>
	                       
	                        </tr>
	                    </thead>
	                    <tbody>
	                    <g:each in="${quotationInstanceList}" status="i" var="quotationInstance">
	                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
	                        
	                            <td><g:link action="show" id="${quotationInstance.id}">${fieldValue(bean: quotationInstance, field: "id")}</g:link></td>
	                        
	                            <td>${fieldValue(bean: quotationInstance, field: "account")}</td>
	                        
	                            <td>${fieldValue(bean: quotationInstance, field: "customerType")}</td>
	                        
	                            <td><g:formatDate format="MMMMM d, yyyy" date="${quotationInstance.createdDate}" /></td>
	                        
	                            <td>${fieldValue(bean: quotationInstance, field: "geo")}</td>
	                        
	                            <td>${fieldValue(bean: quotationInstance, field: "totalQuotedPrice")}</td>
	                            
	                            <td> ${fieldValue(bean: quotationInstance, field: "status")} </td>
	                        
	                        </tr>
	                    </g:each>
	                    </tbody>
	                </table>
           		</gui:tab>
				           		
           </gui:tabView>
            </div>
            
        </div>
    </body>
</html>
