<%@ page import="com.valent.pricewell.SowDiscount" %>

<table>
  <tr class="fieldcontain ${hasErrors(bean: sowDiscountInstance, field: 'description', 'error')} ">
    <td>
		<label for="description">
			<g:message code="sowDiscount.description.label" default="Description" /><em>*</em>
		</label>
	</td>
    <td>
		<g:field type="text" name="description" value="${fieldValue(bean: sowDiscountInstance, field: 'description')}" class="required"/>
	</td>
  </tr>
  
  <tr>
    <td>
		<label for="territory">
			<g:message code="sowDiscount.territories.label" default="Territory" /><em>*</em>
		</label>
	</td>
    <td>
		<g:select name="territoryId" from="${com.valent.pricewell.Geo.list()?.sort{it.name}}" optionKey="id" optionValue="name" value="" noSelection="${['':'Select One...']}" class="required"/>
	</td>
  </tr>
  
  <tr>
    <td>
		<label for="amount">
			<g:message code="sowDiscount.amount.label" default="Amount" /><em>*</em>
		</label>
	</td>
    <td>
    	<table>
       		<tr>
       			<td><div id="currencySymbol"></div></td>
       			<td><g:field type="text" name="amount" value="${fieldValue(bean: sowDiscountInstance, field: 'amount')}" class="required number"/></td>
       		</tr>
       	</table>
    	
	</td>
  </tr>
 
</table>




<%--<div class="fieldcontain ${hasErrors(bean: sowDiscountInstance, field: 'amountPercentage', 'error')} ">
	<label for="amountPercentage">
		<g:message code="sowDiscount.amountPercentage.label" default="Amount Percentage" />
		
	</label>
	<g:field type="number" name="amountPercentage" value="${fieldValue(bean: sowDiscountInstance, field: 'amountPercentage')}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: sowDiscountInstance, field: 'isGlobal', 'error')} ">
	<label for="isGlobal">
		<g:message code="sowDiscount.isGlobal.label" default="Is Global" />
		
	</label>
	<g:checkBox name="isGlobal" value="${sowDiscountInstance?.isGlobal}" />
</div>--%>

<%--<div class="fieldcontain ${hasErrors(bean: sowDiscountInstance, field: 'quotations', 'error')} ">
	<label for="quotations">
		<g:message code="sowDiscount.quotations.label" default="Quotations" />
		
	</label>
	<g:select name="quotations" from="${com.valent.pricewell.Quotation.list()}" multiple="multiple" optionKey="id" size="5" value="${sowDiscountInstance?.quotations*.id}" class="many-to-many"/>
</div>--%>

