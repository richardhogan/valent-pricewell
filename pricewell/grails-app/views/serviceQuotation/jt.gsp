<%
	def baseurl = request.siteUrl
%>
<html>
  <head>
    <title>Simple GSP page</title>
    
    <link type="text/css" href="${baseurl}/css/redmond/jquery-ui-1.8.16.custom.css" rel="stylesheet" />	
	<script type="text/javascript" src="${baseurl}/js/jquery-1.6.2.min.js"></script>
	<script type="text/javascript" src="${baseurl}/js/jquery-ui-1.8.16.custom.min.js"></script>
	<script language="JavaScript" type="text/javascript"> 
        	jQuery.noConflict();
		</script> 
    <script type="text/javascript">
    
	    (function($) { 
		    		$(function() {
							$( "#datepicker" ).datepicker();
					}); })(jQuery);
    </script>

  </head>
  <body>
    <div>
      <p> Between <input type="text" id="datepicker"> </p>        
    </div>

  </body>
</html>