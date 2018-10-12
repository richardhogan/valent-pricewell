<!DOCTYPE html>
<%@ page import="NimbleTagLib" %>
<%@ page import="org.apache.shiro.SecurityUtils"%>

<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <title>Price Well</title>
                         
        <link rel="shortcut icon" href="${resource(dir:'images',file:'valentlogo.png')}" type="image/x-icon" />
              
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
       <g:layoutHead />
        
        <script>
			jQuery(document).ready(function(){
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

			function setAutomaticTimeout(){
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
      	
       	<script>
      	
       		 <g:if test="${flash.message != null && flash.message.length() > 0}">
		 		  <g:if test="${flash.type != null && flash.type == 'error'}">
			       		jQuery(document).ready(function()
		     			{
			       			jQuery.jGrowl('${flash.message.encodeAsHTML()}', 
				                  	  { 'life': 5000, 'header': '<span class=\'icon icon_error\'>&nbsp;</span>' });
		     				//jQuery('.jGrowl').addClass('mCenter');
		     			});
		 		  </g:if>
		 		  <g:else>
		
		     			jQuery(document).ready(function()
		     			{
		     				jQuery.jGrowl('${flash.message.encodeAsHTML()}', 
		                    	  { 'life': 5000, 'header': '<span class=\'icon icon_tick\'>&nbsp;</span>' });
		     				//jQuery('.jGrowl').addClass('mCenter');
		     			});
		 			
		 		    //nimble.growl("success", '${flash.message.encodeAsHTML()}' , 5000);
		 		    
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
							 <!--<g:if test="${SecurityUtils.subject.hasRole('SYSTEM ADMINISTRATOR')}">
							  |  <a href="${baseurl}/navigation/administration" class="">Admin Menu</a> | 
							 <a href="${baseurl}/setting/settings" class="">Settings</a>
							  
							  </g:if>-->
						</div>
					</n:isLoggedIn>
			</td></tr>
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