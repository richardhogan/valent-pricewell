<%@ page import="grails.converters.JSON"%>
<%
	def baseurl = request.siteUrl
		
%>

<html>
	<script>
		var serviceFunnelGraph;
		jQuery(document).ready(function() 
		{			
			serviceFunnelGraph = new Highcharts.Chart(
			{
				chart: 
				{
					renderTo: 'serviceFunnelChart',
					type: 'funnel',
		            marginRight: 100,
					height: 300,
					width: Math.round(jQuery(window).width()*45/100),
					backgroundColor:'transparent',
					marginTop: 50
				},
				title: 
				{
					text: ''//"Service Pipeline"
		            
				},
		        plotOptions: {
		            /*series: {
		                dataLabels: {
		                    enabled: true,
		                    format: '<b>{point.name}</b> ({point.y:,.0f})',
		                    color: 'black',
		                    softConnector: true
		                }
                    }*/
					funnel: {
	                    allowPointSelect: true,
	                    cursor: 'pointer',
	                    dataLabels: {
	                        enabled: false
	                    },
	                    showInLegend: true
	                }
		        },
		        series: [{
		            name: 'Service',
		            data: <%= serviceFunnelData['series'] as JSON%>
		        }]
			});
		});
	</script>
		
		

		<div id="serviceFunnelChart"></div>

</html>