<%
	def baseurl = request.siteUrl
%>

<script>
		
	jQuery(document).ready(function()
 	{
		jQuery("#btnClear").click(function()
		{	
			jQuery( "#dvResponseMessage" ).html("").hide();
			return false;
		});	
	});
	

</script>
		
<g:if test="${responseType == 'checkApiPermission' }">
	<br/>
	<h1>Check API Permissions Response</h1>
</g:if>

<g:each in="${responseList}" status="i" var="responseInstance">
		${i+1} ${responseInstance}<br>
</g:each>

<g:if test="${responseType == 'checkApiPermission' }">
	<div class="buttons">
        <span><button id="btnClear" title="Clear Response">Clear</button></span>
    </div>
</g:if>
