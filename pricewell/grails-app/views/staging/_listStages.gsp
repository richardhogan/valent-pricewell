

<%@ page import="java.lang.String" %>
<%
	def baseurl = request.siteUrl
%>
<html>
	<g:setProvider library="prototype"/>
	
	<style>
		h1, button, #successDialogInfo
		{
			font-family:Georgia, Times, serif; font-size:15px; font-weight: bold;
		}
		button{
			cursor:pointer;
		}
		
		
	</style>
	
	
	<script>
	
		//var ajaxList = new AjaxPricewellList("User", "UserSetup", "${baseurl}", "setup", 600, 500, true, true, true, true);
		
		jQuery(document).ready(function()
		{
			//ajaxList.init();

			jQuery('#serviceSubStageList').dataTable({
				"sPaginationType": "full_numbers",
				"sDom": 't<"F"ip>',
				"aaSorting": [[ 3, "asc" ]],
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
			

			jQuery(".subStageEdit").click(function(){
				jQuery("#dvSubStage").html('Loading, please wait.....');
				jQuery.ajax({
					type: "POST",
					url: "${baseurl}/staging/editStageName",
					data: {id: this.id},
					success: function(data){
						jQuery("#dvSubStage").html(data);
					}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){}
				});
			});
			
			
		});
	</script>
    <body>
        <div class="body">
            
            <div class="leftNavSmall">      		
	    		<g:render template="../staging/nevigationsetup"/>
	    	</div>
            
            <div id="dvSubStage" class="body rightContent column">
            
            	<h1>${title}</h1><hr />
            	
                <table cellpadding="0" cellspacing="0" border="0" class="display" id="serviceSubStageList">
                    <thead>
                        <tr>
                        	<th> Stage Display Name </th>
                        	
                        	<th> Stage Name </th>
                        	
                            <th> Parent Stage </th>
                        
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${subStagesList?.sort {it.stagingId}}" status="i" var="subStage">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        	
                        	<td> ${subStage.displayName?.encodeAsHTML()} </td>
                        	
                        	<td> ${subStage.name?.encodeAsHTML()} </td>
                        	
                            <td> ${subStage.staging.displayName?.encodeAsHTML()} </td>
                            
                            <td> <a id="${subStage.id}" href="#" title="Edit" class="subStageEdit hyperlink "> Edit </a></td>
		             	</tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
        </div>
		
    </body>
</html>
