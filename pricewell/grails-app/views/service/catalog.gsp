
<%@ page import="com.valent.pricewell.Service" %>
<%@ page import="com.valent.pricewell.Pricelist" %>
<%@ page import="org.apache.shiro.SecurityUtils"%>

<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        
        <g:set var="entityName" value="${message(code: 'service.label', default: 'Service')}" />
        <style type="text/css" title="currentStyle">
			@import "${baseurl}/js/dataTables/css/demo_page.css";
			@import "${baseurl}/js/dataTables/css/demo_table.css";
		</style>

		<script type="text/javascript" language="javascript" src="${baseurl}/js/dataTables/js/jquery.dataTables.js"></script>
		        
        <script type="text/javascript"> 
        	jQuery.noConflict();
		</script>
		
        <r:require module="jqueryalert"/>
		        
        <title>Service Catalog </title>
        <script>
	
			jQuery(function() {
				
				  
					
				jQuery("#calculatePortfolio").click(function(){
						jQuery('#dialog').dialog('open');
							 return false;
					})
					
				jQuery("#dialog").dialog({ autoOpen: false });

				jQuery('#serviceList').dataTable({
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

				jQuery( "#workflowSelectionDialog" ).dialog(
					 	{
							modal: true,
							autoOpen: false,
							resizable: false,
							height:300,
							width: 400
						});


				jQuery( "#btnNewService" ).click(function() 
						{
							if(${portfolioList?.size()==0})
							{
								jAlert('${message(code:'newServicePortfolioNotAssign.message.alert')}', 'Create New Service Alert');
								
							}
							else
							{
								jQuery.ajax({type:'POST',
				   					url:'${baseurl}/service/selectionOfWorkflow',
				   					success:function(data,textStatus)
				   					{
					   					jQuery('#workflowSelectionDialog').html(data);
									 	jQuery("#workflowSelectionDialog").dialog("open");
									},
				   					error:function(XMLHttpRequest,textStatus,errorThrown){}});
							}
							
							return false;
						});

				jQuery( "#importServiceSuccessDialog" ).dialog(
			 	{
					modal: true,
					autoOpen: false,
					resizable: false,
					buttons: {
						OK: function() 
						{
							 
							jQuery(this).dialog( "close" );
							var filePath = jQuery(this).data("filePath");
							window.location = "${baseurl}/downloadFile/downloadTextFile?filePath="+filePath;
							return false;
						}
					}
				});

				jQuery( "#responseDialog" ).dialog(
			 	{
					modal: true,
					autoOpen: false,
					resizable: false,
					height:500,
					width: 800,
					buttons: {
						"Download Response": function() 
						{
							 
							jQuery(this).dialog( "close" );
							var filePath = jQuery(this).data("filePath");
							window.location = "${baseurl}/downloadFile/downloadTextFile?filePath="+filePath;
							return false;
						},
						"close": function()
						{
							jQuery(this).dialog( "close" );
							return false;
						}
					}
				});
						
				jQuery( "#importServiceFailureDialog" ).dialog(
				{
					modal: true,
					autoOpen: false,
					resizable: false,
					buttons: {
						OK: function() {
							jQuery(this).dialog( "close" );
							location.reload();
							return false;
						}
					}
				});

						    
				jQuery( "#btnImport" ).click(function() 
				{
					jQuery.ajax({type:'POST',
	   					url:'${baseurl}/service/importFile',
	   					success:function(data,textStatus)
	   					{
		   					jQuery('#importServiceDialog').html(data);
						 	jQuery("#importServiceDialog").dialog("open");
						},
	   					error:function(XMLHttpRequest,textStatus,errorThrown){}});
   					
					return false;
				});

						
				jQuery( "#importServiceDialog" ).dialog(
				{
					modal: true,
					height: 300,
					width: 450,
					autoOpen: false,
					resizable: false,
					close: function( event, ui ) {
						jQuery(this).html('');
					}
				});

			});
		</script>
    </head>
    <body>
    
    	<div id="importServiceSuccessDialog" title="Success">
			<p>File imported successfully. Now one response file will be generated. Please press OK.</p>
		</div>
		
		<div id="responseDialog" title="Success">
			
		</div>
		
		<div id="workflowSelectionDialog" title="Select Service Workflow">
			
		</div>

		<div id="importServiceFailureDialog" title="Failure">
			<p>Failed to import file.</p>
		</div>
		
		<div id="importServiceDialog" title="Import Service File">
			
		</div>
		
    	<g:if test="${!SecurityUtils.subject.hasRole('SYSTEM ADMINISTRATOR') && !SecurityUtils.subject.hasRole('PORTFOLIO MANAGER') && !SecurityUtils.subject.hasRole('PRODUCT MANAGER') && !SecurityUtils.subject.hasRole('SERVICE DESIGNER') && (SecurityUtils.subject.hasRole('GENERAL MANAGER') || SecurityUtils.subject.hasRole('SALES PRESIDENT') || SecurityUtils.subject.hasRole('SALES MANAGER') || SecurityUtils.subject.hasRole('SALES PERSON'))}">	
	    	<div class="body">
        </g:if>
        <g:else>
        	<div class="nav">
	            <span><g:link class="list" action="index" title="List Of Service" class="buttons.button button"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
	        </div>
	        
	        <div class="leftNav">
	       		<g:render template="serviceNavigation"/>
	    	</div>
    		
        	<div id="columnRight" class="body rightContent column">
        </g:else>
        
            <h1> ${title} </h1>
            <g:set var="serviceMode" value="published" scope="request"/>
            
            <g:if test="${!SecurityUtils.subject.hasRole('GENERAL MANAGER') && !SecurityUtils.subject.hasRole('SALES PRESIDENT') && !SecurityUtils.subject.hasRole('SALES MANAGER') && !SecurityUtils.subject.hasRole('SALES PERSON')}">
            	<g:render template="searchService" model="['searchFields': searchFields]" />
            </g:if>
            
            <g:if test="${flash.message}">
            <!--div class="message">${flash.message}</div-->
            </g:if>
            
            <div class="nav">
            	<g:if test="${!SecurityUtils.subject.hasRole('SYSTEM ADMINISTRATOR') && !SecurityUtils.subject.hasRole('PORTFOLIO MANAGER') && !SecurityUtils.subject.hasRole('PRODUCT MANAGER') && !SecurityUtils.subject.hasRole('SERVICE DESIGNER') && (SecurityUtils.subject.hasRole('GENERAL MANAGER') || SecurityUtils.subject.hasRole('SALES PRESIDENT') || SecurityUtils.subject.hasRole('SALES MANAGER') || SecurityUtils.subject.hasRole('SALES PERSON'))}">
				
					<span><g:link class="buttons.button darkbutton" action="index" title="Refresh Catalog" >Refresh Catalog</g:link></span>
            	</g:if>
            	<g:else>
            		<span><g:link class="buttons.button darkbutton" action="refreshPricelist" title="Refresh Catalog" params="[caller: 'catalog']">Refresh Catalog</g:link></span>
            		<g:if test="${createPermit}">
            			<span><g:link class="buttons.button darkbutton" action="create" title="New Service" onclick="if(${portfolioList?.size()==0}){jAlert('${message(code:'newServicePortfolioNotAssign.message.alert')}', 'Create New Service Alert');return false;}">New Service</g:link></span>

            			<!-- <span>&nbsp;
							<input id="btnNewService" type="button" title="New Service" value="New Service"  class="buttons.button button" class="menuButtonStyle "/>
						</span> -->            			

            			<!-- <span><g:link class="buttons.button button" action="importService" title="Import New Service" onclick="if(${portfolioList?.size()==0}){jAlert('${message(code:'newServicePortfolioNotAssign.message.alert')}', 'Create New Service Alert');return false;}">Import Service</g:link></span>-->
            			
            			<g:if test="${SecurityUtils.subject.hasRole('SYSTEM ADMINISTRATOR')}">
					 		<span>
								<!-- <input id="btnImport" type="button" title="Import Multiple Services" value="Import Service"  class="buttons.button button" class="menuButtonStyle "/> -->
								<g:link class="buttons.button darkbutton" action="importFile" title="Import Multiple Services" >Import Service</g:link>
							</span>
						</g:if>
            		</g:if>
            	</g:else>
        	</div> 
        	<div class="list">
                <table cellpadding="0" cellspacing="0" border="0" class="display" id="serviceList">
                    <thead>
                        <tr>
                        	<th><g:message code="service.portfolio.label" default="Portfolio" /></th>
                        	
                        	<th><g:message code="service.serviceName.label" default="Service Name" /></th>
                        	
                        	<th><g:message code="service.skuName.label" default="Sku Name" /></th>
                        	
                            <th> <g:message code="serviceProfile.unitOfSale.label" default="Unit of Sale" /> </th>
                            
                            <th> <g:message code="serviceProfile.baseUnits.label" default="Base Units" /> </th>
                                                       
                            <th> <g:message code="serviceProfile.baseHrs.label" default="Base Hrs" /> </th>
                            
                            <th> <g:message code="serviceProfile.additionalHrs.label" default="Add.Unit Hrs" /> </th>
                            
                            <th> <g:message code="serviceProfile.premiumPercent.label" default="Premium (%)" /> </th>
                            
                            <th> <g:message code="serviceProfile.datePublished.label" default="Published Date" /> </th>
                                  
                        	<th> <g:message code="default.geo.list" default="Territories" /> </th>
                        	 
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${serviceInstanceList}" status="i" var="serviceInstance">
                        <tr>
                        
                        	<g:set var="estimateMap" value="${serviceInstance.serviceProfile.calculateTotalEstimatedTime()}"/>
                        	
                        	<td>${fieldValue(bean: serviceInstance, field: "portfolio")}</td>
                        	
                            <td> 
                            	<g:link action="show" title="Show Details" class="hyperlink"  params="[id: serviceInstance.id]"> ${fieldValue(bean: serviceInstance, field: "serviceName")} </g:link> 
                    		</td>
                        
                            <td>${fieldValue(bean: serviceInstance, field: "skuName")}</td>
                            
                            <td> ${serviceInstance.serviceProfile.unitOfSale} </td>
                            
                            <td> ${serviceInstance.serviceProfile.baseUnits} </td>
                            
                            <td> ${estimateMap["totalFlat"]} </td>
                            
                            <td> ${estimateMap["totalExtra"]} </td>
                            
                            <td> ${serviceInstance.serviceProfile.premiumPercent} </td>
                            
                            <td> <g:formatDate format="MMMMM d, yyyy" date="${serviceInstance.serviceProfile.dateModified}" /> </td>
                            
                            <td> ${Pricelist.findAllByServiceProfile(serviceInstance.serviceProfile).geo.join(", ")} </td>
                                           
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
           
        </div>
    </body>
</html>
