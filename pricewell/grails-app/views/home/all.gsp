
<%@ page import="grails.converters.JSON"%>
<%@ page import="org.apache.shiro.SecurityUtils"%>
<%
	def baseurl = request.siteUrl
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="layout" content="main" />

<style>
.box {
	width: 15%;
	height: auto;
	border-top: 1px solid #0000FF;
	border-bottom: 1px solid #0000FF;
	border-right: 1px solid #0000FF;
	border-left: 1px solid #0000FF;
	padding-left: 30px;
}
</style>
<script type="text/javascript">
    	     jQuery(function () {
    	    	 jQuery("#startDate").datepicker({
      			        numberOfMonths: 1,
      			      dateFormat: 'mm/dd/yy',
      			        onSelect: function (selected) {
      			            var dt = new Date(selected);
      			            dt.setDate(dt.getDate() + 1);
      			            
      			            //jQuery("#endDate").datepicker("option", "minDate", dt);
      			        }
      			    });
    	    	 jQuery("#endDate").datepicker({
      			        numberOfMonths: 1,
      			        dateFormat: 'mm/dd/yy',
      			        onSelect: function (selected) {
      			            var dt = new Date(selected);
      			            dt.setDate(dt.getDate() - 1);
      			          //  jQuery("#startDate").datepicker("option", "maxDate", dt);
      			        }
      			    });
      			});   
    	     
    	     </script>
<script>
       //var dataObject=jQuery.parseJSON('{"start":"'+today+'","end":"'+quarterStartDate+'"}');
	       jQuery(document).ready(function()
	       {
		   		jQuery( "#tabsDiv" ).tabs();
		   		
		   		jQuery('.blink').blink();

		  // 		dateRange('serviceSold_dateRange', 'This quarter to date', function(val)
	     // 		{
		//			var obj = jQuery.parseJSON(val);
		//			var portfolioId = jQuery("#portfolioId").val();
					
		//			refreshTotalITCostGraphs(obj, portfolioId)
		//			return false;
	     // 		});

		   //		jQuery("#portfolioId").change(function () 
   		    //	{
	      	//		var portfolioId = this.value;
	      	//		var obj = jQuery.parseJSON(jQuery("#serviceSold_dateRange").val());
	      			
	      	//		refreshTotalITCostGraphs(obj, portfolioId)
			//		return false;
   		    //	});
	      		
		   	//	dateRange('vsoe_dateRange', 'This quarter to date', function(val)
	      	//	{
		    //  		//alert(val);
			//		var obj = jQuery.parseJSON(val);
					//In order to get selected text
					//alert(jQuery("#pendinDays_dateRange option:selected").text());
			//		vsoeDiscountingGraph.showLoading();
					
			//		jQuery.ajax({type:'POST',data: {start: obj.start, end: obj.end},
			//			 url:'${baseurl}/charts/VSOEDiscount',
			//			 success:function(data,textStatus)
			//			 {
			//				 jQuery('#dvVsoeGraph').html(data);
			//				 vsoeDiscountingGraph.hideLoading();
			//			 },
			//			 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
	      	//	});

		   	//	dateRange('unitsSold_dateRange', 'This quarter to date', function(val)
	      	//	{
		   			
			//		var obj = jQuery.parseJSON(val);
			//		refreshTotalRequestsbyService(obj);
	      	//	});

		   //		dateRange('salesSold_dateRange', 'This quarter to date', function(val)
	      //		{
		      		
			//		var obj = jQuery.parseJSON(val);
					//alert(obj);
			//		refereshTotalValueofRequestsbyService(obj);
	      	//	});
			//	dateRange('productsSold_dateRange', 'This quarter to date', function(val)
	      	//	{
			//		var obj = jQuery.parseJSON(val);
			//		alert("helo")
			//		//refreshTotalProductsSoldByServiceOffering(obj);
	      	//	});
				dateRangeWithCustom('glbl_dateRange', 'This quarter to date', function(val)
	    	      		{
    	      		if(val=='customDate')
        	      		{
        	      		jQuery("#glbl_dataRangeSpan").css("display","none");
        	      		jQuery("#searchbydate").css("display","");
        	      		}
    	      		else
        	      		{
    	      			jQuery("#startDate").val("");
    	      			jQuery("#endDate").val("");
    	      			jQuery("#searchbydate").css("display","none");
    	      			//dataObject = jQuery.parseJSON(val);
        	      		}
	    					
	    					
	    					//refreshTotalProductsSoldByServiceOffering(obj);
	    	      		});
		   	//	dateRange('serviceFunnel_dateRange', 'This quarter to date', function(val)
   	      	//	{
   			//		var obj1 = jQuery.parseJSON(val);
   					//alert(obj1.start + " " + obj1.end);
   			//		refreshServicePipeline(obj1);
   	      	//	});
   	      		jQuery("#closeSearchByDate").click(function()
					{
   	      			jQuery("#startDate").val("");
      				jQuery("#endDate").val("");
   	      			jQuery("#glbl_dataRangeSpan").css("display","");
	      			jQuery("#searchbydate").css("display","none");
	      			jQuery("select#glbl_dateRange").prop('selectedIndex', 0);
   	      			}
   	    	      		);
   	      		
   	      		
		   		jQuery( "#dvExceptionReport" ).dialog(
			 	{
					autoOpen: false,
					resizable: false,
					height: 450,
					modal: true,
					width: jQuery(window).width()-200,
					close: function( event, ui ) {
							jQuery(this).html('');
						}
				});
				
		   		jQuery( "#serviceExceptionBtn" ).click(function() 
				{
		   			jQuery('#dvExceptionReport').html("Loading, Please wait.........");
		   			jQuery('#dvExceptionReport').dialog( "option", "title", 'Exception report of undefined rate/cost of territories in services' );
					jQuery("#dvExceptionReport").dialog("open");
		   			jQuery.ajax({type:'POST',
						 url:'${baseurl}/service/serviceExceptionReport',
						 success:function(data,textStatus)
						 {
							 jQuery('#dvExceptionReport').html(data);
						 },
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
				});
		   		jQuery("#searchButton").click(function()
		   		    	{
	   		    		var territory_id=jQuery("#glbl_terrotory_id").val();
		   				var portfolio_id=jQuery("#glbl_portfolio_id").val();
	   		    		var startDate=jQuery("#startDate").val();
	   		    		var endDate=jQuery("#endDate").val();
						var dateRange=jQuery("#glbl_dateRange").val();
						//alert(dateRange);
	   		    		
	   		    	if(startDate=="" && endDate=="" )
	   		    	{
						if(dateRange=="customDate")
							{
							
							jAlert("Please Enter Start Date And End Date")
							}
						else
							{
							var dataObject = jQuery.parseJSON(dateRange);
							//alert(dataObject);
							//if(${role != 'PRODUCT MANAGER'})									
				    	  if(${!SecurityUtils.subject.hasRole('PRODUCT MANAGER')})
				    	 {
								refreshAllData(dataObject,portfolio_id,territory_id)
				    	 }
							else
								{
								refreshServicePipeline(dataObject)
								//alert("Product Manager")
								}
		    				
							}
	   		    		
		   		    	}
	   		    	else if(startDate == "") {
		    			jAlert('Please Enter Start Date');
		    		}
		    		else if(endDate == "") {
		    			jAlert('Please Enter End Date');
  		    		}
		    		else
			    		{
			    		if((Date.parse(startDate)>= Date.parse(endDate)))
				    		{
			    			jAlert('End Date Must be greater than Start Date');
				    		}
			    		else
				    		{
			    			//var portfolio_id=jQuery("#glbl_portfolio_id").val();
			    			
			    			//jAlert('JSon'+jsonObj);
			    			//var portfolioId =2; //jQuery("#portfolioId").val();
			    				var myObj = {};
				    			myObj["start"] = setDateFormat(endDate);
				    			myObj["end"] = setDateFormat(startDate);
				    			var jsonObj = JSON.stringify(myObj);
				    			var obj = jQuery.parseJSON(jsonObj);
				    			//if(${role != 'PRODUCT MANAGER'})									
						    	 if(${!SecurityUtils.subject.hasRole('PRODUCT MANAGER')})
						    	 {
										refreshAllData(dataObject,portfolio_id,territory_id)
						    	 }
									else
										{
										refreshServicePipeline(dataObject)
										}
				    		}
			    		}
		   		    	});
   		    	function refreshAllData(obj,portfolio_id,territory_id)
   		    	{
   		    		refereshTotalValueofRequestsbyService(obj,portfolio_id,territory_id);
	    			refreshTotalProductsSoldByServiceOffering(obj,portfolio_id,territory_id);
	    			refreshTotalRequestsbyService(obj,portfolio_id,territory_id);
	    			refreshTotalITCostGraphs(obj,portfolio_id,territory_id);
   	   		    	}
		   		function refereshTotalValueofRequestsbyService(obj,portfolio_id,territory_id)
	      		{
		      		
		      		//Total Value of Requests by Service
		      		serviceSalesQuoteChart.showLoading();
					jQuery.ajax({type:'POST',data: {start: obj.start, end: obj.end,portfolio_id:portfolio_id,territory_id:territory_id},
					 url:'${baseurl}/charts/totalSalesSoldGraph',
					 success:function(data,textStatus)
					 {
						 
						 jQuery('#dvSalesSoldGraph').html(data);
						 serviceSalesQuoteChart.hideLoading();
				 	 },
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
		      		}
				function refreshTotalProductsSoldByServiceOffering(obj,portfolio_id,territory_id)
				{
					productsSoldByServiceChart.showLoading();
				
				jQuery.ajax({type:'POST',data: {start: obj.start, end: obj.end,portfolio_id:portfolio_id,territory_id:territory_id},
					 url:'${baseurl}/charts/totalProductSoldGraph',
					 success:function(data,textStatus)
					 {
						// alert(data);
						 jQuery('#dvProductsSoldGraph').html(data);
						 productsSoldByServiceChart.hideLoading();
					 },
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
					}
				function refreshTotalRequestsbyService(obj,portfolio_id,territory_id)
				{
					salesTotalUnitsByServiceMapChart.showLoading();
					
					jQuery.ajax({type:'POST',data: {start: obj.start, end: obj.end,portfolio_id:portfolio_id,territory_id:territory_id},
						 url:'${baseurl}/charts/salesTotalUnitsSoldGraph',
						 success:function(data,textStatus)
						 {
							 jQuery('#dvUnitsSoldGraph').html(data);
							 salesTotalUnitsByServiceMapChart.hideLoading();
						 },
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
					}
		   		jQuery( "#productExceptionBtn" ).click(function() 
				{
		   			jQuery('#dvExceptionReport').html("Loading, Please wait.........");
		   			jQuery('#dvExceptionReport').dialog( "option", "title", 'Exception report of undefined price of territories in products' );
					jQuery("#dvExceptionReport").dialog("open");
		   			jQuery.ajax({type:'POST',
						 url:'${baseurl}/service/productExceptionReport',
						 success:function(data,textStatus)
						 {
							 jQuery('#dvExceptionReport').html(data);
						 },
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
				});

		   		jQuery(".mainChartDiv").css("width",Math.round(jQuery(window).width()*95/100));
				jQuery(".mainChartDiv .leftChartDiv").css("width",Math.round(jQuery(window).width()*47/100));
				jQuery(".mainChartDiv .leftChartDiv .chartBox").css("width",Math.round(jQuery(window).width()*47/100));
				jQuery(".mainChartDiv .rightChartDiv").css("width",Math.round(jQuery(window).width()*47/100));
				jQuery(".mainChartDiv .rightChartDiv .chartBox").css("width",Math.round(jQuery(window).width()*47/100));
				jQuery(".mainChartDiv .fullChartDiv").css("width",Math.round(jQuery(window).width()*94/100)+5);
				jQuery(".mainChartDiv .fullChartDiv .chartBox").css("width",Math.round(jQuery(window).width()*94/100)+5);

				jQuery(".twoRowChartDiv").css("width",Math.round(jQuery(window).width()*95/100));
				jQuery(".twoRowChartDiv .fullChartDiv").css("width",Math.round(jQuery(window).width()*94/100)+5);
				jQuery(".twoRowChartDiv .fullChartDiv .chartBox").css("width",Math.round(jQuery(window).width()*94/100)+5);

				jQuery(".mainExceptionDiv .fullExceptionDiv").css("width",Math.round(jQuery(window).width()*94/100));
				jQuery(".mainExceptionDiv .fullExceptionDiv .exceptionBox").css("width",Math.round(jQuery(window).width()*94/100));
				jQuery(".mainExceptionDiv .fullExceptionDiv .exceptionBox #dvForService").css("width",Math.round(jQuery(window).width()*90/100));
		   	});
	       
			function refreshServicePipeline(obj1)
			{
				serviceFunnelGraph.showLoading();
					
					jQuery.ajax({type:'POST',data: {start: obj1.start, end: obj1.end},
						 url:'${baseurl}/charts/serviceFunnelChart',
						 success:function(data,textStatus)
						 {
							 jQuery('#dvServiceFunnelGraph').html(data);
							 serviceFunnelGraph.hideLoading();
						 },
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
				}
		   	function refreshTotalITCostGraphs(obj, portfolioId,territory_id)
		   	{			
			   //	alert(portfolioId)	
				serviceSoldPiGraph.showLoading();
				serviceSoldLineGraph.showLoading();
				
				jQuery.ajax({type:'POST',data: {start: obj.start, end: obj.end, portfolioId: portfolioId,territory_id:territory_id},
					 url:'${baseurl}/charts/serviceSoldPerPortfolio',
					 success:function(data,textStatus)
					 {
						 jQuery('#dvServiceSoldPiGraph').html(data['piGraphData']);
						 jQuery('#dvServiceSoldLineGraph').html(data['lineGraphData']);
						 //jQuery('#serviceSoldTitle').html("Total IT Cost for Portfolio - " + data['portfolioName']);
						 jQuery('#serviceSoldTitle').html("Transactions - " + data['portfolioName']);
						 
						 serviceSoldPiGraph.hideLoading();
						 serviceSoldLineGraph.hideLoading();
					 },
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});

				itCostPerQuotationLineGraph.showLoading();
				
				jQuery.ajax({type:'POST',data: {start: obj.start, end: obj.end, portfolioId: portfolioId, territory_id:territory_id,currency: '${currency}'},
					 url:'${baseurl}/charts/itCostPerQuotationAndPortfolio',
			success : function(data, textStatus) {
				jQuery('#dvItCostPerQuotationGraph').html(data['graphData']);
				//jQuery('#totalItCostTitle').html("Total IT Cost for Portfolio - " + data['portfolioName']);

				itCostPerQuotationLineGraph.hideLoading();
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
			}
		});
		return false;
	}
</script>
</head>

<body>
	<div>
		<div id="dvExceptionReport"></div>

		<div id="tabsDiv" class="body">
			<ul>
				<li><a href="#dashboard">Dashboard</a></li>
			</ul>


			<div id="dashboard">
				<g:if test="${SecurityUtils.subject.hasRole('PORTFOLIO MANAGER')}">

					<g:if test="${ serviceList?.size()>0}">
						<button id="serviceExceptionBtn" title="Service Exception Report"
							type="button" class="buttons.button button">Service
							Exception</button>
					</g:if>
					<g:if test="${ productList?.size()>0}">
						<button id="productExceptionBtn" title="Product Exception Report"
							type="button" class="buttons.button button">Product
							Exception</button>
					</g:if>

					<hr />
				</g:if>

				<g:if test="${listForServiceDesigner?.size() > 0}">
					<g:render template="/reports/listForServiceDesigner"
						mode="['listForServiceDesigner': listForServiceDesigner]" />
				</g:if>

				<g:elseif
					test="${!SecurityUtils.subject.hasRole('SERVICE DESIGNER')}">
					<div class="chartNav">
						<div class="leftDiv" style="float: left">Charts</div>
						<g:set var="glbl_portfolios"
							value="${serviceSoldPerPortfolioMap['portfolios']}" />
						
						<div style="text-align: right; font-weight: bold;">
							<g:form name="filterChartsForm" class="filterChartsForm">
								<g:if test="${!SecurityUtils.subject.hasRole('PRODUCT MANAGER')}">
								<b> Territory: </b>
								<g:select name="glbl_terrotory_id"
									from="${serviceSoldPerPortfolioMap['territory']}" value=""
									noSelection="${['-1':'None']}" optionKey="id"
									optionValue="name" />
									</g:if>
								<g:if test="${glbl_portfolios?.size() > 1}">
									<b> Portfolio: </b>
									<g:select name="glbl_portfolio_id"
										from="${serviceSoldPerPortfolioMap['portfolios']}" value=""
										optionKey="id" optionValue="portfolioName" />
								</g:if><g:else>
									<g:hiddenField name="glbl_portfolio_id"
										value="${glbl_portfolio?.id}" />
								</g:else>
								<span id="glbl_dataRangeSpan"> Date Range: <select
									id="glbl_dateRange" name="glbl_dateRange"></select></span>
								<span id="searchbydate" style="display: none" readonly="true"> Start Date
									: <g:textField id="startDate" style="width:100px" name="startDate" class="required" />
									End Date : <g:textField id="endDate" name="endDate" style="width:100px"
										class="required" readonly="true"/>
									<button type="button" id="closeSearchByDate"
										class="roundNewButton" title="Close">x</button>
								</span>
								<span class="button"><button type="button"
										id="searchButton" name="Search" title="Filter Data">Search</button></span>
										
								
							</g:form>

						</div>
					</div>
					<g:if test="${salesSoldByServicesMap}">
						<div class="mainChartDiv"
							id="mainChartDivForTotalSalesSoldByServiceOffering">

							<div class="fullChartDiv">
								<div class="chartBox oneRowChartBoxHeight">
									<div class="chartHeader">
										<div class="chartTitle">Total Value of Requests by
											Service</div><%/*<!--Total Sales by Service Offering</div>-->*/%>
										<div class="chartAction">
											<%--<select id="salesSold_dateRange" name="salesSold_dateRange"></select></div>--%>
										</div>
										<div class="chartContent">
											<div id="dvSalesSoldGraph">
												<g:include
													view="/reports/salesSoldInBaseCurrencyByServiceOffering.gsp"
													model="['salesSoldByServicesMap': salesSoldByServicesMap]" />
											</div>
										</div>
									</div>

								</div>

							</div>
					</g:if>

					<g:set var="portfolios"
						value="${serviceSoldPerPortfolioMap['portfolios']}" />
					<g:set var="portfolio"
						value="${serviceSoldPerPortfolioMap['portfolio']}" />

					<g:if
						test="${SecurityUtils.subject.hasRole('PORTFOLIO MANAGER') && portfolios?.size() > 0}">
						<div class="twoRowChartDiv"
							id="mainChartDivForServiceSoldPerPortfolio">

							<div class="fullChartDiv">
								<div class="chartBox twoRowChartBoxHeight">
									<div class="chartHeader">
										<!-- <div id="serviceSoldTitle" class="chartTitle">Total IT Cost for Portfolio - ${portfolio?.portfolioName}</div> -->
										<div id="serviceSoldTitle" class="chartTitle">
											<!-- Total Service Sold for Portfolio -->
											Transactions -
											${portfolio?.portfolioName}
										</div>
										<div class="chartAction"><%--
											<select id="serviceSold_dateRange" name="serviceSold_dateRange"></select>
							                
						                    
						                    <g:if test="${portfolios?.size() > 1}">
							                    <b> Portfolio: &nbsp;</b>
							                    <g:select name="portfolioId" from="${serviceSoldPerPortfolioMap['portfolios']}" value="" optionKey="id" optionValue="portfolioName" />
						                    </g:if>
						                    <g:else>
						                    	<g:hiddenField name="portfolioId" value="${portfolio?.id}" />
						                    </g:else>
										--%></div>
									</div>
									<div class="chartContent">
										<div class="combineChart">
											<div id="dvServiceSoldPiGraph" class="dvLeftChart">
												<g:render template="/reports/serviceSoldPerPortfolioPiGraph" model="['serviceSoldPerPortfolioMap': serviceSoldPerPortfolioMap]"/>
								 			</div>
								 			
								 			<div id="dvServiceSoldLineGraph" class="dvRightChart">
						 						<g:render template="/reports/serviceSoldPerPortfolioLineGraph" model="['serviceSoldPerPortfolioMap': serviceSoldPerPortfolioMap]"/>
							 				</div>
										</div>
										
										<div class="combineChart fullChart" id="dvItCostPerQuotationGraph">
					 						<g:render template="/reports/itCostPerQuotationAndPortfolio" model="['itCostPerQuotationMap': itCostPerQuotationMap]"/>
				 						</div>
									</div>
								</div>
			 				</div>
						</div>
						
						
					</g:if>
				
					<g:if test="${salesTotalUnitsByServiceMap}">
						<div class="mainChartDiv" id="mainChartDivForSalesTotalUnitsByServiceOffering">
							<div class="fullChartDiv">
				 				<div class="chartBox oneRowChartBoxHeight">
									<div class="chartHeader">
										<div class="chartTitle"> Total Requests by Service</div> <!--Sales Total Units By Service Offering</div>-->
										<div class="chartAction"><!-- <select id="unitsSold_dateRange" name="unitsSold_dateRange"></select> -->
										</div>
									</div>
									<div class="chartContent">
										<div id="dvUnitsSoldGraph">
					 						<g:include view="/reports/salesTotalUnitsByServiceOffering.gsp" model="['salesTotalUnitsByServiceMap': salesTotalUnitsByServiceMap]"/>
				 						</div>
									</div>
								</div>
								
			 				</div>
						</div>
					</g:if>
								
					<g:if test="${productsSoldByServiceMap}">
						<div class="mainChartDiv" id="mainChartDivForTotalProductSoldByServiceOffering">
						
							<div class="fullChartDiv">
				 				<div class="chartBox oneRowChartBoxHeight">
									<div class="chartHeader">
										<div class="chartTitle">Total Products Sold By Service Offering</div>
										<%--<div class="chartAction"><select id="productsSold_dateRange" name="productsSold_dateRange"></select></div>--%>
									</div>
									<div class="chartContent">
										<div id="dvProductsSoldGraph">
					 						<g:include view="/reports/productsSoldByService.gsp" model="['productsSoldByServiceMap': productsSoldByServiceMap]"/>
				 						</div>
									</div>
								</div>
								
			 				</div>
						</div>
					</g:if>
					
					<g:if test="${SecurityUtils.subject.hasRole('PRODUCT MANAGER')}">
						<div class="mainChartDiv" id="mainChartDivForServiceDesignerAvgEstVarianceAndServicePipeling">
							<div class="leftChartDiv">
								<div class="chartBox oneRowChartBoxHeight">
									<div class="chartHeader">
										<div class="chartTitle">Service Designer vs Avg Estimates Variance</div>
									</div>
									<div class="chartContent">
										<g:include view="/reports/serviceDesignerVeriance.gsp" model="['serviceDesignerEstimatedVeriance': serviceDesignerEstimatedVeriance]"/>
									</div>
								</div>
							</div> 
						
							<div class="rightChartDiv">
								<div class="chartBox oneRowChartBoxHeight">
									<div class="chartHeader">
										<div class="chartTitle">Service Pipeline</div>
										<!--<div class="chartAction"><select id="serviceFunnel_dateRange" name="serviceFunnel_dateRange"></select></div>-->
									</div>
									<div class="chartContent">
										<div id="dvServiceFunnelGraph">
				 							<g:include view="/reports/serviceFunnel.gsp" params="['serviceFunnelData': serviceFunnelData]"/>
				 						</div>
									</div>
								</div>
								
							</div>
						</div>
					</g:if>
												
							
				</g:elseif>
					
			</div>
			
			
			<g:if test="${assignedPortfolio?.size() > 0}">
				<hr /><div class="box">
					<h1><center>Portfolio Assigned</center></h1><hr>
					 <g:each in="${assignedPortfolio}" status="i" var="portfolio">
				     	${portfolio}<br> 
				     </g:each>
				</div>
			</g:if>
				
		</div>
	</div>	
</body>
</html>