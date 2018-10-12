<%@ page import="grails.converters.JSON"%>
<%
	def baseurl = request.siteUrl
%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
 		<g:javascript library="jquery" plugin="jquery"/>
		<script src="${baseurl}/js/highcharts.js" type="text/javascript"></script>
		<script src="${baseurl}/js/modules/exporting.js" type="text/javascript"></script>
		<script>
			
		   	var chart3; // globally available
		      	jQuery(document).ready(function()
		      	{
		
		             chart3 = new Highcharts.Chart(
		             {
		
		                chart: {
		
		                   	renderTo: 'serviceDesignerVeriance',
		
		                    defaultSeriesType: 'column'
		
		                },
		
		                title: {
		
		                   text: 'Service Designer vs Avg Estimates Variance'
		
		                },
		
		                xAxis: {
		
		                   categories: ['Service Designer']
		
		                },
		
		                yAxis: {
						   min: 0,
		                   title: {
		
		                      text: '<b>Avg Estimate Variance (%)</b>'
		
		                   }
		
		                },
						
						tooltip: {
					         formatter: function() {
					            return 'Estimate Variance for '+
					               this.series.name+': '+ this.y +' %';
					         }
					    },
					    
		                series: <%= serviceDesignerEstimatedVeriance as JSON%>
		             });
		
		          });
		      
		</script>
	
        
        
	</head>
		<div class="body">

			<g:render template="samplenavigation" />
	
			
 			
 			<g:if test="${serviceDesignerEstimatedVeriance}">
				
					<div id="serviceDesignerVeriance" style="width: 100%; height: 400px"></div>
				
			</g:if>
		</div>
</html>

