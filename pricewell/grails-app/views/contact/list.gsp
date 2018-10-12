
<%@ page import="com.valent.pricewell.Contact" %>
<%@ page import="org.apache.shiro.SecurityUtils"%>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'contact.label', default: 'Contact')}" />
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
				window.location.href = '${baseurl}/contact';
				return false;
			}
			jQuery(document).ready(function()
			{
				jQuery('#contactList').dataTable({
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
            <!--span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span-->
            <span><g:link class="buttons.button button" title="Create Contact" action="create" ><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
        	<h2>Search Contact</h2>
            <g:render template="/contact/searchContactToolbar"/><hr>
            <h2><g:message code="default.list.label" args="[entityName]" /></h2>
            
            <!--<g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>-->
            
           <g:if test="${SecurityUtils.subject.hasRole('SALES PERSON') && !isSearchList}">
						
				<div id="tabsDiv">
					<ul>
							<li><a href="#tbAssigned">Assigned Contacts</a></li>
							
							<li><a href="#tbUnassigned">Unassigned Contacts</a></li>
					</ul>
				
				
					<div id="tbAssigned" label="Assigned Contacts">
						
							<g:render template="/contact/list" model="['contactInstanceList': contactInstanceList, 'contactInstanceTotal': contactInstanceTotal, 'tblName': 'contactList']"/>
					
					</div>
		
					<div id="tbUnassigned" label="Unassigned Contacts" >
						
							<g:render template="/contact/list" model="['contactInstanceList': unAssignedList, 'contactInstanceTotal': unAssignedList.size(), 'tblName': 'unAssignedList']"/>
						
					</div>
					
				</div>
			</g:if>
			<g:else>
				<g:render template="/contact/list" model="['contactInstanceList': contactInstanceList, 'contactInstanceTotal': contactInstanceTotal, 'tblName': 'contactList']"/>
			</g:else>
            
        </div>
    </body>
</html>
