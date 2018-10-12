<%@ page import="grails.converters.JSON"%>
<%
	def baseurl = request.siteUrl
%>
<html>

    <script>
    	var drilldownActivityRoleTimeChart;
    	jQuery(document).ready(function() 
		{
    		jQuery( "#backToActivityBtn" ).click(function() 
			{
    			drilldownActivityRoleTimeChart.showLoading();
    			jQuery.ajax({type:'POST',data: {serviceName: '${activityRoleHoursMap['serviceName']}', opportunityId: jQuery("#opportunityId").val()},
	   				 url:'${baseurl}/charts/drilldownServiceVariance',
	   				 success:function(data,textStatus)
	   				 {
	   					 jQuery('#dvServiceVariance').html(data);
	   					 drilldownActivityRoleTimeChart.hideLoading();
	   				 },
	   				 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
			});

    		drilldownActivityRoleTimeChart = new Highcharts.Chart(
    	    {
    		    
    	    	chart: {
    	    		renderTo: 'drilldownActivityRoleTimeChartDv',
					type: 'column',
					height: 300,
					width: Math.round(jQuery(window).width()*92/100)+10,//Math.round(jQuery(window).width()*45/100),
					backgroundColor:'transparent',
					marginTop: 50
                },
                title: {
                    text: 'Drilldown <%=activityRoleHoursMap['activityRoleName']%>'
                },
                xAxis: {
                    categories: <%= activityRoleHoursMap['categories'] as JSON%>
                },
                yAxis: {
                    min: 0,
                    title: {
                        text: 'Total Hours'
                    }
                },
                legend: {
                	enabled: 'true'
                },
                tooltip: {
                    formatter: function() {
                        return '<b>'+ this.x +'</b><br/>'+
                            this.series.name +': '+ this.y;
                    }
                },
                plotOptions: {
                	column: {
                        stacking: 'normal'
                        
                    }
                },
                series: [{
                    name: 'Budget Hours',
                    data: <%= activityRoleHoursMap['budgetHours'] as JSON%>,
                	stack: 'budget'
                }, {
                    name: 'Actual Hours',
                    data: <%= activityRoleHoursMap['actualHours'] as JSON%>,
                    stack: 'actual'
                }]
            });
		});
       	

        
  	</script>
	
	<div>
		<button id="backToActivityBtn" class="buttons.button button" title="Back To Service Drilldown">Back</button>
		<div id="drilldownActivityRoleTimeChartDv">
	 		
	 	</div>
	</div>
 	

</html>