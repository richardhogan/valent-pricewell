
<%
	def baseurl = request.siteUrl
%>

<head>
        <link rel="stylesheet" type="text/css" href="${baseurl }/css/navigation.css"/> 
        
        
		<script type="text/javascript" src="${baseurl }/js/menu/dropmenu.js"></script> 
		<script>
			$(document).ready(function(){
				$("#nav-one").dropmenu();
			});
		</script>
		<link rel="stylesheet" id="smthemenewprint-css" href="${baseurl }/js/menu/style.css" type="text/css">
		
	<style>
		body {background: #fff; margin: 0 2em 2em 2em;}
			#mainmenu {
        		  margin: 0em 0;
        	}
        		
        	#mainmenu li a{
				 font-weight: bold; font-size: 14px; padding: 0.2em 1em;			 
			}
			
			#header {background-color:#fff; padding: 0px 0px 0px 0px; margin-bottom: 0em; width: 100%}
			
			
			#userops {
				color: #000;
			}
			
			#userops  a{
				
			}
			
	</style>
	<title> Administration </title>
	
</head>
<div id="grailsLogo" width="100%">
	<table width=100% id="header">
		<tr><td>
		  	<a href="http://valent-software.com"><img src="${baseurl }/images/valentlogo.png" border="0" /></a>
		</td>
		<td align="true" width=20%>
			<font color="#ffffff">
			<g:if test="${navigation}">
				<n:isLoggedIn>
					<div id="userops">
						 <n:principalName /> | <g:link controller="auth" action="logout" class=""><g:message code="nimble.link.logout.basic" /></g:link>
					</div>
				</n:isLoggedIn>
			</g:if>
			</font>
	</td></tr>
	</table>
	<g:if test="${navigation}">
		<n:isLoggedIn>
			<g:render template="/layouts/new_navigation"/>
			<hr>
		</n:isLoggedIn>
	</g:if>
</div>