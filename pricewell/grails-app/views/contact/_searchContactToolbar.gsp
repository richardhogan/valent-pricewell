<%
	def baseurl = request.siteUrl
%>
<script src="${baseurl }/js/jquery.validate.js"></script>
<script>
	 (function($) {
		  $(document).ready(function()
		  {				 
		    $("#contactSearch").validate();
		  });
		  
		  
	 })(jQuery);
</script>

<g:form action="search" method="POST" name="contactSearch">
	<table>
		<tr>
			<td>
				 <label>Firstname</label>
			</td>
			<td>
				 <g:textField name="searchFields.firstname" value="${searchFields?.firstname}" />
			</td>
			
			<td>&nbsp;&nbsp;</td>
			
			<td>
				 <label>Lastname</label>
			</td>
			<td>
				 <g:textField name="searchFields.lastname" value="${searchFields?.lastname}" />
			</td>
			
			<td>&nbsp;&nbsp;</td>
			
			<td>
				<label>E-mail</label>
			</td>
			<td>
			 	<g:textField name="searchFields.email" value="${searchFields?.email}" class="email"/>
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
		
			 	<span class="button"><g:submitButton name="search" class="search" controller="contact" action="search" title="Search Contact"
			 				value="Search"/></span>
			</td>
		</tr>
	</table>
 </g:form>