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
    		.leftDiv {
    			float: left;
    			width: 50%;
    			font-weight:bold;
    			font-size: large;
			}
			
			.rightDiv {
				float: left;
				padding-left: 5px;
				text-align: right;
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
      		 var territoryChanged = false;
       		var chart1; // globally available
      		jQuery(document).ready(function() 
      	    {
          	   
				jQuery('.blink').blink();
				
	      		jQuery( "#tabsDiv" ).tabs();

	      		jQuery("#quotes").dialog({ autoOpen: false, height: 500, minWidth: 1200 });
	      	
	      		function refreshQuotaChart(range)
		    	{
			    	//alert(range)
		    		var territoryId = jQuery("#salesTerritoryId").val();
		    		/*var territoryId = "";
			    	var range = this.value;
			    	if(jQuery("#territory").val())
			    		{territoryId = jQuery("#territory").val();}*/
			    	quotaChartGraph.showLoading();
			    	
		    		jQuery.ajax({type:'POST',data: {range: range, territoryId: territoryId },
						 url:'${baseurl}/charts/getQuotaAssignedVsQuotaAchivementChartData',
						 success:function(data,textStatus)
						 {
							 jQuery('#dvQuotaChart').html(data);
							 quotaChartGraph.hideLoading();

							 if(${!SecurityUtils.subject.hasRole('SALES PERSON')})
					    	 {
						    	 quotaAssignedVsQuotaAchivedPerPersonChart.showLoading();
							 	 quotaPerPersonGraphChanges(range, territoryId);
					    	 }
						 },
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});
			    }
			    
	      		function quotaPerPersonGraphChanges(range, territoryId)
	      		{
	      			jQuery.ajax({type:'POST',data: {range: range, territoryId: territoryId },
						 url:'${baseurl}/charts/getQuotaAssignedVsQuotaAchivementPerPersonChartData',
						 success:function(data,textStatus)
						 {
							 jQuery('#dvQuotaChartPerPerson').html(data);
							 quotaAssignedVsQuotaAchivedPerPersonChart.hideLoading();

							 
						 },
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});
						 return false;
		      	}		
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
	   	      			}
	   	    	      		);
	      		jQuery("#searchButton").click(function()
		   		    	{
	      				var territory_id=jQuery("#salesTerritoryId").val();
	   		    		var startDate=jQuery("#startDate").val();
	   		    		var endDate=jQuery("#endDate").val();
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
	    				refreshAllData(dataObject,territory_id)
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
			    		if(startDate>= endDate)
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
			    			refreshAllData(obj,territory_id)
			    			
				    		}
			    		}
		   		    	});
	      		
	      		function refreshAllData(dataObject,territory_id)
	      		{
	      			territoryChanged = true;
	      			if(territoryChanged == true)
		  		    {
			  		    //showLoadingBox();
			  		}
	      			refreshQuarterlySalesChartWithDate(dataObject,territory_id);
	      			refreshleadFunnelWithDate(dataObject,territory_id);
	      			 if(${role != 'SALES PERSON'})
		      			 {
		      			 // alert(dataObject)
		      			refreshQuotaChartwithDate(dataObject,territory_id)
		      			 }
		      	}
	      		
		      		
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
      		function refreshQuarterlySalesChartWithDate(dataObject,territory_id)
      		{
	      			var startDate=dataObject.start
	      			var endDate=dataObject.end
					quarterlyTotalSalesChart.showLoading();
				
					jQuery.ajax({type:'POST',
					 url:'${baseurl}/charts/quarterlySaleswithDate',
					 data: {start: startDate, end: endDate,territory_id:territory_id},
					 success:function(data,textStatus)
					 {
						 jQuery('#dvQuarterlyTotalSalesGraph').html(data);
						 //alert("in quota chare");
						 quarterlyTotalSalesChart.hideLoading();
						 if(territoryChanged == true)
						 {
							// alert("In quartelt")
							// alert("in quota chare");
							 //if(${SecurityUtils.subject.hasRole('SALES MANAGER')} || ${SecurityUtils.subject.hasRole('SALES PERSON')})
							 if(${role == 'SALES MANAGER'} || ${role == 'SALES PERSON'})
							 {
								 	//var startDate=jQuery("#startDate").val();
					      			//var endDate=jQuery("#endDate").val();
					      			//var territoryId = jQuery("#salesTerritoryId").val();
					      			//startDate=startDate.split("/").reverse().join("-");
					      			//alert("startDate "+startDate);
					      			//endDate=endDate.split("/").reverse().join("-");
								// alert("in quotachart");
								 refreshDealStatusChartWithDate(dataObject,territory_id);
								 //refreshQuotaChartwithDate();
								 //refreshVSOEChartWithDate(startDate,endDate);
							 }
							 else
							 {
								// alert("hello")
								refreshDealStatusAgingChartWithDate(dataObject,territory_id);
							 }
							 
						 }
					 },
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});
	      	}
	      	function refreshDealStatusChartWithDate(dataObject,territory_id)
	      	{
	      		dealStatusGraph.showLoading();
				
				jQuery.ajax({type:'POST',data: {start: dataObject.start, end: dataObject.end, territoryId: territory_id},
					 url:'${baseurl}/charts/dealStatusChart',
					 success:function(data,textStatus)
					 {
						 //alert("success");
						 jQuery('#dealStatusChart').html(data);
						 dealStatusGraph.hideLoading();
				
						 if(territoryChanged == true)
						 {
							refreshOpportunityFunnelChartWithDate(dataObject,territory_id);
						 }
					 },
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});
		      	}
	      	function refreshDealStatusAgingChartWithDate(dataObject,territory_id)
	      	{
	      		dealStatusAgingGraph.showLoading();
				
				jQuery.ajax({type:'POST',data: {start: dataObject.start, end: dataObject.end,territoryId: territory_id},
					 url:'${baseurl}/charts/dealStatusAging',
					 success:function(data,textStatus)
					 {
						 jQuery('#dealStatusAgingGraph').html(data);
						 dealStatusAgingGraph.hideLoading();
						 
						 if(territoryChanged == true)
						 {
							 refreshDealStatusChartWithDate(dataObject,territory_id);
						 }
					 },
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});
		      	}
	      	function refreshOpportunityFunnelChartWithDate(dataObject,territory_id)//dateVal)
      		{
      			//var obj1 = jQuery.parseJSON(dateVal);
      			//var territoryId = jQuery("#salesTerritoryId").val();
					//alert(obj1.start + " " + obj1.end);
					opportunityFunnelGraph.showLoading();
					
					jQuery.ajax({type:'POST',data: {start: dataObject.start, end: dataObject.end, territoryId: territory_id},
						 url:'${baseurl}/charts/opportunityFunnelChart',
						 success:function(data,textStatus)
						 {
							 jQuery('#dvOpportunityFunnelGraph').html(data);
							 opportunityFunnelGraph.hideLoading();

							if(territoryChanged == true)
						{
								refreshVSOEChartWithDate(dataObject,territory_id);
						}
						 },
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});
		    }
      		function refreshVSOEChartWithDate(dateObject,territory_Id)
      		{
      			//var obj = jQuery.parseJSON(dateVal);
      			//var territoryId = jQuery("#salesTerritoryId").val();
				
				vsoeDiscountingGraph.showLoading();
				
				jQuery.ajax({type:'POST',data: {start: dateObject.start, end: dateObject.end, territoryId: territory_Id},
					 url:'${baseurl}/charts/VSOEDiscount',
					 success:function(data,textStatus)
					 {
						 jQuery('#dvVsoeGraph').html(data);
						 vsoeDiscountingGraph.hideLoading();

						 if(territoryChanged == true)
						 {
							 //hideLoadingBox();
							 territoryChanged = false;
						 }
					 },
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});
	      	}
      		function refreshQuotaChartwithDate(dateObject,territory_Id)
	    	{
		    	//alert("in refereshQuotawithDate")
	    		//var territoryId = jQuery("#salesTerritoryId").val();
	    		/*var territoryId = "";
		    	var range = this.value;
		    	if(jQuery("#territory").val())
		    		{territoryId = jQuery("#territory").val();}*/
		    	quotaChartGraph.showLoading();
		    	
	    		jQuery.ajax({type:'POST',data:{start: dateObject.start, end: dateObject.end, territoryId: territory_Id},
					 url:'${baseurl}/charts/getQuotaAssignedVsQuotaAchivementChartDataWithDate',
					 success:function(data,textStatus)
					 {
						 jQuery('#dvQuotaChart').html(data);
						 quotaChartGraph.hideLoading();

						 //if(${!SecurityUtils.subject.hasRole('SALES PERSON')})
						 if(${role != 'SALES PERSON'})									
				    	 {
					    	 quotaAssignedVsQuotaAchivedPerPersonChart.showLoading();
					    	 quotaPerPersonGraphChangesWithDate(dateObject,territory_Id);
				    	 }
					 },
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});
		    }
      		function quotaPerPersonGraphChangesWithDate(dateObject,territory_Id)
      		{
      			jQuery.ajax({type:'POST',data:{start: dateObject.start, end: dateObject.end, territoryId: territory_Id},
					url:'${baseurl}/charts/getQuotaAssignedVsQuotaAchivementPerPersonChartDataWithDate',
					 success:function(data,textStatus)
					 {
						 jQuery('#dvQuotaChartPerPerson').html(data);
						 quotaAssignedVsQuotaAchivedPerPersonChart.hideLoading();

						
					 },
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});
					 return false;
	      	}
	      	function refreshleadFunnelWithDate(dateObject,territory_Id)
	      	
	      		{
   					//var obj1 = jQuery.parseJSON(dateVal);
   					//alert(obj1.start + " " + obj1.end);
   					leadFunnelGraph.showLoading();
   					//alert("Loading");
   					jQuery.ajax({type:'POST',data: {start: dateObject.start, end: dateObject.end,territory_Id:territory_Id},
   						 url:'${baseurl}/charts/leadFunnelChartWithDate',
   						 success:function(data,textStatus)
   						 {
   							 jQuery('#dvLeadFunnelGraph').html(data);
   							leadFunnelGraph.hideLoading();
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
						<div class="chartNav">
				
					
					<div style="text-align: right; font-weight:bold;">
					<div style="text-align: left;"> Charts </div>
						<%--<g:if test="${role == 'SALES PERSON' }">--%>
						<g:if test="${SecurityUtils.subject.hasRole('SALES PERSON')}">
							<g:hiddenField name="salesTerritoryId" value="${defaultTerritory?.id}" />
							Territory : ${defaultTerritory?.name }
						</g:if>
						<g:else>
							
							Select Territory : <g:select name="salesTerritoryId" from="${territoryList}" value="${defaultTerritory?.id}" optionKey="id" optionValue="name" />
							</g:else>
							<span id="glbl_dataRangeSpan"> Date Range: <select
									id="glbl_dateRange" name="glbl_dateRange"></select></span>
								<span id="searchbydate" style="display: none"> Start Date
									: <g:textField id="startDate" name="startDate" class="required" readonly="true" />
									End Date : <g:textField id="endDate" name="endDate"
										class="required" readonly="true"/>
									<button type="button" id="closeSearchByDate"
										class="roundNewButton" title="Close">x</button>
								</span>
							 <span class="button"><button type="button" id="searchButton" name="Search" title="Filter Data">Search</button></span>
							
						
						 
					</div>
				</div>
				<br/>
				
				
		 		<div class="mainChartDiv">
		 			<div class="leftChartDiv">
						<div class="chartBox oneRowChartBoxHeight">
							<div class="chartHeader">
								<div class="chartTitle">Quarterly Total Sales</div>
								<div class="chartAction"></div>
							</div>
							<div class="chartContent">
								<div id="dvQuarterlyTotalSalesGraph">
			 						<g:include view="/reports/quarterlyTotalSalesBySalesUser.gsp" params="['quarterlyTotalSalesMap': quarterlyTotalSalesMap, 'currency': currency]"/>
		 						</div>
							</div>
						</div>
					</div>
					
					<g:if test="${!SecurityUtils.subject.hasRole('SALES PERSON')}">
						<div class="rightChartDiv">
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
					</g:if>
					
					<g:if test="${SecurityUtils.subject.hasRole('SALES PERSON')}">
						<div class="rightChartDiv">
							<div class="chartBox oneRowChartBoxHeight">
								<div class="chartHeader">
									<div class="chartTitle">
										Quota Assigned Vs Quota Achieved
									</div>
										
									<div class="chartAction">
									<!--  <g:select name="quotaDateRange" from="['First to this quarter', 'Previous to this quarter',
					                           								 'First quarter', 'Previous quarter', 'This quarter',
					                           								 'Next quarter', 'Last quarter', 'This to next quarter',
					                           								 'This to last quarter', 'Previous year', 'This year', 'Next year']"  value='This quarter' noSelection="['': 'Select Any One...']" />
				                        -->	
									</div>
								</div>
								<div class="chartContent">
									
									<div id="dvQuotaChart">
					 					<g:if test="${quotaData['Greater'] != '' && quotaData['Greater'] != null}">
						 					<g:if test="${quotaData['Greater'] == 'assigned'}">
						 						<g:include view="/reports/quotaAssignedVsQuotaAchivementGraph.gsp"/>
					 						</g:if>
					 						<g:elseif test="${quotaData['Greater'] == 'achieved'}">
					 							<g:include view="/reports/quotaAssignedVsQuotaAchivementGraph2.gsp"/>
					 						</g:elseif>
				 						</g:if>
						 			</div>
									
								</div>
							</div>
						</div> 
					</g:if>
	 			</div>
	 			
	 			<g:if test="${!SecurityUtils.subject.hasRole('SALES PERSON')}">
					<div class="mainChartDiv" id="mainChartDivForQuotaAssignVsQuotaAchievedIncludingPerPerson">
					
						<div class="fullChartDiv">
			 				<div class="chartBox oneRowChartBoxHeight">
								<div class="chartHeader">
									<div class="chartTitle">Quota Assigned Vs Quota Achieved Including Per Person</div>
									<div class="chartAction">
										<!--<g:select name="quotaDateRange" from="['First to this quarter', 'Previous to this quarter',
					                           								 'First quarter', 'Previous quarter', 'This quarter',
					                           								 'Next quarter', 'Last quarter', 'This to next quarter',
					                           								 'This to last quarter', 'Previous year', 'This year', 'Next year']"  value='This quarter' noSelection="['': 'Select Any One...']" />
					                    -->
					                    <!--<g:set var="territories" value="${quotaData['territoryList']}" />
					                    <g:if test="${territories}">whenever modify please add size after territories with greater 1
						                    <b> Territory: &nbsp;</b>
						                    <g:select name="territory" from="${quotaData['territoryList']}" value="" optionKey="id" optionValue="name" />
					                    </g:if>-->
									</div>
								</div>
								<div class="chartContent">
									<div class="combineChart">
										<div id="dvQuotaChart" class="dvLeftChart">
						 					<g:if test="${quotaData['Greater'] != '' && quotaData['Greater'] != null}">
							 					<g:if test="${quotaData['Greater'] == 'assigned'}">
							 						<g:include view="/reports/quotaAssignedVsQuotaAchivementGraph.gsp"/>
						 						</g:if>
						 						<g:elseif test="${quotaData['Greater'] == 'achieved'}">
						 							<g:include view="/reports/quotaAssignedVsQuotaAchivementGraph2.gsp"/>
						 						</g:elseif>
					 						</g:if>
							 			</div>
							 			
							 			<div id="dvQuotaChartPerPerson" class="dvRightChart">
					 						<g:include view="/reports/quotaAssignedVsQuotaAchivementPerPerson.gsp"/>
						 				</div>
									</div>
								</div>
							</div>
		 				</div>
					</div>
				</g:if>
				
				<div class="mainChartDiv" id="mainChartDivForDealStatusAndDealStatusAgingGraph">
					<div class="leftChartDiv">
						<div class="chartBox oneRowChartBoxHeight">
							<div class="chartHeader">
								<div class="chartTitle">Deal Status Aging Graph</div>
							</div>
							<div class="chartContent">
								<div id="dealStatusAgingGraph_dateRange"></div>
					 			<div id="dealStatusAgingGraph">
					 				<g:include view="/reports/dealStatusAgingGraph.gsp" model="['pendingDaysMap': pendingDaysMap]"/>
				 				</div>
				 				
				 				<!-- <center>
							 			<a class="cbuttons" style="color: white;" href="javascript:" onclick="jQuery('#quotes').dialog('open')">View Details</a>
									</center>
												
						 			<div id="quotes"  style="width: 450px; height: 350px">  
						 				<g:render template="/quotation/listPending"/>
						 		 	</div> -->
							</div>
						</div>
					</div> 
					
					<div class="rightChartDiv">
						<div class="chartBox oneRowChartBoxHeight">
							<div class="chartHeader">
								<div class="chartTitle">Deal Status</div>
								<div class="chartAction"><!-- <select id="dealStatus_dateRange" name="dealStatus_dateRange"></select> --> </div>
							</div>
							<div class="chartContent">
								<div id="dealStatusChart">
			 						<g:render template="/reports/dealStatus" model="['quoteTypesMap': quoteTypesMap]"/>
		 						</div>
		 						
							</div>
						</div>
					</div> 
				</div>
				
				<div class="mainChartDiv" id="mainChartDivForOpportunityAndLeadPipeline">
		 			<div class="leftChartDiv">
				
						<div class="chartBox oneRowChartBoxHeight">
							<div class="chartHeader">
								<div class="chartTitle">Opportunity Pipeline</div>
								<!--<div class="chartAction"><select id="opportunityFunnel_dateRange" name="opportunityFunnel_dateRange"></select> </div>-->
							</div>
							<div class="chartContent">
								<div id="dvOpportunityFunnelGraph">
		 							<g:include view="/reports/opportunityFunnel.gsp" params="['opportunityFunnelData': opportunityFunnelData]"/>
		 						</div>
							</div>
						</div>
					</div>
					
					<div class="rightChartDiv">
						<div class="chartBox oneRowChartBoxHeight">
							<div class="chartHeader">
								<div class="chartTitle">Lead Pipeline</div>
								<!--<div class="chartAction"><select id="leadFunnel_dateRange" name="leadFunnel_dateRange"></select> </div>-->
							</div>
							<div class="chartContent">
								<div id="dvLeadFunnelGraph">
		 							<g:include view="/reports/leadFunnel.gsp" params="['leadFunnelData': leadFunnelData]"/>
		 						</div>
							</div>
						</div>
					</div>
	 			</div>
			
				<g:if test="${SecurityUtils.subject.hasRole('SALES PERSON')}">
					<div class="mainChartDiv">
						<div class="leftChartDiv">
							<div class="chartBox oneRowChartBoxHeight">
								<div class="chartHeader">
									<div class="chartTitle">Compliant Transactions (%)</div>
									<div class="chartAction"><select id="vsoe_dateRange" name="vsoe_dateRange"></select></div>
								</div>
								<div class="chartContent">
									<div id="dvVsoeGraph">
				 						<g:include view="/reports/VSOEDiscounting.gsp" model="['totaldiscount': totaldiscount]"/>
			 						</div>
								</div>
							</div>
						</div>						
					</div>
				</g:if>
				
	 			
			</div>
			
			
	</div>
 </body>
 
 
 
 