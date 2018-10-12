
<%@ page import="com.valent.pricewell.Notification" %>
<%
	def baseurl = request.siteUrl
%>
<g:set var="entityName" value="${message(code: 'notification.label', default: 'Notification')}" /> 
		<style type="text/css" title="currentStyle">
			@import "${baseurl}/js/dataTables/css/demo_page.css";
			@import "${baseurl}/js/dataTables/css/demo_table.css";
		</style>
			
		<script type="text/javascript" language="javascript" src="${baseurl}/js/dataTables/js/jquery.dataTables.js"></script>
			
	<script>
		jQuery(document).ready(function()
		{
			jQuery('#notificationList').dataTable({
				"sPaginationType": "full_numbers",
				"sDom": '<"H"f>t<"F"ip>',
		        "fnDrawCallback": function() {
	                if (Math.ceil((this.fnSettings().fnRecordsDisplay()) / this.fnSettings()._iDisplayLength) > 1)  {
	                        jQuery('.dataTables_paginate').css("display", "block"); 
	                        jQuery('.dataTables_length').css("display", "block");
	                } else {
	                		jQuery('.dataTables_paginate').css("display", "none");
	                		jQuery('.dataTables_length').css("display", "none");
	                }
	            }
			});
		});
	</script>   
    <body>
        
        <div class="body">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1><hr>
            
            <div class="list">
                <table cellpadding="0" cellspacing="0" border="0" class="display" id="notificationList">
                    <thead>
                        <tr>
                        	<th>No.</th>
                        	<th>Message</th>
                        	<th>Comment</th>
                        	<th>Object Type</th>
                        	<th>Date Created</th>
                        	<th>Active</th>
                        <!--    <g:sortableColumn property="message" title="${message(code: 'notification.message.label', default: 'Message')}" />
                        
                            <g:sortableColumn property="dateCreated" title="${message(code: 'notification.dateCreated.label', default: 'Date Created')}" />
                        
                            <g:sortableColumn property="objectType" title="${message(code: 'notification.objectType.label', default: 'Object Type')}" />
                        
                            <g:sortableColumn property="active" title="${message(code: 'notification.active.label', default: 'Active')}" />-->
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${notificationInstanceList}" status="i" var="notificationInstance">
                        <tr>
                        	<td>${i+1}</td>
                        	
                            <td>${fieldValue(bean: notificationInstance, field: "message")}</td>
                            
                            <td>${fieldValue(bean: notificationInstance, field: "comment")}</td>
                        
                            <td>${fieldValue(bean: notificationInstance, field: "objectType")}</td>
                            
                            <td><g:formatDate format="MMMMM d, yyyy" date="${notificationInstance.dateCreated}" /></td>
                        
                            <td><g:formatBoolean boolean="${notificationInstance.active}" /></td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
           
        </div>
    </body>

