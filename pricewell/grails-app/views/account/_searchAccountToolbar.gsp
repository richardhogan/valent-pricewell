<%
	def baseurl = request.siteurl
%>
<g:setProvider library="prototype"/>
<script>
	 (function($) {
		  $(document).ready(function()
		  {				 
		    $("#accountSearch").validate();
		  });
		  
		  
	 })(jQuery);
</script>

<g:form action="search" method="POST" name="accountSearch">
	<table>
		<tr>
			<td>
				 <label>Account Name</label>
			</td>
			<td>
				 <g:textField name="searchFields.accountName" value="${searchFields?.accountName}" />
			</td>
			
			<td>&nbsp;&nbsp;</td>
			
			<td>
				<label>Website</label>
			</td>
			<td>
			 	<g:textField name="searchFields.website" value="${searchFields?.website}" class="url"/>
			</td>
			
			<td>&nbsp;&nbsp;</td>
			
			<td>
				 <label>Phone</label>
			</td>
			
			<td>
				<g:textField name="searchFields.phone" value="${searchFields?.phone}" number="true"/>			
			</td>
			
			<td>&nbsp;&nbsp;</td>
			
			<td cospan="2">	 
		
			 	<span class="button"><g:submitButton name="search" class="search" title="Search Account" controller="account" action="search" 
			 				value="Search"/></span>
			</td>
		</tr>
	</table>
 </g:form>