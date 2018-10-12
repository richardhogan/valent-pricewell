<%
	def baseurl = request.siteUrl
%>
<script src="${baseurl}/js/jquery.validate.js"></script>
<script>
	 (function($) {
		  $(document).ready(function()
		  {				 
		    $("#opportunitySearch").validate();
		  });
		  
		  
	 })(jQuery);
</script>

<g:form action="search" method="POST" name="opportunitySearch">
	<g:hiddenField name="listType" value="${listType}" />
	<table>
		<tr>
			<td>
				 <label>Opportunity Name</label>
			</td>
			<td>
				 <g:textField name="searchFields.name" value="${searchFields?.name}" />
			</td>
			
			<td>&nbsp;&nbsp;</td>
			
			<td>
				 <label>Account Name</label>
			</td>
			<td>
				 <g:select name="searchFields.accountId" from="${accountList?.sort {it.accountName}}" value="${searchFields?.accountId}" optionKey="id" optionValue="accountName" noSelection="['': 'Select Any One']" />
			</td>
				
			<td cospan="2">	 
		
			 	<span class="button"><g:submitButton name="search" class="search" title="Search Opportunity" controller="opportunity" action="search" 
			 				value="Search"/></span>
			</td>
		</tr>
	</table>
 </g:form>