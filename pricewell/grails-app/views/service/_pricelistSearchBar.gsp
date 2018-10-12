<g:form action="pricelist" method="POST">
	<table>
	<g:if test="${false}">
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
			
		</tr>
	</g:if>
	<tr>
		<td>
			<label> Portfolio </label>
		</td>
		<td>
			<g:select name="searchFields.portfolio.id" from="${com.valent.pricewell.Portfolio.list()}" optionKey="id"  
			 				noSelection="${['all':'All']}" value="${searchFields?.portfolio?.id}" />
		</td>
		
		<td>
			<label> Select GEO </label>
		</td>
		<td>
		  <g:select name="geoId" from="${com.valent.pricewell.Geo.list()}" optionKey="id" value="${geoInstance?.id}"  />
		</td>
		
		<td cospan="2">	 
		
		 	<span class="button">
		 			<input type="button" title="Show Pricelist" value="Show Pricelist" onclick="call();"/>
		 			<g:submitButton name="search" title="Search Pricelist" class="search" controller="service" action="refreshPricelist" value="Refresh catalog"/>
		 			
		 	</span>
		 	
		</td>
		
	</tr>
	</table>
 </g:form>