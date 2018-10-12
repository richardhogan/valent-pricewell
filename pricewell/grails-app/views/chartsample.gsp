<html>
<head>
	<script type="text/javascript" src="http://www.google.com/jsapi"></script>
</head>

<%
   int totalQuotes = 5000	
   def qoutesColumns = [['string', 'Quote Status'], ['number', 'values A'], ['number', 'values B']]
   def quotesValues = [['QUOTE', 1200, 1000], ['LEAD', 1000, 800], ['CONTRACT', 2000,200], ['SOW', 1800,600]]
%>

<h2> Total Quotes ${totalQuotes} </h2>

<gvisualization:columnCoreChart elementId="barChart" title="Summary of Quotes status" width="${450}" height="${300}" 
 columns="${qoutesColumns}" data="${quotesValues}"/>
 
 <div id="barChart"></div>

</html>