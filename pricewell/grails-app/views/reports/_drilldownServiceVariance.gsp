<%@ page import="grails.converters.JSON"%>
<%
	def baseurl = request.siteUrl
%>
<html>

    <script>
    	var drilldownServiceVarianceChart;
    	jQuery(document).ready(function() 
		{
    		jQuery( "#backBtn" ).click(function() 
			{
    			drilldownServiceVarianceChart.showLoading();
    			jQuery.ajax({type:'POST',data: {opportunityId: jQuery("#opportunityId").val()},
	   				 url:'${baseurl}/charts/getOpportunityServiceVariance',
	   				 success:function(data,textStatus)
	   				 {
	   					 jQuery('#dvServiceVariance').html(data);
	   					 drilldownServiceVarianceChart.hideLoading();
	   					 
	   				 },
	   				 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
			});

    		drilldownServiceVarianceChart = new Highcharts.Chart(
    	    {
    		    
    	    	chart: {
    	    		renderTo: 'drilldownServiceVarianceChartDv',
					type: 'column',
					height: 300,
					width: Math.round(jQuery(window).width()*92/100)+10,//Math.round(jQuery(window).width()*45/100),
					backgroundColor:'transparent',
					marginTop: 50
                },
                title: {
                    text: 'Drilldown Service : <%=activityRoleHoursMap['serviceName']%>'
                },
                xAxis: {
                    categories: <%= activityRoleHoursMap['categories'] as JSON%>,
                    labels: {
                        formatter: function() {
                            return getModifiedCategory(this.value);
                        },
                        rotation: -30
                    }
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
                        return '<b>'+ getModifiedX(this.x) +'</b><br/>'+
                            this.series.name +': '+ this.y+'<br>Note : Click to explore it.';
                    }
                },
                plotOptions: {
                	column: {
                        stacking: 'normal',
                        cursor: 'pointer',
            			point: {
							events: {
								click: function(){
									drilldownActivityRoleTimeFn(this.category);
								}
							}
		            	}
                        
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
       	
    	function drilldownActivityRoleTimeFn(category)
       	{
    		drilldownServiceVarianceChart.showLoading();
       		jQuery.ajax({type:'POST',data: {serviceName: '${activityRoleHoursMap['serviceName']}', opportunityId: jQuery("#opportunityId").val(), activityRoleString: category},
				 url:'${baseurl}/charts/drilldownActivityRoleTime',
				 success:function(data,textStatus)
				 {
					 jQuery('#dvServiceVariance').html(data);
					 drilldownServiceVarianceChart.hideLoading();
				 },
				 error:function(XMLHttpRequest,textStatus,errorThrown){}});
			 return false;
        }

        function getModifiedCategory(str)
        {
        	var res = str.split("--");
			var act = res[0].substring(0, 4);
			var role = res[1].substring(0, 4)
			return act+"...-"+role+"..."
        }
        
        function getModifiedX(str)
        {
        	var res = str.split("--");
        	var resStr = "Activity : "+res[0]+", "+"Role : "+res[1];
        	//'<b>'+ res[0]+", Activity : "+res[1]+", "+"</b><br><b>Role : "+res[2]+"</br>";
            return resStr;
        }
  	</script>
	
	<div>
		<button id="backBtn" class="buttons.button button" title="Back To Service">Back</button>
		<div id="drilldownServiceVarianceChartDv">
	 		
	 	</div>
	</div>
 	

</html>