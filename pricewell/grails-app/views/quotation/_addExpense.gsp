<%
	def baseurl = request.siteUrl
%>
<script>

	jQuery(function() 
	{
		jQuery('#btnSaveExpense').click(function()
		{
			if(jQuery('#frmExpense').validate().form())
	        {
				showLoadingBox();
				jQuery.ajax({type:'POST',data:jQuery('#frmExpense').serialize(),
					 url:'${baseurl}/quotation/saveExpense',
					 success:function(data,textStatus)
					 {
						 	hideLoadingBox();
						 	jQuery('#dvQuote').html(data);
						 	jQuery( "#dvQutationServices" ).dialog( "close" );
						 	refreshForecastValue();
					 },
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false
        	}
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
                     <label for="expenseAmount"><g:message code="quotation.expenseAmount.label" default="Expense Amount" /></label><em>*</em>
                 </td>
                 <td valign="top" class="value ${hasErrors(bean: quotationInstance, field: 'expenseAmount', 'errors')}">
                     ${quotationInstance?.geo?.currencySymbol}
                     <g:textField name="expenseAmount" value="${quotationInstance?.expenseAmount}" class="required number" />
                     
                 </td>
             </tr>
             
            <tr class="prop">
                 <td valign="top" class="name">
                     <label for="description"><g:message code="quotation.description.label" default="Description" /></label>
                 </td>
                 <td valign="top" class="value ${hasErrors(bean: quotationInstance, field: 'description', 'errors')}">
                     <g:textArea name="description" value="${quotationInstance?.description}"  rows="5" columns="75" style="margin-left: 0px; margin-right: 0px; width: 648px;"/>
                     
                 </td>
             </tr>
		</tbody>
	</table>
	
	<input id="btnSaveExpense" title="Save Expenses" class="save" value="Save Expenses" type="button"/>
	
</g:form>
