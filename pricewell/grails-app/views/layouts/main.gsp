<!DOCTYPE html>
<%@page import="com.valent.pricewell.util.PricewellUtils"%>
<%@page import="com.valent.pricewell.HomeController"%>
<%@ page import="com.valent.pricewell.PricewellSecurity"%>
    
<html>
    <head>
        <title>Price Well</title>
                         
        <link rel="shortcut icon" href="/assets/valentlogo.png" type="image/x-icon" />

         <asset:javascript src="application.js"/>
         <asset:stylesheet href="application.css"/>
        <link rel="stylesheet" href="https://cdn.ckeditor.com/ckeditor5/44.3.0/ckeditor5.css" />
        <script src="https://cdn.ckeditor.com/ckeditor5/44.3.0/ckeditor5.umd.js"></script>
        <asset:javascript src="ckeditor5-compat.js"/>

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
			jQuery(document).ready(function()
			{
				jQuery("#nav-one").dropmenu();
				setAutomaticTimeout();
				//var p = setInterval(function(){alert("Hello");},3000);
            
            	isNewNotification();
            	

				jQuery(".notification").qtip(
   			    {
   			         content: 
   				     {
   			        	 url: '${baseurl}/notification/myNotifications',
   			             method: 'GET',
   			          	 text: 'Loading, please wait...',
   			          	 title: {
   									text: "Notifications"
   							}
   				     }, 
   			         style: { 	name: 'light', 
   				         		width: 320, 
   				         		border: { width: 2, radius: 5, color: 'black' },
   				         		title: { 'font-size': 20, 'text-align': 'center' } 
   			         		}, 
   			         show: { when: { event: 'click' }, effect: 'slide' },
   					 hide: { when: { event: 'unfocus' }, effect: 'slide'},
   					 position: {
   			             corner: {
   			                  target: 'bottomLeft' // ...and opposite corner
   			             }
   			         }/*,
   			      	 api: 
   	   			     {
   			      	     beforeShow :function() 
   			         	 {
   			           		jQuery("#dvNotification").html("Notifications");
   			        	 },
   			        	 onHide: function() 
   			      		 {
   			        		var qtipAPI = jQuery('.notification').qtip("api");
   	                        qtipAPI.updateContent("");

                      		jQuery.ajax({type:'POST',data: {type: "all"},
   						 		url:'${baseurl}/notification/dismissNotifications',
   						 		success:function(data,textStatus){qtipAPI.updateContent(data);},
   						 		error:function(XMLHttpRequest,textStatus,errorThrown){}});
   								//return false;
                         }
   			    	 }*/
   			    });


				jQuery("#dvChangeRole").click(function() 
				{
					
					jQuery( "#dvChangeRoleMenu" ).dialog( "option", "title", "Change Role");
					jQuery( "#dvChangeRoleMenu" ).dialog( "open" );
					var popupURL = '${baseurl}/service/userrolesection?role='+this.title;
					jQuery.ajax({type:'POST',
								 url:popupURL,
								 success:function(data,textStatus){
									 jQuery('#dvChangeRoleMenu').html(data);
								 },
								 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
				}); 
				jQuery( "#dvChangeRoleMenu" ).dialog(
				{
					height: 120,
					width: 350,
					modal: true,
					autoOpen: false,
					zIndex: 1999,
					position: [900, 50],
					
				});			    
			});
			
			//Temporary method to set timeout 10 seonds
			function setTempTime(){
				jQuery.post('${baseurl}/userSetup/setlogouttime', function(data){
						setAutomaticTimeout();
					}); 
			}

			//checking for new notification
			function isNewNotification()
			{
	   			jQuery.ajax(
	    	   	{
	   	    	   	type:'POST',data: {type: "all"},
				 	url:'${baseurl}/notification/countActiveNotification',
				 	success:function(data,textStatus)
				 	{
					 	if(isNumeric(data) && parseInt(data)>0)
					 	{
				 			jQuery("#dvNotification").html("Notifications <span class='headerNav-counter'>"+ parseInt(data) +"</span>");
						}
				 		else
					 	{
						 	jQuery("#dvNotification").html("Notifications");
					 	}
					 	
				 	},
				 	error:function(XMLHttpRequest,textStatus,errorThrown){}
			 	});
			 	//return false;
   			}
   			
			var timeout = 1800000

			function setAutomaticTimeout()
			{
				var myVar = setInterval(function(){isNewNotification()},60000);
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
        
      	<div id="dvChangeRoleMenu"></div>
      	
      	<script>
      	
       	  <g:if test="${flash.message != null && flash.message.length() > 0}">
       		  <g:if test="${flash.type != null && flash.type == 'error'}">
		       		jQuery(document).ready(function()
           			{
		       			jQuery().toastmessage('showErrorToast', "${flash.message.encodeAsHTML()}");
           			});
       		  </g:if>
       		  <g:else>

	       			jQuery(document).ready(function()
	       			{
	       				jQuery().toastmessage('showSuccessToast', "${flash.message.encodeAsHTML()}");
	       			});
       		    
       		  </g:else>
       			
       	  </g:if>
		      
		</script>
			<font color="#ffffff">
			
				<table id="header">
					<tr>
						<td>
						  	<a href="http://valent-software.com"><asset:image src="valentlogo.png" border="0" /></a>
						  	<p id="demo"></p>
						</td>
						<td align="right" width=35%>
							
								<div id="userops">
						      		<div class="headerNav-list">
						      			<div>
						      				<a href="#notifications" class="headerNav-link notification">
						      					<div id="dvNotification">
						      						Notifications 
							      					<!--<g:if test="${notificationList?.size() > 0}">
							      						<span class="headerNav-counter">${notificationList.size()}</span>
						      						</g:if>-->
					      						</div>
				      						</a>
			      						</div>
							        	
							        	<% 
											  Object obj = session.getAttribute(HomeController.DEFAULTUSERROLE);
											  if( obj == null ){
												obj = PricewellUtils.getFirstMatchingRoleEnum();
											  }
										  
											  String role = "";
											  if( obj != null ){
												  role = obj.value();
											  }
			      						%>
							        	<div><span class="headerNav-link2"><sec:username/> <div id="dvChangeRole" style="float:right;" title="<%=role%>">(<%=role%> <asset:image src="edit-24.png" title="Change Role" width="12px" alt="Change Role"/>) </div></span></div>
							        	
							        	<div><g:link controller="auth" action="logout" class="headerNav-link"><g:message code="nimble.link.logout.basic" /></g:link></div>
							      	</div>
								</div>
							
						</td>
					</tr>
				</table>		
			</font>
			<g:render template="/layouts/new_navigation"/>
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
		<div id="throbber-overlay"></div>
		<div id="throbber-box">
			<div class="loader-content">
				<div id="loader-message">
					<img title="Please wait..." alt="Please wait..." src="${baseurl}/images/throbber.gif">
				</div>
			</div>
		</div>		
    </body>
</html>