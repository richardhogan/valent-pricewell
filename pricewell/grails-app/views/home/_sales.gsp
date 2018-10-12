<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
       <script type="text/javascript" src="http://www.google.com/jsapi"></script>  
       <script>
		
		var my = [{

                   name: 'Jane',

                   data: [1, 0, 4, 2, 1, 4]

                }, {

                   name: 'John',

                   data: [5, 7, 3, 3, 2, 0]

                }, {
                
                   name: 'Abhi',
                	
                   data: [4, 0, 6, 1, 3, 5]
                
                }]
       var chart1; // globally available
      	jQuery(document).ready(function() {

             chart1 = new Highcharts.Chart({

                chart: {

                   renderTo: 'container',

                   type: 'bar'

                },

                title: {

                   text: 'Fruit Consumption'

                },

                xAxis: {

                   categories: ['Apples', 'Bananas', 'Oranges','Mango','Nut','S-bary']

                },

                yAxis: {

                   title: {

                      text: 'Fruit eaten'

                   }

                },

                series: my

             });

          });
       
       </script>
 </head>
 
 <body>
 	<div id="container" style="width: 30%; height: 300px"></div>
 
 </body>