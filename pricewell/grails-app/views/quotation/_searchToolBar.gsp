<g:form action="search" method="POST">

<input type="hidden" name="mode" value="sales" />

	<table>
	<tr>
		<td>
			 <label>SKU</label>
		</td>
		<td>
			 <g:textField name="searchFields.skuName" value="${searchFields?.skuName}" />
		</td>
		<td>
			<label>Tags</label>
		</td>
		<td>
		 	<g:textField name="searchFields.tags" value="${searchFields?.tags}" />
		</td>
		<td>
			 <label>Service Name</label>
		</td>
		
		<td>
			<g:textField name="searchFields.serviceName" value="${searchFields?.serviceName}" />			
		</td>
		
	
		<td>
			<label> Portfolio </label>
		</td>
		<td>
			<g:select name="searchFields.portfolio.id" from="${com.valent.pricewell.Portfolio.list()}" optionKey="id"  
			 				noSelection="${['all':'All']}" value="${searchFields?.portfolio?.id}" />
		</td>		
		<td cospan="3">	 
		 	<span class="button"><g:submitToRemote name="search" class="search" controller="service" action="search" 
		 				title="Search Quote" value="Search" update="dvSearchServices"/></span>
		</td>
		
	</tr>
	</table>
 </g:form>