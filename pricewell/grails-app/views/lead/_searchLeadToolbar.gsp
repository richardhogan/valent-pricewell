<%
	def baseurl = request.siteUrl
%>
<script src="${baseurl}/js/jquery.validate.js"></script>
<script>
	 (function($) {
		  $(document).ready(function()
		  {				 
		    $("#leadSearch").validate();
		  });
		  
		  
	 })(jQuery);
</script>

<g:form action="search" method="POST" name="leadSearch">
	<table>
		<tr>
			<td>
				 <label>Firstname</label>
			</td>
			<td>
				 <g:textField name="searchFields.firstname" value="${searchFields?.firstname}" />
			</td>
			
			<td>&nbsp;</td>
			
			<td>
				 <label>Lastname</label>
			</td>
			<td>
				 <g:textField name="searchFields.lastname" value="${searchFields?.lastname}" />
			</td>
			
			<td>&nbsp;</td>
			
			<td>
				<label>E-mail</label>
			</td>
			<td>
			 	<g:textField name="searchFields.email" value="${searchFields?.email}" class="email"/>
			</td>
			
			<td>&nbsp;</td>
			
			<td>
				 <label>Phone</label>
			</td>
			
			<td>
				<g:textField name="searchFields.phone" value="${searchFields?.phone}" number="true"/>			
			</td>
			
			<td>&nbsp;</td>
			
			<td>
				 <label>Days older</label>
			</td>
			<td>&nbsp;</td>
			<td>
				<select name="searchFields.daysPending" id="searchFields.daysPending">
				  <option value="0" ${searchFields?.daysPending == '0'? 'SELECTED': ''}>All</option>
				  <option value="-10" ${searchFields?.daysPending == '-10'? 'SELECTED': ''}>Less than 10 days</option>
				  <option value="-20" ${searchFields?.daysPending == '-20'? 'SELECTED': ''}>Less than 20 days</option>
				  <option value="-30" ${searchFields?.daysPending == '-30'? 'SELECTED': ''}>Less than 30 days</option>
				  <option value="-40" ${searchFields?.daysPending == '-40'? 'SELECTED': ''}>Less than 40 days</option>
				  <option value="-50" ${searchFields?.daysPending == '-50'? 'SELECTED': ''}>Less than 50 days</option>
				  <option value="-60" ${searchFields?.daysPending == '-60'? 'SELECTED': ''}>Less than 60 days</option>
				  <option value="60" ${searchFields?.daysPending == '60'? 'SELECTED': ''}>More than 60 days</option>
				</select>
			</td>
			
			
			<td cospan="2">	 
		
			 	<span class="button"><g:submitButton name="search" class="search" controller="lead" action="search" title="Search Lead"
			 				value="Search"/></span>
			</td>
		</tr>
	</table>
 </g:form>