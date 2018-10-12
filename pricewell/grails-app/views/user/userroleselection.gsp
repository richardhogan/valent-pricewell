<%
	def baseurl = request.siteUrl
	String defaultRole = "";
	
%>

<script type="text/javascript">
<!--
jQuery(document).ready(function()
		{
			jQuery("#currentrole").val("<%=request.getParameter("role")%>");
			jQuery("#changeButton").click(function() 
			{
				jConfirm('Are you sure to change the role?', 'Please Confirm', function(r)
		  		{
				    if(r == true)
	   				{
		   				var currentRole = jQuery("#currentrole").val();
				    	window.location.href = 	"${baseurl}/home/changerole?role="+currentRole;
				    	return;
	   				}
				});;
			}); 
		});
//-->
</script>
<br />
<g:if test="${roles?.size() > 0}">
<div>
	<select id="currentrole" >
	    <g:each in="${roles}" status="i" var="role">
	    	<g:if test="${role.name != 'USER' }">
	    			<option>${role.name?.encodeAsHTML()}</option>
	     	</g:if>
	    </g:each>
    </select>
    <input type="button" value="Change Role" class="buttons.button darkbutton" id="changeButton"/>
</div>
</g:if>