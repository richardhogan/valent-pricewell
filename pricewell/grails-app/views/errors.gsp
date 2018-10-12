<%
	def baseurl = request.siteUrl	
%>
<html>
	<head>
		<title>Application Error</title>
        <style>
body 
{
background-image:url('${baseurl}/images/background.jpg');
background-color:#cccccc;
}
</style>
	</head>
	<body>
        <h1>Application Error</h1>
        
        <p> Sorry for inconvenience, Please refresh this page from browser. </p>
        <p> If this error keeps coming then contact Valent Administrator: admin@valent-software.com </p>
        <p> ${str} </p>
	</body>
</html>