<%@ page import="grails.converters.JSON"%>
<html>
	<script>
		var chart;
		
		jQuery(document).ready(function() 
		{		
			chart = new Highcharts.Chart(
			{
				chart: 
				{
					renderTo: 'container'
				},
				title: 
				{
					text: 'VSOE Compliant Transactions (%)'
				},
				tooltip: 
				{
					formatter: function() {
						return '<b>'+ this.point.name +'</b>: '+ this.percentage +'  (%)';
					}
				},
				plotOptions: 
				{
					pie: {
						allowPointSelect: true,
						cursor: 'pointer',
						dataLabels: {
							enabled: false
						},
						showInLegend: true
					}
				},
				series: [
				{
					type: 'pie',
					name: 'Browser share',
					data: <%= totaldiscount["data"] as JSON%>/*[
						['> +15',   20.0],
						['-15 >', 20.0],
						['Other',       60.0]						
					]*/
				}]
			});
		});
	</script>
		
		<div id="container" style="width: 530px; height: 300px"></div>
</html>