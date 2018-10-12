<%@ page import="grails.converters.JSON"%>
<html>
    <script>
		
       	 var itCostPerQuotationLineGraph;

	      	jQuery(document).ready(function()
	      	{
	      		itCostPerQuotationLineGraph = new Highcharts.Chart(
				{
		            chart: {
		                renderTo: 'itCostPerQuotationAndPortfolioLineContainer',
		                type: 'line',
		                height: 300,
						width: Math.round(jQuery(window).width()*92/100)+10,
						backgroundColor:'transparent',
						marginTop: 50
		            },
		            title: {
		                text: ''//"Quarterly Total Sales"
		            },
		            
		            xAxis: {
		                categories: <%= itCostPerQuotationMap['categories'] as JSON%>,
		                
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
		                    text: '<b>Service Revenue (${currency})</b>'//'Total IT Cost (${currency})'
		                }
		            },
		            tooltip: {
		            	formatter: function() {
		                    return '<b>'+ this.x +' </b><br/>Total Revenue of '+
		                        this.series.name +' : <br/>'+ Highcharts.numberFormat(this.y, 2)+' ${currency}' ;
				    
		                }
		            },
		            legend: {
		                layout: 'vertical',
		                align: 'right',
		                verticalAlign: 'middle',
		                borderWidth: 0
		            },
		            series: <%= itCostPerQuotationMap['series'] as JSON%>
		        });
	
			});
          
  	</script>
 <div id="itCostPerQuotationAndPortfolioLineContainer"></div>

</html>