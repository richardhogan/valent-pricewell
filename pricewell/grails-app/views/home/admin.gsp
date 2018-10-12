<%@ page import="grails.converters.JSON"%>
<%
	def baseurl = request.siteUrl
%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <meta name="layout" content="main" />
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
		   	jQuery(document).ready(function() 
		   	{
		   		dateRangeWithCustom('glbl_dateRange', 'This quarter to date', function(val)
	    	      		{
    	      		if(val=='customDate')
        	      		{
        	      		jQuery("#glbl_dataRangeSpan").css("display","none");
        	      		jQuery("#searchbydate").css("display","");
        	      		}
    	      		else
        	      		{
        	      		//alert(val);
    	      			jQuery("#startDate").val("");
    	      			jQuery("#endDate").val("");
    	      			jQuery("#searchbydate").css("display","none");
    	      			//dataObject = jQuery.parseJSON(val);
        	      		}
	    	      		});
	      		jQuery("#closeSearchByDate").click(function()
						{
	      				jQuery("#startDate").val("");
	      				jQuery("#endDate").val("");
	   	      			jQuery("#glbl_dataRangeSpan").css("display","");
		      			jQuery("#searchbydate").css("display","none");
		      			jQuery("select#glbl_dateRange").prop('selectedIndex', 0);
		      			//jQuery("select#glbl_dataRangeSpan")[0].selectedIndex = 0;
		      			//jQuery("#glbl_dataRangeSpan").val("This quarter to date");
	   	      			}
	   	    	      		);
				jQuery( "#tabsDiv" ).tabs();
				
				jQuery("#notifications").hide();
				
				
				dateRange('salesVarianceDateRange', 'This quarter to date', function(val)
		     	{
					var obj = jQuery.parseJSON(val);
					//In order to get selected text
					//alert(jQuery("#pendinDays_dateRange option:selected").text());
					

							return false;
	      		});
				jQuery("#searchButton").click(function()
		   		    	{
	      				//var territory_id=jQuery("#salesTerritoryId").val();
	   		    		var startDate=jQuery("#startDate").val();
	   		    		var endDate=jQuery("#endDate").val();
	   		    		var startDateVal = new Date(jQuery('#startDate').val());
	   		    		var endDateVal = new Date(jQuery('#endDate').val());

	   		    		
	   		    		var dateRange=jQuery("#glbl_dateRange").val();
	   		    	if(startDate=="" && endDate=="" )
	   		    	{
	   		    		if(dateRange=="customDate")
						{
						
						jAlert("Please Enter Start Date And End Date")
						}
					else
						{
						territoryChanged = true;
		      			if(territoryChanged == true)
			  		    {
				  		    //showLoadingBox();
				  		}
						var dataObject = jQuery.parseJSON(dateRange);
						//alert(dataObject);
						//alert(dateRange)
	    				//refreshAllData(dataObject,territory_id)
						refreshAllData(dataObject);
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
			    		//alert((Date.parse(startDate)>= Date.parse(endDate)))
			    		if(startDateVal>= endDateVal)
				    		{
			    			jAlert('End Date Must be greater than Start Date');
				    		}
			    		else
				    		{
				    		
			    			var myObj = {};
			    			myObj["start"] = setDateFormat(endDate);
			    			myObj["end"] = setDateFormat(startDate);
			    			var jsonObj = JSON.stringify(myObj);
			    			//alert(jsonObj)
			    			var obj = jQuery.parseJSON(jsonObj);
			    			//alert(jsonObj);
			    			//refreshAllData(obj,territory_id)
			    			refreshAllData(obj)
				    		}
			    		}
		   		    	});
				jQuery("#opportunityId").change(function () 
   		    	{
					serviceVarianceChart.showLoading();
	    			jQuery.ajax({type:'POST',data: {opportunityId: jQuery("#opportunityId").val()},
		   				 url:'${baseurl}/charts/getOpportunityServiceVariance',
		   				 success:function(data,textStatus)
		   				 {
		   					 jQuery('#dvServiceVariance').html(data);
		   					serviceVarianceChart.hideLoading();
		   					 
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
			});

			function refreshExceptionReport()
			{
				jQuery.ajax({type:'POST',
	   				 url:'${baseurl}/charts/refreshUnassignedExceptionReport',
	   				 success:function(data,textStatus)
	   				 {
	   					 jQuery('#dvExceptionGraph').html(data);	   					 
	   				 },
	   				 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
			}
			
			function refreshAllData(obj)
		    	{
					refreshAccountStatusbyRole(obj);
					refreshComplaintTransactions(obj);
					if(${serviceVarianceMap['opportunityList'].size() > 0})
						{
					refreshSalesVariance(obj);
		    	}
		    		refereshRecentUserActivity(obj);
					
    			}
		    	function refereshRecentUserActivity(obj)
		    	{
					jQuery("#recentUserActivity").css("display","none");
					jQuery("#loadingUser").css("display","");
		    		//recentUserActivity.showLoading();
					jQuery.ajax({type:'POST',data: {start: obj.start, end: obj.end},
					 url:'${baseurl}/charts/recentUserActivity',
					 success:function(data,textStatus)
					 {
						 
						// jQuery('#dvSalesSoldGraph').html(data);
							
							jQuery('#dvRecentUserActivity').html('').html(data);
						 	jQuery("#recentUserActivity").css("display","");
							jQuery("#loadingUser").css("display","none");
				 	 },
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;

			    	}
		    	function refreshComplaintTransactions(obj)
		    	{
					vsoeDiscountingGraph.showLoading();
					
					jQuery.ajax({type:'POST',data: {start: obj.start, end: obj.end},
						 url:'${baseurl}/charts/VSOEDiscount',
						 success:function(data,textStatus)
						 {
							 jQuery('#dvVsoeGraph').html(data);
							 vsoeDiscountingGraph.hideLoading();
						 },
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
			    	}
		    	
		    	function refreshAccountStatusbyRole(obj)
		    	{

		    		chart1.showLoading();
					
					jQuery.ajax({type:'POST',data: {start: obj.start, end: obj.end},
						 url:'${baseurl}/charts/accountStatusbyRole',
						 success:function(data,textStatus)
						 {
							 //alert(data)
							 jQuery('#dvAccountStatusbyRole').html('');
							 //alert(jQuery('#dvAssignedPortfoliosbyPortfolioManager').html())
							  jQuery('#dvAccountStatusbyRole').html(data);
							  chart1.hideLoading();
						 },
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;


			    	}
		    	function refreshSalesVariance(obj)
		    	{

		    		serviceVarianceChart.showLoading();
					
					jQuery.ajax({type:'POST',data: {start: obj.start, end: obj.end,opportunityId: jQuery("#opportunityId").val()},
						 url:'${baseurl}/charts/salesVarianceWithDate',
						 success:function(data,textStatus)
						 {
							 //alert(data)
							 jQuery('#dvServiceVariance').html('');
							 //alert(jQuery('#dvAssignedPortfoliosbyPortfolioManager').html())
							  jQuery('#dvServiceVariance').html(data);
							 serviceVarianceChart.hideLoading();
						 },
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
			    	}
	   	</script>	
	</head>
	
	<body>
	 	<div id="tabsDiv" class="body">
	 		<ul>
	 			<li><a href="#dashboard">Dashboard</a></li>
			</ul>
				
			
			<div id="dashboard">
			<div class="chartNav">
						<div class="leftDiv" style="float: left">Charts</div>
						
						
						<div style="text-align: right; font-weight: bold;">
														
								
								
									
								
								<span id="glbl_dataRangeSpan"> Date Range: <select
									id="glbl_dateRange" name="glbl_dateRange"></select></span>
								<span id="searchbydate" style="display: none" > Start Date
									: <g:textField id="startDate" name="startDate" class="required"  readonly="true"/>
									
									End Date : <g:textField id="endDate" name="endDate"
										readonly="true" class="required" />
									<button type="button" id="closeSearchByDate"
										class="roundNewButton" title="Close">x</button>
								</span>
								<span class="button"><button type="button"
										id="searchButton" name="Search" title="Filter Data">Search</button></span>
										
								
						

						</div>
						</div>
				
				<!--<g:if test="${notificationList.size() > 0}">
					<h1 style="color:red">You Have ${notificationList.size()} Pending <g:if test="${notificationList.size()==1}">Notification. </g:if><g:else>Notifications. </g:else>
					Click <a href="#"  class="hyperlink notification">Here</a> To View</h1><hr />
				</g:if>-->
				
				<div class="mainChartDiv" id="mainChartDivForAccountStatusAndAssignedPortfolios">
					<g:if test="${accountStatusByRoleData}">
						<div class="leftChartDiv">
							<div class="chartBox oneRowChartBoxHeight">
								<div class="chartHeader">
									<div class="chartTitle">Account Status by Role</div>
								</div>
								<div id="dvAccountStatusbyRole">
									<g:include view="/reports/accountStatus.gsp" model="['accountStatusByRoleData': accountStatusByRoleData]"/>
								</div>
							</div>
						</div> 
					</g:if>
					
					<g:if test="${assignedPortfolios}">
						<div class="rightChartDiv">
							<div class="chartBox oneRowChartBoxHeight">
								<div class="chartHeader">
									<div class="chartTitle">Assigned Portfolios by Portfolio Manager</div>
								</div>
								<div id="dvAssignedPortfoliosbyPortfolioManager">
									<g:include view="/reports/portfolioAssignment.gsp" model="['assignedPortfolios': assignedPortfolios]"/>
								</div>
							</div>
							
						</div>
					</g:if>
				</div>
				
				<g:if test="${serviceVarianceMap['opportunityList'].size() > 0}">
					<div class="mainChartDiv" id="mainChartForServiceVariance">
			 			<div class="fullChartDiv">
							<div class="chartBox oneRowChartBoxHeight">
								<div class="chartHeader">
									<!-- <div class="combineTitleAndAction">
										<div class="title">Service Variance (%) For Opportunity</div>
										<div class="action">
											<g:select name="opportunityId" from="${serviceVarianceMap['opportunityList']}" value="" optionKey="id" optionValue="name" />
											<select id="salesVarianceDateRange" name="salesVarianceDateRange"></select>
										</div>
									</div> -->
									
									<div class="chartTitle">
										Service Variance (%) For Opportunity: 
										<g:select name="opportunityId" style="font-size: 10px;" from="${serviceVarianceMap['opportunityList']}" value="" optionKey="id" optionValue="name" />
									</div>
									
									<!--<div class="chartAction">
										<select id="salesVarianceDateRange" name="salesVarianceDateRange"></select>
									</div>-->
								</div>
								<div class="chartContent">
									<div id="dvServiceVariance">
										<g:render template="/reports/serviceVariance" mode="['serviceVarianceMap': serviceVarianceMap]"/>
									</div>
								</div>
							</div>
							
						</div>
		 			</div>
	 			</g:if>
	 			
				<div class="mainChartDiv" id="mainChartDivForVSOEChartAndLoginRecord">
		 			<div class="leftChartDiv">
		 				<div class="chartBox oneRowChartBoxHeight">
							<div class="chartHeader">
								<div class="chartTitle">Compliant Transactions (%)</div>
								<div class="chartAction"><!--  <select id="vsoe_dateRange" name="vsoe_dateRange"></select>--></div>
							</div>
							<div class="chartContent">
								<div id="dvVsoeGraph">
			 						<g:include view="/reports/VSOEDiscounting.gsp" model="['totaldiscount': totaldiscount]"/>
		 						</div>
							</div>
						</div>
						
	 				</div>
	 				
	 				<div class="rightChartDiv">
		 				<div class="chartBox oneRowChartBoxHeight">
							<div class="chartHeader">
								<div class="chartTitle">Recent User Activity</div>								
							</div>
							<div class="chartContent">
								<div id="dvRecentUserActivity" style="height: 250; width: 200;">
			 						<g:render template="/reports/recentActivity" model="['recentLoginList': recentLoginList]"/>
		 						</div>
							</div>
						</div>
	 				</div>
	 								
		 		</div>	
		 		
		 		<div class="mainChartDiv" id="mainChartDivForExceptionReport">
		 			<div class="leftChartDiv">
		 				<div class="chartBox oneRowChartBoxHeight">
							<div class="chartHeader">
								<div class="chartTitle">Unassigned Exception</div>
								<div class="chartAction"></div>
							</div>
							<div class="chartContent">
								<div id="dvExceptionGraph">
			 						<g:render template="/reports/unassignExceptionReport" model="['unassignException': unassignException]"/>
		 						</div>
							</div>
						</div>
						
	 				</div>
	 						
		 		</div>	
		 		
			</div>
			
		</div>
	</body>
</html>