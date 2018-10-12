<%@ page import="grails.converters.JSON"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        
	    <script>
			var chart;
			jQuery(document).ready(function() {
				chart = new Highcharts.Chart({
					chart: {
						renderTo: 'container',
						plotBackgroundColor: null,
						plotBorderWidth: null,
						plotShadow: false
					},
					title: {
						text: 'Generate report of Services Total Units Sold'
					},
					tooltip: {
						formatter: function() {
							return '<b>'+ this.point.name +'</b>: '+ this.percentage +' %';
						}
					},
					plotOptions: {
						pie: {
							allowPointSelect: true,
							cursor: 'pointer',
							dataLabels: {
								enabled: false
							},
							showInLegend: true
						}
					},
					series: [{
						type: 'pie',
						name: 'Browser share',
						data: <%= totalUnitSoldForService as JSON%>
							/*[
							['Firefox',   45.0],
							['IE',       26.8],
							{
								name: 'Chrome',
								y: 12.8,
								sliced: true,
								selected: true
							},
							['Safari',    8.5],
							['Opera',     6.2],
							['Others',   0.7]
						]*/
					}]
				});
			});
			
		</script>
	</head>
	<body>
		<g:render template="samplenavigation" />
		
		<div>
              	<label>GEO</label>
               	<g:select name="geoId" from="${com.valent.pricewell.Geo.list()}" optionKey="id" value="${geoInstance?.id}" noSelection="['all':'All']"  />
               	<label>Portfolio</label>
               	<g:select name="portfolioId" from="${com.valent.pricewell.Portfolio.list()}" optionKey="id" value="${portfolioId}" noSelection="['all':'All']"  />
               	<label>Year</label>
               	<g:select name="year" from="${['2011','2010','2009']}"  value="${year}" noSelection="['all':'All']"  />
               	<label>Quarter</label>
               	<g:select name="year" from="${['Q1','Q2','Q3', 'Q4']}"  value="${year}" noSelection="['all':'All']"  />
				<input type="button" name="searchButton" value="Show"/>                
			                   
        </div>
 		<div id="container" style="width: 600px; height: 300px"></div>
 		
	</body>
</html>