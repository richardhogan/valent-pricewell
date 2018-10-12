<%@ page import="grails.converters.JSON"%>
<html>

    <script>
		
       	var dealStatusAgingGraph; // globally available
	      	jQuery(document).ready(function() 
	    	{
	
	      		dealStatusAgingGraph = new Highcharts.Chart(
	    	    {
	    	
   	                chart: {
   	
   	                   renderTo: 'chartDealStatusAgingGraph',
   	
   	                   type: 'column',
						height: 300,
						width: Math.round(jQuery(window).width()*45/100),
						backgroundColor:'transparent',
						marginTop: 50
   	
   	                },
	    	
   	                title: {
   	
   	                   text: ''//"Deal Status Aging Graph"
   	
   	                },
	    	
   	                xAxis: {
   	
   	                   title: {
   	
   	                         text: '<b>Days Pending</b>'
   	
   	                      },
	    	                      
   	                   categories: <%= pendingDaysMap["categories"] as JSON %>
   	
   	                },
	    	
   	                yAxis: {
   	                	min: 0,
   	                    title: {
   							text: '' 
   						}
   					},

   					tooltip: {
   		                formatter: function() {
   		                    return '<b>'+ this.x +'</b><br/>Days Pending '+
   		                        this.series.name +' : '+ this.y +'<br/>';
   		                }
   		            },
   		            
   					
   	                legend: {
   	         	         enabled: true
   	         	    },

	   	         	series: <%= pendingDaysMap["series"] as JSON %>
	    	
   	             });
	
	        });
          
  	</script>
	
 <div id="chartDealStatusAgingGraph"></div>

</html>