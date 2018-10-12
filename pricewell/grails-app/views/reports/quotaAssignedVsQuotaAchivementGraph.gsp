<%@ page import="grails.converters.JSON"%>
<%
	def baseurl = request.siteUrl
		
%>

<html>
	
	<script>
		var quotaChartGraph;
		jQuery(document).ready(function() 
		{			
			
			/*jQuery( "#quotaChart" ).progressbar({
				value: <%=quotaData['Percent']%>
			});*/
			
			quotaChartGraph = new Highcharts.Chart(
			{
				chart: 
				{
					renderTo: 'quotaChart',
					height: 300,
					width: Math.round(jQuery(window).width()*45/100)-70,
					backgroundColor:'transparent',
					marginTop: 50
				},
				title: 
				{
					text: ''//"Quota Assigned Vs Quota Achieved"
				},
				tooltip: 
				{
					formatter: function() 
					{
						var assigned = <%=quotaData['Assigned']%>
						return '<b>Quotas</b><br /><b>'+ this.point.name +'</b>: '+ Math.round(this.percentage) +'  (%), ${quotaData['currencySymbol']}'+this.y+' ${quotaData['currency']}<br/>'+
                        '<b>Assigned</b>: ${quotaData['currencySymbol']}'+assigned +' ${quotaData['currency']}<br />';
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
					data: ${quotaData['data'] as JSON}
						/*[
                 			['Achieved',   <%=quotaData['Achieved']%>],
                 
			                 {
			                     name: 'Remains',
			                     y: <%=quotaData['Remains']%>,
			                     sliced: true,
			                     selected: true
			                 }
                 
             			]*/
						
				}]
			});

			if(!quotaChartGraph.hasData()) {  // Only if there is no data
				quotaChartGraph.hideNoData(); // Hide old message
				quotaChartGraph.showNoData("No Quota Assigned");
	        }
		});
	</script>
		
		

		<!--<div id="quotaChart" style="height: 3em" title="<%=quotaData['Achieved']%> / <%=quotaData['Assigned']%> Remains = <%=quotaData['Remains']%>"></div><%=quotaData['Percent']%>%-->
		
		<div id="quotaChart"></div>

</html>