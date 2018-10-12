<%@ page import="grails.converters.JSON"%>
<html>
    <script>
		
       	 var serviceSalesQuoteChart;
	      	jQuery(document).ready(function()
	      	{
	             serviceSalesQuoteChart = new Highcharts.Chart(
	    	     {
	                 chart: {
	                     renderTo: 'salesSoldByServices',
	                     type: 'column',
	                     
						height: 300,
						width: Math.round(jQuery(window).width()*92/100)+10,
						backgroundColor:'transparent',
						marginTop: 50
	                 },
	                 title: {
	                     text: ''//"Total Sales Sold By Service Offering"
	                 },
	                 xAxis: 
		             {
	                     categories: <%= salesSoldByServicesMap['categories'] as JSON%>,
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
	                     title: {
	                         text: '<b>Total ${currency}</b>'
	                     }
	                 },
	                 legend: {
	                     enabled: false
	                 },
	                 tooltip: {
	                	 valueDecimals: 2,
	                	 formatter: function() {
	                         return '<b> '+ this.x +' Sold </b><br/>'+ this.y+' ${currency}';
	                     }
	                 },
	                 series: [{
	                     name: 'Sales sold',
	                     data: <%= salesSoldByServicesMap['data'] %>
	                 }]
	             });
	
	          });
          
  	</script>
	

 <div id="salesSoldByServices" ></div>

</html>