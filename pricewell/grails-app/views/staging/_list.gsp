
<%@ page import="com.valent.pricewell.Staging" %>

<g:setProvider library="prototype"/>
		
		<script>
			jQuery(document).ready(function()
			{
				jQuery('#stagingList').dataTable({
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
		
        <g:set var="entityName" value="${message(code: 'staging.label', default: 'Staging')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    
    <div class="body">
        
	        <div class="nav">
	            <span><g:remoteLink class="buttons.button button" title="Create Stage" action="create" controller="staging" update="[success:'mainWorkflowSettingTab',failure:'mainWorkflowSettingTab']"><g:message code="default.new.label" args="[entityName]" /></g:remoteLink></span>
	        </div>
	        
	        <div class="leftNavSmall">      		
	    		<g:render template="../staging/nevigation"/>
	    	</div>
	        
	        <div class="body rightContent column">
	            <h1>${title}</h1><hr />
	            
	            <div class="list">
	                <table cellpadding="0" cellspacing="0" border="0" class="display" id="stagingList">
	                    <thead>
	                        <tr>
	                        
	                            <th>Order</th>
	                            
	                            <th>Display Name</th>
	                        	
	                            <th>Description</th>
	                        
	                        </tr>
	                    </thead>
	                    <tbody>
		                    <g:each in="${stagingInstanceList}" status="i" var="stagingInstance">
		                        <tr>
		                        
		                            <td>${fieldValue(bean: stagingInstance, field: "sequenceOrder")}</td>
		                            
		                            <td><g:remoteLink controller="staging" title="Show Stage" class="hyperlink" action="show" id="${stagingInstance.id}" update="[success:'mainWorkflowSettingTab',failure:'mainWorkflowSettingTab']"> ${fieldValue(bean: stagingInstance, field: "displayName")} </g:remoteLink></td>
		                            
		                            <td>${fieldValue(bean: stagingInstance, field: "description")}</td>
		                        
		                        </tr>
		                    </g:each>
	                    </tbody>
	                </table>
	            </div>
	            
	        </div>
	    
    </div>

