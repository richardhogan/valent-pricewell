<%@ page import="grails.converters.JSON"%>
<html>
	<script>
		 var chart2; // globally available
	      	jQuery(document).ready(function()
	      	{
	
	             chart2 = new Highcharts.Chart({
	
	                chart: {
	
	                   renderTo: 'portfolioAssignment',
	
	                   type: 'bar',
						height: 300,
						width: Math.round(jQuery(window).width()*45/100),
						backgroundColor:'transparent',
						marginTop: 50
	
	                },
	
	                title: {
	
	                   text: ''//'Assigned Portfolios by Portfolio Manager'
	
	                },
	
	                xAxis: {
	
	                   categories: ["Portfolio Manager"]
	                  
	                },
	
	                yAxis: {
	
	                   title: {
	
	                      text: '<b>Portfolio Assigned</b>'
	
	                   }
	
	                },
	                
	                
					tooltip: {
				         formatter: function() {
				            return 'Portfolio assigned to '+
				               this.series.name+' : '+ this.y;
				         }
				    },
				    series: <%= assignedPortfolios as JSON%>
	
	             });
	
	          });
	</script>

<div id="portfolioAssignment" ></div>
</html>