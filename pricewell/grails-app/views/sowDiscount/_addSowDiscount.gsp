<%
	def baseurl = request.siteUrl
%>

<script type="text/javascript">

	jQuery(document).ready(function()
	{
		jQuery("#addSowDiscountFrm").validate();
		
		jQuery("#discountId").change(function() 
    	{
			jQuery.ajax({type:'POST',data: {id: this.value },
				 url:'${baseurl}/sowDiscount/getDiscountAmount',
				 success:function(data,textStatus){jQuery('#amount').val(data);},
				 error:function(XMLHttpRequest,textStatus,errorThrown){}});
			 
			return false;
		  
		});

		jQuery("#addDiscountBtn").click(function()
		{
			if(jQuery("#addSowDiscountFrm").validate().form())
			{
				showLoadingBox();
				jQuery.ajax({
					type: "POST",
					url: "${baseurl}/quotation/addSowDiscount",
					data:jQuery("#addSowDiscountFrm").serialize(),
					success: function(data)
					{
						hideLoadingBox();
						/*if(data['key'] == "success"){
							refreshSowDiscounts(${quotationInstance?.id})
						}*/

						jQuery("#dvQutationServices").html(data);
					}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){
						hideLoadingBox();
						alert("Error while saving");
					}
				});
			}
			return false;
		}); 

		jQuery("#cancelBtn").click(function()
		{
			refreshSowDiscounts(${quotationInstance?.id});
			return false;
		}); 
	});

	function refreshSowDiscounts(quotationId)
	{
		showLoadingBox();
		jQuery.post( '${baseurl}/quotation/discount' , 
		  	{id: quotationId},
	      	function( data ) 
	      	{
			  	hideLoadingBox();
	          	jQuery('#dvQutationServices').html('').html(data);
	      	});							
		
		return false;
	}
</script>

<div class="list" style="width: 75%;">
	<g:form name="addSowDiscountFrm">
		<g:hiddenField name="quotationId" value="${quotationInstance?.id}"/>
		
		<table>
			<tr>
				<th>Global Discount</th>
				<th>Amount</th>
				<th></th>
				<th></th>
			</tr>
			
			<tr>
				<td>
					<g:select name="discountId" from="${discountsList?.sort{it.description}}" optionKey="id" optionValue="description" value="" noSelection="${['':'Select One...']}" class="required"/>
				</td>
				<td>
					<g:field type="text" name="amount" class="required number" readonly="true"/>
				</td>
				<td>
					<input id="addDiscountBtn" type="button" title="Add Discount To SOW" value="Add" class="button"/>
				</td>
				<td>
					<input id="cancelBtn" type="button" title="Cancel" value="Cancel" class="button"/>
				</td>
			</tr>
		</table>
	</g:form>
</div>