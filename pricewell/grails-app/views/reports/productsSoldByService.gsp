<%@ page import="grails.converters.JSON"%>
<html>
    <script>
		
       	 var productsSoldByServiceChart;

	      	jQuery(document).ready(function()
	      	{
				productsSoldByServiceChart = new Highcharts.Chart(
				{
		            chart: {
		                renderTo: 'productsSoldByService',
		                type: 'column',
						
						height: 300,
						width: Math.round(jQuery(window).width()*92/100)+10,
						align: 'left',
						backgroundColor:'transparent',
						marginTop: 50
		            },
		            title: {
		                text: ''//"Total Products Sold By Service Offering"
		            },
		            legend: {
		                layout: 'vertical',
		                align: 'left',
		                verticalAlign: 'top',
		                y: 50,
		                padding: 3,
		                itemMarginTop: 5,
		                itemMarginBottom: 5,
		                itemStyle: {
		                    lineHeight: '14px'
		                },title: {
		                    text: "Products"
		                }
		            },	
		            xAxis: {
		                categories: <%= productsSoldByServiceMap['categories'] as JSON%>,
						labels: {
	                         rotation: 0,
	                         align: 'center',
	                         staggerLines: 3,
	                         style: {
	                             fontSize: '10px',
	                             fontFamily: 'Verdana, sans-serif',
	                             fontWeight: 'bold'
	                         }
						}
		            },
		            yAxis: {
		                min: 0,
		                title: {
		                    text: '<b>Total ${currency}</b>'
		                }
		            },
		            tooltip: {
		                formatter: function() {
		                    return '<b>'+ this.x +' </b><br/>'+
		                        this.series.name +': '+ Highcharts.numberFormat(this.y, 2) +' ${currency}<br/>'+
		                        'Total: '+ Highcharts.numberFormat(this.point.stackTotal, 2)+' ${currency}';
				    
		                }
		            },
		            plotOptions: {
		                column: {
		                    stacking: 'normal'
		                }
		            },
		            series: <%= productsSoldByServiceMap['series'] as JSON%>
		        });
	
			});
          
  	</script>
 <div id="productsSoldByService"></div>

</html>