<%
	def baseurl = request.siteUrl
%>
<style type="text/css">
.searchForm td{
	padding-left: 1px;
}
</style>
<script>
	jQuery(function() {
		jQuery( "#datePublished" ).datepicker(
				{
					showOn: "button",
					buttonImage: "${baseurl}/images/calendar.gif",
					showWeek: true,
					firstDay: 1,
					buttonImageOnly: true
				});
	});
</script>
	<div class="dialog" id="mylist">
	 	<g:form action="searchCatalog" method="POST">
			<table class="searchForm" style="width:100%;border:2px">
				<tr>
					<td>
					 	<label>SKU</label>
					</td>
					<td>
					 	<g:textField name="searchFields.skuName" value="${searchFields?.skuName}" />
					</td>
					<!--  
					<td>
					 <label>Territories*</label>
					</td>
					<td>
					 <g:textField name="searchFields.territories" value="${searchFields?.territories}" />
					</td>
					-->
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
				<tr>
					<td>
						<label>Publish Date:</label>
					</td>						
                    <td valign="top">
                    			<g:textField id = "datePublished" value="${searchFields?.datePublished}" name="searchFields.datePublished" class="required"/>
                     </td>	
					<td>
						<label>Portfolio</label>
					</td>
					<td>
						<g:select name="searchFields.portfolio.id" from="${com.valent.pricewell.Portfolio.list()}" optionKey="id"  
							noSelection="${['all':'All']}" value="${searchFields?.portfolio?.id}" />
						<g:hiddenField name="searchFields.publishedFlag" value="${serviceMode}"/>
					</td>
					<td colspan="2">
					 	<span class="button">
					 		<g:submitButton title="Search Service" name="search" class="button" action="searchCatalog" controller="service"
							value="Search"/>
							</span>
					</td>		
				</tr>
			</table>
		</g:form>
	</div>