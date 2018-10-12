<%
	def baseurl = request.siteUrl
%>

<style type="text/css" title="currentStyle">
	@import "${baseurl}/js/dataTables/css/demo_page.css";
	@import "${baseurl}/js/dataTables/css/demo_table.css";
</style>

	<style>
		.recentUserBox {
			-moz-border-radius: 15px;
			border-radius: 15px;
			border-style: solid;
    		border-width: medium;
    		height: 300px;
    		width: 500px;
    		padding: 5px 5px 5px 5px;
		}
		
	</style>
	
<script type="text/javascript" language="javascript" src="${baseurl}/js/dataTables/js/jquery.dataTables.js"></script>
			
<script>
	jQuery(document).ready(function()
	{
		jQuery('#lastLoginList').dataTable({
			"sPaginationType": "full_numbers",
			"sDom": 't<"F"ip>',
			"aaSorting": [[ 1, "desc" ]],
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
		
<div class="body">   
	             
	<div class="list" style="height: 290px; padding: 2px; border-color: #666986; margin: 15px 10px 20px 13px; border-radius: 5px; border-style: solid;	border-width: medium;">
	    <table class="display">
	        <thead>
	            <tr>
	            
	                <th>User</th>
	                
	                <th>Last Login</th>
	            	
	            </tr>
	        </thead>
	        <tbody>
	         	<g:each in="${recentLoginList}" status="i" var="loginRecord">
	             	<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
             			<td>${loginRecord?.owner?.profile?.fullName}</td>
	                 	<td><g:formatDate format="MMMMM d, yyyy" date="${loginRecord?.dateCreated}" /></td> 	
	             	</tr>
	         	</g:each>
	        </tbody>
	    </table>
	</div>
</div>
	    
	    			
		
    

