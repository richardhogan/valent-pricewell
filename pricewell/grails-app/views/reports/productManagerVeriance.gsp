<%@ page import="grails.converters.JSON"%>
<html>

    <script>
		
       	var chart1; // globally available
	      	jQuery(document).ready(function() {
	
	             chart1 = new Highcharts.Chart({
	
	                chart: {
	
	                    renderTo: 'productManagerVeriance',
						type: 'bar',
						height: 300,
						width: Math.round(jQuery(window).width()*45/100),
						backgroundColor:'transparent',
						marginTop: 50
	
	                },
	
	                title: {
	
	                   text: ''//"Product Manager vs Avg Estimates Variance"
	
	                },
	
	                xAxis: {
	
	                   categories: <%= productManagerEstimatedVeriance['categories'] as JSON%>//	['Product Manager']
	
	                },
	
	                yAxis: {
	
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
				               this.x+': '+ this.y +' %';
				         }
				    },

				    series: [{
                				name: 'Variance',
                				data: <%= productManagerEstimatedVeriance['data'] as JSON%>
            				}]//<%= productManagerEstimatedVeriance as JSON%>
	
	             });
	
	          });
          
  	</script>
	
 <div id="productManagerVeriance"></div>

</html>