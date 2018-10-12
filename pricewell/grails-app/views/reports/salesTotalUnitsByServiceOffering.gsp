<%@ page import="grails.converters.JSON"%>
<html>
    <script>
       	 var salesTotalUnitsByServiceMapChart;
	      	jQuery(document).ready(function()
	      	{
	             salesTotalUnitsByServiceMapChart = new Highcharts.Chart(
	    	     {
	                 chart: {
	                     renderTo: 'salesTotalUnitsByService',
	                     type: 'column',
						height: 300,
						width: Math.round(jQuery(window).width()*92/100)+10,
						backgroundColor:'transparent',
						marginTop: 50
	                 },
	                 title: {
	                     text: ''//"Sales Total Units By Service Offering"
	                 },
	                 xAxis: 
		             {
	                     categories: <%= salesTotalUnitsByServiceMap['categories'] as JSON%>,
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
	                         text: '<b>Total Units</b>'
	                     }
	                 },
	                 legend: {
	                     enabled: false
	                 },
	                 tooltip: {
	                	 valueDecimals: 0,
	                     formatter: function() {
	                         return '<b> Total Units of '+ this.x +'</b><br/>'+ this.y;
	                     }
	                 },
	                 series: [{
	                     name: 'Units',
	                     data: <%= salesTotalUnitsByServiceMap['data'] %>
	                 }]
	             });
	
	          });
          
  	</script>
	

 <div id="salesTotalUnitsByService"></div>

</html>