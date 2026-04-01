<%@ page import="grails.converters.JSON"%>
<html>
    <script>
       	 var quotaAssignedVsQuotaAchivedPerPersonChart;
	      	jQuery(document).ready(function()
	      	{
	            quotaAssignedVsQuotaAchivedPerPersonChart = new Highcharts.Chart(
	    	    {
	                chart: {
	                   renderTo: 'quotaChartPerPerson',
                       defaultSeriesType: 'column',
						height: 300,
						width: Math.round(jQuery(window).width()*45/100)+70,
						backgroundColor:'transparent',
						marginTop: 50
	                },

	                title: {
	                   text: ''//"Quota Assigned Vs Quota Achieved Per Person"
	                },

	                xAxis: {
	                   categories: <%= (quotaPerPersons?.get('catagories') ?: []) as JSON%>,
	                   title: {
	                   	text: 'Sales Users'
	                   }
	                },

	                yAxis: {
					   min: 0,
	                   title: {
	                      text: 'Total Quotas '
	                   }
	                },
	                
					tooltip: {
				         formatter: function() {
				            return this.x +'<br />'+
				            		'Quotas '+ this.series.name+' : ${quotaPerPersons?.get('currencySymbol') ?: ''}'+ this.y+ ' ${quotaPerPersons?.get('currency') ?: ''}';
				         }
				    },

	                series: <%= (quotaPerPersons?.get('data') ?: []) as JSON%>
	             });
		             
	
	       }); 
          
  	</script>
	

 <div id="quotaChartPerPerson"></div>

</html>