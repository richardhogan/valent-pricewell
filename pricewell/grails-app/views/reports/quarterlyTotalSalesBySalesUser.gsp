<%@ page import="grails.converters.JSON"%>
<html>
    <script>
		
       	 var quarterlyTotalSalesChart;

	      	jQuery(document).ready(function()
	      	{
	      		quarterlyTotalSalesChart = new Highcharts.Chart(
				{
		            chart: {
		                renderTo: 'quarterlyTotalSalesBySalesUser',
		                type: 'line',
		                height: 300,
						width: Math.round(jQuery(window).width()*45/100),
						backgroundColor:'transparent',
						marginTop: 50
		            },
		            title: {
		                text: ''//"Quarterly Total Sales"
		            },
		            
		            xAxis: {
		                categories: <%= quarterlyTotalSalesMap['categories'] as JSON%>,
		                
		                labels: {
		                	
		                	 rotation: -30,
	                         
	                         
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
		                    text: '<b>Total Sales (${currency})</b>'
		                }
		            },
		            tooltip: {
		            	formatter: function() {
		                    return '<b>'+ this.x +' </b><br/>Total '+
		                        this.series.name +': '+ Highcharts.numberFormat(this.y, 2)+' ${currency}' ;
				    
		                }
		            },
		            legend: {
		                layout: 'vertical',
		                align: 'right',
		                verticalAlign: 'middle',
		                borderWidth: 0
		            },
		            series: [<%= quarterlyTotalSalesMap['series'] as JSON%>]
		        });
	
			});
          
  	</script>
 <div id="quarterlyTotalSalesBySalesUser"></div>

</html>