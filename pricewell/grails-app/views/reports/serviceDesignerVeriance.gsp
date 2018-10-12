<%@ page import="grails.converters.JSON"%>
<html>
    <script>
		
       	var serviceDesignerVerianceChart; // globally available
	      	jQuery(document).ready(function()
	      	{

	      		dateRange('date_range', 'This month to date', function(val){
						//alert(val);
						//In order to get selected text
						//alert(jQuery("#date_range option:selected").text());
						return false;
		      		});
	      		
	      		serviceDesignerVerianceChart = new Highcharts.Chart(
	             {
	
	                chart: {
	
	                   	renderTo: 'serviceDesignerVeriance',
	
	                    defaultSeriesType: 'column',
						height: 300,
						width: Math.round(jQuery(window).width()*45/100),
						backgroundColor:'transparent',
						marginTop: 50
	
	                },
	
	                title: {
	
	                   text: ''//"Service Designer vs Avg Estimates Variance"
	
	                },
	
	                xAxis: {
	
	                   categories: <%= serviceDesignerEstimatedVeriance['categories'] as JSON%> //['Service Designer']
	
	                },
	
	                yAxis: {
					   min: 0,
	                   title: {
	
	                      text: '<b>Avg Estimate Variance (%)</b>'
	
	                   }
	
	                },
	                legend: {
			            enabled: false
			        },
	
					tooltip: {
				         formatter: function() {
				            return '<b>Estimate Variance </b><br>'+
				               this.series.name+': '+ this.y +' %';
				         }
				    },
				    series:[{
                				name: 'Variance',
                				data: <%= serviceDesignerEstimatedVeriance['data'] as JSON%>
            				}]   // <%= serviceDesignerEstimatedVeriance as JSON%>
	             });
	
	          });
          
  	</script>

	
 <!-- <div> <b> Select Date Range: &nbsp;</b>  <select id="date_range" name="date_range"></select> </div>-->


 <div id="serviceDesignerVeriance"></div>
</html>