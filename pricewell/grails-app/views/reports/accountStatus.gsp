<%@ page import="grails.converters.JSON"%>
<html>
    <script>
		
       	var chart1; // globally available
      	jQuery(document).ready(function()
      	{

      		/*Highcharts.setOptions({
      	        colors: <%= accountStatusByRoleData['plotColors'] as JSON%>
      	    });*/
      	    
             chart1 = new Highcharts.Chart({

                chart: {

                   renderTo: 'accountStatus',

                    defaultSeriesType: 'column',
					height: 300,
					width: Math.round(jQuery(window).width()*45/100),
					backgroundColor:'transparent',
					marginTop: 50

                },

                title: {

                   text: ''//'Account Status by Role'

                },

                xAxis: {

                   categories: <%= accountStatusByRoleData['catagories'] as JSON%>,
                   title: {
                   	text: '<b>Account Status</b>'
                   }

                },

                yAxis: {
				   min: 0,
                   title: {

                      text: '<b>No. of user</b>'

                   }

                },
                
                tooltip: {
			         formatter: function() {
			            return 'No. of '+
			               this.series.name+' '+this.x+': '+ this.y;
			         }
			    },

                series: <%= accountStatusByRoleData['data'] as JSON%>
             });

          });
          
  	</script>
	

 <div id="accountStatus" ></div>

</html>