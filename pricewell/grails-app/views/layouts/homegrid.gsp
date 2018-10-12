<!DOCTYPE html>
<%@ page import="NimbleTagLib" %>
<%@ page import="org.apache.shiro.SecurityUtils"%>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <title>Price Well</title>
        
        <r:require module="coreui"/> 
        
        <r:layoutResources/>
                 
        <link rel="shortcut icon" href="${resource(dir:'images',file:'valentlogo.png')}" type="image/x-icon" />
        
		<style>
			#header {background-color:#fff; padding: 0px 0px 0px 0px; margin-bottom: 0em; width: 100%}
			
		</style>
  
        <style>  
        	#mainmenu {
        		  margin: 0 0;
        	}
        		
        	#mainmenu li a{
				 font-weight: bold; font-size: 14px; padding: 0.2em 1em;			 
			}
			
			#userops {
				color: #000;
			}
			
			#userops  a{
				
			}
			
			
			
			.jGrowl-notification {
	background-color: 		#363636;
	color: 					#fff;
	opacity: 				1;
	filter: 				alpha(opacity = 1);
	zoom: 					1;
	width: 					235px;
	padding: 				10px;
	margin-top: 			5px;
	margin-bottom: 			5px;
	font-family: 			Tahoma, Arial, Helvetica, sans-serif;
	font-size: 				12px;
	text-align: 			left;
	display: 				none;
	-moz-border-radius: 	5px;
	-webkit-border-radius:	5px;
}

div.jGrowl div.jGrowl-notification div.message {
	font-size: 	14px;
	width: 700px;
	
}
			
.mCenter
{
margin-left:auto;
margin-right:auto;
width:70%;
}

.mWidth {
	width: 700px;
}
 			
        </style>
        
        <script type="text/javascript"> 
        	jQuery.noConflict();
		</script>
		<script>
			jQuery(document).ready(function(){
				setAutomaticTimeout();
			});

			var timeout = 1800000

			function setAutomaticTimeout(){
				jQuery.get('${baseurl}/userSetup/getlogouttime', function(data){
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
				jQuery.get('${baseurl}/userSetup/islogin', function(data){
						if(data != 'true'){
							location.reload();
						}
					});
			}
		</script>
		
<g:layoutHead />
        
        
    </head>
    <body>
		<r:layoutResources/>
		
		<script>
      	
       	  <g:if test="${flash.message != null && flash.message.length() > 0}">
       		  <g:if test="${flash.type != null && flash.type == 'error'}">
		       		jQuery(document).ready(function()
           			{
		       			jQuery().toastmessage('showErrorToast', '${flash.message.encodeAsHTML()}');
           			});
       		  </g:if>
       		  <g:else>

	       			jQuery(document).ready(function()
	       			{
	       				jQuery().toastmessage('showSuccessToast', '${flash.message.encodeAsHTML()}');
	       			});
       		    
       		  </g:else>
       			
       	  </g:if>
		      
		</script>
			<font color="#ffffff">
			
			<table id="header">
				<tr><td>
				  	<a href="http://valent-software.com"><img src="${resource(dir:'images',file:'valentlogo.png')}" border="0" /></a>
				</td>
				<td align="true" width=20%>
					<n:isLoggedIn>
						<div id="userops">  
							 <n:principalName /> | <g:link controller="auth" action="logout" class=""><g:message code="nimble.link.logout.basic" /></g:link>
							 <g:if test="${SecurityUtils.subject.hasRole('SYSTEM ADMINISTRATOR')}">
							  |  <a href="${baseurl}/navigation/administration" class="">Admin Menu</a>
							  </g:if>
						</div>
					</n:isLoggedIn>
			</td></tr>
			</table>		
			</font>
			<g:render template="/layouts/navigation"/> 
		<hr>
        <g:layoutBody />
    </body>
</html>