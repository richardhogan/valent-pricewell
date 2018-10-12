
<%@ page import="com.valent.pricewell.Lead" %>
<%@ page import="org.apache.shiro.SecurityUtils"%>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'lead.label', default: 'Lead')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
        <style type="text/css" title="currentStyle">
			@import "${baseurl}/js/dataTables/css/demo_page.css";
			@import "${baseurl}/js/dataTables/css/demo_table.css";
		</style>
			
		<script type="text/javascript" language="javascript" src="${baseurl}/js/dataTables/js/jquery.dataTables.js"></script>
        <script type="text/javascript"> 
        	jQuery.noConflict();
		</script>
		
        <modalbox:modalIncludes />
		<script>
			function changeUrl()
			{
				window.location.href = '${baseurl}/lead';
				return false;
			}

			jQuery(document).ready(function()
			{
				jQuery('#leadList').dataTable({
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
				
				jQuery( ".helpBtn" ).click(function() 
				{
					jQuery("#helpDialog").dialog("open");
					return false;
				});
				jQuery( "#helpDialog" ).dialog(
				{
					modal: true,
					autoOpen: false,
					height: 500,
					width: 1000
				});
				
			});
		</script>
    </head>
    <body>
        <div class="nav">
            <!--span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span-->
            <span><g:link class="create" title="Create Lead" action="create" class="buttons.button button"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div id="helpDialog" title="Leads">
			
		</div>
        <div class="body">
        	
            
            
            <div class="leftNavSmall">
	       		<g:render template="leadNavigation"/>		 		
	    	</div>
			
            <div class="body rightContent column">
            
            	
            
            	<h2>Search Lead</h2>
            	<g:render template="/lead/searchLeadToolbar"/><hr>
            	<!--<button id="helpBtn" class="helpBtn buttons.button button" title="Leads">Leads</button>-->
            	<div class="list">
					<h2>${title}</h2>
					
					<g:if test="${SecurityUtils.subject.hasRole('SALES PERSON')&& title == 'Pending Leads'}">
						
						<div id="tabsDiv">
							<ul>
									<li><a href="#tbAssigned">Assigned Leads</a></li>
									
									<li><a href="#tbUnassigned">Unassigned Leads</a></li>
							</ul>
						
						
							<div id="tbAssigned" label="Assigned Leads">
								
									<g:render template="/lead/list" model="['leadInstanceList': leadInstanceList, 'leadInstanceTotal': leadInstanceTotal, 'tblName': 'leadList']"/>
							
							</div>
				
							<div id="tbUnassigned" label="Unassigned Leads" >
								
									<g:render template="/lead/list" model="['leadInstanceList': unAssignedList, 'leadInstanceTotal': unAssignedList.size(), 'tblName': 'unAssignedList']"/>
								
							</div>
							
						</div>
					</g:if>
					<g:else>
						<g:render template="/lead/list" model="['leadInstanceList': leadInstanceList, 'leadInstanceTotal': leadInstanceTotal, 'tblName': 'leadList']"/>
					</g:else>
	            	
				</div>
            	
            	
            </div>
            
        </div>
    </body>
</html>
