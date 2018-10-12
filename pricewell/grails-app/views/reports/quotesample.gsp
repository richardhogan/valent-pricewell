<%
	def baseurl = request.siteUrl
%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <link rel='stylesheet' type='text/css' href='${baseurl}/js/yui-cms/2.1/accordion/assets/accordion.css'/>
        <link rel='stylesheet' type='text/css' href='${baseurl}/css/customyui.css'/>    
        <link rel='stylesheet' type='text/css' href='${baseurl}/css/mySkin.css'/>        
       <script type="text/javascript" src="${baseurl}/js/yui-cms/2.1/bubbling/bubbling-min.js" ></script>  
		<script type="text/javascript" src="${baseurl}/js/yui-cms/2.1/accordion/accordion-min.js" ></script>
        <script type="text/javascript" src="http://www.google.com/jsapi"></script>
        
       <gui:resources components="tabView"/>
        
        
	</head>
<div class="body yui-skin-sam">

	<g:render template="samplenavigation" />

<h1> Statistics of Quotes </h1>
 	
    
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
			
					<%
					   def myDailyActivitiesColumns = [['string', 'Quote Status'], ['number', 'no of Quotes']]
					   def myDailyActivitiesData = [['QUOTE', 400],['LEAD', 300],['SOW', 800],['CONTRACT', 400],['REJECT', 300]]
					%>
					<gvisualization:pieCoreChart elementId="piechart" title="Division of 2200 Quotes by quote's status" width="${800}" height="${300}" 
					 columns="${myDailyActivitiesColumns}" data="${myDailyActivitiesData}" />
					<div id="piechart"></div>
				
</div>
</html>

