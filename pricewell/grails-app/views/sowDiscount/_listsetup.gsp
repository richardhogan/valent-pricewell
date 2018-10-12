
<%@ page import="com.valent.pricewell.SowDiscount" %>
<%
	def baseurl = request.siteUrl
%>

<!doctype html>
<html>
	<head>
		<g:set var="entityName" value="${message(code: 'sowDiscount.label', default: 'SowDiscount')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
		
		<style>
			h1, button, #successDialogInfo
			{
				font-family:Georgia, Times, serif; font-size:15px; font-weight: bold;
			}
			button{
				cursor:pointer;
			}
		</style>
	
		<script>
	
			function refreshGeoGroupList()
			{
				refreshNavigation();
				jQuery.ajax({
					type: "POST",
					url: "${baseurl}/sowDiscount/listsetup",
					data: {source: 'firstsetup'},
					success: function(data){
						jQuery('#contents').html(data);
					}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){}
				});
			}
			
			var ajaxList = new AjaxPricewellList("Sow Discount", "SowDiscount", "${baseurl}", "setup", 700, 800, "${true}", "${true}", "${true}", "${true}");
			
			jQuery(document).ready(function()
			{
				ajaxList.init();
			});
		</script>
	</head>
	<body>
		<div class=" body">
			
			<h1> ${sowDiscountInstanceTotal} SOW Discounts defined &nbsp; &nbsp;
            	<g:if test="${true == true}">
            		<span><button id="createSowDiscount"> Add Discount </button></span>
           		</g:if>
			</h1><hr />
			
			<div class="list">
				<table cellpadding="0" cellspacing="0" border="0" class="display" id="sowDiscountsList">
					<thead>
						<tr>
						
							<th>${message(code: 'sowDiscount.description.label', default: 'Description')}</th>
						
							<th>${message(code: 'sowDiscount.amount.label', default: 'Amount')}</th>
						
							<th>Territory</th>
							<%--<g:sortableColumn property="amountPercentage" title="${message(code: 'sowDiscount.amountPercentage.label', default: 'Amount Percentage')}" />
						
							<g:sortableColumn property="isGlobal" title="${message(code: 'sowDiscount.isGlobal.label', default: 'Is Global')}" />--%>
						
							<%--<g:if test="${source == 'firstsetup'}">--%>
								<g:if test="${true == true}"><th></th></g:if>
                            
                            	<g:if test="${true == true}"><th></th></g:if>
                           	<%--</g:if>--%>
						</tr>
					</thead>
					<tbody>
						<g:each in="${sowDiscountInstanceList}" status="i" var="sowDiscountInstance">
							<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
							
								<td><g:link action="show" id="${sowDiscountInstance.id}">${fieldValue(bean: sowDiscountInstance, field: "description")}</g:link></td>
							
								<td>${fieldValue(bean: sowDiscountInstance, field: "amount")}</td>
							
								<td>${sowDiscountInstance.territories.join('</br>')}</td>
								
								<%--<td>${fieldValue(bean: sowDiscountInstance, field: "amountPercentage")}</td>
							
								<td><g:formatBoolean boolean="${sowDiscountInstance.isGlobal}" /></td>--%>
							
								<%--<g:if test="${source == 'firstsetup'}">--%>
									<g:if test="${true == true}">
										<td> <a id="${sowDiscountInstance.id}" title="Edit SOW Discount" href="#" class="editSowDiscount hyperlink"> Edit </a></td>
									</g:if>
									<g:if test="${true == true}">
										<td> <a id="${sowDiscountInstance.id}" title="Delete SOW Discount" href="#" class="deleteSowDiscount hyperlink"> Delete </a></td>
									</g:if>
								<%--</g:if>--%>
								
							</tr>
						</g:each>
					</tbody>
				</table>
			</div>
			
		</div>
		
		<div id="sowDiscountDialog" title="">
			
		</div>
	</body>
</html>
