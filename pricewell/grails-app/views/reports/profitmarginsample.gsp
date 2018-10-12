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
		
		                   	renderTo: 'profitMargin',
		
		                    defaultSeriesType: 'column'
		
		                },
		
		                title: {
		
		                   text: 'Estimated Profit Margin by GEOs'
		
		                },
		
		                xAxis: {
		
		                   categories: ['GEO']
		
		                },
		
		                yAxis: {
						   min: 0,
		                   title: {
		
		                      text: 'Profit Margin (%)'
		
		                   }
		
		                },
		
						tooltip: {
					         formatter: function() {
					            return 'Profit margin for '+
					               this.series.name+': '+ this.y +' %';
					         }
					    },
					    
		                series: [
		                	{
		                		name: 'USA',
		                		data: [35]
		                	},
		                	{
		                		name: 'Germany',
		                		data: [31]
		                	},
		                	{
		                		name: 'Japan',
		                		data: [29]
		                	},
		                	{
		                		name: 'UK',
		                		data: [37]
		                	},
		                	{
		                		name: 'Russia',
		                		data: [38]
		                	}
		                ]
		             });
		
		          });
		      
		</script>
	
        
        
	</head>
	<div class="body">

		<g:render template="samplenavigation" />

		<h1> Profit Margins of Service by GEOs </h1>
 	
    
			<div> 	
                 <label>Portfolio</label>
                   	<g:select name="portfolioId" from="${com.valent.pricewell.Portfolio.list()}" optionKey="id" value="${portfolioId}" noSelection="${['all':'All']}"  />
                 <label>Service</label>
                   	<g:select name="serviceId" from="${com.valent.pricewell.Service.list()}" optionKey="id" value="1" noSelection="${['all':'All']}"  />
                   	
   					<input type="button" name="searchButton" value="Show"/>                
				                   
            </div>
			
					<div id="profitMargin" style="width: 100%; height: 400px"></div>
				
	</div>
</html>

