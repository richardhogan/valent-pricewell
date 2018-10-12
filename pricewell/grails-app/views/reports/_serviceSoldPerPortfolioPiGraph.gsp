<%@ page import="grails.converters.JSON"%>
<%
	def baseurl = request.siteUrl
%>
<html>
	<script>
		var serviceSoldPiGraph;
		
		jQuery(document).ready(function() 
		{			
			serviceSoldPiGraph = new Highcharts.Chart(
			{
				chart: 
				{
					renderTo: 'serviceSoldPiContainer',
					height: 300,
					width: Math.round(jQuery(window).width()*45/100),
					backgroundColor:'transparent',
					marginTop: 50
				},
				title: 
				{
					text: ''//'Compliant Transactions (%)'
				},
				tooltip: 
				{
					formatter: function() {
						return '<b>'+ this.point.name +'</b>: '+ Math.round(this.percentage) +'  (%)';
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
					data: <%= serviceSoldPerPortfolioMap["dataOfPiGraph"] as JSON%>
						
				}]
			});
		});
	</script>
		
	<div id="serviceSoldPiContainer"></div>
</html>