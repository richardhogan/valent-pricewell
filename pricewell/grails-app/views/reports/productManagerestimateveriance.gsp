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
        
       
        
	</head>
		<div>

			<g:render template="samplenavigation" />
	
			
	 		<g:if test="${productManagerEstimatedVeriance}">
	 			<h1> Statistics of Estimates Variance of Product Managers </h1>
				<g:include view="/reports/productManagerVeriance.gsp" model="['productManagerEstimatedVeriance': productManagerEstimatedVeriance]"/>		
			</g:if>
		</div>
</html>

