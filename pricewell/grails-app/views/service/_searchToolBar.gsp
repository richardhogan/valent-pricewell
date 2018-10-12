<g:form action="search" method="POST">
	<table>
	<tr>
		<td>
			 <label>SKU*</label>
		</td>
		<td>
			 <g:textField name="searchFields.skuName" value="${searchFields?.skuName}" />
		</td>
		<td>
			<label>Tags*</label>
		</td>
		<td>
		 	<g:textField name="searchFields.tags" value="${searchFields?.tags}" />
		</td>
		<td>
			 <label>Service Name*</label>
		</td>
		
		<td>
			<g:textField name="searchFields.serviceName" value="${searchFields?.serviceName}" />			
		</td>
		
	</tr>
	<tr>
		<td>
			<label>Portfolio*</label>
		</td>
		<td>
			<g:select name="searchFields.portfolio.id" from="${com.valent.pricewell.Portfolio.list()}" optionKey="id"  
			 				noSelection="${['all':'All']}" value="${searchFields?.portfolio?.id}" />
			 
		</td>
		<g:if test="${serviceMode == 'DEV' || serviceMode == 'REMOVE'}">
			<g:hiddenField name="searchFields.publishedFlag" value="${serviceMode}"/>
		</g:if>
		<g:else>
		<td>
			 <label>Publish status:</label>
		</td>
		<td>
			 <g:select name="searchFields.publishedFlag" from="${['Published Only', 'All']}" value="${searchFields?.publishedFlag}" />
		</td>
		</g:else>
		<td cospan="2">	 
		
		 	<span class="button"><g:submitButton title="Search Service" name="search" class="search" controller="service" action="search" 
		 				value="Search"/></span>
		</td>
		
	</tr>
	</table>
 </g:form>