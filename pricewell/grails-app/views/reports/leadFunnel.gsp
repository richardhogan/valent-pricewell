<%@ page import="grails.converters.JSON"%>
<%
	def baseurl = request.siteUrl
		
%>

<html>
	<script>
		var leadFunnelGraph;
		jQuery(document).ready(function() 
		{			
			leadFunnelGraph = new Highcharts.Chart(
			{
				chart: 
				{
					renderTo: 'leadFunnelChart',
					type: 'funnel',
		            marginRight: 100,
					height: 300,
					width: Math.round(jQuery(window).width()*45/100),
					backgroundColor:'transparent',
					marginTop: 50
				},
				title: 
				{
					text: ''//"Lead Pipeline"
		            
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
		            name: 'Lead',
		            data: <%= leadFunnelData['series'] as JSON%>/*[
		                ['Prospecting',   5],
		                ['Qualification', 4],
		                ['Need Analysis', 0],
		                ['Value Proposition', 5],
		                ['Decision Makers', 7],
		                ['Perception Analysis', 6],
		                ['Proposal/Price Quote', 1],
		                ['Negotiation/Review', 8]
		            ]*/
		        }]
			});
		});
	</script>
		
		

		<div id="leadFunnelChart"></div>

</html>