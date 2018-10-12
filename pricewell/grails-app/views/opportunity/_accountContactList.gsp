<%
	def baseurl = request.siteUrl
%>
<script>
	  jQuery(document).ready(function()
	  {
		  
	  });	
</script>

<g:select name="contactId" id="contactId" from="${contactList}" optionKey="id" class="required" noSelection="['': 'Select Any One']"/>
