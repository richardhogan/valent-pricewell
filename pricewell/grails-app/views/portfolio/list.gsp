
<%@ page import="com.valent.pricewell.Portfolio" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'portfolio.label', default: 'Portfolio')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
        
        <style type="text/css" title="currentStyle">
			@import "${baseurl}/js/dataTables/css/demo_page.css";
			@import "${baseurl}/js/dataTables/css/demo_table.css";
		</style>
			
		<script type="text/javascript" language="javascript" src="${baseurl}/js/dataTables/js/jquery.dataTables.js"></script>
		
		<script>
			jQuery(document).ready(function()
			{
				jQuery('#portfolioList').dataTable({
					"sPaginationType": "full_numbers",
					"sDom": '<"H"f>t<"F"ip>',
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
			});
		</script>
    </head>
    <body>
        <div class="nav">
     		<g:if test="${createPermit}">
            	<span><g:link class="create" action="create" title="Create Portfolio" class="buttons.button button"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
           </g:if>
        </div>
        <div class="body">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            	<!--div class="message">${flash.message}</div-->
            </g:if>
            <div class="list">
                <table cellpadding="0" cellspacing="0" border="0" class="display"  id="portfolioList">
                    <thead>
                        <tr>
                        
                            <th>${message(code: 'portfolio.portfolioName.label', default: 'Name')} </th>
                        
                            <!-- <th>${message(code: 'portfolio.description.label', default: 'Description')}</th>-->
                        
                            <th>${message(code: 'portfolio.dateModified.label', default: 'Date Modified')}</th>
                        
                            <th>${message(code: 'portfolio.stagingStatus.label', default: 'Staging Status')}</th>
                        
                            <th><g:message code="portfolio.portfolioManager.label" default="Portfolio Manager" /></th>
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${portfolioInstanceList}" status="i" var="portfolioInstance">
                        <tr>
                        
                            <td><g:link action="show" title="Show Details" class="hyperlink" id="${portfolioInstance.id}">${fieldValue(bean: portfolioInstance, field: "portfolioName")}</g:link></td>
                        
                            <!-- <td>${fieldValue(bean: portfolioInstance, field: "description")}</td>-->
                        
                            <td><g:formatDate format="MMMMM d, yyyy" date="${portfolioInstance.dateModified}" /></td>
                        
                            <td>${(portfolioInstance.stagingStatus.toLowerCase() == "published"? "Active": "Closed")}</td>
                        
                            <td>${fieldValue(bean: portfolioInstance, field: "portfolioManager")}</td>
                        
                        	
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                
            </div>
        </div>
    </body>
</html>
