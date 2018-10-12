
<%@ page import="com.valent.pricewell.Account" %>
<%@ page import="org.apache.shiro.SecurityUtils"%>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'account.label', default: 'Account')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
        
        <g:setProvider library="prototype"/>
        
        <style type="text/css" title="currentStyle">
			@import "${baseurl}/js/dataTables/css/demo_page.css";
			@import "${baseurl}/js/dataTables/css/demo_table.css";
		</style>
			
		<script type="text/javascript" language="javascript" src="${baseurl}/js/dataTables/js/jquery.dataTables.js"></script>
		
        <script>
			jQuery(document).ready(function()
			{
				jQuery('#accountList').dataTable({
					"sPaginationType": "full_numbers",
					"sDom": 't<"F"ip>',
			        "bFilter": false,
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
				jQuery('#unAssignedList').dataTable({
					"sPaginationType": "full_numbers",
					"sDom": 't<"F"ip>',
			        "bFilter": false,
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
				jQuery( "#tabsDiv" ).tabs({ heightStyle: "content" });
			});
		</script>
    </head>
    <body>
        <div class="nav">
            
            <span><g:link action="create" title="Create Account" class="buttons.button button"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h2>Search Account</h2>
            <g:render template="/account/searchAccountToolbar"/><hr>
            <h2><g:message code="default.list.label" args="[entityName]" /></h2>
            <!--<g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>-->
            <g:if test="${SecurityUtils.subject.hasRole('SALES PERSON')}">
						
						<div id="tabsDiv">
							<ul>
									<li><a href="#tbAssigned">Assigned Accounts</a></li>
									
									<li><a href="#tbUnassigned">Unassigned Accounts</a></li>
							</ul>
						
						
							<div id="tbAssigned" label="Assigned Accounts">
								
									<g:render template="/account/list" model="['accountInstanceList': accountInstanceList, 'accountInstanceTotal': accountInstanceTotal, 'tblName': 'accountList']"/>
							
							</div>
				
							<div id="tbUnassigned" label="Unassigned Accounts" >
								
									<g:render template="/account/list" model="['accountInstanceList': unAssignedList, 'accountInstanceTotal': unAssignedList.size(), 'tblName': 'unAssignedList']"/>
								
							</div>
							
						</div>
					</g:if>
					<g:else>
						<g:render template="/account/list" model="['accountInstanceList': accountInstanceList, 'accountInstanceTotal': accountInstanceTotal, 'tblName': 'accountList']"/>
					</g:else>
        </div>
    </body>
</html>
