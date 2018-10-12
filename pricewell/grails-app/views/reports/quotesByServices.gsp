<html>
<head>
	<script type="text/javascript" src="http://www.google.com/jsapi"></script>
</head>

<%	
   def columns = [['string', 'Quote Status'], ['number', 'Assessment'], ['number', 'Design'], ['number', 'TAM'], ['number', 'Implement'], ['number', 'Integrate']]
   def values = [['Quoted', 69, 28, 30, 27, 12], 
	   					['Won', 33, 14, 10, 15, 16], 
						   ['Lost', 12, 4, 20, 9, 4],
						   ['Pending', 14, 6, 0, 2, 2],
						   	['Billed', 0, 2, 0, 1, 0],
							   ['Rev-Rec', 0, 2, 0, 0, 0]]
%>


<gvisualization:columnCoreChart elementId="chart" title="Sales Quotes by Service Offering" width="${650}" height="${400}" 
 columns="${columns}" data="${values}"/>
 
 <div id="chart"></div>

</html>