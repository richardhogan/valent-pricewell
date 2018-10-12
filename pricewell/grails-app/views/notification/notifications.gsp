<%@ page import="grails.converters.JSON"%>
<%
	def baseurl = request.siteUrl
%>

	<style>
			
		
		.gridtable
		{
			max-height: 350px;
		}
		
		table.gridtable 
		{
			 border-width: 1px;
			 border-color: white;
			 border-collapse: collapse;
		}
		table.gridtable th 
		{
			 border-width: 1px;
			 padding: 8px;
			 border-style: solid;
			 border-color: white;
		}
		table.gridtable td 
		{
			 border-width: 1px;
			 padding: 8px;
			 border-style: solid;
			 border-color: white;
		}
		
		#notifications {
		   max-height: 480px;
		   overflow-x: auto;
		   overflow-y: auto;
		   border-width:1px; border-style:solid; border-color:white;
		   
		}
		
		.activeNotification {
			background-color: #d7d7d7;
		}
		
	</style>
	
	<script>
			 
		jQuery(document).ready(function()
		{
			jQuery( "#btnSelected" ).click(function() 
			{
				var selectedValues = "";
				jQuery('#chkNotification input:checked').each(function() 
				{
					selectedValues = selectedValues + jQuery(this).val() + " ";
					 
				});

				if(selectedValues != "")
				{
					jQuery.ajax({type:'POST',data: {'selectedNotifications': selectedValues, 'type': "selected"},
						 url:'${baseurl}/notification/dismissNotifications',
						 success:function(data,textStatus)
						 {
							 if(data == "success")
							 {
								 jQuery( "#successDismissNotiDialog" ).dialog( "open" );
							 }
							 else
							 {
								 jQuery( "#failureDismissNotiDialog" ).dialog( "open" );
							 }
						 },
						 error:function(XMLHttpRequest,textStatus,errorThrown){jQuery( "#failureDismissNotiDialog" ).dialog( "open" );}});
				}
				//alert(selectedValues);
				return false;
			});

			jQuery( "#btnAll" ).click(function() 
			{
				showThrobberBox();
				jQuery.ajax({type:'POST',data: {type: "all"},
					 url:'${baseurl}/notification/dismissNotifications',
					 success:function(data,textStatus)
					 {
						 hideThrobberBox();
						 if(data == "success")
						 {
							 jQuery( "#successDismissNotiDialog" ).dialog( "open" );
						 }
						 else
						 {
							 jQuery( "#failureDismissNotiDialog" ).dialog( "open" );
						 }
					 },
					 error:function(XMLHttpRequest,textStatus,errorThrown){hideThrobberBox();jQuery( "#failureDismissNotiDialog" ).dialog( "open" );}});
				return false;
			});

			jQuery( "#successDismissNotiDialog" ).dialog(
		 	{
				modal: true,
				autoOpen: false,
				resizable: false,
				buttons: {
					OK: function() {
						jQuery( "#successDismissNotiDialog" ).dialog( "close" );
						return false;
					}
				},
			 	close: function( event, ui ) {
			 		location.reload();
				}
			});
					
			jQuery( "#failureDismissNotiDialog" ).dialog(
			{
				modal: true,
				autoOpen: false,
				resizable: false,
				buttons: {
					OK: function() {
						jQuery( "#failureDismissNotiDialog" ).dialog( "close" );
						location.reload();
						return false;
					}
				},
				close: function( event, ui ) {
					location.reload();
				}
			});
		});
		
	</script>
	
	<div style="max-height: 500px;">
	
		<div id="successDismissNotiDialog" title="Success">
			<p>Notifications successfully dismissed.</p>
		</div>

		<div id="failureDismissNotiDialog" title="Failure">
			<p>Failed to dismiss notifications.</p>
		</div>
			
		<div id="notifications">
			<g:if test="${notificationList?.size() > 0 }">
				<table class="gridtable" id="chkNotification">
					
					<g:each in="${notificationList}" status="i" var="notificationInstance">
				        <tr>
				        	<td>
				        		<g:if test="${notificationInstance?.active == true || notificationInstance?.active == 'true' }">
				        			<input id="chkNotification_${notificationInstance?.id}" type="checkbox" value="${notificationInstance?.id}" name="chkNotification${notificationInstance?.id}" />
				        		</g:if>
			        		</td>
				        	<g:if test="${notificationInstance?.active == true || notificationInstance?.active == 'true' }"><td class="activeNotification"></g:if>
				        	
				        	<g:else><td></g:else>
				        	
				        		 <g:if test="${fieldValue(bean: notificationInstance, field: 'objectType')=='Portfolio'}"> 
				            	 	${fieldValue(bean: notificationInstance, field: "message")}<br/><g:link controller="portfolio" action="show" params="[id: notificationInstance?.objectId, notificationId: notificationInstance?.id]" class="hyperlink" style="color: blue;">  Link to Portfolio </g:link>
				            	 </g:if>
				            	 <g:elseif test="${fieldValue(bean: notificationInstance, field: 'objectType')=='Quotation'}">
				            	 	${fieldValue(bean: notificationInstance, field: "message")}<br/><g:link controller="quotation" action="show" params="[id: notificationInstance?.objectId, notificationId: notificationInstance?.id]" class="hyperlink" style="color: blue;">  Link to Quotation </g:link>
				            	 </g:elseif>
				            	 <g:elseif test="${fieldValue(bean: notificationInstance, field: 'objectType')=='GEO'}">
				            	 	${fieldValue(bean: notificationInstance, field: "message")}<br/><g:link controller="geoGroup" action="show" params="[id: notificationInstance?.objectId, notificationId: notificationInstance?.id]" class="hyperlink" style="color: blue;">  Link to GEO </g:link>
				            	 </g:elseif>
				            	 <g:elseif test="${fieldValue(bean: notificationInstance, field: 'objectType')=='Territory'}">
				            	 	${fieldValue(bean: notificationInstance, field: "message")}<br/><g:link controller="geo" action="show" params="[id: notificationInstance?.objectId, notificationId: notificationInstance?.id]" class="hyperlink" style="color: blue;">  Link to Territory </g:link>
				            	 </g:elseif>
				            	 <g:elseif test="${fieldValue(bean: notificationInstance, field: 'objectType')=='Delivery Role'}">
				            	 	${fieldValue(bean: notificationInstance, field: "message")}<br/><g:link controller="deliveryRole" action="show" params="[id: notificationInstance?.objectId, notificationId: notificationInstance?.id]" class="hyperlink" style="color: blue;">  Link to Delivery Role </g:link>
				            	 </g:elseif>
				            	 <g:elseif test="${notificationInstance.objectType == 'ServiceProfile' }">
				            	 	${fieldValue(bean: notificationInstance, field: "message")}<br/>
				            	 	<g:if test="${fieldValue(bean: notificationInstance, field: 'comment') }">
				            	 		<b>Comment : </b>${fieldValue(bean: notificationInstance, field: "comment")}<br>
				            	 	</g:if>
				            	 	<g:link controller="service" action="show" params="[serviceProfileId: notificationInstance?.objectId, notificationId: notificationInstance?.id]" class="hyperlink" style="color: blue;"> Link to Service </g:link>
				            	 </g:elseif>
				            	 <g:else>
				            	 	${fieldValue(bean: notificationInstance, field: "message")}<br/>
				            	 	<g:if test="${notificationInstance.objectType == 'Account'}">
				            	 		<g:link controller="account" action="show" params="[id: notificationInstance?.objectId, notificationId: notificationInstance?.id]" class="hyperlink" style="color: blue;"> Link to Account </g:link>
				            	 	</g:if>
				            	 	<g:elseif test="${notificationInstance.objectType == 'Lead'}">
				            	 		<g:link controller="lead" action="show" params="[id: notificationInstance?.objectId, notificationId: notificationInstance?.id]" class="hyperlink" style="color: blue;"> Link to Lead </g:link>
				            	 	</g:elseif>
				            	 	<g:elseif test="${notificationInstance.objectType == 'Contact'}">
				            	 		<g:link controller="contact" action="show" params="[id: notificationInstance?.objectId, notificationId: notificationInstance?.id]" class="hyperlink" style="color: blue;"> Link to Contact </g:link>
				            	 	</g:elseif>
				            	 	<g:elseif test="${notificationInstance.objectType == 'Opportunity'}">
				            	 		<g:link controller="opportunity" action="show" params="[id: notificationInstance?.objectId, notificationId: notificationInstance?.id]" class="hyperlink" style="color: blue;"> Link to Opportunity </g:link>
				            	 	</g:elseif>
				            	 	<g:elseif test="${notificationInstance.objectType == 'Quota'}">
				            	 		<g:link controller="quota" action="show" params="[id: notificationInstance?.objectId, notificationId: notificationInstance?.id]" class="hyperlink" style="color: blue;"> Link to Quota </g:link>
				            	 	</g:elseif>
				            	 </g:else>
				        	</td>
				        			            	 
				        </tr>
				     </g:each>
					
				</table>
			</g:if>
			<g:else>
				<p>There is no new notification.</p>
			</g:else>
		</div>
	</div>
	
	<g:if test="${isActiveAvailable}">
		<div>
			<b>Dismiss</b> 
			<button id="btnSelected" title="Dismiss Selected Notifications">Selected</button>
			<button id="btnAll" title="Dismiss All Notifications">All</button>
		</div>
	</g:if>	