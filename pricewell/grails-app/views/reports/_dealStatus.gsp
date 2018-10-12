<%@ page import="grails.converters.JSON"%>

<html>
	<script>

		var dealStatusGraph;
		jQuery(document).ready(function() 
		{
			dealStatusGraph = new Highcharts.Chart(
			{
				chart: {
					renderTo: 'dealStatusGraph',
					type: 'column',
					height: 300,
					width: Math.round(jQuery(window).width()*45/100),
					backgroundColor:'transparent',
					marginTop: 50
				},
				title: {
					text: ''//"Deal Status"
				},
				xAxis: {
					categories: <%= quoteTypesMap["categories"] as JSON %>
				},
				yAxis: {
					min: 0,
					title: {
						text: ''
					}
				},
				legend: {
					align: 'right',
					x: -100,
					verticalAlign: 'top',
					y: 20,
					floating: true,
					backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColorSolid) || 'white',
					borderColor: '#CCC',
					borderWidth: 1,
					shadow: false
				},
				tooltip: {
					formatter: function() {
						return '<b>'+ this.x +'</b><br/>'+
							this.series.name +': '+ this.y +'<br/>';
					}
				},
				plotOptions: {
					column: {
						stacking: 'normal'
					}
				},
				series: <%= quoteTypesMap["series1"] as JSON %>
			});
		});
		
	</script>
	
	<div id="dealStatusGraph" ></div>

</html>