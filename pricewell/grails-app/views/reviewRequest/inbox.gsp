<%@ page import="com.valent.pricewell.Notification"%>
<%@ page import="com.valent.pricewell.ReviewRequest"%>

<html>
	<head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:setProvider library="prototype"/>
        
        <g:set var="entityName" value="${message(code: 'reviewRequest.label', default: 'ReviewRequest')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    
    	<script type="text/javascript" src="../js/tiny_mce/tiny_mce.js"></script>
		
		<style>
		p {
			font-size: 1%;
			margin: 0 0 0em;
		}
		
		td.name {
			font-weight: bold;
			font-size: 85%
		}
		
		td.Value {
			font-weight: bold;
			font-size: 95%
		}
		
		td.reduced {
			font-size: 90%
		}
		
		</style>
		<script>
			jQuery(function() {
				jQuery( "#tabsDiv" ).tabs();
				jQuery('.blink').blink();
			});
			</script>
	</head>
	<body>
  	

		<div>
			
						
			<div id="inbox">
				
				<div id="tabsDiv" class="collapsibleContainerNew">
					<ul>
							<li><a href="#tbReviewBoard">Review Board</a></li>
							
							<!--<g:if test="${notificationPending.size() > 0}">
								<li><a href="#alerts" ><span class="blink">You Have ${notificationPending.size()} Pending <g:if test="${notificationPending.size()==1}">Task</g:if><g:else>Tasks</g:else></span></a></li>
							</g:if>-->
				
							<li><a href="#tbNotification">Notifications</a></li>
					</ul>
				
				
						<div id="tbReviewBoard" label="Review Board">
							<div id="mainReviewBoardTab">
								<g:render template="list" model="['reviewRequestInstanceList': reviewRequestInstanceList, 'reviewRequestInstanceTotal': reviewRequestInstanceTotal, 'title': title]"> </g:render>
							</div>
						</div>
			
						<div id="tbNotification" label="Notification" 
							active="${selectedTab=='notifications'}">
							<div id="mainNotificationTab">
								<g:render template="/notification/list" model="['notificationInstanceList': notificationInstanceList, 'notificationInstanceTotal': notificationInstanceTotal]"> </g:render>
							</div>
						</div>
					
				</div>
			</div>
			
		</div>
	
	</body>
</html>
