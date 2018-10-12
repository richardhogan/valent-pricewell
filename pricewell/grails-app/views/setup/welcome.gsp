<%@ page import="com.valent.pricewell.*"%>
<%
	def baseurl = request.siteUrl
%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<meta name="layout" content="mainSetup" />
		<style>
       		.box_1 {
			   width: 100%;
			   height: auto;
			   border-top: 1px solid #0000FF;
			   border-bottom: 1px solid #0000FF;
			   border-right: 1px solid #0000FF;
			   border-left: 1px solid #0000FF;
			   background-color: #EFFBF2;
			}
		
			/* Left Div */
			.LeftDiv{
				  width: 5%;
				  padding: 0 0px;
				  float:left;
				  
				 }
			
			/* Right Div */
			.RightDiv{
				  width: 10%;
				  padding: 0 0px;
				  float: right;
				  
				 } 
		
		</style>
		<script>
		jQuery(document).ready(function()
		 	{
				jQuery("#btnCompanyInfo").click(function()
				{
					window.location.href = '${baseurl}/companyInformation/newCompany.gsp';
				});
			
			});
			
			
		</script>
	</head>
	<body>
	<h1 style="font-family:arial;color:black;font-size:30px;text-align:center;">WELCOME</h1>
	<div class="box_1 style="background-color:#E0F8F7">
	
	<p style="font-family:arial;color:black;font-size:20px;background-color:#EFFBF2;">
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;What is the Valent SLM?</br>
		
	</p>
	
	</div>
	<div class="buttons">
        <button class="RightDiv" id="btnCompanyInfo">Add Company Info >></button>
    </div>
	
	</body>
</html>