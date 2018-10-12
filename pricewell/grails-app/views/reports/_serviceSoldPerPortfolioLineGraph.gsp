<%@ page import="grails.converters.JSON"%>
<html>
    <script>
		
       	 var serviceSoldLineGraph;

	      	jQuery(document).ready(function()
	      	{
	      		serviceSoldLineGraph = new Highcharts.Chart(
				{
		            chart: {
		                renderTo: 'serviceSoldPerPortfolioLineContainer',
		                type: 'line',
		                height: 300,
						width: Math.round(jQuery(window).width()*45/100)+35,
						backgroundColor:'transparent',
						marginTop: 50
		            },
		            title: {
		                text: ''//"Quarterly Total Sales"
		            },
		            
		            xAxis: {
		                categories: <%= serviceSoldPerPortfolioMap['categories'] as JSON%>,
		                
		                labels: {
		                	
		                	 rotation: -20,
	                         	                         
	                         style: {
	                             fontSize: '10px',
	                             fontFamily: 'Verdana, sans-serif',
	                             fontWeight: 'bold'
	                             
	                         }
						}
		            },
		            yAxis: {
		            	min: 0,
		            	startOnTick: false,
		            	
		                title: {
		                    text: '<b>Total Service Sold</b>'//'Total IT Sold'
		                }
		            },
		            tooltip: {
		            	formatter: function() {
		                    return '<b>'+ this.x +' </b><br/>Total '+
		                        this.series.name +': '+ this.y ;
				    
		                }
		            },
		            legend: {
		                layout: 'vertical',
		                align: 'right',
		                verticalAlign: 'middle',
		                borderWidth: 0
		            },
		            series: [<%= serviceSoldPerPortfolioMap['series'] as JSON%>]
		        });
	
			});
          
  	</script>
 <div id="serviceSoldPerPortfolioLineContainer"></div>

</html>