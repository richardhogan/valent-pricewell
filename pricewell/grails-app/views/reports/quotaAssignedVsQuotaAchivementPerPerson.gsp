<%@ page import="grails.converters.JSON"%>
<html>
    <script>
       	 var quotaAssignedVsQuotaAchivedPerPersonChart;
	      	jQuery(document).ready(function()
	      	{
	      		 /*quotaAssignedVsQuotaAchivedPerPersonChart = new Highcharts.Chart(
	    	     {
	                 chart: {
	                     renderTo: 'quotaChartPerPerson',
	                     type: 'column'
	                 },
	                 title: {
	                     text: 'Quota Assigned Vs Quota Achieved Per Persons'
	                 },
	                 xAxis: 
		             {
	                     categories: <%= quotaPerPersons['categories'] as JSON%>,
	                     labels: {
	                         rotation: -45,
	                         align: 'right',
	                         style: {
	                             fontSize: '13px',
	                             fontFamily: 'Verdana, sans-serif'
	                         }
	                     }
	                 },
	                 yAxis: {
	                     min: 0,
	                     title: {
	                         text: '<b>Total Quotas Assigned</b>'
	                     },
	                     stackLabels: {
	                         enabled: true,
	                         style: {
	                             fontWeight: 'bold',
	                             color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
	                         }
	                     }
	                 },
	                 tooltip: {
	                	 formatter: function() {
	                         return '<b>Quotas of '+ this.x +'</b><br/>'+
	                             this.series.name +': '+ this.y +'<br/>'+
	                             'Assigned: '+ this.point.stackTotal;
	                     }
	                 },
	                 plotOptions: {
	                     column: {
	                         stacking: 'normal'
	                     }
	                 },
	                 series: [{name: 'Achieved', data: <%= quotaPerPersons['achived']%>},
		                 	  {name: 'Remains', data: <%= quotaPerPersons['remains']%>}]
	             });*/


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
	                   categories: <%= quotaPerPersons['catagories'] as JSON%>,
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
				            		'Quotas '+ this.series.name+' : ${quotaPerPersons['currencySymbol']}'+ this.y+ ' ${quotaPerPersons['currency']}';
				         }
				    },

	                series: <%= quotaPerPersons['data'] as JSON%>
	             });
		             
	
	       }); 
          
  	</script>
	

 <div id="quotaChartPerPerson"></div>

</html>