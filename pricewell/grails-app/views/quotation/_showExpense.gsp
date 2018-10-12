<%
	def baseurl = request.siteUrl
%>
<script>

	jQuery(function() 
	{
		jQuery('#btnEditExpense').click(function()
		{
			jQuery.ajax({type:'POST',data:jQuery('#frmExpense').serialize(),
				 url:'${baseurl}/quotation/addExpense',
				 success:function(data,textStatus){
					 	jQuery('#dvQutationServices').html(data);
				 },
				 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false
        	
		});

		jQuery('#btnDeleteExpense').click(function()
		{
			jQuery.ajax({type:'POST',data:jQuery('#frmExpense').serialize(),
				 url:'${baseurl}/quotation/deleteExpense',
				 success:function(data,textStatus){
					 	jQuery('#dvQuote').html(data);
					 	jQuery( "#dvQutationServices" ).dialog( "close" );
					 	refreshForecastValue();
				 },
				 error:function(XMLHttpRequest,textStatus,errorThrown){}});
				 return false;
        	
		});
	});

	
	
</script>


<g:form  name="frmExpense" url="[action:'saveExpense',controller:'quotation']">
	<g:hiddenField name="id" value="${quotationInstance?.id}" />
	<g:hiddenField name="source" value="fromOpportunity" />
	<table>
		
		<tbody>
			<tr class="prop">
                 <td valign="top" class="name">
                     <label for="expenseAmount"><g:message code="quotation.expenseAmount.label" default="Expense Amount : " /></label>
                 </td>
                 <td valign="top" class="value ${hasErrors(bean: quotationInstance, field: 'expenseAmount', 'errors')}">
                     ${quotationInstance?.geo?.currencySymbol}
                     ${quotationInstance?.expenseAmount}
                     
                 </td>
             </tr>
             
            <tr class="prop">
                 <td valign="top" class="name">
                     <label for="description"><g:message code="quotation.description.label" default="Description : " /></label>
                 </td>
                 <td valign="top" class="value ${hasErrors(bean: quotationInstance, field: 'description', 'errors')}">
                     ${quotationInstance?.description}
                 </td>
             </tr>
		</tbody>
	</table>
	
	<input id="btnEditExpense" class="save" title="Update Expense" value="Edit" type="button"/>
	<input id="btnDeleteExpense" class="save" title="Delete Expense" value="Delete" type="button"/>
</g:form>
