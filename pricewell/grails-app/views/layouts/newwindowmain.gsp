<!DOCTYPE html>
<%@ page import="NimbleTagLib" %>
<%@ page import="org.apache.shiro.SecurityUtils"%>

<%
	def baseurl = request.siteUrl
%>
    
<html>
    <head>
        <title>Price Well</title>
                         
        <link rel="shortcut icon" href="${baseurl}/images/valentlogo.png" type="image/x-icon" />
              
         <r:require module="coreui"/>
         <r:layoutResources/>
         
         <script type="text/javascript">
			jQuery.noConflict();
		</script>
		<style>
			.error { -moz-border-radius: 2px; -webkit-border-radius: 2px; font-size: 116.667%; margin: 3px; padding: 6px; font-weight: normal; background-color: #ffbaba; border: 1px solid #ffbaba; color: #D8000C; }
						label.error {
    			font-size: 12px;
				}
				
			
		</style>
		<link rel="stylesheet" href="${baseurl}/css/badgeStyle.css">
		<link rel="stylesheet" href="${baseurl}/css/chartsBox.css">
		
       <g:layoutHead />
        
        <script>
			jQuery(document).ready(function()
			{
				jQuery("#nav-one").dropmenu();
				setAutomaticTimeout();  			    
			});

			//Temporary method to set timeout 10 seonds
			function setTempTime(){
				jQuery.post('${baseurl}/userSetup/setlogouttime', function(data){
						setAutomaticTimeout();
					}); 
			}

			var timeout = 1800000

			function setAutomaticTimeout()
			{
				jQuery.post('${baseurl}/userSetup/getlogouttime', function(data){
					if(isNumeric(data)){
						timeout = parseInt(data) + 5000;
						setTimeout(checkSessionTimeOut,timeout);
					} 
					
				});
			}

			function isNumeric(n) {
				return !isNaN(parseFloat(n)) && isFinite(n);
			}
							
			function checkSessionTimeOut(){
				setTimeout(checkSessionTimeOut,timeout);
				jQuery.post('${baseurl}/userSetup/islogin', function(data){
						if(data != 'true'){
							location.reload();
						}
					});
			}

		</script>
        
    </head>
    <body>
        
      	<r:layoutResources/>
			<font color="#ffffff">
			
				<table id="header">
					<tr>
						<td>
						  	<a href="http://valent-software.com"><img src="${baseurl}/images/valentlogo.png" border="0" /></a>
						</td>
						<td align="true" width=30%>
							<n:isLoggedIn>
								<div id="userops">
						      		<div class="headerNav-list">
						      			<div><span class="headerNav-link2"><n:principalName /></span></div>
							      	</div>
								</div>
							</n:isLoggedIn>
						</td>
					</tr>
				</table>		
			</font> 
		<hr>
        <g:layoutBody />
        <div id="loader-overlay"></div>
		<div id="loader-box">
			<div class="loader-content">
				<div id="loader-message">
					<p>Please wait while loading...</p>
				</div>
				<!--<a href="#" class="button">Close</a>-->
			</div>
		</div>
    </body>
</html>